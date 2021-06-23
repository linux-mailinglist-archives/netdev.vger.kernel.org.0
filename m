Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE1D3B1253
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 05:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhFWDmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 23:42:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229890AbhFWDma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 23:42:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624419613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GB/r7lUtyIIaKBdNBMm0s52SNaJtn9H7PsTYTBV7IKA=;
        b=dgc37nx3/Lv90wy0ZWfrL9DRXDZCK8d1O1UpNEL/+2jmOlv3VFbzusUBD6fjGX4Wcz8OV8
        DnOKkSUvo/giC/xjfGoftnH3iitTzM79drLEUXo50f8V21yXv0j4r4YwJT79GwQ7+NnSIY
        ycOazEXurlNXGAtUK0Fq0QFKfNRmPxk=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-hO2E-POkOBuSgo6jdgOj8w-1; Tue, 22 Jun 2021 23:40:11 -0400
X-MC-Unique: hO2E-POkOBuSgo6jdgOj8w-1
Received: by mail-pj1-f70.google.com with SMTP id c5-20020a17090a1d05b029016f9eccfcd6so562634pjd.0
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 20:40:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GB/r7lUtyIIaKBdNBMm0s52SNaJtn9H7PsTYTBV7IKA=;
        b=SdAefcfnwfZuSUHbZOBtb9ee6uT5oTakFsV+/ayP/MKsDCt4lGPd8SqFLOUlGJEkph
         fcnh+ev8oRwdQiUGR5SehGS2MGfIMbk+0OHrRRCiR5fj7xE3fZjCOe46faXPVoIq1ZjB
         D5LQ29yeMAkRAhX7B1YSUIA0/aeVVcxi3+iUYQiunl1/5MRiCGi21B3+s4PAFn0WLuz1
         cMWz1+DSFQg+YK40V2QbshGCxu1Lg4QeuLRN71HX9GJyRjvql4+vF4U1rkU/gvrk9trK
         khaRTOTMHUaxKAs8a5KaJ9B+0HkMqMNm+07KpNpWYpFfTaupMI+rVgWUqKQnFopFufzE
         gm+Q==
X-Gm-Message-State: AOAM532Vy6fODoOwqIo9vqxD+ykmNroPgS8VVxRs32r9G8k5LwzmP+v4
        tKNqBiV1htdPZjvwreZsDjHXmaputCba6VYFSx/N4VqZ92VuJa5YaGQFXCzaXzbgshRY69M2IGx
        Yt/7O7wS1cd/AbNe6
X-Received: by 2002:a17:902:be0d:b029:11d:6614:88cd with SMTP id r13-20020a170902be0db029011d661488cdmr25785739pls.40.1624419610607;
        Tue, 22 Jun 2021 20:40:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypJkpLJFgvhSP1sBslbGcn4btZveSjK+phAN+ZdehO21gt49bGD+mKQt7N2bSScSIsvdQu3g==
X-Received: by 2002:a17:902:be0d:b029:11d:6614:88cd with SMTP id r13-20020a170902be0db029011d661488cdmr25785718pls.40.1624419610340;
        Tue, 22 Jun 2021 20:40:10 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l201sm669242pfd.183.2021.06.22.20.40.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 20:40:09 -0700 (PDT)
Subject: Re: [PATCH] net: tun: fix tun_xdp_one() for IFF_TUN mode
To:     David Woodhouse <dwmw2@infradead.org>,
        netdev <netdev@vger.kernel.org>
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <e832b356-ffc2-8bca-f5d9-75e8b98cfcf2@redhat.com>
 <2cbe878845eb2a1e3803b3340263ea14436fe053.camel@infradead.org>
 <c7ae488b-ffde-f9e3-8b45-1c3d5669b519@redhat.com>
 <b287e6a4e5968e524daeeee4216286666a83bcd8.camel@infradead.org>
 <cfe1ddd7-cc14-49ee-4126-83bd940b5777@redhat.com>
 <32a5efc2845118e8b97f2ee61dc88a3a734cb713.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ecc93a78-ee8b-bcf2-9b45-dd98d2f44768@redhat.com>
Date:   Wed, 23 Jun 2021 11:39:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <32a5efc2845118e8b97f2ee61dc88a3a734cb713.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/22 下午4:29, David Woodhouse 写道:
> On Tue, 2021-06-22 at 16:00 +0800, Jason Wang wrote:
>>> I'm tempted to add a new feature for that 1:1 access, with no ->umem or
>>> ->iotlb at all. And then I can use it as a key to know that the XDP
>>> bugs are fixed too :)
>>
>> This means we need validate the userspace address each time before vhost
>> tries to use that. This will de-gradate the performance. So we still
>> need to figure out the legal userspace address range which might not be
>> easy.
> Easier from the kernel than from userspace though :)


Yes.


>
> But I don't know that we need it. Isn't a call to access_ok() going to
> be faster than what translate_desc() does to look things up anyway?


Right.


>
> In the 1:1 mode, the access_ok() is all that's needed since there's no
> translation.
>
> @@ -2038,6 +2065,14 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
>          u64 s = 0;
>          int ret = 0;
>   
> +       if (vhost_has_feature(vq, VHOST_F_IDENTITY_MAPPING)) {


Using vhost_has_feature() is kind of tricky since it's used for virtio 
feature negotiation.

We probably need to use backend_features instead.

I think we should probably do more:

1) forbid the feature to be set when mem table / IOTLB has at least one 
mapping
2) forbid the mem table / IOTLB updating after the feature is set

Thanks


> +               if (!access_ok((void __user *)addr, len))
> +                       return -EFAULT;
> +
> +               iov[0].iov_len = len;
> +               iov[0].iov_base = (void __user *)addr;
> +               return 1;
> +       }
>          while ((u64)len > s) {
>                  u64 size;
>                  if (unlikely(ret >= iov_size)) {

