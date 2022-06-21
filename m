Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D39553ED8
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 01:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355032AbiFUXCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 19:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355001AbiFUXCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 19:02:34 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE801E3F1
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 16:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655852552; x=1687388552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BWdIhfTTAKwch6FlAu3vjjaKV8qRe/7dsu1JfntWhBY=;
  b=hvzxUGodPwBoXlLBhmOn8PkQPm6S49jk9JDcTqvsFViryNq6tt7iDzI/
   rCmGefmv8m9QzGGybm6jMukmpwvmUT6yOrb1oYzIOZXFAGaSaXHFp5IG9
   09budonH2FbxEtxXRgtImdmI+Dn+9PAhSGLKKmhQJ7h18WCbOa17s/KHU
   71fT5V+rRwNadyD2CMTu40Z3NgYrmHbn1A37rT4TLwa/z4vUn4GdEjxid
   GleG/EoSUY5+9EOrUQ4m/LECQgBymTc5pTW+GPE7cNowm/gT67Fj6jxPv
   5yvGmpG+1AXRrJ5mFcMo0CLmw79ousyEMd3GGznPFByfEA/R8IgSNBfyF
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="341943792"
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="341943792"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 16:02:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="677234984"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Jun 2022 16:02:31 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Norbert Zulinski <norbertx.zulinski@intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 1/3] i40e: Add support for ethtool -s <interface> speed <speed in Mb>
Date:   Tue, 21 Jun 2022 15:59:28 -0700
Message-Id: <20220621225930.632741-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621225930.632741-1-anthony.l.nguyen@intel.com>
References: <20220621225930.632741-1-anthony.l.nguyen@intel.com>
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

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Add ability to change speed through ethtool -s <interface> speed <speed in Mb>
Driver advertises all link modes that support requested speed.
Autoneg must be set off e.g.:
	ethtool -s <interface> autoneg off speed <speed in Mb>.

Add helper function that translate speed in Mb to
enum i40e_aq_link_speed and compare it to supported speeds from
given ethtool_link_ksettings. Add in i40e_set_link_ksettings hold
for requested speed and set copy_ks.base.speed to safe_ks.base.speed
to be sure that user is not changing unsupported setting.
In i40e_speed_to_link_speed compare requested speed with supported
speeds. Set speed to requested speed.

Signed-off-by: Norbert Zulinski <norbertx.zulinski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 90 +++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 552aad6ae1ca..55841816272b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1143,6 +1143,71 @@ static int i40e_get_link_ksettings(struct net_device *netdev,
 	return 0;
 }
 
+#define I40E_LBIT_SIZE 8
+/**
+ * i40e_speed_to_link_speed - Translate decimal speed to i40e_aq_link_speed
+ * @speed: speed in decimal
+ * @ks: ethtool ksettings
+ *
+ * Return i40e_aq_link_speed based on speed
+ **/
+static enum i40e_aq_link_speed
+i40e_speed_to_link_speed(__u32 speed, const struct ethtool_link_ksettings *ks)
+{
+	enum i40e_aq_link_speed link_speed = I40E_LINK_SPEED_UNKNOWN;
+	bool speed_changed = false;
+	int i, j;
+
+	static const struct {
+		__u32 speed;
+		enum i40e_aq_link_speed link_speed;
+		__u8 bit[I40E_LBIT_SIZE];
+	} i40e_speed_lut[] = {
+#define I40E_LBIT(mode) ETHTOOL_LINK_MODE_ ## mode ##_Full_BIT
+		{SPEED_100, I40E_LINK_SPEED_100MB, {I40E_LBIT(100baseT)} },
+		{SPEED_1000, I40E_LINK_SPEED_1GB,
+		 {I40E_LBIT(1000baseT), I40E_LBIT(1000baseX),
+		  I40E_LBIT(1000baseKX)} },
+		{SPEED_10000, I40E_LINK_SPEED_10GB,
+		 {I40E_LBIT(10000baseT), I40E_LBIT(10000baseKR),
+		  I40E_LBIT(10000baseLR), I40E_LBIT(10000baseCR),
+		  I40E_LBIT(10000baseSR), I40E_LBIT(10000baseKX4)} },
+
+		{SPEED_25000, I40E_LINK_SPEED_25GB,
+		 {I40E_LBIT(25000baseCR), I40E_LBIT(25000baseKR),
+		  I40E_LBIT(25000baseSR)} },
+		{SPEED_40000, I40E_LINK_SPEED_40GB,
+		 {I40E_LBIT(40000baseKR4), I40E_LBIT(40000baseCR4),
+		  I40E_LBIT(40000baseSR4), I40E_LBIT(40000baseLR4)} },
+		{SPEED_20000, I40E_LINK_SPEED_20GB,
+		 {I40E_LBIT(20000baseKR2)} },
+		{SPEED_2500, I40E_LINK_SPEED_2_5GB, {I40E_LBIT(2500baseT)} },
+		{SPEED_5000, I40E_LINK_SPEED_5GB, {I40E_LBIT(2500baseT)} }
+#undef I40E_LBIT
+};
+
+	for (i = 0; i < ARRAY_SIZE(i40e_speed_lut); i++) {
+		if (i40e_speed_lut[i].speed == speed) {
+			for (j = 0; j < I40E_LBIT_SIZE; j++) {
+				if (test_bit(i40e_speed_lut[i].bit[j],
+					     ks->link_modes.supported)) {
+					speed_changed = true;
+					break;
+				}
+				if (!i40e_speed_lut[i].bit[j])
+					break;
+			}
+			if (speed_changed) {
+				link_speed = i40e_speed_lut[i].link_speed;
+				break;
+			}
+		}
+	}
+	return link_speed;
+}
+
+#undef I40E_LBIT_SIZE
+
 /**
  * i40e_set_link_ksettings - Set Speed and Duplex
  * @netdev: network interface device structure
@@ -1159,12 +1224,14 @@ static int i40e_set_link_ksettings(struct net_device *netdev,
 	struct ethtool_link_ksettings copy_ks;
 	struct i40e_aq_set_phy_config config;
 	struct i40e_pf *pf = np->vsi->back;
+	enum i40e_aq_link_speed link_speed;
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_hw *hw = &pf->hw;
 	bool autoneg_changed = false;
 	i40e_status status = 0;
 	int timeout = 50;
 	int err = 0;
+	__u32 speed;
 	u8 autoneg;
 
 	/* Changing port settings is not supported if this isn't the
@@ -1197,6 +1264,7 @@ static int i40e_set_link_ksettings(struct net_device *netdev,
 
 	/* save autoneg out of ksettings */
 	autoneg = copy_ks.base.autoneg;
+	speed = copy_ks.base.speed;
 
 	/* get our own copy of the bits to check against */
 	memset(&safe_ks, 0, sizeof(struct ethtool_link_ksettings));
@@ -1215,6 +1283,7 @@ static int i40e_set_link_ksettings(struct net_device *netdev,
 
 	/* set autoneg back to what it currently is */
 	copy_ks.base.autoneg = safe_ks.base.autoneg;
+	copy_ks.base.speed  = safe_ks.base.speed;
 
 	/* If copy_ks.base and safe_ks.base are not the same now, then they are
 	 * trying to set something that we do not support.
@@ -1331,6 +1400,27 @@ static int i40e_set_link_ksettings(struct net_device *netdev,
 						  40000baseLR4_Full))
 		config.link_speed |= I40E_LINK_SPEED_40GB;
 
+	/* Autonegotiation must be disabled to change speed */
+	if ((speed != SPEED_UNKNOWN && safe_ks.base.speed != speed) &&
+	    (autoneg == AUTONEG_DISABLE ||
+	    (safe_ks.base.autoneg == AUTONEG_DISABLE && !autoneg_changed))) {
+		link_speed = i40e_speed_to_link_speed(speed, ks);
+		if (link_speed == I40E_LINK_SPEED_UNKNOWN) {
+			netdev_info(netdev, "Given speed is not supported\n");
+			err = -EOPNOTSUPP;
+			goto done;
+		} else {
+			config.link_speed = link_speed;
+		}
+	} else {
+		if (safe_ks.base.speed != speed) {
+			netdev_info(netdev,
+				    "Unable to set speed, disable autoneg\n");
+			err = -EOPNOTSUPP;
+			goto done;
+		}
+	}
+
 	/* If speed didn't get set, set it to what it currently is.
 	 * This is needed because if advertise is 0 (as it is when autoneg
 	 * is disabled) then speed won't get set.
-- 
2.35.1

