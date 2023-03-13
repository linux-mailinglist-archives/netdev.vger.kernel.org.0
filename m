Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009436B82D5
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjCMUgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjCMUgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:36:20 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CC462DA2
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678739779; x=1710275779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nD0xEsja5qWGknrZQyyc58B4k+83OgAe1HUr/wkbYVI=;
  b=lwvpUaErWzNj0339su/ngZo8AHWY9dr+VdoCOtnMmgRgX1gFBr6LxYo+
   km/aLpJAMIGJDQWfEvYktllS3u+i3tMZ2R6d6K7AcyPSDYR6Cv5HuRDRG
   SUbmWQgyBE/7bf65jCbRQi3IRXU5aLXcmUBkQYXaswst4H8QCVHgQVqGZ
   DOu2/mIgOm0hve5tcaYT/fMg7uMGwaRHTqYR4SRZwnSOdSfTQJznchU+6
   /+KydSfjWx2ibzUlXXGNQZ3tyxWtipd0Ek+/y7c+iSTw7FHroSQO+0D/4
   G3dmFb06T+wgI4GvAzUB+82Lyl7fysNwpkLoMGu3p8PRh5pHj/HSwLRXl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="364913218"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="364913218"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 13:36:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="747732597"
X-IronPort-AV: E=Sophos;i="5.98,257,1673942400"; 
   d="scan'208";a="747732597"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.102])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 13:36:17 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Piotr Raczynski <piotr.raczynski@intel.com>
Subject: [PATCH net v1 1/2] ice: fix W=1 headers mismatch
Date:   Mon, 13 Mar 2023 13:36:07 -0700
Message-Id: <20230313203608.1680781-2-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313203608.1680781-1-jesse.brandeburg@intel.com>
References: <20230313203608.1680781-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

make modules W=1 returns:
.../ice/ice_txrx_lib.c:448: warning: Function parameter or member 'first_idx' not described in 'ice_finalize_xdp_rx'
.../ice/ice_txrx.c:948: warning: Function parameter or member 'ntc' not described in 'ice_get_rx_buf'
.../ice/ice_txrx.c:1038: warning: Excess function parameter 'rx_buf' description in 'ice_construct_skb'

Fix these warnings by adding and deleting the deviant arguments.

Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
Fixes: d7956d81f150 ("ice: Pull out next_to_clean bump out of ice_put_rx_buf()")
CC: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 2 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index dfd22862e926..21c1e1bb214a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -938,6 +938,7 @@ ice_reuse_rx_page(struct ice_rx_ring *rx_ring, struct ice_rx_buf *old_buf)
  * ice_get_rx_buf - Fetch Rx buffer and synchronize data for use
  * @rx_ring: Rx descriptor ring to transact packets on
  * @size: size of buffer to add to skb
+ * @ntc: index of next to clean element
  *
  * This function will pull an Rx buffer from the ring and synchronize it
  * for use by the CPU.
@@ -1026,7 +1027,6 @@ ice_build_skb(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp)
 /**
  * ice_construct_skb - Allocate skb and populate it
  * @rx_ring: Rx descriptor ring to transact packets on
- * @rx_buf: Rx buffer to pull data from
  * @xdp: xdp_buff pointing to the data
  *
  * This function allocates an skb. It then populates it with the page
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 7bc5aa340c7d..c8322fb6f2b3 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -438,6 +438,7 @@ int __ice_xmit_xdp_ring(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring,
  * ice_finalize_xdp_rx - Bump XDP Tx tail and/or flush redirect map
  * @xdp_ring: XDP ring
  * @xdp_res: Result of the receive batch
+ * @first_idx: index to write from caller
  *
  * This function bumps XDP Tx tail and/or flush redirect map, and
  * should be called when a batch of packets has been processed in the
-- 
2.39.2

