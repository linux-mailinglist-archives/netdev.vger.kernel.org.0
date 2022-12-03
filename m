Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D31641602
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 11:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiLCKku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 05:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiLCKkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 05:40:49 -0500
X-Greylist: delayed 353 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 03 Dec 2022 02:40:47 PST
Received: from forward500o.mail.yandex.net (forward500o.mail.yandex.net [37.140.190.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EAE58BDC
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 02:40:47 -0800 (PST)
Received: from iva8-56bd2512c3ca.qloud-c.yandex.net (iva8-56bd2512c3ca.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a8a6:0:640:56bd:2512])
        by forward500o.mail.yandex.net (Yandex) with ESMTP id 7C7F0941199;
        Sat,  3 Dec 2022 13:34:52 +0300 (MSK)
Received: by iva8-56bd2512c3ca.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id oYRxFMVZHqM1-SvSd4DVy;
        Sat, 03 Dec 2022 13:34:51 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1670063691;
        bh=0r0nkrLVjUxYawipZEDUdW5/+AWuHbDfClaOlTCGamg=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=YGCQrYw06sNO1eaGwTf7lLpj1KFPqryPGZQmwOIkx2yWVAME3Pvolp0kz3CB3tJke
         P43FEIF9g8YJAo0g0vVL/7AIAg87xbzHzeMgCYKzaSLDq/cISKWFVHWkMZifgdD7TK
         KP5vxbI+LYhVZKGrvrDHpC/eJg0By3H4n5PiKhmc=
Authentication-Results: iva8-56bd2512c3ca.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Message-ID: <b7288912-af85-3fb8-6a68-cda4be0c34fc@ya.ru>
Date:   Sat, 3 Dec 2022 13:34:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net] unix: Fix race in SOCK_SEQPACKET's
 unix_dgram_sendmsg()
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
References: <efd5147c-1add-12f0-0463-91530806ea24@ya.ru>
 <20221121171602.31927-1-kuniyu@amazon.com>
Content-Language: en-US
From:   Kirill Tkhai <tkhai@ya.ru>
In-Reply-To: <20221121171602.31927-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.11.2022 20:16, Kuniyuki Iwashima wrote:
> From:   Kirill Tkhai <tkhai@ya.ru>
> Date:   Sun, 20 Nov 2022 14:43:06 +0300
>> On 20.11.2022 12:46, Kirill Tkhai wrote:
>>> On 20.11.2022 12:09, Kuniyuki Iwashima wrote:
>>>> From:   Kirill Tkhai <tkhai@ya.ru>
>>>> Date:   Sun, 20 Nov 2022 02:16:47 +0300
>>>>> There is a race resulting in alive SOCK_SEQPACKET socket
>>>>> may change its state from TCP_ESTABLISHED to TCP_CLOSE:
>>>>>
>>>>> unix_release_sock(peer)                  unix_dgram_sendmsg(sk)
>>>>>   sock_orphan(peer)
>>>>>     sock_set_flag(peer, SOCK_DEAD)
>>>>>                                            sock_alloc_send_pskb()
>>>>>                                              if !(sk->sk_shutdown & SEND_SHUTDOWN)
>>>>>                                                OK
>>>>>                                            if sock_flag(peer, SOCK_DEAD)
>>>>>                                              sk->sk_state = TCP_CLOSE
>>>>>   sk->sk_shutdown = SHUTDOWN_MASK
>>>>>
>>>>>
>>>>> After that socket sk remains almost normal: it is able to connect, listen, accept
>>>>> and recvmsg, while it can't sendmsg.
>>>>
>>>> nit: Then, also recvmsg() fails with -ENOTCONN.  And after connect(), even
>>>> both of recvmsg() and sendmsg() does not fail.
>>>
>>> Possible, I wrote not clear. I mean sendmsg fails after connect, while recvmsg does not fail :)
>>> Here is sendmsg abort path:
>>>
>>> unix_dgram_sendmsg()
>>>   sock_alloc_send_pskb()
>>>     if (sk->sk_shutdown & SEND_SHUTDOWN)
>>>       FAIL
>>>
>>>> static int unix_seqpacket_recvmsg(struct socket *sock, struct msghdr *msg,
>>>> 				  size_t size, int flags)
>>>> {
>>>> 	struct sock *sk = sock->sk;
>>>>
>>>> 	if (sk->sk_state != TCP_ESTABLISHED)
>>>> 		return -ENOTCONN;
>>>>
>>>> 	return unix_dgram_recvmsg(sock, msg, size, flags);
>>>> }
>>>>
>>>>
>>>>>
>>>>> Since this is the only possibility for alive SOCK_SEQPACKET to change
>>>>> the state in such way, we should better fix this strange and potentially
>>>>> danger corner case.
>>>>>
>>>>> Also, move TCP_CLOSE assignment for SOCK_DGRAM sockets under state lock.
>>>>>
>>>>> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
>>>>
>>>> Fixes tag is needed:
>>>>
>>>> Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")
>>>>> Before this commit, there was no state change and SEQPACKET sk also went
>>>> through the same path.  The bug was introduced because the commit did not
>>>> consider SEAPACKET.
>>>>
>>>> So, I think the fix should be like below, then we can free the peer faster.
>>>> Note unix_dgram_peer_wake_disconnect_wakeup() is dgram-specific too.
>>>>
>>>> ---8<---
>>>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>>>> index b3545fc68097..be40023a61fb 100644
>>>> --- a/net/unix/af_unix.c
>>>> +++ b/net/unix/af_unix.c
>>>> @@ -2001,11 +2001,14 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
>>>>  		err = 0;
>>>>  		if (unix_peer(sk) == other) {
>>>>  			unix_peer(sk) = NULL;
>>>> -			unix_dgram_peer_wake_disconnect_wakeup(sk, other);
>>>> +
>>>> +			if (sk->sk_type == SOCK_DGRAM) {
>>>> +				unix_dgram_peer_wake_disconnect_wakeup(sk, other);
>>>> +				sk->sk_state = TCP_CLOSE;
>>>> +			}
>>>>  
>>>>  			unix_state_unlock(sk);
>>>>  
>>>> -			sk->sk_state = TCP_CLOSE;
>>>>  			unix_dgram_disconnected(sk, other);
>>>>  			sock_put(other);
>>>>  			err = -ECONNREFUSED;
>>>> ---8<---
>>>>
>>>> Also, it's better to mention that moving TCP_CLOSE under the lock resolves
>>>> another rare race with unix_dgram_connect() for DGRAM sk:
>>>>
>>>>   unix_state_unlock(sk);
>>>>   <--------------------------> connect() could set TCP_ESTABLISHED here.
>>>>   sk->sk_state = TCP_CLOSE;
>>>
>>> Sounds good, I'll test this variant. Thanks!
>>
>> Thinking again, I'd argue about disconnecting from peer (unix_peer(sk) = NULL) here.
>> Normally, unix_dgram_sendmsg() never came here like I wrote:
>>
>>  unix_dgram_sendmsg()
>>    sock_alloc_send_pskb()
>>      if (sk->sk_shutdown & SEND_SHUTDOWN)
>>        FAIL with EPIPE
>>
>> So, this optimization will work very rare, it fact there will not real performance profit.
>> But this creates a cornet case (safe but corner), which seems not good. Corner cases are not
>> good in general.
>>
>> I'd leave an original variant. What do you think about this?
> 
> I think there is no good reason to delay freeing unused memory, not only
> sock_put(other), unix_dgram_disconnected() frees sk->sk_receive_queue.

Hm, it's not about freeing memory. This optimization will work almost never, because of the probability
to get into this is very small. This just adds additional race condition, which is bad from any side.

So, finally I don't like this, sorry.

Thanks for your opinion.
Kirill

> And if peer is cleared, we need not call sock_alloc_send_pskb() and
> return earlier with -ENOTCONN in the following sendmsg()s.  It's easy
> to read because we need not dive into another layer implemented in
> sock_alloc_send_pskb().
> 
> Also, at least, the code has been safe for decades, and if we don't
> clear peer and sk_receive_queue, we have to check other places if
> there are sanity checks for such cases.  IMHO, we should minimize the
> risk if the patch is for -stable.

