Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3721107E12
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 11:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfKWKfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 05:35:13 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:41978 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfKWKfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 05:35:12 -0500
Received: by mail-pj1-f65.google.com with SMTP id gc1so4293515pjb.8
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 02:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=6EDl2iVObj5IHFgEim26P9Eh48X6Q6TXcx9H/6a6sLI=;
        b=qe6u1gs4UqgpfMEDp+1uQVoRKmkAOq0n69yHTbpiyqkR8VEKAsCLEJ6TYoU1Lgzu98
         lEu75QaMeDYU4x1NtTVCt4ZUv6qmHgoPZDu6aUQi5ispKrrNBpDry459B9hLJPFyt3h9
         vENDWIF9fhzQyUtRRrZiFLhbCLAEImo5OGDD44//RV7WJX0yo2SpjJpX8R3Gkw52SaR9
         54qxafnMnzB9jMyksOQuce3PVcHhSUwq89M4MS57hQxRlx48BIBCMS3NSCybhpKe8jZ7
         axJTBzY5UEvfyfsAjk6TDNeuf/noiO32OVUu9pErBala+a02IRuU/q4FaESzoDdw68aA
         +ykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=6EDl2iVObj5IHFgEim26P9Eh48X6Q6TXcx9H/6a6sLI=;
        b=crXsL3H3qJEHw0Wa6S6E8O5ZvEyG52LA6y03tbP+NjeIdmLRpyc/IQrpEM91omEgO/
         8BjVy7Em46ffvlzQsLKEeuJgpenINauDTM78+uodE6mNhxDCG1irATSr5O6R7g9ryCHY
         gtCWts0ibpLW1auTRksnTFBH4sdpMLeZivMM1+HL4MjWXBVj0riKHR7UHG3TCC5URyxF
         oyse80O/vzv3xm8/DbbxDhXFBcXRl5ikJ6mxKO3CfnYMehkm/bSK+tbs4OKKdxn9rB+z
         KUHqseFt5/VullS57dbXli9vA62UeS65vwNt7HVLT37pQi6tGJYA1C63V9hLB3TSrWU3
         XMKw==
X-Gm-Message-State: APjAAAVXYMXYYL2z5+A7A4aYzFzH15oie+BHv3/6suopRUMr7VWqKXC1
        80XqBzmXa4gImJmbvNgqQ1Ihr7UR
X-Google-Smtp-Source: APXvYqwTI85EqxJpg1FvwUoRffelGDP3zroX8mQD3Q8vsh8LbkXvjbnvjKBA7M3k4psOj85kw3N3vQ==
X-Received: by 2002:a17:902:fe12:: with SMTP id g18mr8414757plj.20.1574505311556;
        Sat, 23 Nov 2019 02:35:11 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id p123sm1174390pfg.30.2019.11.23.02.35.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 23 Nov 2019 02:35:11 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        martin.varghese@nokia.com
Subject: [PATCH v2 net-next] Enhanced skb_mpls_pop to update ethertype of the packet in all the cases when an ethernet header is present is the packet.
Date:   Sat, 23 Nov 2019 16:04:59 +0530
Message-Id: <1574505299-23909-1-git-send-email-martinvarghesenokia@gmail.com>
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

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
Changes in v2:
    - check for dev type removed while updating ethertype
      in function skb_mpls_pop.
    - key->mac_proto is checked in function pop_mpls to pass
      ethernt flag to skb_mpls_pop.
    - dev type is checked in function tcf_mpls_act to pass
      ethernet flag to skb_mpls_pop.

 include/linux/skbuff.h    | 3 ++-
 net/core/skbuff.c         | 7 ++++---
 net/openvswitch/actions.c | 4 +++-
 net/sched/act_mpls.c      | 4 +++-
 4 files changed, 12 insertions(+), 6 deletions(-)

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
index 867e61d..988eefb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5529,12 +5529,13 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
  * @skb: buffer
  * @next_proto: ethertype of header after popped MPLS header
  * @mac_len: length of the MAC header
- *
+ * @ethernet: flag to indicate if ethernet header is present in packet
  * Expects skb->data at mac header.
  *
  * Returns 0 on success, -errno otherwise.
  */
-int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
+int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
+		 bool ethernet)
 {
 	int err;
 
@@ -5553,7 +5554,7 @@ int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, mac_len);
 
-	if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
+	if (ethernet) {
 		struct ethhdr *hdr;
 
 		/* use mpls_hdr() to get ethertype to account for VLANs. */
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 12936c1..264c3c0 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -179,7 +179,9 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 {
 	int err;
 
-	err = skb_mpls_pop(skb, ethertype, skb->mac_len);
+	err = skb_mpls_pop(skb, ethertype, skb->mac_len,
+			   (key->mac_proto & ~SW_FLOW_KEY_INVALID)
+			    == MAC_PROTO_ETHERNET);
 	if (err)
 		return err;
 
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 4d8c822..f919f95 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -13,6 +13,7 @@
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_mpls.h>
+#include <linux/if_arp.h>
 
 static unsigned int mpls_net_id;
 static struct tc_action_ops act_mpls_ops;
@@ -76,7 +77,8 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
 
 	switch (p->tcfm_action) {
 	case TCA_MPLS_ACT_POP:
-		if (skb_mpls_pop(skb, p->tcfm_proto, mac_len))
+		if (skb_mpls_pop(skb, p->tcfm_proto, mac_len,
+				 (skb->dev && skb->dev->type == ARPHRD_ETHER)))
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_PUSH:
-- 
1.8.3.1

