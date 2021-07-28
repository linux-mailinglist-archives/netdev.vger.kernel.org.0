Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5370D3D856D
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 03:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbhG1BdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 21:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbhG1BdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 21:33:23 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9C0C061757;
        Tue, 27 Jul 2021 18:33:22 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d9so243630qty.12;
        Tue, 27 Jul 2021 18:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hTfyYpYiEZVB4DznqNLfy54mHdJkZiYxu3icgQV/Gq0=;
        b=Up63uO+sqlsKgjh2fHZ5UkkJe0apvFz26kswUOTF5WHo/kMNt5yat8OrChh+COfCUS
         9KZjnmWDBFivmGdeZb3HSzi+fvBu5kXZpcYZWn4qQkR/43vyDllLrtBciWhZ0kbEjGHo
         EMS5knJ9tcpJzDJwni8g6ckbUAN78FcLfj78McHA2PGvEqkz0d4ew5AqnIr3lTyIVYIg
         jjxQIvdpRNjH+p1o1Z4JOrOwOwMpSWYv3cmzNbfwsCopbgmkPi4vdRVOkNjv7LN+ZA2q
         IF+J2tXEiD3RQGO7LK0ragJg+ktq26ZSrV/YiIbKJKbrsFJIuWfBiRbo75+tutGjDrdN
         Tsng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hTfyYpYiEZVB4DznqNLfy54mHdJkZiYxu3icgQV/Gq0=;
        b=rGyMlNZ+Fmn3DJnQNYP7MSMBWN/E0nftKG0lPGAMqILPjiOLXD4BRzagnwxwD53uSO
         fxGH0YIBGC3r679toGsPuuHMrrvYZz3yb4jVlhnNszZqW6mtcntvccv0YlJ8x1vgEQfU
         uTszIaGxOa7wXp2TMBucsZZh3uGdESpD/6rODLThi+unPv1Us83ZPtbE2z49ZBiW3yaZ
         oMCgf/pxf5i1LtfwTV2L+mgvB+Dn5XA7gz85Akw3QEuKs7QiEjZj+XZG69Dr9wZ1pM2U
         DRoQc/MUS7Tm6XN1D38fvF91HqKJ8tVQEZUYU+v60DMaOAG9VT5HF9HQkgrIL6UZN3j+
         N+yw==
X-Gm-Message-State: AOAM532HA0CvPcYjqEyLL4J5iNpRKH7huiAYuuzncEPFIjmGbq/0f7Mp
        SDL0d6OummINwEucQTyE3g==
X-Google-Smtp-Source: ABdhPJz8/FGTcvBHN6Y1zzCqIfUA0FIxe4QMawU16er3YWV+iPyLOrspN2xfy65MY5yttme1uqYUkQ==
X-Received: by 2002:ac8:7492:: with SMTP id v18mr35959qtq.37.1627436001478;
        Tue, 27 Jul 2021 18:33:21 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id q9sm2557178qkj.28.2021.07.27.18.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 18:33:21 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH RESEND net-next 1/2] net/sched: act_skbmod: Add SKBMOD_F_ECN option support
Date:   Tue, 27 Jul 2021 18:33:15 -0700
Message-Id: <f5bd3c60662ec0982cccd8951990796b87d1f985.1627434177.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Currently, when doing rate limiting using the tc-police(8) action, the
easiest way is to simply drop the packets which exceed or conform the
configured bandwidth limit.  Add a new option to tc-skbmod(8), so that
users may use the ECN [1] extension to explicitly inform the receiver
about the congestion instead of dropping packets "on the floor".

The 2 least significant bits of the Traffic Class field in IPv4 and IPv6
headers are used to represent different ECN states [2]:

	0b00: "Non ECN-Capable Transport", Non-ECT
	0b10: "ECN Capable Transport", ECT(0)
	0b01: "ECN Capable Transport", ECT(1)
	0b11: "Congestion Encountered", CE

As an example:

	$ tc filter add dev eth0 parent 1: protocol ip prio 10 \
		matchall action skbmod ecn

Doing the above marks all ECT(0) and ECT(1) packets as CE.  It does NOT
affect Non-ECT or non-IP packets.  In the tc-police scenario mentioned
above, users may pipe a tc-police action and a tc-skbmod "ecn" action
together to achieve ECN-based rate limiting.

For TCP connections, upon receiving a CE packet, the receiver will respond
with an ECE packet, asking the sender to reduce their congestion window.
However ECN also works with other L4 protocols e.g. DCCP and SCTP [2], and
our implementation does not touch or care about L4 headers.

The updated tc-skbmod SYNOPSIS looks like the following:

	tc ... action skbmod { set SETTABLE | swap SWAPPABLE | ecn } ...

Only one of "set", "swap" or "ecn" shall be used in a single tc-skbmod
command.  Trying to use more than one of them at a time is considered
undefined behavior; pipe multiple tc-skbmod commands together instead.
"set" and "swap" only affect Ethernet packets, while "ecn" only affects
IPv{4,6} packets.

It is also worth mentioning that, in theory, the same effect could be
achieved by piping a "police" action and a "bpf" action using the
bpf_skb_ecn_set_ce() helper, but this requires eBPF programming from the
user, thus impractical.

Depends on patch "net/sched: act_skbmod: Skip non-Ethernet packets".

[1] https://datatracker.ietf.org/doc/html/rfc3168
[2] https://en.wikipedia.org/wiki/Explicit_Congestion_Notification

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
Hi all,

These 2 patches should apply to net-next now, since "net/sched:
act_skbmod: Skip non-Ethernet packets" has been pulled into net-next.
Please review; thank you!

Peilin Ye

 include/uapi/linux/tc_act/tc_skbmod.h |  1 +
 net/sched/act_skbmod.c                | 44 +++++++++++++++++++--------
 2 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/tc_act/tc_skbmod.h b/include/uapi/linux/tc_act/tc_skbmod.h
index c525b3503797..af6ef2cfbf3d 100644
--- a/include/uapi/linux/tc_act/tc_skbmod.h
+++ b/include/uapi/linux/tc_act/tc_skbmod.h
@@ -17,6 +17,7 @@
 #define SKBMOD_F_SMAC	0x2
 #define SKBMOD_F_ETYPE	0x4
 #define SKBMOD_F_SWAPMAC 0x8
+#define SKBMOD_F_ECN	0x10
 
 struct tc_skbmod {
 	tc_gen;
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 8d17a543cc9f..762ceec3e6f6 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 #include <linux/rtnetlink.h>
+#include <net/inet_ecn.h>
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
@@ -21,15 +22,13 @@
 static unsigned int skbmod_net_id;
 static struct tc_action_ops act_skbmod_ops;
 
-#define MAX_EDIT_LEN ETH_HLEN
 static int tcf_skbmod_act(struct sk_buff *skb, const struct tc_action *a,
 			  struct tcf_result *res)
 {
 	struct tcf_skbmod *d = to_skbmod(a);
-	int action;
+	int action, max_edit_len, err;
 	struct tcf_skbmod_params *p;
 	u64 flags;
-	int err;
 
 	tcf_lastuse_update(&d->tcf_tm);
 	bstats_cpu_update(this_cpu_ptr(d->common.cpu_bstats), skb);
@@ -38,19 +37,34 @@ static int tcf_skbmod_act(struct sk_buff *skb, const struct tc_action *a,
 	if (unlikely(action == TC_ACT_SHOT))
 		goto drop;
 
-	if (!skb->dev || skb->dev->type != ARPHRD_ETHER)
-		return action;
+	max_edit_len = skb_mac_header_len(skb);
+	p = rcu_dereference_bh(d->skbmod_p);
+	flags = p->flags;
+
+	/* tcf_skbmod_init() guarantees "flags" to be one of the following:
+	 *	1. a combination of SKBMOD_F_{DMAC,SMAC,ETYPE}
+	 *	2. SKBMOD_F_SWAPMAC
+	 *	3. SKBMOD_F_ECN
+	 * SKBMOD_F_ECN only works with IP packets; all other flags only work with Ethernet
+	 * packets.
+	 */
+	if (flags == SKBMOD_F_ECN) {
+		switch (skb_protocol(skb, true)) {
+		case cpu_to_be16(ETH_P_IP):
+		case cpu_to_be16(ETH_P_IPV6):
+			max_edit_len += skb_network_header_len(skb);
+			break;
+		default:
+			goto out;
+		}
+	} else if (!skb->dev || skb->dev->type != ARPHRD_ETHER) {
+		goto out;
+	}
 
-	/* XXX: if you are going to edit more fields beyond ethernet header
-	 * (example when you add IP header replacement or vlan swap)
-	 * then MAX_EDIT_LEN needs to change appropriately
-	*/
-	err = skb_ensure_writable(skb, MAX_EDIT_LEN);
+	err = skb_ensure_writable(skb, max_edit_len);
 	if (unlikely(err)) /* best policy is to drop on the floor */
 		goto drop;
 
-	p = rcu_dereference_bh(d->skbmod_p);
-	flags = p->flags;
 	if (flags & SKBMOD_F_DMAC)
 		ether_addr_copy(eth_hdr(skb)->h_dest, p->eth_dst);
 	if (flags & SKBMOD_F_SMAC)
@@ -66,6 +80,10 @@ static int tcf_skbmod_act(struct sk_buff *skb, const struct tc_action *a,
 		ether_addr_copy(eth_hdr(skb)->h_source, (u8 *)tmpaddr);
 	}
 
+	if (flags & SKBMOD_F_ECN)
+		INET_ECN_set_ce(skb);
+
+out:
 	return action;
 
 drop:
@@ -129,6 +147,8 @@ static int tcf_skbmod_init(struct net *net, struct nlattr *nla,
 	index = parm->index;
 	if (parm->flags & SKBMOD_F_SWAPMAC)
 		lflags = SKBMOD_F_SWAPMAC;
+	if (parm->flags & SKBMOD_F_ECN)
+		lflags = SKBMOD_F_ECN;
 
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (err < 0)
-- 
2.20.1

