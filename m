Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E833F5954
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 09:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbhHXHql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 03:46:41 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:37524
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234864AbhHXHqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 03:46:40 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2021 03:46:40 EDT
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 16AF740797
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 07:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629790788;
        bh=Zuyxk19zELEDrtZ5P5c0Ms+6wi23L0zn72ao5lHm2JE=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=FyLWOxs1Tkm080wuU24fOkfZV4BosA2DBb1dzTMhyWJKREAJuDlZ0ZVngOIOKGwPk
         tkiXQS2xv2eMpGNEMnmw029PVH0PH5+WvMs3lYKrHvs4r1qnj24MTh8O+eg3fesTsb
         ULpoWR0uum0Sci7v4EQkAAOSmvQuFnaSrgjZichBBe235shPn4HUhGsMGrwMF6WwGd
         vXuEyqogM6Z8kgOhkKbsSjn48L/HdMGsvYWHapRJqui8bO9kyaPZj6QaDj1lC8azel
         QUhKku1olpJ+cJp/T3YH50IW+nEF80/dkNCsUkjQcl2vuyk4vwWgbfSEbEs8AtiX6k
         YPhtF3iSVnVXw==
Received: by mail-ej1-f72.google.com with SMTP id gb24-20020a170907961800b005c158d37301so5710266ejc.17
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 00:39:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zuyxk19zELEDrtZ5P5c0Ms+6wi23L0zn72ao5lHm2JE=;
        b=LzeiEMjY0gzyt+Z78hiEzs2pFOIuarBlFVpdyOHtr4sWLCAA5CzFkCuI9lrXoz6oGN
         7oxJEE6plrtPPuP5X4Tzju1fWfquwUI4LADKJlKRi/BvvibkzAGWz58ENISYm97K7b75
         AJN6B0e3m3kM1bQu3O6kjfOa7mcoHLtzGo7H78vRT42wQQovo2ow99e1I6IJEpWp6/vl
         JW+RMvYlbs/eYJpXvgjr2YeOJ3OtcTraXwKSTPfxmDl8FSO4nXcqFM/JGv3OqpzTETTy
         UdiN8uGpfKR8F6fcS/cqE6tW/8oDQ9lUfBrkAMTXHSq0KRaVjkX/bd21q9SisuJ4WlDX
         L2Ww==
X-Gm-Message-State: AOAM531gomFD0V0pOTzOlfYTR9RJ29u+ttvKYbhDg9L/3E5uKi/weo5r
        h7HpRWKgzPCcTYHkU+9eRQsC7hwZ9bAxxfPyjLynaOR2R6KsDzSBF4MjC2dYQreA5lflJs6J1+q
        j10FT2BBuMcBj6dWL3HMKb7Gtmbpw4IAnsn1bBUa5ArpTanit6A==
X-Received: by 2002:a17:906:6d9:: with SMTP id v25mr40563801ejb.192.1629790787677;
        Tue, 24 Aug 2021 00:39:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfAMy5028gDLZFF3NX7qVJxB/Bfu0IQnN2gB92EDHCsxshcZq4TLviWQfhAzi0O6ddx0dG4313iHbhciyccj8=
X-Received: by 2002:a17:906:6d9:: with SMTP id v25mr40563778ejb.192.1629790787402;
 Tue, 24 Aug 2021 00:39:47 -0700 (PDT)
MIME-Version: 1.0
References: <9ebf8fa1-cbd4-75d6-1099-1a45ca8b8bb0@gmail.com> <20210820210309.GA3357515@bjorn-Precision-5520>
In-Reply-To: <20210820210309.GA3357515@bjorn-Precision-5520>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Tue, 24 Aug 2021 15:39:35 +0800
Message-ID: <CAAd53p5KH69NPMejM93STx3J+0WNBuXzaheWJJoURM39=DLvxg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/3] r8169: Implement dynamic ASPM mechanism
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        nic_swsd <nic_swsd@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 21, 2021 at 5:03 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Thu, Aug 19, 2021 at 05:45:22PM +0200, Heiner Kallweit wrote:
> > On 19.08.2021 13:42, Bjorn Helgaas wrote:
> > > On Thu, Aug 19, 2021 at 01:45:40PM +0800, Kai-Heng Feng wrote:
> > >> r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> > >> Same issue can be observed with older vendor drivers.
> > >
> > > On some platforms but not on others?  Maybe the PCIe topology is a
> > > factor?  Do you have bug reports with data, e.g., "lspci -vv" output?
> > >
> > >> The issue is however solved by the latest vendor driver. There's a new
> > >> mechanism, which disables r8169's internal ASPM when the NIC traffic has
> > >> more than 10 packets, and vice versa.
> > >
> > > Presumably there's a time interval related to the 10 packets?  For
> > > example, do you want to disable ASPM if 10 packets are received (or
> > > sent?) in a certain amount of time?
> > >
> > >> The possible reason for this is
> > >> likely because the buffer on the chip is too small for its ASPM exit
> > >> latency.
> > >
> > > Maybe this means the chip advertises incorrect exit latencies?  If so,
> > > maybe a quirk could override that?
> > >
> > >> Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
> > >> use dynamic ASPM under Windows. So implement the same mechanism here to
> > >> resolve the issue.
> > >
> > > What exactly is "dynamic ASPM"?
> > >
> > > I see Heiner's comment about this being intended only for a downstream
> > > kernel.  But why?
> > >
> > We've seen various more or less obvious symptoms caused by the broken
> > ASPM support on Realtek network chips. Unfortunately Realtek releases
> > neither datasheets nor errata information.
> > Last time we attempted to re-enable ASPM numerous problem reports came
> > in. These Realtek chips are used on basically every consumer mainboard.
> > The proposed workaround has potential side effects: In case of a
> > congestion in the chip it may take up to a second until ASPM gets
> > disabled, what may affect performance, especially in case of alternating
> > traffic patterns. Also we can't expect support from Realtek.
> > Having said that my decision was that it's too risky to re-enable ASPM
> > in mainline even with this workaround in place. Kai-Heng weights the
> > power saving higher and wants to take the risk in his downstream kernel.
> > If there are no problems downstream after few months, then this
> > workaround may make it to mainline.
>
> Since ASPM apparently works well on some platforms but not others, I'd
> suspect some incorrect exit latencies.

Can be, but if their dynamic ASPM mechanism can workaround the issue,
maybe their hardware is just designed that way?

>
> Ideally we'd have some launchpad/bugzilla links, and a better
> understanding of the problem, and maybe a quirk that makes this work
> on all platforms without mucking up the driver with ASPM tweaks.

The tweaks is OS-agnostic and is also implemented in Windows.

>
> But I'm a little out of turn here because the only direct impact to
> the PCI core is the pcie_aspm_supported() interface.  It *looks* like
> these patches don't actually touch the PCIe architected ASPM controls
> in Link Control; all I see is mucking with Realtek-specific registers.

AFAICT, Realtek ethernet NIC and wireless NIC both have two layers of
ASPM, one is the regular PCIe ASPM, and a Realtek specific internal
ASPM.
Both have to be enabled to really make ASPM work for them.

Kai-Heng

>
> I think this is more work than it should be and likely to be not as
> reliable as it should be.  But I guess that's up to you guys.
>
> Bjorn
