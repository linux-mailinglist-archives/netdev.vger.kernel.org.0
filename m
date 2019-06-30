Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3B65B0EA
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 19:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfF3RYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 13:24:25 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38867 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbfF3RYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 13:24:23 -0400
Received: by mail-lf1-f65.google.com with SMTP id b11so7158621lfa.5
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 10:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mzcItkE9NyKz8TKyqVqQ02N7Kdo9xEfAnYuh993LyWk=;
        b=F1uXSFceQFgGnRuQR09fE6WltscOOesSJsvj3dLbd4gDUw3VShHRk8GPHXYRupEDNW
         now1SzECbP81rM14mBsTtsHichP4uxx2fGzciYi/99Mp//OtLI90kBWxmxRCjWdz8f9y
         IC+iAuOglh6BNE7xDKrN5Ad2LpV5bkYjViIFmiXFaGFgSNtKlbrqxW/019+BWycBm05o
         pW/IK3EBiPS57v+g/Y7T6QcQO8mY+6z4aZTnhQE2QU8DhT/LP9KmZLETeL/XgsJybn00
         c30sigOudFHicFXOhOTx2N+1gWztjymXz1RIHhvcMXLHUVyqrzMwP+TVHFl9e9ieBAp8
         W6XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mzcItkE9NyKz8TKyqVqQ02N7Kdo9xEfAnYuh993LyWk=;
        b=jr/1YJ6wir8H6YFB4mqKCKZP5r/qtiKshuHxZ5Lnpq8vToYY+uZspV2MFcERDIvvx8
         91/ho3tLNfxSMK9H7tTWKc3O6J8zCJWokFX8SX1j2cSRRN2CwDZXSNyNHDC49M6vB/CE
         DyvVIRoVDXdhhLnm5dled2Qn2L+cV/5BNWFobtvo/whbxHKrY+SCb7qtSYWwvDFeliav
         9SLzC9gBFZZ/aHg4LlezdZEqsaOYlX1aYK1sN8wOocM5iQEBBXdD5x+gKJPKM+GkPgqX
         WFBFkDV2z7wldNd4wviDMgV+D5uIdss/5SNmP8CmQsWNu7UYN85QgT+OoQlRbIb5jWGc
         zntQ==
X-Gm-Message-State: APjAAAUckfv512I4bR7N3GMz9MZ/aiNC89ZM4NQktp4LhlUfm6U5NxTa
        Z2CYScLa2Od9r0N/gaXuinoUDw==
X-Google-Smtp-Source: APXvYqwr6yQ6jDQA3p+o7C0QYspFBw4p0p71OV3YFLnpqUNrlo4SQQ1uo4OA0FxBtnCzVlX5cIUHow==
X-Received: by 2002:ac2:5a01:: with SMTP id q1mr9871359lfn.46.1561915461257;
        Sun, 30 Jun 2019 10:24:21 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id c1sm2273795lfh.13.2019.06.30.10.24.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 30 Jun 2019 10:24:20 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v5 net-next 3/6] net: ethernet: ti: davinci_cpdma: return handler status
Date:   Sun, 30 Jun 2019 20:23:45 +0300
Message-Id: <20190630172348.5692-4-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190630172348.5692-1-ivan.khoronzhuk@linaro.org>
References: <20190630172348.5692-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change is needed to return flush status of rx handler for
flushing redirected xdp frames after processing channel packets.
Do it as separate patch for simplicity.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/cpsw.c          | 23 +++++++++++++---------
 drivers/net/ethernet/ti/cpsw_ethtool.c  |  2 +-
 drivers/net/ethernet/ti/cpsw_priv.h     |  2 +-
 drivers/net/ethernet/ti/davinci_cpdma.c | 26 ++++++++++++++-----------
 drivers/net/ethernet/ti/davinci_cpdma.h |  4 ++--
 drivers/net/ethernet/ti/davinci_emac.c  | 17 ++++++++++------
 6 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 32b7b3b74a6b..4f72dbb5a428 100644
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
@@ -588,6 +591,7 @@ static int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget)
 	u32			ch_map;
 	int			num_tx, cur_budget, ch;
 	struct cpsw_common	*cpsw = napi_to_cpsw(napi_tx);
+	int			flags;
 	struct cpsw_vector	*txv;
 
 	/* process every unprocessed channel */
@@ -602,7 +606,7 @@ static int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget)
 		else
 			cur_budget = txv->budget;
 
-		num_tx += cpdma_chan_process(txv->ch, cur_budget);
+		num_tx += cpdma_chan_process(txv->ch, cur_budget, &flags);
 		if (num_tx >= budget)
 			break;
 	}
@@ -618,9 +622,9 @@ static int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget)
 static int cpsw_tx_poll(struct napi_struct *napi_tx, int budget)
 {
 	struct cpsw_common *cpsw = napi_to_cpsw(napi_tx);
-	int num_tx;
+	int num_tx, flags;
 
-	num_tx = cpdma_chan_process(cpsw->txv[0].ch, budget);
+	num_tx = cpdma_chan_process(cpsw->txv[0].ch, budget, &flags);
 	if (num_tx < budget) {
 		napi_complete(napi_tx);
 		writel(0xff, &cpsw->wr_regs->tx_en);
@@ -638,6 +642,7 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 	u32			ch_map;
 	int			num_rx, cur_budget, ch;
 	struct cpsw_common	*cpsw = napi_to_cpsw(napi_rx);
+	int			flags;
 	struct cpsw_vector	*rxv;
 
 	/* process every unprocessed channel */
@@ -652,7 +657,7 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 		else
 			cur_budget = rxv->budget;
 
-		num_rx += cpdma_chan_process(rxv->ch, cur_budget);
+		num_rx += cpdma_chan_process(rxv->ch, cur_budget, &flags);
 		if (num_rx >= budget)
 			break;
 	}
@@ -668,9 +673,9 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 static int cpsw_rx_poll(struct napi_struct *napi_rx, int budget)
 {
 	struct cpsw_common *cpsw = napi_to_cpsw(napi_rx);
-	int num_rx;
+	int num_rx, flags;
 
-	num_rx = cpdma_chan_process(cpsw->rxv[0].ch, budget);
+	num_rx = cpdma_chan_process(cpsw->rxv[0].ch, budget, &flags);
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
index 8da46394c0e7..ea25b23c8058 100644
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
 
@@ -1267,15 +1270,15 @@ static int __cpdma_chan_process(struct cpdma_chan *chan)
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
+int cpdma_chan_process(struct cpdma_chan *chan, int quota, int *flags)
 {
 	int used = 0, ret = 0;
 
@@ -1286,6 +1289,7 @@ int cpdma_chan_process(struct cpdma_chan *chan, int quota)
 		ret = __cpdma_chan_process(chan);
 		if (ret < 0)
 			break;
+		*flags |= ret;
 		used++;
 	}
 	return used;
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.h b/drivers/net/ethernet/ti/davinci_cpdma.h
index 0271a20c2e09..aafa8889c789 100644
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
+int cpdma_chan_process(struct cpdma_chan *chan, int quota, int *flags);
 
 int cpdma_ctlr_int_ctrl(struct cpdma_ctlr *ctlr, bool enable);
 void cpdma_ctlr_eoi(struct cpdma_ctlr *ctlr, u32 value);
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 5f4ece0d5a73..06756471d586 100644
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
@@ -1227,6 +1230,7 @@ static int emac_poll(struct napi_struct *napi, int budget)
 	struct device *emac_dev = &ndev->dev;
 	u32 status = 0;
 	u32 num_tx_pkts = 0, num_rx_pkts = 0;
+	int flags;
 
 	/* Check interrupt vectors and call packet processing */
 	status = emac_read(EMAC_MACINVECTOR);
@@ -1238,7 +1242,8 @@ static int emac_poll(struct napi_struct *napi, int budget)
 
 	if (status & mask) {
 		num_tx_pkts = cpdma_chan_process(priv->txchan,
-					      EMAC_DEF_TX_MAX_SERVICE);
+						 EMAC_DEF_TX_MAX_SERVICE,
+						 &flags);
 	} /* TX processing */
 
 	mask = EMAC_DM644X_MAC_IN_VECTOR_RX_INT_VEC;
@@ -1247,7 +1252,7 @@ static int emac_poll(struct napi_struct *napi, int budget)
 		mask = EMAC_DM646X_MAC_IN_VECTOR_RX_INT_VEC;
 
 	if (status & mask) {
-		num_rx_pkts = cpdma_chan_process(priv->rxchan, budget);
+		num_rx_pkts = cpdma_chan_process(priv->rxchan, budget, &flags);
 	} /* RX processing */
 
 	mask = EMAC_DM644X_MAC_IN_VECTOR_HOST_INT;
-- 
2.17.1

