Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CA952571B
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 23:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357935AbiELVf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 17:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239064AbiELVfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 17:35:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5611FA67
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652391353; x=1683927353;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RtF7CNpfkWSTUyqk8QRGJ5aPbyTaid/AcUjnRhgwQFM=;
  b=SvbfrXXfHq/o6Tv2zM2ZJoTvy5mCW4l8Mr1uh5TQOmjSHSCWVcQHJaRh
   f8CeZAZm3keYDrxRcNkCTbdd89RBcgK/QyovtHv651QyUBuhRrFHBcxp8
   bbKnsU2hjW03+Cmsd/DpL3vGmNEMd8S7XJSFXCIerjEj5B1F15jiHaHQI
   8hbJdyTSwZZl8yGUUN79MlC/aApksOMQjCaAOb9Xk/wSQ6B4aO0faT8vW
   s/83NfetXNLXzzqz2j4OTyDRk4xDT+aPdzFiavyspqmqZe/RJuZAlAV5c
   sMl7V1fetqiHLdv8fkVrrmR6E/l1ZNMoiA3Q2mC4YXVfEu4vQEuF8oTqG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="250673224"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="250673224"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 14:35:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="895971315"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 12 May 2022 14:35:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sudheer.mogilappagari@intel.com, amritha.nambiar@intel.com,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: [PATCH net-next 1/1] ice: Expose RSS indirection tables for queue groups via ethtool
Date:   Thu, 12 May 2022 14:32:49 -0700
Message-Id: <20220512213249.3747424-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sridhar Samudrala <sridhar.samudrala@intel.com>

When ADQ queue groups (TCs) are created via tc mqprio command,
RSS contexts and associated RSS indirection tables are configured
automatically per TC based on the queue ranges specified for
each traffic class.

For ex:
tc qdisc add dev enp175s0f0 root mqprio num_tc 3 map 0 1 2 \
	queues 2@0 8@2 4@10 hw 1 mode channel

will create 3 queue groups (TC 0-2) with queue ranges 2, 8 and 4
in 3 queue groups. Each queue group is associated with its
own RSS context and RSS indirection table.

Add support to expose RSS indirection tables for all ADQ queue
groups using ethtool RSS contexts interface.
	ethtool -x enp175s0f0 context <tc-num>

Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 69 +++++++++++++++-----
 1 file changed, 51 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 476bd1c83c87..1e71b70f0e52 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3111,36 +3111,47 @@ static u32 ice_get_rxfh_indir_size(struct net_device *netdev)
 	return np->vsi->rss_table_size;
 }
 
-/**
- * ice_get_rxfh - get the Rx flow hash indirection table
- * @netdev: network interface device structure
- * @indir: indirection table
- * @key: hash key
- * @hfunc: hash function
- *
- * Reads the indirection table directly from the hardware.
- */
 static int
-ice_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key, u8 *hfunc)
+ice_get_rxfh_context(struct net_device *netdev, u32 *indir,
+		     u8 *key, u8 *hfunc, u32 rss_context)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
-	int err, i;
+	u16 qcount, offset;
+	int err, num_tc, i;
 	u8 *lut;
 
+	if (!test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
+		netdev_warn(netdev, "RSS is not supported on this VSI!\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (rss_context && !ice_is_adq_active(pf)) {
+		netdev_err(netdev, "RSS context cannot be non-zero when ADQ is not configured.\n");
+		return -EINVAL;
+	}
+
+	qcount = vsi->mqprio_qopt.qopt.count[rss_context];
+	offset = vsi->mqprio_qopt.qopt.offset[rss_context];
+
+	if (rss_context && ice_is_adq_active(pf)) {
+		num_tc = vsi->mqprio_qopt.qopt.num_tc;
+		if (rss_context >= num_tc) {
+			netdev_err(netdev, "RSS context:%d  > num_tc:%d\n",
+				   rss_context, num_tc);
+			return -EINVAL;
+		}
+		/* Use channel VSI of given TC */
+		vsi = vsi->tc_map_vsi[rss_context];
+	}
+
 	if (hfunc)
 		*hfunc = ETH_RSS_HASH_TOP;
 
 	if (!indir)
 		return 0;
 
-	if (!test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
-		/* RSS not supported return error here */
-		netdev_warn(netdev, "RSS is not configured on this VSI!\n");
-		return -EIO;
-	}
-
 	lut = kzalloc(vsi->rss_table_size, GFP_KERNEL);
 	if (!lut)
 		return -ENOMEM;
@@ -3153,14 +3164,35 @@ ice_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key, u8 *hfunc)
 	if (err)
 		goto out;
 
+	if (ice_is_adq_active(pf)) {
+		for (i = 0; i < vsi->rss_table_size; i++)
+			indir[i] = offset + lut[i] % qcount;
+		goto out;
+	}
+
 	for (i = 0; i < vsi->rss_table_size; i++)
-		indir[i] = (u32)(lut[i]);
+		indir[i] = lut[i];
 
 out:
 	kfree(lut);
 	return err;
 }
 
+/**
+ * ice_get_rxfh - get the Rx flow hash indirection table
+ * @netdev: network interface device structure
+ * @indir: indirection table
+ * @key: hash key
+ * @hfunc: hash function
+ *
+ * Reads the indirection table directly from the hardware.
+ */
+static int
+ice_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key, u8 *hfunc)
+{
+	return ice_get_rxfh_context(netdev, indir, key, hfunc, 0);
+}
+
 /**
  * ice_set_rxfh - set the Rx flow hash indirection table
  * @netdev: network interface device structure
@@ -4102,6 +4134,7 @@ static const struct ethtool_ops ice_ethtool_ops = {
 	.set_pauseparam		= ice_set_pauseparam,
 	.get_rxfh_key_size	= ice_get_rxfh_key_size,
 	.get_rxfh_indir_size	= ice_get_rxfh_indir_size,
+	.get_rxfh_context	= ice_get_rxfh_context,
 	.get_rxfh		= ice_get_rxfh,
 	.set_rxfh		= ice_set_rxfh,
 	.get_channels		= ice_get_channels,
-- 
2.35.1

