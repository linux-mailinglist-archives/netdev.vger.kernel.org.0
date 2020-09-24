Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D980276A54
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 09:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgIXHOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 03:14:40 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36564 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbgIXHOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 03:14:39 -0400
Received: by mail-ot1-f65.google.com with SMTP id 60so2261102otw.3;
        Thu, 24 Sep 2020 00:14:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SOTk4Z9rO9P6kIOtsBeNWrY1r58eD/VU9uBVBOrzix4=;
        b=rnp1aBsLoLM5nT0MqXCQsyGpriZLgRyQvLqyp3ZDecu+hL/g9klGT52W9ElXRGsnta
         kibba+jvOmUwwnOVNAPcPnW909gl91b2opaLMt/FhFJoFi7PCyLpsqULz//Yf0+L4IEC
         C27bGwuVF+JlzvIDf4rxcEZbdjg1y+IGBL7hCzxw5cRTtXQd6laUzzz6XZjeKtguXYtm
         KFQHiIrL3cQQ5KA8cJ05CndsBGYNdu+yjU9xAv0rh6T7LSRkWecIZ9pK0fQa+ZLUJ5no
         Q4IBwWZchMczN9PDLs930k2v7+E+IkO0I13qihSSCPlZKwYYm0xzyQeS8aCReUGLikUY
         mG1g==
X-Gm-Message-State: AOAM530eNZC7iKTxsHwhMRIY/mLpmS6lFkbxX2H3Hn/cJ2AYNA251Ra1
        MsOh/eCE0UB7cilyWSzB0ebBazA2CrJ2n6wLJww=
X-Google-Smtp-Source: ABdhPJwMDvciWihRneO23XLKC32PiddZkEgi4IuEEkGy7I0hvtGdo46FZO/RXon3HQ571YDnqIV4IZvedG6MU6A9iGA=
X-Received: by 2002:a05:6830:1008:: with SMTP id a8mr2046599otp.107.1600931678828;
 Thu, 24 Sep 2020 00:14:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200922072931.2148-1-geert+renesas@glider.be> <20200923.174004.2129776473634492661.davem@davemloft.net>
In-Reply-To: <20200923.174004.2129776473634492661.davem@davemloft.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 24 Sep 2020 09:14:27 +0200
Message-ID: <CAMuHMdU+2KXZ86f_PK8v2Kr08XsECp-YH586aW5WCDpkq07K-g@mail.gmail.com>
Subject: Re: [PATCH net] Revert "ravb: Fixed to be able to unload modules"
To:     David Miller <davem@davemloft.net>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jakub Kicinski <kuba@kernel.org>,
        Yusuke Ashiduka <ashiduka@fujitsu.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Thu, Sep 24, 2020 at 2:40 AM David Miller <davem@davemloft.net> wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> Date: Tue, 22 Sep 2020 09:29:31 +0200
>
> > This reverts commit 1838d6c62f57836639bd3d83e7855e0ee4f6defc.
> >
> > This commit moved the ravb_mdio_init() call (and thus the
> > of_mdiobus_register() call) from the ravb_probe() to the ravb_open()
> > call.  This causes a regression during system resume (s2idle/s2ram), as
> > new PHY devices cannot be bound while suspended.
>  ...
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Cc: stable@vger.kernel.org
>
> I noticed this too late, but please don't CC: stable on networking
> patches.  We have our own workflow as per the netdev FAQ.

OK, will try to remember.
I wanted to give a heads-up to stable that they've backported early a
patch which turned out to have issues.

> I've applied this but the inability to remove a module is an
> extremely serious bug and should be fixed properly.

Sure. As you stated in
https://lore.kernel.org/linux-renesas-soc/20200820.165244.540878641387937530.davem@davemloft.net/
that will need some rework in the MDIO subsystem...

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
