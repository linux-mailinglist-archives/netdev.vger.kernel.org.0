Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC076B2F96
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 22:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbjCIV3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 16:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbjCIV3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 16:29:47 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22586E1939;
        Thu,  9 Mar 2023 13:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678397386; x=1709933386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qlEGnePAxwcjA7kwnk6l4k4Ctmh1+6r+8FPIs/MQz0g=;
  b=JRxJb1ugI4cSH2yxk98/y258ATrHZ2i93KUuC4yeLZPPwIi5qZDMKwhX
   uPoUycFH9Ud7iNHoUG1niRkOLYhv7Z90r0QRHXx55SQ8eIkdKIb+gF4BL
   ysU1dTae85q6Q+xDSaH3QA8+T6a2yTcFXolwukhUPq+iGCkidfl8+TszG
   O3Omy/1i6j8EBnmkMZIhUxAemJWlsm9RDvOKwoHge3dutk98MiCacjlTj
   styOb1P6O53njcVL4E963zsiX06tYTTjMF+V2dHL/9++SaFRaCybaqtCN
   tlhKhQ6q5xNvPOsjsvdgXWwbx2DZSm1tEriuszx1e3OnOrC8gYu7uyTXa
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="338126121"
X-IronPort-AV: E=Sophos;i="5.98,247,1673942400"; 
   d="scan'208";a="338126121"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 13:29:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="710011431"
X-IronPort-AV: E=Sophos;i="5.98,247,1673942400"; 
   d="scan'208";a="710011431"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 09 Mar 2023 13:29:45 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH net-next v2 2/8] i40e: change Rx buffer size for legacy-rx to support XDP multi-buffer
Date:   Thu,  9 Mar 2023 13:28:13 -0800
Message-Id: <20230309212819.1198218-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230309212819.1198218-1-anthony.l.nguyen@intel.com>
References: <20230309212819.1198218-1-anthony.l.nguyen@intel.com>
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

From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>

Adding support for XDP multi-buffer entails adding information of all
the fragments of the packet in the xdp_buff. This approach implies that
underlying buffer has to provide tailroom for skb_shared_info.

In the legacy-rx mode, driver can only configure up to 2k sized Rx buffers
and with the current configuration of 2k sized Rx buffers there is no way
to do tailroom reservation for skb_shared_info. Hence size of Rx buffers
is now lowered to 2048 - sizeof(skb_shared_info). Also, driver can only
chain up to 5 Rx buffers and this means max MTU supported for legacy-rx
is now 8614 (5 * rx_buffer_len  - ETH header with VLAN).

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |  7 +++++++
 drivers/net/ethernet/intel/i40e/i40e_main.c    | 12 +++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 4934ff58332c..afc4fa8c66af 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -5402,6 +5402,13 @@ static int i40e_set_priv_flags(struct net_device *dev, u32 flags)
 		return -EOPNOTSUPP;
 	}
 
+	if ((changed_flags & I40E_FLAG_LEGACY_RX) &&
+	    I40E_2K_TOO_SMALL_WITH_PADDING) {
+		dev_warn(&pf->pdev->dev,
+			 "2k Rx buffer is too small to fit standard MTU and skb_shared_info\n");
+		return -EOPNOTSUPP;
+	}
+
 	if ((changed_flags & new_flags &
 	     I40E_FLAG_LINK_DOWN_ON_CLOSE_ENABLED) &&
 	    (new_flags & I40E_FLAG_MFP_ENABLED))
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index d375d7940308..e8cf5644bf10 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2903,7 +2903,7 @@ static void i40e_sync_filters_subtask(struct i40e_pf *pf)
 static u16 i40e_calculate_vsi_rx_buf_len(struct i40e_vsi *vsi)
 {
 	if (!vsi->netdev || (vsi->back->flags & I40E_FLAG_LEGACY_RX))
-		return I40E_RXBUFFER_2048;
+		return SKB_WITH_OVERHEAD(I40E_RXBUFFER_2048);
 
 	return PAGE_SIZE < 8192 ? I40E_RXBUFFER_3072 : I40E_RXBUFFER_2048;
 }
@@ -3661,10 +3661,16 @@ static int i40e_configure_rx_ring(struct i40e_ring *ring)
 	}
 
 	/* configure Rx buffer alignment */
-	if (!vsi->netdev || (vsi->back->flags & I40E_FLAG_LEGACY_RX))
+	if (!vsi->netdev || (vsi->back->flags & I40E_FLAG_LEGACY_RX)) {
+		if (I40E_2K_TOO_SMALL_WITH_PADDING) {
+			dev_info(&vsi->back->pdev->dev,
+				 "2k Rx buffer is too small to fit standard MTU and skb_shared_info\n");
+			return -EOPNOTSUPP;
+		}
 		clear_ring_build_skb_enabled(ring);
-	else
+	} else {
 		set_ring_build_skb_enabled(ring);
+	}
 
 	ring->rx_offset = i40e_rx_offset(ring);
 
-- 
2.38.1

