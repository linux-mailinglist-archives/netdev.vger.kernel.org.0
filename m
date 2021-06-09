Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F833A13AB
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 14:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbhFIMDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 08:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239732AbhFIMDZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 08:03:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39D7E61364;
        Wed,  9 Jun 2021 12:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623240090;
        bh=g5ty3hxdjO5FjEybn0HB13fUiQR/3e92xkT6TfbIV5w=;
        h=From:To:Cc:Subject:Date:From;
        b=MLVV33seVwpFermNLMROt07qJVOna7OiAOQ2fcPdliz3gn2GLozoLFsmMohFMOAgh
         QIWGeJBuNry4k1Kx+Zq1OxqGYWZFSCl9iTui6YEOvEZ+gF7/lrpZxHiJlfvXNYISjY
         W7qt6SzvF0sELlUWfkwPlNFo4oG0lUR5alzaeNGlVZsymNeoYABenwGh4BkgDL2L/7
         CiK3xzOOLLcFbIDXeIPYYMY69SXfBe6bkK9oMpRodMjLcbRDbTJTCNtxGlghy5g2ra
         laU0UrHYLt8CjdxpQUJx0wpQVsAE/0nsOKymYLMqrSuLVRNRBcjyFwzX71eHYBJlW5
         Qy3VnPu5SCrfQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        grygorii.strashko@ti.com, mcroce@linux.microsoft.com,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: [RFT net-next] net: ti: add pp skb recycling support
Date:   Wed,  9 Jun 2021 14:01:22 +0200
Message-Id: <ef808c4d8447ee8cf832821a985ba68939455461.1623239847.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As already done for mvneta and mvpp2, enable skb recycling for ti
ethernet drivers

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
This patch has just compile-tested
---
 drivers/net/ethernet/ti/cpsw.c     | 4 ++--
 drivers/net/ethernet/ti/cpsw_new.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index c0cd7de88316..049508667a6d 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -430,8 +430,8 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		cpts_rx_timestamp(cpsw->cpts, skb);
 	skb->protocol = eth_type_trans(skb, ndev);
 
-	/* unmap page as no netstack skb page recycling */
-	page_pool_release_page(pool, page);
+	/* mark skb for recycling */
+	skb_mark_for_recycle(skb, page, pool);
 	netif_receive_skb(skb);
 
 	ndev->stats.rx_bytes += len;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 69b7a4e0220a..11f536138495 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -373,8 +373,8 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		cpts_rx_timestamp(cpsw->cpts, skb);
 	skb->protocol = eth_type_trans(skb, ndev);
 
-	/* unmap page as no netstack skb page recycling */
-	page_pool_release_page(pool, page);
+	/* mark skb for recycling */
+	skb_mark_for_recycle(skb, page, pool);
 	netif_receive_skb(skb);
 
 	ndev->stats.rx_bytes += len;
-- 
2.31.1

