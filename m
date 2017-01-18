Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B00B3D673C
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 21:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbhGZSYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 14:24:07 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:54117 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbhGZSYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 14:24:06 -0400
Received: from h7.dl5rb.org.uk (p57907709.dip0.t-ipconnect.de [87.144.119.9])
        (Authenticated sender: ralf@linux-mips.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 0144E200005;
        Mon, 26 Jul 2021 19:04:32 +0000 (UTC)
Received: from h7.dl5rb.org.uk (localhost [127.0.0.1])
        by h7.dl5rb.org.uk (8.16.1/8.16.1) with ESMTPS id 16QJ4WZD836351
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 21:04:32 +0200
Received: (from ralf@localhost)
        by h7.dl5rb.org.uk (8.16.1/8.16.1/Submit) id 16QJ4WiK836350;
        Mon, 26 Jul 2021 21:04:32 +0200
Message-Id: <474560d79e822f58c7c728ee0aaf86113e8d5ffd.1627295848.git.ralf@linux-mips.org>
In-Reply-To: <cover.1627295848.git.ralf@linux-mips.org>
References: <cover.1627295848.git.ralf@linux-mips.org>
From:   Ralf Baechle <ralf@linux-mips.org>
Date:   Wed, 18 Jan 2017 23:08:21 +0100
Subject: [PATCH 2/6] AX.25: Print decoded addresses rather than hex numbers.
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-hams@vger.kernel.org
Lines:  31
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this, ip would have printed the AX.25 address configured for an
AX.25 interface's default addresses as:

  link/ax25 98:92:9c:aa:b0:40:02 brd a2:a6:a8:40:40:40:00

which is pretty unreadable.  With this commit ip will decode AX.25
addresses like

  link/ax25 LINUX-1 brd QST-0

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
 lib/ll_addr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/ll_addr.c b/lib/ll_addr.c
index 00b562ae..910e6daf 100644
--- a/lib/ll_addr.c
+++ b/lib/ll_addr.c
@@ -39,6 +39,8 @@ const char *ll_addr_n2a(const unsigned char *addr, int alen, int type,
 
 	if (alen == 16 && (type == ARPHRD_TUNNEL6 || type == ARPHRD_IP6GRE))
 		return inet_ntop(AF_INET6, addr, buf, blen);
+	if (alen == 7 && type == ARPHRD_AX25)
+		return ax25_ntop(AF_AX25, addr, buf, blen);
 
 	snprintf(buf, blen, "%02x", addr[0]);
 	for (i = 1, l = 2; i < alen && l < blen; i++, l += 3)
-- 
2.31.1


