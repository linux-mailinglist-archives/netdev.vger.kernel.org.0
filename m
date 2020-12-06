Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3242D2D0558
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 14:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgLFNxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 08:53:49 -0500
Received: from mail-m971.mail.163.com ([123.126.97.1]:40282 "EHLO
        mail-m971.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgLFNxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 08:53:48 -0500
X-Greylist: delayed 986 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Dec 2020 08:53:43 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=uDWX3GQBDhMg1X3HJI
        Olbdz5D5Bs5i6dSzmMCE8ONSg=; b=K+gPg3B3pRR6j6XbXreaMY8IP5w7ZZ1kql
        S5Rup4WT0ANHJJEQQDnUpmZJWnZ9AryRFNYSPzKvFS7uAt4cJ0GlVtZ8j5qU6Csz
        GblrE/FJvH5NgL9LMH4wCDvS/ilr+1sZ70m/IACkUMHGOZROUgkSnU9ovV0ubL98
        6OQbOwW2Q=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp1 (Coremail) with SMTP id GdxpCgBXNkEu3sxfE1UBAQ--.322S4;
        Sun, 06 Dec 2020 21:35:45 +0800 (CST)
From:   Xiaohui Zhang <ruc_zhangxiaohui@163.com>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] ionic: fix array overflow on receiving too many fragments for a packet
Date:   Sun,  6 Dec 2020 21:35:37 +0800
Message-Id: <20201206133537.30135-1-ruc_zhangxiaohui@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: GdxpCgBXNkEu3sxfE1UBAQ--.322S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFykuFyfGF48Kw4ftF17Awb_yoW8JF47pF
        WUGFyUur4kXr4q9a1vyr4kuFW5Aw4rWrWSgr9a934rWw17tFZ7W3Z8tFyfAr95trW8Cr10
        qrsIywn5X3Z8WwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UkcTQUUUUU=
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: puxfs6pkdqw5xldrx3rl6rljoofrz/xtbBRRHyMFPAIsMQXwAAsr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>

If the hardware receives an oversized packet with too many rx fragments,
skb_shinfo(skb)->frags can overflow and corrupt memory of adjacent pages.
This becomes especially visible if it corrupts the freelist pointer of
a slab page.

Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 169ac4f54..a3e274c65 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -102,8 +102,12 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
 
 		dma_unmap_page(dev, dma_unmap_addr(page_info, dma_addr),
 			       PAGE_SIZE, DMA_FROM_DEVICE);
-		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+		struct skb_shared_info *shinfo = skb_shinfo(skb);
+
+		if (shinfo->nr_frags < ARRAY_SIZE(shinfo->frags)) {
+			skb_add_rx_frag(skb, shinfo->nr_frags,
 				page_info->page, 0, frag_len, PAGE_SIZE);
+		}
 		page_info->page = NULL;
 		page_info++;
 		i--;
-- 
2.17.1

