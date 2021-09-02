Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EE43FEF90
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 16:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345459AbhIBOif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 10:38:35 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:39875 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345637AbhIBOib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 10:38:31 -0400
Received: by mail-ot1-f41.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so2763804otf.6;
        Thu, 02 Sep 2021 07:37:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2rl17F8ZLBnG5Isa+rmWjX2SNqghsw0qlnTGMKBisZ0=;
        b=h6acscH9YzN7mudrVnga/dMRI8dWQQsLCC0TAEa7y58n4i2u7YbR/ZXP1fymmI/Jd7
         avMJozazwugwGRkVG498Kj5ope1tnccMWA5DCNADPqatJ1U97R+iNJITVh+ove3Cj86N
         CjpM9Ah04avjDqfIQvoFoonHKg2+1UPsnylrYhKPnsJkN4mG4PhaGmxK5mZ4YbVfFr6M
         Mot6RghEKw3resvqqD2+WySdHg8Pdolns3wkiN6Lc+NSSu0OcF5S4A4pWoSpZcGbO2bh
         uOEI38KeD4QPQgNyKfFLx3ur1sl/0nqav7KN0vTMnKB7ENjLCiqTYYurGdy6vNzD9eDN
         vuWw==
X-Gm-Message-State: AOAM533wLQCvzR7sxHm2QQWhZhne1gS+EQVEN/kKu6/DHUgGdUxty9Y3
        wier6UK7pCk741q0RqRkrD2JGIaX4ozFsmefjtM=
X-Google-Smtp-Source: ABdhPJyrp2UQgnC/bMjq5FEMaYHKwQw/CGCD4kMAVeIwn6tfTR+Oa80W/Q25Kga3HOIYpu8ch3KhznvFoaPPcUbuTPI=
X-Received: by 2002:a9d:7115:: with SMTP id n21mr2928384otj.321.1630593452296;
 Thu, 02 Sep 2021 07:37:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com> <YTBkbvYYy2f/b3r2@kroah.com>
In-Reply-To: <YTBkbvYYy2f/b3r2@kroah.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 2 Sep 2021 16:37:21 +0200
Message-ID: <CAJZ5v0jfdE4RTR=71a6eGDoOF5jvr0ReM27WME+owmPLkXuU5w@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 7:43 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Sep 02, 2021 at 01:50:51AM +0300, Vladimir Oltean wrote:
> > There are systems where the PHY driver might get its probe deferred due
> > to a missing supplier, like an interrupt-parent, gpio, clock or whatever.
> >
> > If the phy_attach_direct call happens right in between probe attempts,
> > the PHY library is greedy and assumes that a specific driver will never
> > appear, so it just binds the generic PHY driver.
> >
> > In certain cases this is the wrong choice, because some PHYs simply need
> > the specific driver. The specific PHY driver was going to probe, given
> > enough time, but this doesn't seem to matter to phy_attach_direct.
> >
> > To solve this, make phy_attach_direct check whether a specific PHY
> > driver is pending or not, and if it is, just defer the probing of the
> > MAC that's connecting to us a bit more too.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/base/dd.c            | 21 +++++++++++++++++++--
> >  drivers/net/phy/phy_device.c |  8 ++++++++
> >  include/linux/device.h       |  1 +
> >  3 files changed, 28 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> > index 1c379d20812a..b22073b0acd2 100644
> > --- a/drivers/base/dd.c
> > +++ b/drivers/base/dd.c
> > @@ -128,13 +128,30 @@ static void deferred_probe_work_func(struct work_struct *work)
> >  }
> >  static DECLARE_WORK(deferred_probe_work, deferred_probe_work_func);
> >
> > +static bool __device_pending_probe(struct device *dev)
> > +{
> > +     return !list_empty(&dev->p->deferred_probe);
> > +}
> > +
> > +bool device_pending_probe(struct device *dev)
> > +{
> > +     bool pending;
> > +
> > +     mutex_lock(&deferred_probe_mutex);
> > +     pending = __device_pending_probe(dev);
> > +     mutex_unlock(&deferred_probe_mutex);
> > +
> > +     return pending;
> > +}
> > +EXPORT_SYMBOL_GPL(device_pending_probe);
> > +
> >  void driver_deferred_probe_add(struct device *dev)
> >  {
> >       if (!dev->can_match)
> >               return;
> >
> >       mutex_lock(&deferred_probe_mutex);
> > -     if (list_empty(&dev->p->deferred_probe)) {
> > +     if (!__device_pending_probe(dev)) {
> >               dev_dbg(dev, "Added to deferred list\n");
> >               list_add_tail(&dev->p->deferred_probe, &deferred_probe_pending_list);
> >       }
> > @@ -144,7 +161,7 @@ void driver_deferred_probe_add(struct device *dev)
> >  void driver_deferred_probe_del(struct device *dev)
> >  {
> >       mutex_lock(&deferred_probe_mutex);
> > -     if (!list_empty(&dev->p->deferred_probe)) {
> > +     if (__device_pending_probe(dev)) {
> >               dev_dbg(dev, "Removed from deferred list\n");
> >               list_del_init(&dev->p->deferred_probe);
> >               __device_set_deferred_probe_reason(dev, NULL);
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 52310df121de..2c22a32f0a1c 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -1386,8 +1386,16 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
> >
> >       /* Assume that if there is no driver, that it doesn't
> >        * exist, and we should use the genphy driver.
> > +      * The exception is during probing, when the PHY driver might have
> > +      * attempted a probe but has requested deferral. Since there might be
> > +      * MAC drivers which also attach to the PHY during probe time, try
> > +      * harder to bind the specific PHY driver, and defer the MAC driver's
> > +      * probing until then.
>
> Wait, no, this should not be a "special" thing, and why would the list
> of deferred probe show this?
>
> If a bus wants to have this type of "generic vs. specific" logic, then
> it needs to handle it in the bus logic itself as that does NOT fit into
> the normal driver model at all.

Well, I think that this is a general issue and it appears to me to be
present in the driver core too, at least to some extent.

Namely, if there are two drivers matching the same device and the
first one's ->probe() returns -EPROBE_DEFER, that will be converted to
EPROBE_DEFER by really_probe(), so driver_probe_device() will pass it
to __device_attach_driver() which then will return 0.  This
bus_for_each_drv() will call __device_attach_driver()  for the second
matching driver even though the first one may still probe successfully
later.

To me, this really is a variant of "if a driver has failed to probe,
try another one" which phy_attach_direct() appears to be doing and in
both cases the probing of the "alternative" is premature if the
probing of the original driver has been deferred.

> Don't try to get a "hint" of this by messing with the probe function list.

I agree that this doesn't look particularly clean, but then I'm
wondering how to address this cleanly.
