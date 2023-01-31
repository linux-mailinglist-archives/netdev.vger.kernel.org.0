Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFB46837C2
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjAaUpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjAaUpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:45:43 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341CC59B41;
        Tue, 31 Jan 2023 12:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675197933; x=1706733933;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ckiQmM973dMAl5oTy8Y59xEi2bspMtjYPeLZuf6LzCk=;
  b=JxIl4rGgVd5un12W8Itq+lr+ALD/jrNDL2P4fNTNhmZCURGxa9XDbTdy
   Qwx0XsB1j5hB7rjoAWN5PVpmGBnAGMGwTcNLLdOmui21L0nElonAdg+bG
   wR5w6uq6Ki+6fPXMEPnKL+N1qWn9HrlgtnPiOtT55WEY7Z1cqQ1lIP12R
   MFxmcbicnUrQjONs9cvzbWidZQpOoJXjxzvdJEzHhE0GmCu7tsuyG2a0r
   0eeQdhJufiGSJRCVNH5HyaQyihgOSX0vwCsin6fzLpPOuPIeIYfM5bjkV
   v+XfrwpXBErkH8yDadVBLRy7oT7ZsOP1fR01paa+YIiabvG6/UvTt0G0e
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="414167190"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="414167190"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 12:45:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="788595293"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="788595293"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2023 12:45:26 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 07/13] ice: use ice_max_xdp_frame_size() in ice_xdp_setup_prog()
Date:   Tue, 31 Jan 2023 21:45:00 +0100
Message-Id: <20230131204506.219292-8-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
References: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This should have been used in there from day 1, let us address that
before introducing XDP multi-buffer support for Rx side.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 28 +++++++++++------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 88b4a017990d..a9d644276dfd 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2862,6 +2862,18 @@ int ice_vsi_determine_xdp_res(struct ice_vsi *vsi)
 	return 0;
 }
 
+/**
+ * ice_max_xdp_frame_size - returns the maximum allowed frame size for XDP
+ * @vsi: Pointer to VSI structure
+ */
+static int ice_max_xdp_frame_size(struct ice_vsi *vsi)
+{
+	if (test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags))
+		return ICE_RXBUF_1664;
+	else
+		return ICE_RXBUF_3072;
+}
+
 /**
  * ice_xdp_setup_prog - Add or remove XDP eBPF program
  * @vsi: VSI to setup XDP for
@@ -2872,11 +2884,11 @@ static int
 ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 		   struct netlink_ext_ack *extack)
 {
-	int frame_size = vsi->netdev->mtu + ICE_ETH_PKT_HDR_PAD;
+	unsigned int frame_size = vsi->netdev->mtu + ICE_ETH_PKT_HDR_PAD;
 	bool if_running = netif_running(vsi->netdev);
 	int ret = 0, xdp_ring_err = 0;
 
-	if (frame_size > vsi->rx_buf_len) {
+	if (frame_size > ice_max_xdp_frame_size(vsi)) {
 		NL_SET_ERR_MSG_MOD(extack, "MTU too large for loading XDP");
 		return -EOPNOTSUPP;
 	}
@@ -7321,18 +7333,6 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 	dev_err(dev, "Rebuild failed, unload and reload driver\n");
 }
 
-/**
- * ice_max_xdp_frame_size - returns the maximum allowed frame size for XDP
- * @vsi: Pointer to VSI structure
- */
-static int ice_max_xdp_frame_size(struct ice_vsi *vsi)
-{
-	if (test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags))
-		return ICE_RXBUF_1664;
-	else
-		return ICE_RXBUF_3072;
-}
-
 /**
  * ice_change_mtu - NDO callback to change the MTU
  * @netdev: network interface device structure
-- 
2.34.1

