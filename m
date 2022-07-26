Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B658581B24
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 22:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239608AbiGZUfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 16:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239920AbiGZUfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 16:35:12 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6319B38A5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658867711; x=1690403711;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OO7sL1Uym7iiVcbRP++pRbReBUo5nXFtzh+nOusaT9I=;
  b=HjOdjjXIL6aPTA0XYMfV51tPLqCGPU3u0XSARGBNCncyqBEckY2Na9LQ
   vx5nIJXAUJb1AzqZ6ZgJ6/b23cqvmnSio9EIxOgcdLV7zlX9zgkOB13B1
   lWGjgAnDex9q+4tGImyT+6/E/u2Jm+j4qx1vGumGRBdHYK1oSixT4FMxB
   NvXvqqT9firJIJ4ZW8nRs/IssV9pNDjWaXDH3w7+7zwvwHNSSEzRr7HJE
   7qvdYpyzajMlVVOR6YhLsHzka7557ZARcmHiFxuo9aE21H6j02vwaC50v
   naWxKNuaY6K/fxGhuZfpMx4+l6O54t8zozlzxfO398fZcNAcXcsH72wQ3
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="274923301"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="274923301"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 13:35:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="658854155"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jul 2022 13:35:10 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        xiyou.wangcong@gmail.com, jesse.brandeburg@intel.com,
        gustavoars@kernel.org, baowen.zheng@corigine.com,
        boris.sukholitko@broadcom.com, kurt@linutronix.de,
        pablo@netfilter.org, paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        michal.swiatkowski@linux.intel.com, alexandr.lobakin@intel.com,
        gnault@redhat.com, mostrows@speakeasy.net, paulus@samba.org,
        marcin.szycik@linux.intel.com
Subject: [PATCH net-next 3/4] flow_offload: Introduce flow_match_pppoe
Date:   Tue, 26 Jul 2022 13:31:32 -0700
Message-Id: <20220726203133.2171332-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220726203133.2171332-1-anthony.l.nguyen@intel.com>
References: <20220726203133.2171332-1-anthony.l.nguyen@intel.com>
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

From: Wojciech Drewek <wojciech.drewek@intel.com>

Allow to offload PPPoE filters by adding flow_rule_match_pppoe.
Drivers can extract PPPoE specific fields from now on.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 include/net/flow_offload.h | 6 ++++++
 net/core/flow_offload.c    | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index a8d8512b7059..2a9a9e42e7fd 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -76,6 +76,10 @@ struct flow_match_ct {
 	struct flow_dissector_key_ct *key, *mask;
 };
 
+struct flow_match_pppoe {
+	struct flow_dissector_key_pppoe *key, *mask;
+};
+
 struct flow_rule;
 
 void flow_rule_match_meta(const struct flow_rule *rule,
@@ -122,6 +126,8 @@ void flow_rule_match_enc_opts(const struct flow_rule *rule,
 			      struct flow_match_enc_opts *out);
 void flow_rule_match_ct(const struct flow_rule *rule,
 			struct flow_match_ct *out);
+void flow_rule_match_pppoe(const struct flow_rule *rule,
+			   struct flow_match_pppoe *out);
 
 enum flow_action_id {
 	FLOW_ACTION_ACCEPT		= 0,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 0d3075d3c8fb..8cfb63528d18 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -230,6 +230,13 @@ void flow_rule_match_ct(const struct flow_rule *rule,
 }
 EXPORT_SYMBOL(flow_rule_match_ct);
 
+void flow_rule_match_pppoe(const struct flow_rule *rule,
+			   struct flow_match_pppoe *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_PPPOE, out);
+}
+EXPORT_SYMBOL(flow_rule_match_pppoe);
+
 struct flow_block_cb *flow_block_cb_alloc(flow_setup_cb_t *cb,
 					  void *cb_ident, void *cb_priv,
 					  void (*release)(void *cb_priv))
-- 
2.35.1

