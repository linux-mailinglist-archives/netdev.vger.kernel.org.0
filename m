Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399244869F6
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 19:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242887AbiAFSbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 13:31:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:21739 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242865AbiAFSbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 13:31:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641493867; x=1673029867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b4jyUOQj78ej7LIXpztgoLpb/moHtvV4n2V0c6w2v48=;
  b=JJgzeq/c/X8yysDBJCHfc6AyumEX19EouyrZwuPOZPUbPgTgtwt8odot
   w/DQCikShfqkeN1BIXeTDD461UN6GwIZJ5bqNpaAgy8qrvhS2owlecStT
   y8vBbhozjtBcKA2kwCeINwYFhkhS/bf0FKHbcH1rjByb3y/qhvXgv8bd5
   M+5ALHsN21zn9wr5vLcuMNPdc2pwskVjW8IiI2c4dN+JmZe0Y7PHn0Ng9
   kIqXvWwYmrEhlTszuTiZ6ELWcyubTFPR12EI9aWALVbGl4cDpLYfnuYcl
   OQH9hGbLxT4su3nvKqyQgy+CiGOrz/sIXOyHPt1xzVQb6KozYaoqyaldP
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242666613"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="242666613"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 10:30:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="489024740"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 06 Jan 2022 10:30:49 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 3/5] ice: Slightly simply ice_find_free_recp_res_idx
Date:   Thu,  6 Jan 2022 10:30:11 -0800
Message-Id: <20220106183013.3777622-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220106183013.3777622-1-anthony.l.nguyen@intel.com>
References: <20220106183013.3777622-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

The 'possible_idx' bitmap is set just after it is zeroed, so we can save
the first step.

The 'free_idx' bitmap is used only at the end of the function as the
result of a bitmap xor operation. So there is no need to explicitly
zero it before.

So, slightly simply the code and remove 2 useless 'bitmap_zero()' call

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 756e7f91e48d..11ae0bee3590 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4070,10 +4070,8 @@ ice_find_free_recp_res_idx(struct ice_hw *hw, const unsigned long *profiles,
 	DECLARE_BITMAP(used_idx, ICE_MAX_FV_WORDS);
 	u16 bit;
 
-	bitmap_zero(possible_idx, ICE_MAX_FV_WORDS);
 	bitmap_zero(recipes, ICE_MAX_NUM_RECIPES);
 	bitmap_zero(used_idx, ICE_MAX_FV_WORDS);
-	bitmap_zero(free_idx, ICE_MAX_FV_WORDS);
 
 	bitmap_set(possible_idx, 0, ICE_MAX_FV_WORDS);
 
-- 
2.31.1

