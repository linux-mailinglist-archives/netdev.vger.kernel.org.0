Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52556CFA9D
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 07:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjC3FQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 01:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC3FQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 01:16:49 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11B05245;
        Wed, 29 Mar 2023 22:16:45 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 31F0C5FD25;
        Thu, 30 Mar 2023 08:16:42 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680153402;
        bh=gsOfma4lyrnLfMCE/+bHkDrhbc8nxtLfnG2vBKGjSSM=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=Qw8MY1vtgsYAnokKaNQqF8gVvlA5wi0remxRsT75tXYda5TGvQy4mxmjusPuL0XIv
         D/8qWwy+2FQivrGj1phwfwvd98P41Bq6htKNX2cyXIK89jey8YknwPNQ9Bbryct0Py
         4b9lEKRnUkhCGLYN8ENfIVQ5kUkrSu6BOVBSVFoJOIuH359eW0KhE9MFPgehEfRisl
         S6FeTgCEQ7i1G5dNYuVxhVBOTJFcMa7OkvMbEmLFUQMxuB/wtQa1HyYvK9rSVGvsOJ
         lmCeJRo/4NbDFyV6vQbfF6jXGQDX+r9/l4aPRxoL4AOqDhqaewHnTLkken4D1GOhFC
         hn7Hm3wKlTRrw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu, 30 Mar 2023 08:16:36 +0300 (MSK)
Message-ID: <3083bb71-45bd-0738-14b6-fe2860c61b09@sberdevices.ru>
Date:   Thu, 30 Mar 2023 08:13:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1 1/2] vsock: return errors other than -ENOMEM to
 socket
Content-Language: en-US
To:     Vishnu Dasa <vdasa@vmware.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     Bryan Tan <bryantan@vmware.com>,
        Pv-drivers <Pv-drivers@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
References: <97f19214-ba04-c47e-7486-72e8aa16c690@sberdevices.ru>
 <99da938b-3e67-150c-2f74-41d917a95950@sberdevices.ru>
 <itjmw7vh3a7ggbodsu4mksu2hqbpdpxmu6cpexbra66nfhsw4x@hzpuzwldkfx5>
 <CAGxU2F648TyvAJN+Zk6YCnGUhn=0W_MZTox7RxQ45zHmHHO0SA@mail.gmail.com>
 <0f0a8603-e8a1-5fb2-23d9-5773c808ef85@sberdevices.ru>
 <ak74j6l2qesrixxmw7pfw56najqhdn32lv3xfxcb53nvmkyi3x@fr25vo2jlvbj>
 <64451c35-5442-73cb-4398-2b907dd810cc@sberdevices.ru>
 <B25B4275-957C-4052-B089-3714B6A7B0A3@vmware.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <B25B4275-957C-4052-B089-3714B6A7B0A3@vmware.com>
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/30 01:24:00 #21043458
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30.03.2023 00:44, Vishnu Dasa wrote:
> 
> 
>> On Mar 28, 2023, at 4:20 AM, Arseniy Krasnov <AVKrasnov@sberdevices.ru> wrote:
>>
>> !! External Email
>>
>> On 28.03.2023 14:19, Stefano Garzarella wrote:
>>> On Tue, Mar 28, 2023 at 01:42:19PM +0300, Arseniy Krasnov wrote:
>>>>
>>>>
>>>> On 28.03.2023 12:42, Stefano Garzarella wrote:
>>>>> I pressed send too early...
>>>>>
>>>>> CCing Bryan, Vishnu, and pv-drivers@vmware.com
>>>>>
>>>>> On Tue, Mar 28, 2023 at 11:39 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>>>>>
>>>>>> On Sun, Mar 26, 2023 at 01:13:11AM +0300, Arseniy Krasnov wrote:
>>>>>>> This removes behaviour, where error code returned from any transport
>>>>>>> was always switched to ENOMEM. This works in the same way as:
>>>>>>> commit
>>>>>>> c43170b7e157 ("vsock: return errors other than -ENOMEM to socket"),
>>>>>>> but for receive calls.
>>>>>>>
>>>>>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>>>>>> ---
>>>>>>> net/vmw_vsock/af_vsock.c | 4 ++--
>>>>>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>>>>>> index 19aea7cba26e..9262e0b77d47 100644
>>>>>>> --- a/net/vmw_vsock/af_vsock.c
>>>>>>> +++ b/net/vmw_vsock/af_vsock.c
>>>>>>> @@ -2007,7 +2007,7 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>>>>>>>
>>>>>>>              read = transport->stream_dequeue(vsk, msg, len - copied, flags);
>>>>>>
>>>>>> In vmci_transport_stream_dequeue() vmci_qpair_peekv() and
>>>>>> vmci_qpair_dequev() return VMCI_ERROR_* in case of errors.
>>>>>>
>>>>>> Maybe we should return -ENOMEM in vmci_transport_stream_dequeue() if
>>>>>> those functions fail to keep the same behavior.
>>>>
>>>> Yes, seems i missed it, because several months ago we had similar question for send
>>>> logic:
>>>> https://nam04.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.spinics.net%2Flists%2Fkernel%2Fmsg4611091.html&data=05%7C01%7Cvdasa%40vmware.com%7C3b17793425384debe75708db2f7eec8c%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C638155994413494900%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=MMfFcKuFFvMcJrbToKvWvIB%2FZmzp%2BdGGVWFVWztuSzg%3D&reserved=0
>>>> And it was ok to not handle VMCI send path in this way. So i think current implementation
>>>> for tx is a little bit buggy, because VMCI specific error from 'vmci_qpair_enquev()' is
>>>> returned to af_vsock.c. I think error conversion must be added to VMCI transport for tx
>>>> also.
>>>
>>> Good point!
>>>
>>> These are negative values, so there are no big problems, but I don't
>>> know what the user expects in this case.
>>>
>>> @Vishnu Do we want to return an errno to the user or a VMCI_ERROR_*?
>>
>> Small remark, as i can see, VMCI_ERROR_ is not exported to user in include/uapi,
>> so IIUC user won't be able to interpret such values correctly.
>>
>> Thanks, Arseniy
> 
> Let's just return -ENOMEM from vmci transport in case of error in
> vmci_transport_stream_enqueue and vmci_transport_stream_dequeue.
> 
> @Arseniy,
> Could you please add a separate patch in this set to handle the above?

Sure, ack, in the next few days!

Thanks, Arseniy

> 
> Thanks,
> Vishnu
> 
>>
>>>
>>> In both cases I think we should do the same for both enqueue and
>>> dequeue.
>>>
>>>>
>>>> Good thing is that Hyper-V uses general error codes.
>>>
>>> Yeah!
>>>
>>> Thanks,
>>> Stefano
>>>
>>>>
>>>> Thanks, Arseniy
>>>>>>
>>>>>> CCing Bryan, Vishnu, and pv-drivers@vmware.com
>>>>>>
>>>>>> The other transports seem okay to me.
>>>>>>
>>>>>> Thanks,
>>>>>> Stefano
>>>>>>
>>>>>>>              if (read < 0) {
>>>>>>> -                      err = -ENOMEM;
>>>>>>> +                      err = read;
>>>>>>>                      break;
>>>>>>>              }
>>>>>>>
>>>>>>> @@ -2058,7 +2058,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>>>>>>>      msg_len = transport->seqpacket_dequeue(vsk, msg, flags);
>>>>>>>
>>>>>>>      if (msg_len < 0) {
>>>>>>> -              err = -ENOMEM;
>>>>>>> +              err = msg_len;
>>>>>>>              goto out;
>>>>>>>      }
>>>>>>>
>>>>>>> --
>>>>>>> 2.25.1
>>>>>>>
>>>>>
>>>>
>>>
>>
>> !! External Email: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender.
> 
> 
