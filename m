Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60ED63B5850
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 06:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhF1E3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 00:29:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45129 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229578AbhF1E3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 00:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624854448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o1xtLTToeyqa2U4eJBXFpKDKIzd68CvhihFPifGQBPQ=;
        b=LhxR9twiM3fYxtQb2t7o4w/hcD0G/vNms5C5Bs5NBXTvlNvu2TAArHdDXK8aLy4dl48fPv
        q1jIKCkuQ8qIQDFCpAdnWFgNIrShZjsB6XWhEWGQwyGbAwdXXPD0h5emK4okY/PaJtYpsf
        syETBhQI5vaLyiOvvRWKyvvSt22Rsoc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-Zu0R2lxSMQi_aNwXwyj_Rw-1; Mon, 28 Jun 2021 00:27:26 -0400
X-MC-Unique: Zu0R2lxSMQi_aNwXwyj_Rw-1
Received: by mail-pj1-f70.google.com with SMTP id u8-20020a17090a8908b029016f79b38655so11183821pjn.8
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 21:27:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=o1xtLTToeyqa2U4eJBXFpKDKIzd68CvhihFPifGQBPQ=;
        b=e3k3MP7h/m8LrQ/NwP3PTGmvoeGDNK3U8qh7GRMKCQE1x36mVl2ai5JKlTrOVyB43q
         a6yDndbcMR9YCT9ZxCwyRPxdr1YUz98ZmsrRat7es6RQq4lsV+iMSVsVR693bXMEr/jA
         AgZHR4GqS8XUDmLSbwlgbRHtPknZ428Bfx4pdGp47t81sU+2HPMLmcrO8gwiThg+FQ7L
         SoV8PKbasK/fsSYxA+iL5bqX+1onGeFpmk2b9BbmUjAiikI/m4DHhy+l2V8uxVkZR9oY
         btWc6RXJhbWNmjO6bXCfvFMY44i+W+aDjRo9rZG3wP43msZvo79lZ6aVeYBTTrXAjSgs
         xuwg==
X-Gm-Message-State: AOAM533a8ciO+a26NqdkeNw2BWRNcBQom/SntFxLoylSz66GE7lb7piP
        lU9vQ1to4CJWc6TKzw6boShQ5JNaRi0HZvkz6j4k8hMJ0GkcwAJWtDDSJsa96eO9rf+CNDfbdS2
        ZCPCvLC4lxGhzTMsu
X-Received: by 2002:a17:90b:3142:: with SMTP id ip2mr34543001pjb.63.1624854445326;
        Sun, 27 Jun 2021 21:27:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTxjiSUInT9Lkq2bvqXC0+T2xLQ44T+XHJaHjdcs/PVsq1liVR3goJXjp3j0Q6IoPdBYTtMQ==
X-Received: by 2002:a17:90b:3142:: with SMTP id ip2mr34542983pjb.63.1624854445157;
        Sun, 27 Jun 2021 21:27:25 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l4sm1611362pjf.49.2021.06.27.21.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Jun 2021 21:27:24 -0700 (PDT)
Subject: Re: [PATCH v3 4/5] net: tun: fix tun_xdp_one() for IFF_TUN mode
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
 <20210624123005.1301761-4-dwmw2@infradead.org>
 <be6ec48e-ffc7-749b-f775-a34d376f474c@redhat.com>
 <32071ebb3f433b239394e243a6fc8a2bc6d36dcb.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8914d56f-8059-71df-ab51-9fbb9637e45a@redhat.com>
Date:   Mon, 28 Jun 2021 12:27:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <32071ebb3f433b239394e243a6fc8a2bc6d36dcb.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/25 下午4:51, David Woodhouse 写道:
> On Fri, 2021-06-25 at 15:41 +0800, Jason Wang wrote:
>> 在 2021/6/24 下午8:30, David Woodhouse 写道:
>>> From: David Woodhouse <dwmw@amazon.co.uk>
>>>
>>> In tun_get_user(), skb->protocol is either taken from the tun_pi header
>>> or inferred from the first byte of the packet in IFF_TUN mode, while
>>> eth_type_trans() is called only in the IFF_TAP mode where the payload
>>> is expected to be an Ethernet frame.
>>>
>>> The equivalent code path in tun_xdp_one() was unconditionally using
>>> eth_type_trans(), which is the wrong thing to do in IFF_TUN mode and
>>> corrupts packets.
>>>
>>> Pull the logic out to a separate tun_skb_set_protocol() function, and
>>> call it from both tun_get_user() and tun_xdp_one().
>>>
>>> XX: It is not entirely clear to me why it's OK to call eth_type_trans()
>>> in some cases without first checking that enough of the Ethernet header
>>> is linearly present by calling pskb_may_pull().
>>
>> Looks like a bug.
>>
>>
>>>     Such a check was never
>>> present in the tun_xdp_one() code path, and commit 96aa1b22bd6bb ("tun:
>>> correct header offsets in napi frags mode") deliberately added it *only*
>>> for the IFF_NAPI_FRAGS mode.
>>
>> We had already checked this in tun_get_user() before:
>>
>>           if ((tun->flags & TUN_TYPE_MASK) == IFF_TAP) {
>>                   align += NET_IP_ALIGN;
>>                   if (unlikely(len < ETH_HLEN ||
>>                                (gso.hdr_len && tun16_to_cpu(tun,
>> gso.hdr_len) < ETH_HLEN)))
>>                           return -EINVAL;
>>           }
> We'd checked skb->len, but that doesn't mean we had a full Ethernet
> header *linearly* at skb->data, does it?


The linear room is guaranteed through either:

1) tun_build_skb()

or

2) tun_alloc_skb()


>
> For the basic tun_get_user() case I suppose we copy_from_user() into a
> single linear skb anyway, even if userspace had fragment it and used
> writev(). So we *are* probably safe there?
>
> I'm sure we *can* contrive a proof that it's safe for that case, if we
> must. But I think we should *need* that proof, if we're going to bypass
> the check. And I wasn't comfortable touching that code without it.
>
> We should also have a fairly good reason... it isn't clear to me *why*
> we're bothering to avoid the check. Is it so slow, even in the case
> where there's nothing to be done?
>
> For a linear skb, the inline pskb_may_pull() is going to immediately
> return true because ETH_HLEN < skb_headlen(skb), isn't it? Why optimise
> *that* away?
>
> Willem, was there a reason you made that conditional in the first
> place?
>
> If we're going to continue to *not* check on the XDP path, we similarly
> need a proof that it can't be fragmented. And also a reason to bother
> with the "optimisation", of course.


For XDP path, we simply need to add a length check since the packet is 
always a linear memory.

Thanks


>
>

