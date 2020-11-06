Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BCA2A9F57
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 22:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgKFVsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 16:48:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:60672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgKFVsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 16:48:38 -0500
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D92D021556;
        Fri,  6 Nov 2020 21:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604699317;
        bh=EYBzfz3L81zdNiSWhDFneVxtFj51xGY2xLbv4ub889k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rvTbINw4o8Nz7VSmQ0MG9IwCI0U5QGQ2de065jkv9ElPfQDpKZKJ7FcuKagWIijhE
         dlfkWwZATag1wsXpImOAwypsAsE7dQDPE0nz0mjw7u3Pbvb0N25X6+b54HUoj+z3pf
         FCBfiC+6eF0H3gK8vuViL7ip52P8+8Nv1VqJe3hg=
Received: by mail-wm1-f50.google.com with SMTP id c9so2841054wml.5;
        Fri, 06 Nov 2020 13:48:36 -0800 (PST)
X-Gm-Message-State: AOAM530si5m5tfXvF2PoSEatv7tpPVrrCLQs+KJz3Q0PIzzuLb+HM0J0
        CO/bDjMEyxy+Z56S09CMKlBWKpMsv7ZvTra3LdM=
X-Google-Smtp-Source: ABdhPJwyApUc1D551AfGemklZEDSxyRD5mSU05AoTitYdeMABzYeb7SEju468gY9nU1JRMqQZqpQgorbrGd+7p1A//U=
X-Received: by 2002:a1c:3c8a:: with SMTP id j132mr1554643wma.75.1604699315292;
 Fri, 06 Nov 2020 13:48:35 -0800 (PST)
MIME-Version: 1.0
References: <20201106173231.3031349-1-arnd@kernel.org>
In-Reply-To: <20201106173231.3031349-1-arnd@kernel.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 6 Nov 2020 22:48:18 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0soc41M-s0nd9xQgztyVCHNy8VJpQ9jmzi-N0Z0rGfRQ@mail.gmail.com>
Message-ID: <CAK8P3a0soc41M-s0nd9xQgztyVCHNy8VJpQ9jmzi-N0Z0rGfRQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/4] remove compat_alloc_user_space()
To:     Networking <netdev@vger.kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 6, 2020 at 6:32 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> This is the third version of my seires, now spanning four patches
> instead of two, with a new approach for handling struct ifreq
> compatibility after I realized that my earlier approach introduces
> additional problems.
>
> The idea here is to always push down the compat conversion
> deeper into the call stack: rather than pretending to be
> native mode with a modified copy of the original data on
> the user space stack, have the code that actually works on
> the data understand the difference between native and compat
> versions.
>
> I have spent a long time looking at all drivers that implement
> an ndo_do_ioctl callback to verify that my assumptions are
> correct. This has led to a series of 29 additional patches
> that I am not including here but will post separately, fixing
> a number of bugs in SIOCDEVPRIVATE ioctls, removing dead
> code, and splitting ndo_do_ioctl into two new ndo callbacks
> for private and ethernet specific commands.

I got a reply from the build bots that the version I sent was broken
on 32-bit machines, so don't merge it just yet. Let me know if
there are any other comments I should address before resending
though.

       Arnd
