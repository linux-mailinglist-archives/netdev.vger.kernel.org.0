Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCB960B94D
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiJXUIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiJXUHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:07:52 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF6E74CFB;
        Mon, 24 Oct 2022 11:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Cc:To:From:Date:Message-ID;
        bh=hhalkjn0eBQkvgLrXfIYCYF+eIeNxyHQCuk3KORLldQ=; b=mTwXrmkcI1jnz1wvD/OJGqvwtu
        JJW3ktj6RpqMFRV6BYy/dNHsmIPjAdflpTvINeEa7iJa9FxVBzlHdQnzr5NVyVIXeBXs7B7p7WCxN
        2vpoKCfp6nAlTFve7n26XFB7jDap7Jt5SM2iiRB4KLu2X4M1YCF5C7GCYK22xlBsE2XOM2twJ7Nv9
        7pee9kWF6RzHElpDuUOAVUYVULmE0HuWWmr/Ee7X5IINucNyqFXBRZcmns5wvahY9pRdbMXpGCHP7
        /GmLJxyYvZHV0TsIH4awAR0LCw48trQXKpCIapDf5Q3DmlT4EtqlkCAmx01CZUjaLI54ngGu37pg2
        ZPD5SOeCYFcaYJO6Ir4ZhaJNGj+TM9ti5kkS26unk5T70LaZNm5reS0AN1oatjHUBPd28Roc47BQQ
        +DomxHZXoacnpsUYe29xT5luKK0ajQurXS/gpsoy2w5YzR0KO5BmYNNRoX4HRIzvvKD9lf2D3aGfr
        l/KyEggIju03zQkl/9UuIecR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1omyBr-005XYJ-Eu; Mon, 24 Oct 2022 14:12:31 +0000
Message-ID: <3baa63ac-ff1a-201f-06b3-e7a093f88b11@samba.org>
Date:   Mon, 24 Oct 2022 16:12:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH for-6.1 1/3] net: flag sockets supporting msghdr
 originated zerocopy
Content-Language: en-US
From:   Stefan Metzmacher <metze@samba.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org
References: <cover.1666346426.git.asml.silence@gmail.com>
 <3dafafab822b1c66308bb58a0ac738b1e3f53f74.1666346426.git.asml.silence@gmail.com>
 <20221021091404.58d244af@kernel.org>
 <99ab0cb7-45ad-c67d-66f4-6b52c5e6ac33@gmail.com>
 <7852a65b-d0eb-74dd-63f1-08df3434a06e@kernel.dk>
 <d49a8932-eda9-6bb5-bde9-6418406018cd@samba.org>
In-Reply-To: <d49a8932-eda9-6bb5-bde9-6418406018cd@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 24.10.22 um 14:49 schrieb Stefan Metzmacher:
> Am 22.10.22 um 18:07 schrieb Jens Axboe:
>> On 10/22/22 9:57 AM, Pavel Begunkov wrote:
>>> On 10/21/22 17:14, Jakub Kicinski wrote:
>>>> On Fri, 21 Oct 2022 11:16:39 +0100 Pavel Begunkov wrote:
>>>>> We need an efficient way in io_uring to check whether a socket supports
>>>>> zerocopy with msghdr provided ubuf_info. Add a new flag into the struct
>>>>> socket flags fields.
>>>>>
>>>>> Cc: <stable@vger.kernel.org> # 6.0
>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>> ---
>>>>> ? include/linux/net.h | 1 +
>>>>> ? net/ipv4/tcp.c????? | 1 +
>>>>> ? net/ipv4/udp.c????? | 1 +
>>>>> ? 3 files changed, 3 insertions(+)
>>>>>
>>>>> diff --git a/include/linux/net.h b/include/linux/net.h
>>>>> index 711c3593c3b8..18d942bbdf6e 100644
>>>>> --- a/include/linux/net.h
>>>>> +++ b/include/linux/net.h
>>>>> @@ -41,6 +41,7 @@ struct net;
>>>>> ? #define SOCK_NOSPACE??????? 2
>>>>> ? #define SOCK_PASSCRED??????? 3
>>>>> ? #define SOCK_PASSSEC??????? 4
>>>>> +#define SOCK_SUPPORT_ZC??????? 5
>>>>
>>>> Acked-by: Jakub Kicinski <kuba@kernel.org>
>>>>
>>>> Any idea on when this will make it to Linus? If within a week we can
>>>> probably delay:
>>>
>>> After a chat with Jens, IIUC he can take it and send out to
>>> Linus early. So, sounds like a good plan
>>
>> Yes, and let's retain the name for now, can always be changed if we need
>> to make it more granular. I'll ship this off before -rc2.
> 
> I'm now always getting -EOPNOTSUPP from SENDMSG_ZC for tcp connections...

The problem is that inet_accept() doesn't set SOCK_SUPPORT_ZC...

This hack below fixes it for me, but I'm sure there's a nicer way...

The natural way would be to overload inet_csk_accept for tcp,
but sk1->sk_prot->accept() is called with sk2->sk_socket == NULL,
because sock_graft() is called later...

metze

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 3dd02396517d..0f35f2a32756 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -736,6 +736,7 @@ EXPORT_SYMBOL(inet_stream_connect);
   *	Accept a pending connection. The TCP layer now gives BSD semantics.
   */

+#include <net/transp_v6.h>
  int inet_accept(struct socket *sock, struct socket *newsock, int flags,
  		bool kern)
  {
@@ -754,6 +755,8 @@ int inet_accept(struct socket *sock, struct socket *newsock, int flags,
  		  (TCPF_ESTABLISHED | TCPF_SYN_RECV |
  		  TCPF_CLOSE_WAIT | TCPF_CLOSE)));

+	if (sk2->sk_prot == &tcp_prot || sk2->sk_prot == &tcpv6_prot)
+		set_bit(SOCK_SUPPORT_ZC, &newsock->flags);
  	sock_graft(sk2, newsock);

  	newsock->state = SS_CONNECTED;


