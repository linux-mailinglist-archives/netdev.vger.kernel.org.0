Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84D6DF5A32
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388215AbfKHVhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:37:36 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:34605 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388098AbfKHVhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:37:36 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MiJIk-1hxgKI09MU-00fVGs; Fri, 08 Nov 2019 22:36:28 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org, "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org
Subject: [PATCH 10/16] packet: clarify timestamp overflow
Date:   Fri,  8 Nov 2019 22:32:48 +0100
Message-Id: <20191108213257.3097633-11-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191108213257.3097633-1-arnd@arndb.de>
References: <20191108213257.3097633-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Pbh9bPUl2aqLHegsKvRFwZRv3Cocop6mYisT9cAEAqjy9WJ2fy6
 UEpW8x2RFVQtu+G+dVwH5ICaDXq8iRjgi21pd4OXQ0FVy0ZJx9KJfMGHTgklUPQyr3z7BTo
 2GkxOSDAcCm6BGiX4Iy0vpTySWhE1nI/6y4RP3MtLMZliq0iN6/OUuj/P18as7HJN7uVT0Q
 gJcxtFflpPIxSw/idl9dg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:y4QVRpvbjHQ=:TunfjY7qgL1v9cin2/j9nU
 3LGWsCmTvT3gfa9SMUftuz8J36IjGWdRJm9Juvg1/pJojs7J4nyiAEmakQ9uBHdHcsucfPsJ3
 HZWcT8EOWwtyiNUJ0e7WohuZtSjzNH0k/eR+O4OA1y6XOdfYblR+/e15ibItKEQfzNyMnAdbR
 SbkKzaPgEBSaCqjjsVPAeqzuKc2oDUQyH9F2aqjpAwxpfXm+HSQQ6nDzYBYHb7cOYrp10AjN3
 bnv5grR3SEL8fWYa0LviYIqBWbxj1gvAk2qbPjrs4cwPoBaILy4ZJys+HRZmWOGB+okqfNrE9
 ly2VvYSnt11hNNb6Ohn1jIULFNdsRBbWoDPAJkq91SkcxPFDdl6xfh2g91Rl0zGRjYx2h17/E
 UGmIvyfhtQ5TkKY5SoyB8kCml5fQYDMwqj4otLd1nApj6KU3yK5rOrsZsfn+7XBqg2AyQtzWq
 ToYMlnA0V3T4NEVrSSa9JoYgKhwObft2+60+ocYOstnSVnsQlMHM+CL6a8hBEv+UsoblK1IpM
 ld9EQqSSFRxnR2U7/6kfmjXLEJ0OJ00ek5J+5fk31900/LEkL/+zbZ9aavQBl/4OfuWQJiRG4
 oJceiu7OfVrHTXsnJnJ1eJZUPqyfB2OcrNJfd/+dZfQbbfvthI8ezUHhTJMDTeirr/zDIXpdd
 e7Opd2AdmaCJYuBdoBkEKpvMSBtskWm7M7RyXAJNE9qcI5TeH6uHCYk2h+reFPapTock9gZJH
 uK8uAIySB5iZGLaE2c9Firh5vQsXe0PeG9XJM4tkvEe8NMDl7Zp2caYES6RMjNS9/LUkKisEG
 tWuHC307ihkEhayQnnm4tDMTLg9cwuP6ilvSGJzuDvKf2EqTn/fIVpzwJbIGiIRZs7R649kB5
 L+1g7uJWOISvVJ5T/Bcg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The memory mapped packet socket data structure in version 1 through 3
all contain 32-bit second values for the packet time stamps, which makes
them suffer from the overflow of time_t in y2038 or y2106 (depending
on whether user space interprets the value as signed or unsigned).

The implementation uses the deprecated getnstimeofday() function.

In order to get rid of that, this changes the code to use
ktime_get_real_ts64() as a replacement, documenting the nature of the
overflow. As long as the user applications treat the timestamps as
unsigned, or only use the difference between timestamps, they are
fine, and changing the timestamps to 64-bit wouldn't require a more
invasive user space API change.

Note: a lot of other APIs suffer from incompatible structures when
time_t gets redefined to 64-bit in 32-bit user space, but this one
does not.

Acked-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/lkml/CAF=yD-Jomr-gWSR-EBNKnSpFL46UeG564FLfqTCMNEm-prEaXA@mail.gmail.com/T/#u
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/packet/af_packet.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 82a50e850245..0bfdb07e253b 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -408,17 +408,17 @@ static int __packet_get_status(const struct packet_sock *po, void *frame)
 	}
 }
 
-static __u32 tpacket_get_timestamp(struct sk_buff *skb, struct timespec *ts,
+static __u32 tpacket_get_timestamp(struct sk_buff *skb, struct timespec64 *ts,
 				   unsigned int flags)
 {
 	struct skb_shared_hwtstamps *shhwtstamps = skb_hwtstamps(skb);
 
 	if (shhwtstamps &&
 	    (flags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
-	    ktime_to_timespec_cond(shhwtstamps->hwtstamp, ts))
+	    ktime_to_timespec64_cond(shhwtstamps->hwtstamp, ts))
 		return TP_STATUS_TS_RAW_HARDWARE;
 
-	if (ktime_to_timespec_cond(skb->tstamp, ts))
+	if (ktime_to_timespec64_cond(skb->tstamp, ts))
 		return TP_STATUS_TS_SOFTWARE;
 
 	return 0;
@@ -428,13 +428,20 @@ static __u32 __packet_set_timestamp(struct packet_sock *po, void *frame,
 				    struct sk_buff *skb)
 {
 	union tpacket_uhdr h;
-	struct timespec ts;
+	struct timespec64 ts;
 	__u32 ts_status;
 
 	if (!(ts_status = tpacket_get_timestamp(skb, &ts, po->tp_tstamp)))
 		return 0;
 
 	h.raw = frame;
+	/*
+	 * versions 1 through 3 overflow the timestamps in y2106, since they
+	 * all store the seconds in a 32-bit unsigned integer.
+	 * If we create a version 4, that should have a 64-bit timestamp,
+	 * either 64-bit seconds + 32-bit nanoseconds, or just 64-bit
+	 * nanoseconds.
+	 */
 	switch (po->tp_version) {
 	case TPACKET_V1:
 		h.h1->tp_sec = ts.tv_sec;
@@ -774,8 +781,8 @@ static void prb_close_block(struct tpacket_kbdq_core *pkc1,
 		 * It shouldn't really happen as we don't close empty
 		 * blocks. See prb_retire_rx_blk_timer_expired().
 		 */
-		struct timespec ts;
-		getnstimeofday(&ts);
+		struct timespec64 ts;
+		ktime_get_real_ts64(&ts);
 		h1->ts_last_pkt.ts_sec = ts.tv_sec;
 		h1->ts_last_pkt.ts_nsec	= ts.tv_nsec;
 	}
@@ -805,7 +812,7 @@ static void prb_thaw_queue(struct tpacket_kbdq_core *pkc)
 static void prb_open_block(struct tpacket_kbdq_core *pkc1,
 	struct tpacket_block_desc *pbd1)
 {
-	struct timespec ts;
+	struct timespec64 ts;
 	struct tpacket_hdr_v1 *h1 = &pbd1->hdr.bh1;
 
 	smp_rmb();
@@ -818,7 +825,7 @@ static void prb_open_block(struct tpacket_kbdq_core *pkc1,
 	BLOCK_NUM_PKTS(pbd1) = 0;
 	BLOCK_LEN(pbd1) = BLK_PLUS_PRIV(pkc1->blk_sizeof_priv);
 
-	getnstimeofday(&ts);
+	ktime_get_real_ts64(&ts);
 
 	h1->ts_first_pkt.ts_sec = ts.tv_sec;
 	h1->ts_first_pkt.ts_nsec = ts.tv_nsec;
@@ -2162,7 +2169,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	unsigned long status = TP_STATUS_USER;
 	unsigned short macoff, netoff, hdrlen;
 	struct sk_buff *copy_skb = NULL;
-	struct timespec ts;
+	struct timespec64 ts;
 	__u32 ts_status;
 	bool is_drop_n_account = false;
 	bool do_vnet = false;
@@ -2294,7 +2301,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	skb_copy_bits(skb, 0, h.raw + macoff, snaplen);
 
 	if (!(ts_status = tpacket_get_timestamp(skb, &ts, po->tp_tstamp)))
-		getnstimeofday(&ts);
+		ktime_get_real_ts64(&ts);
 
 	status |= ts_status;
 
-- 
2.20.0

