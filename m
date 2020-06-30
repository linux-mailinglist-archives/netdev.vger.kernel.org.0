Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A1A20EAA5
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgF3BGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:06:46 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:60171 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgF3BGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:06:43 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 4290374f;
        Tue, 30 Jun 2020 00:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=uwnjUE31tMKRKEKYq4haAys8j
        Ew=; b=nwPcNe37L5CN62lr+nhaWqiTbDSySqUdWEqRGfqa7qfLiEoj+2iNc25uH
        4G2lHP9P8wtVYvDIqcF41KEh6HvjdqHDfF52zsaWlBpITLFTKeN1V5qsmJK8Qul2
        b75dR6w1XC+bbGHbze8x/otYgPEg+adx0tudhYYDeQ5Sd9biHhNe+MF776FzVB0/
        T6+E7VVJVTK87eRteL9cogaw93KkM9U1buDKSd3OIhP3j9dWfMdMiWQ/e0QNGOrz
        RHqjFA/OclAmuW5KIzFTu1g6YyhWSg8M2xqQwC3cYc/7sbclr3r2D6t8GIWewnxT
        yt5XwnW890pUouVD3thFDARN5GuBA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 89153989 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 30 Jun 2020 00:46:57 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net v2 3/8] wireguard: implement header_ops->parse_protocol for AF_PACKET
Date:   Mon, 29 Jun 2020 19:06:20 -0600
Message-Id: <20200630010625.469202-4-Jason@zx2c4.com>
In-Reply-To: <20200630010625.469202-1-Jason@zx2c4.com>
References: <20200630010625.469202-1-Jason@zx2c4.com>
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

