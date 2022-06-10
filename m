Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9C5546916
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbiFJPJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbiFJPJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:09:45 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40D1104C9D;
        Fri, 10 Jun 2022 08:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654873784; x=1686409784;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hLfP1Ps0iAuRPRTqfGTHnJR7oFfSvIiolsiTbIHvb2Q=;
  b=cYzZV4yMFFzIj9PEKaR9m51UHUfXOu/Ld/k8ZqHzdjevXHSqFY/+jPvv
   E0vKWi3BS7132DqOn2m9TWf7ljy7Igs7rGYt1qhgdvN058cS+wM2Cj8BM
   GPXhG3zfRof+Wrp51QP5zFhMTBpdbUVttMa8T/79YRC3ihIWH7J0kWeeV
   Sd2skhd+FUPkrgrwDIYCT4LIm4Y4YV8xRcMjJ+jsFMcexRqrTRp4vDNvN
   L0Gsip25uc8nXwZ5EwO3bNk4y3i6go87F6plBMPGYFsvb0MA1NMKxMiWX
   TzM0BNrqTxtAPtzOTgC5angVVlQvnJixN6NWYgyStFmyhexCR6ABQ0prr
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="278788421"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="278788421"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 08:09:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638176177"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 10 Jun 2022 08:09:42 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 01/10] ice: introduce priv-flag for toggling loopback mode
Date:   Fri, 10 Jun 2022 17:09:14 +0200
Message-Id: <20220610150923.583202-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220610150923.583202-1-maciej.fijalkowski@intel.com>
References: <20220610150923.583202-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a knob that will allow user to turn the underlying net device into
loopback mode. The use case for this will be the AF_XDP ZC tests. Once
the device is in loopback mode, then it will be possible from AF_XDP
perspective to see if zero copy implementations in drivers work
properly.

The code for interaction with admin queue is reused from ethtool's
loopback test.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 60453b3b8d23..90c066f3782b 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -487,6 +487,7 @@ enum ice_pf_flags {
 	ICE_FLAG_PLUG_AUX_DEV,
 	ICE_FLAG_MTU_CHANGED,
 	ICE_FLAG_GNSS,			/* GNSS successfully initialized */
+	ICE_FLAG_LOOPBACK,
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 1e71b70f0e52..cfc3c5e36907 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -166,6 +166,7 @@ static const struct ice_priv_flag ice_gstrings_priv_flags[] = {
 	ICE_PRIV_FLAG("mdd-auto-reset-vf", ICE_FLAG_MDD_AUTO_RESET_VF),
 	ICE_PRIV_FLAG("vf-vlan-pruning", ICE_FLAG_VF_VLAN_PRUNING),
 	ICE_PRIV_FLAG("legacy-rx", ICE_FLAG_LEGACY_RX),
+	ICE_PRIV_FLAG("loopback", ICE_FLAG_LOOPBACK),
 };
 
 #define ICE_PRIV_FLAG_ARRAY_SIZE	ARRAY_SIZE(ice_gstrings_priv_flags)
@@ -1288,6 +1289,22 @@ static int ice_set_priv_flags(struct net_device *netdev, u32 flags)
 			ice_up(vsi);
 		}
 	}
+
+	if (test_bit(ICE_FLAG_LOOPBACK, change_flags)) {
+		if (!test_bit(ICE_FLAG_LOOPBACK, orig_flags)) {
+			/* Enable MAC loopback in firmware */
+			if (ice_aq_set_mac_loopback(&pf->hw, true, NULL)) {
+				dev_err(dev, "Failed to enable loopback\n");
+				ret = -ENXIO;
+			}
+		} else {
+			/* Disable MAC loopback in firmware */
+			if (ice_aq_set_mac_loopback(&pf->hw, false, NULL)) {
+				dev_err(dev, "Failed to disable loopback\n");
+				ret = -ENXIO;
+			}
+		}
+	}
 	/* don't allow modification of this flag when a single VF is in
 	 * promiscuous mode because it's not supported
 	 */
-- 
2.27.0

