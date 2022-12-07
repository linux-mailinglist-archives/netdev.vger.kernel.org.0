Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988776464EE
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiLGXRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiLGXRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:17:50 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071032BB03
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670455067; x=1701991067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XGiSMLWVR3SmG5R6DnoxnRU6/8j8mbwQeCMiptTfzxQ=;
  b=Dfq8PcsGEbGrht/IUFsoxgl2n8fAW5YWmQvhbJx2iCkB0U+cNb+YSMkl
   M8JmSkOgz5Qtj1ICnAXS+m2XVeU32MDnsKJ9MVvHPdBbzCFJWtBQEVmWf
   mxKEXEBZnjLawEInJm63ZBe41h1Lksxd2imi5DdHpJR+FUUDi6xLS+dNk
   wCnlxI6KypvuBp/F3QAt6YZ4qAQxgFwoi2z00O4sD9pAerxkQN4HZ+eD8
   cvQduuQ0z78kfSM8B1c8CzgpuhrFHk5OXgB8YP3nM6317TK3T44pjbcKk
   46i1S1uWll8ZbfyzDzFQfq+ze78QVIXatqtsPnh3z7PkMt7UvEwPm4eXd
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="403293973"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="403293973"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 15:17:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="677539551"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="677539551"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 15:17:41 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next v1 2/2] ethtool: refactor bit-shifts
Date:   Wed,  7 Dec 2022 15:17:28 -0800
Message-Id: <20221207231728.2331166-3-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221207231728.2331166-1-jesse.brandeburg@intel.com>
References: <20221207231728.2331166-1-jesse.brandeburg@intel.com>
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

While coding up the BIT() conversions for ethtool, some ugly conversions
and code were noticed and we can fix them with a little GENMASK and a
small refactor to use local variables to simplify some bitset.c code.

These changes should have no functional effect.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 net/ethtool/bitset.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ethtool/bitset.c b/net/ethtool/bitset.c
index 0515d6604b3b..ac289f335582 100644
--- a/net/ethtool/bitset.c
+++ b/net/ethtool/bitset.c
@@ -14,12 +14,12 @@
 
 static u32 ethnl_lower_bits(unsigned int n)
 {
-	return ~(u32)0 >> (32 - n % 32);
+	return GENMASK((n % 32), 0);
 }
 
 static u32 ethnl_upper_bits(unsigned int n)
 {
-	return ~(u32)0 << (n % 32);
+	return GENMASK(31, (n % 32));
 }
 
 /**
@@ -452,8 +452,8 @@ ethnl_update_bitset32_verbose(u32 *bitmap, unsigned int nbits,
 		ethnl_bitmap32_clear(bitmap, 0, nbits, mod);
 
 	nla_for_each_nested(bit_attr, tb[ETHTOOL_A_BITSET_BITS], rem) {
+		unsigned int idx, bitmap_idx, mod_idx;
 		bool old_val, new_val;
-		unsigned int idx;
 
 		if (nla_type(bit_attr) != ETHTOOL_A_BITSET_BITS_BIT) {
 			NL_SET_ERR_MSG_ATTR(extack, bit_attr,
@@ -464,12 +464,14 @@ ethnl_update_bitset32_verbose(u32 *bitmap, unsigned int nbits,
 				      names, extack);
 		if (ret < 0)
 			return ret;
-		old_val = bitmap[idx / 32] & ((u32)1 << (idx % 32));
+		bitmap_idx = idx / 32;
+		mod_idx = idx % 32;
+		old_val = bitmap[bitmap_idx] & BIT(mod_idx);
 		if (new_val != old_val) {
 			if (new_val)
-				bitmap[idx / 32] |= ((u32)1 << (idx % 32));
+				bitmap[bitmap_idx] |= BIT(mod_idx);
 			else
-				bitmap[idx / 32] &= ~((u32)1 << (idx % 32));
+				bitmap[bitmap_idx] &= ~BIT(mod_idx);
 			*mod = true;
 		}
 	}
-- 
2.31.1

