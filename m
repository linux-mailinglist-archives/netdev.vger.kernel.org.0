Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB8C68E3A1
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 23:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjBGWwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 17:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjBGWwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 17:52:16 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434806191
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 14:52:15 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id j9so10212108qvt.0
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 14:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sjvoUtm+ePjfUM8gtJzFLeJsQ6L7hMcptpwWjVIr8NU=;
        b=VmSoY9hpmQXkNwlR2THU263UmuoULGlT7OUTTQJmm4e6WRthbDDcYNuu+kTLO3886l
         yyEPAJvwPQA5hWZlUx9bIy9C9rkYwk6YnK99zHz/DDwqIJjoOztrMLs5bSVp5btYoO1L
         /k3DrNLc8AZw2GvpZguHLNEuLIxrTLgWTIm7ZLjVbT4fodhmkWhwY3MO4I52Z2/FSnAp
         mOHWO27quCkyv0f5B2Hnd1FQn6wRDJer7mcEsMYC1hqe4yGs2xdY1ydFzbq4XvACzUaT
         mYsEOERD651Zi19nlR+MPcwEq86Ej+VQ1ZiMzO/iV6vs/mecchKcZPPp1S9WLPrdP8iS
         bNMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sjvoUtm+ePjfUM8gtJzFLeJsQ6L7hMcptpwWjVIr8NU=;
        b=XoDFWl1Tf08sc5aHbuDyjScI9xFMvUK6gDnsgtdJ0NV+43BR/oAqPreT4/1tdBpGMx
         ItBv5tP8bxbCH5CIEcXNCm3pIO+yvzWheOmryqJVIVdn9wDB0VOjntmBom/tT2w5+CJK
         bJSuIGSVhgyYYYqdqAimXWyjmCEflGmTbZXh5JQuvp/qPdTN2tq1J2gzJb23pdHu7hwn
         zxtEdPAWw4G3PHBDMMg2agGZsjoP2NqZg88NsE+i05jzfaf8StZvLWYdDUWnkcAsEeyY
         m9Mon1aL+GeOuMCk4PgVmFJofcGf/6LiaLNH/yXv3aMKfmymK8xA6VaJPGcf5bxoCjin
         k83w==
X-Gm-Message-State: AO0yUKXEMxr8eVHSxiQGlMMiUWhP6/ZZXp4YGsw2uKCSw+GF4XPQ12q8
        P6fTSgtQW4UFEugyRYsOfyZHKsEOHFTbXQ==
X-Google-Smtp-Source: AK7set+v/YTm8nZvQpYDFvpnDpDYj1qnZfIWM0bZQ3wDYr4uIPg2KcVUInd1Y02TSoVDDS5mOLtGNg==
X-Received: by 2002:a05:6214:230e:b0:56b:ff69:7df8 with SMTP id gc14-20020a056214230e00b0056bff697df8mr8533090qvb.51.1675810334188;
        Tue, 07 Feb 2023 14:52:14 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w15-20020a05620a444f00b007296805f607sm10622037qkp.17.2023.02.07.14.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 14:52:13 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCHv2 net-next 2/5] net: extract nf_ct_skb_network_trim function to nf_conntrack_ovs
Date:   Tue,  7 Feb 2023 17:52:07 -0500
Message-Id: <0dd0765269b3c92d3856331738bbb464537804e1.1675810210.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1675810210.git.lucien.xin@gmail.com>
References: <cover.1675810210.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are almost the same code in ovs_skb_network_trim() and
tcf_ct_skb_network_trim(), this patch extracts them into a function
nf_ct_skb_network_trim() and moves the function to nf_conntrack_ovs.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netfilter/nf_conntrack.h |  2 ++
 net/netfilter/nf_conntrack_ovs.c     | 26 ++++++++++++++++++++
 net/openvswitch/conntrack.c          | 36 ++++------------------------
 net/sched/act_ct.c                   | 27 +--------------------
 4 files changed, 33 insertions(+), 58 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 6a2019aaa464..a6e89d7212f8 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -362,6 +362,8 @@ static inline struct nf_conntrack_net *nf_ct_pernet(const struct net *net)
 	return net_generic(net, nf_conntrack_net_id);
 }
 
+int nf_ct_skb_network_trim(struct sk_buff *skb, int family);
+
 #define NF_CT_STAT_INC(net, count)	  __this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_INC_ATOMIC(net, count) this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_ADD_ATOMIC(net, count, v) this_cpu_add((net)->ct.stat->count, (v))
diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index eff4d53f8b8c..c60ef71d1aea 100644
--- a/net/netfilter/nf_conntrack_ovs.c
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -102,3 +102,29 @@ int nf_ct_add_helper(struct nf_conn *ct, const char *name, u8 family,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_add_helper);
+
+/* Trim the skb to the length specified by the IP/IPv6 header,
+ * removing any trailing lower-layer padding. This prepares the skb
+ * for higher-layer processing that assumes skb->len excludes padding
+ * (such as nf_ip_checksum). The caller needs to pull the skb to the
+ * network header, and ensure ip_hdr/ipv6_hdr points to valid data.
+ */
+int nf_ct_skb_network_trim(struct sk_buff *skb, int family)
+{
+	unsigned int len;
+
+	switch (family) {
+	case NFPROTO_IPV4:
+		len = skb_ip_totlen(skb);
+		break;
+	case NFPROTO_IPV6:
+		len = sizeof(struct ipv6hdr)
+			+ ntohs(ipv6_hdr(skb)->payload_len);
+		break;
+	default:
+		len = skb->len;
+	}
+
+	return pskb_trim_rcsum(skb, len);
+}
+EXPORT_SYMBOL_GPL(nf_ct_skb_network_trim);
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 2172930b1f17..47a58657b1e4 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1090,36 +1090,6 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
 	return 0;
 }
 
-/* Trim the skb to the length specified by the IP/IPv6 header,
- * removing any trailing lower-layer padding. This prepares the skb
- * for higher-layer processing that assumes skb->len excludes padding
- * (such as nf_ip_checksum). The caller needs to pull the skb to the
- * network header, and ensure ip_hdr/ipv6_hdr points to valid data.
- */
-static int ovs_skb_network_trim(struct sk_buff *skb)
-{
-	unsigned int len;
-	int err;
-
-	switch (skb->protocol) {
-	case htons(ETH_P_IP):
-		len = skb_ip_totlen(skb);
-		break;
-	case htons(ETH_P_IPV6):
-		len = sizeof(struct ipv6hdr)
-			+ ntohs(ipv6_hdr(skb)->payload_len);
-		break;
-	default:
-		len = skb->len;
-	}
-
-	err = pskb_trim_rcsum(skb, len);
-	if (err)
-		kfree_skb(skb);
-
-	return err;
-}
-
 /* Returns 0 on success, -EINPROGRESS if 'skb' is stolen, or other nonzero
  * value if 'skb' is freed.
  */
@@ -1134,9 +1104,11 @@ int ovs_ct_execute(struct net *net, struct sk_buff *skb,
 	nh_ofs = skb_network_offset(skb);
 	skb_pull_rcsum(skb, nh_ofs);
 
-	err = ovs_skb_network_trim(skb);
-	if (err)
+	err = nf_ct_skb_network_trim(skb, info->family);
+	if (err) {
+		kfree_skb(skb);
 		return err;
+	}
 
 	if (key->ip.frag != OVS_FRAG_TYPE_NONE) {
 		err = handle_fragments(net, key, info->zone.id, skb);
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index b126f03c1bb6..0a1ecc972a8b 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -726,31 +726,6 @@ static bool tcf_ct_skb_nfct_cached(struct net *net, struct sk_buff *skb,
 	return false;
 }
 
-/* Trim the skb to the length specified by the IP/IPv6 header,
- * removing any trailing lower-layer padding. This prepares the skb
- * for higher-layer processing that assumes skb->len excludes padding
- * (such as nf_ip_checksum). The caller needs to pull the skb to the
- * network header, and ensure ip_hdr/ipv6_hdr points to valid data.
- */
-static int tcf_ct_skb_network_trim(struct sk_buff *skb, int family)
-{
-	unsigned int len;
-
-	switch (family) {
-	case NFPROTO_IPV4:
-		len = skb_ip_totlen(skb);
-		break;
-	case NFPROTO_IPV6:
-		len = sizeof(struct ipv6hdr)
-			+ ntohs(ipv6_hdr(skb)->payload_len);
-		break;
-	default:
-		len = skb->len;
-	}
-
-	return pskb_trim_rcsum(skb, len);
-}
-
 static u8 tcf_ct_skb_nf_family(struct sk_buff *skb)
 {
 	u8 family = NFPROTO_UNSPEC;
@@ -1011,7 +986,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	if (err)
 		goto drop;
 
-	err = tcf_ct_skb_network_trim(skb, family);
+	err = nf_ct_skb_network_trim(skb, family);
 	if (err)
 		goto drop;
 
-- 
2.31.1

