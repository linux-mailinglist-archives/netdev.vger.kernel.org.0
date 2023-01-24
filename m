Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CAA67A490
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 22:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjAXVF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 16:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjAXVF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 16:05:57 -0500
Received: from forward500b.mail.yandex.net (forward500b.mail.yandex.net [178.154.239.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD29E05D
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 13:05:54 -0800 (PST)
Received: from sas8-92ddc00f49ef.qloud-c.yandex.net (sas8-92ddc00f49ef.qloud-c.yandex.net [IPv6:2a02:6b8:c1b:2988:0:640:92dd:c00f])
        by forward500b.mail.yandex.net (Yandex) with ESMTP id EA1355EF6B;
        Wed, 25 Jan 2023 00:05:43 +0300 (MSK)
Received: by sas8-92ddc00f49ef.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id f5Wnv93YDiE1-9G1XHwIL;
        Wed, 25 Jan 2023 00:05:43 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1674594343;
        bh=OBDdjRcjw6LpfMzA76rXxFKk9M/9wv53LkE16JaD5/k=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=j4hBthzeC14euo68JJoN9oidVJWRY+fYNJVmcTT5OOEi+E4WI2GnkgEpectYrdo36
         sejiPG8fGmgbGT02kzDkjzaIZnB2hsb6O1ngm1zhSfPnAr8Ynot2MvrtEfRMgzAuvL
         Efvzq15u/6vxlBnTFBreNDaswX6l8NebCp24z234=
Authentication-Results: sas8-92ddc00f49ef.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Message-ID: <a145e41c-a997-cbcc-a456-d9efdf06e3fa@ya.ru>
Date:   Wed, 25 Jan 2023 00:05:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next] unix: Guarantee sk_state relevance in case of it
 was assigned by a task on other cpu
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, gorcunov@gmail.com,
        kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
References: <72ae40ef-2d68-2e89-46d3-fc8f820db42a@ya.ru>
 <20230124175712.38112-1-kuniyu@amazon.com>
Content-Language: en-US
From:   Kirill Tkhai <tkhai@ya.ru>
In-Reply-To: <20230124175712.38112-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kuniyuki,

On 24.01.2023 20:57, Kuniyuki Iwashima wrote:
> From:   Kirill Tkhai <tkhai@ya.ru>
> Date:   Mon, 23 Jan 2023 01:21:20 +0300
>> Some functions use unlocked check for sock::sk_state. This does not guarantee
>> a new value assigned to sk_state on some CPU is already visible on this CPU.
>>
>> Example:
>>
>> [CPU0:Task0]                    [CPU1:Task1]
>> unix_listen()
>>   unix_state_lock(sk);
>>   sk->sk_state = TCP_LISTEN;
>>   unix_state_unlock(sk);
>>                                 unix_accept()
>>                                   if (sk->sk_state != TCP_LISTEN) /* not visible */
>>                                      goto out;                    /* return error */
>>
>> Task1 may miss new sk->sk_state value, and then unix_accept() returns error.
>> Since in this situation unix_accept() is called chronologically later, such
>> behavior is not obvious and it is wrong.
> 
> Have you seen this on a real workload ?

No, I haven't seen. This is my observation on current code, which I made during work
on recent scm_fds patch.

> It sounds like a userspace bug that accept() is called on a different
> CPU before listen() returns.  At least, accept() is fetching sk at the
> same time, then I think there should be no guarantee that sk_state is
> TCP_LISTEN.
>
> Same for other TCP_ESTABLISHED tests, it seems a program is calling
> sendmsg()/recvmsg() when sk is still TCP_CLOSE and betting concurrent
> connect() will finish earlier.

Not exactly. This is not about the case of "accept() is called before listen() returns".
This is about "accept is called after listen returns".

 unix_listen()
   unix_state_lock(sk);
   sk->sk_state = TCP_LISTEN;
   unix_state_unlock(sk);

 <<returned from syscall>>
                                 unix_accept()
                                   if (sk->sk_state != TCP_LISTEN) /* not visible */
                                      goto out;                    /* return error */

A syscall enter and exit do not imply any memory barriers. New sk_state in unix_accept()
may be not visible.

Speaking about other cases. Even changes made by three sequential syscalls connect(),
accept() and sendmsg() may be not visible on other CPU:

CPU0                                   CPU1                 CPU2
connect(sk)
  sk2->sk_state = TCP_ESTABLISHED                     
sendmsg(sk)
                                       sk2 = accept()
                                                            read("fdinfo of sk2")
                                                              sk2->sk_state is not visible

There are a lot of possibilities of smp reordering in recvmsg().


CPU0                                  CPU1                 CPU2
connect(sk)
  sk2->sk_state = TCP_ESTABLISHED                     
sendmsg(sk)
                                      sk2 = accept()
                                   
                                                           sk2 = pidfd_getfd("fd of sk2)
                                                           ioctl(sk2, SIOCATMARK, &answ) -> answ=1
                                                           if (answ)
                                                             recvmsg(sk2) --> TCP_ESTABLISHED is not visible

^^^ in this example there is also smp reordering between answ and sk_state

There are a lot of cases. We should not wait for real appearance, because this may appear on !x86 cpus,
and this may result in long and difficult debug for users. We should provide stable interfaces for them.

The big advantage is this should not affect performance, since generic case still goes thru unlocked
fastpath case.

Kirill
 
>>
>> This patch aims to fix the problem. A new function unix_sock_state() is
>> introduced, and it makes sure a user never misses a new state assigned just
>> before the function is called. We will use it in the places, where unlocked
>> sk_state dereferencing was used before.
>>
>> Note, that there remain some more places with sk_state unfixed. Also, the same
>> problem is with unix_peer(). This will be a subject for future patches.
>>
>> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
>> ---
>>  net/unix/af_unix.c |   43 +++++++++++++++++++++++++++++++------------
>>  1 file changed, 31 insertions(+), 12 deletions(-)
>>
>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>> index 009616fa0256..f53e09a0753b 100644
>> --- a/net/unix/af_unix.c
>> +++ b/net/unix/af_unix.c
>> @@ -247,6 +247,28 @@ struct sock *unix_peer_get(struct sock *s)
>>  }
>>  EXPORT_SYMBOL_GPL(unix_peer_get);
>>  
>> +/* This function returns current sk->sk_state guaranteeing
>> + * its relevance in case of assignment was made on other CPU.
>> + */
>> +static unsigned char unix_sock_state(struct sock *sk)
>> +{
>> +	unsigned char s_state = READ_ONCE(sk->sk_state);
>> +
>> +	/* SOCK_STREAM and SOCK_SEQPACKET sockets never change their
>> +	 * sk_state after switching to TCP_ESTABLISHED or TCP_LISTEN.
>> +	 * We may avoid taking the lock in case of those states are
>> +	 * already visible.
>> +	 */
>> +	if ((s_state == TCP_ESTABLISHED || s_state == TCP_LISTEN)
>> +	    && sk->sk_type != SOCK_DGRAM)
>> +		return s_state;
>> +
>> +	unix_state_lock(sk);
>> +	s_state = sk->sk_state;
>> +	unix_state_unlock(sk);
>> +	return s_state;
>> +}
>> +
>>  static struct unix_address *unix_create_addr(struct sockaddr_un *sunaddr,
>>  					     int addr_len)
>>  {
>> @@ -812,13 +834,9 @@ static void unix_show_fdinfo(struct seq_file *m, struct socket *sock)
>>  	int nr_fds = 0;
>>  
>>  	if (sk) {
>> -		s_state = READ_ONCE(sk->sk_state);
>> +		s_state = unix_sock_state(sk);
>>  		u = unix_sk(sk);
>>  
>> -		/* SOCK_STREAM and SOCK_SEQPACKET sockets never change their
>> -		 * sk_state after switching to TCP_ESTABLISHED or TCP_LISTEN.
>> -		 * SOCK_DGRAM is ordinary. So, no lock is needed.
>> -		 */
>>  		if (sock->type == SOCK_DGRAM || s_state == TCP_ESTABLISHED)
>>  			nr_fds = atomic_read(&u->scm_stat.nr_fds);
>>  		else if (s_state == TCP_LISTEN)
>> @@ -1686,7 +1704,7 @@ static int unix_accept(struct socket *sock, struct socket *newsock, int flags,
>>  		goto out;
>>  
>>  	err = -EINVAL;
>> -	if (sk->sk_state != TCP_LISTEN)
>> +	if (unix_sock_state(sk) != TCP_LISTEN)
>>  		goto out;
>>  
>>  	/* If socket state is TCP_LISTEN it cannot change (for now...),
>> @@ -2178,7 +2196,8 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>>  	}
>>  
>>  	if (msg->msg_namelen) {
>> -		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
>> +		unsigned char s_state = unix_sock_state(sk);
>> +		err = s_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
> 
> No need to define s_state here, or a blank line is needed after
> the definition.
> https://patchwork.kernel.org/project/netdevbpf/patch/72ae40ef-2d68-2e89-46d3-fc8f820db42a@ya.ru/
> 
>>  		goto out_err;
>>  	} else {
>>  		err = -ENOTCONN;
>> @@ -2279,7 +2298,7 @@ static ssize_t unix_stream_sendpage(struct socket *socket, struct page *page,
>>  		return -EOPNOTSUPP;
>>  
>>  	other = unix_peer(sk);
>> -	if (!other || sk->sk_state != TCP_ESTABLISHED)
>> +	if (!other || unix_sock_state(sk) != TCP_ESTABLISHED)
>>  		return -ENOTCONN;
>>  
>>  	if (false) {
>> @@ -2391,7 +2410,7 @@ static int unix_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,
>>  	if (err)
>>  		return err;
>>  
>> -	if (sk->sk_state != TCP_ESTABLISHED)
>> +	if (unix_sock_state(sk) != TCP_ESTABLISHED)
>>  		return -ENOTCONN;
>>  
>>  	if (msg->msg_namelen)
>> @@ -2405,7 +2424,7 @@ static int unix_seqpacket_recvmsg(struct socket *sock, struct msghdr *msg,
>>  {
>>  	struct sock *sk = sock->sk;
>>  
>> -	if (sk->sk_state != TCP_ESTABLISHED)
>> +	if (unix_sock_state(sk) != TCP_ESTABLISHED)
>>  		return -ENOTCONN;
>>  
>>  	return unix_dgram_recvmsg(sock, msg, size, flags);
>> @@ -2689,7 +2708,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
>>  
>>  static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
>>  {
>> -	if (unlikely(sk->sk_state != TCP_ESTABLISHED))
>> +	if (unlikely(unix_sock_state(sk) != TCP_ESTABLISHED))
>>  		return -ENOTCONN;
>>  
>>  	return unix_read_skb(sk, recv_actor);
>> @@ -2713,7 +2732,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>>  	size_t size = state->size;
>>  	unsigned int last_len;
>>  
>> -	if (unlikely(sk->sk_state != TCP_ESTABLISHED)) {
>> +	if (unlikely(unix_sock_state(sk) != TCP_ESTABLISHED)) {
>>  		err = -EINVAL;
>>  		goto out;
>>  	}

