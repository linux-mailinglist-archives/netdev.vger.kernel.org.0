Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D2A29AB34
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 12:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899614AbgJ0LvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 07:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394050AbgJ0LvY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 07:51:24 -0400
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6104207C3;
        Tue, 27 Oct 2020 11:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603799483;
        bh=Jkm9KTP2d4FaPkRwRtL8+peWn2RqI0SjRbGNKFX9l24=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dCosEtnAGgQAyhH9LGV1mSx7fyOoQg67erOLZ5nhJ9pAl4C/m5CDPgZST/+vZ9adV
         K8M2M/90d09rfYz+GXQD7YY9GUxSDV2xiBMYpUJRXvkBLqXVAEgyJ8NfoqfDg/vHCI
         5NjvzJW3bIoPfH5zZTyVx4T/HyWn+zxjxGHRR6Yk=
Received: by mail-qk1-f182.google.com with SMTP id z6so796595qkz.4;
        Tue, 27 Oct 2020 04:51:23 -0700 (PDT)
X-Gm-Message-State: AOAM530z7ZQ1ghPUuZZfCacrvX5ttM7MQ2KSPPqVJh8XLTWHVIfMQ0Ak
        RtxA7X/rJJq+HG13mqBWyW2nzGMa3hXYw9HyQd0=
X-Google-Smtp-Source: ABdhPJzcfllDuvkPvTZe2bxMZp9RKsNVH6ol/ilVbFi7E0XaIe77KwQyB3aloZk6orShkn3HWJevON2FAhvigxbmtHw=
X-Received: by 2002:a05:620a:b13:: with SMTP id t19mr1552663qkg.3.1603799482840;
 Tue, 27 Oct 2020 04:51:22 -0700 (PDT)
MIME-Version: 1.0
References: <20201026213040.3889546-1-arnd@kernel.org> <20201026213040.3889546-4-arnd@kernel.org>
 <03c5bc171594c884c903994ef82d703776bfcbc0.camel@sipsolutions.net>
In-Reply-To: <03c5bc171594c884c903994ef82d703776bfcbc0.camel@sipsolutions.net>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 27 Oct 2020 12:51:06 +0100
X-Gmail-Original-Message-ID: <CAK8P3a30T5o=EEnp3sdNM5iqsSaL6DKZONGBs+3S6g+36uHVzQ@mail.gmail.com>
Message-ID: <CAK8P3a30T5o=EEnp3sdNM5iqsSaL6DKZONGBs+3S6g+36uHVzQ@mail.gmail.com>
Subject: Re: [PATCH net-next 04/11] wimax: fix duplicate initializer warning
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 8:22 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Mon, 2020-10-26 at 22:29 +0100, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > gcc -Wextra points out multiple fields that use the same index '1'
> > in the wimax_gnl_policy definition:
> >
> > net/wimax/stack.c:393:29: warning: initialized field overwritten [-Woverride-init]
> > net/wimax/stack.c:397:28: warning: initialized field overwritten [-Woverride-init]
> > net/wimax/stack.c:398:26: warning: initialized field overwritten [-Woverride-init]
> >
> > This seems to work since all four use the same NLA_U32 value, but it
> > still appears to be wrong. In addition, there is no intializer for
> > WIMAX_GNL_MSG_PIPE_NAME, which uses the same index '2' as
> > WIMAX_GNL_RFKILL_STATE.
>
> That's funny. This means that WIMAX_GNL_MSG_PIPE_NAME was never used,
> since it is meant to be a string, and that won't (usually) fit into 4
> bytes...
>
> I suppose that's all an artifact of wimax being completely and utterly
> dead anyway. We should probably just remove it.

Makes sense. I checked
https://en.wikipedia.org/wiki/List_of_WiMAX_networks, and it appears
that these entries are all stale, after everyone has migrated to LTE
or discontinued their service altogether.

NetworkManager appears to have dropped userspace support in 2015
https://bugzilla.gnome.org/show_bug.cgi?id=747846, the
www.linuxwimax.org site had already shut down earlier.

WiMax is apparently still being deployed on airport campus
networks ("AeroMACS"), but in a frequency band that was not
supported by the old Intel 2400m (used in Sandy Bridge laptops
and earlier), which is the only driver using the kernel's wimax
stack.

Inaky, do you have any additional information about possible
users? If we are sure there are none, then I'd suggest removing
all the wimax code directly, otherwise it could go through
drivers/staging/ for a release or two (and move it back in case
there are users after all). I can send a patch if you like.

> So as far as the warning fix is concerned:
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>

Thanks!

        Arnd
