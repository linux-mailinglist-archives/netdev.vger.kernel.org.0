Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9576559A96
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 15:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiFXNmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 09:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiFXNmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 09:42:32 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB6C488A9
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 06:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656078151; x=1687614151;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tHizgFNnSXkpG46Dn3nJDt/CPuSpOnuIsvpe7rCWWTo=;
  b=DcsCHf3yDp0WNifjw0DB4IaY12EDQLT/iJ/gE9FEdJAJ40oV7xob+d8L
   +ugT6BIL0OKLfmZd+kqOvBE6+gY1Ec3LjESQaf2uejeWMoQggmV7ZVwhT
   0SkzyrpADFnm+/+o5Wnk/fJQOtLi6MOe0MUjCdQ8hRb1cqoT1vzMlSenN
   1q6ueTDONWbTLx5jI8FVaOp0uJ3PYhAFMKSHpaZhTHqzRRUOOk08BT595
   uw2wQDoSS5/yTZbzfX8jfMjXJAhVipiYvIJHcZKSuH8sVBKBUgNvMIEY+
   XA85Ut91HBSC4sYKjeFt5rnasAmvWhN3JhFNnnEk34NtiIpn67EYKuM9C
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="264041777"
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="264041777"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2022 06:42:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,218,1650956400"; 
   d="scan'208";a="678546029"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Jun 2022 06:42:24 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25ODgI7Z005567;
        Fri, 24 Jun 2022 14:42:22 +0100
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        xiyou.wangcong@gmail.com, jesse.brandeburg@intel.com,
        gustavoars@kernel.org, baowen.zheng@corigine.com,
        boris.sukholitko@broadcom.com, elic@nvidia.com,
        edumazet@google.com, kuba@kernel.org, jhs@mojatatu.com,
        jiri@resnulli.us, kurt@linutronix.de, pablo@netfilter.org,
        pabeni@redhat.com, paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        intel-wired-lan@lists.osuosl.org,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com
Subject: [RFC PATCH net-next 3/4] flow_offload: Introduce flow_match_pppoe
Date:   Fri, 24 Jun 2022 15:41:33 +0200
Message-Id: <20220624134134.13605-4-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220624134134.13605-1-marcin.szycik@linux.intel.com>
References: <20220624134134.13605-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Allow to offload PPPoE filters by adding flow_rule_match_pppoe.
Drivers can extract PPPoE specific fields from now on.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 include/net/flow_offload.h | 6 ++++++
 net/core/flow_offload.c    | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 6484095a8c01..50283a30b97b 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -72,6 +72,10 @@ struct flow_match_ct {
 	struct flow_dissector_key_ct *key, *mask;
 };
 
+struct flow_match_pppoe {
+	struct flow_dissector_key_pppoe *key, *mask;
+};
+
 struct flow_rule;
 
 void flow_rule_match_meta(const struct flow_rule *rule,
@@ -116,6 +120,8 @@ void flow_rule_match_enc_opts(const struct flow_rule *rule,
 			      struct flow_match_enc_opts *out);
 void flow_rule_match_ct(const struct flow_rule *rule,
 			struct flow_match_ct *out);
+void flow_rule_match_pppoe(const struct flow_rule *rule,
+			   struct flow_match_pppoe *out);
 
 enum flow_action_id {
 	FLOW_ACTION_ACCEPT		= 0,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 929f6379a279..d13d293e3de2 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -223,6 +223,13 @@ void flow_rule_match_ct(const struct flow_rule *rule,
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

