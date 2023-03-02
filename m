Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889956A84F0
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 16:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjCBPJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 10:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCBPJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 10:09:18 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6632C1351A;
        Thu,  2 Mar 2023 07:09:15 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 82B075FD0E;
        Thu,  2 Mar 2023 18:09:12 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1677769752;
        bh=arLYnzRobVfIG4Xp6X3i9HedVCLBAhYiuD+9xD5xV54=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=NuxGBxE/GMn/5Jxg6mKRWyM7waw7zJ5DmrumuRxbeMkZBAXbJ5cIXagAopnzXPPgv
         6G5+EmDOjS9z2l7oIIOBVIW9ldWODX1HiqZ1npdGI9W9QrSOcqy41cBV95rpA8IY73
         VoCkE1eDYGl0kt7uFKaxvoK2pLDDntzPnNc4d9PFW2FsnIBIU+oYN6bomsEe010k8k
         ykjduawsI13bzUlIWIiVMmu2P+gmBIbslFyObfYyhPocIAVqxrcgAD4Y86jkYIeUmM
         SKnP84W6gUNJUk6d+KMqM4ZKg8uW88OMyhCP3EmNgUsQjUkM7aIMektqs4hnR+Y44c
         x2N5bZcimqwTQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu,  2 Mar 2023 18:09:07 +0300 (MSK)
Message-ID: <63035ec9-6546-0881-353a-502b68daaada@sberdevices.ru>
Date:   Thu, 2 Mar 2023 18:06:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1] vsock: check error queue to set EPOLLERR
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <oxffffaa@gmail.com>,
        <kernel@sberdevices.ru>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
References: <76e7698d-890b-d14d-fa34-da5dd7dd13d8@sberdevices.ru>
 <20230302100621.gk45unegjbqjgpxh@sgarzare-redhat>
 <3b38870c-7606-bf2e-8b17-21a75a1ed751@sberdevices.ru>
 <20230302133845.hglm4uregjsvrcrc@sgarzare-redhat>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230302133845.hglm4uregjsvrcrc@sgarzare-redhat>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/02 07:22:00 #20908555
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02.03.2023 16:38, Stefano Garzarella wrote:
> On Thu, Mar 02, 2023 at 02:41:29PM +0300, Arseniy Krasnov wrote:
>> Hello!
>>
>> On 02.03.2023 13:06, Stefano Garzarella wrote:
>>> On Wed, Mar 01, 2023 at 08:19:45AM +0300, Arseniy Krasnov wrote:
>>>> EPOLLERR must be set not only when there is error on the socket, but also
>>>> when error queue of it is not empty (may be it contains some control
>>>> messages). Without this patch 'poll()' won't detect data in error queue.
>>>
>>> Do you have a reproducer?
>>>
>> Dedicated reproducer - no:)
>> To reproduce this issue, i used last MSG_ZEROCOPY patches. Completion was inserted to
>> error queue, and 'poll()' didn't report about it. That was the reason, why this patch
>> was included to MSG_ZEROCOPY patchset. But also i think it is better to reduce number
>> of patches in it(i'm working on v2), so it is good to handle this patch separately.
> 
> Yep, absolutely!
> 
>> May be one way to reproduce it is use SO_TIMESTAMP(time info about skbuff will be queued
>> to the error queue). IIUC this feature is implemented at socket layer and may work in
>> vsock (but i'm not sure). Ok, i'll check it and try to implement reproducer.
>>
>> IIUC, for future, policy for fixes is "for each fix implement reproducer in vsock_test"?
> 
> Nope, but for each fix we should have a Fixes tag.
> 
> Usually we use vsock_test to check regressions on features and also the
> behaviour of different transports.
> My question was more about whether this problem was there before
> supporting sk_buff or not, to figure out which Fixes tag to use.
> 
Ok i see
>>
>>>> This patch is based on 'tcp_poll()'.
>>>
>>> LGTM but we should add a Fixes tag.
>>> It's not clear to me whether the problem depends on when we switched to using sk_buff or was pre-existing.
>>>
>>> Do you have any idea when we introduced this issue?
>> git blame shows, that this code exists since first commit to vsock:
> 
> Okay, but did we use sk_error_queue before supporting sk_buff?
> 
No I think, sk_error_queue was unavailable to user(and still unavailable today),
because we don't have check for MSG_ERRQUEUE flag in recv logic in af_vsock.c
(i've added it in MSG_ZEROCOPY). So even if some subsystem of the kernel inserts
skb to sk_error_queue in AF_VSOCK case, user won't dequeue it.

> Anyway, if we are not sure I think we can use the following Fixes tag,
> I don't see any issue if we backport this patch also before supporting
> sk_buff.
> 
Ok, i'll try to prepare reproducer(may be in vsock_test) and add Fixes tag with the
commit "VSOCK: Introduce VM Sockets."

Thanks, Arseniy
> Thanks,
> Stefano
> 
>>
>> commit d021c344051af91f42c5ba9fdedc176740cbd238
>> Author: Andy King <acking@vmware.com>
>> Date:   Wed Feb 6 14:23:56 2013 +0000
>>
>>    VSOCK: Introduce VM Sockets
>>
>> For TCP same logic was added by:
>>
>> commit 4ed2d765dfaccff5ebdac68e2064b59125033a3b
>> Author: Willem de Bruijn <willemb@google.com>
>> Date:   Mon Aug 4 22:11:49 2014 -0400
>>
>>    net-timestamp: TCP timestamping
>>
>>
>>>
>>> Thanks,
>>> Stefano
>>>
>>
>> Thanks Arseniy
>>
>>>>
>>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>>> ---
>>>> net/vmw_vsock/af_vsock.c | 2 +-
>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>>> index 19aea7cba26e..b5e51ef4a74c 100644
>>>> --- a/net/vmw_vsock/af_vsock.c
>>>> +++ b/net/vmw_vsock/af_vsock.c
>>>> @@ -1026,7 +1026,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
>>>>     poll_wait(file, sk_sleep(sk), wait);
>>>>     mask = 0;
>>>>
>>>> -    if (sk->sk_err)
>>>> +    if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
>>>>         /* Signify that there has been an error on this socket. */
>>>>         mask |= EPOLLERR;
>>>>
>>>> -- 
>>>> 2.25.1
>>>>
>>>
>>
> 
