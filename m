Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A193FB501
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 14:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236688AbhH3MA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 08:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236685AbhH3MAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 08:00:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EC5461155;
        Mon, 30 Aug 2021 11:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324800;
        bh=3JsOcYGw+1cT39hDwt/srPR/6CQ2MzTldkaBUDI+yZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0GtGruDsDDNb1b+K1yFZt/vouI9tdQys1xhBkkXXV5YbbwiX5/HNsRMayctXeYfZ
         9TCA5QFfIjlTIA0st87qPaUUIpZG9qYIv3lnl3kAQAWBZVtNOi7uck6/WXn++Za5dg
         QUjLb7EDgnKeg+cVvHDnmGCPCMBKQE7WdcuLa6GaBF8LahWR4l4+82xlpy0ubCeuKV
         eHz95mL4izxE9HC1kMbC3/6Hk2vcrFomHyQbpPtb6KeJkSjc7TcMeWtAMesUDP4gzA
         fHuuBimDfPl8UA4MD3Qci+5qiketMViX54tezB1AmFlUHuStN9gFUamiUYilgDC8ou
         63dawCWvWHMxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=E7=8E=8B=E8=B4=87?= <yun.wang@linux.alibaba.com>,
        Abaci <abaci@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 13/14] net: fix NULL pointer reference in cipso_v4_doi_free
Date:   Mon, 30 Aug 2021 07:59:41 -0400
Message-Id: <20210830115942.1017300-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830115942.1017300-1-sashal@kernel.org>
References: <20210830115942.1017300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: 王贇 <yun.wang@linux.alibaba.com>

[ Upstream commit 733c99ee8be9a1410287cdbb943887365e83b2d6 ]

In netlbl_cipsov4_add_std() when 'doi_def->map.std' alloc
failed, we sometime observe panic:

  BUG: kernel NULL pointer dereference, address:
  ...
  RIP: 0010:cipso_v4_doi_free+0x3a/0x80
  ...
  Call Trace:
   netlbl_cipsov4_add_std+0xf4/0x8c0
   netlbl_cipsov4_add+0x13f/0x1b0
   genl_family_rcv_msg_doit.isra.15+0x132/0x170
   genl_rcv_msg+0x125/0x240

This is because in cipso_v4_doi_free() there is no check
on 'doi_def->map.std' when 'doi_def->type' equal 1, which
is possibe, since netlbl_cipsov4_add_std() haven't initialize
it before alloc 'doi_def->map.std'.

This patch just add the check to prevent panic happen for similar
cases.

Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/cipso_ipv4.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index e0480c6cebaa..16bbd62db791 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -466,14 +466,16 @@ void cipso_v4_doi_free(struct cipso_v4_doi *doi_def)
 	if (!doi_def)
 		return;
 
-	switch (doi_def->type) {
-	case CIPSO_V4_MAP_TRANS:
-		kfree(doi_def->map.std->lvl.cipso);
-		kfree(doi_def->map.std->lvl.local);
-		kfree(doi_def->map.std->cat.cipso);
-		kfree(doi_def->map.std->cat.local);
-		kfree(doi_def->map.std);
-		break;
+	if (doi_def->map.std) {
+		switch (doi_def->type) {
+		case CIPSO_V4_MAP_TRANS:
+			kfree(doi_def->map.std->lvl.cipso);
+			kfree(doi_def->map.std->lvl.local);
+			kfree(doi_def->map.std->cat.cipso);
+			kfree(doi_def->map.std->cat.local);
+			kfree(doi_def->map.std);
+			break;
+		}
 	}
 	kfree(doi_def);
 }
-- 
2.30.2

