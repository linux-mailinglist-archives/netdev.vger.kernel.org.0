Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011365F4D53
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 03:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiJEBUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 21:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJEBUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 21:20:06 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FEA71C401
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 18:20:02 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-127dca21a7dso18394650fac.12
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 18:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Ceuc5hMxkKSWe0YzMEQGxi0JYCsW2TKctFQMwFXBbrk=;
        b=daNmJ+rZ2Yc9PtQPZlXy7hKebRpGcmBwnO1RerQx2mPrtFK4r5LavQoKt7aVPf56Mq
         hs8bDrxuAYvOV5+2vUCdM9WKhteCOY+4zTCLuerU9p0WMvLfenx3pXwGBZTYFmOQyZP+
         XO3xwPR4/1m4+WPheJsrVltvElz3Bk7PRJX5WWFyizdM/C/32Wf8Sox4rv1XYaTUGBxw
         tHvvjHl87Z9tAXIuBDdNqKfvK741txDEFfetnrPXWtwfAwM2IaQdlqsGHWB9dcYSzuaO
         PwDVesSJrxtLgrjYb7sRGTURib/sKJTF6md4xlB/DBdmeBC/xjM1G8p2lSJ/f6NqtE6c
         ftlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Ceuc5hMxkKSWe0YzMEQGxi0JYCsW2TKctFQMwFXBbrk=;
        b=gEVhlhWzIwGR1i/XZKq9z9IN0qdC0rG2wgxj60QUnVy/Cy8hKOkEOJgJE8L5mKzySA
         J/2+R5vkqjb+HKt3zLYSz0xwmE/AN4ZSPnMyOQFPr/jw2lwNpOQEsq/Xya5DjJKxlHKR
         5RAoX428L+orqitOVtOz0pOls1ZcJeaOFmY4fNlQAkUz2fg4YQ2DR1qWjF0zrE/VN4JN
         OZCHIgK6UYEiC7q05G1kG8APvIIpUY0FuGnScckIj/7qelWbTE3TPPcXjydtHs2N2I98
         6EfAaDF//w8WGF/w4leJXiCIXCQcI7T+262hAXIiU6G8Xp2XrRic0s3PXQKfGnZWjK4a
         K4Lg==
X-Gm-Message-State: ACrzQf0QKBtVhemx6nh3aL9irwAt51n+bw1ItD/nBEOR42qQG6+EjGQl
        GU2qsbKKTReAx76H9RTw6+QPVPe2Sw3JHg==
X-Google-Smtp-Source: AMsMyM5hXuifpNig/ratiuZd2gGfkhnO+SZU1ei5PA33OCpBWU3tdr18bDGD3h1l5e1KNBj/87OxBQ==
X-Received: by 2002:a05:6870:e99a:b0:12c:8a51:ba3f with SMTP id r26-20020a056870e99a00b0012c8a51ba3fmr1362596oao.276.1664932800904;
        Tue, 04 Oct 2022 18:20:00 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id ce4-20020a056830628400b00660a927e3bcsm1631787otb.25.2022.10.04.18.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 18:20:00 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>
Subject: [PATCH net-next 1/3] net: move the helper function to nf_conntrack_helper for ovs and tc
Date:   Tue,  4 Oct 2022 21:19:54 -0400
Message-Id: <7ede455b42ed8cb29cb66d6c5182add429653b53.1664932669.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1664932669.git.lucien.xin@gmail.com>
References: <cover.1664932669.git.lucien.xin@gmail.com>
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

Move ovs_ct_helper from openvswitch to nf_conntrack_helper and rename
as nf_ct_helper so that it can be used in TC act_ct in the next patch.
Note that it also adds the checks for the family and proto, as in TC
act_ct, the packets with correct family and proto are not guaranteed.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netfilter/nf_conntrack_helper.h |  2 +
 net/netfilter/nf_conntrack_helper.c         | 71 +++++++++++++++++++++
 net/openvswitch/conntrack.c                 | 61 +-----------------
 3 files changed, 74 insertions(+), 60 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 9939c366f720..6c32e59fc16f 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -115,6 +115,8 @@ struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp);
 int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 			      gfp_t flags);
 
+int nf_ct_helper(struct sk_buff *skb, u16 proto);
+
 void nf_ct_helper_destroy(struct nf_conn *ct);
 
 static inline struct nf_conn_help *nfct_help(const struct nf_conn *ct)
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index ff737a76052e..83615e479f87 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -26,7 +26,9 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_log.h>
+#include <net/ip.h>
 
 static DEFINE_MUTEX(nf_ct_helper_mutex);
 struct hlist_head *nf_ct_helper_hash __read_mostly;
@@ -240,6 +242,75 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 }
 EXPORT_SYMBOL_GPL(__nf_ct_try_assign_helper);
 
+/* 'skb' should already be pulled to nh_ofs. */
+int nf_ct_helper(struct sk_buff *skb, u16 proto)
+{
+	const struct nf_conntrack_helper *helper;
+	const struct nf_conn_help *help;
+	enum ip_conntrack_info ctinfo;
+	unsigned int protoff;
+	struct nf_conn *ct;
+	int err;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
+		return NF_ACCEPT;
+
+	help = nfct_help(ct);
+	if (!help)
+		return NF_ACCEPT;
+
+	helper = rcu_dereference(help->helper);
+	if (!helper)
+		return NF_ACCEPT;
+
+	if (helper->tuple.src.l3num != NFPROTO_UNSPEC &&
+	    helper->tuple.src.l3num != proto)
+		return NF_ACCEPT;
+
+	switch (proto) {
+	case NFPROTO_IPV4:
+		protoff = ip_hdrlen(skb);
+		proto = ip_hdr(skb)->protocol;
+		break;
+	case NFPROTO_IPV6: {
+		u8 nexthdr = ipv6_hdr(skb)->nexthdr;
+		__be16 frag_off;
+		int ofs;
+
+		ofs = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
+				       &frag_off);
+		if (ofs < 0 || (frag_off & htons(~0x7)) != 0) {
+			pr_debug("proto header not found\n");
+			return NF_ACCEPT;
+		}
+		protoff = ofs;
+		proto = nexthdr;
+		break;
+	}
+	default:
+		WARN_ONCE(1, "helper invoked on non-IP family!");
+		return NF_DROP;
+	}
+
+	if (helper->tuple.dst.protonum != proto)
+		return NF_ACCEPT;
+
+	err = helper->help(skb, protoff, ct, ctinfo);
+	if (err != NF_ACCEPT)
+		return err;
+
+	/* Adjust seqs after helper.  This is needed due to some helpers (e.g.,
+	 * FTP with NAT) adusting the TCP payload size when mangling IP
+	 * addresses and/or port numbers in the text-based control connection.
+	 */
+	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
+	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
+		return NF_DROP;
+	return NF_ACCEPT;
+}
+EXPORT_SYMBOL_GPL(nf_ct_helper);
+
 /* appropriate ct lock protecting must be taken by caller */
 static int unhelp(struct nf_conn *ct, void *me)
 {
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index cb255d8ed99a..75e709303815 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -434,65 +434,6 @@ static int ovs_ct_set_labels(struct nf_conn *ct, struct sw_flow_key *key,
 	return 0;
 }
 
-/* 'skb' should already be pulled to nh_ofs. */
-static int ovs_ct_helper(struct sk_buff *skb, u16 proto)
-{
-	const struct nf_conntrack_helper *helper;
-	const struct nf_conn_help *help;
-	enum ip_conntrack_info ctinfo;
-	unsigned int protoff;
-	struct nf_conn *ct;
-	int err;
-
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
-		return NF_ACCEPT;
-
-	help = nfct_help(ct);
-	if (!help)
-		return NF_ACCEPT;
-
-	helper = rcu_dereference(help->helper);
-	if (!helper)
-		return NF_ACCEPT;
-
-	switch (proto) {
-	case NFPROTO_IPV4:
-		protoff = ip_hdrlen(skb);
-		break;
-	case NFPROTO_IPV6: {
-		u8 nexthdr = ipv6_hdr(skb)->nexthdr;
-		__be16 frag_off;
-		int ofs;
-
-		ofs = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr,
-				       &frag_off);
-		if (ofs < 0 || (frag_off & htons(~0x7)) != 0) {
-			pr_debug("proto header not found\n");
-			return NF_ACCEPT;
-		}
-		protoff = ofs;
-		break;
-	}
-	default:
-		WARN_ONCE(1, "helper invoked on non-IP family!");
-		return NF_DROP;
-	}
-
-	err = helper->help(skb, protoff, ct, ctinfo);
-	if (err != NF_ACCEPT)
-		return err;
-
-	/* Adjust seqs after helper.  This is needed due to some helpers (e.g.,
-	 * FTP with NAT) adusting the TCP payload size when mangling IP
-	 * addresses and/or port numbers in the text-based control connection.
-	 */
-	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
-	    !nf_ct_seq_adjust(skb, ct, ctinfo, protoff))
-		return NF_DROP;
-	return NF_ACCEPT;
-}
-
 /* Returns 0 on success, -EINPROGRESS if 'skb' is stolen, or other nonzero
  * value if 'skb' is freed.
  */
@@ -1037,7 +978,7 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 		 */
 		if ((nf_ct_is_confirmed(ct) ? !cached || add_helper :
 					      info->commit) &&
-		    ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
+		    nf_ct_helper(skb, info->family) != NF_ACCEPT) {
 			return -EINVAL;
 		}
 
-- 
2.31.1

