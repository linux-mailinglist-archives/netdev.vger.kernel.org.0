Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2895E175C03
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 14:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgCBNqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 08:46:39 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26353 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbgCBNqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 08:46:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583156798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9QGJ3IFSQKD0aenoqLqaDuoaTCV6qzjmUS2/kCa+Du0=;
        b=Q3Fo4s51C2U7KHVIXW9sXOh4jpzrE7fmuf6lO8VVH2wkqIRFi2oQW48ljSFxWkxcWhRlR2
        mkloXBXlcoqfztbouAUD6pe50YMVjOIW3un6YPShlOy7D6TZieyDdCIi45J3IJgT4uuCIL
        rYH8CigLfWAAH47RCuKLjFDRWcV0b0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-ba81UrnTPDaq7wy_gEACPg-1; Mon, 02 Mar 2020 08:46:36 -0500
X-MC-Unique: ba81UrnTPDaq7wy_gEACPg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85218107ACC4;
        Mon,  2 Mar 2020 13:46:34 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-20.brq.redhat.com [10.40.200.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 663B65DA7C;
        Mon,  2 Mar 2020 13:46:29 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 3845930737E05;
        Mon,  2 Mar 2020 14:46:28 +0100 (CET)
Subject: [net-next PATCH] mvneta: add XDP ethtool errors stats for TX to
 driver
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>, kuba@kernel.org,
        andrew@lunn.ch, thomas.petazzoni@bootlin.com
Date:   Mon, 02 Mar 2020 14:46:28 +0100
Message-ID: <158315678810.1983667.11239367181663328821.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding ethtool stats for when XDP transmitted packets overrun the TX
queue. This is recorded separately for XDP_TX and ndo_xdp_xmit. This
is an important aid for troubleshooting XDP based setups.

It is currently a known weakness and property of XDP that there isn't
any push-back or congestion feedback when transmitting frames via XDP.
It's easy to realise when redirecting from a higher speed link into a
slower speed link, or simply two ingress links into a single egress.
The situation can also happen when Ethernet flow control is active.

For testing the patch and provoking the situation to occur on my
Espressobin board, I configured the TX-queue to be smaller (434) than
RX-queue (512) and overload network with large MTU size frames (as a
larger frame takes longer to transmit).

Hopefully the upcoming XDP TX hook can be extended to provide insight
into these TX queue overflows, to allow programmable adaptation
strategies.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/marvell/mvneta.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index b22eeb5f8700..bc488e8b8e45 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -344,8 +344,10 @@ enum {
 	ETHTOOL_XDP_REDIRECT,
 	ETHTOOL_XDP_PASS,
 	ETHTOOL_XDP_DROP,
-	ETHTOOL_XDP_XMIT,
 	ETHTOOL_XDP_TX,
+	ETHTOOL_XDP_TX_ERR,
+	ETHTOOL_XDP_XMIT,
+	ETHTOOL_XDP_XMIT_ERR,
 	ETHTOOL_MAX_STATS,
 };
 
@@ -404,7 +406,9 @@ static const struct mvneta_statistic mvneta_statistics[] = {
 	{ ETHTOOL_XDP_PASS, T_SW, "rx_xdp_pass", },
 	{ ETHTOOL_XDP_DROP, T_SW, "rx_xdp_drop", },
 	{ ETHTOOL_XDP_TX, T_SW, "rx_xdp_tx", },
+	{ ETHTOOL_XDP_TX_ERR, T_SW, "rx_xdp_tx_errors", },
 	{ ETHTOOL_XDP_XMIT, T_SW, "tx_xdp_xmit", },
+	{ ETHTOOL_XDP_XMIT_ERR, T_SW, "tx_xdp_xmit_errors", },
 };
 
 struct mvneta_stats {
@@ -417,7 +421,9 @@ struct mvneta_stats {
 	u64	xdp_pass;
 	u64	xdp_drop;
 	u64	xdp_xmit;
+	u64	xdp_xmit_err;
 	u64	xdp_tx;
+	u64	xdp_tx_err;
 };
 
 struct mvneta_ethtool_stats {
@@ -2059,6 +2065,7 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
 static int
 mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
 {
+	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
 	struct mvneta_tx_queue *txq;
 	struct netdev_queue *nq;
 	struct xdp_frame *xdpf;
@@ -2076,8 +2083,6 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
 	__netif_tx_lock(nq, cpu);
 	ret = mvneta_xdp_submit_frame(pp, txq, xdpf, false);
 	if (ret == MVNETA_XDP_TX) {
-		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
-
 		u64_stats_update_begin(&stats->syncp);
 		stats->es.ps.tx_bytes += xdpf->len;
 		stats->es.ps.tx_packets++;
@@ -2085,6 +2090,10 @@ mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
 		u64_stats_update_end(&stats->syncp);
 
 		mvneta_txq_pend_desc_add(pp, txq, 0);
+	} else {
+		u64_stats_update_begin(&stats->syncp);
+		stats->es.ps.xdp_tx_err++;
+		u64_stats_update_end(&stats->syncp);
 	}
 	__netif_tx_unlock(nq);
 
@@ -2128,6 +2137,7 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
 	stats->es.ps.tx_bytes += nxmit_byte;
 	stats->es.ps.tx_packets += nxmit;
 	stats->es.ps.xdp_xmit += nxmit;
+	stats->es.ps.xdp_xmit_err += num_frame - nxmit;
 	u64_stats_update_end(&stats->syncp);
 
 	return nxmit;
@@ -2152,7 +2162,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		int err;
 
 		err = xdp_do_redirect(pp->dev, xdp, prog);
-		if (err) {
+		if (unlikely(err)) {
 			ret = MVNETA_XDP_DROPPED;
 			page_pool_put_page(rxq->page_pool,
 					   virt_to_head_page(xdp->data), len,
@@ -4518,6 +4528,8 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 		u64 skb_alloc_error;
 		u64 refill_error;
 		u64 xdp_redirect;
+		u64 xdp_xmit_err;
+		u64 xdp_tx_err;
 		u64 xdp_pass;
 		u64 xdp_drop;
 		u64 xdp_xmit;
@@ -4532,7 +4544,9 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 			xdp_pass = stats->es.ps.xdp_pass;
 			xdp_drop = stats->es.ps.xdp_drop;
 			xdp_xmit = stats->es.ps.xdp_xmit;
+			xdp_xmit_err = stats->es.ps.xdp_xmit_err;
 			xdp_tx = stats->es.ps.xdp_tx;
+			xdp_tx_err = stats->es.ps.xdp_tx_err;
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 
 		es->skb_alloc_error += skb_alloc_error;
@@ -4541,7 +4555,9 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
 		es->ps.xdp_pass += xdp_pass;
 		es->ps.xdp_drop += xdp_drop;
 		es->ps.xdp_xmit += xdp_xmit;
+		es->ps.xdp_xmit_err += xdp_xmit_err;
 		es->ps.xdp_tx += xdp_tx;
+		es->ps.xdp_tx_err += xdp_tx_err;
 	}
 }
 
@@ -4594,9 +4610,15 @@ static void mvneta_ethtool_update_stats(struct mvneta_port *pp)
 			case ETHTOOL_XDP_TX:
 				pp->ethtool_stats[i] = stats.ps.xdp_tx;
 				break;
+			case ETHTOOL_XDP_TX_ERR:
+				pp->ethtool_stats[i] = stats.ps.xdp_tx_err;
+				break;
 			case ETHTOOL_XDP_XMIT:
 				pp->ethtool_stats[i] = stats.ps.xdp_xmit;
 				break;
+			case ETHTOOL_XDP_XMIT_ERR:
+				pp->ethtool_stats[i] = stats.ps.xdp_xmit_err;
+				break;
 			}
 			break;
 		}


