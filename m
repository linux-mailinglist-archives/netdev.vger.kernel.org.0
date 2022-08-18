Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7764D598822
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344560AbiHRPyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344421AbiHRPyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:54:25 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B23CC650F
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660837982; x=1692373982;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K6xAOfYF4wti2+D4DZEcF9W27P/xT12OoGFHWkTP3qs=;
  b=m4SuUFevYFC9N1lEdwfwkIqDURUDN0ThVgmtoIBCalRbQr37tJ6X3zeO
   BdP35Uh0sy/a8E2CcMVkJ71TPAmtIYYwAHFq/4bsjQHV5rql+HYxXS4Jf
   EmkcGyAGixta096neYKsD+EDq0Q1eWZRVQlrCqxMnU78pf1OL0CaFNWp1
   Yhj6VqnXsX6iCa2wtZ1HRIop6RmW5HYT5WezpLBge3hlgvPPrTFgF0AiH
   GgefqpV9m+pER3X3rYedbtR8GTUwGLrfXQ/kiYpPB9XQGNg05dTJHkhFR
   3sojM6nbcIDE06fQwtT/g0jAhlL5rRxvxEr3KxgpYRtg8Aj1fhyG1uzsL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="318817390"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="318817390"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 08:52:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="676104311"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2022 08:52:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/5] ice: Implement FCS/CRC and VLAN stripping co-existence policy
Date:   Thu, 18 Aug 2022 08:52:04 -0700
Message-Id: <20220818155207.996297-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220818155207.996297-1-anthony.l.nguyen@intel.com>
References: <20220818155207.996297-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>

Make sure that only the valid combinations of FCS/CRC stripping and
VLAN stripping offloads are allowed.

You cannot have FCS/CRC stripping disabled while VLAN stripping is
enabled - this breaks the correctness of the FCS/CRC.

If administrator tries to enable VLAN stripping when FCS/CRC stripping is
disabled, the request should be rejected.

If administrator tries to disable FCS/CRC stripping when VLAN stripping
is enabled, the request should be rejected if VLANs are configured. If
there is no VLAN configured, then both FCS/CRC and VLAN stripping should
be disabled.

Testing Hints:
The default settings after driver load are:
- VLAN C-Tag offloads are enabled
- VLAN S-Tag offloads are disabled
- FCS/CRC stripping is enabled

Restore the default settings before each test with the command:
ethtool -K eth0 rx-fcs off rxvlan on txvlan on rx-vlan-stag-hw-parse off
tx-vlan-stag-hw-insert off

Test 1:
Disable FCS/CRC and VLAN stripping:
ethtool -K eth0 rx-fcs on rxvlan off
Try to enable VLAN stripping:
ethtool -K eth0 rxvlan on

Expected: VLAN stripping request is rejected

Test 2:
Try to disable FCS/CRC stripping:
ethtool -K eth0 rx-fcs on

Expected: VLAN stripping is also disabled, as there are no VLAN
configured

Test 3:
Add a VLAN:
ip link add link eth0 eth0.42 type vlan id 42
ip link set eth0 up
Try to disable FCS/CRC stripping:
ethtool -K eth0 rx-fcs on

Expected: FCS/CRC stripping request is rejected

Signed-off-by: Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 25 +++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a827045198cc..8dfecdc74a18 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5722,6 +5722,9 @@ ice_fdb_del(struct ndmsg *ndm, __always_unused struct nlattr *tb[],
 					 NETIF_F_HW_VLAN_STAG_RX | \
 					 NETIF_F_HW_VLAN_STAG_TX)
 
+#define NETIF_VLAN_STRIPPING_FEATURES	(NETIF_F_HW_VLAN_CTAG_RX | \
+					 NETIF_F_HW_VLAN_STAG_RX)
+
 #define NETIF_VLAN_FILTERING_FEATURES	(NETIF_F_HW_VLAN_CTAG_FILTER | \
 					 NETIF_F_HW_VLAN_STAG_FILTER)
 
@@ -5808,6 +5811,14 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 			      NETIF_F_HW_VLAN_STAG_TX);
 	}
 
+	if (!(netdev->features & NETIF_F_RXFCS) &&
+	    (features & NETIF_F_RXFCS) &&
+	    (features & NETIF_VLAN_STRIPPING_FEATURES) &&
+	    !ice_vsi_has_non_zero_vlans(np->vsi)) {
+		netdev_warn(netdev, "Disabling VLAN stripping as FCS/CRC stripping is also disabled and there is no VLAN configured\n");
+		features &= ~NETIF_VLAN_STRIPPING_FEATURES;
+	}
+
 	return features;
 }
 
@@ -5901,6 +5912,13 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 	current_vlan_features = netdev->features & NETIF_VLAN_OFFLOAD_FEATURES;
 	requested_vlan_features = features & NETIF_VLAN_OFFLOAD_FEATURES;
 	if (current_vlan_features ^ requested_vlan_features) {
+		if ((features & NETIF_F_RXFCS) &&
+		    (features & NETIF_VLAN_STRIPPING_FEATURES)) {
+			dev_err(ice_pf_to_dev(vsi->back),
+				"To enable VLAN stripping, you must first enable FCS/CRC stripping\n");
+			return -EIO;
+		}
+
 		err = ice_set_vlan_offload_features(vsi, features);
 		if (err)
 			return err;
@@ -5986,6 +6004,13 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 	 * flag the packet data will have the 4 byte CRC appended
 	 */
 	if (changed & NETIF_F_RXFCS) {
+		if ((features & NETIF_F_RXFCS) &&
+		    (features & NETIF_VLAN_STRIPPING_FEATURES)) {
+			dev_err(ice_pf_to_dev(vsi->back),
+				"To disable FCS/CRC stripping, you must first disable VLAN stripping\n");
+			return -EIO;
+		}
+
 		ice_vsi_cfg_crc_strip(vsi, !!(features & NETIF_F_RXFCS));
 		ret = ice_down_up(vsi);
 		if (ret)
-- 
2.35.1

