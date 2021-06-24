Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5903B277C
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 08:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhFXGkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 02:40:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56114 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231132AbhFXGkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 02:40:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624516671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KUvfirNaUXWSb8QwBmA98rmkDvdHvQwjN+VegLENr1M=;
        b=LCytcIZISFLz3dFl37vPPejmyexHlJGRglK7Hz72LrI/UbnXV6Xx1Svgj/dN7FPdX+EY2q
        C2XA4kilTCT6xuLAUbJEZ6jihDpFEHGRpbx5BbmjtGJbrYGmdxoXQ4a7B4G32Bilj6EPkQ
        +JMta/S7nD+Mly8CVQtyUsKNKMPnqrQ=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-dVHcxoRdM4-XXXUEXVwA0Q-1; Thu, 24 Jun 2021 02:37:50 -0400
X-MC-Unique: dVHcxoRdM4-XXXUEXVwA0Q-1
Received: by mail-pf1-f198.google.com with SMTP id p42-20020a056a000a2ab02902f33d81f23fso3346771pfh.9
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 23:37:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KUvfirNaUXWSb8QwBmA98rmkDvdHvQwjN+VegLENr1M=;
        b=DBlRySBYBijVR7K9mk0RSfVUz5yeLfxGcSaBtYjq/9EY8yoXNjDinPzVPTxMfiiO7a
         2RQK3EwdAp/hXvdLqyu7eBcm2oheGDOpWBuEVn9yUssa8p4n9AqifMwbP/ChKxY033z+
         7hr1ZYLuLamyCUx9ULzbgWLtQ+ge+uEP+9Bf7R91TPBkCBLoFqQh3jTIOc0M0ilVwkYb
         R+A5DlHbq/40nXSbwWKZ8rMhV9idZOlQXn/LMbkfZXpHyjRAhzYTbNdXzZzTl2EHE+bc
         2Yldi7ikQQXGLG6vBB1bYYxVQa9MKRot/KlM5nIuq21n1x9B0xUwONLmgsv0vAb9j51D
         edzQ==
X-Gm-Message-State: AOAM530hizsVoOH787zHKwLInmKZOdwoQthSMQr+o3Gy0qYpUIoXxkB3
        WgxTO5E7jJ4VVL5tEV6YOE8WRWEQrwIGlSu7tBGmA9/WFP6HZLyGfR7CnMlO9GExHXZANh/BWXW
        CLXDg9MIRcZyHGwhw
X-Received: by 2002:a05:6a00:14c5:b029:2f9:b8ea:7ab3 with SMTP id w5-20020a056a0014c5b02902f9b8ea7ab3mr3532660pfu.76.1624516668996;
        Wed, 23 Jun 2021 23:37:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFl9LXzX851g0Gb4ZaeKJbaoQCjdio8tLsh0/z7cat9XBx0SIZ6XHgYxuYaeQ+TbWSXYnBbQ==
X-Received: by 2002:a05:6a00:14c5:b029:2f9:b8ea:7ab3 with SMTP id w5-20020a056a0014c5b02902f9b8ea7ab3mr3532646pfu.76.1624516668754;
        Wed, 23 Jun 2021 23:37:48 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 125sm1676730pfg.52.2021.06.23.23.37.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 23:37:48 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] net: tun: fix tun_xdp_one() for IFF_TUN mode
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210622161533.1214662-1-dwmw2@infradead.org>
 <fedca272-a03e-4bac-4038-2bb1f6b4df84@redhat.com>
 <e8843f32aa14baff398584e5b3a00d20994836b6.camel@infradead.org>
 <f2e6498d310454e9c884f3f8470477e0cc527b58.camel@infradead.org>
 <e61c84062230d3454c0a6539ed372b84449d9572.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <12d5dc12-0b1a-eec1-2986-a971f660e850@redhat.com>
Date:   Thu, 24 Jun 2021 14:37:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e61c84062230d3454c0a6539ed372b84449d9572.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/24 上午6:52, David Woodhouse 写道:
> On Wed, 2021-06-23 at 18:31 +0100, David Woodhouse wrote:
>> Joy... that's wrong because when tun does both the PI and the vnet
>> headers, the PI header comes *first*. When tun does only PI and vhost
>> does the vnet headers, they come in the other order.
>>
>> Will fix (and adjust the test cases to cope).
>
> I got this far, pushed to
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/vhost-net
>
> All the test cases are now passing. I don't guarantee I haven't
> actually broken qemu and IFF_TAP mode though, mind you :)


No problem, but it would be easier for me if you can post another 
version of the series.


>
> I'll need to refactor the intermediate commits a little so I won't
> repost the series quite yet, but figured I should at least show what I
> have for comments, as my day ends and yours begins.
>
>
> As discussed, I expanded tun_get_socket()/tap_get_socket() to return
> the actual header length instead of letting vhost make wild guesses.


This probably won't work since we had TUNSETVNETHDRSZ.

I agree the vhost codes is tricky since it assumes only two kinds of the 
hdr length.

But it was basically how it works for the past 10 years. It depends on 
the userspace (Qemu) to coordinate it with the TUN/TAP through 
TUNSETVNETHDRSZ during the feature negotiation.


> Note that in doing so, I have made tun_get_socket() return -ENOTCONN if
> the tun fd *isn't* actually attached (TUNSETIFF) to a real device yet.


Any reason for doing this? Note that the socket is loosely coupled with 
the networking device.


>
> I moved the sanity check back to tun/tap instead of doing it in
> vhost_net_build_xdp(), because the latter has no clue about the tun PI
> header and doesn't know *where* the virtio header is.


Right, the deserves a separate patch.


>
>

[...]


>   	mutex_unlock(&n->dev.mutex);
> diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
> index 915a187cfabd..b460ba98f34e 100644
> --- a/include/linux/if_tap.h
> +++ b/include/linux/if_tap.h
> @@ -3,14 +3,14 @@
>   #define _LINUX_IF_TAP_H_
>   
>   #if IS_ENABLED(CONFIG_TAP)
> -struct socket *tap_get_socket(struct file *);
> +struct socket *tap_get_socket(struct file *, size_t *);
>   struct ptr_ring *tap_get_ptr_ring(struct file *file);
>   #else
>   #include <linux/err.h>
>   #include <linux/errno.h>
>   struct file;
>   struct socket;
> -static inline struct socket *tap_get_socket(struct file *f)
> +static inline struct socket *tap_get_socket(struct file *f, size_t *)
>   {
>   	return ERR_PTR(-EINVAL);
>   }
> diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
> index 2a7660843444..8d78b6bbc228 100644
> --- a/include/linux/if_tun.h
> +++ b/include/linux/if_tun.h
> @@ -21,11 +21,10 @@ struct tun_msg_ctl {
>   
>   struct tun_xdp_hdr {
>   	int buflen;
> -	struct virtio_net_hdr gso;


Any reason for doing this? I meant it can work but we need limit the 
changes that is unrelated to the fixes.

Thanks


