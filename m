Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443C36415F8
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 11:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiLCKhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 05:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiLCKhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 05:37:38 -0500
Received: from forward500j.mail.yandex.net (forward500j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD079231
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 02:37:32 -0800 (PST)
Received: from iva1-5283d83ef885.qloud-c.yandex.net (iva1-5283d83ef885.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:16a7:0:640:5283:d83e])
        by forward500j.mail.yandex.net (Yandex) with ESMTP id AD8C56CB65F8;
        Sat,  3 Dec 2022 13:37:30 +0300 (MSK)
Received: by iva1-5283d83ef885.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id TbRO6gVZTiE1-u3gM1tcf;
        Sat, 03 Dec 2022 13:37:29 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1670063850;
        bh=cuNfB4qlUjn9bzRNLsRajGFMhAeUNCovJsb8lc7+rcM=;
        h=In-Reply-To:Date:References:To:From:Subject:Message-ID;
        b=C3ylARcY+3EofmFlz4DkAFHLuqg1TR0KQa9FM+Jp+zeTHT8CI1IX0mvS4zeF0w7WJ
         jd5vo9ztH0p0v0LbeTV6aotjAaOL/+NTgZMPjuWNaezq60h6gvKQYdfe8Tsw1Xhy08
         HIChtZn/61I1wKrNPeSJbg3JM6HZBO6w3xIc1kMk=
Authentication-Results: iva1-5283d83ef885.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Message-ID: <d00b9876-4175-794a-4f5f-124f0d5112d3@ya.ru>
Date:   Sat, 3 Dec 2022 13:37:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net v2] unix: Fix race in SOCK_SEQPACKET's
 unix_dgram_sendmsg()
Content-Language: en-US
From:   Kirill Tkhai <tkhai@ya.ru>
To:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        Kuniyuki Iwashima <kuniyu@amazon.com>
References: <bd4d533b-15d2-6c0a-7667-70fd95dbea20@ya.ru>
 <7f1277b54a76280cfdaa25d0765c825d665146b9.camel@redhat.com>
 <b7172d71-5f64-104e-48cc-3e6b07ba75ac@ya.ru>
In-Reply-To: <b7172d71-5f64-104e-48cc-3e6b07ba75ac@ya.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.12.2022 01:43, Kirill Tkhai wrote:
> On 01.12.2022 12:30, Paolo Abeni wrote:
>> On Sun, 2022-11-27 at 01:46 +0300, Kirill Tkhai wrote:
>>> There is a race resulting in alive SOCK_SEQPACKET socket
>>> may change its state from TCP_ESTABLISHED to TCP_CLOSE:
>>>
>>> unix_release_sock(peer)                  unix_dgram_sendmsg(sk)
>>>   sock_orphan(peer)
>>>     sock_set_flag(peer, SOCK_DEAD)
>>>                                            sock_alloc_send_pskb()
>>>                                              if !(sk->sk_shutdown & SEND_SHUTDOWN)
>>>                                                OK
>>>                                            if sock_flag(peer, SOCK_DEAD)
>>>                                              sk->sk_state = TCP_CLOSE
>>>   sk->sk_shutdown = SHUTDOWN_MASK
>>>
>>>
>>> After that socket sk remains almost normal: it is able to connect, listen, accept
>>> and recvmsg, while it can't sendmsg.
>>>
>>> Since this is the only possibility for alive SOCK_SEQPACKET to change
>>> the state in such way, we should better fix this strange and potentially
>>> danger corner case.
>>>
>>> Also, move TCP_CLOSE assignment for SOCK_DGRAM sockets under state lock
>>> to fix race with unix_dgram_connect():
>>>
>>> unix_dgram_connect(other)            unix_dgram_sendmsg(sk)
>>>                                        unix_peer(sk) = NULL
>>>                                        unix_state_unlock(sk)
>>>   unix_state_double_lock(sk, other)
>>>   sk->sk_state  = TCP_ESTABLISHED
>>>   unix_peer(sk) = other
>>>   unix_state_double_unlock(sk, other)
>>>                                        sk->sk_state  = TCP_CLOSED
>>>
>>> This patch fixes both of these races.
>>>
>>> Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")
>>
>> I don't think this commmit introduces the issues, both behavior
>> described above appear to be present even before?
> 
> 1)Hm, I pointed to the commit suggested by Kuniyuki without checking it.
> 
> Possible, the real problem commit is dc56ad7028c5 "af_unix: fix potential NULL deref in unix_dgram_connect()",
> since it added TCP_CLOSED assignment to unix_dgram_sendmsg().
> 
> 2)What do you think about initial version of fix?
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/38a920a7-cfba-7929-886d-c3c6effc0c43@ya.ru/
> 
> Despite there are some arguments, I'm not still sure that v2 is better.

Rethinking again, I think v1 is better, and we don't have to introduce optimizations,
which works only in very rare race cases. So, I'm going to return to V1 version,
which is better.

Kirill
