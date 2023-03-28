Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838B76CBB27
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbjC1Jg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjC1Jgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:36:39 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E9C7DA0;
        Tue, 28 Mar 2023 02:35:41 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 2F2215FD0E;
        Tue, 28 Mar 2023 12:35:38 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679996138;
        bh=3PbLJXlMS03N1z+S8n5YYeRBHkPx2Jy2H4fazX9eSgM=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=l1n8TpPu/p6OJEkJNH6kOrwK+E/UeccbzVOc2ZMwO6mRYUox6066R3ViEh/LNc0mY
         HCWM8AHxjGpnVvodnApWGoeNnrkKSOqC7KVtnTuA3Z7jUtkLS5iNZ1+ox99WxVtsOe
         Z/n+wtlZJ5BsDr3ZI+0hvehBwIzxXYoTMMiuUoM7PkTUQ1BOx4to4ggxPLEElT9cy1
         y0+1R597Il65L1Nvel8NhfFng3718nIVDqPXj6T2mZ/zlqRbXO4N0Xc2JvVE7dIyoI
         DDYsvoO6mJE2+N7BDTNejUyrrHVq/LhpUm7dm0b8isySObpvetM/F/T2wAV3Xz7SrB
         tva+dyucyWp2w==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 28 Mar 2023 12:35:34 +0300 (MSK)
Message-ID: <d91ac5f0-1f47-58b3-d033-f492d0e17da7@sberdevices.ru>
Date:   Tue, 28 Mar 2023 12:32:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v2 2/3] virtio/vsock: WARN_ONCE() for invalid state of
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
References: <728181e9-6b35-0092-3d01-3d7aff4521b6@sberdevices.ru>
 <30aa2604-77c0-322e-44fd-ff99fc25e388@sberdevices.ru>
 <lgpswwclsuiukh2q5couf33jytf6abneazmwkty6fevoxcgh5p@3dzfbmenjhco>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <lgpswwclsuiukh2q5couf33jytf6abneazmwkty6fevoxcgh5p@3dzfbmenjhco>
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



On 28.03.2023 12:29, Stefano Garzarella wrote:
> On Sun, Mar 26, 2023 at 01:09:25AM +0300, Arseniy Krasnov wrote:
>> This adds WARN_ONCE() and return from stream dequeue callback when
>> socket's queue is empty, but 'rx_bytes' still non-zero.
> 
> Nit: I would explain why we add this, for example:
> 
> This allows the detection of potential bugs due to packet merging
> (see previous patch).
> 
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> net/vmw_vsock/virtio_transport_common.c | 7 +++++++
>> 1 file changed, 7 insertions(+)
> 
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index b9144af71553..ad70531de133 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -398,6 +398,13 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>>     u32 free_space;
>>
>>     spin_lock_bh(&vvs->rx_lock);
>> +
>> +    if (WARN_ONCE(skb_queue_empty(&vvs->rx_queue) && vvs->rx_bytes,
>> +              "No skbuffs with non-zero 'rx_bytes'\n")) {
> 
> Nit: I would rephrase it this way:
> "rx_queue is empty, but rx_bytes is non-zero"
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
> Anyway the patch LGTM!

Thanks for review! Since only string value and commit message should be
updated, i can resend it with 'net' (as it is fix) and update two thing
above in 'net' version?

Thanks, Arseniy
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> 
