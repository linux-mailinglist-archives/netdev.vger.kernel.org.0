Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C42354E915
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 20:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376452AbiFPSGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 14:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbiFPSGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 14:06:34 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BC34CD54;
        Thu, 16 Jun 2022 11:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655402794; x=1686938794;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D5KPza/kgLdh1wzhegt7VKlkovGKoDj3NRf/x28hTqA=;
  b=CqqUqSZMtoQmLs3S5jHZd9Y7jbF6FxmeVrpzS5fTbTM3Vqcw0KtKDZC4
   XW8JL/p/yKb/moWQBlQ2Kj//ky0j+B7k1ot+pYGO60OzMyYFpG1yJ/uWv
   p49bkrZvqj3iRexjF8Qt5DtZAbKndlh7d5mwsWGtNtQHVsmCRXj57VJLd
   YOjivVBCmeBMy99K7tXGMqbAAglkxgLOnvIDEeRy82XtTlJTbdbMLxg0k
   LFs2nilB6qWQ50Kc9mTMP7Jn740x6dZVd2nQNOtNmZa1KoRlTgQh4xAvf
   /pmgNgjABF19a3laSLWPoJXc/O89HDf9oP+g3bwU19580gQCzFpsbDtcz
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="343275919"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="343275919"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 11:06:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="641664310"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 16 Jun 2022 11:06:26 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v4 bpf-next 03/10] ice: check DD bit on Rx descriptor rather than (EOP | RS)
Date:   Thu, 16 Jun 2022 20:06:02 +0200
Message-Id: <20220616180609.905015-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
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
index 1e71b70f0e52..b6275a29fa0d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -658,7 +658,7 @@ static int ice_lbtest_receive_frames(struct ice_rx_ring *rx_ring)
 		rx_desc = ICE_RX_DESC(rx_ring, i);
 
 		if (!(rx_desc->wb.status_error0 &
-		    cpu_to_le16(ICE_TX_DESC_CMD_EOP | ICE_TX_DESC_CMD_RS)))
+		    cpu_to_le16(BIT(ICE_RX_FLEX_DESC_STATUS0_DD_S))))
 			continue;
 
 		rx_buf = &rx_ring->rx_buf[i];
-- 
2.27.0

