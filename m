Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285393DF2C0
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbhHCQhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:37:54 -0400
Received: from mga12.intel.com ([192.55.52.136]:57769 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234308AbhHCQhr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:37:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="193324561"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="193324561"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:37:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="419108156"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 03 Aug 2021 09:37:04 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahEs029968;
        Tue, 3 Aug 2021 17:37:00 +0100
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
Subject: [PATCH net-next 04/21] ethernet, dpaa2: simplify per-channel Ethtool stats counting
Date:   Tue,  3 Aug 2021 18:36:24 +0200
Message-Id: <20210803163641.3743-5-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803163641.3743-1-alexandr.lobakin@intel.com>
References: <20210803163641.3743-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't hardcode ARRAY_SIZE() - 1, just put a placeholder and take
offsetof() from it to hide unwanted statistics from Ethtool.
Will be handy for switching to standard XDP stats.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h     | 7 ++++++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index cdb623d5f2c1..8cb57f103d6b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -382,10 +382,15 @@ struct dpaa2_eth_ch_stats {
 	__u64 xdp_tx;
 	__u64 xdp_tx_err;
 	__u64 xdp_redirect;
-	/* Must be last, does not show up in ethtool stats */
+	/* The rest of the structure does not show up in ethtool stats */
+	struct { } __eth_end;
+	/* Must be last */
 	__u64 frames;
 };
 
+#define DPAA2_ETH_NUM_CH_STATS		(offsetof(struct dpaa2_eth_ch_stats, \
+						  __eth_end) / sizeof(u64))
+
 /* Maximum number of queues associated with a DPNI */
 #define DPAA2_ETH_MAX_TCS		8
 #define DPAA2_ETH_MAX_RX_QUEUES_PER_TC	16
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index ad5e374eeccf..95ae83905458 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -278,7 +278,7 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 	/* Per-channel stats */
 	for (k = 0; k < priv->num_channels; k++) {
 		ch_stats = &priv->channel[k]->stats;
-		for (j = 0; j < sizeof(*ch_stats) / sizeof(__u64) - 1; j++)
+		for (j = 0; j < DPAA2_ETH_NUM_CH_STATS; j++)
 			*((__u64 *)data + i + j) += *((__u64 *)ch_stats + j);
 	}
 	i += j;
-- 
2.31.1

