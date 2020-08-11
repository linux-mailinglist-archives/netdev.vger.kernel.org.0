Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB3D242094
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 21:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgHKTuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 15:50:17 -0400
Received: from mail.efficios.com ([167.114.26.124]:58220 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgHKTuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 15:50:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 70BC72CFA34;
        Tue, 11 Aug 2020 15:50:13 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Tdp9EjkuQFHC; Tue, 11 Aug 2020 15:50:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 188CF2CF8B0;
        Tue, 11 Aug 2020 15:50:13 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 188CF2CF8B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1597175413;
        bh=wacVchKN4LsmNI6I5pXp9kMKjgCCodEpsngulBK/dAM=;
        h=From:To:Date:Message-Id;
        b=vKznxKc1kVIGd+ul3nm15Kde8NQqLbnm6Za/sRG63Ck7cRMEkIZGFQpaAUWDRb6u9
         DcAovqc+3anF7is0bC2X5HvxVl9oLMtKrR5cxQn1z1ZB4AzebxxsG8c6fyiziJWFbZ
         HCQVe7AeuQQC3W66tpQEbMvzoteNAxTMX/INvXQT3GxTp9EJECq45N0GqDHseHR+0I
         0+Mwm4GyiPwJgus5c2e6H3F+AJqD7FrG8v6Pna+4lPcmK+6g3su3Ma573uIWMrp8Rk
         xpMlPoMgEkzR/Z/TS9Z7jH7QbCY3/+shuSbGd2hn+Gel2qa5KEkTKdC3V1HROBdgID
         hN4Zqv8iGYSkQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fUjH-GAaUQdY; Tue, 11 Aug 2020 15:50:13 -0400 (EDT)
Received: from localhost.localdomain (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id EC2122CF9B6;
        Tue, 11 Aug 2020 15:50:12 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 2/3] ipv4/icmp: l3mdev: Perform icmp error route lookup on source device routing table
Date:   Tue, 11 Aug 2020 15:50:02 -0400
Message-Id: <20200811195003.1812-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200811195003.1812-1-mathieu.desnoyers@efficios.com>
References: <20200811195003.1812-1-mathieu.desnoyers@efficios.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per RFC792, ICMP errors should be sent to the source host.

However, in configurations with Virtual Routing and Forwarding tables,
looking up which routing table to use is currently done by using the
destination net_device.

commit 9d1a6c4ea43e ("net: icmp_route_lookup should use rt dev to
determine L3 domain") changes the interface passed to
l3mdev_master_ifindex() and inet_addr_type_dev_table() from skb_in->dev
to skb_dst(skb_in)->dev. This effectively uses the destination device
rather than the source device for choosing which routing table should be
used to lookup where to send the ICMP error.

Therefore, if the source and destination interfaces are within separate
VRFs, or one in the global routing table and the other in a VRF, looking
up the source host in the destination interface's routing table will
fail if the destination interface's routing table contains no route to
the source host.

One observable effect of this issue is that traceroute does not work in
the following cases:

- Route leaking between global routing table and VRF
- Route leaking between VRFs

Preferably use the source device routing table when sending ICMP error
messages. If no source device is set, fall-back on the destination
device routing table.

Fixes: 9d1a6c4ea43e ("net: icmp_route_lookup should use rt dev to determine L3 domain")
Link: https://tools.ietf.org/html/rfc792
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 net/ipv4/icmp.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index cf36f955bfe6..1eb83d82ec68 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -465,6 +465,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 					int type, int code,
 					struct icmp_bxm *param)
 {
+	struct net_device *route_lookup_dev = NULL;
 	struct rtable *rt, *rt2;
 	struct flowi4 fl4_dec;
 	int err;
@@ -479,7 +480,17 @@ static struct rtable *icmp_route_lookup(struct net *net,
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
+	if (skb_in->dev)
+		route_lookup_dev = skb_in->dev;
+	else if (skb_dst(skb_in))
+		route_lookup_dev = skb_dst(skb_in)->dev;
+	fl4->flowi4_oif = l3mdev_master_ifindex(route_lookup_dev);
 
 	security_skb_classify_flow(skb_in, flowi4_to_flowi(fl4));
 	rt = ip_route_output_key_hash(net, fl4, skb_in);
@@ -503,7 +514,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	if (err)
 		goto relookup_failed;
 
-	if (inet_addr_type_dev_table(net, skb_dst(skb_in)->dev,
+	if (inet_addr_type_dev_table(net, route_lookup_dev,
 				     fl4_dec.saddr) == RTN_LOCAL) {
 		rt2 = __ip_route_output_key(net, &fl4_dec);
 		if (IS_ERR(rt2))
-- 
2.17.1

