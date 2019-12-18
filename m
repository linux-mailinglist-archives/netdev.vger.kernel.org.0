Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 708C3123BEB
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 01:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfLRAvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 19:51:39 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38727 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbfLRAve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 19:51:34 -0500
Received: by mail-pf1-f194.google.com with SMTP id x185so210465pfc.5;
        Tue, 17 Dec 2019 16:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lIjsvF9IAOKO/y9eAPFaGirPoWCV8dxZZXU9yHmkvfQ=;
        b=qmW/1GT7rwoMEFROf0tuZO/TNcV775jnRSkCS+it7yLw59eK7Y1L43a+g6+fLSWG9b
         SWv1c8DzoiqPdynrpgYLWmcUPh6EUkPbVBmWbnp4VvVkeXaTRdvypbgwk+TG/V6NBR2h
         b4jZ3BoJGQh2iGNuM5aBYvvPV8DSFCcFgL2XpTuONZn5Q8QQ9CzoCnC0uUhNrdRtSPua
         VAnHhXdl4U1HGS9EnUOW64gVihWaQUfx3RNom3BE9YmDhompVgHI7F1M+2VKKbiQOZdg
         SITxEV5bTN1gKcRlL4xJids5KsCKftXxWUeVjCLpWp9uPjVsUmPi+QNMip5j5b1Jbnx3
         OtdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lIjsvF9IAOKO/y9eAPFaGirPoWCV8dxZZXU9yHmkvfQ=;
        b=UsZi+e9/vZhtfYUPmfPFqOwx44ixKn1AOgRQgpHyB0E9CrZf9Q8BRZlu5jHV7XKmzy
         L8Rf2W3yfHiFC2DpY7X3oM/1X576I/vdvRynnzFHN8dQKSABg9dw7uGdajtEDFRHxn/J
         ieEUZHr4FD4HjoyGITkEy4gKm224gg4BwbupdQRihfgcKIRe3RdqJPWASQ2yyxjePG5G
         ICLS+0DALA9TDUjEV97r/EWbMaq6Nz9J+UYBfhCzVDsvokNQEW9LdhbCGFeezdB1AQPb
         XkXKFMcH/DDKrrCrM5YmY8smQa6weVwyXAGKVocwobpXjExhlMxB6Dz2EUN2JbBXCUP+
         fSYg==
X-Gm-Message-State: APjAAAUsBtzsfJN67l+Y79SDAmQrN9DvV1fUM+N3Hpix33rUM+WySvcF
        3N/rbDpJtguBXKY4CWI085A=
X-Google-Smtp-Source: APXvYqwKGOZaAQfUtUBJtD/vxKXoV8SgggpyDu6VySrj1IUnPf+QUgUexIcyJuZXBY/qUmNXPbGJ2w==
X-Received: by 2002:a63:5b0a:: with SMTP id p10mr871386pgb.228.1576630293350;
        Tue, 17 Dec 2019 16:51:33 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 81sm274819pfx.30.2019.12.17.16.51.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 16:51:33 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 8/8] net: bcmgenet: Add software counters to track reallocations
Date:   Tue, 17 Dec 2019 16:51:15 -0800
Message-Id: <1576630275-17591-9-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
References: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When inserting the TSB, keep track of how many times we had to do
it and if there was a failure in doing so, this helps profile the
driver for possibly incorrect headroom settings.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 6 ++++++
 drivers/net/ethernet/broadcom/genet/bcmgenet.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index e2bca19bf10b..3ee7917e3fc0 100644
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
index d33c0d093f82..61a6fe9f4cec 100644
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

