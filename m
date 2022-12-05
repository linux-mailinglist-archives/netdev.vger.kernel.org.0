Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F28642E57
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 18:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiLERHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 12:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiLERHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 12:07:21 -0500
Received: from forward503o.mail.yandex.net (forward503o.mail.yandex.net [37.140.190.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7102B167CD
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:07:19 -0800 (PST)
Received: from myt5-18b0513eae63.qloud-c.yandex.net (myt5-18b0513eae63.qloud-c.yandex.net [IPv6:2a02:6b8:c12:571f:0:640:18b0:513e])
        by forward503o.mail.yandex.net (Yandex) with ESMTP id 2B7F45C3FCF;
        Mon,  5 Dec 2022 20:07:14 +0300 (MSK)
Received: by myt5-18b0513eae63.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id C7auKgaVdW21-E1SinOQS;
        Mon, 05 Dec 2022 20:07:13 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1670260033;
        bh=wFiPXk6NHQrpBHOuQZNOpLPgYLZ2iuqPm89dvwpn3YE=;
        h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
        b=XSo7WmNHomzt7TGvVaT2+UcGyAxcICyxegfFm12G4vkO/SyxwIO0DYOB8nRfTfw50
         lMSIcHfJu5I0W9lJmZNKvNIveTKhfPfUcUE6yOxlAqG1UvLpqyqEg/KVxfFYoYKIv3
         4BqL7ULzAQ4xNSX6JjFjOUSraI1XTXosye0gVjq0=
Authentication-Results: myt5-18b0513eae63.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Message-ID: <6e1cb672-cfe4-8adb-e618-1915f04562c0@ya.ru>
Date:   Mon, 5 Dec 2022 20:07:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net v2] unix: Fix race in SOCK_SEQPACKET's
 unix_dgram_sendmsg()
To:     Paolo Abeni <pabeni@redhat.com>,
        "Iwashima, Kuniyuki" <kuniyu@amazon.co.jp>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bd4d533b-15d2-6c0a-7667-70fd95dbea20@ya.ru>
 <7f1277b54a76280cfdaa25d0765c825d665146b9.camel@redhat.com>
 <b7172d71-5f64-104e-48cc-3e6b07ba75ac@ya.ru>
 <53BD8023-E114-4B3E-BB07-C1889C8A3E95@amazon.co.jp>
 <216de1827267077a19c5ed3e540b7db74afd1fc0.camel@redhat.com>
Content-Language: en-US
From:   Kirill Tkhai <tkhai@ya.ru>
In-Reply-To: <216de1827267077a19c5ed3e540b7db74afd1fc0.camel@redhat.com>
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

On 05.12.2022 12:22, Paolo Abeni wrote:
> On Fri, 2022-12-02 at 23:18 +0000, Iwashima, Kuniyuki wrote:
>>
>>> On Dec 3, 2022, at 7:44, Kirill Tkhai <tkhai@ya.ru> wrote:
>>>> On 01.12.2022 12:30, Paolo Abeni wrote:
>>>>> On Sun, 2022-11-27 at 01:46 +0300, Kirill Tkhai wrote:
>>>>> There is a race resulting in alive SOCK_SEQPACKET socket
>>>>> may change its state from TCP_ESTABLISHED to TCP_CLOSE:
>>>>>
>>>>> unix_release_sock(peer)                  unix_dgram_sendmsg(sk)
>>>>>  sock_orphan(peer)
>>>>>    sock_set_flag(peer, SOCK_DEAD)
>>>>>                                           sock_alloc_send_pskb()
>>>>>                                             if !(sk->sk_shutdown & SEND_SHUTDOWN)
>>>>>                                               OK
>>>>>                                           if sock_flag(peer, SOCK_DEAD)
>>>>>                                             sk->sk_state = TCP_CLOSE
>>>>>  sk->sk_shutdown = SHUTDOWN_MASK
>>>>>
>>>>>
>>>>> After that socket sk remains almost normal: it is able to connect, listen, accept
>>>>> and recvmsg, while it can't sendmsg.
>>>>>
>>>>> Since this is the only possibility for alive SOCK_SEQPACKET to change
>>>>> the state in such way, we should better fix this strange and potentially
>>>>> danger corner case.
>>>>>
>>>>> Also, move TCP_CLOSE assignment for SOCK_DGRAM sockets under state lock
>>>>> to fix race with unix_dgram_connect():
>>>>>
>>>>> unix_dgram_connect(other)            unix_dgram_sendmsg(sk)
>>>>>                                       unix_peer(sk) = NULL
>>>>>                                       unix_state_unlock(sk)
>>>>>  unix_state_double_lock(sk, other)
>>>>>  sk->sk_state  = TCP_ESTABLISHED
>>>>>  unix_peer(sk) = other
>>>>>  unix_state_double_unlock(sk, other)
>>>>>                                       sk->sk_state  = TCP_CLOSED
>>>>>
>>>>> This patch fixes both of these races.
>>>>>
>>>>> Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")
>>>>
>>>> I don't think this commmit introduces the issues, both behavior
>>>> described above appear to be present even before?
>>>
>>> 1)Hm, I pointed to the commit suggested by Kuniyuki without checking it.
>>>
>>> Possible, the real problem commit is dc56ad7028c5 "af_unix: fix potential NULL deref in unix_dgram_connect()",
>>> since it added TCP_CLOSED assignment to unix_dgram_sendmsg().
>>
>> The commit just moved the assignment.
>>
>> Note unix_dgram_disconnected() is called for SOCK_SEQPACKET 
>> after releasing the lock, and 83301b5367a9 introduced the 
>> TCP_CLOSE assignment.
> 
> I'm sorry for the back and forth, I think I initally misread the code.
> I agree 83301b5367a9 is good fixes tag.
> 
>>> 2)What do you think about initial version of fix?
>>>
>>> https://patchwork.kernel.org/project/netdevbpf/patch/38a920a7-cfba-7929-886d-c3c6effc0c43@ya.ru/
>>>
>>> Despite there are some arguments, I'm not still sure that v2 is better.
> 
> v1 introduces quite a few behavior changes (different error code,
> different cleanup schema) that could be IMHO more risky for a stable
> patch. I suggest to pick the minimal change that addresses the issue
> (v2 in this case).

Hm, not exactly. EPIPE is regular return value, which is normally returned from
unix_dgram_sendmsg()->sock_alloc_send_pskb (see SEND_SHUTDOWN check).
ECONNREFUSED is a race case return value, it does not returned normally.

What different cleanup scheme do you mean? IMO, there is the same behavior
as we get, when race is failed, and sock_alloc_send_pskb() returns EPIPE as in regular case. 
