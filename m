Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF16A6E5661
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 03:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjDRBYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 21:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjDRBYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 21:24:43 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736A644AB
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 18:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681781080; x=1713317080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mqODA4ZqlVeCeGvY+5HNbSlv13C7snY1bZz/qMjmvfM=;
  b=ttxGIslFGo2csKudXQu8X8LZsdRi1uIrBWN0ml1a31EB+yg/i5lkUo+l
   Xc6VpARCEDsASdDV4sd61qMKQ3sfK4b0UBP6+4uQsCI8BX7M8kPK+XDp4
   kyGsHFDYi/r56tm6rYf9J596eP5ieE8X5ZMOhA0q+iJadt8i4fVO2jUSQ
   Q=;
X-IronPort-AV: E=Sophos;i="5.99,205,1677542400"; 
   d="scan'208";a="205436333"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1box-1dm6-7f722725.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2023 01:24:36 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1box-1dm6-7f722725.us-east-1.amazon.com (Postfix) with ESMTPS id 6087480D38;
        Tue, 18 Apr 2023 01:24:33 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 18 Apr 2023 01:24:32 +0000
Received: from 88665a182662.ant.amazon.com (10.94.51.151) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 18 Apr 2023 01:24:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <willemdebruijn.kernel@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzkaller@googlegroups.com>, <willemb@google.com>
Subject: RE: [PATCH v1 net] udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.
Date:   Mon, 17 Apr 2023 18:24:21 -0700
Message-ID: <20230418012421.86283-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <643de9b9bc7d4_2f58012942e@willemb.c.googlers.com.notmuch>
References: <643de9b9bc7d4_2f58012942e@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.94.51.151]
X-ClientProxiedBy: EX19D040UWA002.ant.amazon.com (10.13.139.113) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 17 Apr 2023 20:52:09 -0400
> Kuniyuki Iwashima wrote:
> > From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Date:   Mon, 17 Apr 2023 19:28:25 -0400
> > > Kuniyuki Iwashima wrote:
> > > > From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > > > Date:   Mon, 17 Apr 2023 17:53:33 -0400
> > > > > Kuniyuki Iwashima wrote:
> > > > > > From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > > > > > Date:   Mon, 17 Apr 2023 16:36:20 -0400
> > > > > > > Kuniyuki Iwashima wrote:
> > > > > > > > syzkaller reported [0] memory leaks of an UDP socket and ZEROCOPY
> > > > > > > > skbs.  We can reproduce the problem with these sequences:
> > > > > > > > 
> > > > > > > >   sk = socket(AF_INET, SOCK_DGRAM, 0)
> > > > > > > >   sk.setsockopt(SOL_SOCKET, SO_TIMESTAMPING, SOF_TIMESTAMPING_TX_SOFTWARE)
> > > > > > > >   sk.setsockopt(SOL_SOCKET, SO_ZEROCOPY, 1)
> > > > > > > >   sk.sendto(b'', MSG_ZEROCOPY, ('127.0.0.1', 53))
> > > > > > > >   sk.close()
> > > > > > > > 
> > > > > > > > sendmsg() calls msg_zerocopy_alloc(), which allocates a skb, sets
> > > > > > > > skb->cb->ubuf.refcnt to 1, and calls sock_hold().  Here, struct
> > > > > > > > ubuf_info_msgzc indirectly holds a refcnt of the socket.  When the
> > > > > > > > skb is sent, __skb_tstamp_tx() clones it and puts the clone into
> > > > > > > > the socket's error queue with the TX timestamp.
> > > > > > > > 
> > > > > > > > When the original skb is received locally, skb_copy_ubufs() calls
> > > > > > > > skb_unclone(), and pskb_expand_head() increments skb->cb->ubuf.refcnt.
> > > > > > > > This additional count is decremented while freeing the skb, but struct
> > > > > > > > ubuf_info_msgzc still has a refcnt, so __msg_zerocopy_callback() is
> > > > > > > > not called.
> > > > > > > > 
> > > > > > > > The last refcnt is not released unless we retrieve the TX timestamped
> > > > > > > > skb by recvmsg().  When we close() the socket holding such skb, we
> > > > > > > > never call sock_put() and leak the count, skb, and sk.
> > > > > > > > 
> > > > > > > > To avoid this problem, we must call skb_queue_purge() while we close()
> > > > > > > > UDP sockets.
> > > > > > > > 
> > > > > > > > Note that TCP does not have this problem because skb_queue_purge() is
> > > > > > > > called by sk_stream_kill_queues() during close().
> > > > > > > 
> > > > > > > Thanks for the clear description.
> > > > > > > 
> > > > > > > So the issue is that the tx timestamp notification is still queued on
> > > > > > > the error queue and this is not freed on socket destruction.
> > > > > > > 
> > > > > > > That surprises me. The error definitely needs to be purged on socket
> > > > > > > destruction. And it is, called in inet_sock_destruct, which is called
> > > > > > > udp_destruct_sock.
> > > > > > > 
> > > > > > > The issue here is that there is a circular dependency, where the
> > > > > > > sk_destruct is not called until the ref count drops to zero?
> > > > > > 
> > > > > > Yes, right.
> > > > > > 
> > > > > > > 
> > > > > > > sk_stream_kill_queues is called from inet_csk_destroy_sock, from
> > > > > > > __tcp_close (and thus tcp_prot.close) among others.
> > > > > > > 
> > > > > > > purging the error queue for other sockets on .close rather than
> > > > > > > .destroy sounds good to me.
> > > > > > > 
> > > > > > > But SOF_TIMESTAMPING_TX_SOFTWARE and MSG_ZEROCOPY are not limited to
> > > > > > > TCP and UDP. So we probably need this in a more protocol independent
> > > > > > > close.
> > > > > > 
> > > > > > At least, we limit SO_ZEROCOPY to TCP, UDP and RDS for now.  Also, RDS
> > > > > > seems to just use TCP. [0]
> > > > > > 
> > > > > > ---8<---
> > > > > > 	case SO_ZEROCOPY:
> > > > > > 		if (sk->sk_family == PF_INET || sk->sk_family == PF_INET6) {
> > > > > > 			if (!(sk_is_tcp(sk) ||
> > > > > > 			      (sk->sk_type == SOCK_DGRAM &&
> > > > > > 			       sk->sk_protocol == IPPROTO_UDP)))
> > > > > > 				ret = -EOPNOTSUPP;
> > > > > > 		} else if (sk->sk_family != PF_RDS) {
> > > > > > 			ret = -EOPNOTSUPP;
> > > > > > 		}
> > > > > > 		if (!ret) {
> > > > > > 			if (val < 0 || val > 1)
> > > > > > 				ret = -EINVAL;
> > > > > > 			else
> > > > > > 				sock_valbool_flag(sk, SOCK_ZEROCOPY, valbool);
> > > > > > 		}
> > > > > > 		break;
> > > > > > ---8<---
> > > > > > 
> > > > > > [0]: https://lore.kernel.org/netdev/cover.1518718761.git.sowmini.varadhan@oracle.com/
> > > > > 
> > > > > Good point, thanks. I used to experiment with more protocols, as can
> > > > > be seen from msg_zerocopy.c. But those are thankfully not relevant.
> > > > > > 
> > > > > > Thanks,
> > > > > > Kuniyuki
> > > > > > 
> > > > > > 
> > > > > > > 
> > > > > > > > [0]:
> > > > > > > > BUG: memory leak
> > > > > > > > unreferenced object 0xffff88800c6d2d00 (size 1152):
> > > > > > > >   comm "syz-executor392", pid 264, jiffies 4294785440 (age 13.044s)
> > > > > > > >   hex dump (first 32 bytes):
> > > > > > > >     00 00 00 00 00 00 00 00 cd af e8 81 00 00 00 00  ................
> > > > > > > >     02 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
> > > > > > > >   backtrace:
> > > > > > > >     [<0000000055636812>] sk_prot_alloc+0x64/0x2a0 net/core/sock.c:2024
> > > > > > > >     [<0000000054d77b7a>] sk_alloc+0x3b/0x800 net/core/sock.c:2083
> > > > > > > >     [<0000000066f3c7e0>] inet_create net/ipv4/af_inet.c:319 [inline]
> > > > > > > >     [<0000000066f3c7e0>] inet_create+0x31e/0xe40 net/ipv4/af_inet.c:245
> > > > > > > >     [<000000009b83af97>] __sock_create+0x2ab/0x550 net/socket.c:1515
> > > > > > > >     [<00000000b9b11231>] sock_create net/socket.c:1566 [inline]
> > > > > > > >     [<00000000b9b11231>] __sys_socket_create net/socket.c:1603 [inline]
> > > > > > > >     [<00000000b9b11231>] __sys_socket_create net/socket.c:1588 [inline]
> > > > > > > >     [<00000000b9b11231>] __sys_socket+0x138/0x250 net/socket.c:1636
> > > > > > > >     [<000000004fb45142>] __do_sys_socket net/socket.c:1649 [inline]
> > > > > > > >     [<000000004fb45142>] __se_sys_socket net/socket.c:1647 [inline]
> > > > > > > >     [<000000004fb45142>] __x64_sys_socket+0x73/0xb0 net/socket.c:1647
> > > > > > > >     [<0000000066999e0e>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > > > > > > >     [<0000000066999e0e>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
> > > > > > > >     [<0000000017f238c1>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > > > > > > 
> > > > > > > > BUG: memory leak
> > > > > > > > unreferenced object 0xffff888017633a00 (size 240):
> > > > > > > >   comm "syz-executor392", pid 264, jiffies 4294785440 (age 13.044s)
> > > > > > > >   hex dump (first 32 bytes):
> > > > > > > >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > > > > > >     00 00 00 00 00 00 00 00 00 2d 6d 0c 80 88 ff ff  .........-m.....
> > > > > > > >   backtrace:
> > > > > > > >     [<000000002b1c4368>] __alloc_skb+0x229/0x320 net/core/skbuff.c:497
> > > > > > > >     [<00000000143579a6>] alloc_skb include/linux/skbuff.h:1265 [inline]
> > > > > > > >     [<00000000143579a6>] sock_omalloc+0xaa/0x190 net/core/sock.c:2596
> > > > > > > >     [<00000000be626478>] msg_zerocopy_alloc net/core/skbuff.c:1294 [inline]
> > > > > > > >     [<00000000be626478>] msg_zerocopy_realloc+0x1ce/0x7f0 net/core/skbuff.c:1370
> > > > > > > >     [<00000000cbfc9870>] __ip_append_data+0x2adf/0x3b30 net/ipv4/ip_output.c:1037
> > > > > > > >     [<0000000089869146>] ip_make_skb+0x26c/0x2e0 net/ipv4/ip_output.c:1652
> > > > > > > >     [<00000000098015c2>] udp_sendmsg+0x1bac/0x2390 net/ipv4/udp.c:1253
> > > > > > > >     [<0000000045e0e95e>] inet_sendmsg+0x10a/0x150 net/ipv4/af_inet.c:819
> > > > > > > >     [<000000008d31bfde>] sock_sendmsg_nosec net/socket.c:714 [inline]
> > > > > > > >     [<000000008d31bfde>] sock_sendmsg+0x141/0x190 net/socket.c:734
> > > > > > > >     [<0000000021e21aa4>] __sys_sendto+0x243/0x360 net/socket.c:2117
> > > > > > > >     [<00000000ac0af00c>] __do_sys_sendto net/socket.c:2129 [inline]
> > > > > > > >     [<00000000ac0af00c>] __se_sys_sendto net/socket.c:2125 [inline]
> > > > > > > >     [<00000000ac0af00c>] __x64_sys_sendto+0xe1/0x1c0 net/socket.c:2125
> > > > > > > >     [<0000000066999e0e>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > > > > > > >     [<0000000066999e0e>] do_syscall_64+0x38/0x90 arch/x86/entry/common.c:80
> > > > > > > >     [<0000000017f238c1>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > > > > > > 
> > > > > > > > Fixes: b5947e5d1e71 ("udp: msg_zerocopy")
> > > > > > > > Reported-by: syzbot <syzkaller@googlegroups.com>
> > > > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > > > > > ---
> > > > > > > >  include/net/udp.h | 5 +++++
> > > > > > > >  1 file changed, 5 insertions(+)
> > > > > > > > 
> > > > > > > > diff --git a/include/net/udp.h b/include/net/udp.h
> > > > > > > > index de4b528522bb..b9182f166b2f 100644
> > > > > > > > --- a/include/net/udp.h
> > > > > > > > +++ b/include/net/udp.h
> > > > > > > > @@ -195,6 +195,11 @@ void udp_lib_rehash(struct sock *sk, u16 new_hash);
> > > > > > > >  
> > > > > > > >  static inline void udp_lib_close(struct sock *sk, long timeout)
> > > > > > > >  {
> > > > > > > > +	/* A zerocopy skb has a refcnt of sk and may be
> > > > > > > > +	 * put into sk_error_queue with TX timestamp
> > > > > > > > +	 */
> > > > > > > > +	skb_queue_purge(&sk->sk_error_queue);
> > > > > > > > +
> > > > > > > >  	sk_common_release(sk);
> > > > > > > >  }
> > > > > 
> > > > > Does this leave a race, where another completion may be queued between
> > > > > skb_queue_purge and the eventual sock_put in sk_common_release?
> > > > 
> > > > I thought udp_send_skb() returns only after TX completion, and
> > > > ->release() will never called while file is accessed by sendmsg().
> > > 
> > > udp_send_skb (and the sendmsg) syscall returns immediately sending
> > > the packet.
> > > 
> > > The packets I'm concerned about are those queued in a qdisc or the
> > > device, waiting for a completion.
> > 
> > Ah, I got your point.
> > 
> > So, we need to make sure TX tstamp is not queued if SOCK_DEAD is
> > flagged and we purge the queue only after marking SOCK_DEAD ?
> 
> Exactly. Thanks for the sketch.
> 
> Ideally without having to take an extra lock in the common path.
> sk_commmon_release calls sk_prot->destroy == udp_destroy_sock,
> which already sets SOCK_DEAD.
> 
> Could we move the skb_queue_purge in there? That is also what
> calls udp_flush_pending_frames.

Yes, that makes sense.

I was thinking if we need a memory barrier for SOCK_DEAD to sync
with TX, which reads it locklessly.  Maybe we should check SOCK_DEAD
with sk->sk_error_queue.lock held ?

And I forgot to return error from sock_queue_err_skb() to free skb
in __skb_complete_tx_timestamp().

---8<---
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4c0879798eb8..287b834df9c8 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4979,6 +4979,8 @@ static void skb_set_err_queue(struct sk_buff *skb)
  */
 int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
 {
+	unsigned long flags;
+
 	if (atomic_read(&sk->sk_rmem_alloc) + skb->truesize >=
 	    (unsigned int)READ_ONCE(sk->sk_rcvbuf))
 		return -ENOMEM;
@@ -4992,9 +4994,16 @@ int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
 	/* before exiting rcu section, make sure dst is refcounted */
 	skb_dst_force(skb);
 
-	skb_queue_tail(&sk->sk_error_queue, skb);
-	if (!sock_flag(sk, SOCK_DEAD))
-		sk_error_report(sk);
+	spin_lock_irqsave(&sk->sk_error_queue.lock, flags);
+	if (sock_flag(sk, SOCK_DEAD)) {
+		spin_unlock_irqrestore(&sk->sk_error_queue.lock, flags);
+		return -EINVAL;
+	}
+	__skb_queue_tail(&sk->sk_error_queue, skb);
+	spin_unlock_irqrestore(&sk->sk_error_queue.lock, flags);
+
+	sk_error_report(sk);
+
 	return 0;
 }
 EXPORT_SYMBOL(sock_queue_err_skb);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c605d171eb2d..7060a5cda711 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2674,6 +2674,11 @@ void udp_destroy_sock(struct sock *sk)
 		if (up->encap_enabled)
 			static_branch_dec(&udp_encap_needed_key);
 	}
+
+	/* A zerocopy skb has a refcnt of sk and may be
+	 * put into sk_error_queue with TX timestamp
+	 */
+	skb_queue_purge(&sk->sk_error_queue);
 }
 
 /*
---8<---
