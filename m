Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8286F68E3A0
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 23:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjBGWwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 17:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjBGWwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 17:52:15 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2453B558C
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 14:52:14 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id j9so10212071qvt.0
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 14:52:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lmTO2yvB6o4eZJOwaqq1SmR3XEgJqSAVeoWDhrOLzUo=;
        b=j+SJ0K3f7U5H2fVt7Mf/i5su1XyN+hz8H5sSxwz6DnOBfPsaThJ3i3f4wK6mrjrMDz
         Jld5QgaubB0dAVimBRTTJHfrkR0JRkab47vn1ufosV0dw82/zatYs4nNQ7BYvIvLV8mU
         SfH5mDWEUpadzrAoZIqAXRsyq6XxvxVWOpbqdhLpvei1vgR0xw7j9+5VhuONFbjMF/9A
         SJGILg4nK881jb9J8xc06PCO3yrAcW5T7uIAtimToV25UEhN+MVWD9+9XYMMcloMfYf1
         1B0nI7nKlJKTm+kkOqLtVo4yuS7AmUkl/bmKognIuoucimJEgVBJTuyPETCOOYdQOD25
         CddA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lmTO2yvB6o4eZJOwaqq1SmR3XEgJqSAVeoWDhrOLzUo=;
        b=bcXRzh8cZNWQEJKuk3gcPJy9XAbh8c2yP3WfOXWs1dBWAxf9cH612333SPdWH27SFJ
         x0gn1SMtr6xQgSgDaunRUxS4R8j1S3EHDC+vGK1IQJ4oHBp4id6n/pVmyJJg9/Rwwksv
         8nMa12LfzGywLkn+sp7nSXzZbGxUpB6nlxzL0mSeDZsXZ5ZayxBvcOo2sLFwkxNDdPVt
         6eiKhSBRpn2f3n8MR6t2RztX9/0261cd3g2Frl/z3SR/NmwvEi1RYQXXadVkzeLYYoVW
         B7wpAHyk8yZoc8smaN0MKMKFSY/0t+ECjYmdOkQvaPj4Ufu8A66TcEGblLK3XMlsdIuy
         Be5A==
X-Gm-Message-State: AO0yUKU7s4lbHYNqs7bOIp177/gAbqSa1BhJKdV3iHk9Cdg9XMVvsMjD
        1cu6diJA0BaoPP9WTqCSVxTzKxQsBblLig==
X-Google-Smtp-Source: AK7set8S58npFUcEyXQM4TbLUA5qje/tNgCOfyfF3Cyihpwy/AlZv8zOf1WkzBpCDg0cApwhME/hNg==
X-Received: by 2002:a05:6214:27c2:b0:535:5492:b422 with SMTP id ge2-20020a05621427c200b005355492b422mr6930338qvb.30.1675810333006;
        Tue, 07 Feb 2023 14:52:13 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w15-20020a05620a444f00b007296805f607sm10622037qkp.17.2023.02.07.14.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 14:52:12 -0800 (PST)
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
Subject: [PATCHv2 net-next 1/5] net: create nf_conntrack_ovs for ovs and tc use
Date:   Tue,  7 Feb 2023 17:52:06 -0500
Message-Id: <40147ea76fbcedaa477a68e4ef12399dd36782bc.1675810210.git.lucien.xin@gmail.com>
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

Similar to nf_nat_ovs created by Commit ebddb1404900 ("net: move the
nat function to nf_nat_ovs for ovs and tc"), this patch is to create
nf_conntrack_ovs to get these functions shared by OVS and TC only.

There are nf_ct_helper() and nf_ct_add_helper() from nf_conntrak_helper
in this patch, and will be more in the following patches.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/Kconfig               |   3 +
 net/netfilter/Makefile              |   1 +
 net/netfilter/nf_conntrack_helper.c |  98 --------------------------
 net/netfilter/nf_conntrack_ovs.c    | 104 ++++++++++++++++++++++++++++
 net/openvswitch/Kconfig             |   1 +
 net/sched/Kconfig                   |   1 +
 6 files changed, 110 insertions(+), 98 deletions(-)
 create mode 100644 net/netfilter/nf_conntrack_ovs.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f71b41c7ce2f..4d6737160857 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -189,6 +189,9 @@ config NF_CONNTRACK_LABELS
 	  to connection tracking entries.  It can be used with xtables connlabel
 	  match and the nftables ct expression.
 
+config NF_CONNTRACK_OVS
+	bool
+
 config NF_CT_PROTO_DCCP
 	bool 'DCCP protocol connection tracking support'
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index ba2a6b5e93d9..5ffef1cd6143 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -11,6 +11,7 @@ nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMEOUT) += nf_conntrack_timeout.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMESTAMP) += nf_conntrack_timestamp.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_LABELS) += nf_conntrack_labels.o
+nf_conntrack-$(CONFIG_NF_CONNTRACK_OVS) += nf_conntrack_ovs.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_DCCP) += nf_conntrack_proto_dccp.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_SCTP) += nf_conntrack_proto_sctp.o
 nf_conntrack-$(CONFIG_NF_CT_PROTO_GRE) += nf_conntrack_proto_gre.o
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 48ea6d0264b5..0c4db2f2ac43 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -242,104 +242,6 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 }
 EXPORT_SYMBOL_GPL(__nf_ct_try_assign_helper);
 
-/* 'skb' should already be pulled to nh_ofs. */
-int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
-		 enum ip_conntrack_info ctinfo, u16 proto)
-{
-	const struct nf_conntrack_helper *helper;
-	const struct nf_conn_help *help;
-	unsigned int protoff;
-	int err;
-
-	if (ctinfo == IP_CT_RELATED_REPLY)
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
-	if (helper->tuple.src.l3num != NFPROTO_UNSPEC &&
-	    helper->tuple.src.l3num != proto)
-		return NF_ACCEPT;
-
-	switch (proto) {
-	case NFPROTO_IPV4:
-		protoff = ip_hdrlen(skb);
-		proto = ip_hdr(skb)->protocol;
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
-		proto = nexthdr;
-		break;
-	}
-	default:
-		WARN_ONCE(1, "helper invoked on non-IP family!");
-		return NF_DROP;
-	}
-
-	if (helper->tuple.dst.protonum != proto)
-		return NF_ACCEPT;
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
-EXPORT_SYMBOL_GPL(nf_ct_helper);
-
-int nf_ct_add_helper(struct nf_conn *ct, const char *name, u8 family,
-		     u8 proto, bool nat, struct nf_conntrack_helper **hp)
-{
-	struct nf_conntrack_helper *helper;
-	struct nf_conn_help *help;
-	int ret = 0;
-
-	helper = nf_conntrack_helper_try_module_get(name, family, proto);
-	if (!helper)
-		return -EINVAL;
-
-	help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
-	if (!help) {
-		nf_conntrack_helper_put(helper);
-		return -ENOMEM;
-	}
-#if IS_ENABLED(CONFIG_NF_NAT)
-	if (nat) {
-		ret = nf_nat_helper_try_module_get(name, family, proto);
-		if (ret) {
-			nf_conntrack_helper_put(helper);
-			return ret;
-		}
-	}
-#endif
-	rcu_assign_pointer(help->helper, helper);
-	*hp = helper;
-	return ret;
-}
-EXPORT_SYMBOL_GPL(nf_ct_add_helper);
-
 /* appropriate ct lock protecting must be taken by caller */
 static int unhelp(struct nf_conn *ct, void *me)
 {
diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
new file mode 100644
index 000000000000..eff4d53f8b8c
--- /dev/null
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -0,0 +1,104 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Support ct functions for openvswitch and used by OVS and TC conntrack. */
+
+#include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
+#include <net/ip.h>
+
+/* 'skb' should already be pulled to nh_ofs. */
+int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
+		 enum ip_conntrack_info ctinfo, u16 proto)
+{
+	const struct nf_conntrack_helper *helper;
+	const struct nf_conn_help *help;
+	unsigned int protoff;
+	int err;
+
+	if (ctinfo == IP_CT_RELATED_REPLY)
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
+int nf_ct_add_helper(struct nf_conn *ct, const char *name, u8 family,
+		     u8 proto, bool nat, struct nf_conntrack_helper **hp)
+{
+	struct nf_conntrack_helper *helper;
+	struct nf_conn_help *help;
+	int ret = 0;
+
+	helper = nf_conntrack_helper_try_module_get(name, family, proto);
+	if (!helper)
+		return -EINVAL;
+
+	help = nf_ct_helper_ext_add(ct, GFP_KERNEL);
+	if (!help) {
+		nf_conntrack_helper_put(helper);
+		return -ENOMEM;
+	}
+#if IS_ENABLED(CONFIG_NF_NAT)
+	if (nat) {
+		ret = nf_nat_helper_try_module_get(name, family, proto);
+		if (ret) {
+			nf_conntrack_helper_put(helper);
+			return ret;
+		}
+	}
+#endif
+	rcu_assign_pointer(help->helper, helper);
+	*hp = helper;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_ct_add_helper);
diff --git a/net/openvswitch/Kconfig b/net/openvswitch/Kconfig
index 747d537a3f06..29a7081858cd 100644
--- a/net/openvswitch/Kconfig
+++ b/net/openvswitch/Kconfig
@@ -15,6 +15,7 @@ config OPENVSWITCH
 	select NET_MPLS_GSO
 	select DST_CACHE
 	select NET_NSH
+	select NF_CONNTRACK_OVS if NF_CONNTRACK
 	select NF_NAT_OVS if NF_NAT
 	help
 	  Open vSwitch is a multilayer Ethernet switch targeted at virtualized
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index f5acb535413d..4f7b52f5a11c 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -984,6 +984,7 @@ config NET_ACT_TUNNEL_KEY
 config NET_ACT_CT
 	tristate "connection tracking tc action"
 	depends on NET_CLS_ACT && NF_CONNTRACK && (!NF_NAT || NF_NAT) && NF_FLOW_TABLE
+	select NF_CONNTRACK_OVS
 	select NF_NAT_OVS if NF_NAT
 	help
 	  Say Y here to allow sending the packets to conntrack module.
-- 
2.31.1

