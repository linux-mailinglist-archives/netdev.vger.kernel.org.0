Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709401138C9
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 01:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfLEA1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 19:27:31 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43113 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbfLEA1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 19:27:31 -0500
Received: by mail-pl1-f195.google.com with SMTP id q16so434834plr.10
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 16:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=6EGq9rWlHhJFdXLEzitVVKeJkWoGiVKrAurXqrskrCk=;
        b=kft+WHKPKVIw+Owh4ftOEgIz2fWcd7FLup5TaKxGY8B0igGad6HFpROwpJZ41MMB32
         reB5Cugg9Yu2vQIZrgm6rYmRULFWxXOJBenUTxVs4vLScHdBjvAVr9Vf8vqF7nCSZ/8B
         7/mft+oGuHOF0y63d4r8QG4o8lFpoFwSUn1haF+hWOy8k5piRS6Qsv2jipxA6YCMhw1B
         FRYwdI/J02AFBNvDkcRddmmDiwPbGwJAjmSh2WxTrrDyRqY+DiKvlXdrfbLPtRvVfJ6v
         4VZA2pGG2x8tr5nO7iB9zB2/UcAXllQtSN1ebRKHfGKrMScOfKgJBNz8X3BOtS2eo6Us
         y9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=6EGq9rWlHhJFdXLEzitVVKeJkWoGiVKrAurXqrskrCk=;
        b=j2jPe2O+0fcPNRDZm+48W9YynE2NFZvd7fHMU4WTjZg8TmbJqgSeDOFuqke6bCPpkn
         a1vSl4FrLKZAm049wKZytJ3yETokjyITgHv1Sod+T56+Yh9iC599YLPL/nUoyRLN4xt3
         mRZ2I1+wYQSdGz79xlk7YdP9mnkixsZ4aubJOTb8/3E5e/tz3Alp8H7QXUKaG+1wQg4F
         BEKb9l/ynDdvJBwvjbFez15Lyt9rEuTpZ+v58wewk4WKi2u0NosBQrkZrjBQgWxtLP5p
         v+q3V6bdIj09EXm2Rgs9WVLiYtATqWr+DVCGJK6gvdNt2/V2r+Tob+PfbH6vj/qGGe4t
         hiQA==
X-Gm-Message-State: APjAAAVOvzf9UnERiaITMGIniqx930nLzuVE6RJ0ldcBYYTg7qMzcS0E
        SFSwFpmaxb6mQTdxnbFfz+ImUYIM
X-Google-Smtp-Source: APXvYqxhN3ijA1y54rPIqR3s9wgPy3Cj1weTSog82keddPxFgNLypdjr3CTeyQXg8NZWf9rR/NUXmw==
X-Received: by 2002:a17:902:ba8e:: with SMTP id k14mr2610709pls.335.1575505650203;
        Wed, 04 Dec 2019 16:27:30 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id u9sm8846130pfm.102.2019.12.04.16.27.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 04 Dec 2019 16:27:29 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        martin.varghese@nokia.com
Subject: [PATCH net v2] net: Fixed updating of ethertype in skb_mpls_push()
Date:   Thu,  5 Dec 2019 05:57:22 +0530
Message-Id: <1575505642-5626-1-git-send-email-martinvarghesenokia@gmail.com>
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
Changes in v2:
    Changed the subject line of patch.

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

