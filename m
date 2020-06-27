Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587C520BFFA
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 10:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgF0IHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 04:07:31 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:48179 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgF0IH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 04:07:28 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 98160d3d;
        Sat, 27 Jun 2020 07:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=xKPsjje8Yh5NeiPGcodksFIMq
        EM=; b=3gFJ1lXvw/h4T7b8GfonTIDVGdvaOawzoQSF+NPaHH2t0JtbP0XHud99H
        A1Cd+j9fJXscQ/paZ57y5v09fIiGI/SfwMVCx3p+AqYXm3rIe9XK0D1Z7i6xF/ny
        +sn2DhtI/GSde4ZpCH5rsZB4FtsDzj925sYH5PgtQf443DqUpV8Gszv6wtsN300R
        X/70kCgBLyS21b9m1ltn0l1zIz0X/a3uo9sP4dR6LF0JiQn9fPvbUH9oqYHRdwfq
        F2FuMt39/iw4lrJl6MHjtnwZlpmarK0lZaPr3znLly3ReShhYSjqD+ssP2os/fnF
        csnYPimDxdYsJiF/dkLTSFIIYzcrQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4f8fbdf5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 27 Jun 2020 07:48:03 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 2/5] net: ipip: implement header_ops->parse_protocol for AF_PACKET
Date:   Sat, 27 Jun 2020 02:07:10 -0600
Message-Id: <20200627080713.179883-3-Jason@zx2c4.com>
In-Reply-To: <20200627080713.179883-1-Jason@zx2c4.com>
References: <20200627080713.179883-1-Jason@zx2c4.com>
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

