Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F745A4666
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiH2Jrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiH2Jrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:47:51 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFF25E556
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 02:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661766463; x=1693302463;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ERh9FN6XBrS+my2+cyzr9hMAr8OTT3qzzCLuWO3wz+o=;
  b=XLKys5BzmWXOMn1fdTadN2A9fa4TQqM+Ikz3GXHC1wZeLx28HDQDp22T
   eAJTo9fTKWoJWfgUYJdNPGN/BusZtj8NFqtXzGJYbH3uh2vVhBkSJDmOd
   Tkt/4ovbE1Ci3QC/a82lRgTKEQhorMq1JlzV44tIKkgNSoDwHhXZI9gFz
   XWoin8fI9dQpPMRYdHp5dROErcvNHrdOefpE2+f/a9N+/mmYb6sGc8qdL
   VRp2+LbF4vElEeFPrhxL3s4UKMy/PZ3TO0vJ3/QgdEN+o0OQWaskQbWzR
   bWPDy22mX87Rgsjr8zi8v5XXbG9vRO+l1hbTfyaB7TkAxghN23OBXorud
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="294865351"
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="294865351"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 02:47:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="737281244"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 29 Aug 2022 02:47:28 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27T9lK8h021475;
        Mon, 29 Aug 2022 10:47:26 +0100
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
Subject: [RFC PATCH net-next v2 4/5] flow_offload: Introduce flow_match_l2tpv3
Date:   Mon, 29 Aug 2022 11:44:11 +0200
Message-Id: <20220829094412.554018-5-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220829094412.554018-1-wojciech.drewek@intel.com>
References: <20220829094412.554018-1-wojciech.drewek@intel.com>
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

