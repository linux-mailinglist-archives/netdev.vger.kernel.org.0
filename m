Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F61B67BFA
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 23:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbfGMVGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 17:06:18 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.20]:29129 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727553AbfGMVGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 17:06:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1563051975;
        s=strato-dkim-0002; d=fami-braun.de;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=HnwoBd+26A/0HImKl2tAjnDE1msXwOU+1eBYq1RVV3g=;
        b=Ebn+aF+yq+EvGs7YmF+M2ZTUuF89EJGKB9NxKTgEuEDxvokY9Ey1oKu/krmut2/NSt
        T+vPnPwBmw0dzVnFSR/eDw5aEW5cEeAC1nMMnePAJWjUa4lnIRCn/4/+qk698cWVbeTF
        yIsYPw8pqL2GRoDqIURKCSsGC+G4WZTCGtaFCZar1z+yKjik2dRTLpG4A/UWp+hTdGSd
        nYj4QC3ORBpKhHBQOoc3dRc3B4OKwpgSr1a9GKMb9GPf+4KLUjU1YF/BWOgVidD3PkQc
        s/GjmIjOvCEJ5FC+wgdMpPEAic0+QybFwzs7bgg0it1Y4pEnT+TKSqFQp/PgEPDB/xmQ
        0phg==
X-RZG-AUTH: ":P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBEm4ljegySSvO7VhbcRIBGrxpcA5nVfJ6oTd1q4jmuxkBZDcOZJmhPeDaVIEbzatXpfJEm4ImQQ=="
X-RZG-CLASS-ID: mo00
Received: from dynamic.fami-braun.de
        by smtp.strato.de (RZmta 44.24 AUTH)
        with ESMTPSA id R034b8v6DL3Eu1L
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <netdev@vger.kernel.org>;
        Sat, 13 Jul 2019 23:03:14 +0200 (CEST)
Received: from dynamic.fami-braun.de (localhost [127.0.0.1])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTP id D4E5215409A
        for <netdev@vger.kernel.org>; Sat, 13 Jul 2019 23:03:13 +0200 (CEST)
Received: by dynamic.fami-braun.de (fami-braun.de, from userid 1001)
        id A321915822E; Sat, 13 Jul 2019 23:03:13 +0200 (CEST)
From:   michael-dev@fami-braun.de
To:     netdev@vger.kernel.org
Cc:     michael-dev@fami-braun.de
Subject: [PATCH] Fix dumping vlan rules
Date:   Sat, 13 Jul 2019 23:03:06 +0200
Message-Id: <20190713210306.30815-1-michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "M. Braun" <michael-dev@fami-braun.de>

Given the following bridge rules:
1. ip protocol icmp accept
2. ether type vlan vlan type ip ip protocol icmp accept

The are currently both dumped by "nft list ruleset" as
1. ip protocol icmp accept
2. ip protocol icmp accept

Though, the netlink code actually is different

bridge filter FORWARD 4
  [ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]
  [ immediate reg 0 accept ]

bridge filter FORWARD 5 4
  [ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000081 ]
  [ payload load 2b @ link header + 16 => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]
  [ immediate reg 0 accept ]

Fix this by avoiding the removal of all vlan statements
in the given example.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 src/payload.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/src/payload.c b/src/payload.c
index 3bf1ecc..905422a 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -506,6 +506,18 @@ static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
 		     dep->left->payload.desc == &proto_ip6) &&
 		    expr->payload.base == PROTO_BASE_TRANSPORT_HDR)
 			return false;
+		/* Do not kill
+		 *  ether type vlan and vlan type ip and ip protocol icmp
+		 * into
+		 *  ip protocol icmp
+		 * as this lacks ether type vlan.
+		 * More generally speaking, do not kill protocol type
+		 * for stacked protocols if we only have protcol type matches.
+		 */
+		if (dep->left->etype == EXPR_PAYLOAD && dep->op == OP_EQ &&
+		    expr->flags & EXPR_F_PROTOCOL &&
+		    expr->payload.base == dep->left->payload.base)
+			return false;
 		break;
 	}
 
-- 
2.20.1

