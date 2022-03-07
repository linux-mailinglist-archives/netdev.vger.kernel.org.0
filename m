Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC3D4D0BCF
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 00:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241390AbiCGXPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 18:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240859AbiCGXPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 18:15:00 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FB72E692;
        Mon,  7 Mar 2022 15:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646694845; x=1678230845;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V7Y1Jcc2LPh+LpFTGHXVo4sV+mrjtBNGrWLXuBAqa3M=;
  b=kF0upLECKcFmwyT4aeeGMvU7Kg70EhU6ZBEZVwF0MIyZxeMjZeCKT9t0
   ofXnvP/TFaFlsqyz5SNwRUWzxXhlRb52Ee495dKsPV7eqLNztwW8AydEj
   1snG4k3daCqLXNOlcKOqkVOEUo4jXRJCMXzVD+UV6e+a9ndCh2o47CF7t
   IaUlriBGVQzbtCHZYB+5t8XnOKCWGYfZt3tYDG+VagsXuMLaDMBCNpfoI
   jQTjvmKuX6djZ6yzO5uEne2G5JVnsKkJq37flX6EF8jzJ3Wrfkjm0kGs9
   N7gnvqvJXBVaXDHRDJuJP744xa5vNhmi4NCWnXmYzckxsozhHu1GqC9MN
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="315246581"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="315246581"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 15:14:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="813416923"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga005.fm.intel.com with ESMTP; 07 Mar 2022 15:14:02 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, anthony.l.nguyen@intel.com, kuba@kernel.org,
        davem@davemloft.net, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next] ice: xsk: fix GCC version checking against pragma unroll presence
Date:   Tue,  8 Mar 2022 00:13:53 +0100
Message-Id: <20220307231353.56638-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pragma unroll was introduced around GCC 8, whereas current xsk code in
ice that prepares loop_unrolled_for macro that is based on mentioned
pragma, compares GCC version against 4, which is wrong and Stephen
found this out by compiling kernel with GCC 5.4 [0].

Fix this mistake and check if GCC version is >= 8.

[0]: https://lore.kernel.org/netdev/20220307213659.47658125@canb.auug.org.au/

Fixes: 126cdfe1007a ("ice: xsk: Improve AF_XDP ZC Tx and use batching API")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
This code has not made it to net tree yet, hence sending it against
net-next and this time I'm not routing it via Tony's queue as it's
probably a bit urgent?

 drivers/net/ethernet/intel/ice/ice_xsk.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
index 0cbb5793b5b8..123bb98ebfbe 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.h
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
@@ -10,7 +10,7 @@
 
 #ifdef __clang__
 #define loop_unrolled_for _Pragma("clang loop unroll_count(8)") for
-#elif __GNUC__ >= 4
+#elif __GNUC__ >= 8
 #define loop_unrolled_for _Pragma("GCC unroll 8") for
 #else
 #define loop_unrolled_for for
-- 
2.33.1

