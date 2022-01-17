Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E181D49073C
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239169AbiAQLm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:42:56 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:16717 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239124AbiAQLm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:42:56 -0500
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JcqgM1r7hzZdkl;
        Mon, 17 Jan 2022 19:39:11 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 17 Jan 2022 19:42:48 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <socketcan@hartkopp.net>, <mkl@pengutronix.de>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] can: isotp: isotp_rcv_cf(): fix so->rx race problem
Date:   Mon, 17 Jan 2022 20:01:02 +0800
Message-ID: <20220117120102.2395157-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receive a FF, the current code logic does not consider the real
so->rx.state but set so->rx.state to ISOTP_IDLE directly. That will
make so->rx accessed by multiple receiving processes concurrently.

The following syz problem is one of the scenarios. so->rx.len is
changed by isotp_rcv_ff() during isotp_rcv_cf(), so->rx.len equals
0 before alloc_skb() and equals 4096 after alloc_skb(). That will
trigger skb_over_panic() in skb_put().

=======================================================
CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.16.0-rc8-syzkaller #0
RIP: 0010:skb_panic+0x16c/0x16e net/core/skbuff.c:113
Call Trace:
 <TASK>
 skb_over_panic net/core/skbuff.c:118 [inline]
 skb_put.cold+0x24/0x24 net/core/skbuff.c:1990
 isotp_rcv_cf net/can/isotp.c:570 [inline]
 isotp_rcv+0xa38/0x1e30 net/can/isotp.c:668
 deliver net/can/af_can.c:574 [inline]
 can_rcv_filter+0x445/0x8d0 net/can/af_can.c:635
 can_receive+0x31d/0x580 net/can/af_can.c:665
 can_rcv+0x120/0x1c0 net/can/af_can.c:696
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5465
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5579

Check so->rx.state equals ISOTP_IDLE firstly in isotp_rcv_ff().
Make sure so->rx idle when receive another new packet. And set
so->rx.state to ISOTP_IDLE after whole packet being received.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/can/isotp.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index df6968b28bf4..a4b174f860f3 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -443,8 +443,10 @@ static int isotp_rcv_ff(struct sock *sk, struct canfd_frame *cf, int ae)
 	int off;
 	int ff_pci_sz;
 
+	if (so->rx.state != ISOTP_IDLE)
+		return 0;
+
 	hrtimer_cancel(&so->rxtimer);
-	so->rx.state = ISOTP_IDLE;
 
 	/* get the used sender LL_DL from the (first) CAN frame data length */
 	so->rx.ll_dl = padlen(cf->len);
@@ -518,8 +520,6 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
 		so->lastrxcf_tstamp = skb->tstamp;
 	}
 
-	hrtimer_cancel(&so->rxtimer);
-
 	/* CFs are never longer than the FF */
 	if (cf->len > so->rx.ll_dl)
 		return 1;
@@ -531,15 +531,15 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
 			return 1;
 	}
 
+	hrtimer_cancel(&so->rxtimer);
+
 	if ((cf->data[ae] & 0x0F) != so->rx.sn) {
 		/* wrong sn detected - report 'illegal byte sequence' */
 		sk->sk_err = EILSEQ;
 		if (!sock_flag(sk, SOCK_DEAD))
 			sk_error_report(sk);
 
-		/* reset rx state */
-		so->rx.state = ISOTP_IDLE;
-		return 1;
+		goto err_out;
 	}
 	so->rx.sn++;
 	so->rx.sn %= 16;
@@ -551,21 +551,18 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
 	}
 
 	if (so->rx.idx >= so->rx.len) {
-		/* we are done */
-		so->rx.state = ISOTP_IDLE;
-
 		if ((so->opt.flags & ISOTP_CHECK_PADDING) &&
 		    check_pad(so, cf, i + 1, so->opt.rxpad_content)) {
 			/* malformed PDU - report 'not a data message' */
 			sk->sk_err = EBADMSG;
 			if (!sock_flag(sk, SOCK_DEAD))
 				sk_error_report(sk);
-			return 1;
+			goto err_out;
 		}
 
 		nskb = alloc_skb(so->rx.len, gfp_any());
 		if (!nskb)
-			return 1;
+			goto err_out;
 
 		memcpy(skb_put(nskb, so->rx.len), so->rx.buf,
 		       so->rx.len);
@@ -573,6 +570,10 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
 		nskb->tstamp = skb->tstamp;
 		nskb->dev = skb->dev;
 		isotp_rcv_skb(nskb, sk);
+
+		/* we are done */
+		so->rx.state = ISOTP_IDLE;
+
 		return 0;
 	}
 
@@ -591,6 +592,11 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
 	/* we reached the specified blocksize so->rxfc.bs */
 	isotp_send_fc(sk, ae, ISOTP_FC_CTS);
 	return 0;
+
+err_out:
+	/* reset rx state */
+	so->rx.state = ISOTP_IDLE;
+	return 1;
 }
 
 static void isotp_rcv(struct sk_buff *skb, void *data)
-- 
2.25.1

