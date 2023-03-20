Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592AA6C2125
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbjCTTTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjCTTTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:19:21 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EBDEC53;
        Mon, 20 Mar 2023 12:11:16 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 3EB1C5FD24;
        Mon, 20 Mar 2023 21:14:05 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679336045;
        bh=YB66nolKkjoVJU5evh+1HebsOHaQzQKU6oDfFomMopo=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=SuBDWnSq/ExcHfGMvBol5cflBae0kgkygILrfeU5AF3LapTEuqNog18ajLEmITCzD
         +p1DeLidfqsVOexq6/24svD+4HjrRjBGUPehzCQfznvbSR7sW4Mcxve+hnVxJjOSnJ
         RyxCMbt1IxUSr+vCbt20d+jUH+Fpw/XOCW7Mh9t5mqjvt7KdUTezv9P87sEnnRWoQe
         TZtaLoVCjLh+CGO/wmkSfiaCyWRYw+27RuGnwTDPQSkayjTLOIlx2W0LjY94bxCTXl
         oiMOWXhSajyhEco7E9YCmmlXKQF9egDDYlHczz4HHJ3PxD6tuqaQbBSy7AadXf5yIT
         qWOFecjroSqhw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon, 20 Mar 2023 21:14:05 +0300 (MSK)
Message-ID: <37bef564-8f3e-aab3-a7d7-24e6c4caa318@sberdevices.ru>
Date:   Mon, 20 Mar 2023 21:10:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1 2/3] virtio/vsock: add WARN() for invalid state of
 socket
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <e141e6f1-00ae-232c-b840-b146bdb10e99@sberdevices.ru>
 <da93402d-920e-c248-a5a1-baf24b70ebee@sberdevices.ru>
 <20230320150715.twapgesp2gj6egua@sgarzare-redhat>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230320150715.twapgesp2gj6egua@sgarzare-redhat>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/20 09:56:00 #20977321
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20.03.2023 18:07, Stefano Garzarella wrote:
> On Sun, Mar 19, 2023 at 09:52:19PM +0300, Arseniy Krasnov wrote:
>> This prints WARN() and returns from stream dequeue callback when socket's
>> queue is empty, but 'rx_bytes' still non-zero.
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> net/vmw_vsock/virtio_transport_common.c | 7 +++++++
>> 1 file changed, 7 insertions(+)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 3c75986e16c2..c35b03adad8d 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -388,6 +388,13 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>     u32 free_space;
>>
>>     spin_lock_bh(&vvs->rx_lock);
>> +
>> +    if (skb_queue_empty(&vvs->rx_queue) && vvs->rx_bytes) {
>> +        WARN(1, "No skbuffs with non-zero 'rx_bytes'\n");
> 
> I would use WARN_ONCE, since we can't recover so we will flood the log.
> 
> And you can put the condition in the first argument, I mean something
> like this:
>         if (WARN_ONCE(skb_queue_empty(&vvs->rx_queue) && vvs->rx_bytes,
>                       "rx_queue is empty, but rx_bytes is non-zero\n")) {
I see, ok.
> 
> Thanks,
> Stefano
> 
>> +        spin_unlock_bh(&vvs->rx_lock);
>> +        return err;
>> +    }
>> +
>>     while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
>>         skb = skb_peek(&vvs->rx_queue);
>>
>> -- 
>> 2.25.1
>>
> 
