Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C1468ACC6
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 23:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbjBDWDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 17:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbjBDWC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 17:02:58 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4251CCA26
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 14:02:56 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id h24so9274934qta.12
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 14:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sjvoUtm+ePjfUM8gtJzFLeJsQ6L7hMcptpwWjVIr8NU=;
        b=M4mcZAd/FehY/SITADRTcv3dzNkTY+se4inMf1alN7sFjGfJzjtAxQe3ErP7/XmliY
         K3jvMbHdgvZ0KvRT5jNH9J39GssTjXe28U9Qmbt8Bm81oVYM+QPaXzkBt+26gT7wcM9w
         ppDGNcN3kA2bUxjt22lhxVoGG8ew1F7s3Fr+n3hk0GMWeM8RAHEAIE0EYUmXKnCM3txo
         Ejn7Qfa0oeQhkx3o10R8MLWtkekaOdFqq0Qg7KkrORZzGeSbr4JfaHzzGwnt3DZatU6o
         oANFF4pZKBwzK4eT4o7/5buVsN+a2Usi5NIt32Hk5D2wk/CyUIUrLkc4uKpG6vD5F0qv
         MDNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sjvoUtm+ePjfUM8gtJzFLeJsQ6L7hMcptpwWjVIr8NU=;
        b=edn9jphI3SPirj6XVgMsBDPf9FAbi1Jhb0j0o7+Q+gTbzJFbnROBaul8WwMpYH7ev6
         f+PmLoXh5M1pUroU5u4DxTSZKhBK2ki7xbhKnENBzHIVFleKIDCB7TDv5xQz3MCFTkbT
         vcg1QYyuWh8q/ba2l+xJKNX/jWRcWAVklTY1Nedg7sztG+LIPN3b15rbEacMyuJLiEmG
         cJTWSdDPossTpFr2ro4hohq8nEMomvi6DCXlMM/U6xNn5v0+hiwcT7ac1QfKMQ640gyI
         yxKYb4MhcAYUzUBj1n8dvqGDMskRHTR4NkBb0XfcZGZIL3d9iSeLZAXXqmnA7+Pusojf
         aprg==
X-Gm-Message-State: AO0yUKV/3RM7TBiJwBm33QhiPDmKUeTrxZrd/SwfAZCk7l/cKVcsneJV
        5m9dUl59oCAhivE0hDK5YzFccvvLI+3F/A==
X-Google-Smtp-Source: AK7set97DlqTmbYJhZP8DLMDB/+se8d0Diz2eIYmf762p9agVtOQAo67NSP3eX+gEO2lF/837EiC4g==
X-Received: by 2002:a05:622a:1991:b0:3b9:bf32:f8d5 with SMTP id u17-20020a05622a199100b003b9bf32f8d5mr27090012qtc.14.1675548175175;
        Sat, 04 Feb 2023 14:02:55 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id dm40-20020a05620a1d6800b006fef61300fesm4423061qkb.16.2023.02.04.14.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 14:02:54 -0800 (PST)
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
Subject: [PATCH net-next 2/5] net: extract nf_ct_skb_network_trim function to nf_conntrack_ovs
Date:   Sat,  4 Feb 2023 17:02:48 -0500
Message-Id: <c47c8808a2e46776ed38218ed6c8ddd59ced59d6.1675548023.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1675548023.git.lucien.xin@gmail.com>
References: <cover.1675548023.git.lucien.xin@gmail.com>
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

