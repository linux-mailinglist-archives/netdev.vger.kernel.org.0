Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE046C2C6B
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbjCUIam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjCUIaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:30:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE4EAD15
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679387343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VdAkEc4+Jc17UFo+IFspyWLrKMsHzFG0fne7hcDGYj8=;
        b=Ci6ImXke8kXLFchYBEsDDzUT0PzH3Cqy5S3oLhkQZzD0bKXDsvgb2KTcMEpkyUioptUgOU
        qjDd0kTo+O9nvJXREhH3lGD2DsRtzOgYbWOYzcRYNqf17Wcct7b38GkNWVBhRkpPYTjwSi
        mVze4YVwl07YB68jxX91Ms7iT10mCcE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-t1Gu3Yd9OA6U-7jDh16BIA-1; Tue, 21 Mar 2023 04:29:02 -0400
X-MC-Unique: t1Gu3Yd9OA6U-7jDh16BIA-1
Received: by mail-qk1-f197.google.com with SMTP id x80-20020a376353000000b0074681bc7f42so2578757qkb.8
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679387342;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VdAkEc4+Jc17UFo+IFspyWLrKMsHzFG0fne7hcDGYj8=;
        b=n35SVKYuG/4FHtIN9PIXloyDfAgYGQFA5ibdkr5xIKvg7PCGj3PRXHMgJk7eOmbHsa
         LsQVaKGaCv/zRw1cJmf74Vocihf2BoIaIvru8ZjoJ59cjXGxWn4L3X5J3TZeK34GOJXd
         F0HNdOljESKSdJCKKLS7576oPxQmkz0ySKCiFcSfnUhKDf2TDvOmUQChRqADYxgFYuq7
         0OmsGtV88XZS8OlBgd8wwRIlqa6k0sUCD1PUPE7qD2vnYisVB4CtxtljNPIS3QszKLdk
         6FR0NQqRzsEBepgThjDHn8gwV9Q23JmeA/T7+nzJwXejn6ZERMKHUZis+qziks3qaMWR
         RzFQ==
X-Gm-Message-State: AO0yUKXyDecyto3rfAuELoNuPd/hvPJ/zKY4gEr3kxVWzIHsbzoaknRl
        6q1DT1VvXHXTOFgU8VOpeSYOk9af+Q38yG1yLocoujKZRCc+UKuk0nu1Kzd1j9ayk3abvp9XSt3
        CU9xLJ7G2U4eR3by5
X-Received: by 2002:a05:622a:1051:b0:3d4:eb79:744f with SMTP id f17-20020a05622a105100b003d4eb79744fmr3461675qte.24.1679387342093;
        Tue, 21 Mar 2023 01:29:02 -0700 (PDT)
X-Google-Smtp-Source: AK7set8+9mH/ASsttF6m8QpFD8AJ5PwroH0B+Mwvj5O0naMIvFjj0iJ1GdQ1UqCQuemzR8tKily5qQ==
X-Received: by 2002:a05:622a:1051:b0:3d4:eb79:744f with SMTP id f17-20020a05622a105100b003d4eb79744fmr3461667qte.24.1679387341779;
        Tue, 21 Mar 2023 01:29:01 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id i19-20020ac87653000000b003b9a73cd120sm279816qtr.17.2023.03.21.01.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 01:29:01 -0700 (PDT)
Date:   Tue, 21 Mar 2023 09:28:54 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2] virtio/vsock: allocate multiple skbuffs on tx
Message-ID: <20230321082854.jluiqjyc4n5k2vza@sgarzare-redhat>
References: <ea5725eb-6cb5-cf15-2938-34e335a442fa@sberdevices.ru>
 <20230320142959.2wwf474fiyp3ex5z@sgarzare-redhat>
 <2be688af-89a6-d903-017b-dafee3e48c33@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2be688af-89a6-d903-017b-dafee3e48c33@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 09:02:19PM +0300, Arseniy Krasnov wrote:
>
>
>On 20.03.2023 17:29, Stefano Garzarella wrote:
>> On Sun, Mar 19, 2023 at 09:46:10PM +0300, Arseniy Krasnov wrote:
>>> This adds small optimization for tx path: instead of allocating single
>>> skbuff on every call to transport, allocate multiple skbuff's until
>>> credit space allows, thus trying to send as much as possible data without
>>> return to af_vsock.c.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>> Link to v1:
>>> https://lore.kernel.org/netdev/2c52aa26-8181-d37a-bccd-a86bd3cbc6e1@sberdevices.ru/
>>>
>>> Changelog:
>>> v1 -> v2:
>>> - If sent something, return number of bytes sent (even in
>>>   case of error). Return error only if failed to sent first
>>>   skbuff.
>>>
>>> net/vmw_vsock/virtio_transport_common.c | 53 ++++++++++++++++++-------
>>> 1 file changed, 39 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>> index 6564192e7f20..3fdf1433ec28 100644
>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>> @@ -196,7 +196,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>>     const struct virtio_transport *t_ops;
>>>     struct virtio_vsock_sock *vvs;
>>>     u32 pkt_len = info->pkt_len;
>>> -    struct sk_buff *skb;
>>> +    u32 rest_len;
>>> +    int ret;
>>>
>>>     info->type = virtio_transport_get_type(sk_vsock(vsk));
>>>
>>> @@ -216,10 +217,6 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>>
>>>     vvs = vsk->trans;
>>>
>>> -    /* we can send less than pkt_len bytes */
>>> -    if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
>>> -        pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>>> -
>>>     /* virtio_transport_get_credit might return less than pkt_len credit */
>>>     pkt_len = virtio_transport_get_credit(vvs, pkt_len);
>>>
>>> @@ -227,17 +224,45 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>>     if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
>>>         return pkt_len;
>>>
>>> -    skb = virtio_transport_alloc_skb(info, pkt_len,
>>> -                     src_cid, src_port,
>>> -                     dst_cid, dst_port);
>>> -    if (!skb) {
>>> -        virtio_transport_put_credit(vvs, pkt_len);
>>> -        return -ENOMEM;
>>> -    }
>>> +    ret = 0;
>>> +    rest_len = pkt_len;
>>> +
>>> +    do {
>>> +        struct sk_buff *skb;
>>> +        size_t skb_len;
>>> +
>>> +        skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE, rest_len);
>>> +
>>> +        skb = virtio_transport_alloc_skb(info, skb_len,
>>> +                         src_cid, src_port,
>>> +                         dst_cid, dst_port);
>>> +        if (!skb) {
>>> +            ret = -ENOMEM;
>>> +            break;
>>> +        }
>>> +
>>> +        virtio_transport_inc_tx_pkt(vvs, skb);
>>> +
>>> +        ret = t_ops->send_pkt(skb);
>>> +
>>> +        if (ret < 0)
>>> +            break;
>>>
>>> -    virtio_transport_inc_tx_pkt(vvs, skb);
>>> +        rest_len -= skb_len;
>>
>> t_ops->send_pkt() is returning the number of bytes sent. Current
>> implementations always return `skb_len`, so there should be no problem,
>> but it would be better to put a comment here, or we should handle the
>> case where ret != skb_len to avoid future issues.
>
>Hello, thanks for review!
>
>I see. I think i'll handle such partial sends (ret != skb_len) as error, as
>it is the only thing to do - we remove 'skb_len' from user's buffer, but
>'send_pkt()' returns another value, so it will be strange for me to continue
>this tx loop as everything is ok. Something like this:
>+
>+ if (ret < 0)
>+    break;
>+
>+ if (ret != skb_len) {
>+    ret = -EFAULT;//or may be -EIO
>+    break;
>+ }

Good for me.

>
>>
>>> +    } while (rest_len);
>>>
>>> -    return t_ops->send_pkt(skb);
>>> +    /* Don't call this function with zero as argument:
>>> +     * it tries to acquire spinlock and such argument
>>> +     * makes this call useless.
>>
>> Good point, can we do the same also for virtio_transport_get_credit()?
>> (Maybe in a separate patch)
>>
>> I'm thinking if may be better to do it directly inside the functions,
>> but I don't have a strong opinion on that since we only call them here.
>>
>
>I think in this patch i can call 'virtio_transport_put_credit()' without if, but
>i'll prepare separate patch which adds zero argument check to this function.

Yep, I agree.

>As i see, the only function suitable for such 'if' condition is
>'virtio_transport_put_credit()'.

Why not even for virtio_transport_get_credit() ?

When we send packets without payload (e.g. VIRTIO_VSOCK_OP_REQUEST,
VIRTIO_VSOCK_OP_SHUTDOWN) we call virtio_transport_get_credit()
with `credit` parameter equal to 0, then we acquire the spinlock but
in the end we do nothing.

>Anyway - for future use this check won't be bad.

Yep, these are minor improvements ;-)

Thanks,
Stefano

