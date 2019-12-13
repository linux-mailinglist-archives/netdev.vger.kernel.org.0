Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A1F11EC2F
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 21:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfLMUxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 15:53:50 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:43261 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfLMUxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 15:53:49 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mf3yk-1i3ky22RkQ-00gY1h; Fri, 13 Dec 2019 21:53:36 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH v2 08/24] packet: clarify timestamp overflow
Date:   Fri, 13 Dec 2019 21:52:13 +0100
Message-Id: <20191213205221.3787308-5-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191213204936.3643476-1-arnd@arndb.de>
References: <20191213204936.3643476-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:kKBta+G+as32YcXvSh8tqOxFF8jEv1GeP9pum+Ut03Clje4yb0Y
 szlos7jj5U38a9OyuzukApS8mGz2pEGMpu1kdmhnUtVYGq1KoMKrBMvwG2Ju1qHHmp6TxBX
 Ckl2dSzUfranvLS9EdhP4rZF83JADlDdY8rQeETo2twFKq2U+Hc5gvv4bWLL/UDNPmm4X9p
 JVMHJaWzJlbVlDbLw7GIQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:IRdm5OTc3rE=:EZmf5cbRyzKAHD8CnHoxmH
 gRxlyJt2cIfonuW1EgiTb6S6CC3kH7g5rzAgTaMgZ0k1RpIInOJ2F8y2+gd9A6VUVkKi5JCGb
 kd3iCHr+Obp8BOvM4r1mNwxlrC+n9BXx0w+2KXY6qh2qXG4lNnP1LNV+ftLNGZtPFNdGOrKcr
 wsh4atIZsxCGAek99Bp7zpXILcoh8saZ3vcIf+IuU9ytJDcsTP02o2wd4tQPS8FuXsZG/EYpG
 gP6AS9n28Y9Q5BEtZXdAAM6SeL4CGa+8eL10mRk9ruYXac+Uyk50eNmdioIsalwVYhAQPqN8g
 sD5ZAbLLfyKD01KehEeUvUEtOJMNUdtUaaDUGmvQx6LkICIZjvEKGY7tfG3W4jxBJ5+fRR3It
 8D81cJPCLAx8nBmUVJXvnDtvRYZSI2xaDDdi+v4p7ge5IviGf4LvGxsUqG22NAIuIsEGPwswR
 MRpgwWx95S8xjpP+eM8f35d4yEg8Zwl8cf0QSE2vRpxNTSN6BAC23Ugpc0MgkaZvTN6PlgHy3
 3Yh1MDgPA8QogrIr5jLZby5BU44A12q/x8ulD0APdnweT0jCXUQqUm2wLBb3dbSpdtinVL147
 5kntc3jlnYo6w1mCqN9CRLprjxVgRpKRgCR3UEcqVEYjOLu2pY7wTgGZOOfyYAuJotpjSCjr/
 XlSIPO8GPwp3rLOl6z/JJoPmio90dX0nZi0jpOFeN9uHM9zbTXcnSGed0EnppfrcBJMoVR+YR
 3ZyCOZjrtvRn5uKUkBZwnN1TgWzSHQpGViJqM8zRLcUpooFBFjgaWbyMEEB0HDT06PmgwsZKV
 ybKqE9JyyG90ElcZMYr1x0qseCj9ADA+RrT2+g9cu3G0ogv7a92+boY1NSUaS8oRVuYX9JbMU
 1ytJBPm9j09YOD61HG6Q==
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
index 53c1d41fb1c9..60300f3fcddc 100644
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
@@ -2168,7 +2175,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	unsigned long status = TP_STATUS_USER;
 	unsigned short macoff, netoff, hdrlen;
 	struct sk_buff *copy_skb = NULL;
-	struct timespec ts;
+	struct timespec64 ts;
 	__u32 ts_status;
 	bool is_drop_n_account = false;
 	bool do_vnet = false;
@@ -2300,7 +2307,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	skb_copy_bits(skb, 0, h.raw + macoff, snaplen);
 
 	if (!(ts_status = tpacket_get_timestamp(skb, &ts, po->tp_tstamp)))
-		getnstimeofday(&ts);
+		ktime_get_real_ts64(&ts);
 
 	status |= ts_status;
 
-- 
2.20.0

