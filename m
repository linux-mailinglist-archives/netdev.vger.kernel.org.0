Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFF634DC3D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhC2W4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:56:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:2470 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231634AbhC2Wzi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:55:38 -0400
IronPort-SDR: VB6VMzXVmGuyoD8wnpCIq71MmaXfLzDVqlNS0g6NUsM+Ea//ENuahiXfbbxy3luN5fQ5/GMBXl
 k1nYYm9SKHFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="189393034"
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="189393034"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 15:55:37 -0700
IronPort-SDR: 3s/F2k48dkoPqDwHO5TH6bnkPDVuUwMxL7u8NG2EGjxANnDohIaABmv4hVxNAq5D38ycR7DCFZ
 2CHBNK/Dk6Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="417884310"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 29 Mar 2021 15:55:35 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>
Subject: [PATCH v5 bpf-next 13/17] veth: implement ethtool's get_channels() callback
Date:   Tue, 30 Mar 2021 00:43:12 +0200
Message-Id: <20210329224316.17793-14-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210329224316.17793-1-maciej.fijalkowski@intel.com>
References: <20210329224316.17793-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Libbpf's xsk part calls get_channels() API to retrieve the queue count
of the underlying driver so that XSKMAP is sized accordingly.

Implement that in veth so multi queue scenarios can work properly.

Cc: Toshiaki Makita <toshiaki.makita1@gmail.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/veth.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index aa1a66ad2ce5..180aabe8a33f 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -218,6 +218,17 @@ static void veth_get_ethtool_stats(struct net_device *dev,
 	}
 }
 
+static void veth_get_channels(struct net_device *dev,
+			      struct ethtool_channels *channels)
+{
+	channels->tx_count = dev->real_num_tx_queues;
+	channels->rx_count = dev->real_num_rx_queues;
+	channels->max_tx = dev->real_num_tx_queues;
+	channels->max_rx = dev->real_num_rx_queues;
+	channels->combined_count = min(dev->real_num_rx_queues, dev->real_num_tx_queues);
+	channels->max_combined = min(dev->real_num_rx_queues, dev->real_num_tx_queues);
+}
+
 static const struct ethtool_ops veth_ethtool_ops = {
 	.get_drvinfo		= veth_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
@@ -226,6 +237,7 @@ static const struct ethtool_ops veth_ethtool_ops = {
 	.get_ethtool_stats	= veth_get_ethtool_stats,
 	.get_link_ksettings	= veth_get_link_ksettings,
 	.get_ts_info		= ethtool_op_get_ts_info,
+	.get_channels		= veth_get_channels,
 };
 
 /* general routines */
-- 
2.20.1

