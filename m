Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85C23E1405
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237333AbhHELkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231162AbhHELkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 07:40:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B43261151;
        Thu,  5 Aug 2021 11:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628163592;
        bh=8mU0A5orRr3K27+zyQdI9wprEVKYjZQphj65N7Meb+s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sW+AX4B2inRuoHz0NXi4GyPdRZ3BPqYLHHXDiKjWUHq8lKwKhv+yOpSLnP71dorGv
         Ndecir0Ev8wu2wKv+6TwlBLwJHUD2LoB7jfecMOmer0RpUvkuYQwCpw4KLIB30+7IX
         fki4SJG+czHxjO/pmkME/iB6Vl2FGJz7yNjFKQEvAdraP9p8aUj8oLVF45cjZrL1PL
         lG8YqetoPk7m6QF1JiQhChcDeBTjIk55LcwoJwbtyBq49liE5VB5m8UWWeZkAhSlka
         U2fqUp+AL+/J8YFxpx+K3t+5S3wK1CzbAWs+75/I0F9Ku7f//zyuMG6R0Tuyx/cYN1
         ahDkZJX4y3j/A==
Received: by mail-wr1-f41.google.com with SMTP id z4so6105194wrv.11;
        Thu, 05 Aug 2021 04:39:52 -0700 (PDT)
X-Gm-Message-State: AOAM530na3r6jOSGvzIhUnUfQA8oLgKgmvnEHrTWobfExpv/ODIdWlv8
        eeQlYgHPav0QFTRmMrjpYocMq8iHViQ4RiN6aJY=
X-Google-Smtp-Source: ABdhPJzgbV+9A3p0Oavt2jWm5P+Q15oIZKr3J79k/r3svVZpDvhlSqs1Iyh4llZ4yrpFmBOyZuKo+Hb83iWfrscQg2c=
X-Received: by 2002:adf:fd90:: with SMTP id d16mr4962346wrr.105.1628163590597;
 Thu, 05 Aug 2021 04:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210805110048.1696362-1-arnd@kernel.org> <20210805112546.gitosuu7bzogbzyf@skbuf>
In-Reply-To: <20210805112546.gitosuu7bzogbzyf@skbuf>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 5 Aug 2021 13:39:34 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0w95+3dBo5OLeCsEi8gjmFqabnSeqeNPQq49=rPeRm=A@mail.gmail.com>
Message-ID: <CAK8P3a0w95+3dBo5OLeCsEi8gjmFqabnSeqeNPQq49=rPeRm=A@mail.gmail.com>
Subject: Re: [PATCH net-next] dsa: sja1105: fix reverse dependency
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 5, 2021 at 1:25 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Aug 05, 2021 at 01:00:28PM +0200, Arnd Bergmann wrote:
> >
> > Fixes: 566b18c8b752 ("net: dsa: sja1105: implement TX timestamping for SJA1110")
> > Fixes: 227d07a07ef1 ("net: dsa: sja1105: Add support for traffic through standalone ports")
>
> The second Fixes: tag makes no sense.

Fair enough. I added this because that was when the original 'select' got added,
but of course it was not wrong at the time.

> > diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> > index bca1b5d66df2..548285539752 100644
> > --- a/net/dsa/Kconfig
> > +++ b/net/dsa/Kconfig
> > @@ -138,6 +138,7 @@ config NET_DSA_TAG_LAN9303
> >
> >  config NET_DSA_TAG_SJA1105
> >       tristate "Tag driver for NXP SJA1105 switches"
> > +     depends on NET_DSA_SJA1105 || !NET_DSA_SJA1105
>
> I think I would prefer an optional "build as module if NET_DSA_SJA1105 is a module"
> dependency only if NET_DSA_SJA1105_PTP is enabled. I think this is how that is
> expressed:
>
>         depends on (NET_DSA_SJA1105 && NET_DSA_SJA1105_PTP) || !NET_DSA_SJA1105 || !NET_DSA_SJA1105_PTP

Ah, I had not realized this dependency is only there when NET_DSA_SJA1105_PTP
is also enabled. I will give this a little more testing and resend
later with that change.

Do you have any opinion on whether that 'select' going the other way is still
relevant?

      Arnd
