Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4506AC512
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 16:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjCFPcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 10:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjCFPcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 10:32:03 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091863644C;
        Mon,  6 Mar 2023 07:31:45 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 6A47C5FD14;
        Mon,  6 Mar 2023 18:31:43 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678116703;
        bh=/XFFWLxFfmXSs0UwYPecMcii9mm/PzED5WfvB5xCt5o=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=O3/ZnFWiTv+xzowN+WxlAcqDbCDhDugrXWa+j6+TQ/xFZ18SjdB0eX3ZDv3pV9mck
         ejFvE84Ggh0+54uIZ2b531/NsCXulu/A9lcb+4TfKSJYcPi9E+n4tDNi6T5IW0xmyE
         1C81n4a4HtTeUY3a3Ekkhgxt1CmzFNHaQy5EwpEihyj8mxDB3HhoBEWAUh7j/j67Ia
         TiY5CzygxqVNRLr3zwHgR9fLSt9w/niIdcbr4P20yx9wEshIKKVYDipCZLrvNQA/LO
         Ejl+I1IW0bkPzjSuGcVfEPS9DnL9NDXzrCcWzbTwFyoqDpV2u1nWKEd313xuFMcukb
         YKOtR2vOn7cIA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  6 Mar 2023 18:31:43 +0300 (MSK)
Message-ID: <868147ea-7d02-829b-7c37-058f650038c5@sberdevices.ru>
Date:   Mon, 6 Mar 2023 18:28:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v2 3/4] virtio/vsock: free skb on data copy failure
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
References: <a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru>
 <ef98aad4-f86d-fe60-9a35-792363a78a68@sberdevices.ru>
 <20230306120742.v6ss4w22ku7pe45a@sgarzare-redhat>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230306120742.v6ss4w22ku7pe45a@sgarzare-redhat>
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/06 11:48:00 #20919088
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06.03.2023 15:07, Stefano Garzarella wrote:
> On Sun, Mar 05, 2023 at 11:08:38PM +0300, Arseniy Krasnov wrote:
>> This fixes two things in case when 'memcpy_to_msg()' fails:
>> 1) Update credit parameters of the socket, like this skbuff was
>>   copied to user successfully. This is needed because when skbuff was
>>   received it's length was used to update 'rx_bytes', thus when we drop
>>   skbuff here, we must account rest of it's data in 'rx_bytes'.
>> 2) Free skbuff which was removed from socket's queue.
>>
>> Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> net/vmw_vsock/virtio_transport_common.c | 6 +++++-
>> 1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 30b0539990ba..ffb1af4f2b52 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -379,8 +379,12 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>         spin_unlock_bh(&vvs->rx_lock);
>>
>>         err = memcpy_to_msg(msg, skb->data, bytes);
>> -        if (err)
>> +        if (err) {
>> +            skb_pull(skb, skb->len);
>> +            virtio_transport_dec_rx_pkt(vvs, skb);
>> +            consume_skb(skb);
> 
> I'm not sure it's the right thing to do, if we fail to copy the content
> into the user's buffer, I think we should queue it again.
> 
> In fact, before commit 71dc9ec9ac7d ("virtio/vsock: replace
> virtio_vsock_pkt with sk_buff"), we used to remove the packet from the
> rx_queue, only if memcpy_to_msg() was successful.
> 
> Maybe it is better to do as we did before and use skb_peek() at the
> beginning of the loop and __skb_unlink() when skb->len == 0.
Yes, i see. I'll also add test to cover this case.
> 
> Thanks,
> Stefano
> 
>>             goto out;
>> +        }
>>
>>         spin_lock_bh(&vvs->rx_lock);
>>
>> -- 
>> 2.25.1
>>
> 
