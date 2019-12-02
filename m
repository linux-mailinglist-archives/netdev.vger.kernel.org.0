Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC2710E542
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 06:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbfLBFUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 00:20:06 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36152 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbfLBFUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 00:20:06 -0500
Received: by mail-pg1-f196.google.com with SMTP id k13so17780012pgh.3
        for <netdev@vger.kernel.org>; Sun, 01 Dec 2019 21:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=65zZM5jAx2UyOpGPpufi+bpk8NMcLIMTkuf/67nlcg4=;
        b=iVDqjapOrsElMuDQy87yNqIPMNu9ikbPx/ge3oAu1lVv1caNjZ/C7wFFsFdmHNG51f
         UC7C6bQ0UJy6Xo7Xfo7dbK8Iqa9EugfWP6bZt1I+xi9PorzwQpb/s42xuQN7HKB70sCZ
         0+X9q2QF0zQ4LOJ2zVOi/BZip/P7wjSluTYo9gkNZZjre/DU1V5P750thY2O8QgtuiRz
         UWVIXO7W+1z/L6aF6zbaCfIEZbsdR7AUzaQ+PovLfBi98ut5ACv8bxQIQS9CdNfa7Htg
         lUWHyzf003RlaYUWHIAEjgici0azzVMeZyIoJairt4IvgA66ercKlkA5zeRtARsabOU+
         Mfpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=65zZM5jAx2UyOpGPpufi+bpk8NMcLIMTkuf/67nlcg4=;
        b=Dz7jtLOz2Iqx0PgDA1RfDQfRO8iYDVMzXUebRblxxygd7rPIxk0tCArvbvgu1294IY
         TzB8WlNZh2YEqnPP8gtNJuPhtKx/I1Fna886MQu7Gng1NnrPvWpsGfHgPtAAERTuzLhm
         3xbcgeN3SMuxMDaAS9H2LKpfZVHl0Nu7SLpIxew9p9WKz0bwShKkMF+jGfHmLsIkKquZ
         O/4/AkOfWDHYJwj3Z2ESb5qdVzECpbQDFppL77iwezmwLmavnnrGMiFYkEFI6Xd+jL3+
         S5s6DrF9lxTJLqYhrdd1ZYcjWmElnXIN2CoYkes2yB2xM3N9YK9sRKorNmM+0imZC8dL
         PwuA==
X-Gm-Message-State: APjAAAXeSiEVb3aetLQfeUpznauByrhqPbUWUkqqJDuPvuhxHBRNT/cp
        sJ0+ZaJ0Dm2vRrnebbttZLIp1Jd2
X-Google-Smtp-Source: APXvYqzF4+Um2wHEw3C+mTnuxlyKHULeOmhYUbeZrbt/h94dTi1QkWV1RyR6FcF2mVykFcBGY7azWg==
X-Received: by 2002:a63:cf4f:: with SMTP id b15mr29688524pgj.216.1575264005562;
        Sun, 01 Dec 2019 21:20:05 -0800 (PST)
Received: from localhost.localdomain ([42.109.137.125])
        by smtp.gmail.com with ESMTPSA id f8sm2548351pjg.28.2019.12.01.21.20.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 01 Dec 2019 21:20:04 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        martin.varghese@nokia.com
Subject: [PATCH v3 net] Fixed updating of ethertype in function skb_mpls_pop
Date:   Mon,  2 Dec 2019 10:49:51 +0530
Message-Id: <1575263991-5915-1-git-send-email-martinvarghesenokia@gmail.com>
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

