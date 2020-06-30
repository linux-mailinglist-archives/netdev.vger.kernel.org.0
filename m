Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8180D20EAAA
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgF3BG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:06:57 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:60171 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbgF3BGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:06:49 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 9a11897b;
        Tue, 30 Jun 2020 00:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=A0lWy9h3jqc1a7KNAk9VRzVMi
        Yo=; b=RGb76Hs+stzcpM6Cm3qD56ZvWNFk3f9dZcsx92Q29Tj5kV+uppfxIv94b
        w1PwC8r8ar6tePQD97SNREOHcPs/FndQ6VaDvAshGEz/+y58px5TV+Ffka7Mfq6f
        MC4vgNC3kukh6Z6OrTMuIBj7BAnogbwc2iBXucjZkARU90SQZA/giM1s04cVI1/X
        9RtnbkQh23lqBAnwewf3yHncs8yV0F7KcGFiVXQmhBPK/Ho5kU5DJWakOm7rVxPj
        fh44FEqyQZXH1xynzLj3wDCcDAPW1+3IjNFi9q7EzkolZRt/2JmzhRg0xldyZSY8
        r5cy93m7QmyIoLwrLxEjr1614OuMw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e95283e4 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 30 Jun 2020 00:47:02 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hans Wippel <ndev@hwipl.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net v2 7/8] net: sit: implement header_ops->parse_protocol for AF_PACKET
Date:   Mon, 29 Jun 2020 19:06:24 -0600
Message-Id: <20200630010625.469202-8-Jason@zx2c4.com>
In-Reply-To: <20200630010625.469202-1-Jason@zx2c4.com>
References: <20200630010625.469202-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sit uses skb->protocol to determine packet type, and bails out if it's
not set. For AF_PACKET injection, we need to support its call chain of:

    packet_sendmsg -> packet_snd -> packet_parse_headers ->
      dev_parse_header_protocol -> parse_protocol

Without a valid parse_protocol, this returns zero, and sit rejects the
skb. So, this wires up the ip_tunnel handler for layer 3 packets for
that case.

Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/ipv6/sit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 1fbb4dfbb191..5e2c34c0ac97 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1421,6 +1421,7 @@ static void ipip6_tunnel_setup(struct net_device *dev)
 	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 
 	dev->netdev_ops		= &ipip6_netdev_ops;
+	dev->header_ops		= &ip_tunnel_header_ops;
 	dev->needs_free_netdev	= true;
 	dev->priv_destructor	= ipip6_dev_free;
 
-- 
2.27.0

