Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6856B171601
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 12:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgB0LbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 06:31:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57644 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728895AbgB0LbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 06:31:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582803060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FIrk2Hb43yFwH4NOdjBtoYONsH6Vtku0xH2W+V1h4o8=;
        b=Rw5LOTkfUrxslgGEAU6DPYdeTX6g45Ne7awmqQ28ov3bGI+dnISf703SBFFTUJIMp/1AFW
        Lrjyl8jGYoWzxSmuilQrz6wtss3wlYGEtsknMzuEPp7bAIPS7VXIZGD/SVtB9M+JOT1cFx
        /Z3u7UH6lHAC0OL9VkBU/p5s0ZLPCvQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-7T0PViH1ODiSQBrtGv8GYg-1; Thu, 27 Feb 2020 06:30:58 -0500
X-MC-Unique: 7T0PViH1ODiSQBrtGv8GYg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12C5F108442C;
        Thu, 27 Feb 2020 11:30:57 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-88.ams2.redhat.com [10.36.117.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECD441BC6D;
        Thu, 27 Feb 2020 11:30:55 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH net-next 2/2] net: datagram: drop 'destructor' argument from several helpers
Date:   Thu, 27 Feb 2020 12:30:38 +0100
Message-Id: <42639d3f3b1da6959ed42c683780c48a8fe08f4e.1582802470.git.pabeni@redhat.com>
In-Reply-To: <cover.1582802470.git.pabeni@redhat.com>
References: <cover.1582802470.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only users for such argument are the UDP protocol and the UNIX
socket family. We can safely reclaim the accounted memory directly
from the UDP code and, after the previous patch, we can do scm
stats accounting outside the datagram helpers.

Overall this cleans up a bit some datagram-related helpers, and
avoids an indirect call per packet in the UDP receive path.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/skbuff.h | 12 ++----------
 net/core/datagram.c    | 25 +++++++------------------
 net/ipv4/udp.c         | 14 ++++++++------
 net/unix/af_unix.c     |  6 ++++--
 4 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5b50278c4bc8..21749b2cdc9b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3514,23 +3514,15 @@ int __skb_wait_for_more_packets(struct sock *sk, =
struct sk_buff_head *queue,
 struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
 					  struct sk_buff_head *queue,
 					  unsigned int flags,
-					  void (*destructor)(struct sock *sk,
-							   struct sk_buff *skb),
 					  int *off, int *err,
 					  struct sk_buff **last);
 struct sk_buff *__skb_try_recv_datagram(struct sock *sk,
 					struct sk_buff_head *queue,
-					unsigned int flags,
-					void (*destructor)(struct sock *sk,
-							   struct sk_buff *skb),
-					int *off, int *err,
+					unsigned int flags, int *off, int *err,
 					struct sk_buff **last);
 struct sk_buff *__skb_recv_datagram(struct sock *sk,
 				    struct sk_buff_head *sk_queue,
-				    unsigned int flags,
-				    void (*destructor)(struct sock *sk,
-						       struct sk_buff *skb),
-				    int *off, int *err);
+				    unsigned int flags, int *off, int *err);
 struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned flags, int n=
oblock,
 				  int *err);
 __poll_t datagram_poll(struct file *file, struct socket *sock,
diff --git a/net/core/datagram.c b/net/core/datagram.c
index a78e7f864c1e..4213081c6ed3 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -166,8 +166,6 @@ static struct sk_buff *skb_set_peeked(struct sk_buff =
*skb)
 struct sk_buff *__skb_try_recv_from_queue(struct sock *sk,
 					  struct sk_buff_head *queue,
 					  unsigned int flags,
-					  void (*destructor)(struct sock *sk,
-							   struct sk_buff *skb),
 					  int *off, int *err,
 					  struct sk_buff **last)
 {
@@ -198,8 +196,6 @@ struct sk_buff *__skb_try_recv_from_queue(struct sock=
 *sk,
 			refcount_inc(&skb->users);
 		} else {
 			__skb_unlink(skb, queue);
-			if (destructor)
-				destructor(sk, skb);
 		}
 		*off =3D _off;
 		return skb;
@@ -212,7 +208,6 @@ struct sk_buff *__skb_try_recv_from_queue(struct sock=
 *sk,
  *	@sk: socket
  *	@queue: socket queue from which to receive
  *	@flags: MSG\_ flags
- *	@destructor: invoked under the receive lock on successful dequeue
  *	@off: an offset in bytes to peek skb from. Returns an offset
  *	      within an skb where data actually starts
  *	@err: error code returned
@@ -245,10 +240,7 @@ struct sk_buff *__skb_try_recv_from_queue(struct soc=
k *sk,
  */
 struct sk_buff *__skb_try_recv_datagram(struct sock *sk,
 					struct sk_buff_head *queue,
-					unsigned int flags,
-					void (*destructor)(struct sock *sk,
-							   struct sk_buff *skb),
-					int *off, int *err,
+					unsigned int flags, int *off, int *err,
 					struct sk_buff **last)
 {
 	struct sk_buff *skb;
@@ -269,8 +261,8 @@ struct sk_buff *__skb_try_recv_datagram(struct sock *=
sk,
 		 * However, this function was correct in any case. 8)
 		 */
 		spin_lock_irqsave(&queue->lock, cpu_flags);
-		skb =3D __skb_try_recv_from_queue(sk, queue, flags, destructor,
-						off, &error, last);
+		skb =3D __skb_try_recv_from_queue(sk, queue, flags, off, &error,
+						last);
 		spin_unlock_irqrestore(&queue->lock, cpu_flags);
 		if (error)
 			goto no_packet;
@@ -293,10 +285,7 @@ EXPORT_SYMBOL(__skb_try_recv_datagram);
=20
 struct sk_buff *__skb_recv_datagram(struct sock *sk,
 				    struct sk_buff_head *sk_queue,
-				    unsigned int flags,
-				    void (*destructor)(struct sock *sk,
-						       struct sk_buff *skb),
-				    int *off, int *err)
+				    unsigned int flags, int *off, int *err)
 {
 	struct sk_buff *skb, *last;
 	long timeo;
@@ -304,8 +293,8 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk,
 	timeo =3D sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
=20
 	do {
-		skb =3D __skb_try_recv_datagram(sk, sk_queue, flags, destructor,
-					      off, err, &last);
+		skb =3D __skb_try_recv_datagram(sk, sk_queue, flags, off, err,
+					      &last);
 		if (skb)
 			return skb;
=20
@@ -326,7 +315,7 @@ struct sk_buff *skb_recv_datagram(struct sock *sk, un=
signed int flags,
=20
 	return __skb_recv_datagram(sk, &sk->sk_receive_queue,
 				   flags | (noblock ? MSG_DONTWAIT : 0),
-				   NULL, &off, err);
+				   &off, err);
 }
 EXPORT_SYMBOL(skb_recv_datagram);
=20
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 08a41f1e1cd2..a68e2ac37f26 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1671,10 +1671,11 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, u=
nsigned int flags,
 		error =3D -EAGAIN;
 		do {
 			spin_lock_bh(&queue->lock);
-			skb =3D __skb_try_recv_from_queue(sk, queue, flags,
-							udp_skb_destructor,
-							off, err, &last);
+			skb =3D __skb_try_recv_from_queue(sk, queue, flags, off,
+							err, &last);
 			if (skb) {
+				if (!(flags & MSG_PEEK))
+					udp_skb_destructor(sk, skb);
 				spin_unlock_bh(&queue->lock);
 				return skb;
 			}
@@ -1692,9 +1693,10 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, un=
signed int flags,
 			spin_lock(&sk_queue->lock);
 			skb_queue_splice_tail_init(sk_queue, queue);
=20
-			skb =3D __skb_try_recv_from_queue(sk, queue, flags,
-							udp_skb_dtor_locked,
-							off, err, &last);
+			skb =3D __skb_try_recv_from_queue(sk, queue, flags, off,
+							err, &last);
+			if (skb && !(flags & MSG_PEEK))
+				udp_skb_dtor_locked(sk, skb);
 			spin_unlock(&sk_queue->lock);
 			spin_unlock_bh(&queue->lock);
 			if (skb)
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 145a3965341e..194e7b93e404 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2102,9 +2102,11 @@ static int unix_dgram_recvmsg(struct socket *sock,=
 struct msghdr *msg,
=20
 		skip =3D sk_peek_offset(sk, flags);
 		skb =3D __skb_try_recv_datagram(sk, &sk->sk_receive_queue, flags,
-					      scm_stat_del, &skip, &err, &last);
-		if (skb)
+					      &skip, &err, &last);
+		if (skb) {
+			scm_stat_del(sk, skb);
 			break;
+		}
=20
 		mutex_unlock(&u->iolock);
=20
--=20
2.21.1

