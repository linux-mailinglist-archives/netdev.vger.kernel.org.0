Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9E144D286
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 08:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhKKHgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 02:36:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231185AbhKKHgk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 02:36:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 778676135E;
        Thu, 11 Nov 2021 07:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636616031;
        bh=QG6rxubhlm+xVWz1ucpUG/Vc4hQUbjbEez9Eq4wVz+c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rAJA748qder949q4fQEF1ASvgfTXaQsG4rSbAImH+iTBP7x/33YT0Z8z5p5pnPmP3
         pZf4Ce+yogY/myzUWykDANvs/U5RkJrrg/gUijyyLOTzC27WDJULu4dKRSaZYic7JT
         eVVHqg9JSw4z5CksrDPGtYCWCTh/91R3mpKCnGjUdbuImj1/0aStrwKd/TSC3NjAQG
         dYnoqOHCK4lFqyIaOCG8GQOo2AwroMOhJ7SBT5OKR5LMJBbw5Vi809pzyC9C96Eed3
         RshPkwrZgpQKcHIqSDtEK6to0DuFhb+BUQkgGlAMPVWSCFDxcaar0gGziHv/q8rSPD
         k6rSfFnu5VwmQ==
Received: by mail-wm1-f54.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso3625416wms.3;
        Wed, 10 Nov 2021 23:33:51 -0800 (PST)
X-Gm-Message-State: AOAM531MUYgfSWF5TtVr6ttnljEKcdMqfwmTRdITh8Hsvi9hKtQW35yv
        JItkvUAl14z6uQtNFh/0IT5lqtl1nUmFstLZN5c=
X-Google-Smtp-Source: ABdhPJxzGVNkezxnW3f6WHwFaHhv8pgqXtCVHYqsKbUj8e9LsPH9kOnfqlk8UGINyj9UOCnuo5tJa46lRLnvIl3LZVM=
X-Received: by 2002:a05:600c:2107:: with SMTP id u7mr23449078wml.82.1636616029983;
 Wed, 10 Nov 2021 23:33:49 -0800 (PST)
MIME-Version: 1.0
References: <20211104133735.1223989-1-arnd@kernel.org> <CAKwvOd=vrUe7xWohkPZkfui2BM-uP2Q79v02NzTJs9XJJ1CTjw@mail.gmail.com>
In-Reply-To: <CAKwvOd=vrUe7xWohkPZkfui2BM-uP2Q79v02NzTJs9XJJ1CTjw@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 11 Nov 2021 08:33:34 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1eWa8p58qAHS8hBee0p_-WOxZrtuLQ3ncARpyzBnsWiw@mail.gmail.com>
Message-ID: <CAK8P3a1eWa8p58qAHS8hBee0p_-WOxZrtuLQ3ncARpyzBnsWiw@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: pcie: fix constant-conversion warning
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Yaara Baruch <yaara.baruch@intel.com>,
        Matti Gottlieb <matti.gottlieb@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 10:38 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Thu, Nov 4, 2021 at 6:37 AM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > clang points out a potential issue with integer overflow when
> > the iwl_dev_info_table[] array is empty:
> >
> > drivers/net/wireless/intel/iwlwifi/pcie/drv.c:1344:42: error: implicit conversion from 'unsigned long' to 'int' changes value from 18446744073709551615 to -1 [-Werror,-Wconstant-conversion]
> >         for (i = ARRAY_SIZE(iwl_dev_info_table) - 1; i >= 0; i--) {
> >                ~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~
> >
> > This is still harmless, as the loop correctly terminates, but adding
> > an (int) cast makes that clearer to the compiler.
> >
> > Fixes: 3f7320428fa4 ("iwlwifi: pcie: simplify iwl_pci_find_dev_info()")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
> > index c574f041f096..81e8f2fc4982 100644
> > --- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
> > +++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
> > @@ -1341,7 +1341,7 @@ iwl_pci_find_dev_info(u16 device, u16 subsystem_device,
> >  {
> >         int i;
> >
> > -       for (i = ARRAY_SIZE(iwl_dev_info_table) - 1; i >= 0; i--) {
> > +       for (i = (int)ARRAY_SIZE(iwl_dev_info_table) - 1; i >= 0; i--) {
>
> Perhaps `i` could be a `size_t` instead of an `int`?
>
> size_t i = ARRAY_SIZE(iwl_dev_info_table);
> while (i--) {
>   ...

I imagine 'i' is idiomatically 'int' in inner iterations.

I've sent a different fix now.

        Arnd
