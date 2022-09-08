Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF285B2448
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 19:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiIHRRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 13:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiIHRRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 13:17:22 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EC6CCD6F
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 10:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662657441; x=1694193441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GC1/3D8EaA60gHqrLrcyCOQ5oRte+ZIpjxiXYInJWO4=;
  b=XEVUYd9SXZsvJ+DvsV0B7gWFIb6fGzYvRIA5i8ml7KX4v/qRmRLmmgmg
   dqUg/GNBFVHCXSxRrS2VT7ZeFFehUdxyF+qIaTmnfGKxeF8r311fNk3rm
   lIvGNZ07TYXzaOmBAV/VsNusZpO6KoEmAlv+U+mQoV8qovmDXe2QwAx6M
   YAnLComtflV3h3GF/2qFR2U2UcG0PrNUTJgS8aA2MdMrKDZ127+u4UMiE
   7+6EguEj/H0q3WgXIkUOTUePeqwu8b6GO1BgkAf80JI/BvQU6z/trQAEI
   xE4kuSsS7exzcD12JBX3gZefF0q+qFKlZE2fPNj5mG7Qwp4Vrcq7bqj31
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="297267577"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="297267577"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 10:16:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="860117842"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 08 Sep 2022 10:16:56 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        simon.horman@corigine.com, kurt@linutronix.de,
        komachi.yoshiki@gmail.com, jchapman@katalix.com,
        boris.sukholitko@broadcom.com, louis.peens@corigine.com,
        gnault@redhat.com, vladbu@nvidia.com, pablo@netfilter.org,
        baowen.zheng@corigine.com, maksym.glubokiy@plvision.eu,
        jiri@resnulli.us, paulb@nvidia.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com
Subject: [PATCH net-next v1 4/5] flow_offload: Introduce flow_match_l2tpv3
Date:   Thu,  8 Sep 2022 10:16:43 -0700
Message-Id: <20220908171644.1282191-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220908171644.1282191-1-anthony.l.nguyen@intel.com>
References: <20220908171644.1282191-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Allow to offload L2TPv3 filters by adding flow_rule_match_l2tpv3.
Drivers can extract L2TPv3 specific fields from now on.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 include/net/flow_offload.h | 6 ++++++
 net/core/flow_offload.c    | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 2a9a9e42e7fd..e343f9f8363e 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -80,6 +80,10 @@ struct flow_match_pppoe {
 	struct flow_dissector_key_pppoe *key, *mask;
 };
 
+struct flow_match_l2tpv3 {
+	struct flow_dissector_key_l2tpv3 *key, *mask;
+};
+
 struct flow_rule;
 
 void flow_rule_match_meta(const struct flow_rule *rule,
@@ -128,6 +132,8 @@ void flow_rule_match_ct(const struct flow_rule *rule,
 			struct flow_match_ct *out);
 void flow_rule_match_pppoe(const struct flow_rule *rule,
 			   struct flow_match_pppoe *out);
+void flow_rule_match_l2tpv3(const struct flow_rule *rule,
+			    struct flow_match_l2tpv3 *out);
 
 enum flow_action_id {
 	FLOW_ACTION_ACCEPT		= 0,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 8cfb63528d18..abe423fd5736 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -237,6 +237,13 @@ void flow_rule_match_pppoe(const struct flow_rule *rule,
 }
 EXPORT_SYMBOL(flow_rule_match_pppoe);
 
+void flow_rule_match_l2tpv3(const struct flow_rule *rule,
+			    struct flow_match_l2tpv3 *out)
+{
+	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_L2TPV3, out);
+}
+EXPORT_SYMBOL(flow_rule_match_l2tpv3);
+
 struct flow_block_cb *flow_block_cb_alloc(flow_setup_cb_t *cb,
 					  void *cb_ident, void *cb_priv,
 					  void (*release)(void *cb_priv))
-- 
2.35.1

