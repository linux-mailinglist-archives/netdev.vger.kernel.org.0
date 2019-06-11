Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 585533C0A0
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 02:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbfFKAcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 20:32:04 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45476 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728645AbfFKAcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 20:32:04 -0400
Received: by mail-ot1-f67.google.com with SMTP id n2so10023426otl.12
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 17:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=o3DK0nkWpRpMiwc8Ih5d4ou6a8n/VYA8Lld2bDfDIo8=;
        b=SyWXCkz8+bgQGMvoosoPUj0DOLFOc+jImidLs+UQ697u7L/0hCiuhwZXAUdLPZn3iD
         3kzIxQwmkr/2i8iz2KlIFg9ryEIhR8EHebgN25FV/qf42+Sxs/mmoCBzFxw32hKMQSth
         bud8phsvyHBg1qGmO68is4TB2VFWqCLYyYT9X6/cEMJg1yS3WoQr90OjVCcuXofHfPBI
         ltKFPiphWhBVtfu0xTxRF5XXBNsgeggn5sZ4YSGOq1hIAb80DO1mnkBA+Gx5XsZ2E/hU
         rBirb0ru0YuuFXNl997zZENmRMQy2rCEtkebKbQL175xgK7mt9VjEl1VoSjKPdrrsx7e
         kEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=o3DK0nkWpRpMiwc8Ih5d4ou6a8n/VYA8Lld2bDfDIo8=;
        b=Z27oBtptJ5ptYrq01n3V3sXMabyg9I78qt1z6Pk+V1MSPD/PeN8Jq1Gkir9kmKD5ZR
         9azpgfcjaoiOIM9sBxE59FswXSRpbkqJfk5uOcYFbm8kyLYJwvIKKm9CkSXoaVrLJT49
         Ja2HQ4GiaR05Op0VzvUBpgg9upvcO/+ur5sB0gFXadfjr8O2HgYdfYdZpvRbtkNS4wF2
         sjvNLhoO4YfW2uG9KIeCBMhsbwv1gdMvXC0SEmyTHa24Ltt4vl0HSpsouWJP7n6ftLYV
         CGrYWLq5lXUa2zjuVubwvMRKsvYmYKHcD6enuFq3BLQhir0up6KxMfRubZoW2p7wNDRl
         qhwg==
X-Gm-Message-State: APjAAAVFNB/vyzjUcKz4Jie8hRfUN250iTKY9ZeAiZzCWpTP553B6ts4
        dI+caNZi7G5SxqBnRrbY+GYBx2c=
X-Google-Smtp-Source: APXvYqwAaZIpFcT/Fr48rlFI3ER6u2+Q8FeT8KyNUu+g5m+jqlRCGs+C/WaBodGDEefRBcU3bsla6w==
X-Received: by 2002:a9d:7d90:: with SMTP id j16mr3065144otn.95.1560213122870;
        Mon, 10 Jun 2019 17:32:02 -0700 (PDT)
Received: from localhost.localdomain (99-149-127-125.lightspeed.rlghnc.sbcglobal.net. [99.149.127.125])
        by smtp.gmail.com with ESMTPSA id l12sm836427otp.74.2019.06.10.17.32.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 17:32:02 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net-next] ipv4: Support multipath hashing on inner IP pkts for GRE tunnel
Date:   Mon, 10 Jun 2019 20:31:42 -0400
Message-Id: <20190611003142.11626-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multipath hash policy value of 0 isn't distributing since the outer IP
dest and src aren't varied eventhough the inner ones are. Since the flow
is on the inner ones in the case of tunneled traffic, hashing on them is
desired.

This currently only supports IP over GRE and CONFIG_NET_GRE_DEMUX must
be compiled as built-in in the kernel.

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 Documentation/networking/ip-sysctl.txt |  4 ++
 net/ipv4/route.c                       | 75 ++++++++++++++++++++++----
 net/ipv4/sysctl_net_ipv4.c             |  2 +-
 3 files changed, 70 insertions(+), 11 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 5eedc6941ce5..4f1e18713ea4 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -80,6 +80,10 @@ fib_multipath_hash_policy - INTEGER
 	Possible values:
 	0 - Layer 3
 	1 - Layer 4
+	2 - Inner Layer 3 for tunneled IP packets. Only IP tunneled by GRE is
+	    supported now. Others are treated as if the control is set to 0,
+	    i.e. the outer L3 is used. GRE support is only valid when the kernel
+	    was compiled with CONFIG_NET_GRE_DEMUX.
 
 fib_sync_mem - UNSIGNED INTEGER
 	Amount of dirty memory from fib entries that can be backlogged before
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 14c7fdacaa72..92c693ee8d4b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -112,6 +112,7 @@
 #include <net/secure_seq.h>
 #include <net/ip_tunnels.h>
 #include <net/l3mdev.h>
+#include <net/gre.h>
 
 #include "fib_lookup.h"
 
@@ -1782,23 +1783,29 @@ static int __mkroute_input(struct sk_buff *skb,
  * calculated from the inner IP addresses.
  */
 static void ip_multipath_l3_keys(const struct sk_buff *skb,
-				 struct flow_keys *hash_keys)
+				 struct flow_keys *hash_keys,
+				 const struct iphdr *outer_iph,
+				 int offset)
 {
-	const struct iphdr *outer_iph = ip_hdr(skb);
-	const struct iphdr *key_iph = outer_iph;
 	const struct iphdr *inner_iph;
+	const struct iphdr *key_iph;
 	const struct icmphdr *icmph;
 	struct iphdr _inner_iph;
 	struct icmphdr _icmph;
 
+	if (!outer_iph)
+		outer_iph = ip_hdr(skb);
+
+	key_iph = ip_hdr(skb);
+
 	if (likely(outer_iph->protocol != IPPROTO_ICMP))
 		goto out;
 
 	if (unlikely((outer_iph->frag_off & htons(IP_OFFSET)) != 0))
 		goto out;
 
-	icmph = skb_header_pointer(skb, outer_iph->ihl * 4, sizeof(_icmph),
-				   &_icmph);
+	icmph = skb_header_pointer(skb, offset + outer_iph->ihl * 4,
+				   sizeof(_icmph), &_icmph);
 	if (!icmph)
 		goto out;
 
@@ -1820,6 +1827,47 @@ static void ip_multipath_l3_keys(const struct sk_buff *skb,
 	hash_keys->addrs.v4addrs.dst = key_iph->daddr;
 }
 
+static void ip_multipath_inner_l3_keys(const struct sk_buff *skb,
+				       struct flow_keys *hash_keys)
+{
+	const struct iphdr *outer_iph = ip_hdr(skb);
+	const struct iphdr *inner_iph;
+	struct iphdr _inner_iph;
+	int hdr_len;
+
+	switch (outer_iph->protocol) {
+#ifdef CONFIG_NET_GRE_DEMUX
+	case IPPROTO_GRE:
+		{
+			struct tnl_ptk_info tpi;
+			bool csum_err = false;
+
+			hdr_len = gre_parse_header(skb, &tpi, &csum_err,
+						   htons(ETH_P_IP),
+						   outer_iph->ihl * 4);
+			if (hdr_len > 0 && tpi.proto == htons(ETH_P_IP))
+				break;
+		}
+		/* fallthrough */
+#endif
+	default:
+		/* Hash on outer for unknown tunnels, non IP tunneled, or non-
+		 * tunneled pkts
+		 */
+		ip_multipath_l3_keys(skb, hash_keys, outer_iph, 0);
+		return;
+	}
+	inner_iph = skb_header_pointer(skb,
+				       outer_iph->ihl * 4 + hdr_len,
+				       sizeof(struct iphdr), &_inner_iph);
+	if (inner_iph) {
+		ip_multipath_l3_keys(skb, hash_keys, inner_iph, hdr_len);
+	} else {
+		/* Use outer */
+		ip_multipath_l3_keys(skb, hash_keys, outer_iph, 0);
+	}
+}
+
 /* if skb is set it will be used and fl4 can be NULL */
 int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 		       const struct sk_buff *skb, struct flow_keys *flkeys)
@@ -1828,12 +1876,13 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 	struct flow_keys hash_keys;
 	u32 mhash;
 
+	memset(&hash_keys, 0, sizeof(hash_keys));
+
 	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
 	case 0:
-		memset(&hash_keys, 0, sizeof(hash_keys));
 		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 		if (skb) {
-			ip_multipath_l3_keys(skb, &hash_keys);
+			ip_multipath_l3_keys(skb, &hash_keys, NULL, 0);
 		} else {
 			hash_keys.addrs.v4addrs.src = fl4->saddr;
 			hash_keys.addrs.v4addrs.dst = fl4->daddr;
@@ -1849,8 +1898,6 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 			if (skb->l4_hash)
 				return skb_get_hash_raw(skb) >> 1;
 
-			memset(&hash_keys, 0, sizeof(hash_keys));
-
 			if (!flkeys) {
 				skb_flow_dissect_flow_keys(skb, &keys, flag);
 				flkeys = &keys;
@@ -1863,7 +1910,6 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 			hash_keys.ports.dst = flkeys->ports.dst;
 			hash_keys.basic.ip_proto = flkeys->basic.ip_proto;
 		} else {
-			memset(&hash_keys, 0, sizeof(hash_keys));
 			hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 			hash_keys.addrs.v4addrs.src = fl4->saddr;
 			hash_keys.addrs.v4addrs.dst = fl4->daddr;
@@ -1872,6 +1918,15 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 			hash_keys.basic.ip_proto = fl4->flowi4_proto;
 		}
 		break;
+	case 2:
+		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+		if (skb) {
+			ip_multipath_inner_l3_keys(skb, &hash_keys);
+		} else {
+			hash_keys.addrs.v4addrs.src = fl4->saddr;
+			hash_keys.addrs.v4addrs.dst = fl4->daddr;
+		}
+		break;
 	}
 	mhash = flow_hash_from_keys(&hash_keys);
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 2316c08e9591..e1efc2e62d21 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -960,7 +960,7 @@ static struct ctl_table ipv4_net_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_fib_multipath_hash_policy,
 		.extra1		= &zero,
-		.extra2		= &one,
+		.extra2		= &two,
 	},
 #endif
 	{
-- 
2.17.1

