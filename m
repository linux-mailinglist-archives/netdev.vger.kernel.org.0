Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4B06AC50B
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 16:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjCFPbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 10:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbjCFPbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 10:31:09 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D1319D;
        Mon,  6 Mar 2023 07:31:01 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 44A465FD22;
        Mon,  6 Mar 2023 18:30:58 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678116658;
        bh=OgZo6Aq2fk3CdEmFT2c72x8cXEzEqOMILRx65+UY1xc=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=m2YwdLTgKmljuNPF6h8pyjPgj/ohC6JcQ84QGyTb1isFXjiOaYn47CnChs9hk2I0x
         oY2Pjs4tYaJ5SXMphgB22JDwBs7hgMxkzq3cHuFEy/jqxgTOHLtpgcTiYTR9xw5fW4
         uyNteMOJ8gKKDbZMEYppeXCno7bcxcHV6vsov8pjM5wyJwFt0Uq9wfUgIP0qCzxoBe
         bzRmRVH1AZiguFRnGGlGcpNQ91WpTGleqEdlOEbMUJvz/+5e3WXvKu3SCoiUq8ti3R
         V7zHLBoGcEakSne927ands0SnvcVgX48pBucmlqmJ3Q/9gAZVixCbvlpYZTjeyySI3
         CvGKbzPKaaMvQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  6 Mar 2023 18:30:53 +0300 (MSK)
Message-ID: <c9b0b5b7-def1-b849-ca94-714bb6763266@sberdevices.ru>
Date:   Mon, 6 Mar 2023 18:27:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v2 1/4] virtio/vsock: fix 'rx_bytes'/'fwd_cnt'
 calculation
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
 <4a3f3978-1093-4c0a-663f-28d77eeb0806@sberdevices.ru>
 <20230306115718.2h7munjxd2royuzq@sgarzare-redhat>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230306115718.2h7munjxd2royuzq@sgarzare-redhat>
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



On 06.03.2023 14:57, Stefano Garzarella wrote:
> On Sun, Mar 05, 2023 at 11:06:26PM +0300, Arseniy Krasnov wrote:
>> Substraction of 'skb->len' is redundant here: 'skb_headroom()' is delta
>> between 'data' and 'head' pointers, e.g. it is number of bytes returned
>> to user (of course accounting size of header). 'skb->len' is number of
>> bytes rest in buffer.
>>
>> Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> net/vmw_vsock/virtio_transport_common.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index a1581c77cf84..2e2a773df5c1 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -255,7 +255,7 @@ static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
>> {
>>     int len;
>>
>> -    len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr) - skb->len;
>> +    len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr);
> 
> IIUC virtio_transport_dec_rx_pkt() is always called after skb_pull(),
> so skb_headroom() is returning the amount of space we removed.
> 
> Looking at the other patches in this series, I think maybe we should
> change virtio_transport_dec_rx_pkt() and virtio_transport_inc_rx_pkt()
> by passing the value to subtract or add directly.
> Since some times we don't remove the whole payload, so it would be
> better to call it with the value in hdr->len.
> 
> I mean something like this (untested):
> 
> index a1581c77cf84..9e69ae7a9a96 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -241,21 +241,18 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>  }
> 
>  static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
> -                                       struct sk_buff *skb)
> +                                       u32 len)
>  {
> -       if (vvs->rx_bytes + skb->len > vvs->buf_alloc)
> +       if (vvs->rx_bytes + len > vvs->buf_alloc)
>                 return false;
> 
> -       vvs->rx_bytes += skb->len;
> +       vvs->rx_bytes += len;
>         return true;
>  }
> 
>  static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
> -                                       struct sk_buff *skb)
> +                                       u32 len)
>  {
> -       int len;
> -
> -       len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr) - skb->len;
>         vvs->rx_bytes -= len;
>         vvs->fwd_cnt += len;
>  }
> @@ -388,7 +385,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>                 skb_pull(skb, bytes);
> 
>                 if (skb->len == 0) {
> -                       virtio_transport_dec_rx_pkt(vvs, skb);
> +                       virtio_transport_dec_rx_pkt(vvs, bytes);
>                         consume_skb(skb);
>                 } else {
>                         __skb_queue_head(&vvs->rx_queue, skb);
> @@ -437,17 +434,17 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 
>         while (!msg_ready) {
>                 struct virtio_vsock_hdr *hdr;
> +               size_t pkt_len;
> 
>                 skb = __skb_dequeue(&vvs->rx_queue);
>                 if (!skb)
>                         break;
>                 hdr = virtio_vsock_hdr(skb);
> +               pkt_len = (size_t)le32_to_cpu(hdr->len);
> 
>                 if (dequeued_len >= 0) {
> -                       size_t pkt_len;
>                         size_t bytes_to_copy;
> 
> -                       pkt_len = (size_t)le32_to_cpu(hdr->len);
>                         bytes_to_copy = min(user_buf_len, pkt_len);
> 
>                         if (bytes_to_copy) {
> @@ -484,7 +481,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>                                 msg->msg_flags |= MSG_EOR;
>                 }
> 
> -               virtio_transport_dec_rx_pkt(vvs, skb);
> +               virtio_transport_dec_rx_pkt(vvs, pkt_len);
>                 kfree_skb(skb);
>         }
> 
> @@ -1040,7 +1037,7 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
> 
>         spin_lock_bh(&vvs->rx_lock);
> 
> -       can_enqueue = virtio_transport_inc_rx_pkt(vvs, skb);
> +       can_enqueue = virtio_transport_inc_rx_pkt(vvs, len);
>         if (!can_enqueue) {
>                 free_pkt = true;
>                 goto out;
> 
> When we used vsock_pkt, we were passing the structure because the `len`
> field was immutable (and copied from the header), whereas with skb it
> can change and so we introduced these errors.
> 
> What do you think?
Yes, i think passing explicit integer value to 'virtio_transport_inc/dec_rx_pkt'
is more clear solution. I had this variant, but thought that current will be
smaller. Current version with skb argument forces to call 'skb_pull()' before
each 'virtio_transport_dec_rx_pkt()' as 'rx_bytes'/'fwd_cnt' new value relies
on skb parameters - otherwise 'rx_bytes' become invalid. 'skb_pull()' will be
used only to update 'skb->len' which shows rest of the data. I'll do it in v3.

Thanks, Arseniy
> 
> Thanks,
> Stefano
> 
