Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECCE12384A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbfLQVEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:04:24 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54915 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728399AbfLQVDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:03:35 -0500
Received: by mail-wm1-f66.google.com with SMTP id b19so4322671wmj.4;
        Tue, 17 Dec 2019 13:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3xyP56jfldk/QOafjRLnUwDKDDtqv9xmwev/LMdHDz4=;
        b=IepK1T4eyRa/Fd+JEJACkzRNKWN1Mi65wb9Z/timiiFdWrYIV4mpLb6KSJFxeO7pSB
         0+D8H2z738RcaY6hMbUQdLG4KlneBfkoLKDSwUw/trV5H9rp816xzLJUvzlNWdJ67Z3x
         myjRFDYiumHaR6otSdbWyiBFRYBaOLm38WVBEMNBgh5LBUG/rbFdR+RcMBVTQ/eEP63w
         1+1kb/lhj9wKzHbzMpy2dVerl/Kv5znE91r+3OEamPsJs3p4guhZWDH+jlIUPzP+yg5R
         wgOS+ynUchrx+dKkoYi4ixxPZk3dRxhh2wue53MIP56XTF5sXzXjejB1CdkV042zNwq9
         nq1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3xyP56jfldk/QOafjRLnUwDKDDtqv9xmwev/LMdHDz4=;
        b=FkW7sRroOKGJZIzEeg0Eh4ByRq7lfhbxs94qN0XtxpQ8iuEEkLYTd2Kcp/mcZg3DAN
         6sqMdjcA0e8lFP4s2cTF0bdHZffxD95AbWt0TZZCLmsjSz5M92sly1EddDcyLJ8IrML9
         /MWUY+bNM6F3nJIqJ/mv32zdm3dqKFSTPSpFjKTb1oyYQ00lmPD7PCz37Y6d/fEFSykh
         uw2LxxiQI82YAcz14pZUlG1IVRDnThdqBvJ1LOC9MqjdJHkZLrgmZd1YkozLltQpc3Eh
         JlW8lytNgW/a4bE4ffe9rzSWRnmihjIUD9g9oOIo43FbsxH+clmShv/XV1b2q95wqnea
         /5Vg==
X-Gm-Message-State: APjAAAXYCG7m6j7NuFp/SjCt8DczjURKgTtU5SzmCWfuepjFidc2tc+b
        HWMB3ufE8RIHLRzTW1Ed2fk=
X-Google-Smtp-Source: APXvYqx6FXdGu1uMMrx6xqysMukshZBb05oMC7T5qwh/o6DLubYhJW5yLiDondYhhFYgINnWAChviw==
X-Received: by 2002:a1c:c919:: with SMTP id f25mr7554275wmb.49.1576616613191;
        Tue, 17 Dec 2019 13:03:33 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i5sm37856wml.31.2019.12.17.13.03.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:03:32 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 8/8] net: bcmgenet: Add software counters to track reallocations
Date:   Tue, 17 Dec 2019 13:02:29 -0800
Message-Id: <1576616549-39097-9-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
References: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When inserting the TSB, keep track of how many times we had to do
it and if there was a failure in doing so, this helps profile the
driver for possibly incorrect headroom settings.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 6 ++++++
 drivers/net/ethernet/broadcom/genet/bcmgenet.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 0280e76bb60f..e0109b86c054 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -861,6 +861,9 @@ static const struct bcmgenet_stats bcmgenet_gstrings_stats[] = {
 	STAT_GENET_SOFT_MIB("alloc_rx_buff_failed", mib.alloc_rx_buff_failed),
 	STAT_GENET_SOFT_MIB("rx_dma_failed", mib.rx_dma_failed),
 	STAT_GENET_SOFT_MIB("tx_dma_failed", mib.tx_dma_failed),
+	STAT_GENET_SOFT_MIB("tx_realloc_tsb", mib.tx_realloc_tsb),
+	STAT_GENET_SOFT_MIB("tx_realloc_tsb_failed",
+			    mib.tx_realloc_tsb_failed),
 	/* Per TX queues */
 	STAT_GENET_Q(0),
 	STAT_GENET_Q(1),
@@ -1487,6 +1490,7 @@ static void bcmgenet_tx_reclaim_all(struct net_device *dev)
 static struct sk_buff *bcmgenet_put_tx_csum(struct net_device *dev,
 					    struct sk_buff *skb)
 {
+	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct status_64 *status = NULL;
 	struct sk_buff *new_skb;
 	u16 offset;
@@ -1501,11 +1505,13 @@ static struct sk_buff *bcmgenet_put_tx_csum(struct net_device *dev,
 		new_skb = skb_realloc_headroom(skb, sizeof(*status));
 		if (!new_skb) {
 			dev_kfree_skb_any(skb);
+			priv->mib.tx_realloc_tsb_failed++;
 			dev->stats.tx_dropped++;
 			return NULL;
 		}
 		dev_consume_skb_any(skb);
 		skb = new_skb;
+		priv->mib.tx_realloc_tsb++;
 	}
 
 	skb_push(skb, sizeof(*status));
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.h b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
index 11645cccc207..178d000e462f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.h
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.h
@@ -144,6 +144,8 @@ struct bcmgenet_mib_counters {
 	u32	alloc_rx_buff_failed;
 	u32	rx_dma_failed;
 	u32	tx_dma_failed;
+	u32	tx_realloc_tsb;
+	u32	tx_realloc_tsb_failed;
 };
 
 #define UMAC_HD_BKP_CTRL		0x004
-- 
2.7.4

