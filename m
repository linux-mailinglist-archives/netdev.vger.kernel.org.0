Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0503D6E24C
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 10:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfGSIMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 04:12:15 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33276 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfGSIMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 04:12:14 -0400
Received: by mail-lj1-f196.google.com with SMTP id h10so29963294ljg.0;
        Fri, 19 Jul 2019 01:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mEBaSqitjE462bEAjNFGz8xwcHRYHwLdCUJSC13I1HM=;
        b=o9c2gcWbMFWrT8wxt9D7NX5RkGevgroq610iUkNIWnwd4Hir6W8hdOKMafk+dMiB8i
         wduJuz1UzdZwsj6lSJqrY+s9p24rNsaYoTsd4RvkHunwWHkCt3Suc7YfQX1pcTbXR4Lt
         RBv7EGJjS1Il/mnUCMZOSzXEmjwZFalhPDPFOKRAzY1rSVDdYwJT/cExtwnIV31vow6B
         d6F+JDYylpCZhvxoGL94MRceKyNO+jVyGTiNRg7zcGAnQ3iTchHh+xePtYQBN3qgO7Pq
         dQvREvPbSP0QkH7wl+pbmpNcUSAan+7AF0vr1gIMZeIXoRzXvwNZeVe97qe4bGweLOpH
         f6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mEBaSqitjE462bEAjNFGz8xwcHRYHwLdCUJSC13I1HM=;
        b=hRzjtWuHd8PcC/+r6re3iRNqlUUnvrUU+uGp/3lvYMqXBxhD3SHIBrsrCcea07H/ZA
         Z920OUAkHv6YrSIe/7qqZqMNrYdJqd0gdNMIoS7e/Y4yG6RcLMkw2UQwjSIM8oH0Gg49
         wRUSj3aobZepKpNeeORTYQMxKUn6zK+DNQ7CUl/sefp2J3Qli22JE//x5Ny0yQfCRq/D
         /HFXShcXLjM92rT3gMozuQ9WLtPo+hFSoWnujPgVNvvivWiPaq9Aj7RIPU2IpjTCK3vt
         w1px69Yk2Q+aJD3JfMI7y29MFsycBeSw8Un1cOXARuMIeQibTXi2jNkBVAKIZ410RkJl
         Jhyw==
X-Gm-Message-State: APjAAAUTFycm052D1eTDFnLimc+sPbaIHZqaY/xQRyeKeK0+4qzI4l+6
        hkoI+xUUn9gEESvvgS58dSg=
X-Google-Smtp-Source: APXvYqxZcTgCvF2Fp5q2IDGGyyhyLMRArBwBWQonSV/wGWV1db0uJaSKGV2f8utlhSbuEkjkKaeYLw==
X-Received: by 2002:a2e:2411:: with SMTP id k17mr27314205ljk.136.1563523932846;
        Fri, 19 Jul 2019 01:12:12 -0700 (PDT)
Received: from peter.cuba.int. ([83.220.32.68])
        by smtp.googlemail.com with ESMTPSA id a70sm5476692ljf.57.2019.07.19.01.12.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 01:12:12 -0700 (PDT)
From:   Peter Kosyh <p.kosyh@gmail.com>
To:     David Ahern <dsa@cumulusnetworks.com>
Cc:     davem@davemloft.net, Peter Kosyh <p.kosyh@gmail.com>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] vrf: make sure skb->data contains ip header to make routing
Date:   Fri, 19 Jul 2019 11:11:47 +0300
Message-Id: <20190719081148.11512-1-p.kosyh@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <213bada2-fe81-3c14-1506-11abf0f3ca22@cumulusnetworks.com>
References: <213bada2-fe81-3c14-1506-11abf0f3ca22@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vrf_process_v4_outbound() and vrf_process_v6_outbound() do routing
using ip/ipv6 addresses, but don't make sure the header is available
in skb->data[] (skb_headlen() is less then header size).

Case:

1) igb driver from intel.
2) Packet size is greater then 255.
3) MPLS forwards to VRF device.

So, patch adds pskb_may_pull() calls in vrf_process_v4/v6_outbound()
functions.

Signed-off-by: Peter Kosyh <p.kosyh@gmail.com>
---
 drivers/net/vrf.c | 58 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 54edf8956a25..6e84328bdd40 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -165,23 +165,29 @@ static int vrf_ip6_local_out(struct net *net, struct sock *sk,
 static netdev_tx_t vrf_process_v6_outbound(struct sk_buff *skb,
 					   struct net_device *dev)
 {
-	const struct ipv6hdr *iph = ipv6_hdr(skb);
+	const struct ipv6hdr *iph;
 	struct net *net = dev_net(skb->dev);
-	struct flowi6 fl6 = {
-		/* needed to match OIF rule */
-		.flowi6_oif = dev->ifindex,
-		.flowi6_iif = LOOPBACK_IFINDEX,
-		.daddr = iph->daddr,
-		.saddr = iph->saddr,
-		.flowlabel = ip6_flowinfo(iph),
-		.flowi6_mark = skb->mark,
-		.flowi6_proto = iph->nexthdr,
-		.flowi6_flags = FLOWI_FLAG_SKIP_NH_OIF,
-	};
+	struct flowi6 fl6;
 	int ret = NET_XMIT_DROP;
 	struct dst_entry *dst;
 	struct dst_entry *dst_null = &net->ipv6.ip6_null_entry->dst;
 
+	if (!pskb_may_pull(skb, ETH_HLEN + sizeof(struct ipv6hdr)))
+		goto err;
+
+	iph = ipv6_hdr(skb);
+
+	memset(&fl6, 0, sizeof(fl6));
+	/* needed to match OIF rule */
+	fl6.flowi6_oif = dev->ifindex;
+	fl6.flowi6_iif = LOOPBACK_IFINDEX;
+	fl6.daddr = iph->daddr;
+	fl6.saddr = iph->saddr;
+	fl6.flowlabel = ip6_flowinfo(iph);
+	fl6.flowi6_mark = skb->mark;
+	fl6.flowi6_proto = iph->nexthdr;
+	fl6.flowi6_flags = FLOWI_FLAG_SKIP_NH_OIF;
+
 	dst = ip6_route_output(net, NULL, &fl6);
 	if (dst == dst_null)
 		goto err;
@@ -237,21 +243,27 @@ static int vrf_ip_local_out(struct net *net, struct sock *sk,
 static netdev_tx_t vrf_process_v4_outbound(struct sk_buff *skb,
 					   struct net_device *vrf_dev)
 {
-	struct iphdr *ip4h = ip_hdr(skb);
+	struct iphdr *ip4h;
 	int ret = NET_XMIT_DROP;
-	struct flowi4 fl4 = {
-		/* needed to match OIF rule */
-		.flowi4_oif = vrf_dev->ifindex,
-		.flowi4_iif = LOOPBACK_IFINDEX,
-		.flowi4_tos = RT_TOS(ip4h->tos),
-		.flowi4_flags = FLOWI_FLAG_ANYSRC | FLOWI_FLAG_SKIP_NH_OIF,
-		.flowi4_proto = ip4h->protocol,
-		.daddr = ip4h->daddr,
-		.saddr = ip4h->saddr,
-	};
+	struct flowi4 fl4;
 	struct net *net = dev_net(vrf_dev);
 	struct rtable *rt;
 
+	if (!pskb_may_pull(skb, ETH_HLEN + sizeof(struct iphdr)))
+		goto err;
+
+	ip4h = ip_hdr(skb);
+
+	memset(&fl4, 0, sizeof(fl4));
+	/* needed to match OIF rule */
+	fl4.flowi4_oif = vrf_dev->ifindex;
+	fl4.flowi4_iif = LOOPBACK_IFINDEX;
+	fl4.flowi4_tos = RT_TOS(ip4h->tos);
+	fl4.flowi4_flags = FLOWI_FLAG_ANYSRC | FLOWI_FLAG_SKIP_NH_OIF;
+	fl4.flowi4_proto = ip4h->protocol;
+	fl4.daddr = ip4h->daddr;
+	fl4.saddr = ip4h->saddr;
+
 	rt = ip_route_output_flow(net, &fl4, NULL);
 	if (IS_ERR(rt))
 		goto err;
-- 
2.11.0

