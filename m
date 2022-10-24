Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC7060B926
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbiJXUF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbiJXUEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:04:52 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949271DDDE7;
        Mon, 24 Oct 2022 11:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=geyns9AXUsLan2yEnbOALbeOUFkD91nGt5o9v5BAJzw=; b=aLq9GfkmPLuoWz+OFoe9wUpf/M
        b1+0G2N2bTYvQT9lQIkZuAC3fc8Be9IZNT9+f9p4tAUTZGymKE3CQs6oFmJpSJJou1oa4mPFWC/DP
        TMmdPycOdA/M+XzX5/76/svUkbl4b8iauufMVjwd0jg/Qcok0O95/Sa3XeVUkQ50m3JDTeJYYFEzn
        FQDqymg9la8jQQd5v/nVT7KIIKHeH630V74dKSjB69er940iAE+Oct2d1ekbvKjsHldrCAjQM5YLM
        EBTfslogI9xBumOycyw8rBdhIi4X6dtaM+qzCCL1sPWYXKxBeQ99O2+UIILw+LdoFiPfPvkBA6cAU
        ahLYLUZs3SVBmJ7hP7gF5JvvT+VBSm5JTdALXBnjMDmPSnUKENlG/rnI/T4ztexT6PzXutUvIV1cY
        XKH/4XhbygDadaXHqV2Xa+8CH0iQR0nMM4X6/7wMCXOhGl04FHS3/FDLcxD1Nflyg/hjPrpk0wGYY
        nZabdg6dryGykXDErGxrvMYg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1omwt4-005XAd-E1; Mon, 24 Oct 2022 12:49:02 +0000
Message-ID: <d49a8932-eda9-6bb5-bde9-6418406018cd@samba.org>
Date:   Mon, 24 Oct 2022 14:49:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH for-6.1 1/3] net: flag sockets supporting msghdr
 originated zerocopy
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
Content-Language: en-US, de-DE
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <7852a65b-d0eb-74dd-63f1-08df3434a06e@kernel.dk>
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

Am 22.10.22 um 18:07 schrieb Jens Axboe:
> On 10/22/22 9:57 AM, Pavel Begunkov wrote:
>> On 10/21/22 17:14, Jakub Kicinski wrote:
>>> On Fri, 21 Oct 2022 11:16:39 +0100 Pavel Begunkov wrote:
>>>> We need an efficient way in io_uring to check whether a socket supports
>>>> zerocopy with msghdr provided ubuf_info. Add a new flag into the struct
>>>> socket flags fields.
>>>>
>>>> Cc: <stable@vger.kernel.org> # 6.0
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>> ? include/linux/net.h | 1 +
>>>> ? net/ipv4/tcp.c????? | 1 +
>>>> ? net/ipv4/udp.c????? | 1 +
>>>> ? 3 files changed, 3 insertions(+)
>>>>
>>>> diff --git a/include/linux/net.h b/include/linux/net.h
>>>> index 711c3593c3b8..18d942bbdf6e 100644
>>>> --- a/include/linux/net.h
>>>> +++ b/include/linux/net.h
>>>> @@ -41,6 +41,7 @@ struct net;
>>>> ? #define SOCK_NOSPACE??????? 2
>>>> ? #define SOCK_PASSCRED??????? 3
>>>> ? #define SOCK_PASSSEC??????? 4
>>>> +#define SOCK_SUPPORT_ZC??????? 5
>>>
>>> Acked-by: Jakub Kicinski <kuba@kernel.org>
>>>
>>> Any idea on when this will make it to Linus? If within a week we can
>>> probably delay:
>>
>> After a chat with Jens, IIUC he can take it and send out to
>> Linus early. So, sounds like a good plan
> 
> Yes, and let's retain the name for now, can always be changed if we need
> to make it more granular. I'll ship this off before -rc2.

I'm now always getting -EOPNOTSUPP from SENDMSG_ZC for tcp connections...

metze

