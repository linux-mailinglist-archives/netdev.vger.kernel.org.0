Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774001738CF
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgB1Npv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:45:51 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28209 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726714AbgB1Npu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:45:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582897549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8S/B+E4QOMrg76d6GFL+tCT9MLglv+xExTOfH0u0Dzg=;
        b=aUNEbVBjovXdakb93bkv92dlV3+vWAZc4RvbEhUqK0PQ9Oo4PN1O5chZep9kV7FU8YDdrk
        kXRWLmqdQkhiD2vtMSMgBQyOGJf45cZIIg4pPF2QEe7vSZbCpzIX/IUMEBbw2Vth3bqpqt
        zjoTs/6hjCPjEsu40UM9j7CIoihDZ6s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-CU305swqP0SWtkt0H_HzWQ-1; Fri, 28 Feb 2020 08:45:47 -0500
X-MC-Unique: CU305swqP0SWtkt0H_HzWQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79B8C8018AB;
        Fri, 28 Feb 2020 13:45:46 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.36.118.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63BDF92D01;
        Fri, 28 Feb 2020 13:45:45 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH net-next v2 1/2] unix: uses an atomic type for scm files accounting
Date:   Fri, 28 Feb 2020 14:45:21 +0100
Message-Id: <a995b03e54307b878870810e2cf4083ce50f4dac.1582897428.git.pabeni@redhat.com>
In-Reply-To: <cover.1582897428.git.pabeni@redhat.com>
References: <cover.1582897428.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So the scm_stat_{add,del} helper can be invoked with no
additional lock held.

This clean-up the code a bit and will make the next
patch easier.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/af_unix.h |  2 +-
 net/unix/af_unix.c    | 21 ++++++---------------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 17e10fba2152..5cb65227b7a9 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -42,7 +42,7 @@ struct unix_skb_parms {
 } __randomize_layout;
=20
 struct scm_stat {
-	u32 nr_fds;
+	atomic_t nr_fds;
 };
=20
 #define UNIXCB(skb)	(*(struct unix_skb_parms *)&((skb)->cb))
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index cbd7dc01e147..145a3965341e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -689,7 +689,8 @@ static void unix_show_fdinfo(struct seq_file *m, stru=
ct socket *sock)
=20
 	if (sk) {
 		u =3D unix_sk(sock->sk);
-		seq_printf(m, "scm_fds: %u\n", READ_ONCE(u->scm_stat.nr_fds));
+		seq_printf(m, "scm_fds: %u\n",
+			   atomic_read(&u->scm_stat.nr_fds));
 	}
 }
=20
@@ -1598,10 +1599,8 @@ static void scm_stat_add(struct sock *sk, struct s=
k_buff *skb)
 	struct scm_fp_list *fp =3D UNIXCB(skb).fp;
 	struct unix_sock *u =3D unix_sk(sk);
=20
-	lockdep_assert_held(&sk->sk_receive_queue.lock);
-
 	if (unlikely(fp && fp->count))
-		u->scm_stat.nr_fds +=3D fp->count;
+		atomic_add(fp->count, &u->scm_stat.nr_fds);
 }
=20
 static void scm_stat_del(struct sock *sk, struct sk_buff *skb)
@@ -1609,10 +1608,8 @@ static void scm_stat_del(struct sock *sk, struct s=
k_buff *skb)
 	struct scm_fp_list *fp =3D UNIXCB(skb).fp;
 	struct unix_sock *u =3D unix_sk(sk);
=20
-	lockdep_assert_held(&sk->sk_receive_queue.lock);
-
 	if (unlikely(fp && fp->count))
-		u->scm_stat.nr_fds -=3D fp->count;
+		atomic_sub(fp->count, &u->scm_stat.nr_fds);
 }
=20
 /*
@@ -1801,10 +1798,8 @@ static int unix_dgram_sendmsg(struct socket *sock,=
 struct msghdr *msg,
 	if (sock_flag(other, SOCK_RCVTSTAMP))
 		__net_timestamp(skb);
 	maybe_add_creds(skb, sock, other);
-	spin_lock(&other->sk_receive_queue.lock);
 	scm_stat_add(other, skb);
-	__skb_queue_tail(&other->sk_receive_queue, skb);
-	spin_unlock(&other->sk_receive_queue.lock);
+	skb_queue_tail(&other->sk_receive_queue, skb);
 	unix_state_unlock(other);
 	other->sk_data_ready(other);
 	sock_put(other);
@@ -1906,10 +1901,8 @@ static int unix_stream_sendmsg(struct socket *sock=
, struct msghdr *msg,
 			goto pipe_err_free;
=20
 		maybe_add_creds(skb, sock, other);
-		spin_lock(&other->sk_receive_queue.lock);
 		scm_stat_add(other, skb);
-		__skb_queue_tail(&other->sk_receive_queue, skb);
-		spin_unlock(&other->sk_receive_queue.lock);
+		skb_queue_tail(&other->sk_receive_queue, skb);
 		unix_state_unlock(other);
 		other->sk_data_ready(other);
 		sent +=3D size;
@@ -2405,9 +2398,7 @@ static int unix_stream_read_generic(struct unix_str=
eam_read_state *state,
 			sk_peek_offset_bwd(sk, chunk);
=20
 			if (UNIXCB(skb).fp) {
-				spin_lock(&sk->sk_receive_queue.lock);
 				scm_stat_del(sk, skb);
-				spin_unlock(&sk->sk_receive_queue.lock);
 				unix_detach_fds(&scm, skb);
 			}
=20
--=20
2.21.1

