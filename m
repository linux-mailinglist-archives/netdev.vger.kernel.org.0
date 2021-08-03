Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37E83DF301
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbhHCQmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:42:51 -0400
Received: from mga17.intel.com ([192.55.52.151]:63276 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234271AbhHCQms (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:42:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="194014685"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="194014685"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:42:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="419722331"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 03 Aug 2021 09:42:23 -0700
Received: from alobakin-mobl.ger.corp.intel.com (lkalica-MOBL.ger.corp.intel.com [10.213.13.182])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GgIOK032342;
        Tue, 3 Aug 2021 17:42:18 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next 19/21] virtio-net: don't mix error-caused drops with XDP_DROP cases
Date:   Tue,  3 Aug 2021 18:42:17 +0200
Message-Id: <20210803164217.4202-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's pretty confusing to have just one field for tracking both
XDP_DROP cases and various errors which lead to the frame being
dropped.
Add a new field, xdp_errors, to separate error paths, and leave
xdp_drops purely for counting frames with the XDP_DROP verdict.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/virtio_net.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8cbb4651ed75..acad099006cd 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -91,6 +91,7 @@ struct virtnet_rq_stats {
 	u64 xdp_tx;
 	u64 xdp_redirects;
 	u64 xdp_drops;
+	u64 xdp_errors;
 	u64 kicks;
 };
 
@@ -113,6 +114,7 @@ static const struct virtnet_stat_desc virtnet_rq_stats_desc[] = {
 	{ "xdp_tx",		VIRTNET_RQ_STAT(xdp_tx) },
 	{ "xdp_redirects",	VIRTNET_RQ_STAT(xdp_redirects) },
 	{ "xdp_drops",		VIRTNET_RQ_STAT(xdp_drops) },
+	{ "xdp_errors",		VIRTNET_RQ_STAT(xdp_errors) },
 	{ "kicks",		VIRTNET_RQ_STAT(kicks) },
 };
 
@@ -804,7 +806,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			trace_xdp_exception(vi->dev, xdp_prog, act);
 			goto err_xdp;
 		case XDP_DROP:
-			goto err_xdp;
+			stats->xdp_drops++;
+			goto xdp_drop;
 		}
 	}
 	rcu_read_unlock();
@@ -828,8 +831,9 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	return skb;
 
 err_xdp:
+	stats->xdp_errors++;
+xdp_drop:
 	rcu_read_unlock();
-	stats->xdp_drops++;
 err_len:
 	stats->drops++;
 	put_page(page);
@@ -1012,7 +1016,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
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
@@ -1081,8 +1090,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
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
2.31.1

