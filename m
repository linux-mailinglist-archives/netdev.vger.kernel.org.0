Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BF83DF2AA
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbhHCQhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:37:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:33456 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233671AbhHCQhU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:37:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="210621129"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="210621129"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:37:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="670507815"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga005.fm.intel.com with ESMTP; 03 Aug 2021 09:36:52 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahEp029968;
        Tue, 3 Aug 2021 17:36:48 +0100
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
Subject: [PATCH net-next 01/21] ethtool, stats: use a shorthand pointer in stats_prepare_data()
Date:   Tue,  3 Aug 2021 18:36:21 +0200
Message-Id: <20210803163641.3743-2-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just place dev->ethtool_ops on the stack and use it instead of
dereferencing the former a bunch of times to improve code
readability.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 net/ethtool/stats.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index ec07f5765e03..e35c87206b4c 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -108,12 +108,15 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	const struct stats_req_info *req_info = STATS_REQINFO(req_base);
 	struct stats_reply_data *data = STATS_REPDATA(reply_base);
 	struct net_device *dev = reply_base->dev;
+	const struct ethtool_ops *ops;
 	int ret;
 
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
 
+	ops = dev->ethtool_ops;
+
 	/* Mark all stats as unset (see ETHTOOL_STAT_NOT_SET) to prevent them
 	 * from being reported to user space in case driver did not set them.
 	 */
@@ -123,18 +126,17 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	memset(&data->rmon_stats, 0xff, sizeof(data->rmon_stats));
 
 	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask) &&
-	    dev->ethtool_ops->get_eth_phy_stats)
-		dev->ethtool_ops->get_eth_phy_stats(dev, &data->phy_stats);
+	    ops->get_eth_phy_stats)
+		ops->get_eth_phy_stats(dev, &data->phy_stats);
 	if (test_bit(ETHTOOL_STATS_ETH_MAC, req_info->stat_mask) &&
-	    dev->ethtool_ops->get_eth_mac_stats)
-		dev->ethtool_ops->get_eth_mac_stats(dev, &data->mac_stats);
+	    ops->get_eth_mac_stats)
+		ops->get_eth_mac_stats(dev, &data->mac_stats);
 	if (test_bit(ETHTOOL_STATS_ETH_CTRL, req_info->stat_mask) &&
-	    dev->ethtool_ops->get_eth_ctrl_stats)
-		dev->ethtool_ops->get_eth_ctrl_stats(dev, &data->ctrl_stats);
+	    ops->get_eth_ctrl_stats)
+		ops->get_eth_ctrl_stats(dev, &data->ctrl_stats);
 	if (test_bit(ETHTOOL_STATS_RMON, req_info->stat_mask) &&
-	    dev->ethtool_ops->get_rmon_stats)
-		dev->ethtool_ops->get_rmon_stats(dev, &data->rmon_stats,
-						 &data->rmon_ranges);
+	    ops->get_rmon_stats)
+		ops->get_rmon_stats(dev, &data->rmon_stats, &data->rmon_ranges);
 
 	ethnl_ops_complete(dev);
 	return 0;
-- 
2.31.1

