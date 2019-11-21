Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4990510523A
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 13:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKUMXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 07:23:24 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45402 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfKUMXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 07:23:24 -0500
Received: by mail-pf1-f194.google.com with SMTP id z4so1583545pfn.12
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 04:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=4lQjfr3tkzYcIAniemVyUkfAYvQyBYvY988WhIgzj9g=;
        b=fwjqoXkXCeKlLmbCN1BUUzC0lYoWfW+uDR/iDOeEPsS2B1oHEUTJO71pmUmAXOuSQ2
         ehvbs1x6x9vKsOqqugagXhQu/Z5YFHO9iQIACkYNB/m3Opn4fK/DoNUBpmXfFxRoNJo2
         t5JjWJWvorAja1LATpYATukjVLwtevHUPyinZqG9ou3wVwia/YF84pNIWpGF5gMTHsUj
         A41sK50FqPS2iiHFBipwAC0RaAD+YmpUUOyzH61L82GZJkmDv34bgtdClfKheP5nr0D/
         Slx8GT3ACsuzNxuXCqt3CPd3mVIxfooSkGFINvgWO2OLa8V0bRc5PTs28qHgKRHKms5O
         n2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=4lQjfr3tkzYcIAniemVyUkfAYvQyBYvY988WhIgzj9g=;
        b=i6eh9etJFsIV6RjWYXOvgpaZVxxFDZpvbxuJlTGupk85XHVlKTR51f1YHprrUEdo8X
         tf0t4Bxg7Thtssoz4ug1suR5yQWlp9scj5qb3qLurswtso9KJ/BhtggxCyoVHOPblTuc
         XyGGfK/qOAOKokIx+aVliWxzz3PwGW/TKPJ7k9vbRo5lYQIV0+pEiz+0UnIPkgeM7bBK
         Guxgk1HYUczWvFzBpbRt7SA2xOVNfoT8fb7VkQnqQpQRj7Kw+L99DipHXFdU/6n5nwXG
         nQrH2qQKRqfxiR2oP/jEwVOwuPUukFcTIPcMDzbGC1ig+j9/38UN2PVsMQJIBimuxGV2
         VY/Q==
X-Gm-Message-State: APjAAAWnncLsT0huEcnJEtdZ6HBplMZxT4NhWNFICtiR9EBGqvjanys5
        djuSQr5/9XJZDnLPCQ3HX39Vmboh
X-Google-Smtp-Source: APXvYqzHf8J42FKujMuXjmjBodhEfRF10XQP1gWmPy2mvu3uXMLrXEDPrWVh7Yn4XHpb80UlNr80eQ==
X-Received: by 2002:a62:830a:: with SMTP id h10mr10809348pfe.6.1574339003457;
        Thu, 21 Nov 2019 04:23:23 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([171.61.89.87])
        by smtp.gmail.com with ESMTPSA id v26sm3484394pfm.126.2019.11.21.04.23.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 21 Nov 2019 04:23:22 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        martin.varghese@nokia.com
Subject: [PATCH net-next] Enhanced skb_mpls_pop to update ethertype of the packet in all the cases when an ethernet header is present is the packet.
Date:   Thu, 21 Nov 2019 17:53:15 +0530
Message-Id: <1574338995-14657-1-git-send-email-martinvarghesenokia@gmail.com>
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
 include/linux/skbuff.h    | 3 ++-
 net/core/skbuff.c         | 8 +++++---
 net/openvswitch/actions.c | 2 +-
 net/sched/act_mpls.c      | 2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)

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
index 867e61d..8ac377d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5529,12 +5529,14 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
  * @skb: buffer
  * @next_proto: ethertype of header after popped MPLS header
  * @mac_len: length of the MAC header
- *
+ * @ethernet: flag to indicate if ethernet header is present in packet
+ *	      ignored for device type ARPHRD_ETHER
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
+	if ((skb->dev && skb->dev->type == ARPHRD_ETHER) || ethernet) {
 		struct ethhdr *hdr;
 
 		/* use mpls_hdr() to get ethertype to account for VLANs. */
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 12936c1..9e5d274 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -179,7 +179,7 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
 {
 	int err;
 
-	err = skb_mpls_pop(skb, ethertype, skb->mac_len);
+	err = skb_mpls_pop(skb, ethertype, skb->mac_len, true);
 	if (err)
 		return err;
 
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 4d8c822..5fa39fc 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -76,7 +76,7 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
 
 	switch (p->tcfm_action) {
 	case TCA_MPLS_ACT_POP:
-		if (skb_mpls_pop(skb, p->tcfm_proto, mac_len))
+		if (skb_mpls_pop(skb, p->tcfm_proto, mac_len, false))
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_PUSH:
-- 
1.8.3.1

