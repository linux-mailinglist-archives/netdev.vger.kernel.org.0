Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380BB45A8D9
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238901AbhKWQpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:45:19 -0500
Received: from mga06.intel.com ([134.134.136.31]:10141 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233467AbhKWQpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:45:04 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="295864757"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="295864757"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="457120064"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 23 Nov 2021 08:41:46 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Ws016784;
        Tue, 23 Nov 2021 16:41:43 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 net-next 16/26] virtio_net: don't mix XDP_DROP counter with Rx XDP errors
Date:   Tue, 23 Nov 2021 17:39:45 +0100
Message-Id: <20211123163955.154512-17-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dedicate a separate counter for tracking XDP_ABORTED and other XDP
errors and to leave xdp_drop for XDP_DROP case solely.
Needed to better align with generic XDP stats.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/virtio_net.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c74af526d79b..112ceda3dcf7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -92,6 +92,7 @@ struct virtnet_rq_stats {
 	u64 xdp_tx;
 	u64 xdp_redirects;
 	u64 xdp_drops;
+	u64 xdp_errors;
 	u64 kicks;
 };

@@ -115,6 +116,7 @@ static const struct virtnet_stat_desc virtnet_rq_stats_desc[] = {
 	{ "xdp_tx",		VIRTNET_RQ_STAT(xdp_tx) },
 	{ "xdp_redirects",	VIRTNET_RQ_STAT(xdp_redirects) },
 	{ "xdp_drops",		VIRTNET_RQ_STAT(xdp_drops) },
+	{ "xdp_errors",		VIRTNET_RQ_STAT(xdp_errors) },
 	{ "kicks",		VIRTNET_RQ_STAT(kicks) },
 };

@@ -818,7 +820,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			trace_xdp_exception(vi->dev, xdp_prog, act);
 			goto err_xdp;
 		case XDP_DROP:
-			goto err_xdp;
+			stats->xdp_drops++;
+			goto xdp_drop;
 		}
 	}
 	rcu_read_unlock();
@@ -843,8 +846,9 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	return skb;

 err_xdp:
+	stats->xdp_errors++;
+xdp_drop:
 	rcu_read_unlock();
-	stats->xdp_drops++;
 err_len:
 	stats->drops++;
 	put_page(page);
@@ -1033,7 +1037,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		case XDP_DROP:
 			if (unlikely(xdp_page != page))
 				__free_pages(xdp_page, 0);
-			goto err_xdp;
+
+			if (unlikely(act != XDP_DROP))
+				goto err_xdp;
+
+			stats->xdp_drops++;
+			goto xdp_drop;
 		}
 	}
 	rcu_read_unlock();
@@ -1103,8 +1112,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	return head_skb;

 err_xdp:
+	stats->xdp_errors++;
+xdp_drop:
 	rcu_read_unlock();
-	stats->xdp_drops++;
 err_skb:
 	put_page(page);
 	while (num_buf-- > 1) {
--
2.33.1

