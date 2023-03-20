Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831716C212E
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjCTTTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjCTTTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:19:22 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDEEDBD7;
        Mon, 20 Mar 2023 12:11:16 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 8CA315FD1B;
        Mon, 20 Mar 2023 21:05:43 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679335543;
        bh=ChXPnaWU9tioQBcItc3cTbZ8j7fWtooOfi6E3G+mq0A=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=R5Nxk4rPuF6DytMXjBFMyim/nVNu3nt5IJ0hPAlzLzL7ElpE+Obhs4RA+tVUMOpax
         LWGwsNXyyAGvzduT7ONsz0GNkNytqv0xUV45ca4N7a0wTi5J33KXd/82U04Ai+5kg6
         9hgqU8LM8hwMWZYcpnjq6vPNFzVE75HWohDp7x3kRC1zODNaxPSiKvDyptUtOSuKFW
         qQB8XEdqIYQ65/9JpN3kvRYM9tRTkk+r3yWKJjpxdG1r+rgAvofWXlztRZ7Gd01a0S
         XTpVeECA6WAc8nMPkf/Gmhz4/bBqpt1lH+8ZfeoN5ocn2X8NutwYRgyGOl5Ql/DqsF
         gXH8FW70x02Vg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon, 20 Mar 2023 21:05:40 +0300 (MSK)
Message-ID: <2be688af-89a6-d903-017b-dafee3e48c33@sberdevices.ru>
Date:   Mon, 20 Mar 2023 21:02:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v2] virtio/vsock: allocate multiple skbuffs on tx
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
References: <ea5725eb-6cb5-cf15-2938-34e335a442fa@sberdevices.ru>
 <20230320142959.2wwf474fiyp3ex5z@sgarzare-redhat>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230320142959.2wwf474fiyp3ex5z@sgarzare-redhat>
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



On 20.03.2023 17:29, Stefano Garzarella wrote:
> On Sun, Mar 19, 2023 at 09:46:10PM +0300, Arseniy Krasnov wrote:
>> This adds small optimization for tx path: instead of allocating single
>> skbuff on every call to transport, allocate multiple skbuff's until
>> credit space allows, thus trying to send as much as possible data without
>> return to af_vsock.c.
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> Link to v1:
>> https://lore.kernel.org/netdev/2c52aa26-8181-d37a-bccd-a86bd3cbc6e1@sberdevices.ru/
>>
>> Changelog:
>> v1 -> v2:
>> - If sent something, return number of bytes sent (even in
>>   case of error). Return error only if failed to sent first
>>   skbuff.
>>
>> net/vmw_vsock/virtio_transport_common.c | 53 ++++++++++++++++++-------
>> 1 file changed, 39 insertions(+), 14 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 6564192e7f20..3fdf1433ec28 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -196,7 +196,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>     const struct virtio_transport *t_ops;
>>     struct virtio_vsock_sock *vvs;
>>     u32 pkt_len = info->pkt_len;
>> -    struct sk_buff *skb;
>> +    u32 rest_len;
>> +    int ret;
>>
>>     info->type = virtio_transport_get_type(sk_vsock(vsk));
>>
>> @@ -216,10 +217,6 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>
>>     vvs = vsk->trans;
>>
>> -    /* we can send less than pkt_len bytes */
>> -    if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
>> -        pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>> -
>>     /* virtio_transport_get_credit might return less than pkt_len credit */
>>     pkt_len = virtio_transport_get_credit(vvs, pkt_len);
>>
>> @@ -227,17 +224,45 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>     if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
>>         return pkt_len;
>>
>> -    skb = virtio_transport_alloc_skb(info, pkt_len,
>> -                     src_cid, src_port,
>> -                     dst_cid, dst_port);
>> -    if (!skb) {
>> -        virtio_transport_put_credit(vvs, pkt_len);
>> -        return -ENOMEM;
>> -    }
>> +    ret = 0;
>> +    rest_len = pkt_len;
>> +
>> +    do {
>> +        struct sk_buff *skb;
>> +        size_t skb_len;
>> +
>> +        skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE, rest_len);
>> +
>> +        skb = virtio_transport_alloc_skb(info, skb_len,
>> +                         src_cid, src_port,
>> +                         dst_cid, dst_port);
>> +        if (!skb) {
>> +            ret = -ENOMEM;
>> +            break;
>> +        }
>> +
>> +        virtio_transport_inc_tx_pkt(vvs, skb);
>> +
>> +        ret = t_ops->send_pkt(skb);
>> +
>> +        if (ret < 0)
>> +            break;
>>
>> -    virtio_transport_inc_tx_pkt(vvs, skb);
>> +        rest_len -= skb_len;
> 
> t_ops->send_pkt() is returning the number of bytes sent. Current
> implementations always return `skb_len`, so there should be no problem,
> but it would be better to put a comment here, or we should handle the
> case where ret != skb_len to avoid future issues.

Hello, thanks for review!

I see. I think i'll handle such partial sends (ret != skb_len) as error, as
it is the only thing to do - we remove 'skb_len' from user's buffer, but
'send_pkt()' returns another value, so it will be strange for me to continue
this tx loop as everything is ok. Something like this:
+ 
+ if (ret < 0)
+    break;
+ 
+ if (ret != skb_len) {
+    ret = -EFAULT;//or may be -EIO
+    break;
+ }

> 
>> +    } while (rest_len);
>>
>> -    return t_ops->send_pkt(skb);
>> +    /* Don't call this function with zero as argument:
>> +     * it tries to acquire spinlock and such argument
>> +     * makes this call useless.
> 
> Good point, can we do the same also for virtio_transport_get_credit()?
> (Maybe in a separate patch)
> 
> I'm thinking if may be better to do it directly inside the functions,
> but I don't have a strong opinion on that since we only call them here.
> 

I think in this patch i can call 'virtio_transport_put_credit()' without if, but
i'll prepare separate patch which adds zero argument check to this function.
As i see, the only function suitable for such 'if' condition is 'virtio_transport_put_credit()'.
Anyway - for future use this check won't be bad.

Thanks, Arseniy

> Thanks,
> Stefano
> 
>> +     */
>> +    if (rest_len)
>> +        virtio_transport_put_credit(vvs, rest_len);
>> +
>> +    /* Return number of bytes, if any data has been sent. */
>> +    if (rest_len != pkt_len)
>> +        ret = pkt_len - rest_len;
>> +
>> +    return ret;
>> }
>>
>> static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
>> -- 
>> 2.25.1
>>
> 
