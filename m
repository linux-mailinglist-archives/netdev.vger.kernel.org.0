Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C9360B940
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbiJXUGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233933AbiJXUGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:06:05 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F181C97F3;
        Mon, 24 Oct 2022 11:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=HpMQ+SsOUd+lBATzyWN+M8SFWhbeUymYidMMvnxoKsE=; b=pClK9/vz18UP3urCFuImdSzsl7
        Ss3obbUjAWYbyrZ8JZK+3zltNmPzq+uMtyhmM8YexKLJ7ZheG2Ncvkx6pABKrxMb4z6jwubT2c16i
        3t1Mx8hHXet8vm/1dwJXo2+RTCeQeBEpoqxRjWdW8iTmJ+S223L+uCmViXG5ZYDtfG5+qbLCQUIe8
        7rkihNLp1ZqT6agGWZZGyFi4kN+b6HT9VXp060t0qhBw0du4JPfV/uTn64k8H9Q2ZKZHq6//b+CrK
        K2f3qlzr37WF8tTRH6zl8Z6Q4w9uwv3e7pHbs8t2IFQEmbYFSuxuPEfY0gPK16Nts33fGivK0FVLP
        q8yEvcXqG4cGdB+vHDvHyv0a0JQyMOQAMdJtcNaj+PDWFsrsrlfVkpjGAd+dCFKwMeUSLHIVyAD+d
        msSWBQp8gqfAOrVrM4vrlroSl6iF7IABtmnRaescH/vJOc6XXZarL+TQo5ZI1en4j/3xvo4G6fWsb
        2mY769XT2aq0/opvreQVsPJO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1on1WB-005Z3r-8A; Mon, 24 Oct 2022 17:45:43 +0000
Message-ID: <62b6de98-026c-115f-ebae-950cb5501139@samba.org>
Date:   Mon, 24 Oct 2022 19:45:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH for-6.1 1/3] net: flag sockets supporting msghdr
 originated zerocopy
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1666346426.git.asml.silence@gmail.com>
 <3dafafab822b1c66308bb58a0ac738b1e3f53f74.1666346426.git.asml.silence@gmail.com>
 <20221021091404.58d244af@kernel.org>
 <99ab0cb7-45ad-c67d-66f4-6b52c5e6ac33@gmail.com>
 <7852a65b-d0eb-74dd-63f1-08df3434a06e@kernel.dk>
 <d49a8932-eda9-6bb5-bde9-6418406018cd@samba.org>
 <3baa63ac-ff1a-201f-06b3-e7a093f88b11@samba.org>
 <27c801d6-4031-8510-1eeb-18b7c7e26d1f@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <27c801d6-4031-8510-1eeb-18b7c7e26d1f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 24.10.22 um 19:00 schrieb Pavel Begunkov:
> On 10/24/22 15:12, Stefan Metzmacher wrote:
>> Am 24.10.22 um 14:49 schrieb Stefan Metzmacher:
>>> Am 22.10.22 um 18:07 schrieb Jens Axboe:
>>>> On 10/22/22 9:57 AM, Pavel Begunkov wrote:
>>>>> On 10/21/22 17:14, Jakub Kicinski wrote:
>>>>>> On Fri, 21 Oct 2022 11:16:39 +0100 Pavel Begunkov wrote:
>>>>>>> We need an efficient way in io_uring to check whether a socket supports
>>>>>>> zerocopy with msghdr provided ubuf_info. Add a new flag into the struct
>>>>>>> socket flags fields.
>>>>>>>
>>>>>>> Cc: <stable@vger.kernel.org> # 6.0
>>>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>>>> ---
>>>>>>> ? include/linux/net.h | 1 +
>>>>>>> ? net/ipv4/tcp.c????? | 1 +
>>>>>>> ? net/ipv4/udp.c????? | 1 +
>>>>>>> ? 3 files changed, 3 insertions(+)
>>>>>>>
>>>>>>> diff --git a/include/linux/net.h b/include/linux/net.h
>>>>>>> index 711c3593c3b8..18d942bbdf6e 100644
>>>>>>> --- a/include/linux/net.h
>>>>>>> +++ b/include/linux/net.h
>>>>>>> @@ -41,6 +41,7 @@ struct net;
>>>>>>> ? #define SOCK_NOSPACE??????? 2
>>>>>>> ? #define SOCK_PASSCRED??????? 3
>>>>>>> ? #define SOCK_PASSSEC??????? 4
>>>>>>> +#define SOCK_SUPPORT_ZC??????? 5
>>>>>>
>>>>>> Acked-by: Jakub Kicinski <kuba@kernel.org>
>>>>>>
>>>>>> Any idea on when this will make it to Linus? If within a week we can
>>>>>> probably delay:
>>>>>
>>>>> After a chat with Jens, IIUC he can take it and send out to
>>>>> Linus early. So, sounds like a good plan
>>>>
>>>> Yes, and let's retain the name for now, can always be changed if we need
>>>> to make it more granular. I'll ship this off before -rc2.
>>>
>>> I'm now always getting -EOPNOTSUPP from SENDMSG_ZC for tcp connections...
>>
>> The problem is that inet_accept() doesn't set SOCK_SUPPORT_ZC...
> 
> Yeah, you're right, accept is not handled, not great. Thanks
> for tracking it down. And I'll add a test for it
> 
> 
>> This hack below fixes it for me, but I'm sure there's a nicer way...
>>
>> The natural way would be to overload inet_csk_accept for tcp,
>> but sk1->sk_prot->accept() is called with sk2->sk_socket == NULL,
>> because sock_graft() is called later...
> 
> I think it's acceptable for a fix. sk_is_tcp() sounds a bit better
> assuming that sk_type/protocol are set there.
> 
> 
>> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
>> index 3dd02396517d..0f35f2a32756 100644
>> --- a/net/ipv4/af_inet.c
>> +++ b/net/ipv4/af_inet.c
>> @@ -736,6 +736,7 @@ EXPORT_SYMBOL(inet_stream_connect);
>>    *    Accept a pending connection. The TCP layer now gives BSD semantics.
>>    */
>>
>> +#include <net/transp_v6.h>
>>   int inet_accept(struct socket *sock, struct socket *newsock, int flags,
>>           bool kern)
>>   {
>> @@ -754,6 +755,8 @@ int inet_accept(struct socket *sock, struct socket *newsock, int flags,
>>             (TCPF_ESTABLISHED | TCPF_SYN_RECV |
>>             TCPF_CLOSE_WAIT | TCPF_CLOSE)));
>>
>> +    if (sk2->sk_prot == &tcp_prot || sk2->sk_prot == &tcpv6_prot)
>> +        set_bit(SOCK_SUPPORT_ZC, &newsock->flags);
>>       sock_graft(sk2, newsock);

Hmm, I think we just need to check if the flag was set on the listening socket,
otherwise we have a hard coded value again...

This also works for me, and seems like a much nicer patch:

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 3dd02396517d..4728087c42a5 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -754,6 +754,8 @@ int inet_accept(struct socket *sock, struct socket *newsock, int flags,
  		  (TCPF_ESTABLISHED | TCPF_SYN_RECV |
  		  TCPF_CLOSE_WAIT | TCPF_CLOSE)));

+	if (test_bit(SOCK_SUPPORT_ZC, &sock->flags))
+		set_bit(SOCK_SUPPORT_ZC, &newsock->flags);
  	sock_graft(sk2, newsock);

  	newsock->state = SS_CONNECTED;


