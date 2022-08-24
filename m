Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC315A022B
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 21:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbiHXTh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 15:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238302AbiHXTh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 15:37:56 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676FB792CD
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 12:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661369875; x=1692905875;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GBMUVO5SJrFf+c3wHtRDGdNq1vDaJRcApKC/pNJzKmg=;
  b=Zpf669+FLXriCVgpb2KjcVp/BJy4OowUFT7hxNAHkrhERMqxQQelN7Su
   mQQRg+Rb9Yzr7d+JvK7PXa5NhoWB/h27g+wxzlgYJ60lQ1uPbagYiWUW8
   oWMSPUpShLAHF28cED/YnfktSiM92ha+/fUpK2jjQ9eTJ7+/FJMOoaSU5
   jKZoXFpqZ62fI2tx6anR5KdWxphA6cnIxVmGm2tBnwCr+bn0Q/fCHEpuW
   4GtDCvUtRRJmdKazK25PK4hPvsH15Dtx0UV19CTuBrKdgrPCS4nYWk7gy
   DgFOhy7zU2L9JITXZ4CvaP8eKZ4jJkjf1RgmVt6QlbsKpNjRWx4/LGjgE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="380351205"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="380351205"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 12:37:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="785742652"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 24 Aug 2022 12:37:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 2/2] i40e: Fix incorrect address type for IPv6 flow rules
Date:   Wed, 24 Aug 2022 12:37:47 -0700
Message-Id: <20220824193748.874343-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220824193748.874343-1-anthony.l.nguyen@intel.com>
References: <20220824193748.874343-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

It was not possible to create 1-tuple flow director
rule for IPv6 flow type. It was caused by incorrectly
checking for source IP address when validating user provided
destination IP address.

Fix this by changing ip6src to correct ip6dst address
in destination IP address validation for IPv6 flow type.

Fixes: efca91e89b67 ("i40e: Add flow director support for IPv6")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index 156e92c43780..e9cd0fa6a0d2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -4485,7 +4485,7 @@ static int i40e_check_fdir_input_set(struct i40e_vsi *vsi,
 				    (struct in6_addr *)&ipv6_full_mask))
 			new_mask |= I40E_L3_V6_DST_MASK;
 		else if (ipv6_addr_any((struct in6_addr *)
-				       &usr_ip6_spec->ip6src))
+				       &usr_ip6_spec->ip6dst))
 			new_mask &= ~I40E_L3_V6_DST_MASK;
 		else
 			return -EOPNOTSUPP;
-- 
2.35.1

