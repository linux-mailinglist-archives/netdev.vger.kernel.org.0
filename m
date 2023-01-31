Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2591B6838C9
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbjAaVhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbjAaVhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:37:39 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8981C5AB57
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675201046; x=1706737046;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=efh9OGeNAZCWPImYO4vw66DotKV5ZiIBZQoeq88vvAQ=;
  b=LVuhEZUwv+QaSMk5PEMeYgrxGilNU8YEoUIxGKHMJFe2BYja59OmUKVs
   wWd5d9f2qLmJnFjCMc0jE4svYbiBgcJ2eoV9Fa/H4O9WuXqvDyk3Idb5q
   +Bz8i6jppoHQSFuoJ9DKgZWe5g0XrQy86KhPHGH1QBSgmsCL4spY1h35v
   3nkb8v/sjG4MjFDp/sof847FRIgq+VVIOLtMaQ/bpaNQkfH2ufqLMQTe7
   JEfWPkR+GKN3eSe+9iazpulopjzwaaa8GFjvaNMf4WqOTkd4/LrgEOiul
   HliEVy2L/bqMC7zp4XHi95cGSlPcXVHH6JkB5WLB48LE9SItkD3K/VCdC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="327980315"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="327980315"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 13:37:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="910063024"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="910063024"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga006.fm.intel.com with ESMTP; 31 Jan 2023 13:37:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Subject: [PATCH net 6/6] ice: switch: fix potential memleak in ice_add_adv_recipe()
Date:   Tue, 31 Jan 2023 13:37:03 -0800
Message-Id: <20230131213703.1347761-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
References: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
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

From: Zhang Changzhong <zhangchangzhong@huawei.com>

When ice_add_special_words() fails, the 'rm' is not released, which will
lead to a memory leak. Fix this up by going to 'err_unroll' label.

Compile tested only.

Fixes: 8b032a55c1bd ("ice: low level support for tunnels")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 9b762f7972ce..61f844d22512 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -5420,7 +5420,7 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	 */
 	status = ice_add_special_words(rinfo, lkup_exts, ice_is_dvm_ena(hw));
 	if (status)
-		goto err_free_lkup_exts;
+		goto err_unroll;
 
 	/* Group match words into recipes using preferred recipe grouping
 	 * criteria.
-- 
2.38.1

