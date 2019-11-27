Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7940110AD1C
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 11:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfK0KBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 05:01:36 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33869 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfK0KBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 05:01:36 -0500
Received: by mail-pf1-f196.google.com with SMTP id n13so10748917pff.1
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 02:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=65zZM5jAx2UyOpGPpufi+bpk8NMcLIMTkuf/67nlcg4=;
        b=ciLfthaBaN6mZW5+EWBE5L1gQZ4rWYNyIiNay9YpGZbA57rMSRqP/dv1JUYn3Hlzo+
         EF7PHISgJguU8uMw+93OBa4DsolkMO7uqrum0mcKeYgmVsiIxMJ6xvxXRIWeEXaY8cyW
         1kzNRrfLPaNsnKHbwVOexLlLUSGhLwSWu6RLGOhmhqF+JUsoDZnRRYbwNSZqkyg6dwIU
         XAhwch5edhy1Oh2CqH6uZvrII9WpbhZPpls4E1oznHEIQJMUjm7v+xCiiJegn+/Nc89e
         ydNlCTJ0Tyb+J2fq+c6vcmKTn28S6UlLRCaUp5+1/a24dTvKnu6z37i/dwSulTwwwjyu
         k1xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=65zZM5jAx2UyOpGPpufi+bpk8NMcLIMTkuf/67nlcg4=;
        b=l9p9PKW4EsBiyZubfUfgZm7R2sdGPWOi3biB3SsddA8/ONk6uCsCdoU3Dy9i+V5osz
         +6WHNSMYJVYTSmjHErT/MbdlPPVbuIiWEDUx0L13QFd9hWpMF47h5kGHBSJHhBwLkPvP
         xbYpazkgpUvONwXFp092JOk20OZed63l7J60V2rHV4paQ05SP988izrpbkf264Nf/ksc
         G6DGpOzktj3moGoTsW9atCToWNIZ4TlyBQ6+EM2s+OjnmAYzJjVn5Souxzf2ue8PSNSO
         fTOI3pthXxzuxx4j4psxUt4q3c9Mq0d4RDdkpqn3HnUMpgrC92G/UlolBavzZbnPO+T+
         7jAw==
X-Gm-Message-State: APjAAAWBJoi0MJ3se6p0u0/78j67FidgEXMkpWYhudbEKXX+T123WV3t
        KDMywh+EVayZNKiC8PEGmhxgwW2K
X-Google-Smtp-Source: APXvYqyU3TWUVt9fONBI88qq7tmGiAnGooVFaQjlreUWN/lIShLz9kDQbA4zo7+/7cWdWO/ZBw1JQw==
X-Received: by 2002:a63:ce12:: with SMTP id y18mr3808778pgf.186.1574848894674;
        Wed, 27 Nov 2019 02:01:34 -0800 (PST)
Received: from localhost.localdomain ([42.109.138.77])
        by smtp.gmail.com with ESMTPSA id x70sm16347659pfd.132.2019.11.27.02.01.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 27 Nov 2019 02:01:34 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        martin.varghese@nokia.com
Subject: [PATCH v3 net-next] Enhanced skb_mpls_pop to update ethertype of the packet in all the cases when an ethernet header is present is the packet.
Date:   Wed, 27 Nov 2019 15:31:17 +0530
Message-Id: <1574848877-7531-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

The skb_mpls_pop was not updating ethertype of an ethernet packet if the
packet was originally received from a non ARPHRD_ETHER device.

In the below OVS data path flow, since the device corresponding to port 7
is an l3 device (ARPHRD_NONE) the skb_mpls_pop function does not update
the ethertype of the packet even though the previous push_eth action had
added an ethernet header to the packet.

recirc_id(0),in_port(7),eth_type(0x8847),
mpls(label=12/0xfffff,tc=0/0,ttl=0/0x0,bos=1/1),
actions:push_eth(src=00:00:00:00:00:00,dst=00:00:00:00:00:00),
pop_mpls(eth_type=0x800),4

Fixes: ed246cee09b9 ("net: core: move pop MPLS functionality from OvS to core helper")
Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
Changes in v2:
    - In function skb_mpls_pop check for dev type removed
      while updating ethertype.
    - key->mac_proto is checked in function pop_mpls to pass
      ethernet flag to skb_mpls_pop.
    - dev type is checked in function tcf_mpls_act to pass
      ethernet flag to skb_mpls_pop.

Changes in v3:
    - Fixed header inclusion order.
    - Removed unwanted braces.
    - Retain space between function argements and description in the
      coments of function skb_mpls_pop.      
    - used ovs_key_mac_proto(key) to check if the packet is ethernet.
    - Added fixes tag.

 include/linux/skbuff.h    | 3 ++-
 net/core/skbuff.c         | 6 ++++--
 net/openvswitch/actions.c | 3 ++-
 net/sched/act_mpls.c      | 4 +++-
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dfe02b6..70204b9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3530,7 +3530,8 @@ int skb_zerocopy(struct sk_buff *to, struct sk_buff *from,
 int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
 int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
 		  int mac_len);
-int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len);
+int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
+		 bool ethernet);
 int skb_mpls_update_lse(struct sk_buff *skb, __be32 mpls_lse);
 int skb_mpls_dec_ttl(struct sk_buff *skb);
 struct sk_buff *pskb_extract(struct sk_buff *skb, int off, int to_copy,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 867e61d..312e80e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5529,12 +5529,14 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
  * @skb: buffer
  * @next_proto: ethertype of header after popped MPLS header
  * @mac_len: length of the MAC header
+ * @ethernet: flag to indicate if ethernet header is present in packet
  *
  * Expects skb->data at mac header.
  *
  * Returns 0 on success, -errno otherwise.
  */
-int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
+int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
+		 bool ethernet)
 {
 	int err;
 
@@ -5553,7 +5555,7 @@ int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, mac_len);
 
-	if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
+	if (ethernet) {
 		struct ethhdr *hdr;
 
 		/* use mpls_hdr() to get ethertype to account for VLANs. */
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 12936c1..91e2100 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -179,7 +179,8 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 {
 	int err;
 
-	err = skb_mpls_pop(skb, ethertype, skb->mac_len);
+	err = skb_mpls_pop(skb, ethertype, skb->mac_len,
+			   ovs_key_mac_proto(key) == MAC_PROTO_ETHERNET);
 	if (err)
 		return err;
 
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 4d8c822..47e0cfd 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /* Copyright (C) 2019 Netronome Systems, Inc. */
 
+#include <linux/if_arp.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -76,7 +77,8 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
 
 	switch (p->tcfm_action) {
 	case TCA_MPLS_ACT_POP:
-		if (skb_mpls_pop(skb, p->tcfm_proto, mac_len))
+		if (skb_mpls_pop(skb, p->tcfm_proto, mac_len,
+				 skb->dev && skb->dev->type == ARPHRD_ETHER))
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_PUSH:
-- 
1.8.3.1

