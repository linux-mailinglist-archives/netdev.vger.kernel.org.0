Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2CF634285
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbiKVRcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbiKVRci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:32:38 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5326374
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:32:32 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id x18so10763679qki.4
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 09:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1Wz9pcIMhcfYoeObTauu2Pan+ugQgsifFGJ9WUx4lo=;
        b=bZ9H2De9h5fVWjdNmELK8zNLPyxIMmqpMdFrvxOMWQICUNbBeR40LsdX3iRM988grS
         k1umHoo6gbqJ1VAgbONYG9GUlWfmb1xsJT605lZbJlkVZ/3Uu+o8EaZ39NbapC1zP3pJ
         KN0juwcn30LtMBvLG0dYXM1EQhWS3UglcDZtZ9/FGaT0vEISBGJjtnwSngIfD/lUU43m
         Tazn3bEahIft7Tmuk+SsSnQ6Ry1esB4an3e/tFXgsNK6xEjdGVId222w1BZ8HFBceiex
         tjyIVqWfB8msnvowC5MjpyiB4L4+j7uCrgRok7dgk3+kadpFSmHZ/rhla9sCkv8orftn
         Dhlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J1Wz9pcIMhcfYoeObTauu2Pan+ugQgsifFGJ9WUx4lo=;
        b=REWRzWFXEoWxlwjqqLXcxgp49M0VcTj02Bl/YaLiiHcPMdAatcCGzxTdY/FIbcfK6L
         zX2mDce/H+iyzc8tlPZyaqCr5F94UYQWI/LfdQfUhMQahRtWpFFW+1zvkRIm21t03Fb5
         K6bk0eMDw5e5o274vgHdXhgXDJHJ2jqDUKy8DYY8TSjcHLJnBZwT4gI8pv2BOrFvcSRD
         fys7f4Xzqp20RZRGPD3YZypvW2haxctIaEwhAnx++ZThOQ/RoZOgBZLw4/6IE27Kqbz9
         sht60TjIcSsEpCMD8W0UmcRTKFBvFjsrvk65+bGdj1kQbP2vW2yntxwXfHlbv1bJ4z4Q
         sArQ==
X-Gm-Message-State: ANoB5plPEmziKXcAo8fKuLpz2pXyre1KVHc7qid8i72/Q4+Bjhp7rZa+
        VqreXuniUxtJpdtJbw9gIuJ7cCljIwBOeQ==
X-Google-Smtp-Source: AA0mqf5wUlgvaah52Dqu0/uOVnT/SQO50QifMd1f8A/cq81nfVpiOkcZignmYQ0ry19fhboLN48EpA==
X-Received: by 2002:a05:620a:1321:b0:6fa:2d31:5fa1 with SMTP id p1-20020a05620a132100b006fa2d315fa1mr6567139qkj.118.1669138351179;
        Tue, 22 Nov 2022 09:32:31 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j12-20020a05620a410c00b006eef13ef4c8sm10865040qko.94.2022.11.22.09.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 09:32:30 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org
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
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCHv2 net-next 5/5] net: move the nat function to nf_nat_ovs for ovs and tc
Date:   Tue, 22 Nov 2022 12:32:21 -0500
Message-Id: <bf19487f4dfc8cd91a4395672d9905b10917128d.1669138256.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1669138256.git.lucien.xin@gmail.com>
References: <cover.1669138256.git.lucien.xin@gmail.com>
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

There are two nat functions are nearly the same in both OVS and
TC code, (ovs_)ct_nat_execute() and ovs_ct_nat/tcf_ct_act_nat().

This patch creates nf_nat_ovs.c under netfilter and moves them
there then exports nf_ct_nat() so that it can be shared by both
OVS and TC, and keeps the nat (type) check and nat flag update
in OVS and TC's own place, as these parts are different between
OVS and TC.

Note that in OVS nat function it was using skb->protocol to get
the proto as it already skips vlans in key_extract(), while it
doesn't in TC, and TC has to call skb_protocol() to get proto.
So in nf_ct_nat_execute(), we keep using skb_protocol() which
works for both OVS and TC contrack.

Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netfilter/nf_nat.h |   4 +
 net/netfilter/Makefile         |   2 +-
 net/netfilter/nf_nat_ovs.c     | 135 ++++++++++++++++++++++++++++++++
 net/openvswitch/conntrack.c    | 137 +++------------------------------
 net/sched/act_ct.c             | 136 +++-----------------------------
 5 files changed, 161 insertions(+), 253 deletions(-)
 create mode 100644 net/netfilter/nf_nat_ovs.c

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index e9eb01e99d2f..9877f064548a 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -104,6 +104,10 @@ unsigned int
 nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state);
 
+int nf_ct_nat(struct sk_buff *skb, struct nf_conn *ct,
+	      enum ip_conntrack_info ctinfo, int *action,
+	      const struct nf_nat_range2 *range, bool commit);
+
 static inline int nf_nat_initialized(const struct nf_conn *ct,
 				     enum nf_nat_manip_type manip)
 {
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 1d4db1943936..4fa50d2842ec 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -52,7 +52,7 @@ obj-$(CONFIG_NF_CONNTRACK_SANE) += nf_conntrack_sane.o
 obj-$(CONFIG_NF_CONNTRACK_SIP) += nf_conntrack_sip.o
 obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
 
-nf_nat-y	:= nf_nat_core.o nf_nat_proto.o nf_nat_helper.o
+nf_nat-y	:= nf_nat_core.o nf_nat_proto.o nf_nat_helper.o nf_nat_ovs.o
 
 obj-$(CONFIG_NF_LOG_SYSLOG) += nf_log_syslog.o
 
diff --git a/net/netfilter/nf_nat_ovs.c b/net/netfilter/nf_nat_ovs.c
new file mode 100644
index 000000000000..daff80e7a43a
--- /dev/null
+++ b/net/netfilter/nf_nat_ovs.c
@@ -0,0 +1,135 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Support nat functions for openvswitch and used by OVS and TC conntrack. */
+
+#include <net/netfilter/nf_nat.h>
+
+/* Modelled after nf_nat_ipv[46]_fn().
+ * range is only used for new, uninitialized NAT state.
+ * Returns either NF_ACCEPT or NF_DROP.
+ */
+static int nf_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
+			     enum ip_conntrack_info ctinfo, int *action,
+			     const struct nf_nat_range2 *range,
+			     enum nf_nat_manip_type maniptype)
+{
+	__be16 proto = skb_protocol(skb, true);
+	int hooknum, err = NF_ACCEPT;
+
+	/* See HOOK2MANIP(). */
+	if (maniptype == NF_NAT_MANIP_SRC)
+		hooknum = NF_INET_LOCAL_IN; /* Source NAT */
+	else
+		hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
+
+	switch (ctinfo) {
+	case IP_CT_RELATED:
+	case IP_CT_RELATED_REPLY:
+		if (proto == htons(ETH_P_IP) &&
+		    ip_hdr(skb)->protocol == IPPROTO_ICMP) {
+			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
+							   hooknum))
+				err = NF_DROP;
+			goto out;
+		} else if (IS_ENABLED(CONFIG_IPV6) && proto == htons(ETH_P_IPV6)) {
+			__be16 frag_off;
+			u8 nexthdr = ipv6_hdr(skb)->nexthdr;
+			int hdrlen = ipv6_skip_exthdr(skb,
+						      sizeof(struct ipv6hdr),
+						      &nexthdr, &frag_off);
+
+			if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
+				if (!nf_nat_icmpv6_reply_translation(skb, ct,
+								     ctinfo,
+								     hooknum,
+								     hdrlen))
+					err = NF_DROP;
+				goto out;
+			}
+		}
+		/* Non-ICMP, fall thru to initialize if needed. */
+		fallthrough;
+	case IP_CT_NEW:
+		/* Seen it before?  This can happen for loopback, retrans,
+		 * or local packets.
+		 */
+		if (!nf_nat_initialized(ct, maniptype)) {
+			/* Initialize according to the NAT action. */
+			err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
+				/* Action is set up to establish a new
+				 * mapping.
+				 */
+				? nf_nat_setup_info(ct, range, maniptype)
+				: nf_nat_alloc_null_binding(ct, hooknum);
+			if (err != NF_ACCEPT)
+				goto out;
+		}
+		break;
+
+	case IP_CT_ESTABLISHED:
+	case IP_CT_ESTABLISHED_REPLY:
+		break;
+
+	default:
+		err = NF_DROP;
+		goto out;
+	}
+
+	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
+	if (err == NF_ACCEPT)
+		*action |= (1 << maniptype);
+out:
+	return err;
+}
+
+int nf_ct_nat(struct sk_buff *skb, struct nf_conn *ct,
+	      enum ip_conntrack_info ctinfo, int *action,
+	      const struct nf_nat_range2 *range, bool commit)
+{
+	enum nf_nat_manip_type maniptype;
+	int err, ct_action = *action;
+
+	*action = 0;
+
+	/* Add NAT extension if not confirmed yet. */
+	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
+		return NF_ACCEPT;   /* Can't NAT. */
+
+	if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
+	    (ctinfo != IP_CT_RELATED || commit)) {
+		/* NAT an established or related connection like before. */
+		if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
+			/* This is the REPLY direction for a connection
+			 * for which NAT was applied in the forward
+			 * direction.  Do the reverse NAT.
+			 */
+			maniptype = ct->status & IPS_SRC_NAT
+				? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
+		else
+			maniptype = ct->status & IPS_SRC_NAT
+				? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
+	} else if (ct_action & (1 << NF_NAT_MANIP_SRC)) {
+		maniptype = NF_NAT_MANIP_SRC;
+	} else if (ct_action & (1 << NF_NAT_MANIP_DST)) {
+		maniptype = NF_NAT_MANIP_DST;
+	} else {
+		return NF_ACCEPT;
+	}
+
+	err = nf_ct_nat_execute(skb, ct, ctinfo, action, range, maniptype);
+	if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
+		if (ct->status & IPS_SRC_NAT) {
+			if (maniptype == NF_NAT_MANIP_SRC)
+				maniptype = NF_NAT_MANIP_DST;
+			else
+				maniptype = NF_NAT_MANIP_SRC;
+
+			err = nf_ct_nat_execute(skb, ct, ctinfo, action, range,
+						maniptype);
+		} else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
+			err = nf_ct_nat_execute(skb, ct, ctinfo, action, NULL,
+						NF_NAT_MANIP_SRC);
+		}
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(nf_ct_nat);
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index cc643a556ea1..d03c75165663 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -726,144 +726,27 @@ static void ovs_nat_update_key(struct sw_flow_key *key,
 	}
 }
 
-/* Modelled after nf_nat_ipv[46]_fn().
- * range is only used for new, uninitialized NAT state.
- * Returns either NF_ACCEPT or NF_DROP.
- */
-static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
-			      enum ip_conntrack_info ctinfo,
-			      const struct nf_nat_range2 *range,
-			      enum nf_nat_manip_type maniptype, struct sw_flow_key *key)
-{
-	int hooknum, err = NF_ACCEPT;
-
-	/* See HOOK2MANIP(). */
-	if (maniptype == NF_NAT_MANIP_SRC)
-		hooknum = NF_INET_LOCAL_IN; /* Source NAT */
-	else
-		hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
-
-	switch (ctinfo) {
-	case IP_CT_RELATED:
-	case IP_CT_RELATED_REPLY:
-		if (IS_ENABLED(CONFIG_NF_NAT) &&
-		    skb->protocol == htons(ETH_P_IP) &&
-		    ip_hdr(skb)->protocol == IPPROTO_ICMP) {
-			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
-							   hooknum))
-				err = NF_DROP;
-			goto out;
-		} else if (IS_ENABLED(CONFIG_IPV6) &&
-			   skb->protocol == htons(ETH_P_IPV6)) {
-			__be16 frag_off;
-			u8 nexthdr = ipv6_hdr(skb)->nexthdr;
-			int hdrlen = ipv6_skip_exthdr(skb,
-						      sizeof(struct ipv6hdr),
-						      &nexthdr, &frag_off);
-
-			if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
-				if (!nf_nat_icmpv6_reply_translation(skb, ct,
-								     ctinfo,
-								     hooknum,
-								     hdrlen))
-					err = NF_DROP;
-				goto out;
-			}
-		}
-		/* Non-ICMP, fall thru to initialize if needed. */
-		fallthrough;
-	case IP_CT_NEW:
-		/* Seen it before?  This can happen for loopback, retrans,
-		 * or local packets.
-		 */
-		if (!nf_nat_initialized(ct, maniptype)) {
-			/* Initialize according to the NAT action. */
-			err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
-				/* Action is set up to establish a new
-				 * mapping.
-				 */
-				? nf_nat_setup_info(ct, range, maniptype)
-				: nf_nat_alloc_null_binding(ct, hooknum);
-			if (err != NF_ACCEPT)
-				goto out;
-		}
-		break;
-
-	case IP_CT_ESTABLISHED:
-	case IP_CT_ESTABLISHED_REPLY:
-		break;
-
-	default:
-		err = NF_DROP;
-		goto out;
-	}
-
-	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
-out:
-	/* Update the flow key if NAT successful. */
-	if (err == NF_ACCEPT)
-		ovs_nat_update_key(key, skb, maniptype);
-
-	return err;
-}
-
 /* Returns NF_DROP if the packet should be dropped, NF_ACCEPT otherwise. */
 static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 		      const struct ovs_conntrack_info *info,
 		      struct sk_buff *skb, struct nf_conn *ct,
 		      enum ip_conntrack_info ctinfo)
 {
-	enum nf_nat_manip_type maniptype;
-	int err;
+	int err, action = 0;
 
 	if (!(info->nat & OVS_CT_NAT))
 		return NF_ACCEPT;
+	if (info->nat & OVS_CT_SRC_NAT)
+		action |= (1 << NF_NAT_MANIP_SRC);
+	if (info->nat & OVS_CT_DST_NAT)
+		action |= (1 << NF_NAT_MANIP_DST);
 
-	/* Add NAT extension if not confirmed yet. */
-	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
-		return NF_ACCEPT;   /* Can't NAT. */
+	err = nf_ct_nat(skb, ct, ctinfo, &action, &info->range, info->commit);
 
-	/* Determine NAT type.
-	 * Check if the NAT type can be deduced from the tracked connection.
-	 * Make sure new expected connections (IP_CT_RELATED) are NATted only
-	 * when committing.
-	 */
-	if (ctinfo != IP_CT_NEW && ct->status & IPS_NAT_MASK &&
-	    (ctinfo != IP_CT_RELATED || info->commit)) {
-		/* NAT an established or related connection like before. */
-		if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
-			/* This is the REPLY direction for a connection
-			 * for which NAT was applied in the forward
-			 * direction.  Do the reverse NAT.
-			 */
-			maniptype = ct->status & IPS_SRC_NAT
-				? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
-		else
-			maniptype = ct->status & IPS_SRC_NAT
-				? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
-	} else if (info->nat & OVS_CT_SRC_NAT) {
-		maniptype = NF_NAT_MANIP_SRC;
-	} else if (info->nat & OVS_CT_DST_NAT) {
-		maniptype = NF_NAT_MANIP_DST;
-	} else {
-		return NF_ACCEPT; /* Connection is not NATed. */
-	}
-	err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range, maniptype, key);
-
-	if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
-		if (ct->status & IPS_SRC_NAT) {
-			if (maniptype == NF_NAT_MANIP_SRC)
-				maniptype = NF_NAT_MANIP_DST;
-			else
-				maniptype = NF_NAT_MANIP_SRC;
-
-			err = ovs_ct_nat_execute(skb, ct, ctinfo, &info->range,
-						 maniptype, key);
-		} else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
-			err = ovs_ct_nat_execute(skb, ct, ctinfo, NULL,
-						 NF_NAT_MANIP_SRC, key);
-		}
-	}
+	if (action & (1 << NF_NAT_MANIP_SRC))
+		ovs_nat_update_key(key, skb, NF_NAT_MANIP_SRC);
+	if (action & (1 << NF_NAT_MANIP_DST))
+		ovs_nat_update_key(key, skb, NF_NAT_MANIP_DST);
 
 	return err;
 }
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index c7782c9a6ab6..0c410220239f 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -863,90 +863,6 @@ static void tcf_ct_params_free_rcu(struct rcu_head *head)
 	tcf_ct_params_free(params);
 }
 
-#if IS_ENABLED(CONFIG_NF_NAT)
-/* Modelled after nf_nat_ipv[46]_fn().
- * range is only used for new, uninitialized NAT state.
- * Returns either NF_ACCEPT or NF_DROP.
- */
-static int ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
-			  enum ip_conntrack_info ctinfo,
-			  const struct nf_nat_range2 *range,
-			  enum nf_nat_manip_type maniptype)
-{
-	__be16 proto = skb_protocol(skb, true);
-	int hooknum, err = NF_ACCEPT;
-
-	/* See HOOK2MANIP(). */
-	if (maniptype == NF_NAT_MANIP_SRC)
-		hooknum = NF_INET_LOCAL_IN; /* Source NAT */
-	else
-		hooknum = NF_INET_LOCAL_OUT; /* Destination NAT */
-
-	switch (ctinfo) {
-	case IP_CT_RELATED:
-	case IP_CT_RELATED_REPLY:
-		if (proto == htons(ETH_P_IP) &&
-		    ip_hdr(skb)->protocol == IPPROTO_ICMP) {
-			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
-							   hooknum))
-				err = NF_DROP;
-			goto out;
-		} else if (IS_ENABLED(CONFIG_IPV6) && proto == htons(ETH_P_IPV6)) {
-			__be16 frag_off;
-			u8 nexthdr = ipv6_hdr(skb)->nexthdr;
-			int hdrlen = ipv6_skip_exthdr(skb,
-						      sizeof(struct ipv6hdr),
-						      &nexthdr, &frag_off);
-
-			if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
-				if (!nf_nat_icmpv6_reply_translation(skb, ct,
-								     ctinfo,
-								     hooknum,
-								     hdrlen))
-					err = NF_DROP;
-				goto out;
-			}
-		}
-		/* Non-ICMP, fall thru to initialize if needed. */
-		fallthrough;
-	case IP_CT_NEW:
-		/* Seen it before?  This can happen for loopback, retrans,
-		 * or local packets.
-		 */
-		if (!nf_nat_initialized(ct, maniptype)) {
-			/* Initialize according to the NAT action. */
-			err = (range && range->flags & NF_NAT_RANGE_MAP_IPS)
-				/* Action is set up to establish a new
-				 * mapping.
-				 */
-				? nf_nat_setup_info(ct, range, maniptype)
-				: nf_nat_alloc_null_binding(ct, hooknum);
-			if (err != NF_ACCEPT)
-				goto out;
-		}
-		break;
-
-	case IP_CT_ESTABLISHED:
-	case IP_CT_ESTABLISHED_REPLY:
-		break;
-
-	default:
-		err = NF_DROP;
-		goto out;
-	}
-
-	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
-out:
-	if (err == NF_ACCEPT) {
-		if (maniptype == NF_NAT_MANIP_SRC)
-			tc_skb_cb(skb)->post_ct_snat = 1;
-		if (maniptype == NF_NAT_MANIP_DST)
-			tc_skb_cb(skb)->post_ct_dnat = 1;
-	}
-	return err;
-}
-#endif /* CONFIG_NF_NAT */
-
 static void tcf_ct_act_set_mark(struct nf_conn *ct, u32 mark, u32 mask)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
@@ -986,52 +902,22 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
 			  bool commit)
 {
 #if IS_ENABLED(CONFIG_NF_NAT)
-	int err;
-	enum nf_nat_manip_type maniptype;
+	int err, action = 0;
 
 	if (!(ct_action & TCA_CT_ACT_NAT))
 		return NF_ACCEPT;
+	if (ct_action & TCA_CT_ACT_NAT_SRC)
+		action |= (1 << NF_NAT_MANIP_SRC);
+	if (ct_action & TCA_CT_ACT_NAT_DST)
+		action |= (1 << NF_NAT_MANIP_DST);
 
-	/* Add NAT extension if not confirmed yet. */
-	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
-		return NF_ACCEPT;   /* Can't NAT. */
-
-	if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
-	    (ctinfo != IP_CT_RELATED || commit)) {
-		/* NAT an established or related connection like before. */
-		if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)
-			/* This is the REPLY direction for a connection
-			 * for which NAT was applied in the forward
-			 * direction.  Do the reverse NAT.
-			 */
-			maniptype = ct->status & IPS_SRC_NAT
-				? NF_NAT_MANIP_DST : NF_NAT_MANIP_SRC;
-		else
-			maniptype = ct->status & IPS_SRC_NAT
-				? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST;
-	} else if (ct_action & TCA_CT_ACT_NAT_SRC) {
-		maniptype = NF_NAT_MANIP_SRC;
-	} else if (ct_action & TCA_CT_ACT_NAT_DST) {
-		maniptype = NF_NAT_MANIP_DST;
-	} else {
-		return NF_ACCEPT;
-	}
+	err = nf_ct_nat(skb, ct, ctinfo, &action, range, commit);
+
+	if (action & (1 << NF_NAT_MANIP_SRC))
+		tc_skb_cb(skb)->post_ct_snat = 1;
+	if (action & (1 << NF_NAT_MANIP_DST))
+		tc_skb_cb(skb)->post_ct_dnat = 1;
 
-	err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
-	if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
-		if (ct->status & IPS_SRC_NAT) {
-			if (maniptype == NF_NAT_MANIP_SRC)
-				maniptype = NF_NAT_MANIP_DST;
-			else
-				maniptype = NF_NAT_MANIP_SRC;
-
-			err = ct_nat_execute(skb, ct, ctinfo, range,
-					     maniptype);
-		} else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
-			err = ct_nat_execute(skb, ct, ctinfo, NULL,
-					     NF_NAT_MANIP_SRC);
-		}
-	}
 	return err;
 #else
 	return NF_ACCEPT;
-- 
2.31.1

