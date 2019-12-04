Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4B7112ED6
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 16:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfLDPoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 10:44:09 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38957 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728230AbfLDPoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 10:44:07 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so39294pfx.6
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 07:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=jUZWUL7pslZB3vmqcQ4lBzsC2xFiC+Nbq0yg0LFW440=;
        b=syfzt65nf8ZBjQAsW+ohkwGzSgqbySrX4jG5aSaTcJRlvqX3AyimGFbAIdR8p5/tuQ
         p971M4mzK98gOUs11gO36Q/DTXNOq7WH/7rS83Q+7I4M29+z0QhzB9uJL9J6E6se8lol
         3WyzKF6T2xsJVyREF4ZNnJukD64ammZnYkpuqtlCY885jTqYMtOZSmnqtODSh6V1gW7y
         sY2/8rUI06bdkWwfxD6UP+L2k2BpcNUUNeaUjE5AIFJVGdQ+cWn0as2PM6o4m1XmlTd5
         rZSKBAZZStEEVVWC2np5tDFzE3zRoUY1RM7hofx7dcvjSyOmGSOwz/RVo5M953Mlthwe
         BGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=jUZWUL7pslZB3vmqcQ4lBzsC2xFiC+Nbq0yg0LFW440=;
        b=PU8YnR4auAxXp4GRnu7citZcrG2Q3+V2wbt0rWpmykM/5UHkf2a2/9izBbugizTAwS
         EQ3w0oZEgcGYTIbXxTKkq+ySg703sqxMGinFBKmDWuoCmXTFRq8rYAdLCUppv0i4a6nF
         0RKQFZATij3wSZYCPWA80pRTIaLk7C7V8BbgY1WOCGA//24T052PTG+GnAeAFRcDcukI
         4VVDZ3j86d/AhuiuEH7fpwhZ9qLRHCd5tOaxQI1vjGqpZbTZjJmKubxVbV8CDLxKzYFB
         7G5Zle/OWACf006st2z1pvhQfZsxposp/GFoeo3Vom7FVzL4So5YX1MuuxIRIqldSayG
         xzdA==
X-Gm-Message-State: APjAAAWqfkyHPiGFZRDM8+obNoGZM6zmtptFRwerj0nk2ZQN1iezt1Zq
        kriNZ9zTrLAVasFTnhfhBhEtTaJ8
X-Google-Smtp-Source: APXvYqz0bF1OnXceyBieiCjTkp15zGJEQ58hRXirikeuvSf33A2XPhrVyTq4ZujAa7Yefpix3w7Gaw==
X-Received: by 2002:a63:d543:: with SMTP id v3mr2350301pgi.285.1575474246721;
        Wed, 04 Dec 2019 07:44:06 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id 2sm7968749pgo.79.2019.12.04.07.44.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 04 Dec 2019 07:44:06 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        martin.varghese@nokia.com
Subject: [PATCH net] Fixed updating of ethertype in function skb_mpls_push
Date:   Wed,  4 Dec 2019 21:13:59 +0530
Message-Id: <1575474239-4721-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

The skb_mpls_push was not updating ethertype of an ethernet packet if
the packet was originally received from a non ARPHRD_ETHER device.

In the below OVS data path flow, since the device corresponding to
port 7 is an l3 device (ARPHRD_NONE) the skb_mpls_push function does
not update the ethertype of the packet even though the previous
push_eth action had added an ethernet header to the packet.

recirc_id(0),in_port(7),eth_type(0x0800),ipv4(tos=0/0xfc,ttl=64,frag=no),
actions:push_eth(src=00:00:00:00:00:00,dst=00:00:00:00:00:00),
push_mpls(label=13,tc=0,ttl=64,bos=1,eth_type=0x8847),4

Fixes: 8822e270d697 ("net: core: move push MPLS functionality from OvS to core helper")
Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 include/linux/skbuff.h    | 2 +-
 net/core/skbuff.c         | 4 ++--
 net/openvswitch/actions.c | 3 ++-
 net/sched/act_mpls.c      | 3 ++-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 70204b9..6d81b99 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3529,7 +3529,7 @@ int skb_zerocopy(struct sk_buff *to, struct sk_buff *from,
 int skb_vlan_pop(struct sk_buff *skb);
 int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
 int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
-		  int mac_len);
+		  int mac_len, bool ethernet);
 int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
 		 bool ethernet);
 int skb_mpls_update_lse(struct sk_buff *skb, __be32 mpls_lse);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 312e80e..973a71f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5484,7 +5484,7 @@ static void skb_mod_eth_type(struct sk_buff *skb, struct ethhdr *hdr,
  * Returns 0 on success, -errno otherwise.
  */
 int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
-		  int mac_len)
+		  int mac_len, bool ethernet)
 {
 	struct mpls_shim_hdr *lse;
 	int err;
@@ -5515,7 +5515,7 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
 	lse->label_stack_entry = mpls_lse;
 	skb_postpush_rcsum(skb, lse, MPLS_HLEN);
 
-	if (skb->dev && skb->dev->type == ARPHRD_ETHER)
+	if (ethernet)
 		skb_mod_eth_type(skb, eth_hdr(skb), mpls_proto);
 	skb->protocol = mpls_proto;
 
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 91e2100..4c83954 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -166,7 +166,8 @@ static int push_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 	int err;
 
 	err = skb_mpls_push(skb, mpls->mpls_lse, mpls->mpls_ethertype,
-			    skb->mac_len);
+			    skb->mac_len,
+			    ovs_key_mac_proto(key) == MAC_PROTO_ETHERNET);
 	if (err)
 		return err;
 
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 47e0cfd..2552226 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -83,7 +83,8 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
 		break;
 	case TCA_MPLS_ACT_PUSH:
 		new_lse = tcf_mpls_get_lse(NULL, p, !eth_p_mpls(skb->protocol));
-		if (skb_mpls_push(skb, new_lse, p->tcfm_proto, mac_len))
+		if (skb_mpls_push(skb, new_lse, p->tcfm_proto, mac_len,
+				  skb->dev && skb->dev->type == ARPHRD_ETHER))
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_MODIFY:
-- 
1.8.3.1

