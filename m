Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB5E5A2689
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245559AbiHZLGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343732AbiHZLEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:04:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A962B1A8
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661511867; x=1693047867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ERh9FN6XBrS+my2+cyzr9hMAr8OTT3qzzCLuWO3wz+o=;
  b=UWh4bVAJP0XdotrgUvq8tzhmC0tdgEzgNUIdeahfzcXCpDZRj5I6I0Mu
   YWAWQpCimr7OIYi/mFKDA5klwVBLSEL0qOKoZTFbSanVQy4FCn09Fu0ni
   sCPGwV1vD39Q2/Ao8VeH+gjoyKVunZEK04pwjrLod/7FP2V6uWkEpmqHW
   65LPmUO0Fhj9ijd7eobf95J2S0iEpBIR9thvuQq+powGXSE6erbSbOnkj
   N0nSVrfrPHB6UHJpuyZewVb5Qd3oMtsOY97++ZWpdnCrEkSkZRqg98c2I
   ZFXPwK3bGPr0zHWYWdJNoU7aHU7tNyMSRfLoZHWGQeTGDq6k4LkkUWDM1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="274234338"
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="274234338"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 04:04:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="587263977"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 26 Aug 2022 04:04:20 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27QB4CLu024087;
        Fri, 26 Aug 2022 12:04:18 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcin.szycik@linux.intel.com, michal.swiatkowski@linux.intel.com,
        kurt@linutronix.de, boris.sukholitko@broadcom.com,
        vladbu@nvidia.com, komachi.yoshiki@gmail.com, paulb@nvidia.com,
        baowen.zheng@corigine.com, louis.peens@corigine.com,
        simon.horman@corigine.com, pablo@netfilter.org,
        maksym.glubokiy@plvision.eu, intel-wired-lan@lists.osuosl.org,
        jchapman@katalix.com, gnault@redhat.com
Subject: [RFC PATCH net-next 4/5] flow_offload: Introduce flow_match_l2tpv3
Date:   Fri, 26 Aug 2022 13:00:58 +0200
Message-Id: <20220826110059.119927-5-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220826110059.119927-1-wojciech.drewek@intel.com>
References: <20220826110059.119927-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to offload L2TPv3 filters by adding flow_rule_match_l2tpv3.
Drivers can extract L2TPv3 specific fields from now on.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
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
2.31.1

