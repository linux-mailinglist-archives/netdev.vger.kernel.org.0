Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C4D61A2C3
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 21:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiKDUyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 16:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiKDUy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 16:54:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC41E1274C
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 13:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667595267; x=1699131267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GL6EiV8AgKlN/bhF/elK8GKsQY8r77fRd+rJ9Jlq9J8=;
  b=UvGIrZhlAjITnRk7ZQurtZT5WktE3TElTUcNvUnyaUMEDQC98y8eM8a1
   jYvLTwodP9qR387leyQwXCCbgOWMeg2hFeShpA3qsE8//5f9CvinMTctC
   XWl6yNOB6NWloVjEXb9lPGdekyxnKHd9gRR/1ckphyA4lEqfdIGWJE6Qo
   AnKuTVBDwy6r3a0SxP7soFMWNqhTosu0Tfuy3xmfiJro5OLUAT6kEGMh6
   gWY1+H4EmlgVjuCmid1SFaTeZfvE51KKfkraFUwb6QLpaFEabGS7ehm/x
   2hjLUKENJtPkX7C/pw/6qoqjeBXOVK0k9TGOVij8bidjjUyFHKnmQb1os
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="372177368"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="372177368"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 13:54:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="637716217"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="637716217"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 04 Nov 2022 13:54:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        "Michael J . Ruhl" <michael.j.ruhl@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 5/6] igb: Do not free q_vector unless new one was allocated
Date:   Fri,  4 Nov 2022 13:54:13 -0700
Message-Id: <20221104205414.2354973-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
References: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

Avoid potential use-after-free condition under memory pressure. If the
kzalloc() fails, q_vector will be freed but left in the original
adapter->q_vector[v_idx] array position.

Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index d6c1c2e66f26..c2bb658198bf 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1202,8 +1202,12 @@ static int igb_alloc_q_vector(struct igb_adapter *adapter,
 	if (!q_vector) {
 		q_vector = kzalloc(size, GFP_KERNEL);
 	} else if (size > ksize(q_vector)) {
-		kfree_rcu(q_vector, rcu);
-		q_vector = kzalloc(size, GFP_KERNEL);
+		struct igb_q_vector *new_q_vector;
+
+		new_q_vector = kzalloc(size, GFP_KERNEL);
+		if (new_q_vector)
+			kfree_rcu(q_vector, rcu);
+		q_vector = new_q_vector;
 	} else {
 		memset(q_vector, 0, size);
 	}
-- 
2.35.1

