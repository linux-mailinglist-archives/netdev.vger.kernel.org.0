Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7978D2D75E7
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436555AbgLKMpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405471AbgLKMod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:44:33 -0500
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F44FC0613CF;
        Fri, 11 Dec 2020 04:43:53 -0800 (PST)
Received: by mail-vk1-xa44.google.com with SMTP id t16so2028294vkl.10;
        Fri, 11 Dec 2020 04:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xdZOjC/Y1Xw6QwgDQd8XrJb+pdedL1r+7uac4KYqQSk=;
        b=uFYXR8j4YCcEz6ra8rAkZqVSlXg8oO9o+pOqvc3Z7/CroWo/10nYMUwVqZIX/JdvxL
         ol9inmnhb1j6K0gz04b2Fw1i/C4OIFpEeFSZGewI6+4/5VhZz1F6qfIaUMsuTTa7i3Ey
         Wa0kHdJCreLo2uNWvjaTwvdhOanvgcXq0TFSP0zYcXhHpad+QbMRaUYZ3ZevZAlYmDpM
         KkoRymY9asgZiARWKe1eC+40AMMpT46xKEiJYAL6rouqlB6ACE7zifQ30S+x070VoTZd
         8XV8k0/K0hwcATkG/vhAFjjnmDjZyqilKYSHvittTuIARQPVaWks/x2iPGNKzC3P8dV/
         0QcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xdZOjC/Y1Xw6QwgDQd8XrJb+pdedL1r+7uac4KYqQSk=;
        b=rzVC4Nd5wzA0xuwiVoAXuKTQrhlK54DL9v5VjmLalVcsiMi5HFcBSEoLk2AK5IU4ig
         E1wF005QPOqbfYvR2gM5xK98Crhk2NfvJMdUqSd+j+CpUINKRdkK/TviBio9FIi1Noua
         LA2+xKA1RJD7S8qNHCcLlPOE3WsXI0HwcAcgEWuYpREiY6wsmlTwd1VNxp9lWmY/vQQ7
         lxc5OciPo3RNlKlb1gAlguFgzvq1EFVCuCeptPFV29VYJG8/hNoaL7Y/u1PQ5Eky7o4P
         mfrbXC3L8svjVr58zsVD94qouFv0aRYbBa8dvorDYqI8LxiWyCXSC7uxVjBif9ErWJdM
         +jHA==
X-Gm-Message-State: AOAM531QCEr+VsGbXLTgClnpylnjLlBHqwbQNsFrIb18pbRoNpaMEuMv
        7yrN8CGOSlZCjf1LKVd++Gct5XNnxUyVH40MK9s=
X-Google-Smtp-Source: ABdhPJyItYyFKOZtB8Qnjs98x5a3v5GMApogqkHT8dTyVkfsi5phbaO3dyeaPZLtF/9SPRXXj4bowKQvAGIZKmnBvi8=
X-Received: by 2002:a1f:9987:: with SMTP id b129mr12769098vke.5.1607690632638;
 Fri, 11 Dec 2020 04:43:52 -0800 (PST)
MIME-Version: 1.0
References: <20201210035540.32530-1-TheSven73@gmail.com> <5ff5fd64-2bf0-cbf7-642f-67be198cba05@gmail.com>
In-Reply-To: <5ff5fd64-2bf0-cbf7-642f-67be198cba05@gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Fri, 11 Dec 2020 07:43:40 -0500
Message-ID: <CAGngYiXsyRH=5UYwaCkVDDGkRX6m_Cw9iam+nSRZwA1=ZNPnOQ@mail.gmail.com>
Subject: Re: [PATCH net v2] lan743x: fix rx_napi_poll/interrupt ping-pong
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

On Thu, Dec 10, 2020 at 2:32 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
>
> In addition you could play with sysfs attributes
> /sys/class/net/<if>/gro_flush_timeout
> /sys/class/net/<if>/napi_defer_hard_irqs

Interesting, I will look into that.

> > @@ -2407,7 +2409,7 @@ static int lan743x_rx_open(struct lan743x_rx *rx)
> >
> >       netif_napi_add(adapter->netdev,
> >                      &rx->napi, lan743x_rx_napi_poll,
> > -                    rx->ring_size - 1);
> > +                    64);
>
> This value isn't completely arbitrary.
> Better use constant NAPI_POLL_WEIGHT.
>

Thank you, I will change it in the next patch version.
