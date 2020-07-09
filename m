Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD6C21A42E
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 17:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgGIP5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 11:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgGIP5q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 11:57:46 -0400
Received: from localhost.localdomain.com (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C2312077D;
        Thu,  9 Jul 2020 15:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594310265;
        bh=XHozyYblgSd5bHPIh5crYFqzTqzhHQ1hxMnlHUFC/xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YXGZsq2ryz/pslvlGeC/gM9xXvweRMZrRu5MdYYcmfThzQRYx2Ic9P832xhZDAeML
         MTkAK7kothNQU4YWciu9XYcpmuYJrDLIpsPu1qdKJOYkbSKYsSDZc/WkSfOT/g+Ahi
         K1wfPpxmvD+UuVWMGDTdDNZHP6R/zKfkDlosguF4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, bpf@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, echaudro@redhat.com, sameehj@amazon.com
Subject: [PATCH 4/6] net: mvneta: drop all fragments in XDP_DROP
Date:   Thu,  9 Jul 2020 17:57:21 +0200
Message-Id: <8783879447a481c052bf5caff5cf3dc94792ce1c.1594309075.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1594309075.git.lorenzo@kernel.org>
References: <cover.1594309075.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Release all consumed pages if the eBPF program returns XDP_DROP for XDP
multi-buffers

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index fbf88e524210..f75a45ad586c 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2173,13 +2173,13 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
 static int
 mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	       struct bpf_prog *prog, struct xdp_buff *xdp,
-	       struct mvneta_stats *stats)
+	       u32 frame_sz, struct mvneta_stats *stats)
 {
-	unsigned int len, sync;
-	struct page *page;
+	unsigned int len, data_len, sync;
 	u32 ret, act;
 
 	len = xdp->data_end - xdp->data_hard_start - pp->rx_offset_correction;
+	data_len = xdp->data_end - xdp->data;
 	act = bpf_prog_run_xdp(prog, xdp);
 
 	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
@@ -2195,9 +2195,8 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 
 		err = xdp_do_redirect(pp->dev, xdp, prog);
 		if (unlikely(err)) {
+			mvneta_xdp_put_buff(pp, rxq, xdp, sync, true);
 			ret = MVNETA_XDP_DROPPED;
-			page = virt_to_head_page(xdp->data);
-			page_pool_put_page(rxq->page_pool, page, sync, true);
 		} else {
 			ret = MVNETA_XDP_REDIR;
 			stats->xdp_redirect++;
@@ -2206,10 +2205,8 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 	}
 	case XDP_TX:
 		ret = mvneta_xdp_xmit_back(pp, xdp);
-		if (ret != MVNETA_XDP_TX) {
-			page = virt_to_head_page(xdp->data);
-			page_pool_put_page(rxq->page_pool, page, sync, true);
-		}
+		if (ret != MVNETA_XDP_TX)
+			mvneta_xdp_put_buff(pp, rxq, xdp, sync, true);
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
@@ -2218,14 +2215,13 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		trace_xdp_exception(pp->dev, prog, act);
 		/* fall through */
 	case XDP_DROP:
-		page = virt_to_head_page(xdp->data);
-		page_pool_put_page(rxq->page_pool, page, sync, true);
+		mvneta_xdp_put_buff(pp, rxq, xdp, sync, true);
 		ret = MVNETA_XDP_DROPPED;
 		stats->xdp_drop++;
 		break;
 	}
 
-	stats->rx_bytes += xdp->data_end - xdp->data;
+	stats->rx_bytes += frame_sz + xdp->data_end - xdp->data - data_len;
 	stats->rx_packets++;
 
 	return ret;
@@ -2354,7 +2350,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	};
 	struct mvneta_stats ps = {};
 	struct bpf_prog *xdp_prog;
-	u32 desc_status;
+	u32 desc_status, frame_sz;
 
 	/* Get number of received packets */
 	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
@@ -2383,7 +2379,9 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 				goto next;
 			}
 
+			frame_sz = rx_desc->data_size - ETH_FCS_LEN;
 			desc_status = rx_desc->status;
+
 			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf, page,
 					     &ps);
 		} else {
@@ -2405,7 +2403,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		}
 
 		if (xdp_prog &&
-		    mvneta_run_xdp(pp, rxq, xdp_prog, &xdp_buf, &ps))
+		    mvneta_run_xdp(pp, rxq, xdp_prog, &xdp_buf, frame_sz, &ps))
 			goto next;
 
 		skb = mvneta_swbm_build_skb(pp, rxq, &xdp_buf, desc_status);
-- 
2.26.2

