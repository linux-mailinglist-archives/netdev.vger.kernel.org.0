Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E48C3B4B8B
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 02:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhFZAgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 20:36:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:48451 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229924AbhFZAgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 20:36:04 -0400
IronPort-SDR: ug9NuVVKSVgCmd2Glt6X3Y2kx/BQ9peoeMoqdUos1+hm99hAuVrXKpnYcgxqXMNeCUzkRp0rsV
 NKaq+Cf6wUYA==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="195054022"
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="195054022"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:42 -0700
IronPort-SDR: KED/AhN6B81Gg8FJp8HpNvhyx1Oh9aMjih62jBfI4YrQ4vVKhXBgn4KgtBp94VQIcq7nT+rn3I
 l+d1u1PKeFXQ==
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="557008612"
Received: from aschmalt-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.160.59])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:42 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v4 06/12] igc: Add support for enabling frame preemption via ethtool
Date:   Fri, 25 Jun 2021 17:33:08 -0700
Message-Id: <20210626003314.3159402-7-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210626003314.3159402-1-vinicius.gomes@intel.com>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds support for enabling frame preemption via ethtool. All that's
left for ethtool is to save the settings in the adapter state, and the
request for those settings to be applied.

It's done this because the TSN features (frame preemption is part of
them) interact with one another and it's better to keep track from a
central place.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  2 ++
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 31 ++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 9e0bbb2e55e3..9afee4712aeb 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -173,6 +173,8 @@ struct igc_adapter {
 
 	ktime_t base_time;
 	ktime_t cycle_time;
+	bool frame_preemption_active;
+	u32 add_frag_size;
 
 	/* OS defined structs */
 	struct pci_dev *pdev;
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index fa4171860623..84d5afe92154 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -8,6 +8,7 @@
 
 #include "igc.h"
 #include "igc_diag.h"
+#include "igc_tsn.h"
 
 /* forward declaration */
 struct igc_stats {
@@ -1641,6 +1642,34 @@ static int igc_ethtool_set_eee(struct net_device *netdev,
 	return 0;
 }
 
+static int igc_ethtool_get_preempt(struct net_device *netdev,
+				   struct ethtool_fp *fpcmd)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+
+	fpcmd->enabled = adapter->frame_preemption_active;
+	fpcmd->add_frag_size = adapter->add_frag_size;
+
+	return 0;
+}
+
+static int igc_ethtool_set_preempt(struct net_device *netdev,
+				   struct ethtool_fp *fpcmd,
+				   struct netlink_ext_ack *extack)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+
+	if (fpcmd->add_frag_size < 68 || fpcmd->add_frag_size > 260) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid value for add-frag-size");
+		return -EINVAL;
+	}
+
+	adapter->frame_preemption_active = fpcmd->enabled;
+	adapter->add_frag_size = fpcmd->add_frag_size;
+
+	return igc_tsn_offload_apply(adapter);
+}
+
 static int igc_ethtool_begin(struct net_device *netdev)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
@@ -1934,6 +1963,8 @@ static const struct ethtool_ops igc_ethtool_ops = {
 	.get_ts_info		= igc_ethtool_get_ts_info,
 	.get_channels		= igc_ethtool_get_channels,
 	.set_channels		= igc_ethtool_set_channels,
+	.get_preempt		= igc_ethtool_get_preempt,
+	.set_preempt		= igc_ethtool_set_preempt,
 	.get_priv_flags		= igc_ethtool_get_priv_flags,
 	.set_priv_flags		= igc_ethtool_set_priv_flags,
 	.get_eee		= igc_ethtool_get_eee,
-- 
2.32.0

