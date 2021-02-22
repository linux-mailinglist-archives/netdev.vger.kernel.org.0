Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85B7321B1D
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 16:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhBVPQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 10:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbhBVPPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 10:15:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC6FC0611BE
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 07:13:00 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lECtF-0007dt-CX; Mon, 22 Feb 2021 16:12:49 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lECtE-00073i-EI; Mon, 22 Feb 2021 16:12:48 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     mkl@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andre Naujoks <nautsch2@gmail.com>,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH net v1 2/3] can: fix ref count warning if socket was closed before skb was cloned
Date:   Mon, 22 Feb 2021 16:12:46 +0100
Message-Id: <20210222151247.24534-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222151247.24534-1-o.rempel@pengutronix.de>
References: <20210222151247.24534-1-o.rempel@pengutronix.de>
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

If the socket is closed the struct sock::sk_refcnt will finally reach 0
and sk_free() is called. Which then calls
refcount_dec_and_test(&sk->sk_wmem_alloc). If sk_wmem_alloc reaches 0
the socket is actually free()ed.

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

To fix this problem, we have to take into account, that the socket
technically still there but should not used (by any new skbs) any more.
The function skb_clone_sk_optional() (introduced in the previous patch)
takes care of this. It will only clone the skb, if the sk is set and the
refcount has not reached 0.

Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Andre Naujoks <nautsch2@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Fixes: 0ae89beb283a ("can: add destructor for self generated skbs")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 include/linux/can/skb.h   | 3 +--
 net/can/af_can.c          | 6 +++---
 net/can/j1939/main.c      | 3 +--
 net/can/j1939/socket.c    | 3 +--
 net/can/j1939/transport.c | 4 +---
 5 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/include/linux/can/skb.h b/include/linux/can/skb.h
index 685f34cfba20..bc1af38697a2 100644
--- a/include/linux/can/skb.h
+++ b/include/linux/can/skb.h
@@ -79,13 +79,12 @@ static inline struct sk_buff *can_create_echo_skb(struct sk_buff *skb)
 {
 	struct sk_buff *nskb;
 
-	nskb = skb_clone(skb, GFP_ATOMIC);
+	nskb = skb_clone_sk_optional(skb);
 	if (unlikely(!nskb)) {
 		kfree_skb(skb);
 		return NULL;
 	}
 
-	can_skb_set_owner(nskb, skb->sk);
 	consume_skb(skb);
 	return nskb;
 }
diff --git a/net/can/af_can.c b/net/can/af_can.c
index cce2af10eb3e..9e1bd60e7e1b 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -251,20 +251,20 @@ int can_send(struct sk_buff *skb, int loop)
 		 * its own. Example: can_raw sockopt CAN_RAW_RECV_OWN_MSGS
 		 * Therefore we have to ensure that skb->sk remains the
 		 * reference to the originating sock by restoring skb->sk
-		 * after each skb_clone() or skb_orphan() usage.
+		 * after each skb_clone() or skb_orphan() usage -
+		 * skb_clone_sk_optional() takes care of that.
 		 */
 
 		if (!(skb->dev->flags & IFF_ECHO)) {
 			/* If the interface is not capable to do loopback
 			 * itself, we do it here.
 			 */
-			newskb = skb_clone(skb, GFP_ATOMIC);
+			newskb = skb_clone_sk_optional(skb);
 			if (!newskb) {
 				kfree_skb(skb);
 				return -ENOMEM;
 			}
 
-			can_skb_set_owner(newskb, skb->sk);
 			newskb->ip_summed = CHECKSUM_UNNECESSARY;
 			newskb->pkt_type = PACKET_BROADCAST;
 		}
diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index da3a7a7bcff2..4f6852d48077 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -47,12 +47,11 @@ static void j1939_can_recv(struct sk_buff *iskb, void *data)
 	 * the header goes into sockaddr.
 	 * j1939 may not touch the incoming skb in such way
 	 */
-	skb = skb_clone(iskb, GFP_ATOMIC);
+	skb = skb_clone_sk_optional(iskb);
 	if (!skb)
 		return;
 
 	j1939_priv_get(priv);
-	can_skb_set_owner(skb, iskb->sk);
 
 	/* get a pointer to the header of the skb
 	 * the skb payload (pointer) is moved, so that the next skb_data
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 4e4a510d82f9..c1be6c26ff76 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -305,12 +305,11 @@ static void j1939_sk_recv_one(struct j1939_sock *jsk, struct sk_buff *oskb)
 	if (!j1939_sk_recv_match_one(jsk, oskcb))
 		return;
 
-	skb = skb_clone(oskb, GFP_ATOMIC);
+	skb = skb_clone_sk_optional(oskb);
 	if (!skb) {
 		pr_warn("skb clone failed\n");
 		return;
 	}
-	can_skb_set_owner(skb, oskb->sk);
 
 	skcb = j1939_skb_to_cb(skb);
 	skcb->msg_flags &= ~(MSG_DONTROUTE);
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index e09d087ba240..e902557bbe17 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1014,12 +1014,10 @@ static int j1939_simple_txnext(struct j1939_session *session)
 	if (!se_skb)
 		return 0;
 
-	skb = skb_clone(se_skb, GFP_ATOMIC);
+	skb = skb_clone_sk_optional(se_skb);
 	if (!skb)
 		return -ENOMEM;
 
-	can_skb_set_owner(skb, se_skb->sk);
-
 	j1939_tp_set_rxtimeout(session, J1939_SIMPLE_ECHO_TIMEOUT_MS);
 
 	ret = j1939_send_one(priv, skb);
-- 
2.29.2

