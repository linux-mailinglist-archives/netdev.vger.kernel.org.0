Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF006488AA
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiLISyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLISyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:54:20 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E503D938;
        Fri,  9 Dec 2022 10:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670612059; x=1702148059;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IPfcN1tqk+eEjGQLYmFVlFjParh6rw3yPz/bw3NOhLA=;
  b=KXe7d3u0wajNtQkbTJN2HtFPGQC7QHp3bdphuFR9+/fqmQthznPiwW8Z
   uzq8CHnJ7++AMNcnrGMKtAkMjf7BSRUz7F1ChWnPnFQZnDICT2e+7jpoD
   wv4/AlQwBheTuTM6ErwK76OJcyn7aWtxD7wJV4Z1ec5v+d6lgqSmgfgR5
   sZItvPo5i83ArWCRtrKrjJGv5OqFRgKKOs1vkJDzfSHm2gcLG9dh8Ocbv
   hbo+RZMrA5A/yH56tejwPsiknBitXZHH5k+bKFKAYn40CtnkpudL75J75
   pvq8hXquvyqLBtCE6ZMb8+bOxft+tuNcU1TLwPA+WWQW8ODmYwKeonVJh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="297206595"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="297206595"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 10:54:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="771948532"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="771948532"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 09 Dec 2022 10:54:18 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Bartosz Staszewski <bartoszx.staszewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        bjorn@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        saeed@kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
Subject: [PATCH net v3 1/1] i40e: Fix the inability to attach XDP program on downed interface
Date:   Fri,  9 Dec 2022 10:54:11 -0800
Message-Id: <20221209185411.2519898-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Staszewski <bartoszx.staszewski@intel.com>

Whenever trying to load XDP prog on downed interface, function i40e_xdp
was passing vsi->rx_buf_len field to i40e_xdp_setup() which was equal 0.
i40e_open() calls i40e_vsi_configure_rx() which configures that field,
but that only happens when interface is up. When it is down, i40e_open()
is not being called, thus vsi->rx_buf_len is not set.

Solution for this is calculate buffer length in newly created
function - i40e_calculate_vsi_rx_buf_len() that return actual buffer
length. Buffer length is being calculated based on the same rules
applied previously in i40e_vsi_configure_rx() function.

Fixes: 613142b0bb88 ("i40e: Log error for oversized MTU on device")
Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
Signed-off-by: Bartosz Staszewski <bartoszx.staszewski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
v3:
- Remove unnecessary braces and parentheses
- Simplify return in i40e_calculate_vsi_rx_buf_len(); return early on
if conditions and remove elses

v2: https://lore.kernel.org/netdev/20221207180842.1096243-1-anthony.l.nguyen@intel.com/
- Change title and rework commit message
- Dropped, previous, patch 1

v1: https://lore.kernel.org/netdev/20221115000324.3040207-1-anthony.l.nguyen@intel.com/

 drivers/net/ethernet/intel/i40e/i40e_main.c | 36 ++++++++++++++-------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6416322d7c18..e6e349f0c945 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3693,6 +3693,24 @@ static int i40e_vsi_configure_tx(struct i40e_vsi *vsi)
 	return err;
 }
 
+/**
+ * i40e_calculate_vsi_rx_buf_len - Calculates buffer length
+ *
+ * @vsi: VSI to calculate rx_buf_len from
+ */
+static u16 i40e_calculate_vsi_rx_buf_len(struct i40e_vsi *vsi)
+{
+	if (!vsi->netdev || (vsi->back->flags & I40E_FLAG_LEGACY_RX))
+		return I40E_RXBUFFER_2048;
+
+#if (PAGE_SIZE < 8192)
+	if (!I40E_2K_TOO_SMALL_WITH_PADDING && vsi->netdev->mtu <= ETH_DATA_LEN)
+		return I40E_RXBUFFER_1536 - NET_IP_ALIGN;
+#endif
+
+	return PAGE_SIZE < 8192 ? I40E_RXBUFFER_3072 : I40E_RXBUFFER_2048;
+}
+
 /**
  * i40e_vsi_configure_rx - Configure the VSI for Rx
  * @vsi: the VSI being configured
@@ -3704,20 +3722,14 @@ static int i40e_vsi_configure_rx(struct i40e_vsi *vsi)
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
@@ -13282,7 +13294,7 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi, struct bpf_prog *prog,
 	int i;
 
 	/* Don't allow frames that span over multiple buffers */
-	if (frame_size > vsi->rx_buf_len) {
+	if (frame_size > i40e_calculate_vsi_rx_buf_len(vsi)) {
 		NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
 		return -EINVAL;
 	}
-- 
2.35.1

