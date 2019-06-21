Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB19A4EEA3
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 20:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfFUSPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 14:15:12 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50854 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfFUSOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 14:14:17 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5LIDlXF044319;
        Fri, 21 Jun 2019 13:13:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561140827;
        bh=pVyNlFyT6vNYf3kd2WvQg/ik95AoWQNgjp2/qaToEtw=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=dj/2JrIAYsYwFvHNFVySzArtSsMSTZ7PYLBmsGaWdBuxdD6i0wd5zOg+4z1+WDXjR
         ygweFJQj2mlXSazIHauNSupfQkyicxJdDDkcoib0ahMIR/gn67q7aiJpHWUGMZHdic
         rjmqalTG3s1JG/Z4iUO6phOsqjtfe8/cFmEiwDUU=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5LIDlXx058198
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Jun 2019 13:13:47 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 21
 Jun 2019 13:13:47 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 21 Jun 2019 13:13:47 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5LIDjCa113304;
        Fri, 21 Jun 2019 13:13:46 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v4 net-next 04/11] net: ethernet: ti: cpsw: move set of common functions in cpsw_priv
Date:   Fri, 21 Jun 2019 21:13:07 +0300
Message-ID: <20190621181314.20778-5-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190621181314.20778-1-grygorii.strashko@ti.com>
References: <20190621181314.20778-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparatory patch to add support for a switchdev based cpsw driver,
move common functions to cpsw-priv.c so that they can be used across both
drivers.

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw.c      | 964 ---------------------------
 drivers/net/ethernet/ti/cpsw_priv.c | 967 ++++++++++++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_priv.h |  20 +-
 3 files changed, 986 insertions(+), 965 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 79ac7c1db22b..b55e6b4698ba 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -330,86 +330,6 @@ static void cpsw_ndo_set_rx_mode(struct net_device *ndev)
 			       cpsw_del_mc_addr);
 }
 
-void cpsw_intr_enable(struct cpsw_common *cpsw)
-{
-	writel_relaxed(0xFF, &cpsw->wr_regs->tx_en);
-	writel_relaxed(0xFF, &cpsw->wr_regs->rx_en);
-
-	cpdma_ctlr_int_ctrl(cpsw->dma, true);
-	return;
-}
-
-void cpsw_intr_disable(struct cpsw_common *cpsw)
-{
-	writel_relaxed(0, &cpsw->wr_regs->tx_en);
-	writel_relaxed(0, &cpsw->wr_regs->rx_en);
-
-	cpdma_ctlr_int_ctrl(cpsw->dma, false);
-	return;
-}
-
-void cpsw_tx_handler(void *token, int len, int status)
-{
-	struct netdev_queue	*txq;
-	struct sk_buff		*skb = token;
-	struct net_device	*ndev = skb->dev;
-	struct cpsw_common	*cpsw = ndev_to_cpsw(ndev);
-
-	/* Check whether the queue is stopped due to stalled tx dma, if the
-	 * queue is stopped then start the queue as we have free desc for tx
-	 */
-	txq = netdev_get_tx_queue(ndev, skb_get_queue_mapping(skb));
-	if (unlikely(netif_tx_queue_stopped(txq)))
-		netif_tx_wake_queue(txq);
-
-	cpts_tx_timestamp(cpsw->cpts, skb);
-	ndev->stats.tx_packets++;
-	ndev->stats.tx_bytes += len;
-	dev_kfree_skb_any(skb);
-}
-
-static void cpsw_rx_vlan_encap(struct sk_buff *skb)
-{
-	struct cpsw_priv *priv = netdev_priv(skb->dev);
-	struct cpsw_common *cpsw = priv->cpsw;
-	u32 rx_vlan_encap_hdr = *((u32 *)skb->data);
-	u16 vtag, vid, prio, pkt_type;
-
-	/* Remove VLAN header encapsulation word */
-	skb_pull(skb, CPSW_RX_VLAN_ENCAP_HDR_SIZE);
-
-	pkt_type = (rx_vlan_encap_hdr >>
-		    CPSW_RX_VLAN_ENCAP_HDR_PKT_TYPE_SHIFT) &
-		    CPSW_RX_VLAN_ENCAP_HDR_PKT_TYPE_MSK;
-	/* Ignore unknown & Priority-tagged packets*/
-	if (pkt_type == CPSW_RX_VLAN_ENCAP_HDR_PKT_RESERV ||
-	    pkt_type == CPSW_RX_VLAN_ENCAP_HDR_PKT_PRIO_TAG)
-		return;
-
-	vid = (rx_vlan_encap_hdr >>
-	       CPSW_RX_VLAN_ENCAP_HDR_VID_SHIFT) &
-	       VLAN_VID_MASK;
-	/* Ignore vid 0 and pass packet as is */
-	if (!vid)
-		return;
-
-	/* Untag P0 packets if set for vlan */
-	if (!cpsw_ale_get_vlan_p0_untag(cpsw->ale, vid)) {
-		prio = (rx_vlan_encap_hdr >>
-			CPSW_RX_VLAN_ENCAP_HDR_PRIO_SHIFT) &
-			CPSW_RX_VLAN_ENCAP_HDR_PRIO_MSK;
-
-		vtag = (prio << VLAN_PRIO_SHIFT) | vid;
-		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vtag);
-	}
-
-	/* strip vlan tag for VLAN-tagged packet */
-	if (pkt_type == CPSW_RX_VLAN_ENCAP_HDR_PKT_VLAN_TAG) {
-		memmove(skb->data + VLAN_HLEN, skb->data, 2 * ETH_ALEN);
-		skb_pull(skb, VLAN_HLEN);
-	}
-}
-
 static void cpsw_rx_handler(void *token, int len, int status)
 {
 	struct cpdma_chan	*ch;
@@ -476,274 +396,6 @@ static void cpsw_rx_handler(void *token, int len, int status)
 	}
 }
 
-void cpsw_split_res(struct cpsw_common *cpsw)
-{
-	u32 consumed_rate = 0, bigest_rate = 0;
-	struct cpsw_vector *txv = cpsw->txv;
-	int i, ch_weight, rlim_ch_num = 0;
-	int budget, bigest_rate_ch = 0;
-	u32 ch_rate, max_rate;
-	int ch_budget = 0;
-
-	for (i = 0; i < cpsw->tx_ch_num; i++) {
-		ch_rate = cpdma_chan_get_rate(txv[i].ch);
-		if (!ch_rate)
-			continue;
-
-		rlim_ch_num++;
-		consumed_rate += ch_rate;
-	}
-
-	if (cpsw->tx_ch_num == rlim_ch_num) {
-		max_rate = consumed_rate;
-	} else if (!rlim_ch_num) {
-		ch_budget = CPSW_POLL_WEIGHT / cpsw->tx_ch_num;
-		bigest_rate = 0;
-		max_rate = consumed_rate;
-	} else {
-		max_rate = cpsw->speed * 1000;
-
-		/* if max_rate is less then expected due to reduced link speed,
-		 * split proportionally according next potential max speed
-		 */
-		if (max_rate < consumed_rate)
-			max_rate *= 10;
-
-		if (max_rate < consumed_rate)
-			max_rate *= 10;
-
-		ch_budget = (consumed_rate * CPSW_POLL_WEIGHT) / max_rate;
-		ch_budget = (CPSW_POLL_WEIGHT - ch_budget) /
-			    (cpsw->tx_ch_num - rlim_ch_num);
-		bigest_rate = (max_rate - consumed_rate) /
-			      (cpsw->tx_ch_num - rlim_ch_num);
-	}
-
-	/* split tx weight/budget */
-	budget = CPSW_POLL_WEIGHT;
-	for (i = 0; i < cpsw->tx_ch_num; i++) {
-		ch_rate = cpdma_chan_get_rate(txv[i].ch);
-		if (ch_rate) {
-			txv[i].budget = (ch_rate * CPSW_POLL_WEIGHT) / max_rate;
-			if (!txv[i].budget)
-				txv[i].budget++;
-			if (ch_rate > bigest_rate) {
-				bigest_rate_ch = i;
-				bigest_rate = ch_rate;
-			}
-
-			ch_weight = (ch_rate * 100) / max_rate;
-			if (!ch_weight)
-				ch_weight++;
-			cpdma_chan_set_weight(cpsw->txv[i].ch, ch_weight);
-		} else {
-			txv[i].budget = ch_budget;
-			if (!bigest_rate_ch)
-				bigest_rate_ch = i;
-			cpdma_chan_set_weight(cpsw->txv[i].ch, 0);
-		}
-
-		budget -= txv[i].budget;
-	}
-
-	if (budget)
-		txv[bigest_rate_ch].budget += budget;
-
-	/* split rx budget */
-	budget = CPSW_POLL_WEIGHT;
-	ch_budget = budget / cpsw->rx_ch_num;
-	for (i = 0; i < cpsw->rx_ch_num; i++) {
-		cpsw->rxv[i].budget = ch_budget;
-		budget -= ch_budget;
-	}
-
-	if (budget)
-		cpsw->rxv[0].budget += budget;
-}
-
-static irqreturn_t cpsw_tx_interrupt(int irq, void *dev_id)
-{
-	struct cpsw_common *cpsw = dev_id;
-
-	writel(0, &cpsw->wr_regs->tx_en);
-	cpdma_ctlr_eoi(cpsw->dma, CPDMA_EOI_TX);
-
-	if (cpsw->quirk_irq) {
-		disable_irq_nosync(cpsw->irqs_table[1]);
-		cpsw->tx_irq_disabled = true;
-	}
-
-	napi_schedule(&cpsw->napi_tx);
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t cpsw_rx_interrupt(int irq, void *dev_id)
-{
-	struct cpsw_common *cpsw = dev_id;
-
-	cpdma_ctlr_eoi(cpsw->dma, CPDMA_EOI_RX);
-	writel(0, &cpsw->wr_regs->rx_en);
-
-	if (cpsw->quirk_irq) {
-		disable_irq_nosync(cpsw->irqs_table[0]);
-		cpsw->rx_irq_disabled = true;
-	}
-
-	napi_schedule(&cpsw->napi_rx);
-	return IRQ_HANDLED;
-}
-
-static int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget)
-{
-	u32			ch_map;
-	int			num_tx, cur_budget, ch;
-	struct cpsw_common	*cpsw = napi_to_cpsw(napi_tx);
-	struct cpsw_vector	*txv;
-
-	/* process every unprocessed channel */
-	ch_map = cpdma_ctrl_txchs_state(cpsw->dma);
-	for (ch = 0, num_tx = 0; ch_map & 0xff; ch_map <<= 1, ch++) {
-		if (!(ch_map & 0x80))
-			continue;
-
-		txv = &cpsw->txv[ch];
-		if (unlikely(txv->budget > budget - num_tx))
-			cur_budget = budget - num_tx;
-		else
-			cur_budget = txv->budget;
-
-		num_tx += cpdma_chan_process(txv->ch, cur_budget);
-		if (num_tx >= budget)
-			break;
-	}
-
-	if (num_tx < budget) {
-		napi_complete(napi_tx);
-		writel(0xff, &cpsw->wr_regs->tx_en);
-	}
-
-	return num_tx;
-}
-
-static int cpsw_tx_poll(struct napi_struct *napi_tx, int budget)
-{
-	struct cpsw_common *cpsw = napi_to_cpsw(napi_tx);
-	int num_tx;
-
-	num_tx = cpdma_chan_process(cpsw->txv[0].ch, budget);
-	if (num_tx < budget) {
-		napi_complete(napi_tx);
-		writel(0xff, &cpsw->wr_regs->tx_en);
-		if (cpsw->tx_irq_disabled) {
-			cpsw->tx_irq_disabled = false;
-			enable_irq(cpsw->irqs_table[1]);
-		}
-	}
-
-	return num_tx;
-}
-
-static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
-{
-	u32			ch_map;
-	int			num_rx, cur_budget, ch;
-	struct cpsw_common	*cpsw = napi_to_cpsw(napi_rx);
-	struct cpsw_vector	*rxv;
-
-	/* process every unprocessed channel */
-	ch_map = cpdma_ctrl_rxchs_state(cpsw->dma);
-	for (ch = 0, num_rx = 0; ch_map; ch_map >>= 1, ch++) {
-		if (!(ch_map & 0x01))
-			continue;
-
-		rxv = &cpsw->rxv[ch];
-		if (unlikely(rxv->budget > budget - num_rx))
-			cur_budget = budget - num_rx;
-		else
-			cur_budget = rxv->budget;
-
-		num_rx += cpdma_chan_process(rxv->ch, cur_budget);
-		if (num_rx >= budget)
-			break;
-	}
-
-	if (num_rx < budget) {
-		napi_complete_done(napi_rx, num_rx);
-		writel(0xff, &cpsw->wr_regs->rx_en);
-	}
-
-	return num_rx;
-}
-
-static int cpsw_rx_poll(struct napi_struct *napi_rx, int budget)
-{
-	struct cpsw_common *cpsw = napi_to_cpsw(napi_rx);
-	int num_rx;
-
-	num_rx = cpdma_chan_process(cpsw->rxv[0].ch, budget);
-	if (num_rx < budget) {
-		napi_complete_done(napi_rx, num_rx);
-		writel(0xff, &cpsw->wr_regs->rx_en);
-		if (cpsw->rx_irq_disabled) {
-			cpsw->rx_irq_disabled = false;
-			enable_irq(cpsw->irqs_table[0]);
-		}
-	}
-
-	return num_rx;
-}
-
-static inline void soft_reset(const char *module, void __iomem *reg)
-{
-	unsigned long timeout = jiffies + HZ;
-
-	writel_relaxed(1, reg);
-	do {
-		cpu_relax();
-	} while ((readl_relaxed(reg) & 1) && time_after(timeout, jiffies));
-
-	WARN(readl_relaxed(reg) & 1, "failed to soft-reset %s\n", module);
-}
-
-static void cpsw_set_slave_mac(struct cpsw_slave *slave,
-			       struct cpsw_priv *priv)
-{
-	slave_write(slave, mac_hi(priv->mac_addr), SA_HI);
-	slave_write(slave, mac_lo(priv->mac_addr), SA_LO);
-}
-
-static bool cpsw_shp_is_off(struct cpsw_priv *priv)
-{
-	struct cpsw_common *cpsw = priv->cpsw;
-	struct cpsw_slave *slave;
-	u32 shift, mask, val;
-
-	val = readl_relaxed(&cpsw->regs->ptype);
-
-	slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
-	shift = CPSW_FIFO_SHAPE_EN_SHIFT + 3 * slave->slave_num;
-	mask = 7 << shift;
-	val = val & mask;
-
-	return !val;
-}
-
-static void cpsw_fifo_shp_on(struct cpsw_priv *priv, int fifo, int on)
-{
-	struct cpsw_common *cpsw = priv->cpsw;
-	struct cpsw_slave *slave;
-	u32 shift, mask, val;
-
-	val = readl_relaxed(&cpsw->regs->ptype);
-
-	slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
-	shift = CPSW_FIFO_SHAPE_EN_SHIFT + 3 * slave->slave_num;
-	mask = (1 << --fifo) << shift;
-	val = on ? val | mask : val & ~mask;
-
-	writel_relaxed(val, &cpsw->regs->ptype);
-}
-
 static void _cpsw_adjust_link(struct cpsw_slave *slave,
 			      struct cpsw_priv *priv, bool *link)
 {
@@ -809,44 +461,6 @@ static void _cpsw_adjust_link(struct cpsw_slave *slave,
 	slave->mac_control = mac_control;
 }
 
-static int cpsw_get_common_speed(struct cpsw_common *cpsw)
-{
-	int i, speed;
-
-	for (i = 0, speed = 0; i < cpsw->data.slaves; i++)
-		if (cpsw->slaves[i].phy && cpsw->slaves[i].phy->link)
-			speed += cpsw->slaves[i].phy->speed;
-
-	return speed;
-}
-
-static int cpsw_need_resplit(struct cpsw_common *cpsw)
-{
-	int i, rlim_ch_num;
-	int speed, ch_rate;
-
-	/* re-split resources only in case speed was changed */
-	speed = cpsw_get_common_speed(cpsw);
-	if (speed == cpsw->speed || !speed)
-		return 0;
-
-	cpsw->speed = speed;
-
-	for (i = 0, rlim_ch_num = 0; i < cpsw->tx_ch_num; i++) {
-		ch_rate = cpdma_chan_get_rate(cpsw->txv[i].ch);
-		if (!ch_rate)
-			break;
-
-		rlim_ch_num++;
-	}
-
-	/* cases not dependent on speed */
-	if (!rlim_ch_num || rlim_ch_num == cpsw->tx_ch_num)
-		return 0;
-
-	return 1;
-}
-
 static void cpsw_adjust_link(struct net_device *ndev)
 {
 	struct cpsw_priv	*priv = netdev_priv(ndev);
@@ -1039,45 +653,6 @@ static void cpsw_init_host_port(struct cpsw_priv *priv)
 	}
 }
 
-int cpsw_fill_rx_channels(struct cpsw_priv *priv)
-{
-	struct cpsw_common *cpsw = priv->cpsw;
-	struct sk_buff *skb;
-	int ch_buf_num;
-	int ch, i, ret;
-
-	for (ch = 0; ch < cpsw->rx_ch_num; ch++) {
-		ch_buf_num = cpdma_chan_get_rx_buf_num(cpsw->rxv[ch].ch);
-		for (i = 0; i < ch_buf_num; i++) {
-			skb = __netdev_alloc_skb_ip_align(priv->ndev,
-							  cpsw->rx_packet_max,
-							  GFP_KERNEL);
-			if (!skb) {
-				cpsw_err(priv, ifup, "cannot allocate skb\n");
-				return -ENOMEM;
-			}
-
-			skb_set_queue_mapping(skb, ch);
-			ret = cpdma_chan_idle_submit(cpsw->rxv[ch].ch, skb,
-						     skb->data,
-						     skb_tailroom(skb), 0);
-			if (ret < 0) {
-				cpsw_err(priv, ifup,
-					 "cannot submit skb to channel %d rx, error %d\n",
-					 ch, ret);
-				kfree_skb(skb);
-				return ret;
-			}
-			kmemleak_not_leak(skb);
-		}
-
-		cpsw_info(priv, ifup, "ch %d rx, submitted %d descriptors\n",
-			  ch, ch_buf_num);
-	}
-
-	return 0;
-}
-
 static void cpsw_slave_stop(struct cpsw_slave *slave, struct cpsw_common *cpsw)
 {
 	u32 slave_port;
@@ -1095,221 +670,6 @@ static void cpsw_slave_stop(struct cpsw_slave *slave, struct cpsw_common *cpsw)
 	cpsw_sl_ctl_reset(slave->mac_sl);
 }
 
-static int cpsw_tc_to_fifo(int tc, int num_tc)
-{
-	if (tc == num_tc - 1)
-		return 0;
-
-	return CPSW_FIFO_SHAPERS_NUM - tc;
-}
-
-static int cpsw_set_fifo_bw(struct cpsw_priv *priv, int fifo, int bw)
-{
-	struct cpsw_common *cpsw = priv->cpsw;
-	u32 val = 0, send_pct, shift;
-	struct cpsw_slave *slave;
-	int pct = 0, i;
-
-	if (bw > priv->shp_cfg_speed * 1000)
-		goto err;
-
-	/* shaping has to stay enabled for highest fifos linearly
-	 * and fifo bw no more then interface can allow
-	 */
-	slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
-	send_pct = slave_read(slave, SEND_PERCENT);
-	for (i = CPSW_FIFO_SHAPERS_NUM; i > 0; i--) {
-		if (!bw) {
-			if (i >= fifo || !priv->fifo_bw[i])
-				continue;
-
-			dev_warn(priv->dev, "Prev FIFO%d is shaped", i);
-			continue;
-		}
-
-		if (!priv->fifo_bw[i] && i > fifo) {
-			dev_err(priv->dev, "Upper FIFO%d is not shaped", i);
-			return -EINVAL;
-		}
-
-		shift = (i - 1) * 8;
-		if (i == fifo) {
-			send_pct &= ~(CPSW_PCT_MASK << shift);
-			val = DIV_ROUND_UP(bw, priv->shp_cfg_speed * 10);
-			if (!val)
-				val = 1;
-
-			send_pct |= val << shift;
-			pct += val;
-			continue;
-		}
-
-		if (priv->fifo_bw[i])
-			pct += (send_pct >> shift) & CPSW_PCT_MASK;
-	}
-
-	if (pct >= 100)
-		goto err;
-
-	slave_write(slave, send_pct, SEND_PERCENT);
-	priv->fifo_bw[fifo] = bw;
-
-	dev_warn(priv->dev, "set FIFO%d bw = %d\n", fifo,
-		 DIV_ROUND_CLOSEST(val * priv->shp_cfg_speed, 100));
-
-	return 0;
-err:
-	dev_err(priv->dev, "Bandwidth doesn't fit in tc configuration");
-	return -EINVAL;
-}
-
-static int cpsw_set_fifo_rlimit(struct cpsw_priv *priv, int fifo, int bw)
-{
-	struct cpsw_common *cpsw = priv->cpsw;
-	struct cpsw_slave *slave;
-	u32 tx_in_ctl_rg, val;
-	int ret;
-
-	ret = cpsw_set_fifo_bw(priv, fifo, bw);
-	if (ret)
-		return ret;
-
-	slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
-	tx_in_ctl_rg = cpsw->version == CPSW_VERSION_1 ?
-		       CPSW1_TX_IN_CTL : CPSW2_TX_IN_CTL;
-
-	if (!bw)
-		cpsw_fifo_shp_on(priv, fifo, bw);
-
-	val = slave_read(slave, tx_in_ctl_rg);
-	if (cpsw_shp_is_off(priv)) {
-		/* disable FIFOs rate limited queues */
-		val &= ~(0xf << CPSW_FIFO_RATE_EN_SHIFT);
-
-		/* set type of FIFO queues to normal priority mode */
-		val &= ~(3 << CPSW_FIFO_QUEUE_TYPE_SHIFT);
-
-		/* set type of FIFO queues to be rate limited */
-		if (bw)
-			val |= 2 << CPSW_FIFO_QUEUE_TYPE_SHIFT;
-		else
-			priv->shp_cfg_speed = 0;
-	}
-
-	/* toggle a FIFO rate limited queue */
-	if (bw)
-		val |= BIT(fifo + CPSW_FIFO_RATE_EN_SHIFT);
-	else
-		val &= ~BIT(fifo + CPSW_FIFO_RATE_EN_SHIFT);
-	slave_write(slave, val, tx_in_ctl_rg);
-
-	/* FIFO transmit shape enable */
-	cpsw_fifo_shp_on(priv, fifo, bw);
-	return 0;
-}
-
-/* Defaults:
- * class A - prio 3
- * class B - prio 2
- * shaping for class A should be set first
- */
-static int cpsw_set_cbs(struct net_device *ndev,
-			struct tc_cbs_qopt_offload *qopt)
-{
-	struct cpsw_priv *priv = netdev_priv(ndev);
-	struct cpsw_common *cpsw = priv->cpsw;
-	struct cpsw_slave *slave;
-	int prev_speed = 0;
-	int tc, ret, fifo;
-	u32 bw = 0;
-
-	tc = netdev_txq_to_tc(priv->ndev, qopt->queue);
-
-	/* enable channels in backward order, as highest FIFOs must be rate
-	 * limited first and for compliance with CPDMA rate limited channels
-	 * that also used in bacward order. FIFO0 cannot be rate limited.
-	 */
-	fifo = cpsw_tc_to_fifo(tc, ndev->num_tc);
-	if (!fifo) {
-		dev_err(priv->dev, "Last tc%d can't be rate limited", tc);
-		return -EINVAL;
-	}
-
-	/* do nothing, it's disabled anyway */
-	if (!qopt->enable && !priv->fifo_bw[fifo])
-		return 0;
-
-	/* shapers can be set if link speed is known */
-	slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
-	if (slave->phy && slave->phy->link) {
-		if (priv->shp_cfg_speed &&
-		    priv->shp_cfg_speed != slave->phy->speed)
-			prev_speed = priv->shp_cfg_speed;
-
-		priv->shp_cfg_speed = slave->phy->speed;
-	}
-
-	if (!priv->shp_cfg_speed) {
-		dev_err(priv->dev, "Link speed is not known");
-		return -1;
-	}
-
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(cpsw->dev);
-		return ret;
-	}
-
-	bw = qopt->enable ? qopt->idleslope : 0;
-	ret = cpsw_set_fifo_rlimit(priv, fifo, bw);
-	if (ret) {
-		priv->shp_cfg_speed = prev_speed;
-		prev_speed = 0;
-	}
-
-	if (bw && prev_speed)
-		dev_warn(priv->dev,
-			 "Speed was changed, CBS shaper speeds are changed!");
-
-	pm_runtime_put_sync(cpsw->dev);
-	return ret;
-}
-
-static void cpsw_cbs_resume(struct cpsw_slave *slave, struct cpsw_priv *priv)
-{
-	int fifo, bw;
-
-	for (fifo = CPSW_FIFO_SHAPERS_NUM; fifo > 0; fifo--) {
-		bw = priv->fifo_bw[fifo];
-		if (!bw)
-			continue;
-
-		cpsw_set_fifo_rlimit(priv, fifo, bw);
-	}
-}
-
-static void cpsw_mqprio_resume(struct cpsw_slave *slave, struct cpsw_priv *priv)
-{
-	struct cpsw_common *cpsw = priv->cpsw;
-	u32 tx_prio_map = 0;
-	int i, tc, fifo;
-	u32 tx_prio_rg;
-
-	if (!priv->mqprio_hw)
-		return;
-
-	for (i = 0; i < 8; i++) {
-		tc = netdev_get_prio_tc_map(priv->ndev, i);
-		fifo = CPSW_FIFO_SHAPERS_NUM - tc;
-		tx_prio_map |= fifo << (4 * i);
-	}
-
-	tx_prio_rg = cpsw->version == CPSW_VERSION_1 ?
-		     CPSW1_TX_PRI_MAP : CPSW2_TX_PRI_MAP;
-
-	slave_write(slave, tx_prio_map, tx_prio_rg);
-}
-
 static int cpsw_restore_vlans(struct net_device *vdev, int vid, void *arg)
 {
 	struct cpsw_priv *priv = arg;
@@ -1529,207 +889,6 @@ static netdev_tx_t cpsw_ndo_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_BUSY;
 }
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
-
-static void cpsw_hwtstamp_v1(struct cpsw_priv *priv)
-{
-	struct cpsw_common *cpsw = priv->cpsw;
-	struct cpsw_slave *slave = &cpsw->slaves[cpsw->data.active_slave];
-	u32 ts_en, seq_id;
-
-	if (!priv->tx_ts_enabled && !priv->rx_ts_enabled) {
-		slave_write(slave, 0, CPSW1_TS_CTL);
-		return;
-	}
-
-	seq_id = (30 << CPSW_V1_SEQ_ID_OFS_SHIFT) | ETH_P_1588;
-	ts_en = EVENT_MSG_BITS << CPSW_V1_MSG_TYPE_OFS;
-
-	if (priv->tx_ts_enabled)
-		ts_en |= CPSW_V1_TS_TX_EN;
-
-	if (priv->rx_ts_enabled)
-		ts_en |= CPSW_V1_TS_RX_EN;
-
-	slave_write(slave, ts_en, CPSW1_TS_CTL);
-	slave_write(slave, seq_id, CPSW1_TS_SEQ_LTYPE);
-}
-
-static void cpsw_hwtstamp_v2(struct cpsw_priv *priv)
-{
-	struct cpsw_slave *slave;
-	struct cpsw_common *cpsw = priv->cpsw;
-	u32 ctrl, mtype;
-
-	slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
-
-	ctrl = slave_read(slave, CPSW2_CONTROL);
-	switch (cpsw->version) {
-	case CPSW_VERSION_2:
-		ctrl &= ~CTRL_V2_ALL_TS_MASK;
-
-		if (priv->tx_ts_enabled)
-			ctrl |= CTRL_V2_TX_TS_BITS;
-
-		if (priv->rx_ts_enabled)
-			ctrl |= CTRL_V2_RX_TS_BITS;
-		break;
-	case CPSW_VERSION_3:
-	default:
-		ctrl &= ~CTRL_V3_ALL_TS_MASK;
-
-		if (priv->tx_ts_enabled)
-			ctrl |= CTRL_V3_TX_TS_BITS;
-
-		if (priv->rx_ts_enabled)
-			ctrl |= CTRL_V3_RX_TS_BITS;
-		break;
-	}
-
-	mtype = (30 << TS_SEQ_ID_OFFSET_SHIFT) | EVENT_MSG_BITS;
-
-	slave_write(slave, mtype, CPSW2_TS_SEQ_MTYPE);
-	slave_write(slave, ctrl, CPSW2_CONTROL);
-	writel_relaxed(ETH_P_1588, &cpsw->regs->ts_ltype);
-	writel_relaxed(ETH_P_8021Q, &cpsw->regs->vlan_ltype);
-}
-
-static int cpsw_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
-{
-	struct cpsw_priv *priv = netdev_priv(dev);
-	struct hwtstamp_config cfg;
-	struct cpsw_common *cpsw = priv->cpsw;
-
-	if (cpsw->version != CPSW_VERSION_1 &&
-	    cpsw->version != CPSW_VERSION_2 &&
-	    cpsw->version != CPSW_VERSION_3)
-		return -EOPNOTSUPP;
-
-	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
-		return -EFAULT;
-
-	/* reserved for future extensions */
-	if (cfg.flags)
-		return -EINVAL;
-
-	if (cfg.tx_type != HWTSTAMP_TX_OFF && cfg.tx_type != HWTSTAMP_TX_ON)
-		return -ERANGE;
-
-	switch (cfg.rx_filter) {
-	case HWTSTAMP_FILTER_NONE:
-		priv->rx_ts_enabled = 0;
-		break;
-	case HWTSTAMP_FILTER_ALL:
-	case HWTSTAMP_FILTER_NTP_ALL:
-		return -ERANGE;
-	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
-	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
-	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
-		priv->rx_ts_enabled = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
-		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
-		break;
-	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
-	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
-	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
-	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
-	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
-	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
-	case HWTSTAMP_FILTER_PTP_V2_EVENT:
-	case HWTSTAMP_FILTER_PTP_V2_SYNC:
-	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
-		priv->rx_ts_enabled = HWTSTAMP_FILTER_PTP_V2_EVENT;
-		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
-		break;
-	default:
-		return -ERANGE;
-	}
-
-	priv->tx_ts_enabled = cfg.tx_type == HWTSTAMP_TX_ON;
-
-	switch (cpsw->version) {
-	case CPSW_VERSION_1:
-		cpsw_hwtstamp_v1(priv);
-		break;
-	case CPSW_VERSION_2:
-	case CPSW_VERSION_3:
-		cpsw_hwtstamp_v2(priv);
-		break;
-	default:
-		WARN_ON(1);
-	}
-
-	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
-}
-
-static int cpsw_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
-{
-	struct cpsw_common *cpsw = ndev_to_cpsw(dev);
-	struct cpsw_priv *priv = netdev_priv(dev);
-	struct hwtstamp_config cfg;
-
-	if (cpsw->version != CPSW_VERSION_1 &&
-	    cpsw->version != CPSW_VERSION_2 &&
-	    cpsw->version != CPSW_VERSION_3)
-		return -EOPNOTSUPP;
-
-	cfg.flags = 0;
-	cfg.tx_type = priv->tx_ts_enabled ? HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
-	cfg.rx_filter = priv->rx_ts_enabled;
-
-	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
-}
-#else
-static int cpsw_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
-{
-	return -EOPNOTSUPP;
-}
-
-static int cpsw_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
-{
-	return -EOPNOTSUPP;
-}
-#endif /*CONFIG_TI_CPTS*/
-
-static int cpsw_ndo_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
-{
-	struct cpsw_priv *priv = netdev_priv(dev);
-	struct cpsw_common *cpsw = priv->cpsw;
-	int slave_no = cpsw_slave_index(cpsw, priv);
-
-	if (!netif_running(dev))
-		return -EINVAL;
-
-	switch (cmd) {
-	case SIOCSHWTSTAMP:
-		return cpsw_hwtstamp_set(dev, req);
-	case SIOCGHWTSTAMP:
-		return cpsw_hwtstamp_get(dev, req);
-	}
-
-	if (!cpsw->slaves[slave_no].phy)
-		return -EOPNOTSUPP;
-	return phy_mii_ioctl(cpsw->slaves[slave_no].phy, req, cmd);
-}
-
-static void cpsw_ndo_tx_timeout(struct net_device *ndev)
-{
-	struct cpsw_priv *priv = netdev_priv(ndev);
-	struct cpsw_common *cpsw = priv->cpsw;
-	int ch;
-
-	cpsw_err(priv, tx_err, "transmit timeout, restarting dma\n");
-	ndev->stats.tx_errors++;
-	cpsw_intr_disable(cpsw);
-	for (ch = 0; ch < cpsw->tx_ch_num; ch++) {
-		cpdma_chan_stop(cpsw->txv[ch].ch);
-		cpdma_chan_start(cpsw->txv[ch].ch);
-	}
-
-	cpsw_intr_enable(cpsw);
-	netif_trans_update(ndev);
-	netif_tx_wake_all_queues(ndev);
-}
-
 static int cpsw_ndo_set_mac_address(struct net_device *ndev, void *p)
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
@@ -1891,129 +1050,6 @@ static int cpsw_ndo_vlan_rx_kill_vid(struct net_device *ndev,
 	return ret;
 }
 
-static int cpsw_ndo_set_tx_maxrate(struct net_device *ndev, int queue, u32 rate)
-{
-	struct cpsw_priv *priv = netdev_priv(ndev);
-	struct cpsw_common *cpsw = priv->cpsw;
-	struct cpsw_slave *slave;
-	u32 min_rate;
-	u32 ch_rate;
-	int i, ret;
-
-	ch_rate = netdev_get_tx_queue(ndev, queue)->tx_maxrate;
-	if (ch_rate == rate)
-		return 0;
-
-	ch_rate = rate * 1000;
-	min_rate = cpdma_chan_get_min_rate(cpsw->dma);
-	if ((ch_rate < min_rate && ch_rate)) {
-		dev_err(priv->dev, "The channel rate cannot be less than %dMbps",
-			min_rate);
-		return -EINVAL;
-	}
-
-	if (rate > cpsw->speed) {
-		dev_err(priv->dev, "The channel rate cannot be more than 2Gbps");
-		return -EINVAL;
-	}
-
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(cpsw->dev);
-		return ret;
-	}
-
-	ret = cpdma_chan_set_rate(cpsw->txv[queue].ch, ch_rate);
-	pm_runtime_put(cpsw->dev);
-
-	if (ret)
-		return ret;
-
-	/* update rates for slaves tx queues */
-	for (i = 0; i < cpsw->data.slaves; i++) {
-		slave = &cpsw->slaves[i];
-		if (!slave->ndev)
-			continue;
-
-		netdev_get_tx_queue(slave->ndev, queue)->tx_maxrate = rate;
-	}
-
-	cpsw_split_res(cpsw);
-	return ret;
-}
-
-static int cpsw_set_mqprio(struct net_device *ndev, void *type_data)
-{
-	struct tc_mqprio_qopt_offload *mqprio = type_data;
-	struct cpsw_priv *priv = netdev_priv(ndev);
-	struct cpsw_common *cpsw = priv->cpsw;
-	int fifo, num_tc, count, offset;
-	struct cpsw_slave *slave;
-	u32 tx_prio_map = 0;
-	int i, tc, ret;
-
-	num_tc = mqprio->qopt.num_tc;
-	if (num_tc > CPSW_TC_NUM)
-		return -EINVAL;
-
-	if (mqprio->mode != TC_MQPRIO_MODE_DCB)
-		return -EINVAL;
-
-	ret = pm_runtime_get_sync(cpsw->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(cpsw->dev);
-		return ret;
-	}
-
-	if (num_tc) {
-		for (i = 0; i < 8; i++) {
-			tc = mqprio->qopt.prio_tc_map[i];
-			fifo = cpsw_tc_to_fifo(tc, num_tc);
-			tx_prio_map |= fifo << (4 * i);
-		}
-
-		netdev_set_num_tc(ndev, num_tc);
-		for (i = 0; i < num_tc; i++) {
-			count = mqprio->qopt.count[i];
-			offset = mqprio->qopt.offset[i];
-			netdev_set_tc_queue(ndev, i, count, offset);
-		}
-	}
-
-	if (!mqprio->qopt.hw) {
-		/* restore default configuration */
-		netdev_reset_tc(ndev);
-		tx_prio_map = TX_PRIORITY_MAPPING;
-	}
-
-	priv->mqprio_hw = mqprio->qopt.hw;
-
-	offset = cpsw->version == CPSW_VERSION_1 ?
-		 CPSW1_TX_PRI_MAP : CPSW2_TX_PRI_MAP;
-
-	slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
-	slave_write(slave, tx_prio_map, offset);
-
-	pm_runtime_put_sync(cpsw->dev);
-
-	return 0;
-}
-
-static int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
-			     void *type_data)
-{
-	switch (type) {
-	case TC_SETUP_QDISC_CBS:
-		return cpsw_set_cbs(ndev, type_data);
-
-	case TC_SETUP_QDISC_MQPRIO:
-		return cpsw_set_mqprio(ndev, type_data);
-
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void cpsw_ndo_poll_controller(struct net_device *ndev)
 {
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index a1c83af64835..2f18401eaa79 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -7,12 +7,17 @@
 
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
+#include <linux/kmemleak.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/skbuff.h>
+#include <net/pkt_cls.h>
 
+#include "cpsw.h"
 #include "cpts.h"
 #include "cpsw_ale.h"
 #include "cpsw_priv.h"
@@ -21,6 +26,415 @@
 
 int (*cpsw_slave_index)(struct cpsw_common *cpsw, struct cpsw_priv *priv);
 
+void cpsw_intr_enable(struct cpsw_common *cpsw)
+{
+	writel_relaxed(0xFF, &cpsw->wr_regs->tx_en);
+	writel_relaxed(0xFF, &cpsw->wr_regs->rx_en);
+
+	cpdma_ctlr_int_ctrl(cpsw->dma, true);
+}
+
+void cpsw_intr_disable(struct cpsw_common *cpsw)
+{
+	writel_relaxed(0, &cpsw->wr_regs->tx_en);
+	writel_relaxed(0, &cpsw->wr_regs->rx_en);
+
+	cpdma_ctlr_int_ctrl(cpsw->dma, false);
+}
+
+void cpsw_tx_handler(void *token, int len, int status)
+{
+	struct netdev_queue	*txq;
+	struct sk_buff		*skb = token;
+	struct net_device	*ndev = skb->dev;
+	struct cpsw_common	*cpsw = ndev_to_cpsw(ndev);
+
+	/* Check whether the queue is stopped due to stalled tx dma, if the
+	 * queue is stopped then start the queue as we have free desc for tx
+	 */
+	txq = netdev_get_tx_queue(ndev, skb_get_queue_mapping(skb));
+	if (unlikely(netif_tx_queue_stopped(txq)))
+		netif_tx_wake_queue(txq);
+
+	cpts_tx_timestamp(cpsw->cpts, skb);
+	ndev->stats.tx_packets++;
+	ndev->stats.tx_bytes += len;
+	dev_kfree_skb_any(skb);
+}
+
+irqreturn_t cpsw_tx_interrupt(int irq, void *dev_id)
+{
+	struct cpsw_common *cpsw = dev_id;
+
+	writel(0, &cpsw->wr_regs->tx_en);
+	cpdma_ctlr_eoi(cpsw->dma, CPDMA_EOI_TX);
+
+	if (cpsw->quirk_irq) {
+		disable_irq_nosync(cpsw->irqs_table[1]);
+		cpsw->tx_irq_disabled = true;
+	}
+
+	napi_schedule(&cpsw->napi_tx);
+	return IRQ_HANDLED;
+}
+
+irqreturn_t cpsw_rx_interrupt(int irq, void *dev_id)
+{
+	struct cpsw_common *cpsw = dev_id;
+
+	cpdma_ctlr_eoi(cpsw->dma, CPDMA_EOI_RX);
+	writel(0, &cpsw->wr_regs->rx_en);
+
+	if (cpsw->quirk_irq) {
+		disable_irq_nosync(cpsw->irqs_table[0]);
+		cpsw->rx_irq_disabled = true;
+	}
+
+	napi_schedule(&cpsw->napi_rx);
+	return IRQ_HANDLED;
+}
+
+int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget)
+{
+	u32			ch_map;
+	int			num_tx, cur_budget, ch;
+	struct cpsw_common	*cpsw = napi_to_cpsw(napi_tx);
+	struct cpsw_vector	*txv;
+
+	/* process every unprocessed channel */
+	ch_map = cpdma_ctrl_txchs_state(cpsw->dma);
+	for (ch = 0, num_tx = 0; ch_map & 0xff; ch_map <<= 1, ch++) {
+		if (!(ch_map & 0x80))
+			continue;
+
+		txv = &cpsw->txv[ch];
+		if (unlikely(txv->budget > budget - num_tx))
+			cur_budget = budget - num_tx;
+		else
+			cur_budget = txv->budget;
+
+		num_tx += cpdma_chan_process(txv->ch, cur_budget);
+		if (num_tx >= budget)
+			break;
+	}
+
+	if (num_tx < budget) {
+		napi_complete(napi_tx);
+		writel(0xff, &cpsw->wr_regs->tx_en);
+	}
+
+	return num_tx;
+}
+
+int cpsw_tx_poll(struct napi_struct *napi_tx, int budget)
+{
+	struct cpsw_common *cpsw = napi_to_cpsw(napi_tx);
+	int num_tx;
+
+	num_tx = cpdma_chan_process(cpsw->txv[0].ch, budget);
+	if (num_tx < budget) {
+		napi_complete(napi_tx);
+		writel(0xff, &cpsw->wr_regs->tx_en);
+		if (cpsw->tx_irq_disabled) {
+			cpsw->tx_irq_disabled = false;
+			enable_irq(cpsw->irqs_table[1]);
+		}
+	}
+
+	return num_tx;
+}
+
+int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
+{
+	u32			ch_map;
+	int			num_rx, cur_budget, ch;
+	struct cpsw_common	*cpsw = napi_to_cpsw(napi_rx);
+	struct cpsw_vector	*rxv;
+
+	/* process every unprocessed channel */
+	ch_map = cpdma_ctrl_rxchs_state(cpsw->dma);
+	for (ch = 0, num_rx = 0; ch_map; ch_map >>= 1, ch++) {
+		if (!(ch_map & 0x01))
+			continue;
+
+		rxv = &cpsw->rxv[ch];
+		if (unlikely(rxv->budget > budget - num_rx))
+			cur_budget = budget - num_rx;
+		else
+			cur_budget = rxv->budget;
+
+		num_rx += cpdma_chan_process(rxv->ch, cur_budget);
+		if (num_rx >= budget)
+			break;
+	}
+
+	if (num_rx < budget) {
+		napi_complete_done(napi_rx, num_rx);
+		writel(0xff, &cpsw->wr_regs->rx_en);
+	}
+
+	return num_rx;
+}
+
+int cpsw_rx_poll(struct napi_struct *napi_rx, int budget)
+{
+	struct cpsw_common *cpsw = napi_to_cpsw(napi_rx);
+	int num_rx;
+
+	num_rx = cpdma_chan_process(cpsw->rxv[0].ch, budget);
+	if (num_rx < budget) {
+		napi_complete_done(napi_rx, num_rx);
+		writel(0xff, &cpsw->wr_regs->rx_en);
+		if (cpsw->rx_irq_disabled) {
+			cpsw->rx_irq_disabled = false;
+			enable_irq(cpsw->irqs_table[0]);
+		}
+	}
+
+	return num_rx;
+}
+
+void cpsw_rx_vlan_encap(struct sk_buff *skb)
+{
+	struct cpsw_priv *priv = netdev_priv(skb->dev);
+	u32 rx_vlan_encap_hdr = *((u32 *)skb->data);
+	struct cpsw_common *cpsw = priv->cpsw;
+	u16 vtag, vid, prio, pkt_type;
+
+	/* Remove VLAN header encapsulation word */
+	skb_pull(skb, CPSW_RX_VLAN_ENCAP_HDR_SIZE);
+
+	pkt_type = (rx_vlan_encap_hdr >>
+		    CPSW_RX_VLAN_ENCAP_HDR_PKT_TYPE_SHIFT) &
+		    CPSW_RX_VLAN_ENCAP_HDR_PKT_TYPE_MSK;
+	/* Ignore unknown & Priority-tagged packets*/
+	if (pkt_type == CPSW_RX_VLAN_ENCAP_HDR_PKT_RESERV ||
+	    pkt_type == CPSW_RX_VLAN_ENCAP_HDR_PKT_PRIO_TAG)
+		return;
+
+	vid = (rx_vlan_encap_hdr >>
+	       CPSW_RX_VLAN_ENCAP_HDR_VID_SHIFT) &
+	       VLAN_VID_MASK;
+	/* Ignore vid 0 and pass packet as is */
+	if (!vid)
+		return;
+
+	/* Untag P0 packets if set for vlan */
+	if (!cpsw_ale_get_vlan_p0_untag(cpsw->ale, vid)) {
+		prio = (rx_vlan_encap_hdr >>
+			CPSW_RX_VLAN_ENCAP_HDR_PRIO_SHIFT) &
+			CPSW_RX_VLAN_ENCAP_HDR_PRIO_MSK;
+
+		vtag = (prio << VLAN_PRIO_SHIFT) | vid;
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vtag);
+	}
+
+	/* strip vlan tag for VLAN-tagged packet */
+	if (pkt_type == CPSW_RX_VLAN_ENCAP_HDR_PKT_VLAN_TAG) {
+		memmove(skb->data + VLAN_HLEN, skb->data, 2 * ETH_ALEN);
+		skb_pull(skb, VLAN_HLEN);
+	}
+}
+
+void cpsw_set_slave_mac(struct cpsw_slave *slave, struct cpsw_priv *priv)
+{
+	slave_write(slave, mac_hi(priv->mac_addr), SA_HI);
+	slave_write(slave, mac_lo(priv->mac_addr), SA_LO);
+}
+
+void soft_reset(const char *module, void __iomem *reg)
+{
+	unsigned long timeout = jiffies + HZ;
+
+	writel_relaxed(1, reg);
+	do {
+		cpu_relax();
+	} while ((readl_relaxed(reg) & 1) && time_after(timeout, jiffies));
+
+	WARN(readl_relaxed(reg) & 1, "failed to soft-reset %s\n", module);
+}
+
+void cpsw_ndo_tx_timeout(struct net_device *ndev)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	struct cpsw_common *cpsw = priv->cpsw;
+	int ch;
+
+	cpsw_err(priv, tx_err, "transmit timeout, restarting dma\n");
+	ndev->stats.tx_errors++;
+	cpsw_intr_disable(cpsw);
+	for (ch = 0; ch < cpsw->tx_ch_num; ch++) {
+		cpdma_chan_stop(cpsw->txv[ch].ch);
+		cpdma_chan_start(cpsw->txv[ch].ch);
+	}
+
+	cpsw_intr_enable(cpsw);
+	netif_trans_update(ndev);
+	netif_tx_wake_all_queues(ndev);
+}
+
+int cpsw_fill_rx_channels(struct cpsw_priv *priv)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	struct sk_buff *skb;
+	int ch_buf_num;
+	int ch, i, ret;
+
+	for (ch = 0; ch < cpsw->rx_ch_num; ch++) {
+		ch_buf_num = cpdma_chan_get_rx_buf_num(cpsw->rxv[ch].ch);
+		for (i = 0; i < ch_buf_num; i++) {
+			skb = __netdev_alloc_skb_ip_align(priv->ndev,
+							  cpsw->rx_packet_max,
+							  GFP_KERNEL);
+			if (!skb) {
+				cpsw_err(priv, ifup, "cannot allocate skb\n");
+				return -ENOMEM;
+			}
+
+			skb_set_queue_mapping(skb, ch);
+			ret = cpdma_chan_idle_submit(cpsw->rxv[ch].ch, skb,
+						     skb->data,
+						     skb_tailroom(skb), 0);
+			if (ret < 0) {
+				cpsw_err(priv, ifup,
+					 "cannot submit skb to channel %d rx, error %d\n",
+					 ch, ret);
+				kfree_skb(skb);
+				return ret;
+			}
+			kmemleak_not_leak(skb);
+		}
+
+		cpsw_info(priv, ifup, "ch %d rx, submitted %d descriptors\n",
+			  ch, ch_buf_num);
+	}
+
+	return 0;
+}
+
+static int cpsw_get_common_speed(struct cpsw_common *cpsw)
+{
+	int i, speed;
+
+	for (i = 0, speed = 0; i < cpsw->data.slaves; i++)
+		if (cpsw->slaves[i].phy && cpsw->slaves[i].phy->link)
+			speed += cpsw->slaves[i].phy->speed;
+
+	return speed;
+}
+
+int cpsw_need_resplit(struct cpsw_common *cpsw)
+{
+	int i, rlim_ch_num;
+	int speed, ch_rate;
+
+	/* re-split resources only in case speed was changed */
+	speed = cpsw_get_common_speed(cpsw);
+	if (speed == cpsw->speed || !speed)
+		return 0;
+
+	cpsw->speed = speed;
+
+	for (i = 0, rlim_ch_num = 0; i < cpsw->tx_ch_num; i++) {
+		ch_rate = cpdma_chan_get_rate(cpsw->txv[i].ch);
+		if (!ch_rate)
+			break;
+
+		rlim_ch_num++;
+	}
+
+	/* cases not dependent on speed */
+	if (!rlim_ch_num || rlim_ch_num == cpsw->tx_ch_num)
+		return 0;
+
+	return 1;
+}
+
+void cpsw_split_res(struct cpsw_common *cpsw)
+{
+	u32 consumed_rate = 0, bigest_rate = 0;
+	struct cpsw_vector *txv = cpsw->txv;
+	int i, ch_weight, rlim_ch_num = 0;
+	int budget, bigest_rate_ch = 0;
+	u32 ch_rate, max_rate;
+	int ch_budget = 0;
+
+	for (i = 0; i < cpsw->tx_ch_num; i++) {
+		ch_rate = cpdma_chan_get_rate(txv[i].ch);
+		if (!ch_rate)
+			continue;
+
+		rlim_ch_num++;
+		consumed_rate += ch_rate;
+	}
+
+	if (cpsw->tx_ch_num == rlim_ch_num) {
+		max_rate = consumed_rate;
+	} else if (!rlim_ch_num) {
+		ch_budget = CPSW_POLL_WEIGHT / cpsw->tx_ch_num;
+		bigest_rate = 0;
+		max_rate = consumed_rate;
+	} else {
+		max_rate = cpsw->speed * 1000;
+
+		/* if max_rate is less then expected due to reduced link speed,
+		 * split proportionally according next potential max speed
+		 */
+		if (max_rate < consumed_rate)
+			max_rate *= 10;
+
+		if (max_rate < consumed_rate)
+			max_rate *= 10;
+
+		ch_budget = (consumed_rate * CPSW_POLL_WEIGHT) / max_rate;
+		ch_budget = (CPSW_POLL_WEIGHT - ch_budget) /
+			    (cpsw->tx_ch_num - rlim_ch_num);
+		bigest_rate = (max_rate - consumed_rate) /
+			      (cpsw->tx_ch_num - rlim_ch_num);
+	}
+
+	/* split tx weight/budget */
+	budget = CPSW_POLL_WEIGHT;
+	for (i = 0; i < cpsw->tx_ch_num; i++) {
+		ch_rate = cpdma_chan_get_rate(txv[i].ch);
+		if (ch_rate) {
+			txv[i].budget = (ch_rate * CPSW_POLL_WEIGHT) / max_rate;
+			if (!txv[i].budget)
+				txv[i].budget++;
+			if (ch_rate > bigest_rate) {
+				bigest_rate_ch = i;
+				bigest_rate = ch_rate;
+			}
+
+			ch_weight = (ch_rate * 100) / max_rate;
+			if (!ch_weight)
+				ch_weight++;
+			cpdma_chan_set_weight(cpsw->txv[i].ch, ch_weight);
+		} else {
+			txv[i].budget = ch_budget;
+			if (!bigest_rate_ch)
+				bigest_rate_ch = i;
+			cpdma_chan_set_weight(cpsw->txv[i].ch, 0);
+		}
+
+		budget -= txv[i].budget;
+	}
+
+	if (budget)
+		txv[bigest_rate_ch].budget += budget;
+
+	/* split rx budget */
+	budget = CPSW_POLL_WEIGHT;
+	ch_budget = budget / cpsw->rx_ch_num;
+	for (i = 0; i < cpsw->rx_ch_num; i++) {
+		cpsw->rxv[i].budget = ch_budget;
+		budget -= ch_budget;
+	}
+
+	if (budget)
+		cpsw->rxv[0].budget += budget;
+}
+
 int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
 		     int ale_ageout, phys_addr_t desc_mem_phys,
 		     int descs_pool_size)
@@ -132,3 +546,556 @@ int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
 
 	return ret;
 }
+
+#if IS_ENABLED(CONFIG_TI_CPTS)
+
+static void cpsw_hwtstamp_v1(struct cpsw_priv *priv)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	struct cpsw_slave *slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
+	u32 ts_en, seq_id;
+
+	if (!priv->tx_ts_enabled && !priv->rx_ts_enabled) {
+		slave_write(slave, 0, CPSW1_TS_CTL);
+		return;
+	}
+
+	seq_id = (30 << CPSW_V1_SEQ_ID_OFS_SHIFT) | ETH_P_1588;
+	ts_en = EVENT_MSG_BITS << CPSW_V1_MSG_TYPE_OFS;
+
+	if (priv->tx_ts_enabled)
+		ts_en |= CPSW_V1_TS_TX_EN;
+
+	if (priv->rx_ts_enabled)
+		ts_en |= CPSW_V1_TS_RX_EN;
+
+	slave_write(slave, ts_en, CPSW1_TS_CTL);
+	slave_write(slave, seq_id, CPSW1_TS_SEQ_LTYPE);
+}
+
+static void cpsw_hwtstamp_v2(struct cpsw_priv *priv)
+{
+	struct cpsw_slave *slave;
+	struct cpsw_common *cpsw = priv->cpsw;
+	u32 ctrl, mtype;
+
+	slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
+
+	ctrl = slave_read(slave, CPSW2_CONTROL);
+	switch (cpsw->version) {
+	case CPSW_VERSION_2:
+		ctrl &= ~CTRL_V2_ALL_TS_MASK;
+
+		if (priv->tx_ts_enabled)
+			ctrl |= CTRL_V2_TX_TS_BITS;
+
+		if (priv->rx_ts_enabled)
+			ctrl |= CTRL_V2_RX_TS_BITS;
+		break;
+	case CPSW_VERSION_3:
+	default:
+		ctrl &= ~CTRL_V3_ALL_TS_MASK;
+
+		if (priv->tx_ts_enabled)
+			ctrl |= CTRL_V3_TX_TS_BITS;
+
+		if (priv->rx_ts_enabled)
+			ctrl |= CTRL_V3_RX_TS_BITS;
+		break;
+	}
+
+	mtype = (30 << TS_SEQ_ID_OFFSET_SHIFT) | EVENT_MSG_BITS;
+
+	slave_write(slave, mtype, CPSW2_TS_SEQ_MTYPE);
+	slave_write(slave, ctrl, CPSW2_CONTROL);
+	writel_relaxed(ETH_P_1588, &cpsw->regs->ts_ltype);
+	writel_relaxed(ETH_P_8021Q, &cpsw->regs->vlan_ltype);
+}
+
+static int cpsw_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
+{
+	struct cpsw_priv *priv = netdev_priv(dev);
+	struct hwtstamp_config cfg;
+	struct cpsw_common *cpsw = priv->cpsw;
+
+	if (cpsw->version != CPSW_VERSION_1 &&
+	    cpsw->version != CPSW_VERSION_2 &&
+	    cpsw->version != CPSW_VERSION_3)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	/* reserved for future extensions */
+	if (cfg.flags)
+		return -EINVAL;
+
+	if (cfg.tx_type != HWTSTAMP_TX_OFF && cfg.tx_type != HWTSTAMP_TX_ON)
+		return -ERANGE;
+
+	switch (cfg.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		priv->rx_ts_enabled = 0;
+		break;
+	case HWTSTAMP_FILTER_ALL:
+	case HWTSTAMP_FILTER_NTP_ALL:
+		return -ERANGE;
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+		priv->rx_ts_enabled = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		priv->rx_ts_enabled = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	priv->tx_ts_enabled = cfg.tx_type == HWTSTAMP_TX_ON;
+
+	switch (cpsw->version) {
+	case CPSW_VERSION_1:
+		cpsw_hwtstamp_v1(priv);
+		break;
+	case CPSW_VERSION_2:
+	case CPSW_VERSION_3:
+		cpsw_hwtstamp_v2(priv);
+		break;
+	default:
+		WARN_ON(1);
+	}
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+
+static int cpsw_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
+{
+	struct cpsw_common *cpsw = ndev_to_cpsw(dev);
+	struct cpsw_priv *priv = netdev_priv(dev);
+	struct hwtstamp_config cfg;
+
+	if (cpsw->version != CPSW_VERSION_1 &&
+	    cpsw->version != CPSW_VERSION_2 &&
+	    cpsw->version != CPSW_VERSION_3)
+		return -EOPNOTSUPP;
+
+	cfg.flags = 0;
+	cfg.tx_type = priv->tx_ts_enabled ? HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
+	cfg.rx_filter = priv->rx_ts_enabled;
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+#else
+static int cpsw_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
+{
+	return -EOPNOTSUPP;
+}
+
+static int cpsw_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
+{
+	return -EOPNOTSUPP;
+}
+#endif /*CONFIG_TI_CPTS*/
+
+int cpsw_ndo_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
+{
+	struct cpsw_priv *priv = netdev_priv(dev);
+	struct cpsw_common *cpsw = priv->cpsw;
+	int slave_no = cpsw_slave_index(cpsw, priv);
+
+	if (!netif_running(dev))
+		return -EINVAL;
+
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return cpsw_hwtstamp_set(dev, req);
+	case SIOCGHWTSTAMP:
+		return cpsw_hwtstamp_get(dev, req);
+	}
+
+	if (!cpsw->slaves[slave_no].phy)
+		return -EOPNOTSUPP;
+	return phy_mii_ioctl(cpsw->slaves[slave_no].phy, req, cmd);
+}
+
+int cpsw_ndo_set_tx_maxrate(struct net_device *ndev, int queue, u32 rate)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	struct cpsw_common *cpsw = priv->cpsw;
+	struct cpsw_slave *slave;
+	u32 min_rate;
+	u32 ch_rate;
+	int i, ret;
+
+	ch_rate = netdev_get_tx_queue(ndev, queue)->tx_maxrate;
+	if (ch_rate == rate)
+		return 0;
+
+	ch_rate = rate * 1000;
+	min_rate = cpdma_chan_get_min_rate(cpsw->dma);
+	if ((ch_rate < min_rate && ch_rate)) {
+		dev_err(priv->dev, "The channel rate cannot be less than %dMbps",
+			min_rate);
+		return -EINVAL;
+	}
+
+	if (rate > cpsw->speed) {
+		dev_err(priv->dev, "The channel rate cannot be more than 2Gbps");
+		return -EINVAL;
+	}
+
+	ret = pm_runtime_get_sync(cpsw->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(cpsw->dev);
+		return ret;
+	}
+
+	ret = cpdma_chan_set_rate(cpsw->txv[queue].ch, ch_rate);
+	pm_runtime_put(cpsw->dev);
+
+	if (ret)
+		return ret;
+
+	/* update rates for slaves tx queues */
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		slave = &cpsw->slaves[i];
+		if (!slave->ndev)
+			continue;
+
+		netdev_get_tx_queue(slave->ndev, queue)->tx_maxrate = rate;
+	}
+
+	cpsw_split_res(cpsw);
+	return ret;
+}
+
+static int cpsw_tc_to_fifo(int tc, int num_tc)
+{
+	if (tc == num_tc - 1)
+		return 0;
+
+	return CPSW_FIFO_SHAPERS_NUM - tc;
+}
+
+bool cpsw_shp_is_off(struct cpsw_priv *priv)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	struct cpsw_slave *slave;
+	u32 shift, mask, val;
+
+	val = readl_relaxed(&cpsw->regs->ptype);
+
+	slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
+	shift = CPSW_FIFO_SHAPE_EN_SHIFT + 3 * slave->slave_num;
+	mask = 7 << shift;
+	val = val & mask;
+
+	return !val;
+}
+
+static void cpsw_fifo_shp_on(struct cpsw_priv *priv, int fifo, int on)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	struct cpsw_slave *slave;
+	u32 shift, mask, val;
+
+	val = readl_relaxed(&cpsw->regs->ptype);
+
+	slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
+	shift = CPSW_FIFO_SHAPE_EN_SHIFT + 3 * slave->slave_num;
+	mask = (1 << --fifo) << shift;
+	val = on ? val | mask : val & ~mask;
+
+	writel_relaxed(val, &cpsw->regs->ptype);
+}
+
+static int cpsw_set_fifo_bw(struct cpsw_priv *priv, int fifo, int bw)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	u32 val = 0, send_pct, shift;
+	struct cpsw_slave *slave;
+	int pct = 0, i;
+
+	if (bw > priv->shp_cfg_speed * 1000)
+		goto err;
+
+	/* shaping has to stay enabled for highest fifos linearly
+	 * and fifo bw no more then interface can allow
+	 */
+	slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
+	send_pct = slave_read(slave, SEND_PERCENT);
+	for (i = CPSW_FIFO_SHAPERS_NUM; i > 0; i--) {
+		if (!bw) {
+			if (i >= fifo || !priv->fifo_bw[i])
+				continue;
+
+			dev_warn(priv->dev, "Prev FIFO%d is shaped", i);
+			continue;
+		}
+
+		if (!priv->fifo_bw[i] && i > fifo) {
+			dev_err(priv->dev, "Upper FIFO%d is not shaped", i);
+			return -EINVAL;
+		}
+
+		shift = (i - 1) * 8;
+		if (i == fifo) {
+			send_pct &= ~(CPSW_PCT_MASK << shift);
+			val = DIV_ROUND_UP(bw, priv->shp_cfg_speed * 10);
+			if (!val)
+				val = 1;
+
+			send_pct |= val << shift;
+			pct += val;
+			continue;
+		}
+
+		if (priv->fifo_bw[i])
+			pct += (send_pct >> shift) & CPSW_PCT_MASK;
+	}
+
+	if (pct >= 100)
+		goto err;
+
+	slave_write(slave, send_pct, SEND_PERCENT);
+	priv->fifo_bw[fifo] = bw;
+
+	dev_warn(priv->dev, "set FIFO%d bw = %d\n", fifo,
+		 DIV_ROUND_CLOSEST(val * priv->shp_cfg_speed, 100));
+
+	return 0;
+err:
+	dev_err(priv->dev, "Bandwidth doesn't fit in tc configuration");
+	return -EINVAL;
+}
+
+static int cpsw_set_fifo_rlimit(struct cpsw_priv *priv, int fifo, int bw)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	struct cpsw_slave *slave;
+	u32 tx_in_ctl_rg, val;
+	int ret;
+
+	ret = cpsw_set_fifo_bw(priv, fifo, bw);
+	if (ret)
+		return ret;
+
+	slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
+	tx_in_ctl_rg = cpsw->version == CPSW_VERSION_1 ?
+		       CPSW1_TX_IN_CTL : CPSW2_TX_IN_CTL;
+
+	if (!bw)
+		cpsw_fifo_shp_on(priv, fifo, bw);
+
+	val = slave_read(slave, tx_in_ctl_rg);
+	if (cpsw_shp_is_off(priv)) {
+		/* disable FIFOs rate limited queues */
+		val &= ~(0xf << CPSW_FIFO_RATE_EN_SHIFT);
+
+		/* set type of FIFO queues to normal priority mode */
+		val &= ~(3 << CPSW_FIFO_QUEUE_TYPE_SHIFT);
+
+		/* set type of FIFO queues to be rate limited */
+		if (bw)
+			val |= 2 << CPSW_FIFO_QUEUE_TYPE_SHIFT;
+		else
+			priv->shp_cfg_speed = 0;
+	}
+
+	/* toggle a FIFO rate limited queue */
+	if (bw)
+		val |= BIT(fifo + CPSW_FIFO_RATE_EN_SHIFT);
+	else
+		val &= ~BIT(fifo + CPSW_FIFO_RATE_EN_SHIFT);
+	slave_write(slave, val, tx_in_ctl_rg);
+
+	/* FIFO transmit shape enable */
+	cpsw_fifo_shp_on(priv, fifo, bw);
+	return 0;
+}
+
+/* Defaults:
+ * class A - prio 3
+ * class B - prio 2
+ * shaping for class A should be set first
+ */
+static int cpsw_set_cbs(struct net_device *ndev,
+			struct tc_cbs_qopt_offload *qopt)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	struct cpsw_common *cpsw = priv->cpsw;
+	struct cpsw_slave *slave;
+	int prev_speed = 0;
+	int tc, ret, fifo;
+	u32 bw = 0;
+
+	tc = netdev_txq_to_tc(priv->ndev, qopt->queue);
+
+	/* enable channels in backward order, as highest FIFOs must be rate
+	 * limited first and for compliance with CPDMA rate limited channels
+	 * that also used in bacward order. FIFO0 cannot be rate limited.
+	 */
+	fifo = cpsw_tc_to_fifo(tc, ndev->num_tc);
+	if (!fifo) {
+		dev_err(priv->dev, "Last tc%d can't be rate limited", tc);
+		return -EINVAL;
+	}
+
+	/* do nothing, it's disabled anyway */
+	if (!qopt->enable && !priv->fifo_bw[fifo])
+		return 0;
+
+	/* shapers can be set if link speed is known */
+	slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
+	if (slave->phy && slave->phy->link) {
+		if (priv->shp_cfg_speed &&
+		    priv->shp_cfg_speed != slave->phy->speed)
+			prev_speed = priv->shp_cfg_speed;
+
+		priv->shp_cfg_speed = slave->phy->speed;
+	}
+
+	if (!priv->shp_cfg_speed) {
+		dev_err(priv->dev, "Link speed is not known");
+		return -1;
+	}
+
+	ret = pm_runtime_get_sync(cpsw->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(cpsw->dev);
+		return ret;
+	}
+
+	bw = qopt->enable ? qopt->idleslope : 0;
+	ret = cpsw_set_fifo_rlimit(priv, fifo, bw);
+	if (ret) {
+		priv->shp_cfg_speed = prev_speed;
+		prev_speed = 0;
+	}
+
+	if (bw && prev_speed)
+		dev_warn(priv->dev,
+			 "Speed was changed, CBS shaper speeds are changed!");
+
+	pm_runtime_put_sync(cpsw->dev);
+	return ret;
+}
+
+static int cpsw_set_mqprio(struct net_device *ndev, void *type_data)
+{
+	struct tc_mqprio_qopt_offload *mqprio = type_data;
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	struct cpsw_common *cpsw = priv->cpsw;
+	int fifo, num_tc, count, offset;
+	struct cpsw_slave *slave;
+	u32 tx_prio_map = 0;
+	int i, tc, ret;
+
+	num_tc = mqprio->qopt.num_tc;
+	if (num_tc > CPSW_TC_NUM)
+		return -EINVAL;
+
+	if (mqprio->mode != TC_MQPRIO_MODE_DCB)
+		return -EINVAL;
+
+	ret = pm_runtime_get_sync(cpsw->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(cpsw->dev);
+		return ret;
+	}
+
+	if (num_tc) {
+		for (i = 0; i < 8; i++) {
+			tc = mqprio->qopt.prio_tc_map[i];
+			fifo = cpsw_tc_to_fifo(tc, num_tc);
+			tx_prio_map |= fifo << (4 * i);
+		}
+
+		netdev_set_num_tc(ndev, num_tc);
+		for (i = 0; i < num_tc; i++) {
+			count = mqprio->qopt.count[i];
+			offset = mqprio->qopt.offset[i];
+			netdev_set_tc_queue(ndev, i, count, offset);
+		}
+	}
+
+	if (!mqprio->qopt.hw) {
+		/* restore default configuration */
+		netdev_reset_tc(ndev);
+		tx_prio_map = TX_PRIORITY_MAPPING;
+	}
+
+	priv->mqprio_hw = mqprio->qopt.hw;
+
+	offset = cpsw->version == CPSW_VERSION_1 ?
+		 CPSW1_TX_PRI_MAP : CPSW2_TX_PRI_MAP;
+
+	slave = &cpsw->slaves[cpsw_slave_index(cpsw, priv)];
+	slave_write(slave, tx_prio_map, offset);
+
+	pm_runtime_put_sync(cpsw->dev);
+
+	return 0;
+}
+
+
+int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+		      void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_CBS:
+		return cpsw_set_cbs(ndev, type_data);
+
+	case TC_SETUP_QDISC_MQPRIO:
+		return cpsw_set_mqprio(ndev, type_data);
+
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+void cpsw_cbs_resume(struct cpsw_slave *slave, struct cpsw_priv *priv)
+{
+	int fifo, bw;
+
+	for (fifo = CPSW_FIFO_SHAPERS_NUM; fifo > 0; fifo--) {
+		bw = priv->fifo_bw[fifo];
+		if (!bw)
+			continue;
+
+		cpsw_set_fifo_rlimit(priv, fifo, bw);
+	}
+}
+
+void cpsw_mqprio_resume(struct cpsw_slave *slave, struct cpsw_priv *priv)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	u32 tx_prio_map = 0;
+	int i, tc, fifo;
+	u32 tx_prio_rg;
+
+	if (!priv->mqprio_hw)
+		return;
+
+	for (i = 0; i < 8; i++) {
+		tc = netdev_get_prio_tc_map(priv->ndev, i);
+		fifo = CPSW_FIFO_SHAPERS_NUM - tc;
+		tx_prio_map |= fifo << (4 * i);
+	}
+
+	tx_prio_rg = cpsw->version == CPSW_VERSION_1 ?
+		     CPSW1_TX_PRI_MAP : CPSW2_TX_PRI_MAP;
+
+	slave_write(slave, tx_prio_map, tx_prio_rg);
+}
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index 57b109d4758f..5f4754f8e7f0 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -382,9 +382,27 @@ int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
 		     int descs_pool_size);
 void cpsw_split_res(struct cpsw_common *cpsw);
 int cpsw_fill_rx_channels(struct cpsw_priv *priv);
+int cpsw_need_resplit(struct cpsw_common *cpsw);
+void soft_reset(const char *module, void __iomem *reg);
 void cpsw_intr_enable(struct cpsw_common *cpsw);
 void cpsw_intr_disable(struct cpsw_common *cpsw);
+void cpsw_set_slave_mac(struct cpsw_slave *slave, struct cpsw_priv *priv);
+void cpsw_ndo_tx_timeout(struct net_device *ndev);
 void cpsw_tx_handler(void *token, int len, int status);
+irqreturn_t cpsw_tx_interrupt(int irq, void *dev_id);
+irqreturn_t cpsw_rx_interrupt(int irq, void *dev_id);
+int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget);
+int cpsw_tx_poll(struct napi_struct *napi_tx, int budget);
+int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget);
+int cpsw_rx_poll(struct napi_struct *napi_rx, int budget);
+int cpsw_ndo_ioctl(struct net_device *dev, struct ifreq *req, int cmd);
+void cpsw_rx_vlan_encap(struct sk_buff *skb);
+int cpsw_ndo_set_tx_maxrate(struct net_device *ndev, int queue, u32 rate);
+int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+		      void *type_data);
+bool cpsw_shp_is_off(struct cpsw_priv *priv);
+void cpsw_cbs_resume(struct cpsw_slave *slave, struct cpsw_priv *priv);
+void cpsw_mqprio_resume(struct cpsw_slave *slave, struct cpsw_priv *priv);
 
 /* ethtool */
 u32 cpsw_get_msglevel(struct net_device *ndev);
@@ -414,7 +432,7 @@ int cpsw_nway_reset(struct net_device *ndev);
 void cpsw_get_ringparam(struct net_device *ndev,
 			struct ethtool_ringparam *ering);
 int cpsw_set_ringparam(struct net_device *ndev,
-		       struct ethtool_ringparam *ering);
+			struct ethtool_ringparam *ering);
 int cpsw_set_channels_common(struct net_device *ndev,
 			     struct ethtool_channels *chs,
 			     cpdma_handler_fn rx_handler);
-- 
2.17.1

