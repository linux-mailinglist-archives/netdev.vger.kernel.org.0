Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1060C20BFFB
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 10:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgF0IHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 04:07:35 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:48179 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgF0IHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 04:07:30 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f278eb5f;
        Sat, 27 Jun 2020 07:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=uwnjUE31tMKRKEKYq4haAys8j
        Ew=; b=mk6W3tZ3kchWeSUuHXnTUxI+s3lBoTrQUEaypnA9g8qkKrjmeFSB6B9ma
        WKn3EHHuWOhYnXVLTGHCcWaqTUwrPQDBFNS/mYSyvvUXCp2IvFFbQkpEy+e//iIu
        XaVVXdzxVWTUz0CpcbBBhioSK12ytg4u0bvksKpdUye4CeUdLYElq73kJmwvyahN
        zyTGRLBbSFpm0nyh0JQ+7RKGvk6HdSMI5UAAa8dwGIFbhTC/I8xGRwTHqaOFH5Qy
        MJ+HJ4NJfVtye6eXDi0AFy5j6SpWra8xLnpmyut+T9VtUP7d0beIL56YQGBU0ehS
        m+l+1YcigHYYQLnQ+nEP8u7LEQhsQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 89c47963 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 27 Jun 2020 07:48:05 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net 3/5] wireguard: implement header_ops->parse_protocol for AF_PACKET
Date:   Sat, 27 Jun 2020 02:07:11 -0600
Message-Id: <20200627080713.179883-4-Jason@zx2c4.com>
In-Reply-To: <20200627080713.179883-1-Jason@zx2c4.com>
References: <20200627080713.179883-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WireGuard uses skb->protocol to determine packet type, and bails out if
it's not set or set to something it's not expecting. For AF_PACKET
injection, we need to support its call chain of:

    packet_sendmsg -> packet_snd -> packet_parse_headers ->
      dev_parse_header_protocol -> parse_protocol

Without a valid parse_protocol, this returns zero, and wireguard then
rejects the skb. So, this wires up the ip_tunnel handler for layer 3
packets for that case.

Reported-by: Hans Wippel <ndev@hwipl.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index a8f151b1b5fa..c9f65e96ccb0 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -262,6 +262,7 @@ static void wg_setup(struct net_device *dev)
 			     max(sizeof(struct ipv6hdr), sizeof(struct iphdr));
 
 	dev->netdev_ops = &netdev_ops;
+	dev->header_ops = &ip_tunnel_header_ops;
 	dev->hard_header_len = 0;
 	dev->addr_len = 0;
 	dev->needed_headroom = DATA_PACKET_HEAD_ROOM;
-- 
2.27.0

