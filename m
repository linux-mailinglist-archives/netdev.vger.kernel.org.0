Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDC6326004
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 10:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhBZJ16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 04:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhBZJZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 04:25:47 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E873C06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 01:25:07 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lFZMp-0005Wh-9w; Fri, 26 Feb 2021 10:24:59 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lFZMo-00074N-Vk; Fri, 26 Feb 2021 10:24:58 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     mkl@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andre Naujoks <nautsch2@gmail.com>,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v4 1/1] can: can_skb_set_owner(): fix ref counting if socket was closed before setting skb ownership
Date:   Fri, 26 Feb 2021 10:24:56 +0100
Message-Id: <20210226092456.27126-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two ref count variables controlling the free()ing of a socket:
- struct sock::sk_refcnt - which is changed by sock_hold()/sock_put()
- struct sock::sk_wmem_alloc - which accounts the memory allocated by
  the skbs in the send path.

In case there are still TX skbs on the fly and the socket() is closed,
the struct sock::sk_refcnt reaches 0. In the TX-path the CAN stack
clones an "echo" skb, calls sock_hold() on the original socket and
references it. This produces the following back trace:

| WARNING: CPU: 0 PID: 280 at lib/refcount.c:25 refcount_warn_saturate+0x114/0x134
| refcount_t: addition on 0; use-after-free.
| Modules linked in: coda_vpu(E) v4l2_jpeg(E) videobuf2_vmalloc(E) imx_vdoa(E)
| CPU: 0 PID: 280 Comm: test_can.sh Tainted: G            E     5.11.0-04577-gf8ff6603c617 #203
| Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
| Backtrace:
| [<80bafea4>] (dump_backtrace) from [<80bb0280>] (show_stack+0x20/0x24) r7:00000000 r6:600f0113 r5:00000000 r4:81441220
| [<80bb0260>] (show_stack) from [<80bb593c>] (dump_stack+0xa0/0xc8)
| [<80bb589c>] (dump_stack) from [<8012b268>] (__warn+0xd4/0x114) r9:00000019 r8:80f4a8c2 r7:83e4150c r6:00000000 r5:00000009 r4:80528f90
| [<8012b194>] (__warn) from [<80bb09c4>] (warn_slowpath_fmt+0x88/0xc8) r9:83f26400 r8:80f4a8d1 r7:00000009 r6:80528f90 r5:00000019 r4:80f4a8c2
| [<80bb0940>] (warn_slowpath_fmt) from [<80528f90>] (refcount_warn_saturate+0x114/0x134) r8:00000000 r7:00000000 r6:82b44000 r5:834e5600 r4:83f4d540
| [<80528e7c>] (refcount_warn_saturate) from [<8079a4c8>] (__refcount_add.constprop.0+0x4c/0x50)
| [<8079a47c>] (__refcount_add.constprop.0) from [<8079a57c>] (can_put_echo_skb+0xb0/0x13c)
| [<8079a4cc>] (can_put_echo_skb) from [<8079ba98>] (flexcan_start_xmit+0x1c4/0x230) r9:00000010 r8:83f48610 r7:0fdc0000 r6:0c080000 r5:82b44000 r4:834e5600
| [<8079b8d4>] (flexcan_start_xmit) from [<80969078>] (netdev_start_xmit+0x44/0x70) r9:814c0ba0 r8:80c8790c r7:00000000 r6:834e5600 r5:82b44000 r4:82ab1f00
| [<80969034>] (netdev_start_xmit) from [<809725a4>] (dev_hard_start_xmit+0x19c/0x318) r9:814c0ba0 r8:00000000 r7:82ab1f00 r6:82b44000 r5:00000000 r4:834e5600
| [<80972408>] (dev_hard_start_xmit) from [<809c6584>] (sch_direct_xmit+0xcc/0x264) r10:834e5600 r9:00000000 r8:00000000 r7:82b44000 r6:82ab1f00 r5:834e5600 r4:83f27400
| [<809c64b8>] (sch_direct_xmit) from [<809c6c0c>] (__qdisc_run+0x4f0/0x534)

To fix this problem, only set skb ownership to sockets which have still
a ref count > 0.

Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Andre Naujoks <nautsch2@gmail.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Fixes: 0ae89beb283a ("can: add destructor for self generated skbs")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 include/linux/can/skb.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index 685f34cfba20..d82018cc0d0b 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -65,8 +65,12 @@ static inline void can_skb_reserve(struct sk_buff *skb)
 
 static inline void can_skb_set_owner(struct sk_buff *skb, struct sock *sk)
 {
-	if (sk) {
-		sock_hold(sk);
+	/*
+	 * If the socket has already been closed by user space, the refcount may
+	 * already be 0 (and the socket will be freed after the last TX skb has
+	 * been freed). So only increase socket refcount if the refcount is > 0.
+	 */
+	if (sk && refcount_inc_not_zero(&sk->sk_refcnt)) {
 		skb->destructor = sock_efree;
 		skb->sk = sk;
 	}
-- 
2.29.2

