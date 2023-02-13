Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A24669504E
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 20:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjBMTFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 14:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjBMTFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 14:05:20 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408FF6A61;
        Mon, 13 Feb 2023 11:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676315101; x=1707851101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9TYGTju5wJ26T7VHIbNLTsOJgKK+6HVcw3Qa/CXWZys=;
  b=FArfeAisw6Ua8p7npJ6FNF9yp8ngZujb7ioJXiaPukoY+/0hiasuc/Eu
   /PZ2BM7wxHmIyeFrFSCCJfOIYXiwpJ/Cfvp+mdzimhPeYmK3VGcCJAUyj
   C7Xua1lcY9SlNUXtDw9ns32UYkqFDS1eW2wHXet0znx14xKza6skshiMr
   5lfRQPZEgTPoW9sRs2haumXpFVe6rvW00gw49krx9sgrgSkJ8d+M1xudg
   NpQxBz9PZA9/lp3nlSWjgVLugvWnVxTzj6steMzk41yzqGQcKF3AOmRam
   eBVim9JzOT1tcLPDzKQA5rswdFeA8xQltN4XycpyWcxSpgNwIo+LSXfy8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="332281400"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="332281400"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 11:03:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="670928975"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="670928975"
Received: from paamrpdk12-s2600bpb.aw.intel.com ([10.228.151.145])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 11:03:33 -0800
From:   Tirthendu Sarkar <tirthendu.sarkar@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com
Subject: [PATCH intel-next v2 2/8] i40e: change Rx buffer size for legacy-rx to support XDP multi-buffer
Date:   Tue, 14 Feb 2023 00:18:22 +0530
Message-Id: <20230213184828.39404-3-tirthendu.sarkar@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230213184828.39404-1-tirthendu.sarkar@intel.com>
References: <20230213184828.39404-1-tirthendu.sarkar@intel.com>
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

Adding support for XDP multi-buffer entails adding information of all
the fragments of the packet in the xdp_buff. This approach implies that
underlying buffer has to provide tailroom for skb_shared_info.

In the legacy-rx mode, driver can only configure upto 2k sized Rx buffers
and with the current configuration of 2k sized Rx buffers there is no way
to do tailroom reservation for skb_shared_info. Hence size of Rx buffers
is now lowered to 1664 (2k - sizeof(skb_shared_info)). Also, driver can
only chain upto 5 Rx buffers and this means max MTU supported for
legacy-rx is now 8320.

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 672038801d1d..d7c08f1d486a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2903,7 +2903,7 @@ static void i40e_sync_filters_subtask(struct i40e_pf *pf)
 static u16 i40e_calculate_vsi_rx_buf_len(struct i40e_vsi *vsi)
 {
 	if (!vsi->netdev || (vsi->back->flags & I40E_FLAG_LEGACY_RX))
-		return I40E_RXBUFFER_2048;
+		return I40E_RXBUFFER_1664;
 
 	return PAGE_SIZE < 8192 ? I40E_RXBUFFER_3072 : I40E_RXBUFFER_2048;
 }
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index 768290dc6f48..1382efb43ffd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -97,6 +97,7 @@ enum i40e_dyn_idx_t {
 /* Supported Rx Buffer Sizes (a multiple of 128) */
 #define I40E_RXBUFFER_256   256
 #define I40E_RXBUFFER_1536  1536  /* 128B aligned standard Ethernet frame */
+#define I40E_RXBUFFER_1664  1664  /* For legacy Rx with tailroom for frags */
 #define I40E_RXBUFFER_2048  2048
 #define I40E_RXBUFFER_3072  3072  /* Used for large frames w/ padding */
 #define I40E_MAX_RXBUFFER   9728  /* largest size for single descriptor */
-- 
2.34.1

