Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7910C632AAB
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiKURSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiKURR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:17:56 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB8C91C24
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669050980; x=1700586980;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LW9ODIn3GbGHFffiqHy20akLUoccpmbjy6VCrmzc2OI=;
  b=JKZ3m3yiuFqYVmgHkvR5JzuoA2QlLiVbamu0CLNMdiMOB5gcdGmpLZW+
   RkEuAQx9NkV4AlSh43PwmBBxPPe1F0ww4iVyUMF5nsFTZ1yqcYF41Txk+
   LFIeKfs05yaDGlI9PRci+TpcubyScfCx6r1qFv3l2aw+M6v7X/F7no7Dd
   I=;
X-IronPort-AV: E=Sophos;i="5.96,182,1665446400"; 
   d="scan'208";a="153226539"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 17:16:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com (Postfix) with ESMTPS id ECE868166A;
        Mon, 21 Nov 2022 17:16:14 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 21 Nov 2022 17:16:13 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.14) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Mon, 21 Nov 2022 17:16:11 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <tkhai@ya.ru>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH net] unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()
Date:   Mon, 21 Nov 2022 09:16:02 -0800
Message-ID: <20221121171602.31927-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <efd5147c-1add-12f0-0463-91530806ea24@ya.ru>
References: <efd5147c-1add-12f0-0463-91530806ea24@ya.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D35UWC001.ant.amazon.com (10.43.162.197) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kirill Tkhai <tkhai@ya.ru>
Date:   Sun, 20 Nov 2022 14:43:06 +0300
> On 20.11.2022 12:46, Kirill Tkhai wrote:
> > On 20.11.2022 12:09, Kuniyuki Iwashima wrote:
> >> From:   Kirill Tkhai <tkhai@ya.ru>
> >> Date:   Sun, 20 Nov 2022 02:16:47 +0300
> >>> There is a race resulting in alive SOCK_SEQPACKET socket
> >>> may change its state from TCP_ESTABLISHED to TCP_CLOSE:
> >>>
> >>> unix_release_sock(peer)                  unix_dgram_sendmsg(sk)
> >>>   sock_orphan(peer)
> >>>     sock_set_flag(peer, SOCK_DEAD)
> >>>                                            sock_alloc_send_pskb()
> >>>                                              if !(sk->sk_shutdown & SEND_SHUTDOWN)
> >>>                                                OK
> >>>                                            if sock_flag(peer, SOCK_DEAD)
> >>>                                              sk->sk_state = TCP_CLOSE
> >>>   sk->sk_shutdown = SHUTDOWN_MASK
> >>>
> >>>
> >>> After that socket sk remains almost normal: it is able to connect, listen, accept
> >>> and recvmsg, while it can't sendmsg.
> >>
> >> nit: Then, also recvmsg() fails with -ENOTCONN.  And after connect(), even
> >> both of recvmsg() and sendmsg() does not fail.
> > 
> > Possible, I wrote not clear. I mean sendmsg fails after connect, while recvmsg does not fail :)
> > Here is sendmsg abort path:
> > 
> > unix_dgram_sendmsg()
> >   sock_alloc_send_pskb()
> >     if (sk->sk_shutdown & SEND_SHUTDOWN)
> >       FAIL
> > 
> >> static int unix_seqpacket_recvmsg(struct socket *sock, struct msghdr *msg,
> >> 				  size_t size, int flags)
> >> {
> >> 	struct sock *sk = sock->sk;
> >>
> >> 	if (sk->sk_state != TCP_ESTABLISHED)
> >> 		return -ENOTCONN;
> >>
> >> 	return unix_dgram_recvmsg(sock, msg, size, flags);
> >> }
> >>
> >>
> >>>
> >>> Since this is the only possibility for alive SOCK_SEQPACKET to change
> >>> the state in such way, we should better fix this strange and potentially
> >>> danger corner case.
> >>>
> >>> Also, move TCP_CLOSE assignment for SOCK_DGRAM sockets under state lock.
> >>>
> >>> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
> >>
> >> Fixes tag is needed:
> >>
> >> Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")
> >>> Before this commit, there was no state change and SEQPACKET sk also went
> >> through the same path.  The bug was introduced because the commit did not
> >> consider SEAPACKET.
> >>
> >> So, I think the fix should be like below, then we can free the peer faster.
> >> Note unix_dgram_peer_wake_disconnect_wakeup() is dgram-specific too.
> >>
> >> ---8<---
> >> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> >> index b3545fc68097..be40023a61fb 100644
> >> --- a/net/unix/af_unix.c
> >> +++ b/net/unix/af_unix.c
> >> @@ -2001,11 +2001,14 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
> >>  		err = 0;
> >>  		if (unix_peer(sk) == other) {
> >>  			unix_peer(sk) = NULL;
> >> -			unix_dgram_peer_wake_disconnect_wakeup(sk, other);
> >> +
> >> +			if (sk->sk_type == SOCK_DGRAM) {
> >> +				unix_dgram_peer_wake_disconnect_wakeup(sk, other);
> >> +				sk->sk_state = TCP_CLOSE;
> >> +			}
> >>  
> >>  			unix_state_unlock(sk);
> >>  
> >> -			sk->sk_state = TCP_CLOSE;
> >>  			unix_dgram_disconnected(sk, other);
> >>  			sock_put(other);
> >>  			err = -ECONNREFUSED;
> >> ---8<---
> >>
> >> Also, it's better to mention that moving TCP_CLOSE under the lock resolves
> >> another rare race with unix_dgram_connect() for DGRAM sk:
> >>
> >>   unix_state_unlock(sk);
> >>   <--------------------------> connect() could set TCP_ESTABLISHED here.
> >>   sk->sk_state = TCP_CLOSE;
> > 
> > Sounds good, I'll test this variant. Thanks!
> 
> Thinking again, I'd argue about disconnecting from peer (unix_peer(sk) = NULL) here.
> Normally, unix_dgram_sendmsg() never came here like I wrote:
> 
>  unix_dgram_sendmsg()
>    sock_alloc_send_pskb()
>      if (sk->sk_shutdown & SEND_SHUTDOWN)
>        FAIL with EPIPE
> 
> So, this optimization will work very rare, it fact there will not real performance profit.
> But this creates a cornet case (safe but corner), which seems not good. Corner cases are not
> good in general.
> 
> I'd leave an original variant. What do you think about this?

I think there is no good reason to delay freeing unused memory, not only
sock_put(other), unix_dgram_disconnected() frees sk->sk_receive_queue.

And if peer is cleared, we need not call sock_alloc_send_pskb() and
return earlier with -ENOTCONN in the following sendmsg()s.  It's easy
to read because we need not dive into another layer implemented in
sock_alloc_send_pskb().

Also, at least, the code has been safe for decades, and if we don't
clear peer and sk_receive_queue, we have to check other places if
there are sanity checks for such cases.  IMHO, we should minimize the
risk if the patch is for -stable.

Thank you.


> 
> Kirill
> 
> >>> ---
> >>>  net/unix/af_unix.c |   11 +++++++++--
> >>>  1 file changed, 9 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> >>> index b3545fc68097..6fd745cfc492 100644
> >>> --- a/net/unix/af_unix.c
> >>> +++ b/net/unix/af_unix.c
> >>> @@ -1999,13 +1999,20 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
> >>>  			unix_state_lock(sk);
> >>>  
> >>>  		err = 0;
> >>> -		if (unix_peer(sk) == other) {
> >>> +		if (sk->sk_type == SOCK_SEQPACKET) {
> >>> +			/* We are here only when racing with unix_release_sock()
> >>> +			 * is clearing @other. Never change state to TCP_CLOSE
> >>> +			 * unlike SOCK_DGRAM wants.
> >>> +			 */
> >>> +			unix_state_unlock(sk);
> >>> +			err = -EPIPE;
> >>> +		} else if (unix_peer(sk) == other) {
> >>>  			unix_peer(sk) = NULL;
> >>>  			unix_dgram_peer_wake_disconnect_wakeup(sk, other);
> >>>  
> >>> +			sk->sk_state = TCP_CLOSE;
> >>>  			unix_state_unlock(sk);
> >>>  
> >>> -			sk->sk_state = TCP_CLOSE;
> >>>  			unix_dgram_disconnected(sk, other);
> >>>  			sock_put(other);
> >>>  			err = -ECONNREFUSED;
