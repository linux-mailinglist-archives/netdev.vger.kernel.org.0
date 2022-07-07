Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038DB569F81
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 12:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbiGGKU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 06:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbiGGKUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 06:20:55 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4F99FE2
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 03:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657189252; x=1688725252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LpvEXEB+aClRXGavyoR0tZrzMaYeifUE4rYmPfB1/9U=;
  b=Ouc2x7J/VJCFG/7gV4KrsFToXJu0sN28GNKZ0Sai46KPy5IsLfWvubem
   WbP2mTzR5TFv+n6pguhd1j2nmyN4HkhYs+PCCBF7JON5UOoDVW2UWgdDp
   BoT2pBu33dKadaYnJrZpMmRmoRq3LuayfbsSUsrtkzwLZmWMz2V4zKZO4
   WUpMunN7daEtt1TZDI+06Vhwwd1n2mlVWAtgGqQRh5ICyULul0Wg4KVXP
   3MKGbOMhYn0v9iHhyDpbGAsfb6zAoEzTJHHS80hmkVPhlLyCzC+8kje6b
   cuA8B82VoG5xyDFp0S8CQW4KqPD7BcI8KjBM76C9/1FBP5iGx20xVhQl4
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="347972250"
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="347972250"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 03:20:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="696458217"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jul 2022 03:20:48 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        kuba@kernel.org, davem@davemloft.net, magnus.karlsson@intel.com,
        anatolii.gerasymenko@intel.com, alexandr.lobakin@intel.com,
        john.fastabend@gmail.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net 1/2] ice: check (DD | EOF) bits on Rx descriptor rather than (EOP | RS)
Date:   Thu,  7 Jul 2022 12:20:42 +0200
Message-Id: <20220707102044.48775-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220707102044.48775-1-maciej.fijalkowski@intel.com>
References: <20220707102044.48775-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tx side sets EOP and RS bits on descriptors to indicate that a
particular descriptor is the last one and needs to generate an irq when
it was sent. These bits should not be checked on completion path
regardless whether it's the Tx or the Rx. DD bit serves this purpose and
it indicates that a particular descriptor is either for Rx or was
successfully Txed. EOF is also set as loopback test does not xmit
fragmented frames.

Look at (DD | EOF) bits setting in ice_lbtest_receive_frames() instead
of EOP and RS pair.

Fixes: 0e674aeb0b77 ("ice: Add handler for ethtool selftest")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 70335f6e8524..4efa5e5846e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -658,7 +658,8 @@ static int ice_lbtest_receive_frames(struct ice_rx_ring *rx_ring)
 		rx_desc = ICE_RX_DESC(rx_ring, i);
 
 		if (!(rx_desc->wb.status_error0 &
-		    cpu_to_le16(ICE_TX_DESC_CMD_EOP | ICE_TX_DESC_CMD_RS)))
+		    (cpu_to_le16(BIT(ICE_RX_FLEX_DESC_STATUS0_DD_S)) |
+		     cpu_to_le16(BIT(ICE_RX_FLEX_DESC_STATUS0_EOF_S)))))
 			continue;
 
 		rx_buf = &rx_ring->rx_buf[i];
-- 
2.27.0

