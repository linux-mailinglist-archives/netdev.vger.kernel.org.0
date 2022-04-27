Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C90511E81
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244083AbiD0Rhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 13:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244159AbiD0Rhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 13:37:48 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FA5101E4
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 10:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651080874; x=1682616874;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pBfswDsZrF7sc5K/zWuKcPwnVkgxvHIcjUHW3PDACU8=;
  b=ZFyPa62OJe/DionGTYYAIQvS+TcWqDHsvUpUdpcv+wDCcZ8kkh0UYRgA
   yjydaDghE8lG6x9CnJApSjp4AokRVIoj7Y2NoXGUaG62PcupFQlOZ09t9
   LD36e1vU80GIvKoaHIctX4pRyE+eoTlPa+8hm28DLPWAjZP43BvyKcYUu
   cTvduiJsnmW7U//a9LOqQ8NOewRA3JY/rMXQn+W0K3MOkvmjroHFDPeS8
   ff6aceYQcOPGwwN6VUuDSqi6HeGmRIKDbO0FVVuYA6QpzlriD3PNaEHXT
   B2S6EUhUrKSCJu7/3DYZ2KP8pL9S5VzbayQtdDdWKpKRnL5EsVgFfpaYe
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="253394002"
X-IronPort-AV: E=Sophos;i="5.90,293,1643702400"; 
   d="scan'208";a="253394002"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 10:34:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,293,1643702400"; 
   d="scan'208";a="629107136"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 27 Apr 2022 10:34:33 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Raed Salem <raeds@nvidia.com>,
        Shannon Nelson <snelson@pensando.io>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 1/1] ixgbe: ensure IPsec VF<->PF compatibility
Date:   Wed, 27 Apr 2022 10:31:52 -0700
Message-Id: <20220427173152.443102-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The VF driver can forward any IPsec flags and such makes the function
is not extendable and prone to backward/forward incompatibility.

If new software runs on VF, it won't know that PF configured something
completely different as it "knows" only XFRM_OFFLOAD_INBOUND flag.

Fixes: eda0333ac293 ("ixgbe: add VF IPsec management")
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Shannon Nelson <snelson@pensando.io>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index e596e1a9fc75..69d11ff7677d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -903,7 +903,8 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 	/* Tx IPsec offload doesn't seem to work on this
 	 * device, so block these requests for now.
 	 */
-	if (!(sam->flags & XFRM_OFFLOAD_INBOUND)) {
+	sam->flags = sam->flags & ~XFRM_OFFLOAD_IPV6;
+	if (sam->flags != XFRM_OFFLOAD_INBOUND) {
 		err = -EOPNOTSUPP;
 		goto err_out;
 	}
-- 
2.31.1

