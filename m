Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACD16CBCCB
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 12:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbjC1Kpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 06:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbjC1Kpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 06:45:52 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ADA618A;
        Tue, 28 Mar 2023 03:45:48 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 931785FD0E;
        Tue, 28 Mar 2023 13:45:45 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680000345;
        bh=NOp8u9X32RM0zpODrfERJaF8FGjQ60rLL3xGd0/0O24=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=SQ3aqtO5iBBEDf77OVZEn6ncK4ysjWNeuDmP4PQOsqm0KAEOBGKOw5nzTXGV3+SM1
         FSjPopWFLrn3eu2BPpunLsThx+rnWXJkSYVbio89J5BaD0HOAVUesWYdOEXcMH97Y3
         Ej4S+weC5xkJVYHEYmaE1k3Xl7pVntlIPRQWCmvrY/gPTs8KeQU1J3ee0LgevrT9YJ
         g0u6wQifc17OTob4P2DLiLQQNufdsGxYpLvxsV0IbQJJhGumPskSlVWXgLNGWmZbIM
         LHrehH7hOiixBNRWZVJ8TvwsHdyyz2cVivOh2/613aWqGDFZVbtgGAVudTAhhZg8Lw
         GbKVyPpn+Tqjw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 28 Mar 2023 13:45:39 +0300 (MSK)
Message-ID: <0f0a8603-e8a1-5fb2-23d9-5773c808ef85@sberdevices.ru>
Date:   Tue, 28 Mar 2023 13:42:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1 1/2] vsock: return errors other than -ENOMEM to
 socket
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <97f19214-ba04-c47e-7486-72e8aa16c690@sberdevices.ru>
 <99da938b-3e67-150c-2f74-41d917a95950@sberdevices.ru>
 <itjmw7vh3a7ggbodsu4mksu2hqbpdpxmu6cpexbra66nfhsw4x@hzpuzwldkfx5>
 <CAGxU2F648TyvAJN+Zk6YCnGUhn=0W_MZTox7RxQ45zHmHHO0SA@mail.gmail.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <CAGxU2F648TyvAJN+Zk6YCnGUhn=0W_MZTox7RxQ45zHmHHO0SA@mail.gmail.com>
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/28 06:38:00 #21021220
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28.03.2023 12:42, Stefano Garzarella wrote:
> I pressed send too early...
> 
> CCing Bryan, Vishnu, and pv-drivers@vmware.com
> 
> On Tue, Mar 28, 2023 at 11:39 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> On Sun, Mar 26, 2023 at 01:13:11AM +0300, Arseniy Krasnov wrote:
>>> This removes behaviour, where error code returned from any transport
>>> was always switched to ENOMEM. This works in the same way as:
>>> commit
>>> c43170b7e157 ("vsock: return errors other than -ENOMEM to socket"),
>>> but for receive calls.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>> net/vmw_vsock/af_vsock.c | 4 ++--
>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>> index 19aea7cba26e..9262e0b77d47 100644
>>> --- a/net/vmw_vsock/af_vsock.c
>>> +++ b/net/vmw_vsock/af_vsock.c
>>> @@ -2007,7 +2007,7 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>>>
>>>               read = transport->stream_dequeue(vsk, msg, len - copied, flags);
>>
>> In vmci_transport_stream_dequeue() vmci_qpair_peekv() and
>> vmci_qpair_dequev() return VMCI_ERROR_* in case of errors.
>>
>> Maybe we should return -ENOMEM in vmci_transport_stream_dequeue() if
>> those functions fail to keep the same behavior.

Yes, seems i missed it, because several months ago we had similar question for send
logic:
https://www.spinics.net/lists/kernel/msg4611091.html
And it was ok to not handle VMCI send path in this way. So i think current implementation
for tx is a little bit buggy, because VMCI specific error from 'vmci_qpair_enquev()' is
returned to af_vsock.c. I think error conversion must be added to VMCI transport for tx
also.

Good thing is that Hyper-V uses general error codes.

Thanks, Arseniy
>>
>> CCing Bryan, Vishnu, and pv-drivers@vmware.com
>>
>> The other transports seem okay to me.
>>
>> Thanks,
>> Stefano
>>
>>>               if (read < 0) {
>>> -                      err = -ENOMEM;
>>> +                      err = read;
>>>                       break;
>>>               }
>>>
>>> @@ -2058,7 +2058,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>>>       msg_len = transport->seqpacket_dequeue(vsk, msg, flags);
>>>
>>>       if (msg_len < 0) {
>>> -              err = -ENOMEM;
>>> +              err = msg_len;
>>>               goto out;
>>>       }
>>>
>>> --
>>> 2.25.1
>>>
> 
