Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF95020EAA4
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgF3BGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:06:43 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:60171 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgF3BGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:06:42 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 0323f243;
        Tue, 30 Jun 2020 00:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=xKPsjje8Yh5NeiPGcodksFIMq
        EM=; b=Q52ZVdS2df6sLWVXiAnYvG0t1Kpkwc6tQ98PRlNuUyjRqZOMI0dyC1jzW
        wf6uabx7/Nv2H6FwWSkmhz8rlw/AYib89Hq/mKLOmemyK0+KsaF3ByAz4VJOuuZ6
        UHU33r04I13qbC3ge5v3SSJ3AABEYD7S3TxKLkVBh3IOtHSPsrlDas1ZMJmw/+Yq
        zr7Dno9+plGtZmtD8A2FlPxjl/lqAlx0e2YPoosqz0vOB1OD8OVcfvNnYNI/pX1W
        BA7ralk6oQ9OLkRtLf5acoqD2h7kWO3UVRPvr+1ByF/VWIcXy+HHqLBzKm9zHsAL
        UXeLoaGZ32LDgBBjEO/RpsRTWQSCQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9353f973 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 30 Jun 2020 00:46:56 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net v2 2/8] net: ipip: implement header_ops->parse_protocol for AF_PACKET
Date:   Mon, 29 Jun 2020 19:06:19 -0600
Message-Id: <20200630010625.469202-3-Jason@zx2c4.com>
In-Reply-To: <20200630010625.469202-1-Jason@zx2c4.com>
References: <20200630010625.469202-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ipip uses skb->protocol to determine packet type, and bails out if it's
not set. For AF_PACKET injection, we need to support its call chain of:

    packet_sendmsg -> packet_snd -> packet_parse_headers ->
      dev_parse_header_protocol -> parse_protocol

Without a valid parse_protocol, this returns zero, and ipip rejects the
skb. So, this wires up the ip_tunnel handler for layer 3 packets for
that case.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/ipv4/ipip.c       | 1 +
 net/ipv6/ip6_tunnel.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 40fea52c8277..75d35e76bec2 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -361,6 +361,7 @@ static const struct net_device_ops ipip_netdev_ops = {
 static void ipip_tunnel_setup(struct net_device *dev)
 {
 	dev->netdev_ops		= &ipip_netdev_ops;
+	dev->header_ops		= &ip_tunnel_header_ops;
 
 	dev->type		= ARPHRD_TUNNEL;
 	dev->flags		= IFF_NOARP;
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 821d96c720b9..a18c378ca5f4 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1846,6 +1846,7 @@ static const struct net_device_ops ip6_tnl_netdev_ops = {
 static void ip6_tnl_dev_setup(struct net_device *dev)
 {
 	dev->netdev_ops = &ip6_tnl_netdev_ops;
+	dev->header_ops = &ip_tunnel_header_ops;
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = ip6_dev_free;
 
-- 
2.27.0

