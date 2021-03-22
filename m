Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1C7345188
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhCVVKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:10:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:4966 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhCVVJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:09:27 -0400
IronPort-SDR: 0qKDJ4ZsowShrE82QFnb8zY1NbMW8o0Ip33smIzqAXgeoHjgsqaRpdQV6YRdcm3mxFEm64tItK
 6dHl0ywXxOuQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="210423758"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="210423758"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 14:09:27 -0700
IronPort-SDR: elwylINcCFLgITMkNY//Oqii0BNZPHEaYkCVhYoRG+h6/DYvmF72T4CL22qzLjIZMGp/RJcDoR
 F+c8o+Y3+CwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="513448878"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2021 14:09:25 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 13/17] veth: implement ethtool's get_channels() callback
Date:   Mon, 22 Mar 2021 21:58:12 +0100
Message-Id: <20210322205816.65159-14-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Libbpf's xsk part calls get_channels() API to retrieve the queue count
of the underlying driver so that XSKMAP is sized accordingly.

Implement that in veth so multi queue scenarios can work properly.

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

