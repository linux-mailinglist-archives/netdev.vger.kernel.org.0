Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8911365733D
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 07:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiL1Gb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 01:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiL1Gbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 01:31:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43E3BC87
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 22:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672209069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n2KeMAKOxs2dGkktehdaFB5TmuZYls6R2nspxmVS2pc=;
        b=KFe2ctBeM6BENHbnbuKKCf4MH+CeKeiyWaW/5FaF0GuEHd/nCjhjD7rWmLpa+KUnHP8iu4
        iciaf5gSL1mPtUPclpi0CE2eEe/7LPyhn04ilsMVTHAh17MtaJSKKa3nt5TiTYe6yAq35Y
        8/1VKnjbScWcabN1ziwDssP+s6LPUAw=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-491-kgzmcn3sMPy4Dil5_-yiMw-1; Wed, 28 Dec 2022 01:31:00 -0500
X-MC-Unique: kgzmcn3sMPy4Dil5_-yiMw-1
Received: by mail-pg1-f197.google.com with SMTP id a72-20020a63904b000000b00489753edf13so7680418pge.21
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 22:31:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n2KeMAKOxs2dGkktehdaFB5TmuZYls6R2nspxmVS2pc=;
        b=v4qIx4o4s5PlZnk7rOSys1IXR/nSNddcRTgvoGb4I+VtYiSMDySlL4uTGTKeC+ia9e
         HSxunnTmfpQKp9Y5V6Jxi/UvfTlb8Cp2TcFQM2Oa02Oz3hzrDDeg0LCnu4XPQh3AaIph
         kQGnebOMXIZSd95AK56yTc4GrHYPrQLxFqC8t+yq/JjtFnQjGhr8xt5jjZXVjHOTGxkg
         ruV2Pu+VsW3EddkA2z8gDBiY0A7Wd/8rulwf86QwkEjG3tShAGxA9VYJszuM47cSUTeV
         4t2FrytOhha0uKS5obbmS6vf9evdX4e4VbT+AjUMR99MOJSwHcFzErpUUozJD4db27u5
         PPCw==
X-Gm-Message-State: AFqh2ko6ozA4m414a+QhxJJWq+6HBpmufemMdnyuEDHgD/J8D2ldkJQ7
        Ao/yhMku9htbWQWF6/4P7aQEGpyRCY844vsPOf/g9DPubdLO2b1Ps4bbLeu7qpB5Y2E7D1EpgbY
        x+DCeDX8EkGiFgo6Z
X-Received: by 2002:aa7:83d1:0:b0:580:d71e:a2e5 with SMTP id j17-20020aa783d1000000b00580d71ea2e5mr13675276pfn.22.1672209059051;
        Tue, 27 Dec 2022 22:30:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtz3LablvI6pdqRyz217g39tTPszwJTsdsge+IYn9p6MPtMFBIkxfvLDffbVwiH91mSnroOTQ==
X-Received: by 2002:aa7:83d1:0:b0:580:d71e:a2e5 with SMTP id j17-20020aa783d1000000b00580d71ea2e5mr13675258pfn.22.1672209058777;
        Tue, 27 Dec 2022 22:30:58 -0800 (PST)
Received: from [10.72.13.7] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b67-20020a621b46000000b0053e38ac0ff4sm9485379pfb.115.2022.12.27.22.30.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 22:30:58 -0800 (PST)
Message-ID: <d0126685-10ea-eab6-9b05-53cb30103da2@redhat.com>
Date:   Wed, 28 Dec 2022 14:30:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2 6/9] virtio_net: transmit the multi-buffer xdp
Content-Language: en-US
To:     Heng Qi <hengqi@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
 <20221220141449.115918-7-hengqi@linux.alibaba.com>
 <af506b2f-698f-b3d8-8bc4-f48e2c429ce7@redhat.com>
 <f8b8e76c-6438-9ea5-18e4-24773fa01cfd@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <f8b8e76c-6438-9ea5-18e4-24773fa01cfd@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/12/27 16:26, Heng Qi 写道:
>
>
> 在 2022/12/27 下午3:12, Jason Wang 写道:
>>
>> 在 2022/12/20 22:14, Heng Qi 写道:
>>> This serves as the basis for XDP_TX and XDP_REDIRECT
>>> to send a multi-buffer xdp_frame.
>>>
>>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> ---
>>>   drivers/net/virtio_net.c | 27 ++++++++++++++++++++++-----
>>>   1 file changed, 22 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index 40bc58fa57f5..9f31bfa7f9a6 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -563,22 +563,39 @@ static int __virtnet_xdp_xmit_one(struct 
>>> virtnet_info *vi,
>>>                      struct xdp_frame *xdpf)
>>>   {
>>>       struct virtio_net_hdr_mrg_rxbuf *hdr;
>>> -    int err;
>>> +    struct skb_shared_info *shinfo;
>>> +    u8 nr_frags = 0;
>>> +    int err, i;
>>>         if (unlikely(xdpf->headroom < vi->hdr_len))
>>>           return -EOVERFLOW;
>>>   -    /* Make room for virtqueue hdr (also change xdpf->headroom?) */
>>> +    if (unlikely(xdp_frame_has_frags(xdpf))) {
>>> +        shinfo = xdp_get_shared_info_from_frame(xdpf);
>>> +        nr_frags = shinfo->nr_frags;
>>> +    }
>>> +
>>> +    /* Need to adjust this to calculate the correct postion
>>> +     * for shinfo of the xdpf.
>>> +     */
>>> +    xdpf->headroom -= vi->hdr_len;
>>
>>
>> Any reason we need to do this here? (Or if it is, is it only needed 
>> for multibuffer XDP?)
>
> Going back to its wrapping function virtnet_xdp_xmit(), we need to 
> free up the pending old buffers.
> If the "is_xdp_frame(ptr)" condition is met, then we need to calculate 
> the position of skb_shared_info
> in xdp_get_frame_len() and xdp_return_frame(), which will involve to 
> xdpf->data and xdpf->headroom.
> Therefore, we need to update the value of headroom synchronously here.


Let's tweak the comment above to something like this.

With that fixed,

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


>
> Also, it's not necessary for single-buffer xdp, but we need to keep it 
> because it's harmless and as it should be.
>
> Thanks.
>
>>
>> Other looks good.
>>
>> Thanks
>>
>>
>>>       xdpf->data -= vi->hdr_len;
>>>       /* Zero header and leave csum up to XDP layers */
>>>       hdr = xdpf->data;
>>>       memset(hdr, 0, vi->hdr_len);
>>>       xdpf->len   += vi->hdr_len;
>>>   -    sg_init_one(sq->sg, xdpf->data, xdpf->len);
>>> +    sg_init_table(sq->sg, nr_frags + 1);
>>> +    sg_set_buf(sq->sg, xdpf->data, xdpf->len);
>>> +    for (i = 0; i < nr_frags; i++) {
>>> +        skb_frag_t *frag = &shinfo->frags[i];
>>> +
>>> +        sg_set_page(&sq->sg[i + 1], skb_frag_page(frag),
>>> +                skb_frag_size(frag), skb_frag_off(frag));
>>> +    }
>>>   -    err = virtqueue_add_outbuf(sq->vq, sq->sg, 1, xdp_to_ptr(xdpf),
>>> -                   GFP_ATOMIC);
>>> +    err = virtqueue_add_outbuf(sq->vq, sq->sg, nr_frags + 1,
>>> +                   xdp_to_ptr(xdpf), GFP_ATOMIC);
>>>       if (unlikely(err))
>>>           return -ENOSPC; /* Caller handle free/refcnt */
>

