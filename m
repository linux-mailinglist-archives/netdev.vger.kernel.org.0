Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD954596108
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 19:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbiHPRYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 13:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiHPRYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 13:24:01 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D5452FC8
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660670640; x=1692206640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7lZ5nAY/oqsiIbAAlSbL0N48DzRCm+lSm5sYEmdaViw=;
  b=UTBDWOh/EO4DmCo6F8QEooRSQ2NBxgrLoxPzKAiyky089YNShOgk/Cq1
   vtOe4Tc8nPV9fngDghYwBLfbdoMZnk/tHdQs6jso8Hfh59vNO0qCA9TiQ
   8yr9CBuMDM6fwdS9AP4qh35SJx+HLHdpfTfAmAuRJKztCkOnrxS5o/CO+
   FT9H690LsZbV5S78LxCUgpZQe9bA4+TVey78qU5O0TIqXepJSunNWVuTo
   lK2onGgqtQ4eT2zIZodcba/P26Kpd6QhgbUDFob7iLVrzCfkbTySxjRr1
   +TBbEw/gffTMazHrXZOpTmYc9yNNetjcx4MyHWilRhTT2v1tjQiGkyz4E
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="318281035"
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="318281035"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 10:23:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,241,1654585200"; 
   d="scan'208";a="610340364"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 16 Aug 2022 10:23:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/6] ice: initialize cached_phctime when creating Rx rings
Date:   Tue, 16 Aug 2022 10:23:48 -0700
Message-Id: <20220816172352.2532304-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220816172352.2532304-1-anthony.l.nguyen@intel.com>
References: <20220816172352.2532304-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

When we create new Rx rings, the cached_phctime field is zero initialized.
This could result in incorrect timestamp reporting due to the cached value
not yet being updated. Although a background task will periodically update
the cached value, ensure it matches the existing cached value in the PF
structure at ring initialization.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 1 +
 drivers/net/ethernet/intel/ice/ice_lib.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index bbf6a300078e..3a18762cc38f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2885,6 +2885,7 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 		/* clone ring and setup updated count */
 		rx_rings[i] = *vsi->rx_rings[i];
 		rx_rings[i].count = new_rx_cnt;
+		rx_rings[i].cached_phctime = pf->ptp.cached_phc_time;
 		rx_rings[i].desc = NULL;
 		rx_rings[i].rx_buf = NULL;
 		/* this is to allow wr32 to have something to write to
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index a830f7f9aed0..679529040edd 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1522,6 +1522,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 		ring->netdev = vsi->netdev;
 		ring->dev = dev;
 		ring->count = vsi->num_rx_desc;
+		ring->cached_phctime = pf->ptp.cached_phc_time;
 		WRITE_ONCE(vsi->rx_rings[i], ring);
 	}
 
-- 
2.35.1

