Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D46222F1E
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgGPXf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgGPXfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 19:35:18 -0400
Received: from localhost.localdomain.com (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7C062082F;
        Thu, 16 Jul 2020 22:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594937832;
        bh=XW5tX5m7/tJlsKHLr/66hcOO8zo4uVp57AnwtuvKuWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iF/FPOWL+DOqYOSW+QxcYPnZQ3GvaPsYkJzEvO2oscz1L4QgCsd6mvEdlEAeNqjVp
         qVtkOAr6Em08tzdh2P4o9XcudRi2SCR/FL4x8xHcCSV7vmGyzFv+9bz9s6RQ6ntJw+
         vu/2+pqzj2611zHFXpvASH36GNxMGtvZkhmdUWaw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, bpf@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, echaudro@redhat.com, sameehj@amazon.com
Subject: [PATCH v2 net-next 4/6] net: mvneta: drop all fragments in XDP_DROP
Date:   Fri, 17 Jul 2020 00:16:32 +0200
Message-Id: <1633c89d16b553410aac2dbedf50fa702570a25c.1594936660.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1594936660.git.lorenzo@kernel.org>
References: <cover.1594936660.git.lorenzo@kernel.org>
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
index 021419428ff8..7746693a3de1 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2172,13 +2172,13 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
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
@@ -2194,9 +2194,8 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 
 		err = xdp_do_redirect(pp->dev, xdp, prog);
 		if (unlikely(err)) {
+			mvneta_xdp_put_buff(pp, rxq, xdp, sync, true);
 			ret = MVNETA_XDP_DROPPED;
-			page = virt_to_head_page(xdp->data);
-			page_pool_put_page(rxq->page_pool, page, sync, true);
 		} else {
 			ret = MVNETA_XDP_REDIR;
 			stats->xdp_redirect++;
@@ -2205,10 +2204,8 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
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
@@ -2217,14 +2214,13 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
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
@@ -2355,7 +2351,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 	};
 	struct mvneta_stats ps = {};
 	struct bpf_prog *xdp_prog;
-	u32 desc_status;
+	u32 desc_status, frame_sz;
 
 	/* Get number of received packets */
 	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
@@ -2384,7 +2380,9 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 				goto next;
 			}
 
+			frame_sz = rx_desc->data_size - ETH_FCS_LEN;
 			desc_status = rx_desc->status;
+
 			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf, page,
 					     &ps);
 		} else {
@@ -2406,7 +2404,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 		}
 
 		if (xdp_prog &&
-		    mvneta_run_xdp(pp, rxq, xdp_prog, &xdp_buf, &ps))
+		    mvneta_run_xdp(pp, rxq, xdp_prog, &xdp_buf, frame_sz, &ps))
 			goto next;
 
 		skb = mvneta_swbm_build_skb(pp, rxq, &xdp_buf, desc_status);
-- 
2.26.2

