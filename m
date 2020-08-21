Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B7B24C983
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 03:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgHUBY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 21:24:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:8905 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgHUBYz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 21:24:55 -0400
IronPort-SDR: 3sKFH2Ljlu9pcS1toLvSLNwqys0pqIITO5K9RuycdCfeHYa0cpfo+STMmckFyHlC5R2ZyWKxbK
 nLWv2aHCYXVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="240256226"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="240256226"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 18:24:55 -0700
IronPort-SDR: lRT89i3xe6icCQ2kxKCeg/dPwmT7o7A2nlLokFiqm4lOvWIe5LatvdhEOTOBa0w8fYH7/JO0Lz
 kL03OrfhfcMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="335178829"
Received: from cmw-fedora32-wp.jf.intel.com ([10.166.17.61])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Aug 2020 18:24:54 -0700
Subject: [RFC PATCH net-next 2/2] igb: Implement granular VF trust flags
From:   Carolyn Wyborny <carolyn.wyborny@intel.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        tom.herbert@intel.com
Date:   Thu, 20 Aug 2020 21:18:02 -0400
Message-ID: <159797266481.773633.4868066170158515057.stgit@cmw-fedora32-wp.jf.intel.com>
In-Reply-To: <159797251668.773633.8211193648312545241.stgit@cmw-fedora32-wp.jf.intel.com>
References: <159797251668.773633.8211193648312545241.stgit@cmw-fedora32-wp.jf.intel.com>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement granular VF trust flags feature in the igb driver.  See
known limitations and gaps in cover message.

Signed-off-by: Carolyn Wyborny  <carolyn.wyborny@intel.com>
---
 drivers/net/ethernet/intel/igb/igb.h      |    2 +-
 drivers/net/ethernet/intel/igb/igb_main.c |   21 +++++++++++----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index 2f015b60a995..073a3f764f3f 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -89,7 +89,7 @@ struct vf_data_storage {
 	u16 pf_qos;
 	u16 tx_rate;
 	bool spoofchk_enabled;
-	bool trusted;
+	vf_trust_flags_t trust_flags;
 };
 
 /* Number of unicast MAC filters reserved for the PF in the RAR registers */
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 4f05f6efe6af..63a2df986f90 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -164,7 +164,7 @@ static int igb_ndo_set_vf_bw(struct net_device *, int, int, int);
 static int igb_ndo_set_vf_spoofchk(struct net_device *netdev, int vf,
 				   bool setting);
 static int igb_ndo_set_vf_trust(struct net_device *netdev, int vf,
-				bool setting);
+				vf_trust_flags_t flags);
 static int igb_ndo_get_vf_config(struct net_device *netdev, int vf,
 				 struct ifla_vf_info *ivi);
 static void igb_check_vf_rate_limit(struct igb_adapter *);
@@ -6756,7 +6756,7 @@ static int igb_vf_configure(struct igb_adapter *adapter, int vf)
 	adapter->vf_data[vf].spoofchk_enabled = true;
 
 	/* By default VFs are not trusted */
-	adapter->vf_data[vf].trusted = false;
+	adapter->vf_data[vf].trust_flags = 0;
 
 	return 0;
 }
@@ -7397,7 +7397,7 @@ static int igb_set_vf_mac_filter(struct igb_adapter *adapter, const int vf,
 		break;
 	case E1000_VF_MAC_FILTER_ADD:
 		if ((vf_data->flags & IGB_VF_FLAG_PF_SET_MAC) &&
-		    !vf_data->trusted) {
+		    !(vf_data->trust_flags & VF_TRUST_F_ADV_FLOW)) {
 			dev_warn(&pdev->dev,
 				 "VF %d requested MAC filter but is administratively denied\n",
 				 vf);
@@ -7455,7 +7455,7 @@ static int igb_set_vf_mac_addr(struct igb_adapter *adapter, u32 *msg, int vf)
 
 	if (!info) {
 		if ((vf_data->flags & IGB_VF_FLAG_PF_SET_MAC) &&
-		    !vf_data->trusted) {
+		    !(vf_data->trust_flags & VF_TRUST_F_MACADDR_CHANGE)) {
 			dev_warn(&pdev->dev,
 				 "VF %d attempted to override administratively set MAC address\nReload the VF driver to resume operations\n",
 				 vf);
@@ -9333,19 +9333,20 @@ static int igb_ndo_set_vf_spoofchk(struct net_device *netdev, int vf,
 	return 0;
 }
 
-static int igb_ndo_set_vf_trust(struct net_device *netdev, int vf, bool setting)
+static int igb_ndo_set_vf_trust(struct net_device *netdev, int vf,
+				vf_trust_flags_t flags)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
 	if (vf >= adapter->vfs_allocated_count)
 		return -EINVAL;
-	if (adapter->vf_data[vf].trusted == setting)
+	if (adapter->vf_data[vf].trust_flags == flags)
 		return 0;
 
-	adapter->vf_data[vf].trusted = setting;
+	adapter->vf_data[vf].trust_flags = flags;
 
-	dev_info(&adapter->pdev->dev, "VF %u is %strusted\n",
-		 vf, setting ? "" : "not ");
+	dev_info(&adapter->pdev->dev, "VF %u trust_flags=%x\n",
+		 vf, flags);
 	return 0;
 }
 
@@ -9362,7 +9363,7 @@ static int igb_ndo_get_vf_config(struct net_device *netdev,
 	ivi->vlan = adapter->vf_data[vf].pf_vlan;
 	ivi->qos = adapter->vf_data[vf].pf_qos;
 	ivi->spoofchk = adapter->vf_data[vf].spoofchk_enabled;
-	ivi->trusted = adapter->vf_data[vf].trusted;
+	ivi->trust_flags = adapter->vf_data[vf].trust_flags;
 	return 0;
 }
 


