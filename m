Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3DE30E1EE
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhBCSHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:07:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232641AbhBCSHH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 13:07:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E65CF64E33;
        Wed,  3 Feb 2021 18:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612375586;
        bh=H+L2s9kEjCV3ipAG29NN30jsS5NCaxjxsDsj576Bs4U=;
        h=From:To:Cc:Subject:Date:From;
        b=FemzZ1C+N1a+XSdzmLdSm4PMXlDAhNnFSkTihz6NFY+hIbqnLo5stkkuDnnH4wLqQ
         cl/KuSjcBFs20JWvynpP/E3Ml1nimbSdKCxWU7UyGEvmePP7Qazr5wqJLl0XWVHh/z
         9WVSXwUPybgGxQjQu5hJr0PrFA2MaXTq3YumGP6QMqwqwCNUEJ3Mw2YGZfdqJ5wqEu
         KZ+Bl9evWYBVz8yYyUjx7rDtOiFhgD/kIyZjlfxNG09gSzCPQd3LALKSug4nmBAKvF
         o2RrHkfHWsqFEk5TbWkk6O4nilnVuJlaDlFRQjLV41lrplua0K/RnylbDF3HPPmTqS
         69eJ5s7vRU1lQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, davem@davemloft.net,
        brouer@redhat.com, lorenzo.bianconi@redhat.com,
        grygorii.strashko@ti.com, kuba@kernel.org
Subject: [PATCH net-next] net: ethernet: ti: fix netdevice stats for XDP
Date:   Wed,  3 Feb 2021 19:06:17 +0100
Message-Id: <a457cb17dd9c58c116d64ee34c354b2e89c0ff8f.1612375372.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Align netdevice statistics when the device is running in XDP mode
to other upstream drivers. In particular reports to user-space rx
packets even if they are not forwarded to the networking stack
(XDP_PASS) but if they are redirected (XDP_REDIRECT), dropped (XDP_DROP)
or sent back using the same interface (XDP_TX). This patch allows the
system administrator to very the device is receiving data correctly.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
- this patch is compile-only tested
---
 drivers/net/ethernet/ti/cpsw.c      |  4 +---
 drivers/net/ethernet/ti/cpsw_new.c  |  4 +---
 drivers/net/ethernet/ti/cpsw_priv.c | 12 ++++++++++--
 drivers/net/ethernet/ti/cpsw_priv.h |  2 +-
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 5239318e9686..fd966567464c 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -403,12 +403,10 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		xdp_prepare_buff(&xdp, pa, headroom, size, false);
 
 		port = priv->emac_port + cpsw->data.dual_emac;
-		ret = cpsw_run_xdp(priv, ch, &xdp, page, port);
+		ret = cpsw_run_xdp(priv, ch, &xdp, page, port, &len);
 		if (ret != CPSW_XDP_PASS)
 			goto requeue;
 
-		/* XDP prog might have changed packet data and boundaries */
-		len = xdp.data_end - xdp.data;
 		headroom = xdp.data - xdp.data_hard_start;
 
 		/* XDP prog can modify vlan tag, so can't use encap header */
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 94747f82c60b..58a64313ac00 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -345,12 +345,10 @@ static void cpsw_rx_handler(void *token, int len, int status)
 
 		xdp_prepare_buff(&xdp, pa, headroom, size, false);
 
-		ret = cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port);
+		ret = cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port, &len);
 		if (ret != CPSW_XDP_PASS)
 			goto requeue;
 
-		/* XDP prog might have changed packet data and boundaries */
-		len = xdp.data_end - xdp.data;
 		headroom = xdp.data - xdp.data_hard_start;
 
 		/* XDP prog can modify vlan tag, so can't use encap header */
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 99f44563e10f..bb59e768915e 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1323,7 +1323,7 @@ int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
 }
 
 int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
-		 struct page *page, int port)
+		 struct page *page, int port, int *len)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
 	struct net_device *ndev = priv->ndev;
@@ -1341,10 +1341,13 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
 	}
 
 	act = bpf_prog_run_xdp(prog, xdp);
+	/* XDP prog might have changed packet data and boundaries */
+	*len = xdp->data_end - xdp->data;
+
 	switch (act) {
 	case XDP_PASS:
 		ret = CPSW_XDP_PASS;
-		break;
+		goto out;
 	case XDP_TX:
 		xdpf = xdp_convert_buff_to_frame(xdp);
 		if (unlikely(!xdpf))
@@ -1370,8 +1373,13 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
 		trace_xdp_exception(ndev, prog, act);
 		fallthrough;	/* handle aborts by dropping packet */
 	case XDP_DROP:
+		ndev->stats.rx_bytes += *len;
+		ndev->stats.rx_packets++;
 		goto drop;
 	}
+
+	ndev->stats.rx_bytes += *len;
+	ndev->stats.rx_packets++;
 out:
 	rcu_read_unlock();
 	return ret;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index 7b7f3596b20d..a323bea54faa 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -438,7 +438,7 @@ int cpsw_ndo_bpf(struct net_device *ndev, struct netdev_bpf *bpf);
 int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
 		      struct page *page, int port);
 int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
-		 struct page *page, int port);
+		 struct page *page, int port, int *len);
 irqreturn_t cpsw_tx_interrupt(int irq, void *dev_id);
 irqreturn_t cpsw_rx_interrupt(int irq, void *dev_id);
 irqreturn_t cpsw_misc_interrupt(int irq, void *dev_id);
-- 
2.29.2

