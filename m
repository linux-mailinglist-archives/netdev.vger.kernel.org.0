Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81FCF3BC610
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 07:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhGFF3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 01:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhGFF3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 01:29:05 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50019C061574;
        Mon,  5 Jul 2021 22:26:27 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id h4so20327745pgp.5;
        Mon, 05 Jul 2021 22:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xfO51/nD2+ITtsnp+vQNB9FEHew0E/ztrIof/G6Ncxw=;
        b=h16MSOimomDbQwwFKKd9Z+vODx1k7dxDo3MxmS0c8hyjuTUtOGRhqPBg7iBNh7YiyF
         ZTjiaXiJgHzsNbvyHsUDNu6JbO8bsf3BNlX3qRnrncAM+Tr/IdaCHOcBJu/hv9w9CMSR
         SlwXCO9SQeNveJW2NaLL4SY9+2bfb9Sqx2sGXq/xhQc7MxerZ6XvaHl40JwIwS7eA0V5
         oXwTfbv1G/r1okAVRWrhO7Ux7/yMB09BDEdKDTawQzYDFb7qG7QFj95fHT1sjESM/8tC
         oExTIgnaCYoPjm79+mKOjZ6ZzWtoGq8yffC51gYvw02C8U9yMbX+HVlGuqs6c45g9Iu9
         OIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xfO51/nD2+ITtsnp+vQNB9FEHew0E/ztrIof/G6Ncxw=;
        b=DgVRJm/GnfWY8/FcOjSs1y7cc1j+nSiIZjGyFvxGfe2W/B+GqOHvIfJkmubIgxv/MS
         2qEcHdIDz546PFVqXYyNAoLeSFxhYjqlchckoryqAtIOB+rCRS0UX66BTHcJFider7B3
         AEpkkhBC/pUfB72u5Je76spKh/rYLZdORhCbGppVVOgKFMoxmX0ATO09NCmWvDfaP7C1
         mB03Wizf3m6I6hLLL2LY/a6OILA/hi5u78bqXTHquy2T9eMHLrmi+0AAjVlQZ7mjXTVM
         IBgTtvP6Nc4LVsTeBYs5iWQjPcBzjt6hjZKlO+YhDKXdUPD/QQ+p8SPsVoDK89owMQQd
         XZ+w==
X-Gm-Message-State: AOAM531kweyRdAgvN3jOjRKMpRnl6HWuFXIYysXKyatWBd2alNys2RUj
        CoKLTN7xHA/ySvICj7CyhqWhM6qjxo7SXgXZ
X-Google-Smtp-Source: ABdhPJxAi1hXh3HMU0Ievt01rStkgs8BHrDfo0ECgnC0oBLPTalCFqwNQJplzk1ypBSYBqrOu/1D2g==
X-Received: by 2002:a63:ff22:: with SMTP id k34mr19103706pgi.336.1625549185426;
        Mon, 05 Jul 2021 22:26:25 -0700 (PDT)
Received: from localhost.localdomain (softbank060108183144.bbtec.net. [60.108.183.144])
        by smtp.gmail.com with ESMTPSA id co12sm1236466pjb.33.2021.07.05.22.26.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Jul 2021 22:26:25 -0700 (PDT)
From:   Ryoga Saito <proelbtn@gmail.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        Ryoga Saito <proelbtn@gmail.com>
Subject: [PATCH] net: Add netfilter hooks to track SRv6-encapsulated flows
Date:   Tue,  6 Jul 2021 14:25:48 +0900
Message-Id: <20210706052548.5440-1-proelbtn@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tunneling protocols such as VXLAN or IPIP are implemented using virtual
network devices (vxlan0 or ipip0). Therefore, conntrack can record both
inner flows and outer flows correctly. In contrast, SRv6 is implemented
using lightweight tunnel infrastructure. Therefore, SRv6 packets are
encapsulated and decapsulated without passing through virtual network
device. Due to the following problems caused by this, conntrack can't
record both inner flows and outer flows correctly.

First problem is caused when SRv6 packets are encapsulated. In VXLAN, at
first, packets received are passed to nf_conntrack_in called from
ip_rcv/ipv6_rcv. These packets are sent to virtual network device and these
flows are confirmed in ip_output/ip6_output. However, in SRv6, at first,
packets are passed to nf_conntrack_in, encapsulated and flows are confirmed
in ipv6_output even if inner packets are IPv4. Therefore, IPv6 conntrack
needs to be enabled to track IPv4 inner flow.

Second problem is caused when SRv6 packets are decapsulated. If IPv6
conntrack is enabled, SRv6 packets are passed to nf_conntrack_in called
from ipv6_rcv. Even if inner packets are passed to nf_conntrack_in after
packets are decapsulated, flow aren't tracked because skb->_nfct is already
set. Therefore, IPv6 conntrack needs to be disabled to track IPv4 flow
when packets are decapsulated.

This patch solves these problems and allows conntrack to record inner flows
correctly. It introduces netfilter hooks to srv6 lwtunnel and srv6local
lwtunnel. Before decapsulation/encapsulation, packets are hooked with
POST_ROUTING chain and after decapsulation/encapsulation, packets are
hooked with LOCAL_OUT chain.

Signed-off-by: Ryoga Saito <proelbtn@gmail.com>
---
 net/ipv6/seg6_iptunnel.c |  54 ++++++++++++++++++++----
 net/ipv6/seg6_local.c    | 104 ++++++++++++++++++++++++++++++-----------------
 2 files changed, 113 insertions(+), 45 deletions(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 897fa59..ce638da 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -26,6 +26,7 @@
 #ifdef CONFIG_IPV6_SEG6_HMAC
 #include <net/seg6_hmac.h>
 #endif
+#include <net/netfilter/nf_conntrack.h>

 static size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
 {
@@ -295,15 +296,23 @@ static int seg6_do_srh(struct sk_buff *skb)

 	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
+	nf_reset_ct(skb);

 	return 0;
 }

-static int seg6_input(struct sk_buff *skb)
+static int seg6_input_finish(struct net *net, struct sock *sk,
+			     struct sk_buff *skb)
+{
+	return dst_input(skb);
+}
+
+static int seg6_input_core(struct net *net, struct sock *sk,
+			   struct sk_buff *skb)
 {
 	struct dst_entry *orig_dst = skb_dst(skb);
 	struct dst_entry *dst = NULL;
-	struct seg6_lwt *slwt;
+	struct seg6_lwt *slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
 	int err;

 	err = seg6_do_srh(skb);
@@ -312,8 +321,6 @@ static int seg6_input(struct sk_buff *skb)
 		return err;
 	}

-	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
-
 	preempt_disable();
 	dst = dst_cache_get(&slwt->cache);
 	preempt_enable();
@@ -337,10 +344,27 @@ static int seg6_input(struct sk_buff *skb)
 	if (unlikely(err))
 		return err;

-	return dst_input(skb);
+	return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, dev_net(skb->dev), NULL,
+		       skb, NULL, skb_dst(skb)->dev, seg6_input_finish);
 }

-static int seg6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
+static int seg6_input(struct sk_buff *skb)
+{
+	int proto;
+
+	if (skb->protocol == htons(ETH_P_IPV6))
+		proto = NFPROTO_IPV6;
+	else if (skb->protocol == htons(ETH_P_IP))
+		proto = NFPROTO_IPV4;
+	else
+		return -EINVAL;
+
+	return NF_HOOK(proto, NF_INET_POST_ROUTING, dev_net(skb->dev), NULL,
+		       skb, NULL, skb_dst(skb)->dev, seg6_input_core);
+}
+
+static int seg6_output_core(struct net *net, struct sock *sk,
+			    struct sk_buff *skb)
 {
 	struct dst_entry *orig_dst = skb_dst(skb);
 	struct dst_entry *dst = NULL;
@@ -387,12 +411,28 @@ static int seg6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	if (unlikely(err))
 		goto drop;

-	return dst_output(net, sk, skb);
+	return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net, sk, skb, NULL,
+		       skb_dst(skb)->dev, dst_output);
 drop:
 	kfree_skb(skb);
 	return err;
 }

+static int seg6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
+{
+	int proto;
+
+	if (skb->protocol == htons(ETH_P_IPV6))
+		proto = NFPROTO_IPV6;
+	else if (skb->protocol == htons(ETH_P_IP))
+		proto = NFPROTO_IPV4;
+	else
+		return -EINVAL;
+
+	return NF_HOOK(proto, NF_INET_POST_ROUTING, net, sk, skb, NULL,
+		       skb_dst(skb)->dev, seg6_output_core);
+}
+
 static int seg6_build_state(struct net *net, struct nlattr *nla,
 			    unsigned int family, const void *cfg,
 			    struct lwtunnel_state **ts,
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 60bf3b8..dd29acc 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -30,6 +30,7 @@
 #include <net/seg6_local.h>
 #include <linux/etherdevice.h>
 #include <linux/bpf.h>
+#include <net/netfilter/nf_conntrack.h>

 #define SEG6_F_ATTR(i)		BIT(i)

@@ -413,12 +414,31 @@ static int input_action_end_dx2(struct sk_buff *skb,
 	return -EINVAL;
 }

+static int input_action_end_dx6_finish(struct net *net, struct sock *sk,
+				       struct sk_buff *skb)
+{
+	struct dst_entry *orig_dst = skb_dst(skb);
+	struct seg6_local_lwt *slwt = seg6_local_lwtunnel(orig_dst->lwtstate);
+	struct in6_addr *nhaddr = NULL;
+
+	/* The inner packet is not associated to any local interface,
+	 * so we do not call netif_rx().
+	 *
+	 * If slwt->nh6 is set to ::, then lookup the nexthop for the
+	 * inner packet's DA. Otherwise, use the specified nexthop.
+	 */
+	if (!ipv6_addr_any(&slwt->nh6))
+		nhaddr = &slwt->nh6;
+
+	seg6_lookup_nexthop(skb, nhaddr, 0);
+
+	return dst_input(skb);
+}
+
 /* decapsulate and forward to specified nexthop */
 static int input_action_end_dx6(struct sk_buff *skb,
 				struct seg6_local_lwt *slwt)
 {
-	struct in6_addr *nhaddr = NULL;
-
 	/* this function accepts IPv6 encapsulated packets, with either
 	 * an SRH with SL=0, or no SRH.
 	 */
@@ -429,33 +449,43 @@ static int input_action_end_dx6(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 		goto drop;

-	/* The inner packet is not associated to any local interface,
-	 * so we do not call netif_rx().
-	 *
-	 * If slwt->nh6 is set to ::, then lookup the nexthop for the
-	 * inner packet's DA. Otherwise, use the specified nexthop.
-	 */
-
-	if (!ipv6_addr_any(&slwt->nh6))
-		nhaddr = &slwt->nh6;
-
 	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
+	nf_reset_ct(skb);

-	seg6_lookup_nexthop(skb, nhaddr, 0);
-
-	return dst_input(skb);
+	return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, dev_net(skb->dev), NULL,
+		       skb, NULL, skb_dst(skb)->dev,
+		       input_action_end_dx6_finish);
 drop:
 	kfree_skb(skb);
 	return -EINVAL;
 }

-static int input_action_end_dx4(struct sk_buff *skb,
-				struct seg6_local_lwt *slwt)
+static int input_action_end_dx4_finish(struct net *net, struct sock *sk,
+				       struct sk_buff *skb)
 {
+	struct dst_entry *orig_dst = skb_dst(skb);
+	struct seg6_local_lwt *slwt = seg6_local_lwtunnel(orig_dst->lwtstate);
 	struct iphdr *iph;
 	__be32 nhaddr;
 	int err;

+	iph = ip_hdr(skb);
+	nhaddr = slwt->nh4.s_addr ?: iph->daddr;
+
+	skb_dst_drop(skb);
+
+	err = ip_route_input(skb, nhaddr, iph->saddr, 0, skb->dev);
+	if (err) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	return dst_input(skb);
+}
+
+static int input_action_end_dx4(struct sk_buff *skb,
+				struct seg6_local_lwt *slwt)
+{
 	if (!decap_and_validate(skb, IPPROTO_IPIP))
 		goto drop;

@@ -463,20 +493,12 @@ static int input_action_end_dx4(struct sk_buff *skb,
 		goto drop;

 	skb->protocol = htons(ETH_P_IP);
-
-	iph = ip_hdr(skb);
-
-	nhaddr = slwt->nh4.s_addr ?: iph->daddr;
-
-	skb_dst_drop(skb);
-
 	skb_set_transport_header(skb, sizeof(struct iphdr));
+	nf_reset_ct(skb);

-	err = ip_route_input(skb, nhaddr, iph->saddr, 0, skb->dev);
-	if (err)
-		goto drop;
-
-	return dst_input(skb);
+	return NF_HOOK(NFPROTO_IPV4, NF_INET_LOCAL_OUT, dev_net(skb->dev), NULL,
+		       skb, NULL, skb_dst(skb)->dev,
+		       input_action_end_dx4_finish);

 drop:
 	kfree_skb(skb);
@@ -645,6 +667,7 @@ static struct sk_buff *end_dt_vrf_core(struct sk_buff *skb,
 	skb_dst_drop(skb);

 	skb_set_transport_header(skb, hdrlen);
+	nf_reset_ct(skb);

 	return end_dt_vrf_rcv(skb, family, vrf);

@@ -1078,22 +1101,16 @@ static void seg6_local_update_counters(struct seg6_local_lwt *slwt,
 	u64_stats_update_end(&pcounters->syncp);
 }

-static int seg6_local_input(struct sk_buff *skb)
+static int seg6_local_input_core(struct net *net, struct sock *sk,
+				 struct sk_buff *skb)
 {
 	struct dst_entry *orig_dst = skb_dst(skb);
+	struct seg6_local_lwt *slwt = seg6_local_lwtunnel(orig_dst->lwtstate);
 	struct seg6_action_desc *desc;
-	struct seg6_local_lwt *slwt;
 	unsigned int len = skb->len;
 	int rc;

-	if (skb->protocol != htons(ETH_P_IPV6)) {
-		kfree_skb(skb);
-		return -EINVAL;
-	}
-
-	slwt = seg6_local_lwtunnel(orig_dst->lwtstate);
 	desc = slwt->desc;
-
 	rc = desc->input(skb, slwt);

 	if (!seg6_lwtunnel_counters_enabled(slwt))
@@ -1104,6 +1121,17 @@ static int seg6_local_input(struct sk_buff *skb)
 	return rc;
 }

+static int seg6_local_input(struct sk_buff *skb)
+{
+	if (skb->protocol != htons(ETH_P_IPV6)) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_IN, dev_net(skb->dev), NULL,
+		       skb, skb->dev, NULL, seg6_local_input_core);
+}
+
 static const struct nla_policy seg6_local_policy[SEG6_LOCAL_MAX + 1] = {
 	[SEG6_LOCAL_ACTION]	= { .type = NLA_U32 },
 	[SEG6_LOCAL_SRH]	= { .type = NLA_BINARY },
--
1.8.3.1

