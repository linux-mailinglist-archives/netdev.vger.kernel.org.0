Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A398916845E
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgBURF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:05:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgBURF1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 12:05:27 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 654AE206E2;
        Fri, 21 Feb 2020 17:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582304726;
        bh=eoKDzIN9lKqgVbCG2R5htVsHB/0oozAUa6vbbSh0YkY=;
        h=From:To:Cc:Subject:Date:From;
        b=rA6zE3U9/JO/jHzI+C8gVPKBuI4yDr/rGRHqqJcWW33OfHu7F/0g4KHCVy8g6SgWi
         QJYBnvC53CyzFgGjo9zVem1h/Cmo7bF44h3p7tTnBpr4CVENuf0NCPD/jRPWCInBTm
         RtCAo5K2ERdDvqHEJ5GApsxGmPVSzc3UnThOZCNM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, davem@davemloft.net,
        brouer@redhat.com, lorenzo.bianconi@redhat.com,
        grygorii.strashko@ti.com
Subject: [RFC/RFT net-next] net: ethernet: ti: fix netdevice stats for XDP
Date:   Fri, 21 Feb 2020 18:05:08 +0100
Message-Id: <82f23afa31395a8ba2a324fcec2e90e45563f9c7.1582304311.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Align netdevice statistics when the device is running in XDP mode
to other upstream drivers. In particular reports to user-space rx
packets even if they are not forwarded to the networking stack
(XDP_PASS) but they are redirected (XDP_REDIRECT), dropped (XDP_DROP)
or sent back using the same interface (XDP_TX). This patch allows the
system administrator to very the device is receiving data correctly.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
- this patch is compile-only tested
---
 drivers/net/ethernet/ti/cpsw.c      |  4 +---
 drivers/net/ethernet/ti/cpsw_new.c  |  5 ++---
 drivers/net/ethernet/ti/cpsw_priv.c | 13 +++++++++++--
 drivers/net/ethernet/ti/cpsw_priv.h |  2 +-
 4 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 6ae4a72e6f43..fe3fd33f56f7 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -408,12 +408,10 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		xdp.rxq = &priv->xdp_rxq[ch];
 
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
index 71215db7934b..050496e814c3 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -349,12 +349,11 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		xdp.data_hard_start = pa;
 		xdp.rxq = &priv->xdp_rxq[ch];
 
-		ret = cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port);
+		ret = cpsw_run_xdp(priv, ch, &xdp, page,
+				   priv->emac_port, &len);
 		if (ret != CPSW_XDP_PASS)
 			goto requeue;
 
-		/* XDP prog might have changed packet data and boundaries */
-		len = xdp.data_end - xdp.data;
 		headroom = xdp.data - xdp.data_hard_start;
 
 		/* XDP prog can modify vlan tag, so can't use encap header */
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 97a058ca60ac..a41da48db40b 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1317,7 +1317,7 @@ int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
 }
 
 int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
-		 struct page *page, int port)
+		 struct page *page, int port, int *len)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
 	struct net_device *ndev = priv->ndev;
@@ -1335,10 +1335,13 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
 	}
 
 	act = bpf_prog_run_xdp(prog, xdp);
+	/* XDP prog might have changed packet data and boundaries */
+	*len = xdp.data_end - xdp.data;
+
 	switch (act) {
 	case XDP_PASS:
 		ret = CPSW_XDP_PASS;
-		break;
+		goto out;
 	case XDP_TX:
 		xdpf = convert_to_xdp_frame(xdp);
 		if (unlikely(!xdpf))
@@ -1364,8 +1367,14 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
 		trace_xdp_exception(ndev, prog, act);
 		/* fall through -- handle aborts by dropping packet */
 	case XDP_DROP:
+		ndev->stats.rx_bytes += *len;
+		ndev->stats.rx_packets++;
 		goto drop;
 	}
+
+	ndev->stats.rx_bytes += *len;
+	ndev->stats.rx_packets++;
+
 out:
 	rcu_read_unlock();
 	return ret;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index b8d7b924ee3d..54efd773e033 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -439,7 +439,7 @@ int cpsw_ndo_bpf(struct net_device *ndev, struct netdev_bpf *bpf);
 int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
 		      struct page *page, int port);
 int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
-		 struct page *page, int port);
+		 struct page *page, int port, int *len);
 irqreturn_t cpsw_tx_interrupt(int irq, void *dev_id);
 irqreturn_t cpsw_rx_interrupt(int irq, void *dev_id);
 int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget);
-- 
2.24.1

