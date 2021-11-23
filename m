Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D70245A8FB
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237868AbhKWQpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:45:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:20338 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238570AbhKWQpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:45:16 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="222282451"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="222282451"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="591251873"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Nov 2021 08:41:36 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wo016784;
        Tue, 23 Nov 2021 16:41:33 GMT
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
Subject: [PATCH v2 net-next 12/26] veth: don't mix XDP_DROP counter with Rx XDP errors
Date:   Tue, 23 Nov 2021 17:39:41 +0100
Message-Id: <20211123163955.154512-13-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211123163955.154512-1-alexandr.lobakin@intel.com>
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to mlx5, count XDP_ABORTED and other Rx XDP errors
separately from XDP_DROP to better align with generic XDP stats.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/veth.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 5ca0a899101d..0e6c030576f4 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -43,6 +43,7 @@ struct veth_stats {
 	u64	xdp_packets;
 	u64	xdp_bytes;
 	u64	xdp_redirect;
+	u64	xdp_errors;
 	u64	xdp_drops;
 	u64	xdp_tx;
 	u64	xdp_tx_err;
@@ -96,6 +97,7 @@ static const struct veth_q_stat_desc veth_rq_stats_desc[] = {
 	{ "xdp_bytes",		VETH_RQ_STAT(xdp_bytes) },
 	{ "drops",		VETH_RQ_STAT(rx_drops) },
 	{ "xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
+	{ "xdp_errors",		VETH_RQ_STAT(xdp_errors) },
 	{ "xdp_drops",		VETH_RQ_STAT(xdp_drops) },
 	{ "xdp_tx",		VETH_RQ_STAT(xdp_tx) },
 	{ "xdp_tx_errors",	VETH_RQ_STAT(xdp_tx_err) },
@@ -655,16 +657,18 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
 			fallthrough;
 		case XDP_ABORTED:
 			trace_xdp_exception(rq->dev, xdp_prog, act);
-			fallthrough;
+			goto err_xdp;
 		case XDP_DROP:
 			stats->xdp_drops++;
-			goto err_xdp;
+			goto xdp_drop;
 		}
 	}
 	rcu_read_unlock();

 	return frame;
 err_xdp:
+	stats->xdp_errors++;
+xdp_drop:
 	rcu_read_unlock();
 	xdp_return_frame(frame);
 xdp_xmit:
@@ -805,7 +809,8 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 		fallthrough;
 	case XDP_ABORTED:
 		trace_xdp_exception(rq->dev, xdp_prog, act);
-		fallthrough;
+		stats->xdp_errors++;
+		goto xdp_drop;
 	case XDP_DROP:
 		stats->xdp_drops++;
 		goto xdp_drop;
--
2.33.1

