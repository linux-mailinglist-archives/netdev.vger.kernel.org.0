Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2E5696D5A
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 19:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbjBNSw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 13:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbjBNSw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 13:52:26 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CA37DB7;
        Tue, 14 Feb 2023 10:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676400745; x=1707936745;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r1e8s1dhRuOX60UkVjlnhmpCNbeiG4Bc96mzMjMQx4Y=;
  b=LzES/aB5f579btVMNxVoKHzwh3fevQNjZmfXbgG4y96xsUuqNgqZa8cI
   tSpU0X+rmb5H8VoXrKquRslrfQhL+/OyAUy5JvQUEwLXHAFxF0V0KaybC
   29wPc0GvNo+dDA4xVgvv2pMbnPhk9NScLO+BBFgkul4eywkAv5Btcm0kh
   gIdj4M/1qKI0UFgewYmhNC527WiC3ZumJGk/FAq8kjSewqFCNC6+aCMLb
   lX3hKNd1hyZKgiILGbPM/JJQjmdkV/UJJinTbvRybMqLWyKHekKqyoESm
   1sXemCRvtj0d4/GvG8YLsM7vyFonr0UXKwRrRdg/BbSe30VNx24ICZfFX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="329866063"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="329866063"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 10:52:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="619159903"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="619159903"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 14 Feb 2023 10:52:23 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        bjorn@kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH net 3/3] ixgbe: add double of VLAN header when computing the max MTU
Date:   Tue, 14 Feb 2023 10:51:46 -0800
Message-Id: <20230214185146.1305819-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230214185146.1305819-1-anthony.l.nguyen@intel.com>
References: <20230214185146.1305819-1-anthony.l.nguyen@intel.com>
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

From: Jason Xing <kernelxing@tencent.com>

Include the second VLAN HLEN into account when computing the maximum
MTU size as other drivers do.

Fixes: fabf1bce103a ("ixgbe: Prevent unsupported configurations with XDP")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 +--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index bc68b8f2176d..8736ca4b2628 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -73,6 +73,8 @@
 #define IXGBE_RXBUFFER_4K    4096
 #define IXGBE_MAX_RXBUFFER  16384  /* largest size for a single descriptor */
 
+#define IXGBE_PKT_HDR_PAD   (ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
+
 /* Attempt to maximize the headroom available for incoming frames.  We
  * use a 2K buffer for receives and need 1536/1534 to store the data for
  * the frame.  This leaves us with 512 bytes of room.  From that we need
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 25ca329f7d3c..4507fba8747a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6801,8 +6801,7 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
 	if (ixgbe_enabled_xdp_adapter(adapter)) {
-		int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
-				     VLAN_HLEN;
+		int new_frame_size = new_mtu + IXGBE_PKT_HDR_PAD;
 
 		if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
 			e_warn(probe, "Requested MTU size is not supported with XDP\n");
-- 
2.38.1

