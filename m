Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6B3285D7
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 20:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731505AbfEWSWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 14:22:23 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40856 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731503AbfEWSWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 14:22:08 -0400
Received: by mail-lf1-f67.google.com with SMTP id h13so5104599lfc.7
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 11:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iD/LcGP+QRCarG7SG/VImDpBSvgA/TUijkUBXijkBUI=;
        b=KTAJaZymMWsJUM5gtlkAKLT1t+ZWacGdGCjwyP+pVYMzq/LM3qpuc9TSLcx4+oIXtZ
         7lIp7uxm9vWfahU1HwdhBsdVGm005uD0uW4pVeYGdEESCmrvtZpHu1r4SEGLCHag7EzI
         8LmAd1cGH6DpGvKBMvDOEI7edY7ll+Csb3ZvVzlEXZ+haLBVNQCqlON1+5yTG0UFTM3f
         eiHgB5gh2BPbDs4m/Wpj9ISTN8otDjn/wPJ6J81jKnT5tvU5Kh+yo4vQtZF+eNDL9DvE
         3c5AroVyC8glU7+ciVY3JAmlShVxrzUEII2R4XSqXNifMC7WomayEeKFuzak9yqrFLbu
         ug2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iD/LcGP+QRCarG7SG/VImDpBSvgA/TUijkUBXijkBUI=;
        b=ZfBxJZRGKm6hY8CTBb+niE5D7tn0Kyw9KfWtA33gp5HSY6m5V2SGWIpV77Tx9c+A2J
         f4/E0K45JSRDhnZXMCRimLSGD2cVmDovqsm4HuRuzbKLTT/osS+IZT+ZfnvLnm3cZF6L
         MfZSPj4K+0k4r0MKurw+x4ebx+a/03LT9hX40ZeXE22rDUSB10djaFYGjtf8aksTnS7b
         UarVw/9PiNx3rNzZJ8yahXlhvFbpV+qjtZ34bU76otrsI4cxIw4EQV0gDOfzIfgAJwA+
         vC5GUX+2fwTYpJPu+YhWOx78Cv+CMQjH4/se7G1H1qMFAL2cn/eRPA1QqF8PEIs3rcFI
         JmFA==
X-Gm-Message-State: APjAAAW14z/aIW8yh9wu/7RAQPAe5720Q8L+L9+/2o3zThVFOOFylNmv
        2eETUsUfJOCEiDpu2ebbuV0qJA==
X-Google-Smtp-Source: APXvYqyPGxPAfVCHQbvQBpRFG9opheaYOA7cdGZknOQ62HlQdketqJzI6dBdXZM8OLhIXDTATVw6Tg==
X-Received: by 2002:a19:6b04:: with SMTP id d4mr19991214lfa.57.1558635725898;
        Thu, 23 May 2019 11:22:05 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id n26sm59904lfi.90.2019.05.23.11.22.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 11:22:05 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH net-next 2/3] net: ethernet: ti: davinci_cpdma: return handler status
Date:   Thu, 23 May 2019 21:20:34 +0300
Message-Id: <20190523182035.9283-3-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
References: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change is needed to return flush status of rx handler for
flushing redirected xdp frames after processing channel packets.
Do it as separate patch for simplicity.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/cpsw.c          | 23 +++++++++++------
 drivers/net/ethernet/ti/cpsw_ethtool.c  |  2 +-
 drivers/net/ethernet/ti/cpsw_priv.h     |  2 +-
 drivers/net/ethernet/ti/davinci_cpdma.c | 34 +++++++++++++++----------
 drivers/net/ethernet/ti/davinci_cpdma.h |  4 +--
 drivers/net/ethernet/ti/davinci_emac.c  | 18 ++++++++-----
 6 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 634fc484a0b3..87a600aeee4a 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -337,7 +337,7 @@ void cpsw_intr_disable(struct cpsw_common *cpsw)
 	return;
 }
 
-void cpsw_tx_handler(void *token, int len, int status)
+int cpsw_tx_handler(void *token, int len, int status)
 {
 	struct netdev_queue	*txq;
 	struct sk_buff		*skb = token;
@@ -355,6 +355,7 @@ void cpsw_tx_handler(void *token, int len, int status)
 	ndev->stats.tx_packets++;
 	ndev->stats.tx_bytes += len;
 	dev_kfree_skb_any(skb);
+	return 0;
 }
 
 static void cpsw_rx_vlan_encap(struct sk_buff *skb)
@@ -400,7 +401,7 @@ static void cpsw_rx_vlan_encap(struct sk_buff *skb)
 	}
 }
 
-static void cpsw_rx_handler(void *token, int len, int status)
+static int cpsw_rx_handler(void *token, int len, int status)
 {
 	struct cpdma_chan	*ch;
 	struct sk_buff		*skb = token;
@@ -434,7 +435,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 
 		/* the interface is going down, skbs are purged */
 		dev_kfree_skb_any(skb);
-		return;
+		return 0;
 	}
 
 	new_skb = netdev_alloc_skb_ip_align(ndev, cpsw->rx_packet_max);
@@ -459,7 +460,7 @@ static void cpsw_rx_handler(void *token, int len, int status)
 requeue:
 	if (netif_dormant(ndev)) {
 		dev_kfree_skb_any(new_skb);
-		return;
+		return 0;
 	}
 
 	ch = cpsw->rxv[skb_get_queue_mapping(new_skb)].ch;
@@ -467,6 +468,8 @@ static void cpsw_rx_handler(void *token, int len, int status)
 				skb_tailroom(new_skb), 0);
 	if (WARN_ON(ret < 0))
 		dev_kfree_skb_any(new_skb);
+
+	return 0;
 }
 
 void cpsw_split_res(struct cpsw_common *cpsw)
@@ -605,7 +608,8 @@ static int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget)
 		else
 			cur_budget = txv->budget;
 
-		num_tx += cpdma_chan_process(txv->ch, cur_budget);
+		cpdma_chan_process(txv->ch, &cur_budget);
+		num_tx += cur_budget;
 		if (num_tx >= budget)
 			break;
 	}
@@ -623,7 +627,8 @@ static int cpsw_tx_poll(struct napi_struct *napi_tx, int budget)
 	struct cpsw_common *cpsw = napi_to_cpsw(napi_tx);
 	int num_tx;
 
-	num_tx = cpdma_chan_process(cpsw->txv[0].ch, budget);
+	num_tx = budget;
+	cpdma_chan_process(cpsw->txv[0].ch, &num_tx);
 	if (num_tx < budget) {
 		napi_complete(napi_tx);
 		writel(0xff, &cpsw->wr_regs->tx_en);
@@ -655,7 +660,8 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 		else
 			cur_budget = rxv->budget;
 
-		num_rx += cpdma_chan_process(rxv->ch, cur_budget);
+		cpdma_chan_process(rxv->ch, &cur_budget);
+		num_rx += cur_budget;
 		if (num_rx >= budget)
 			break;
 	}
@@ -673,7 +679,8 @@ static int cpsw_rx_poll(struct napi_struct *napi_rx, int budget)
 	struct cpsw_common *cpsw = napi_to_cpsw(napi_rx);
 	int num_rx;
 
-	num_rx = cpdma_chan_process(cpsw->rxv[0].ch, budget);
+	num_rx = budget;
+	cpdma_chan_process(cpsw->rxv[0].ch, &num_rx);
 	if (num_rx < budget) {
 		napi_complete_done(napi_rx, num_rx);
 		writel(0xff, &cpsw->wr_regs->rx_en);
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index a4a7ec0d2531..0c08ec91635a 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -535,8 +535,8 @@ static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx,
 				    cpdma_handler_fn rx_handler)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
-	void (*handler)(void *, int, int);
 	struct netdev_queue *queue;
+	cpdma_handler_fn handler;
 	struct cpsw_vector *vec;
 	int ret, *ch, vch;
 
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index 04795b97ee71..2ecb3af59fe9 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -390,7 +390,7 @@ void cpsw_split_res(struct cpsw_common *cpsw);
 int cpsw_fill_rx_channels(struct cpsw_priv *priv);
 void cpsw_intr_enable(struct cpsw_common *cpsw);
 void cpsw_intr_disable(struct cpsw_common *cpsw);
-void cpsw_tx_handler(void *token, int len, int status);
+int cpsw_tx_handler(void *token, int len, int status);
 
 /* ethtool */
 u32 cpsw_get_msglevel(struct net_device *ndev);
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 7f89b2299f05..b3d4dfd760d2 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -1137,15 +1137,16 @@ bool cpdma_check_free_tx_desc(struct cpdma_chan *chan)
 	return free_tx_desc;
 }
 
-static void __cpdma_chan_free(struct cpdma_chan *chan,
-			      struct cpdma_desc __iomem *desc,
-			      int outlen, int status)
+static int __cpdma_chan_free(struct cpdma_chan *chan,
+			     struct cpdma_desc __iomem *desc, int outlen,
+			     int status)
 {
 	struct cpdma_ctlr		*ctlr = chan->ctlr;
 	struct cpdma_desc_pool		*pool = ctlr->pool;
 	dma_addr_t			buff_dma;
 	int				origlen;
 	uintptr_t			token;
+	int				ret;
 
 	token      = desc_read(desc, sw_token);
 	origlen    = desc_read(desc, sw_len);
@@ -1160,14 +1161,16 @@ static void __cpdma_chan_free(struct cpdma_chan *chan,
 	}
 
 	cpdma_desc_free(pool, desc, 1);
-	(*chan->handler)((void *)token, outlen, status);
+	ret = (*chan->handler)((void *)token, outlen, status);
+
+	return ret;
 }
 
 static int __cpdma_chan_process(struct cpdma_chan *chan)
 {
+	int				status, outlen, ret;
 	struct cpdma_ctlr		*ctlr = chan->ctlr;
 	struct cpdma_desc __iomem	*desc;
-	int				status, outlen;
 	int				cb_status = 0;
 	struct cpdma_desc_pool		*pool = ctlr->pool;
 	dma_addr_t			desc_dma;
@@ -1178,7 +1181,7 @@ static int __cpdma_chan_process(struct cpdma_chan *chan)
 	desc = chan->head;
 	if (!desc) {
 		chan->stats.empty_dequeue++;
-		status = -ENOENT;
+		ret = -ENOENT;
 		goto unlock_ret;
 	}
 	desc_dma = desc_phys(pool, desc);
@@ -1187,7 +1190,7 @@ static int __cpdma_chan_process(struct cpdma_chan *chan)
 	outlen	= status & 0x7ff;
 	if (status & CPDMA_DESC_OWNER) {
 		chan->stats.busy_dequeue++;
-		status = -EBUSY;
+		ret = -EBUSY;
 		goto unlock_ret;
 	}
 
@@ -1213,28 +1216,31 @@ static int __cpdma_chan_process(struct cpdma_chan *chan)
 	else
 		cb_status = status;
 
-	__cpdma_chan_free(chan, desc, outlen, cb_status);
-	return status;
+	ret = __cpdma_chan_free(chan, desc, outlen, cb_status);
+	return ret;
 
 unlock_ret:
 	spin_unlock_irqrestore(&chan->lock, flags);
-	return status;
+	return ret;
 }
 
-int cpdma_chan_process(struct cpdma_chan *chan, int quota)
+int cpdma_chan_process(struct cpdma_chan *chan, int *quota)
 {
-	int used = 0, ret = 0;
+	int used = 0, ret = 0, res = 0;
 
 	if (chan->state != CPDMA_STATE_ACTIVE)
 		return -EINVAL;
 
-	while (used < quota) {
+	while (used < *quota) {
 		ret = __cpdma_chan_process(chan);
 		if (ret < 0)
 			break;
+		res += ret;
 		used++;
 	}
-	return used;
+
+	*quota = used;
+	return res;
 }
 
 int cpdma_chan_start(struct cpdma_chan *chan)
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.h b/drivers/net/ethernet/ti/davinci_cpdma.h
index 8f6f27185c63..56543d375923 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.h
+++ b/drivers/net/ethernet/ti/davinci_cpdma.h
@@ -61,7 +61,7 @@ struct cpdma_chan_stats {
 struct cpdma_ctlr;
 struct cpdma_chan;
 
-typedef void (*cpdma_handler_fn)(void *token, int len, int status);
+typedef int (*cpdma_handler_fn)(void *token, int len, int status);
 
 struct cpdma_ctlr *cpdma_ctlr_create(struct cpdma_params *params);
 int cpdma_ctlr_destroy(struct cpdma_ctlr *ctlr);
@@ -81,7 +81,7 @@ int cpdma_chan_submit_mapped(struct cpdma_chan *chan, void *token,
 			     dma_addr_t data, int len, int directed);
 int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 		      int len, int directed);
-int cpdma_chan_process(struct cpdma_chan *chan, int quota);
+int cpdma_chan_process(struct cpdma_chan *chan, int *quota);
 
 int cpdma_ctlr_int_ctrl(struct cpdma_ctlr *ctlr, bool enable);
 void cpdma_ctlr_eoi(struct cpdma_ctlr *ctlr, u32 value);
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 4bf65cab79e6..3592690b8dd8 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -860,7 +860,7 @@ static struct sk_buff *emac_rx_alloc(struct emac_priv *priv)
 	return skb;
 }
 
-static void emac_rx_handler(void *token, int len, int status)
+static int emac_rx_handler(void *token, int len, int status)
 {
 	struct sk_buff		*skb = token;
 	struct net_device	*ndev = skb->dev;
@@ -871,7 +871,7 @@ static void emac_rx_handler(void *token, int len, int status)
 	/* free and bail if we are shutting down */
 	if (unlikely(!netif_running(ndev))) {
 		dev_kfree_skb_any(skb);
-		return;
+		return 0;
 	}
 
 	/* recycle on receive error */
@@ -892,7 +892,7 @@ static void emac_rx_handler(void *token, int len, int status)
 	if (!skb) {
 		if (netif_msg_rx_err(priv) && net_ratelimit())
 			dev_err(emac_dev, "failed rx buffer alloc\n");
-		return;
+		return 0;
 	}
 
 recycle:
@@ -902,9 +902,11 @@ static void emac_rx_handler(void *token, int len, int status)
 	WARN_ON(ret == -ENOMEM);
 	if (unlikely(ret < 0))
 		dev_kfree_skb_any(skb);
+
+	return 0;
 }
 
-static void emac_tx_handler(void *token, int len, int status)
+static int emac_tx_handler(void *token, int len, int status)
 {
 	struct sk_buff		*skb = token;
 	struct net_device	*ndev = skb->dev;
@@ -917,6 +919,7 @@ static void emac_tx_handler(void *token, int len, int status)
 	ndev->stats.tx_packets++;
 	ndev->stats.tx_bytes += len;
 	dev_kfree_skb_any(skb);
+	return 0;
 }
 
 /**
@@ -1237,8 +1240,8 @@ static int emac_poll(struct napi_struct *napi, int budget)
 		mask = EMAC_DM646X_MAC_IN_VECTOR_TX_INT_VEC;
 
 	if (status & mask) {
-		num_tx_pkts = cpdma_chan_process(priv->txchan,
-					      EMAC_DEF_TX_MAX_SERVICE);
+		num_tx_pkts = EMAC_DEF_TX_MAX_SERVICE;
+		cpdma_chan_process(priv->txchan, &num_tx_pkts);
 	} /* TX processing */
 
 	mask = EMAC_DM644X_MAC_IN_VECTOR_RX_INT_VEC;
@@ -1247,7 +1250,8 @@ static int emac_poll(struct napi_struct *napi, int budget)
 		mask = EMAC_DM646X_MAC_IN_VECTOR_RX_INT_VEC;
 
 	if (status & mask) {
-		num_rx_pkts = cpdma_chan_process(priv->rxchan, budget);
+		num_rx_pkts = budget;
+		cpdma_chan_process(priv->rxchan, &num_rx_pkts);
 	} /* RX processing */
 
 	mask = EMAC_DM644X_MAC_IN_VECTOR_HOST_INT;
-- 
2.17.1

