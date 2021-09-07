Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73B2402511
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 10:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242571AbhIGI00 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Sep 2021 04:26:26 -0400
Received: from mail-vs1-f50.google.com ([209.85.217.50]:35730 "EHLO
        mail-vs1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242535AbhIGI0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 04:26:16 -0400
Received: by mail-vs1-f50.google.com with SMTP id p14so7610659vsm.2;
        Tue, 07 Sep 2021 01:25:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i5otPz9IyNInXN4bHLqTb0mS9hIBl4WWXnjx8UfK1+8=;
        b=hGKtKYVWwtPBx+cdkbe+Qu+cE8MRQbJDEt17SNywML54Kl9fpRLOTQWO2AtyCJt65r
         JLpExbQWDfVpMTtpjcC9+2CN8etIkEY3IAIUzlKFghcJrzuh7ejEoy2pAlNXGQXlUUso
         skSCjdjPTQxJHreBxYKRlcXFKLHmJCXd9n5JfI+8lbIIPKKwlGaJMDcjwxZntr+/UDKs
         9simxmSqkU5tFjHoAiqlFyjUnQWARFgZ8iBrlf0t/MDkPk6+wbqHKWFe2GgeeEmNmbFj
         Q8+hW+GHOUj0fMOXs2AxEbzYY6JyHi2URLWlLcMNvrkwWIAp2gSnPMnyzbP+eUh2Y/ET
         spMQ==
X-Gm-Message-State: AOAM532vyTGFFJmztXjtsArTJNMqbrA5kivn2USE4F9iQvyGhlttYe93
        CjCUtrJOEsxr68MHhrJ1WzD70Mb/GCP4Uy2MwJ4=
X-Google-Smtp-Source: ABdhPJzwZKq9XwQQIWNnk4yre3z52lV+DpCZ+Fh8SeQZudq4WhXPp91m3s38OB9Wl4gw/hVKRQWmznD55GZGp8/YmGU=
X-Received: by 2002:a67:cb0a:: with SMTP id b10mr8214785vsl.9.1631003110202;
 Tue, 07 Sep 2021 01:25:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210803114051.2112986-1-arnd@kernel.org> <20210803114051.2112986-11-arnd@kernel.org>
 <CAMuHMdVvBL=qZkWF5DXdKjFMKgT-3X-OUBnLYrqawQijoLG4Xw@mail.gmail.com>
In-Reply-To: <CAMuHMdVvBL=qZkWF5DXdKjFMKgT-3X-OUBnLYrqawQijoLG4Xw@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 7 Sep 2021 10:24:58 +0200
Message-ID: <CAMuHMdVhN-frrSgsxJ_28_5B+gYROTkN_dPT1yHBsQU+2U4_=g@mail.gmail.com>
Subject: Re: [PATCH v2 10/14] [net-next] make legacy ISA probe optional
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Doug Berger <opendmb@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sam Creasey <sammy@sammy.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Wed, Aug 11, 2021 at 4:50 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Tue, Aug 3, 2021 at 1:41 PM Arnd Bergmann <arnd@kernel.org> wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > There are very few ISA drivers left that rely on the static probing from
> > drivers/net/Space.o. Make them all select a new CONFIG_NETDEV_LEGACY_INIT
> > symbol, and drop the entire probe logic when that is disabled.
> >
> > The 9 drivers that are called from Space.c are the same set that
> > calls netdev_boot_setup_check().
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> > --- a/drivers/net/ethernet/8390/ne.c
> > +++ b/drivers/net/ethernet/8390/ne.c
> > @@ -951,6 +951,7 @@ static int __init ne_init(void)
> >  }
> >  module_init(ne_init);
> >
> > +#ifdef CONFIG_NETDEV_LEGACY_INIT
> >  struct net_device * __init ne_probe(int unit)
> >  {
> >         int this_dev;
> > @@ -991,6 +992,7 @@ struct net_device * __init ne_probe(int unit)
> >
> >         return ERR_PTR(-ENODEV);
> >  }
> > +#endif
> >  #endif /* MODULE */
>
> My rbtx4927 build log says:
>
> drivers/net/ethernet/8390/ne.c:909:20: warning: ‘ne_add_devices’
> defined but not used [-Wunused-function]

Same for atari_defconfig.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
