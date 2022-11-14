Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588366273EF
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 01:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbiKNAva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 19:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiKNAv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 19:51:28 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F6795A8
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 16:51:27 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-13be3ef361dso11008689fac.12
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 16:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TokapDf0jizPeHR14vhzAkcfTsAR+kvJEKxSIayQiWY=;
        b=mnimACMfnQkcgX11j0eWv7ETR08N23QRtIpjytmtoK6+DQJ/LEunk8rvi6uKM//x1u
         9+dqfJoxKBr5YMQKm+WEkehw8Np/JTPTCcqrghxQvwy8TcMLY80+V60pDgiY3uwze6F3
         DEBZJZPhRP9svBf0qEnDwY7PXi256V2INGeFAvI3MrxDc56zg4DDWytBb3rfrvTUzCpy
         qiwO90KBB8GGrHU9oSVirCPQVdZ6qFgqS0CE0csf+C53swQmvaqKODzIl9Ajy0lDOlJi
         kdYxw9k/vfmxhX5r+Yfx7t7j9QoFnL5q0YfsSOgn24jB+X/S6oFikLk3JlemEeiDQFIf
         HXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TokapDf0jizPeHR14vhzAkcfTsAR+kvJEKxSIayQiWY=;
        b=MNWnI7ws81ypQPXT2MkEyE35vh/7X5EhHQR/x7tFERLivTLgp60wiufiMRpOKM/MWn
         f84BCUrkMBH7jIMdLTS6WtURV1VlYPL/YFLeZXQzKrJ7Zch8MIdAMaku6kQq5S1DkaXA
         FbffPNtNKLLm9Z9y1Q7PmTIuDaNyRuZbyaeujSlG3h19NTJIHv/sQcVGCHPd9fbnzt7f
         TWQZzmGgzmvrPgH4Tb36e/N2zwffsi7ypjUBz9dZ+K3++4a/0U3PQJPIU/ckQVrLHRA7
         /8wL6gOvwyNOJaJbRQ8qsqB4TsRLWc+sSBSOYtuzNBPjSWu1206UhqEZ9wFlV2SWr7oL
         9iGw==
X-Gm-Message-State: ANoB5pmoreD+8yGiY06a81MNKbqGtkFqnlSGhsrjGSrhJBgFhze6PZ+o
        yt+Oe00o5IARHwtpcWwoQsoBMLuIJ48=
X-Google-Smtp-Source: AA0mqf7GG4pBPUaKs34kPpeV7998RIe0kR/7KRBdW9sviGbTIDmHRjFxbHQArgeWx+qyzRNcefTdhA==
X-Received: by 2002:a05:6870:75c3:b0:12d:2523:bb34 with SMTP id de3-20020a05687075c300b0012d2523bb34mr5790379oab.92.1668387086646;
        Sun, 13 Nov 2022 16:51:26 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:6343:42bb:5d9b:dded])
        by smtp.gmail.com with ESMTPSA id d11-20020a056830044b00b0066c15490a55sm3592303otc.19.2022.11.13.16.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 16:51:26 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, wanghai38@huawei.com,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot+278279efdd2730dd14bf@syzkaller.appspotmail.com,
        shaozhengchao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Herbert <tom@herbertland.com>
Subject: [Patch net v3] kcm: close race conditions on sk_receive_queue
Date:   Sun, 13 Nov 2022 16:51:19 -0800
Message-Id: <20221114005119.597905-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

sk->sk_receive_queue is protected by skb queue lock, but for KCM
sockets its RX path takes mux->rx_lock to protect more than just
skb queue. However, kcm_recvmsg() still only grabs the skb queue
lock, so race conditions still exist.

We can teach kcm_recvmsg() to grab mux->rx_lock too but this would
introduce a potential performance regression as struct kcm_mux can
be shared by multiple KCM sockets.

So we have to enforce skb queue lock in requeue_rx_msgs() and handle
skb peek case carefully in kcm_wait_data(). Fortunately,
skb_recv_datagram() already handles it nicely and is widely used by
other sockets, we can just switch to skb_recv_datagram() after
getting rid of the unnecessary sock lock in kcm_recvmsg() and
kcm_splice_read(). Side note: SOCK_DONE is not used by KCM sockets,
so it is safe to get rid of this check too.

I ran the original syzbot reproducer for 30 min without seeing any
issue.

Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Reported-by: syzbot+278279efdd2730dd14bf@syzkaller.appspotmail.com
Reported-by: shaozhengchao <shaozhengchao@huawei.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/kcm/kcmsock.c | 58 +++++------------------------------------------
 1 file changed, 6 insertions(+), 52 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index a5004228111d..890a2423f559 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -222,7 +222,7 @@ static void requeue_rx_msgs(struct kcm_mux *mux, struct sk_buff_head *head)
 	struct sk_buff *skb;
 	struct kcm_sock *kcm;
 
-	while ((skb = __skb_dequeue(head))) {
+	while ((skb = skb_dequeue(head))) {
 		/* Reset destructor to avoid calling kcm_rcv_ready */
 		skb->destructor = sock_rfree;
 		skb_orphan(skb);
@@ -1085,53 +1085,17 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	return err;
 }
 
-static struct sk_buff *kcm_wait_data(struct sock *sk, int flags,
-				     long timeo, int *err)
-{
-	struct sk_buff *skb;
-
-	while (!(skb = skb_peek(&sk->sk_receive_queue))) {
-		if (sk->sk_err) {
-			*err = sock_error(sk);
-			return NULL;
-		}
-
-		if (sock_flag(sk, SOCK_DONE))
-			return NULL;
-
-		if ((flags & MSG_DONTWAIT) || !timeo) {
-			*err = -EAGAIN;
-			return NULL;
-		}
-
-		sk_wait_data(sk, &timeo, NULL);
-
-		/* Handle signals */
-		if (signal_pending(current)) {
-			*err = sock_intr_errno(timeo);
-			return NULL;
-		}
-	}
-
-	return skb;
-}
-
 static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 		       size_t len, int flags)
 {
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
 	int err = 0;
-	long timeo;
 	struct strp_msg *stm;
 	int copied = 0;
 	struct sk_buff *skb;
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-
-	lock_sock(sk);
-
-	skb = kcm_wait_data(sk, flags, timeo, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
@@ -1162,14 +1126,11 @@ static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 			/* Finished with message */
 			msg->msg_flags |= MSG_EOR;
 			KCM_STATS_INCR(kcm->stats.rx_msgs);
-			skb_unlink(skb, &sk->sk_receive_queue);
-			kfree_skb(skb);
 		}
 	}
 
 out:
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return copied ? : err;
 }
 
@@ -1179,7 +1140,6 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 {
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
-	long timeo;
 	struct strp_msg *stm;
 	int err = 0;
 	ssize_t copied;
@@ -1187,11 +1147,7 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 
 	/* Only support splice for SOCKSEQPACKET */
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-
-	lock_sock(sk);
-
-	skb = kcm_wait_data(sk, flags, timeo, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto err_out;
 
@@ -1219,13 +1175,11 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 	 * finish reading the message.
 	 */
 
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return copied;
 
 err_out:
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return err;
 }
 
-- 
2.34.1

