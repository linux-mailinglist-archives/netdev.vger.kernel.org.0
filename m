Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862E63B6D1D
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 05:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhF2Dpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 23:45:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231598AbhF2Dpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 23:45:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624938202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I6uzht0J8yGjsrjxBDqwtdt/Lmm5gSxrLU9WevRZ53c=;
        b=UNCT3l1ous8IMaTNzJm9Bj7+NcXKSsx7j5pER0CjjuGOhO05rjvKKJBFslUvZzv3frYqWz
        Zwdi3MuUEpN88ANopE7I2w7w297ItIanYsIjrvkwA+WrboCEYfUavo9RkuoP1xcpg0o119
        MQ50naJ2mjKM53Dw4ZVIBHIlz14VaHo=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-xZbP0M-rO3SAXY3weF3EBA-1; Mon, 28 Jun 2021 23:43:20 -0400
X-MC-Unique: xZbP0M-rO3SAXY3weF3EBA-1
Received: by mail-pj1-f71.google.com with SMTP id u8-20020a17090a8908b029016f79b38655so1326269pjn.8
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 20:43:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=I6uzht0J8yGjsrjxBDqwtdt/Lmm5gSxrLU9WevRZ53c=;
        b=Uum/VzC97wAtDTG1D2BIpPhGVjfLqCNqLR35W/VBqI06FdY1bge/5F1BTOCva1rWPk
         hw5h4M1hWcK/2FiOar3NtWxHs2xCwm70lRmg3+cIK4fzJEnYodZJRMgqh6yaog42GhDn
         vIyV3ovgilIQreafFNU8AhMyPRQLwrmiYoW7Xz/4TepY+awk82QSHLly3H6GsyR9RVJj
         lawh7FWpaHkvcIfIBpAgiKhurHsYESucUr4KC4VicgbcOfJG5fpU/dR4I/flRIgUsXBa
         fWoXG2v1NuLr2T+o0QVyEI/SQXXJaTgnfebdWlDbbPdVLdF/lcf1O48f6BeNEehvs04h
         CY2w==
X-Gm-Message-State: AOAM530opoPh1Rty93yCMjgdg1U4qpAe5nEO5JQCk5zRQw0XzBokwJHS
        g2+F0dj0WqBvzaU1USqBOlNpEoWc1dsGiVITzp2JJT/qb98ER8F8FvLi/2BH2YLmoPFjQyZJyBv
        sRo2FvuSjuju3zsWi
X-Received: by 2002:a62:774b:0:b029:308:b858:b1fa with SMTP id s72-20020a62774b0000b0290308b858b1famr24061329pfc.34.1624938199426;
        Mon, 28 Jun 2021 20:43:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKNiz3y4btrOis0zGy7eUSnWU2c2EAaqoFTKggUNGJABGTMIHtAIEm754m4hXZMBr1HqfWUg==
X-Received: by 2002:a62:774b:0:b029:308:b858:b1fa with SMTP id s72-20020a62774b0000b0290308b858b1famr24061320pfc.34.1624938199245;
        Mon, 28 Jun 2021 20:43:19 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r21sm1066549pjz.12.2021.06.28.20.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 20:43:18 -0700 (PDT)
Subject: Re: [PATCH v3 3/5] vhost_net: remove virtio_net_hdr validation, let
 tun/tap do it themselves
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
 <20210624123005.1301761-3-dwmw2@infradead.org>
 <b339549d-c8f1-1e56-2759-f7b15ee8eca1@redhat.com>
 <bfad641875aff8ff008dd7f9a072c5aa980703f4.camel@infradead.org>
 <1c6110d9-2a45-f766-9d9a-e2996c14b748@redhat.com>
 <72dfecd426d183615c0dd4c2e68690b0e95dd739.camel@infradead.org>
 <80f61c54a2b39cb129e8606f843f7ace605d67e0.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <99496947-8171-d252-66d3-0af12c62fd2c@redhat.com>
Date:   Tue, 29 Jun 2021 11:43:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <80f61c54a2b39cb129e8606f843f7ace605d67e0.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/29 上午7:29, David Woodhouse 写道:
> On Mon, 2021-06-28 at 12:23 +0100, David Woodhouse wrote:
>> To be clear: from the point of view of my *application* I don't care
>> about any of this; my only motivation here is to clean up the kernel
>> behaviour and make life easier for potential future users. I have found
>> a setup that works in today's kernels (even though I have to disable
>> XDP, and have to use a virtio header that I don't want), and will stick
>> with that for now, if I actually commit it to my master branch at all:
>> https://gitlab.com/openconnect/openconnect/-/commit/0da4fe43b886403e6
>>
>> I might yet abandon it because I haven't *yet* seen it go any faster
>> than the code which just does read()/write() on the tun device from
>> userspace. And without XDP or zerocopy it's not clear that it could
>> ever give me any benefit that I couldn't achieve purely in userspace by
>> having a separate thread to do tun device I/O. But we'll see...
> I managed to do some proper testing, between EC2 c5 (Skylake) virtual
> instances.
>
> The kernel on a c5.metal can transmit (AES128-SHA1) ESP at about
> 1.2Gb/s from iperf, as it seems to be doing it all from the iperf
> thread.
>
> Before I started messing with OpenConnect, it could transmit 1.6Gb/s.
>
> When I pull in the 'stitched' AES+SHA code from OpenSSL instead of
> doing the encryption and the HMAC in separate passes, I get to 2.1Gb/s.
>
> Adding vhost support on top of that takes me to 2.46Gb/s, which is a
> decent enough win.


Interesting, I think the latency should be improved as well in this case.

Thanks


> That's with OpenConnect taking 100% CPU, iperf3
> taking 50% of another one, and the vhost kernel thread taking ~20%.
>
>

