Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370E020BFFD
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 10:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgF0IHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 04:07:39 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:48179 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgF0IHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 04:07:34 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 78266130;
        Sat, 27 Jun 2020 07:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=yhbQ52i5catljqOFAhcNxV2L/
        vc=; b=R7+RFpp8dDhJmSShOsBe9mvuS5x03Im8dQF82SqUIIGebE4T3bGKnALNf
        zuWYdftbtjfqjlt/ZkMoBkJFR5TBl2SOlB+qH8rJT5Frmh+NbxuXCoR004fV3++I
        UCZlKhNYHkP9ArBcwTFM7c1O6oTPUXiqtQGp/7fcTRXpjmMD4Y8NrHc3etF9FvB/
        rvRCkhR0MWonBxbSBZk3NP7q505jkFjrd1Bej14Mps067lNBqJ/tlU+GYMYAu8Od
        1PyTgqM+O8EIvnu7fDm71/8ouRh+mWrss9cHS1aiR7exUuZNG29hk1oesdV4SwNZ
        e+sBFWuzlISD4MDQBNZc9yV80D6tg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b41ae87a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 27 Jun 2020 07:48:07 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 5/5] tun: implement header_ops->parse_protocol for AF_PACKET
Date:   Sat, 27 Jun 2020 02:07:13 -0600
Message-Id: <20200627080713.179883-6-Jason@zx2c4.com>
In-Reply-To: <20200627080713.179883-1-Jason@zx2c4.com>
References: <20200627080713.179883-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tun driver passes up skb->protocol to userspace in the form of PI headers.
For AF_PACKET injection, we need to support its call chain of:

    packet_sendmsg -> packet_snd -> packet_parse_headers ->
      dev_parse_header_protocol -> parse_protocol

Without a valid parse_protocol, this returns zero, and the tun driver
then gives userspace bogus values that it can't deal with.

Note that this isn't the case with tap, because tap already benefits
from the shared infrastructure for ethernet headers. But with tun,
there's nothing.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/tun.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 858b012074bd..7adeb91bd368 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -62,6 +62,7 @@
 #include <net/rtnetlink.h>
 #include <net/sock.h>
 #include <net/xdp.h>
+#include <net/ip_tunnels.h>
 #include <linux/seq_file.h>
 #include <linux/uio.h>
 #include <linux/skb_array.h>
@@ -1351,6 +1352,7 @@ static void tun_net_init(struct net_device *dev)
 	switch (tun->flags & TUN_TYPE_MASK) {
 	case IFF_TUN:
 		dev->netdev_ops = &tun_netdev_ops;
+		dev->header_ops = &ip_tunnel_header_ops;
 
 		/* Point-to-Point TUN Device */
 		dev->hard_header_len = 0;
-- 
2.27.0

