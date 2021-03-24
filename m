Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210D5347AA5
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 15:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbhCXO00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 10:26:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236201AbhCXO0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 10:26:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C553E61A07;
        Wed, 24 Mar 2021 14:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616595964;
        bh=e+83tN45oub7t57k1wySmI/GI/W3QxhArTyYJ/WCdjI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MyC7FumJwuWCuJF5e7NsK+sJDyWQmivi5cxuBsYwdDMeMr+uf+dSvIBzCWYgF45Um
         dTVykwVywevc+Al3FxUQD17nbqDY4u85pIJV3Zf2IoFWnegJ3vrRKH93WpbKNLP/Al
         Wjw4EbRDXiFwYoYowrfLKXtAlK3eFCLdxzgWICe6/JDsJNQ9TLMwExtjV2aU4bLPZy
         8igI8jLJyV2LyBF3oNxCkR39aO0d9C/PIgrLV9SLzpwxU0mrAIiK7QQ59syd9pvSMz
         Ue1BIfKzUxRvdDdObymdq1uWxnOcMJ1jpbUSlnv4CN0PZm6YKZOuiIYwDyKRZ2sAlL
         JT9Ei62zXP9Ww==
Received: by mail-ot1-f51.google.com with SMTP id 31-20020a9d00220000b02901b64b9b50b1so23154050ota.9;
        Wed, 24 Mar 2021 07:26:04 -0700 (PDT)
X-Gm-Message-State: AOAM532Bx4PIqlMVPj6xeprk+451051T0nuw6ttwoJ+6wkDySRui79xH
        ePJWvnv8Krg5AuiWgKXZRZBjqY1jx8xDH94HKNc=
X-Google-Smtp-Source: ABdhPJwlUydzQqHwjm6HrdlQaV8vfRaWaQj41EOvLGtUDwartwUeKbW9ICGnATvfLmV2i8GxbAHReL138rOm0IRfMjw=
X-Received: by 2002:a05:6830:148c:: with SMTP id s12mr3564868otq.251.1616595964114;
 Wed, 24 Mar 2021 07:26:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210324130731.1513798-1-arnd@kernel.org> <f3d1c643-56ef-7fe0-52f0-1f030c890a38@rasmusvillemoes.dk>
In-Reply-To: <f3d1c643-56ef-7fe0-52f0-1f030c890a38@rasmusvillemoes.dk>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 24 Mar 2021 15:25:47 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0YOYSJLTYEEQbm1hvuYy8L-UaGipVbvDuLLSE9zanMGg@mail.gmail.com>
Message-ID: <CAK8P3a0YOYSJLTYEEQbm1hvuYy8L-UaGipVbvDuLLSE9zanMGg@mail.gmail.com>
Subject: Re: [PATCH] [v2] hinic: avoid gcc -Wrestrict warning
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Bin Luo <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 2:29 PM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
> On 24/03/2021 14.07, Arnd Bergmann wrote:
 >
> >       if (set_settings & HILINK_LINK_SET_SPEED) {
> >               speed_level = hinic_ethtool_to_hw_speed_level(speed);
> >               err = snprintf(set_link_str, SET_LINK_STR_MAX_LEN,
> > -                            "%sspeed %d ", set_link_str, speed);
> > -             if (err <= 0 || err >= SET_LINK_STR_MAX_LEN) {
> > +                            "speed %d ", speed);
> > +             if (err >= SET_LINK_STR_MAX_LEN) {
> >                       netif_err(nic_dev, drv, netdev, "Failed to snprintf link speed, function return(%d) and dest_len(%d)\n",
> >                                 err, SET_LINK_STR_MAX_LEN);
> >                       return -EFAULT;
>
> It's not your invention of course, but this both seems needlessly harsh
> and EFAULT is a weird error to return. It's just a printk() message that
> might be truncated, and now that the format string only has a %d
> specifier, it can actually be verified statically that overflow will
> never happen (though I don't know or think gcc can do that, perhaps
> there's some locale nonsense in the standard that allows using
> utf16-encoded sanskrit runes). So probably that test should just be
> dropped, but that's a separate thing.

I thought about fixing it, but this seemed to be a rabbit hole I didn't
want to get into, as there are other harmless issues in the driver
that could be improved.

I'm fairly sure gcc can indeed warn about the overflow with
-Wformat-truncation, but the warning is disabled at the moment
because it has a ton of false positives:

kernel/workqueue.c: In function 'create_worker':
kernel/workqueue.c:1933:55: error: '%d' directive output may be
truncated writing between 1 and 10 bytes into a region of size between
3 and 13 [-Werror=format-truncation=]
 1933 |                 snprintf(id_buf, sizeof(id_buf), "u%d:%d",
pool->id, id);

        Arnd
