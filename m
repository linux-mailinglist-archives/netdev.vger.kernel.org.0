Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94613628DE9
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 01:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbiKOADg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 19:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiKOADc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 19:03:32 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9D360E3;
        Mon, 14 Nov 2022 16:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668470611; x=1700006611;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ir9H701JWAnHlmhyZVK/qniII0MRbkTVvLWle5mHHSA=;
  b=Y6TS38CvdSvsyo+j4IJ2iJZaUXJgBRh8VqZVnga57LB8D56hZJIAAcOI
   8T3KjjjMvrpkk0/mnU9pp5bP45QHhSzemnCxsRVWItFTC5aFSmulDQmIJ
   w8R0FR0TAD59Qj7AQpp9Kc/eu48PYRVwXMQPWgxr0Uw0jJD57sJTWqiKg
   5Y9hlZgMSWwm8yPglAwd9oEL5psN3Le4Wx2oCGRqOdJRxPa7YGC5tDcd/
   TWS1TgvbOMypw3ckMRcXCOqFOmBwyWR+03/sxZI0T+xRGlpUiDr5oF64A
   j+S8Wg92+0aDQqTIlBiFxS1Jg9MwYFiw1dktt/G/SJF80EOwQYTbhZs8K
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="310824665"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="310824665"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 16:03:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="669870406"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="669870406"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 14 Nov 2022 16:03:29 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Bartosz Staszewski <bartoszx.staszewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
Subject: [PATCH net 2/2] i40e: fix xdp_redirect logs error message when testing with MTU=1500
Date:   Mon, 14 Nov 2022 16:03:24 -0800
Message-Id: <20221115000324.3040207-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221115000324.3040207-1-anthony.l.nguyen@intel.com>
References: <20221115000324.3040207-1-anthony.l.nguyen@intel.com>
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

From: Bartosz Staszewski <bartoszx.staszewski@intel.com>

The driver is currently logging an error message "MTU too large to enable XDP"
when trying to enable XDP on totally normal MTU.

This was caused by whenever the interface was down, function
i40e_xdp was passing vsi->rx_buf_len field to i40e_xdp_setup()
which was equal 0. i40e_open() then  calls i40e_vsi_configure_rx()
which configures that field, but that only happens when interface is up.
When it is down, i40e_open() is not being called, thus vsi->rx_buf_len
which causes the bug is not set.

Solution for this is calculate buffer length in newly created
function - i40e_calculate_vsi_rx_buf_len() that return actual buffer
length. Buffer length is being calculated based on the same rules applied
previously in i40e_vsi_configure_rx() function.

Fixes: 613142b0bb88 ("i40e: Log error for oversized MTU on device")
Signed-off-by: Bartosz Staszewski <bartoszx.staszewski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 42 +++++++++++++++------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 41112f92f9ef..4b3b6e5b612d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3695,6 +3695,30 @@ static int i40e_vsi_configure_tx(struct i40e_vsi *vsi)
 	return err;
 }
 
+/**
+ * i40e_calculate_vsi_rx_buf_len - Calculates buffer length
+ *
+ * @vsi: VSI to calculate rx_buf_len from
+ */
+static u16 i40e_calculate_vsi_rx_buf_len(struct i40e_vsi *vsi)
+{
+	u16 ret;
+
+	if (!vsi->netdev || (vsi->back->flags & I40E_FLAG_LEGACY_RX)) {
+		ret = I40E_RXBUFFER_2048;
+#if (PAGE_SIZE < 8192)
+	} else if (!I40E_2K_TOO_SMALL_WITH_PADDING &&
+		   (vsi->netdev->mtu <= ETH_DATA_LEN)) {
+		ret = I40E_RXBUFFER_1536 - NET_IP_ALIGN;
+#endif
+	} else {
+		ret = (PAGE_SIZE < 8192) ? I40E_RXBUFFER_3072 :
+					   I40E_RXBUFFER_2048;
+	}
+
+	return ret;
+}
+
 /**
  * i40e_vsi_configure_rx - Configure the VSI for Rx
  * @vsi: the VSI being configured
@@ -3706,20 +3730,14 @@ static int i40e_vsi_configure_rx(struct i40e_vsi *vsi)
 	int err = 0;
 	u16 i;
 
-	if (!vsi->netdev || (vsi->back->flags & I40E_FLAG_LEGACY_RX)) {
-		vsi->max_frame = I40E_MAX_RXBUFFER;
-		vsi->rx_buf_len = I40E_RXBUFFER_2048;
+	vsi->max_frame = I40E_MAX_RXBUFFER;
+	vsi->rx_buf_len = i40e_calculate_vsi_rx_buf_len(vsi);
+
 #if (PAGE_SIZE < 8192)
-	} else if (!I40E_2K_TOO_SMALL_WITH_PADDING &&
-		   (vsi->netdev->mtu <= ETH_DATA_LEN)) {
+	if (vsi->netdev && !I40E_2K_TOO_SMALL_WITH_PADDING &&
+	    vsi->netdev->mtu <= ETH_DATA_LEN)
 		vsi->max_frame = I40E_RXBUFFER_1536 - NET_IP_ALIGN;
-		vsi->rx_buf_len = I40E_RXBUFFER_1536 - NET_IP_ALIGN;
 #endif
-	} else {
-		vsi->max_frame = I40E_MAX_RXBUFFER;
-		vsi->rx_buf_len = (PAGE_SIZE < 8192) ? I40E_RXBUFFER_3072 :
-						       I40E_RXBUFFER_2048;
-	}
 
 	/* set up individual rings */
 	for (i = 0; i < vsi->num_queue_pairs && !err; i++)
@@ -13267,7 +13285,7 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 	int i;
 
 	/* Don't allow frames that span over multiple buffers */
-	if (frame_size > vsi->rx_buf_len) {
+	if (frame_size > i40e_calculate_vsi_rx_buf_len(vsi)) {
 		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
 		return -EINVAL;
 	}
-- 
2.35.1

