Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0449A55684
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732698AbfFYSAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:00:01 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39580 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732410AbfFYR76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 13:59:58 -0400
Received: by mail-lf1-f67.google.com with SMTP id p24so13292940lfo.6
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 10:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BQmMDEf9H7Vaq7I5JuGUMaBd4qjuzhRid1mFRfo+/Y8=;
        b=J0CIMS+xGTc1gyaqwn7p/IWVtcnle2qwDqeLgpQYBmLUd844qKmh9hmf+gGwQjJpFl
         4wDvP0pDThaFoFXmuiXT6pVFH+BVPQKxk/KRUOIlnCYRoL9X9a5SJqPKjU4FtQn1Cocd
         Ejxy8BPWqhPjJ5x99PBhx6kdDrDHjQIWCR4a52CTiyC6ggC3iDpfXEiAMbZtZprTIPSA
         zVW3s/B1MucDD3fovnNEWbchVpRiALo7Hz1I9F6trAWGwucREaAAP6ZVUFRcS4FI6LTp
         9UWUGs3ecs5OTlyqXgKvHV6OThieDv5oIYdRlOuBMgfNXEAlEwbNg+OwRnB7577frJF1
         +fXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BQmMDEf9H7Vaq7I5JuGUMaBd4qjuzhRid1mFRfo+/Y8=;
        b=mu/w1+xIXvQB5eNrsUA80Twnb4F3tjTVsZlMPC/RY+9yTjeRw2tkBTNFr8cyJg1gNm
         o93HEOD2U/BQvlaRxQTVQQNLwfVqtM/9+wuDKDFfl8ZIwuphIpYdoz2nbEFPOyKnHp5h
         GzHIGU5SpeaeufBRKTnc17b7P5M5zS7gEftNeE93QCZtn9xHniyqwBmoL7pS4a9aFJsK
         j43PXoufgymx9BrBfwOWNyhFJhm28hJvotLY+mlBQBZiyQ/C73ZfYC9OUsjohHX5K3RT
         H+sAmFSY4i5SoO7xB5UqjBUbqwj4iCH5kxcVI54joNqaB3aXk06w7IdJeASNPLCkYteG
         8BmQ==
X-Gm-Message-State: APjAAAXUl1mlL3lEvuJw6XD0JOS0yN8iUuk/jtaxRK7NU033Yyf4hrkl
        v2p80asYJeEtw4E07ONOPFPzcQ==
X-Google-Smtp-Source: APXvYqwWAKPamNzi/+HXxZsRtG5kfFXs0zlr+KbgCXLJytYkfESv+RZ3s9mqyq/k+d/IZconFSlokA==
X-Received: by 2002:a19:7616:: with SMTP id c22mr26526lff.115.1561485595986;
        Tue, 25 Jun 2019 10:59:55 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id g76sm2367597lje.43.2019.06.25.10.59.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 10:59:55 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     davem@davemloft.net, grygorii.strashko@ti.com, hawk@kernel.org,
        brouer@redhat.com, saeedm@mellanox.com, leon@kernel.org
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v4 net-next 3/4] net: ethernet: ti: davinci_cpdma: return handler status
Date:   Tue, 25 Jun 2019 20:59:47 +0300
Message-Id: <20190625175948.24771-4-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org>
References: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change is needed to return flush status of rx handler for
flushing redirected xdp frames after processing channel packets.
Do it as separate patch for simplicity.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/cpsw.c          | 21 ++++++++++-----
 drivers/net/ethernet/ti/cpsw_ethtool.c  |  2 +-
 drivers/net/ethernet/ti/cpsw_priv.h     |  2 +-
 drivers/net/ethernet/ti/davinci_cpdma.c | 34 +++++++++++++++----------
 drivers/net/ethernet/ti/davinci_cpdma.h |  4 +--
 drivers/net/ethernet/ti/davinci_emac.c  | 18 ++++++++-----
 6 files changed, 49 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 32b7b3b74a6b..726925df8d97 100644
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
@@ -464,6 +465,8 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		WARN_ON(ret == -ENOMEM);
 		dev_kfree_skb_any(new_skb);
 	}
+
+	return 0;
 }
 
 void cpsw_split_res(struct cpsw_common *cpsw)
@@ -602,7 +605,8 @@ static int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget)
 		else
 			cur_budget = txv->budget;
 
-		num_tx += cpdma_chan_process(txv->ch, cur_budget);
+		cpdma_chan_process(txv->ch, &cur_budget);
+		num_tx += cur_budget;
 		if (num_tx >= budget)
 			break;
 	}
@@ -620,7 +624,8 @@ static int cpsw_tx_poll(struct napi_struct *napi_tx, int budget)
 	struct cpsw_common *cpsw = napi_to_cpsw(napi_tx);
 	int num_tx;
 
-	num_tx = cpdma_chan_process(cpsw->txv[0].ch, budget);
+	num_tx = budget;
+	cpdma_chan_process(cpsw->txv[0].ch, &num_tx);
 	if (num_tx < budget) {
 		napi_complete(napi_tx);
 		writel(0xff, &cpsw->wr_regs->tx_en);
@@ -652,7 +657,8 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 		else
 			cur_budget = rxv->budget;
 
-		num_rx += cpdma_chan_process(rxv->ch, cur_budget);
+		cpdma_chan_process(rxv->ch, &cur_budget);
+		num_rx += cur_budget;
 		if (num_rx >= budget)
 			break;
 	}
@@ -670,7 +676,8 @@ static int cpsw_rx_poll(struct napi_struct *napi_rx, int budget)
 	struct cpsw_common *cpsw = napi_to_cpsw(napi_rx);
 	int num_rx;
 
-	num_rx = cpdma_chan_process(cpsw->rxv[0].ch, budget);
+	num_rx = budget;
+	cpdma_chan_process(cpsw->rxv[0].ch, &num_rx);
 	if (num_rx < budget) {
 		napi_complete_done(napi_rx, num_rx);
 		writel(0xff, &cpsw->wr_regs->rx_en);
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index f60dc1dfc443..7c19eebbabcc 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -532,8 +532,8 @@ static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx,
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
index 8da46394c0e7..b96f5ae974ba 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -1191,15 +1191,16 @@ bool cpdma_check_free_tx_desc(struct cpdma_chan *chan)
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
@@ -1214,14 +1215,16 @@ static void __cpdma_chan_free(struct cpdma_chan *chan,
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
@@ -1232,7 +1235,7 @@ static int __cpdma_chan_process(struct cpdma_chan *chan)
 	desc = chan->head;
 	if (!desc) {
 		chan->stats.empty_dequeue++;
-		status = -ENOENT;
+		ret = -ENOENT;
 		goto unlock_ret;
 	}
 	desc_dma = desc_phys(pool, desc);
@@ -1241,7 +1244,7 @@ static int __cpdma_chan_process(struct cpdma_chan *chan)
 	outlen	= status & 0x7ff;
 	if (status & CPDMA_DESC_OWNER) {
 		chan->stats.busy_dequeue++;
-		status = -EBUSY;
+		ret = -EBUSY;
 		goto unlock_ret;
 	}
 
@@ -1267,28 +1270,31 @@ static int __cpdma_chan_process(struct cpdma_chan *chan)
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
+		res |= ret;
 		used++;
 	}
-	return used;
+
+	*quota = used;
+	return res;
 }
 
 int cpdma_chan_start(struct cpdma_chan *chan)
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.h b/drivers/net/ethernet/ti/davinci_cpdma.h
index 0271a20c2e09..69074738bef0 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.h
+++ b/drivers/net/ethernet/ti/davinci_cpdma.h
@@ -61,7 +61,7 @@ struct cpdma_chan_stats {
 struct cpdma_ctlr;
 struct cpdma_chan;
 
-typedef void (*cpdma_handler_fn)(void *token, int len, int status);
+typedef int (*cpdma_handler_fn)(void *token, int len, int status);
 
 struct cpdma_ctlr *cpdma_ctlr_create(struct cpdma_params *params);
 int cpdma_ctlr_destroy(struct cpdma_ctlr *ctlr);
@@ -85,7 +85,7 @@ int cpdma_chan_idle_submit_mapped(struct cpdma_chan *chan, void *token,
 				  dma_addr_t data, int len, int directed);
 int cpdma_chan_idle_submit(struct cpdma_chan *chan, void *token, void *data,
 			   int len, int directed);
-int cpdma_chan_process(struct cpdma_chan *chan, int quota);
+int cpdma_chan_process(struct cpdma_chan *chan, int *quota);
 
 int cpdma_ctlr_int_ctrl(struct cpdma_ctlr *ctlr, bool enable);
 void cpdma_ctlr_eoi(struct cpdma_ctlr *ctlr, u32 value);
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 5f4ece0d5a73..0b768a426848 100644
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

