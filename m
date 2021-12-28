Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF375480D8C
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhL1VtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:49:16 -0500
Received: from mx3.wp.pl ([212.77.101.9]:13975 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230246AbhL1VtQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 16:49:16 -0500
Received: (wp-smtpd smtp.wp.pl 14769 invoked from network); 28 Dec 2021 22:49:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1640728152; bh=cGB/2VqJaRDRtG4vk9Wb9lKSDzjlmhIKmM1dSRfHveo=;
          h=From:To:Subject;
          b=GOftwwGsEBvtOhRgyTsgxuXZVNiD0//QLlbREn/USRMYZusq0U/wvjJWa5Iqb2Y6E
           pX3bosqXXT0myF9OEX7Aha8ENz+ofLolJlaSPFt3grloHWuCHsMGTOY5b4y4HWUx06
           zr5qWaPU00/G5hIVeDKDSSB+9bEXTclWcpLo0Cfw=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <davem@davemloft.net>; 28 Dec 2021 22:49:12 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     davem@davemloft.net, kuba@kernel.org, olek2@wp.pl,
        rdunlap@infradead.org, jgg@ziepe.ca, arnd@arndb.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: lantiq_etop: add missing comment for wmb()
Date:   Tue, 28 Dec 2021 22:49:10 +0100
Message-Id: <20211228214910.70810-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: cd61b76c7adb5819e277648f2fee5896
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [AUMk]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the missing code comment for memory barrier
call and fixes checkpatch warning:

WARNING: memory barrier without comment
+	wmb();

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_etop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index 072391c494ce..5d90cc147950 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -498,6 +498,7 @@ ltq_etop_tx(struct sk_buff *skb, struct net_device *dev)
 	spin_lock_irqsave(&priv->lock, flags);
 	desc->addr = ((unsigned int) dma_map_single(&priv->pdev->dev, skb->data, len,
 						DMA_TO_DEVICE)) - byte_offset;
+	/* Make sure the address is written before we give it to HW */
 	wmb();
 	desc->ctl = LTQ_DMA_OWN | LTQ_DMA_SOP | LTQ_DMA_EOP |
 		LTQ_DMA_TX_OFFSET(byte_offset) | (len & LTQ_DMA_SIZE_MASK);
-- 
2.30.2

