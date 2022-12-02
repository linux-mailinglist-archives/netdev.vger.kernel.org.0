Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF766410C9
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 23:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbiLBWoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 17:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234159AbiLBWn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 17:43:59 -0500
Received: from forward500p.mail.yandex.net (forward500p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CE2F81AF
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 14:43:58 -0800 (PST)
Received: from vla1-62318bfe5573.qloud-c.yandex.net (vla1-62318bfe5573.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3819:0:640:6231:8bfe])
        by forward500p.mail.yandex.net (Yandex) with ESMTP id CDEF4F010D8;
        Sat,  3 Dec 2022 01:43:54 +0300 (MSK)
Received: by vla1-62318bfe5573.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id rhct6XQYASw1-FGfs8Fwj;
        Sat, 03 Dec 2022 01:43:54 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1670021034;
        bh=ukc1ERIAmm7lad6hTl+ahMtA50A0ifEQElSJujT3wEY=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID;
        b=vp0V02QHjsM7du86qBee4Cp+bJ1uCbIoNfff1hZEJqow28TUuQGYgUwAh5UrS0kTX
         +0mhSOajqN1Z70HqQN8+0b7jW3Gd2X9Wl8krDvGPYoHUxH0uNsQJlOcka8fuWpe8k/
         li4jLtSKGmDzzoPdrPOqD7eTH38C9Y035Q95hRjE=
Authentication-Results: vla1-62318bfe5573.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Message-ID: <b7172d71-5f64-104e-48cc-3e6b07ba75ac@ya.ru>
Date:   Sat, 3 Dec 2022 01:43:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net v2] unix: Fix race in SOCK_SEQPACKET's
 unix_dgram_sendmsg()
To:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        Kuniyuki Iwashima <kuniyu@amazon.com>
References: <bd4d533b-15d2-6c0a-7667-70fd95dbea20@ya.ru>
 <7f1277b54a76280cfdaa25d0765c825d665146b9.camel@redhat.com>
Content-Language: en-US
From:   Kirill Tkhai <tkhai@ya.ru>
In-Reply-To: <7f1277b54a76280cfdaa25d0765c825d665146b9.camel@redhat.com>
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

On 01.12.2022 12:30, Paolo Abeni wrote:
> On Sun, 2022-11-27 at 01:46 +0300, Kirill Tkhai wrote:
>> There is a race resulting in alive SOCK_SEQPACKET socket
>> may change its state from TCP_ESTABLISHED to TCP_CLOSE:
>>
>> unix_release_sock(peer)                  unix_dgram_sendmsg(sk)
>>   sock_orphan(peer)
>>     sock_set_flag(peer, SOCK_DEAD)
>>                                            sock_alloc_send_pskb()
>>                                              if !(sk->sk_shutdown & SEND_SHUTDOWN)
>>                                                OK
>>                                            if sock_flag(peer, SOCK_DEAD)
>>                                              sk->sk_state = TCP_CLOSE
>>   sk->sk_shutdown = SHUTDOWN_MASK
>>
>>
>> After that socket sk remains almost normal: it is able to connect, listen, accept
>> and recvmsg, while it can't sendmsg.
>>
>> Since this is the only possibility for alive SOCK_SEQPACKET to change
>> the state in such way, we should better fix this strange and potentially
>> danger corner case.
>>
>> Also, move TCP_CLOSE assignment for SOCK_DGRAM sockets under state lock
>> to fix race with unix_dgram_connect():
>>
>> unix_dgram_connect(other)            unix_dgram_sendmsg(sk)
>>                                        unix_peer(sk) = NULL
>>                                        unix_state_unlock(sk)
>>   unix_state_double_lock(sk, other)
>>   sk->sk_state  = TCP_ESTABLISHED
>>   unix_peer(sk) = other
>>   unix_state_double_unlock(sk, other)
>>                                        sk->sk_state  = TCP_CLOSED
>>
>> This patch fixes both of these races.
>>
>> Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")
> 
> I don't think this commmit introduces the issues, both behavior
> described above appear to be present even before?

1)Hm, I pointed to the commit suggested by Kuniyuki without checking it.

Possible, the real problem commit is dc56ad7028c5 "af_unix: fix potential NULL deref in unix_dgram_connect()",
since it added TCP_CLOSED assignment to unix_dgram_sendmsg().

2)What do you think about initial version of fix?

https://patchwork.kernel.org/project/netdevbpf/patch/38a920a7-cfba-7929-886d-c3c6effc0c43@ya.ru/

Despite there are some arguments, I'm not still sure that v2 is better.

Thanks,
Kirill
