Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5103D1A54
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 01:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhGUWf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 18:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhGUWf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 18:35:27 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53859C061575;
        Wed, 21 Jul 2021 16:16:02 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id n10so3713670qke.12;
        Wed, 21 Jul 2021 16:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8kBHltz3fpi5tJOBHoxxMlZNZl2yFO4paDm36raK100=;
        b=J1AIz/EIQ87onxU71lAQ7/9TBEUOW4aEBpScIqH9TibBu7A3/rNhvMuU0nX5lxUfG/
         4k9TzQC12UEOFGm6p3SZsZenae9URnES5GwGWmeRK1PxIN+e8KFg4v02R7IjPcoO4/YI
         2ec9XH1NQ9cTG4OajtQdjUeFTAQZWiFXzdyUdGVr2NvaGA9wCjyEO/YEsrIbn8DSuFId
         QY2Wb9IhMWES4ItmWy5dvq2wxN4rfd6Ona7fKOkoM168yui8N2Ntr0F4EpfbEzRbz6YV
         V4vVyj4DV/22pH/dy+2pUcSRVN5Rh+vxl5yLNi32hdmFmqEsGJjIJCajb+5h8mqvLPjq
         OIvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8kBHltz3fpi5tJOBHoxxMlZNZl2yFO4paDm36raK100=;
        b=B76QvmrcjxCrq+Y7hMLTS6mXG+Qzesu/thwhn/6KDyk9AEyMKEDjn5VPMQdUTfaaYT
         s4Kxb3cj8pfRR4UNnPFK1ocGzOK1dldgFM4x0wz5IIf0AU6t19L8idgV0HgPT+L/SpYh
         KRDdAuzQDGBryKvuEMJuiOB9Z1Idaw+xZ5YQpgKHqHpWY6THqBgsInkBWxSGHKOLi/x7
         RtHgSWYwjMlqSTzPWWXRdSRzK06/C9xE2X26f+MsIMS+N7FpQoiBe3JIM9qzBTNpje5R
         lrp5HM6Aid/vQycX8mFUkFa0DK370VDr3a1fjiLFP3267v3bOvXmWrbs0fupo0ZyvJqJ
         nZMw==
X-Gm-Message-State: AOAM533q3330x2fq+dMC0R0MfICX9/WtG4vS5f+H89SxjqR7vWTpUwTw
        92ODKJRB/ffuBzJlnGL5ig==
X-Google-Smtp-Source: ABdhPJzzBmHQ+Sn4JRrVsfAq41FRZTA8DxFCmeNHoYQkN1hG2JZMNdjGgz7EKW3m6mYTRjjYw1AsbA==
X-Received: by 2002:a37:a154:: with SMTP id k81mr38215797qke.202.1626909360600;
        Wed, 21 Jul 2021 16:16:00 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id k14sm9875038qtm.18.2021.07.21.16.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 16:16:00 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next 1/2] net/sched: act_skbmod: Add SKBMOD_F_ECN option support
Date:   Wed, 21 Jul 2021 16:15:47 -0700
Message-Id: <f5c5a81d6674a8f4838684ac52ed66da83f92499.1626899889.git.peilin.ye@bytedance.com>
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

This patch depends on the following commit, which is in net, but not in
net-next yet:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=727d6a8b7ef3d25080fad228b2c4a1d4da5999c6

Thanks,
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

