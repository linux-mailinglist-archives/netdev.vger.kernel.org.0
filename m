Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2051227203
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 00:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgGTWLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 18:11:33 -0400
Received: from mail.efficios.com ([167.114.26.124]:51434 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgGTWLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 18:11:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 0AFAF2C60A1;
        Mon, 20 Jul 2020 18:11:32 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 18kgqfBodCl8; Mon, 20 Jul 2020 18:11:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id AA2F22C60A0;
        Mon, 20 Jul 2020 18:11:31 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com AA2F22C60A0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1595283091;
        bh=x9SPUXpAbtPNDcHzU+K7hYakdwJYCbQI4mHkrDBdnpA=;
        h=From:To:Date:Message-Id;
        b=GSLyC+KHIsM+sPPDLk3bQduPjvu4yh9wC9epWAfpWEuwQ3NUvN4FQBsTU4WJIR35G
         kiLNpHIDBq2mEhjH3AiKI3AYa/aB9/sOgUcNPlgIKyk7SEnssUhGOacFXq2X/7JgVA
         lWOfw7AnayVrUce3JHAOvGvAFxDzZ1FwH4wHjN/xQvPjdP/KiRwHtPsHk9r9nzxOvP
         DOA+MEBsvhRgWot1hfdsHeXXiKl+IlRQl6Hk0u7a1ffm/AmBVLsto8eT4Q9QIMNzkt
         g9D2Z0jh3XsG3bwLpxzzyW4IhhlpPAG5+c1XDpPeivRPZH4Ip8CIlgqQ0+Jky/cOlo
         I4QcFgHUkJC9Q==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8evlVgIjHs-Y; Mon, 20 Jul 2020 18:11:31 -0400 (EDT)
Received: from thinkos.etherlink (unknown [192.222.236.144])
        by mail.efficios.com (Postfix) with ESMTPSA id 7C9602C609F;
        Mon, 20 Jul 2020 18:11:31 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     netdev@vger.kernel.org
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Ahern <dsa@cumulusnetworks.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [RFC PATCH] Fix: ipv4/icmp: icmp error route lookup performed on wrong routing table
Date:   Mon, 20 Jul 2020 18:11:18 -0400
Message-Id: <20200720221118.26148-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per RFC792, ICMP errors should be sent to the source host.

However, in configurations with Virtual Forwarding and Routing tables,
looking up which routing table to use is currently done by using the
destination net_device.

commit 9d1a6c4ea43e ("net: icmp_route_lookup should use rt dev to
determine L3 domain") changes the interfaces passed to
l3mdev_master_ifindex() and inet_addr_type_dev_table() from skb_in->dev
to skb_dst(skb_in)->dev in order to fix a NULL pointer dereference. This
changes the interface used for routing table lookup from source to
destination. Therefore, if the source and destination interfaces are
within separate VFR, or one in the global routing table and the other in
a VFR, looking up the source host in the destination interface's routing
table is likely to fail.

One observable effect of this issue is that traceroute does not work in
the following cases:

- Route leaking between global routing table and VRF
- Route leaking between VRFs

[ Note 1: I'm not entirely sure what routing table should be used when
  param->replyopts.opt.opt.srr is set ? Is it valid to honor Strict
  Source Route when sending an ICMP error ? ]

[ Note 2: I notice that ipv6 icmp6_send() uses skb_dst(skb)->dev as
  argument to l3mdev_master_ifindex(). I'm not sure if it is correct ? ]

[ This patch is only compile-tested. ]

Fixes: 9d1a6c4ea43e ("net: icmp_route_lookup should use rt dev to determine L3 domain")
Link: https://tools.ietf.org/html/rfc792
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Ahern <dsa@cumulusnetworks.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 net/ipv4/icmp.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index e30515f89802..3d1da70c7293 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -465,6 +465,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 					int type, int code,
 					struct icmp_bxm *param)
 {
+	struct net_device *route_lookup_dev;
 	struct rtable *rt, *rt2;
 	struct flowi4 fl4_dec;
 	int err;
@@ -479,7 +480,14 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	fl4->flowi4_proto = IPPROTO_ICMP;
 	fl4->fl4_icmp_type = type;
 	fl4->fl4_icmp_code = code;
-	fl4->flowi4_oif = l3mdev_master_ifindex(skb_dst(skb_in)->dev);
+	/*
+	 * The device used for looking up which routing table to use is
+	 * preferably the source whenever it is set, which should ensure
+	 * the icmp error can be sent to the source host, else fallback
+	 * on the destination device.
+	 */
+	route_lookup_dev = skb_in->dev ? skb_in->dev : skb_dst(skb_in)->dev;
+	fl4->flowi4_oif = l3mdev_master_ifindex(route_lookup_dev);
 
 	security_skb_classify_flow(skb_in, flowi4_to_flowi(fl4));
 	rt = ip_route_output_key_hash(net, fl4, skb_in);
@@ -503,7 +511,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	if (err)
 		goto relookup_failed;
 
-	if (inet_addr_type_dev_table(net, skb_dst(skb_in)->dev,
+	if (inet_addr_type_dev_table(net, route_lookup_dev,
 				     fl4_dec.saddr) == RTN_LOCAL) {
 		rt2 = __ip_route_output_key(net, &fl4_dec);
 		if (IS_ERR(rt2))
-- 
2.11.0

