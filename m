Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D66B046FBD
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 13:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfFOLBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 07:01:47 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34147 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfFOLBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 07:01:45 -0400
Received: by mail-lj1-f195.google.com with SMTP id p17so4896247ljg.1
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 04:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=z0/hbIyKEzsKlUSNqZcyqqFA3r0AZJ8ImBuvmj1df9M=;
        b=V4Mgcnodj8QQNSXRhi9o2Lg83jmjevVTFHF6tNsrq8GP1XXiVNJ4EtLS3u4Uzfb/Yn
         eS15wvnlZwhtKjoiBcup7VXzL8BfFnyA8iqWefuBlmz31eKEp9ENGVrqtuYZSSgyYI83
         TgUA7IGC1PAaQLOLnoPi3iYVRpY4vsE0QMluOC5pW6qSCmIg62B0j43qYkVi2+rTtaYk
         nLzCaMifa7KuAmeG9YHzJmqa9NOCgTmX0I2XqHtUNi8OlpXVCMtPk2bSD0uBhj9EtXWD
         HophVZf9Tpaj9cF4I8Z2zFizrpA5dE8bZYWu9Ut79b99JgZvDNxoWh7DN5qUSn2kcD3x
         qaIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=z0/hbIyKEzsKlUSNqZcyqqFA3r0AZJ8ImBuvmj1df9M=;
        b=tD4FAEZc9oMx49NpbNhuz+R2fTuG9an91LEBAMzt2SkjLuf8FuFsCqX++7E8C5pg3R
         7ULBiKvN5O9peftDHE39PRctEPQ5FEQ1EyU7qbfRn/LQFkuu5rPNgttrfnhXUZiXl/3T
         IQTtZg+Ic3WZlwUuHn7GizKu8dgcHXoHXrbYDeLyn5wbj1emphBrCvNJGc0pY56k10NZ
         6HByxz2eaTdrPmU9ldbHQBgqiH8OZisYvSSAdqQmx9vFJheuuER5fYJ0D/z3SzZeJTk5
         3/xd/nQYlF0Z75pVsFmUh/g0hy4xgCxFnvikjKDQLkXQrsXNRtkSz59GV4J4niLaA6Uk
         qggQ==
X-Gm-Message-State: APjAAAXIENNQKODDbEcRK0ttTnTsSt/BL72xt5oRDqXoCQRE+Ze4MdzJ
        Oa91YjrUkZPeLSuoC0xYH1Tzzg==
X-Google-Smtp-Source: APXvYqyZgWAyHrmL3iJXYnf7X/41qb/JaYSHL9lErK/e30yGm75FuCObx3wxEf7PcGTDmBTWLx9Fvg==
X-Received: by 2002:a2e:6e0e:: with SMTP id j14mr6490660ljc.85.1560596501562;
        Sat, 15 Jun 2019 04:01:41 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id j14sm936258lfc.9.2019.06.15.04.01.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 04:01:41 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, davem@davemloft.net
Cc:     linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH net-next] net: ethernet: ti: davinci_cpdma: use idled submit
Date:   Sat, 15 Jun 2019 14:01:32 +0300
Message-Id: <20190615110132.6594-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While data pass suspend, reuse of rx descriptors can be disabled using
channel state & lock from cpdma layer. For this, submit to a channel
has to be disabled using state != "not active" under lock, what is done
with this patch. The same submit is used to fill rx channel while
ndo_open, when channel is idled, so add idled submit routine that
allows to prepare descs for the channel. All this simplifies code and
helps to avoid dormant mode usage and send packets only to active
channels, avoiding potential race in later on changes. Also add missed
sync barrier analogically like in other places after stopping tx
queues.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---

Based on net-next/master

 drivers/net/ethernet/ti/cpsw.c          | 15 ++---
 drivers/net/ethernet/ti/cpsw_ethtool.c  | 12 +---
 drivers/net/ethernet/ti/davinci_cpdma.c | 85 +++++++++++++++++++------
 drivers/net/ethernet/ti/davinci_cpdma.h |  2 +
 drivers/net/ethernet/ti/davinci_emac.c  |  4 +-
 5 files changed, 77 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 3430503e1053..7bdd287074fc 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -457,16 +457,13 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	}
 
 requeue:
-	if (netif_dormant(ndev)) {
-		dev_kfree_skb_any(new_skb);
-		return;
-	}
-
 	ch = cpsw->rxv[skb_get_queue_mapping(new_skb)].ch;
 	ret = cpdma_chan_submit(ch, new_skb, new_skb->data,
 				skb_tailroom(new_skb), 0);
-	if (WARN_ON(ret < 0))
+	if (ret < 0) {
+		WARN_ON(ret == -ENOMEM);
 		dev_kfree_skb_any(new_skb);
+	}
 }
 
 void cpsw_split_res(struct cpsw_common *cpsw)
@@ -1051,9 +1048,9 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv)
 			}
 
 			skb_set_queue_mapping(skb, ch);
-			ret = cpdma_chan_submit(cpsw->rxv[ch].ch, skb,
-						skb->data, skb_tailroom(skb),
-						0);
+			ret = cpdma_chan_idle_submit(cpsw->rxv[ch].ch, skb,
+						     skb->data,
+						     skb_tailroom(skb), 0);
 			if (ret < 0) {
 				cpsw_err(priv, ifup,
 					 "cannot submit skb to channel %d rx, error %d\n",
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index 86697b32194d..f60dc1dfc443 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -464,7 +464,6 @@ static void cpsw_suspend_data_pass(struct net_device *ndev)
 	cpsw_intr_disable(cpsw);
 
 	/* Stop all transmit queues for every network device.
-	 * Disable re-using rx descriptors with dormant_on.
 	 */
 	for (i = 0; i < cpsw->data.slaves; i++) {
 		ndev = cpsw->slaves[i].ndev;
@@ -472,7 +471,9 @@ static void cpsw_suspend_data_pass(struct net_device *ndev)
 			continue;
 
 		netif_tx_stop_all_queues(ndev);
-		netif_dormant_on(ndev);
+
+		/* Barrier, so that stop_queue visible to other cpus */
+		smp_mb__after_atomic();
 	}
 
 	/* Handle rest of tx packets and stop cpdma channels */
@@ -485,13 +486,6 @@ static int cpsw_resume_data_pass(struct net_device *ndev)
 	struct cpsw_common *cpsw = priv->cpsw;
 	int i, ret;
 
-	/* Allow rx packets handling */
-	for (i = 0; i < cpsw->data.slaves; i++) {
-		ndev = cpsw->slaves[i].ndev;
-		if (ndev && netif_running(ndev))
-			netif_dormant_off(ndev);
-	}
-
 	/* After this receive is started */
 	if (cpsw->usage_count) {
 		ret = cpsw_fill_rx_channels(priv);
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 35bf14d8e7af..5cf1758d425b 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -134,6 +134,14 @@ struct cpdma_control_info {
 #define ACCESS_RW	(ACCESS_RO | ACCESS_WO)
 };
 
+struct submit_info {
+	struct cpdma_chan *chan;
+	int directed;
+	void *token;
+	void *data;
+	int len;
+};
+
 static struct cpdma_control_info controls[] = {
 	[CPDMA_TX_RLIM]		  = {CPDMA_DMACONTROL,	8,  0xffff, ACCESS_RW},
 	[CPDMA_CMD_IDLE]	  = {CPDMA_DMACONTROL,	3,  1,      ACCESS_WO},
@@ -1002,34 +1010,25 @@ static void __cpdma_chan_submit(struct cpdma_chan *chan,
 	}
 }
 
-int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
-		      int len, int directed)
+static int cpdma_chan_submit_si(struct submit_info *si)
 {
+	struct cpdma_chan		*chan = si->chan;
 	struct cpdma_ctlr		*ctlr = chan->ctlr;
+	int				len = si->len;
 	struct cpdma_desc __iomem	*desc;
 	dma_addr_t			buffer;
-	unsigned long			flags;
 	u32				mode;
-	int				ret = 0;
-
-	spin_lock_irqsave(&chan->lock, flags);
-
-	if (chan->state == CPDMA_STATE_TEARDOWN) {
-		ret = -EINVAL;
-		goto unlock_ret;
-	}
+	int				ret;
 
 	if (chan->count >= chan->desc_num)	{
 		chan->stats.desc_alloc_fail++;
-		ret = -ENOMEM;
-		goto unlock_ret;
+		return -ENOMEM;
 	}
 
 	desc = cpdma_desc_alloc(ctlr->pool);
 	if (!desc) {
 		chan->stats.desc_alloc_fail++;
-		ret = -ENOMEM;
-		goto unlock_ret;
+		return -ENOMEM;
 	}
 
 	if (len < ctlr->params.min_packet_size) {
@@ -1037,16 +1036,15 @@ int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 		chan->stats.runt_transmit_buff++;
 	}
 
-	buffer = dma_map_single(ctlr->dev, data, len, chan->dir);
+	buffer = dma_map_single(ctlr->dev, si->data, len, chan->dir);
 	ret = dma_mapping_error(ctlr->dev, buffer);
 	if (ret) {
 		cpdma_desc_free(ctlr->pool, desc, 1);
-		ret = -EINVAL;
-		goto unlock_ret;
+		return -EINVAL;
 	}
 
 	mode = CPDMA_DESC_OWNER | CPDMA_DESC_SOP | CPDMA_DESC_EOP;
-	cpdma_desc_to_port(chan, mode, directed);
+	cpdma_desc_to_port(chan, mode, si->directed);
 
 	/* Relaxed IO accessors can be used here as there is read barrier
 	 * at the end of write sequence.
@@ -1055,7 +1053,7 @@ int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 	writel_relaxed(buffer, &desc->hw_buffer);
 	writel_relaxed(len, &desc->hw_len);
 	writel_relaxed(mode | len, &desc->hw_mode);
-	writel_relaxed((uintptr_t)token, &desc->sw_token);
+	writel_relaxed((uintptr_t)si->token, &desc->sw_token);
 	writel_relaxed(buffer, &desc->sw_buffer);
 	writel_relaxed(len, &desc->sw_len);
 	desc_read(desc, sw_len);
@@ -1066,8 +1064,53 @@ int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 		chan_write(chan, rxfree, 1);
 
 	chan->count++;
+	return 0;
+}
 
-unlock_ret:
+int cpdma_chan_idle_submit(struct cpdma_chan *chan, void *token, void *data,
+			   int len, int directed)
+{
+	struct submit_info si;
+	unsigned long flags;
+	int ret;
+
+	si.chan = chan;
+	si.token = token;
+	si.data = data;
+	si.len = len;
+	si.directed = directed;
+
+	spin_lock_irqsave(&chan->lock, flags);
+	if (chan->state == CPDMA_STATE_TEARDOWN) {
+		spin_unlock_irqrestore(&chan->lock, flags);
+		return -EINVAL;
+	}
+
+	ret = cpdma_chan_submit_si(&si);
+	spin_unlock_irqrestore(&chan->lock, flags);
+	return ret;
+}
+
+int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
+		      int len, int directed)
+{
+	struct submit_info si;
+	unsigned long flags;
+	int ret;
+
+	si.chan = chan;
+	si.token = token;
+	si.data = data;
+	si.len = len;
+	si.directed = directed;
+
+	spin_lock_irqsave(&chan->lock, flags);
+	if (chan->state != CPDMA_STATE_ACTIVE) {
+		spin_unlock_irqrestore(&chan->lock, flags);
+		return -EINVAL;
+	}
+
+	ret = cpdma_chan_submit_si(&si);
 	spin_unlock_irqrestore(&chan->lock, flags);
 	return ret;
 }
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.h b/drivers/net/ethernet/ti/davinci_cpdma.h
index 10376062dafa..9343c8c73c1b 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.h
+++ b/drivers/net/ethernet/ti/davinci_cpdma.h
@@ -79,6 +79,8 @@ int cpdma_chan_get_stats(struct cpdma_chan *chan,
 			 struct cpdma_chan_stats *stats);
 int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 		      int len, int directed);
+int cpdma_chan_idle_submit(struct cpdma_chan *chan, void *token, void *data,
+			   int len, int directed);
 int cpdma_chan_process(struct cpdma_chan *chan, int quota);
 
 int cpdma_ctlr_int_ctrl(struct cpdma_ctlr *ctlr, bool enable);
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index 4bf65cab79e6..5f4ece0d5a73 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1428,8 +1428,8 @@ static int emac_dev_open(struct net_device *ndev)
 		if (!skb)
 			break;
 
-		ret = cpdma_chan_submit(priv->rxchan, skb, skb->data,
-					skb_tailroom(skb), 0);
+		ret = cpdma_chan_idle_submit(priv->rxchan, skb, skb->data,
+					     skb_tailroom(skb), 0);
 		if (WARN_ON(ret < 0))
 			break;
 	}
-- 
2.17.1

