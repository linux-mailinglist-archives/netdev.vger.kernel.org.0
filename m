Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E79A20EAA7
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgF3BGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:06:50 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:60171 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgF3BGr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:06:47 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 5e605d44;
        Tue, 30 Jun 2020 00:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=Fi3F3RTKj50aJq3o7a+r71FKJ
        OQ=; b=zKuKVmZ4EIvXtJvV2PO6NY1kmkaa8KuqG1oF3iKDzaWCminGCzIHSpvQf
        ie9rjShsJ04k5TozrFyTcJZ5D7EgMndgkAQxNXh1qMplsfNw8fSIPOQJCyN+lsqY
        9ZUxY6vBGgbeMrytfU1My6/ogaqk2LtrdGvdJsqSsCCVfqPCCrMUX2AkNOhtpoW6
        RqP9A7npwU1FlilC6rs2zu9OtP1/xUMPwKSDvZOBJw5icELON8vvxhGasf9jYftC
        sMIy5Zm4ViG4eg/mx0ivrYQ8V4lrKX7r2NIBXeEKHnBAUzj4gQ6yfHHfsaOSu6tg
        OvAwc8JcOJDZxoBNC4DZCdZPjNHsQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b6d6483f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 30 Jun 2020 00:47:01 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net v2 6/8] net: vti: implement header_ops->parse_protocol for AF_PACKET
Date:   Mon, 29 Jun 2020 19:06:23 -0600
Message-Id: <20200630010625.469202-7-Jason@zx2c4.com>
In-Reply-To: <20200630010625.469202-1-Jason@zx2c4.com>
References: <20200630010625.469202-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vti uses skb->protocol to determine packet type, and bails out if it's
not set. For AF_PACKET injection, we need to support its call chain of:

    packet_sendmsg -> packet_snd -> packet_parse_headers ->
      dev_parse_header_protocol -> parse_protocol

Without a valid parse_protocol, this returns zero, and vti rejects the
skb. So, this wires up the ip_tunnel handler for layer 3 packets for
that case.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/ipv4/ip_vti.c  | 1 +
 net/ipv6/ip6_vti.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 1d9c8cff5ac3..460ca1099e8a 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -441,6 +441,7 @@ static const struct net_device_ops vti_netdev_ops = {
 static void vti_tunnel_setup(struct net_device *dev)
 {
 	dev->netdev_ops		= &vti_netdev_ops;
+	dev->header_ops		= &ip_tunnel_header_ops;
 	dev->type		= ARPHRD_TUNNEL;
 	ip_tunnel_setup(dev, vti_net_id);
 }
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 1147f647b9a0..0d964160a9dd 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -905,6 +905,7 @@ static const struct net_device_ops vti6_netdev_ops = {
 static void vti6_dev_setup(struct net_device *dev)
 {
 	dev->netdev_ops = &vti6_netdev_ops;
+	dev->header_ops = &ip_tunnel_header_ops;
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = vti6_dev_free;
 
-- 
2.27.0

