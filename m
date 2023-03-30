Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225976CFF7C
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 11:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjC3JMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 05:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjC3JL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 05:11:58 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF697AA7;
        Thu, 30 Mar 2023 02:11:50 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 5B8855FD25;
        Thu, 30 Mar 2023 12:11:47 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680167507;
        bh=RYJMvFbojXg3R5X/dk91cDXmm8PXnGq/ROukKXRmzZY=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=RSVZMxiOgwXyz0sUrROyRorsxNo8Gh2DYz/ll75I/RDoTDydMrv4qdfjWTFLEfUAM
         ke/2e17GQ2mPtT50b+eQAHXG17FC2oV841sreK7FyGisPaIBhJlgBrxkDAG243z4JF
         ii9NTHkTQABbQBeHbbTKFdQMW9hQR14+PAp6bvBnF2Dt0dJ0gma/0UHnpLZcMYsy2n
         iOlY3qJIHnHxYFMNrtfQpj6r7pK02TytvjbkAtM7lIiU7VcZGcaz0uM0CyruPiB5tB
         bTW8GtEcvMJ14iHaEz+d32/uClpM66aksbWyq/d52waa/aUCgB/yHDmCcUlAAvUfvA
         AUFZekP5iaozg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu, 30 Mar 2023 12:11:42 +0300 (MSK)
Message-ID: <5e294fdb-5a19-140c-e5cb-e5ba00acec58@sberdevices.ru>
Date:   Thu, 30 Mar 2023 12:08:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v2 1/3] vsock: return errors other than -ENOMEM to
 socket
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <pv-drivers@vmware.com>
References: <60abc0da-0412-6e25-eeb0-8e32e3ec21e7@sberdevices.ru>
 <b910764f-a193-e684-a762-f941883a0745@sberdevices.ru>
 <p64mv3f2ujn4uokl5i7abhdbmed3zy2lrozqoam3llcf4r2qkv@gmyoyikbyiwj>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <p64mv3f2ujn4uokl5i7abhdbmed3zy2lrozqoam3llcf4r2qkv@gmyoyikbyiwj>
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/30 06:33:00 #21047900
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30.03.2023 11:02, Stefano Garzarella wrote:
> On Thu, Mar 30, 2023 at 10:05:45AM +0300, Arseniy Krasnov wrote:
>> This removes behaviour, where error code returned from any transport
>> was always switched to ENOMEM. This works in the same way as:
>> commit
>> c43170b7e157 ("vsock: return errors other than -ENOMEM to socket"),
>> but for receive calls.
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> net/vmw_vsock/af_vsock.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> We should first make sure that all transports return the right value,
> and then expose it to the user, so I would move this patch, after
> patch 2.

Yes, right! I'll reorder patches and fix VMCI patch after reply from @Vishnu

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 
>>
>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>> index 5f2dda35c980..413407bb646c 100644
>> --- a/net/vmw_vsock/af_vsock.c
>> +++ b/net/vmw_vsock/af_vsock.c
>> @@ -2043,7 +2043,7 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>>
>>         read = transport->stream_dequeue(vsk, msg, len - copied, flags);
>>         if (read < 0) {
>> -            err = -ENOMEM;
>> +            err = read;
>>             break;
>>         }
>>
>> @@ -2094,7 +2094,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>>     msg_len = transport->seqpacket_dequeue(vsk, msg, flags);
>>
>>     if (msg_len < 0) {
>> -        err = -ENOMEM;
>> +        err = msg_len;
>>         goto out;
>>     }
>>
>> -- 
>> 2.25.1
>>
> 
