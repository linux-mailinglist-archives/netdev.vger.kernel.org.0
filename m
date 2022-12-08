Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88D66474C0
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiLHQ4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiLHQ43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:56:29 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78C17682E
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:56:23 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id pp21so536665qvb.5
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 08:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHi7IZKcG1tRLi+oJLjPRcApijWMbgsfUQaLj1nJZ6k=;
        b=O3kStVFR3zmsbnls9UXb5m7lheCuA7gweJuZytOufXMWTwIF/7jvmUwcj9EmfsgOL4
         Bmn2jJffTB8DkWfIpBWkHwNqWfU+tIhGnUDEgzNlGHY7WA7oxN2FhTI4GkvWBjgmt4SQ
         qv4D9AhSfpUeoWagn5UV3vYtCEopFesPDpFXAHu+JZGRRzEyr3twV2fVm6kJXGzSgvqe
         xYWl99QDLs4GIq8Rpp9RoKsUwLlL38QfMPKtkdOd8eegMD7UtA/Ec7DPT2EhCAc+Q3QA
         rEslcbeieh9gnOXdN1c3umTXu9kzri8kvNp5qYL9Jfq/J4xvT1iqrE7QlmX58bYdKFP+
         PMrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cHi7IZKcG1tRLi+oJLjPRcApijWMbgsfUQaLj1nJZ6k=;
        b=VuEDzmGHm8GDs6jCmzykVUDZP05H8s40Kld5RL1zym0mHzKjSFV9PaPmzoM1aC3KVl
         Ymv1aHs8SV/q/hNNA7TYNm83MJbRdlQjFspElOFFiCZz5Eb1dVo4wDTngGaaWOnr4ORj
         TDa0nA0qjQ/hrSROntfu79vLojSLJBnA3lS7Tqs294/x06pOOzevwKo0C8BFRcbvnXbn
         cECBOYYNWI7ytRv0Z83sBFlLFF3jBarcI1Gpp3sHI9rUY5WY1jUyfMXb+Ho9fVV5tTlQ
         ZCT5yA18i3rN3m2W55yQyIm2fPAES9A1S/aDukBCUXcQQznLM0PkzsiSD95rouna+zT0
         Ipng==
X-Gm-Message-State: ANoB5pmiec+XtMkiOb2pK2nymE6AzAaE8yll/Ju/NnH+mJVywLATXY6S
        /0Xx7uI8ClFo4xD9s0/Vpraiwsei5UEo5g==
X-Google-Smtp-Source: AA0mqf5jwivLyfBFg/HG05jQgR4EKtpaqcMoG8aVtTZK3aWhAzVAR6NUU0sZ3f5lXdaLGki82b6LFg==
X-Received: by 2002:a05:6214:e6c:b0:4c7:7257:68a2 with SMTP id jz12-20020a0562140e6c00b004c7725768a2mr5255596qvb.15.1670518582331;
        Thu, 08 Dec 2022 08:56:22 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j13-20020a05620a288d00b006fbbdc6c68fsm20091298qkp.68.2022.12.08.08.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 08:56:21 -0800 (PST)
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
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCHv4 net-next 5/5] net: move the nat function to nf_nat_ovs for ovs and tc
Date:   Thu,  8 Dec 2022 11:56:12 -0500
Message-Id: <c973910b2d9741153cca02c14c6c105942d7f44a.1670518439.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1670518439.git.lucien.xin@gmail.com>
References: <cover.1670518439.git.lucien.xin@gmail.com>
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

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netfilter/nf_nat.h |   4 +
 net/netfilter/Kconfig          |   3 +
 net/netfilter/Makefile         |   1 +
 net/netfilter/nf_nat_ovs.c     | 135 ++++++++++++++++++++++++++++++++
 net/openvswitch/Kconfig        |   1 +
 net/openvswitch/conntrack.c    | 137 +++------------------------------
 net/sched/Kconfig              |   1 +
 net/sched/act_ct.c             | 136 +++-----------------------------
 8 files changed, 166 insertions(+), 252 deletions(-)
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
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 0846bd75b1da..f71b41c7ce2f 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -459,6 +459,9 @@ config NF_NAT_REDIRECT
 config NF_NAT_MASQUERADE
 	bool
 
+config NF_NAT_OVS
+	bool
+
 config NETFILTER_SYNPROXY
 	tristate
 
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 1d4db1943936..3754eb06fb41 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_NF_LOG_SYSLOG) += nf_log_syslog.o
 obj-$(CONFIG_NF_NAT) += nf_nat.o
 nf_nat-$(CONFIG_NF_NAT_REDIRECT) += nf_nat_redirect.o
 nf_nat-$(CONFIG_NF_NAT_MASQUERADE) += nf_nat_masquerade.o
+nf_nat-$(CONFIG_NF_NAT_OVS) += nf_nat_ovs.o
 
 ifeq ($(CONFIG_NF_NAT),m)
 nf_nat-$(CONFIG_DEBUG_INFO_BTF_MODULES) += nf_nat_bpf.o
diff --git a/net/netfilter/nf_nat_ovs.c b/net/netfilter/nf_nat_ovs.c
new file mode 100644
index 000000000000..551abd2da614
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
+		*action |= BIT(maniptype);
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
+		return NF_DROP;   /* Can't NAT. */
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
+	} else if (ct_action & BIT(NF_NAT_MANIP_SRC)) {
+		maniptype = NF_NAT_MANIP_SRC;
+	} else if (ct_action & BIT(NF_NAT_MANIP_DST)) {
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
diff --git a/net/openvswitch/Kconfig b/net/openvswitch/Kconfig
index 15bd287f5cbd..747d537a3f06 100644
--- a/net/openvswitch/Kconfig
+++ b/net/openvswitch/Kconfig
@@ -15,6 +15,7 @@ config OPENVSWITCH
 	select NET_MPLS_GSO
 	select DST_CACHE
 	select NET_NSH
+	select NF_NAT_OVS if NF_NAT
 	help
 	  Open vSwitch is a multilayer Ethernet switch targeted at virtualized
 	  environments.  In addition to supporting a variety of features
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 58c9f0edc3c4..c8b137649ca4 100644
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
+		action |= BIT(NF_NAT_MANIP_SRC);
+	if (info->nat & OVS_CT_DST_NAT)
+		action |= BIT(NF_NAT_MANIP_DST);
 
-	/* Add NAT extension if not confirmed yet. */
-	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
-		return NF_DROP;   /* Can't NAT. */
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
+	if (action & BIT(NF_NAT_MANIP_SRC))
+		ovs_nat_update_key(key, skb, NF_NAT_MANIP_SRC);
+	if (action & BIT(NF_NAT_MANIP_DST))
+		ovs_nat_update_key(key, skb, NF_NAT_MANIP_DST);
 
 	return err;
 }
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 4662a6ce8a7e..777d6b50505c 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -977,6 +977,7 @@ config NET_ACT_TUNNEL_KEY
 config NET_ACT_CT
 	tristate "connection tracking tc action"
 	depends on NET_CLS_ACT && NF_CONNTRACK && (!NF_NAT || NF_NAT) && NF_FLOW_TABLE
+	select NF_NAT_OVS if NF_NAT
 	help
 	  Say Y here to allow sending the packets to conntrack module.
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index bb87d1e910ea..ccad9c5ba4f0 100644
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
+		action |= BIT(NF_NAT_MANIP_SRC);
+	if (ct_action & TCA_CT_ACT_NAT_DST)
+		action |= BIT(NF_NAT_MANIP_DST);
 
-	/* Add NAT extension if not confirmed yet. */
-	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
-		return NF_DROP;   /* Can't NAT. */
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
+	if (action & BIT(NF_NAT_MANIP_SRC))
+		tc_skb_cb(skb)->post_ct_snat = 1;
+	if (action & BIT(NF_NAT_MANIP_DST))
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

