Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD65E2005AE
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 11:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732233AbgFSJp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 05:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729718AbgFSJp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 05:45:57 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947A6C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 02:45:57 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id s23so4204246pfh.7
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 02:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oneconvergence-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jNlqpl47Bl1A++8r3Ia7Tx8qgn51Qgoi3vKqNeaHWNA=;
        b=XqhAx4WWC8idhMfpW1peUQce4TEKYLjflxklj3hbhZ1KgeyTMOaMtSy+RmkqgA178Q
         +clyBpDFNC/+CBAiw92EQ+fNuw/shFRpxrDrK7EdnbgZ9v7czSjhdGrpt0k5VwZ02T9q
         LpdbOD6W33RT2I544wCQ0XMsNzk5lyTa7e6BzlbMc20iVdveyycy+2VNJe9Jvx9IzXra
         59d8q1qEkVWAGvSazid1kPlR8d2r5Jbgx+l5uRfMY5sruyElScViMfb8mlD8OmfBoqtj
         NolSqLYvywolxF0cT5DqG89L7qaTOavWsfV/j7dyyR8oJjPU9cuDgIsXTAiTlRd2zlim
         LBeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jNlqpl47Bl1A++8r3Ia7Tx8qgn51Qgoi3vKqNeaHWNA=;
        b=YXhF3qUhvRdATfe7CNQZJmQZOKHNgqU/v7LOHvnDRFG6WKxRITRG6MHdHOHbfCkyJM
         GJEP4PRQYFW4r/LAyxM6rAxo6aYbAlNCLtThGS0HwFJvLwuJqbWk3YV5nwxL3yo+6nrT
         ubZEU43qB3w73GNNvnKiXHnkx+jFUowq7JpmlAUvLlNOOCIiwVOzCnqDyBqcC/SaUzF7
         bZyucxwNscK5ZgbhYow3Dr/log6mVQ3sYHy8VJFuj0Cnor3ABKsjtPFIEE2Qh4VDAISX
         mVfnE9p3wUA6tWerQ1u1D5ANOLhyrZDgHE+EHjg0Tpy0ojg8hhPI6bybt+oLBISZN+oQ
         u/sw==
X-Gm-Message-State: AOAM532hHxp+E61OVZgC/ZuXs+O5ddSzv/W7npG5BS7+8Bfye0Fxu1nu
        6sttmo01SLALx0HkWCx6vPrHfTxpbIhfOA==
X-Google-Smtp-Source: ABdhPJx5IT3ksQ1K8KfU2IjFKojdk1fs1KgApvdJlH+uoKqNObwUGRU5IieIHHH3h1/FUHqFSg7Icw==
X-Received: by 2002:a63:df56:: with SMTP id h22mr2367099pgj.140.1592559957048;
        Fri, 19 Jun 2020 02:45:57 -0700 (PDT)
Received: from localhost.localdomain ([27.57.206.119])
        by smtp.gmail.com with ESMTPSA id m20sm5896306pfk.52.2020.06.19.02.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 02:45:56 -0700 (PDT)
From:   dsatish <satish.d@oneconvergence.com>
To:     davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, netdev@vger.kernel.org,
        simon.horman@netronome.com, kesavac@gmail.com,
        satish.d@oneconvergence.com, prathibha.nagooru@oneconvergence.com,
        intiyaz.basha@oneconvergence.com, jai.rana@oneconvergence.com
Subject: [PATCH net-next 2/3] cls_flower: Pass the unmasked key to hw
Date:   Fri, 19 Jun 2020 15:11:55 +0530
Message-Id: <20200619094156.31184-3-satish.d@oneconvergence.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619094156.31184-1-satish.d@oneconvergence.com>
References: <20200619094156.31184-1-satish.d@oneconvergence.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass the unmasked key along with the masked key to the hardware.
This enables hardware to manage its own tables better based on the
hardware features/capabilities.

Signed-off-by: Chandra Kesava <kesavac@gmail.com>
Signed-off-by: Prathibha Nagooru <prathibha.nagooru@oneconvergence.com>
Signed-off-by: Satish Dhote <satish.d@oneconvergence.com>
---
 include/net/flow_offload.h |  45 ++++++++++
 net/core/flow_offload.c    | 171 +++++++++++++++++++++++++++++++++++++
 net/sched/cls_flower.c     |  43 ++++++++++
 3 files changed, 259 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index f2c8311a0433..26c6bd6bdb98 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -11,6 +11,8 @@ struct flow_match {
 	struct flow_dissector	*dissector;
 	void			*mask;
 	void			*key;
+	void			*unmasked_key;
+	struct flow_dissector	*unmasked_key_dissector;
 };
 
 struct flow_match_meta {
@@ -118,6 +120,49 @@ void flow_rule_match_enc_opts(const struct flow_rule *rule,
 void flow_rule_match_ct(const struct flow_rule *rule,
 			struct flow_match_ct *out);
 
+void flow_rule_match_unmasked_key_meta(const struct flow_rule *rule,
+				       struct flow_match_meta *out);
+void flow_rule_match_unmasked_key_basic(const struct flow_rule *rule,
+					struct flow_match_basic *out);
+void flow_rule_match_unmasked_key_control(const struct flow_rule *rule,
+					  struct flow_match_control *out);
+void flow_rule_match_unmasked_key_eth_addrs(const struct flow_rule *rule,
+					    struct flow_match_eth_addrs *out);
+void flow_rule_match_unmasked_key_vlan(const struct flow_rule *rule,
+				       struct flow_match_vlan *out);
+void flow_rule_match_unmasked_key_cvlan(const struct flow_rule *rule,
+					struct flow_match_vlan *out);
+void flow_rule_match_unmasked_key_ipv4_addrs(const struct flow_rule *rule,
+					     struct flow_match_ipv4_addrs *out);
+void flow_rule_match_unmasked_key_ipv6_addrs(const struct flow_rule *rule,
+					     struct flow_match_ipv6_addrs *out);
+void flow_rule_match_unmasked_key_ip(const struct flow_rule *rule,
+				     struct flow_match_ip *out);
+void flow_rule_match_unmasked_key_ports(const struct flow_rule *rule,
+					struct flow_match_ports *out);
+void flow_rule_match_unmasked_key_tcp(const struct flow_rule *rule,
+				      struct flow_match_tcp *out);
+void flow_rule_match_unmasked_key_icmp(const struct flow_rule *rule,
+				       struct flow_match_icmp *out);
+void flow_rule_match_unmasked_key_mpls(const struct flow_rule *rule,
+				       struct flow_match_mpls *out);
+void flow_rule_match_unmasked_key_enc_control(const struct flow_rule *rule,
+					      struct flow_match_control *out);
+void flow_rule_match_unmasked_key_enc_ipv4_addrs(const struct flow_rule *rule,
+					    struct flow_match_ipv4_addrs *out);
+void flow_rule_match_unmasked_key_enc_ipv6_addrs(const struct flow_rule *rule,
+					    struct flow_match_ipv6_addrs *out);
+void flow_rule_match_unmasked_key_enc_ip(const struct flow_rule *rule,
+					 struct flow_match_ip *out);
+void flow_rule_match_unmasked_key_enc_ports(const struct flow_rule *rule,
+					    struct flow_match_ports *out);
+void flow_rule_match_unmasked_key_enc_keyid(const struct flow_rule *rule,
+					    struct flow_match_enc_keyid *out);
+void flow_rule_match_unmasked_key_enc_opts(const struct flow_rule *rule,
+					   struct flow_match_enc_opts *out);
+void flow_rule_match_unmasked_key_ct(const struct flow_rule *rule,
+				     struct flow_match_ct *out);
+
 enum flow_action_id {
 	FLOW_ACTION_ACCEPT		= 0,
 	FLOW_ACTION_DROP,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 0cfc35e6be28..a98c31e864b1 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -173,6 +173,177 @@ void flow_rule_match_enc_opts(const struct flow_rule *rule,
 }
 EXPORT_SYMBOL(flow_rule_match_enc_opts);
 
+#define FLOW_UNMASKED_KEY_DISSECTOR_MATCH(__rule, __type, __out)	\
+	const struct flow_match *__m = &(__rule)->match;		\
+	struct flow_dissector *__d = (__m)->unmasked_key_dissector;	\
+									\
+	(__out)->key = skb_flow_dissector_target(__d, __type,		\
+						 (__m)->unmasked_key);	\
+	(__out)->mask = skb_flow_dissector_target(__d, __type,		\
+						  (__m)->mask)		\
+
+void flow_rule_match_unmasked_key_meta(const struct flow_rule *rule,
+				       struct flow_match_meta *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_META, out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_meta);
+
+void
+flow_rule_match_unmasked_key_basic(const struct flow_rule *rule,
+				   struct flow_match_basic *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_BASIC, out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_basic);
+
+void flow_rule_match_unmasked_key_control(const struct flow_rule *rule,
+					  struct flow_match_control *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_CONTROL,
+					  out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_control);
+
+void flow_rule_match_unmasked_key_eth_addrs(const struct flow_rule *rule,
+					    struct flow_match_eth_addrs *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS,
+					  out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_eth_addrs);
+
+void flow_rule_match_unmasked_key_vlan(const struct flow_rule *rule,
+				       struct flow_match_vlan *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_VLAN, out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_vlan);
+
+void flow_rule_match_unmasked_key_cvlan(const struct flow_rule *rule,
+					struct flow_match_vlan *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_CVLAN, out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_cvlan);
+
+void flow_rule_match_unmasked_key_ipv4_addrs(const struct flow_rule *rule,
+					     struct flow_match_ipv4_addrs *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS,
+					  out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_ipv4_addrs);
+
+void flow_rule_match_unmasked_key_ipv6_addrs(const struct flow_rule *rule,
+					     struct flow_match_ipv6_addrs *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS,
+					  out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_ipv6_addrs);
+
+void flow_rule_match_unmasked_key_ip(const struct flow_rule *rule,
+				     struct flow_match_ip *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_IP, out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_ip);
+
+void flow_rule_match_unmasked_key_ports(const struct flow_rule *rule,
+					struct flow_match_ports *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_PORTS, out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_ports);
+
+void flow_rule_match_unmasked_key_tcp(const struct flow_rule *rule,
+				      struct flow_match_tcp *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_TCP, out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_tcp);
+
+void flow_rule_match_unmasked_key_icmp(const struct flow_rule *rule,
+				       struct flow_match_icmp *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ICMP, out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_icmp);
+
+void flow_rule_match_unmasked_key_mpls(const struct flow_rule *rule,
+				       struct flow_match_mpls *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_MPLS, out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_mpls);
+
+void flow_rule_match_unmasked_key_enc_control(const struct flow_rule *rule,
+					      struct flow_match_control *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL,
+					  out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_enc_control);
+
+void
+flow_rule_match_unmasked_key_enc_ipv4_addrs(const struct flow_rule *rule,
+					    struct flow_match_ipv4_addrs *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule,
+					  FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
+					  out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_enc_ipv4_addrs);
+
+void
+flow_rule_match_unmasked_key_enc_ipv6_addrs(const struct flow_rule *rule,
+					    struct flow_match_ipv6_addrs *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule,
+					  FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS,
+					  out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_enc_ipv6_addrs);
+
+void flow_rule_match_unmasked_key_enc_ip(const struct flow_rule *rule,
+					 struct flow_match_ip *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_IP, out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_enc_ip);
+
+void flow_rule_match_unmasked_key_enc_ports(const struct flow_rule *rule,
+					    struct flow_match_ports *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_PORTS,
+					  out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_enc_ports);
+
+void flow_rule_match_unmasked_key_enc_keyid(const struct flow_rule *rule,
+					    struct flow_match_enc_keyid *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_KEYID,
+					  out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_enc_keyid);
+
+void flow_rule_match_unmasked_key_enc_opts(const struct flow_rule *rule,
+					   struct flow_match_enc_opts *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_OPTS,
+					  out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_enc_opts);
+
+void flow_rule_match_unmasked_key_ct(const struct flow_rule *rule,
+				     struct flow_match_ct *out)
+{
+	FLOW_UNMASKED_KEY_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_CT, out);
+}
+EXPORT_SYMBOL(flow_rule_match_unmasked_key_ct);
+
 struct flow_action_cookie *flow_action_cookie_create(void *data,
 						     unsigned int len,
 						     gfp_t gfp)
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 64b70d396397..f1a5352cbb04 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -121,6 +121,7 @@ struct cls_fl_filter {
 	 */
 	refcount_t refcnt;
 	bool deleted;
+	struct flow_dissector unmasked_key_dissector;
 };
 
 static const struct rhashtable_params mask_ht_params = {
@@ -449,6 +450,13 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	cls_flower.rule->match.key = &f->mkey;
 	cls_flower.classid = f->res.classid;
 
+	/* Pass unmasked key and corresponding dissector also to the driver,
+	 * hardware may optimize its flow table based on its capabilities.
+	 */
+	cls_flower.rule->match.unmasked_key = &f->key;
+	cls_flower.rule->match.unmasked_key_dissector =
+						&f->unmasked_key_dissector;
+
 	err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
 	if (err) {
 		kfree(cls_flower.rule);
@@ -1753,6 +1761,39 @@ static void fl_init_dissector(struct flow_dissector *dissector,
 	skb_flow_dissector_init(dissector, keys, cnt);
 }
 
+/* Initialize dissector for unmasked key. */
+static void fl_init_unmasked_key_dissector(struct flow_dissector *dissector)
+{
+	struct flow_dissector_key keys[FLOW_DISSECTOR_KEY_MAX];
+	size_t cnt = 0;
+
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_META, meta);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_CONTROL, control);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_BASIC, basic);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ETH_ADDRS, eth);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_PORTS, tp);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_PORTS_RANGE, tp_range);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_IP, ip);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_TCP, tcp);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ICMP, icmp);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ARP, arp);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_MPLS, mpls);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_VLAN, vlan);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_CVLAN, cvlan);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_KEYID, enc_key_id);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS, enc_ipv4);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS, enc_ipv6);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_CONTROL, enc_control);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_PORTS, enc_tp);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_IP, enc_ip);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_ENC_OPTS, enc_opts);
+	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_CT, ct);
+
+	skb_flow_dissector_init(dissector, keys, cnt);
+}
+
 static struct fl_flow_mask *fl_create_new_mask(struct cls_fl_head *head,
 					       struct fl_flow_mask *mask)
 {
@@ -1980,6 +2021,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	if (err)
 		goto errout;
 
+	fl_init_unmasked_key_dissector(&fnew->unmasked_key_dissector);
+
 	err = fl_ht_insert_unique(fnew, fold, &in_ht);
 	if (err)
 		goto errout_mask;
-- 
2.17.1

