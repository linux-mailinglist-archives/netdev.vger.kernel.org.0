Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682C76C53E6
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjCVSmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCVSmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:42:03 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD6E46142;
        Wed, 22 Mar 2023 11:42:01 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id C13FF5FD3E;
        Wed, 22 Mar 2023 21:41:59 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679510519;
        bh=FW8jr4pUz8iTbODmex7VnHAmCT1DPjH/4GpL+Pk/K5w=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=EMnTNapepoxBw+9De79Jnrf9xt9+Ww5heQcA1F5qDSdockR9CsAEwu66BsQf2iDRz
         MNHQj7U1ms3SmdGmHdM1wzPXHc5eX9rerFMyi4VyEi+FWISJJXmKY3pLu9vdjJuRDC
         7aXZqNvcezeBlnfGVHXMbTPm1lWg76sfamAr4sx4ScDzjdmYx/eOBZ/ncZxT1Knw0B
         eqLekMEigPjBI4I8MQPCeliBtKQdmaYRaoG2qCCr64oLVeJjIFl8wqiAlQnbj244SC
         aOlmPUfpKzVdygOJ5S6pv2ifzJli8NPRPcCpeJjasFvUmso3zGngbJzivzVaMnCUIC
         U0t/iUw8QucIQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Wed, 22 Mar 2023 21:41:59 +0300 (MSK)
Message-ID: <5651ac8a-db47-2462-e651-e5c6935847b9@sberdevices.ru>
Date:   Wed, 22 Mar 2023 21:38:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v4] virtio/vsock: allocate multiple skbuffs on tx
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
References: <0e0c1421-7cdc-2582-b120-cad6f42824bb@sberdevices.ru>
 <20230322144115.sz3icgbnhjgae2fj@sgarzare-redhat>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230322144115.sz3icgbnhjgae2fj@sgarzare-redhat>
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/22 14:20:00 #20991698
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22.03.2023 17:41, Stefano Garzarella wrote:
> On Tue, Mar 21, 2023 at 06:03:14PM +0300, Arseniy Krasnov wrote:
>> This adds small optimization for tx path: instead of allocating single
>> skbuff on every call to transport, allocate multiple skbuff's until
>> credit space allows, thus trying to send as much as possible data without
>> return to af_vsock.c.
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> Link to v1:
>> https://lore.kernel.org/netdev/2c52aa26-8181-d37a-bccd-a86bd3cbc6e1@sberdevices.ru/
>> Link to v2:
>> https://lore.kernel.org/netdev/ea5725eb-6cb5-cf15-2938-34e335a442fa@sberdevices.ru/
>> Link to v3:
>> https://lore.kernel.org/netdev/f33ef593-982e-2b3f-0986-6d537a3aaf08@sberdevices.ru/
>>
>> Changelog:
>> v1 -> v2:
>> - If sent something, return number of bytes sent (even in
>>   case of error). Return error only if failed to sent first
>>   skbuff.
>>
>> v2 -> v3:
>> - Handle case when transport callback returns unexpected value which
>>   is not equal to 'skb->len'. Break loop.
>> - Don't check for zero value of 'rest_len' before calling
>>   'virtio_transport_put_credit()'. Decided to add this check directly
>>   to 'virtio_transport_put_credit()' in separate patch.
>>
>> v3 -> v4:
>> - Use WARN_ONCE() to handle case when transport callback returns
>>   unexpected value.
>> - Remove useless 'ret = -EFAULT;' assignment for case above.
>>
>> net/vmw_vsock/virtio_transport_common.c | 59 +++++++++++++++++++------
>> 1 file changed, 45 insertions(+), 14 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 6564192e7f20..a300f25749ea 100644
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
>> @@ -227,17 +224,51 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
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
> 
> nit: this initialization seems superfluous since `ret` is
> overwritten later ...
> 
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
>>
>> -    virtio_transport_inc_tx_pkt(vvs, skb);
>> +        virtio_transport_inc_tx_pkt(vvs, skb);
>>
>> -    return t_ops->send_pkt(skb);
>> +        ret = t_ops->send_pkt(skb);
> 
> ... here.
> 
>> +
> 
> nit: we can remove this extra line
> 
>> +        if (ret < 0)
>> +            break;
>> +
>> +        /* Both virtio and vhost 'send_pkt()' returns 'skb_len',
>> +         * but for reliability use 'ret' instead of 'skb_len'.
>> +         * Also if partial send happens (e.g. 'ret' != 'skb_len')
>> +         * somehow, we break this loop, but account such returned
>> +         * value in 'virtio_transport_put_credit()'.
>> +         */
>> +        rest_len -= ret;
>> +
>> +        if (WARN_ONCE(ret != skb_len,
>> +                  "'send_pkt()' returns %i, but %zu expected\n",
>> +                  ret, skb_len))
>> +            break;
>> +    } while (rest_len);
>> +
>> +    virtio_transport_put_credit(vvs, rest_len);
>> +
>> +    /* Return number of bytes, if any data has been sent. */
>> +    if (rest_len != pkt_len)
>> +        ret = pkt_len - rest_len;
>> +
>> +    return ret;
>> }
>>
>> static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
>> -- 2.25.1
>>
> 
> The patch LGTM:
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> Anyway, feel free to include in the same series or as separate patch
> also the changes to avoid useless lock in virtio_transport_put_credit()
> and virtio_transport_get_credit().
> 
> I would include it in this series, because before these changes, we
> used to call virtio_transport_put_credit() only in the error path,
> while now we always call it, even when rest_len is 0.

Thanks for review, done!
https://lore.kernel.org/netdev/f0b283a1-cc63-dc3d-cc0c-0da7f684d4d2@sberdevices.ru/
Added it as second patch to the series

Thanks, Arseniy
> 
> Thanks,
> Stefano
> 
