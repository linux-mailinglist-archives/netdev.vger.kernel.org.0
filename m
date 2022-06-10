Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A465A54691F
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236330AbiFJPJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbiFJPJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:09:47 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A3B3F32A;
        Fri, 10 Jun 2022 08:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654873786; x=1686409786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yT1pPQaPfNKJ7eMGJ6AJ+7V6AtWUkqoN5MiBpXzDc5s=;
  b=OGLH11KQeKJ7Zk1MTZDhw62QKG+QeeVEWDXnrjKA1oWaX8Zr9JukBD36
   msxnfRBJXg65Jzy3AMyJgA3Mib6H9SblarrBQ1aFTcKZJhT4/QjnvNwDt
   iURPsCp00UwEefb8Sx9qBdYMZsZX3s4UGoQVg89GkEXy4vjC/UJ4xm5kC
   lwqxa3iYTTyfPS1rOro4e8X659VFajU9ZJAg5CVEhZkTbDf+FhOEU2STb
   7mwbQH5U5tpHGE1Xjjbd38emy9LX1qi4PPPCF9/f1IoAKqWBpQf9la//o
   ydU+WMgOSS9paKJdlPCCPTIKf9tEyJxvD6irYa/cYKlgtau+beZK3Pcgp
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="278788442"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="278788442"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 08:09:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638176191"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 10 Jun 2022 08:09:44 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 02/10] ice: check DD bit on Rx descriptor rather than (EOP | RS)
Date:   Fri, 10 Jun 2022 17:09:15 +0200
Message-Id: <20220610150923.583202-3-maciej.fijalkowski@intel.com>
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

Tx side sets EOP and RS bits on descriptors to indicate that a
particular descriptor is the last one and needs to generate an irq when
it was sent. These bits should not be checked on completion path
regardless whether it's the Tx or the Rx. DD bit serves this purpose and
it indicates that a particular descriptor is either for Rx or was
successfully Txed.

Look at DD bit being set in ice_lbtest_receive_frames() instead of EOP
and RS pair.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index cfc3c5e36907..3d595345cdfa 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -659,7 +659,7 @@ static int ice_lbtest_receive_frames(struct ice_rx_ring *rx_ring)
 		rx_desc = ICE_RX_DESC(rx_ring, i);
 
 		if (!(rx_desc->wb.status_error0 &
-		    cpu_to_le16(ICE_TX_DESC_CMD_EOP | ICE_TX_DESC_CMD_RS)))
+		    cpu_to_le16(BIT(ICE_RX_FLEX_DESC_STATUS0_DD_S))))
 			continue;
 
 		rx_buf = &rx_ring->rx_buf[i];
-- 
2.27.0

