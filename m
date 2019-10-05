Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBCBECCBA4
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 19:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbfJERXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 13:23:08 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41723 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfJERXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 13:23:07 -0400
Received: by mail-io1-f68.google.com with SMTP id n26so20185538ioj.8;
        Sat, 05 Oct 2019 10:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pxUjmIbw13CFxUgTRwyvWTjL0FCOWPTaQat66nHsxn0=;
        b=GjHYE04fxu3DN13Mnf7fbSHz1nFx//ZjX7nE9aR/qHFSe2rn6p59OexXtYrrEraHOa
         cXCoRJk2iT1G5LdGA6mTi8hUidXPkXUBu+tOw+Tx2dvt0IUcjmL41mT7b4dRX8eUrTyk
         607GLwODe1OC5tQeDGdWeIkX+MYfVZVXXswoWXtm70D9EHTsWqAr/FZsMS7GpIuokoPm
         9/8/yAHZaDs3AstB1kp0qbEECIodqnVJfQ+l7AG/akZsUlPGpW+a1VQXF08r15qDG0UX
         a+JybUpzNaVL93WAYik84iCfzADKmk1AcZ4f7dLGNeuLteK+YraQ3dkxhHswE/HTi/kP
         Qp+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pxUjmIbw13CFxUgTRwyvWTjL0FCOWPTaQat66nHsxn0=;
        b=XjCDmB2QcTjEQA/14iaHdBh3qk+/njOBDrQE4CCHfZ+jCNoa15+152nFbDyBX+im4H
         HShQOhSB46rwuXM/QgbojnV9Xayf+fZGavlUotxL8SdjrMIZWblE9RE5pyZLuhXuwVNg
         DJf4+lAaEL3ckkwc5hCzXIiDQ0+NrFgGRTTbgxzDUrRx/zmy0S14bjSGgiTz3+MC+s8F
         +AR+zBc7LwjdHxTucL0OKNvpaUqQvqamfNe4Llpu3z3EIOYnie39SE7dGFDg1dgISb8r
         MbrAqx4yMF34chxNPHTO8nSCTMmKPIrNJR30xlx85s3oCJT7w4wLKqMFsKS89GWrXl/M
         5nVw==
X-Gm-Message-State: APjAAAWDFfeyDAfXRlfEquZ4BwtOqglIiBXO191iBlKrBbZKz8yjkXhl
        A1TTByoiRKBrqZeewisH3KKko3hbpWGChrws5KY=
X-Google-Smtp-Source: APXvYqw5Yui+O5GuTNL9SpPqBww1zkYRVIwN1ybYrEwInOuQbbnSEOAw3FiqxgVcoXVCZ2BQo2WQINUT+MLaImyTfPk=
X-Received: by 2002:a6b:da06:: with SMTP id x6mr9478783iob.42.1570296186664;
 Sat, 05 Oct 2019 10:23:06 -0700 (PDT)
MIME-Version: 1.0
References: <1570208647.1250.55.camel@oc5348122405> <20191004233052.28865.1609.stgit@localhost.localdomain>
 <1570241926.10511.7.camel@oc5348122405>
In-Reply-To: <1570241926.10511.7.camel@oc5348122405>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 5 Oct 2019 10:22:55 -0700
Message-ID: <CAKgT0Ud7SupVd3RQmTEJ8e0fixiptS-1wFg+8V4EqpHEuAC3wQ@mail.gmail.com>
Subject: Re: [RFC PATCH] e1000e: Use rtnl_lock to prevent race conditions
 between net and pci/pm
To:     "David Z. Dai" <zdai@linux.vnet.ibm.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>, zdai@us.ibm.com,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 7:18 PM David Z. Dai <zdai@linux.vnet.ibm.com> wrote:
>
> On Fri, 2019-10-04 at 16:36 -0700, Alexander Duyck wrote:
> > From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> >
> > This patch is meant to address possible race conditions that can exist
> > between network configuration and power management. A similar issue was
> > fixed for igb in commit 9474933caf21 ("igb: close/suspend race in
> > netif_device_detach").
> >
> > In addition it consolidates the code so that the PCI error handling code
> > will essentially perform the power management freeze on the device prior to
> > attempting a reset, and will thaw the device afterwards if that is what it
> > is planning to do. Otherwise when we call close on the interface it should
> > see it is detached and not attempt to call the logic to down the interface
> > and free the IRQs again.
> >
> > >From what I can tell the check that was adding the check for __E1000_DOWN
> > in e1000e_close was added when runtime power management was added. However
> > it should not be relevant for us as we perform a call to
> > pm_runtime_get_sync before we call e1000_down/free_irq so it should always
> > be back up before we call into this anyway.
> >
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> > ---
> >
> > I'm putting this out as an RFC for now. I haven't had a chance to do much
> > testing yet, but I have verified no build issues, and the driver appears
> > to load, link, and pass traffic without problems.
> >
> > This should address issues seen with either double freeing or never freeing
> > IRQs that have been seen on this and similar drivers in the past.
> >
> > I'll submit this formally after testing it over the weekend assuming there
> > are no issues.
> >
> >  drivers/net/ethernet/intel/e1000e/netdev.c |   33 ++++++++++++++--------------
> >  1 file changed, 17 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> > index d7d56e42a6aa..182a2c8f12d8 100644
> > --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> > +++ b/drivers/net/ethernet/intel/e1000e/netdev.c

<snip>

> >
> > -#ifdef CONFIG_PM_SLEEP
> >  static int e1000e_pm_thaw(struct device *dev)
> >  {
> >       struct net_device *netdev = dev_get_drvdata(dev);
> >       struct e1000_adapter *adapter = netdev_priv(netdev);
> > +     int rc = 0;
> >
> >       e1000e_set_interrupt_capability(adapter);
> > -     if (netif_running(netdev)) {
> > -             u32 err = e1000_request_irq(adapter);
> >
> > -             if (err)
> > -                     return err;
> > +     rtnl_lock();
> > +     if (netif_running(netdev)) {
> > +             rc = e1000_request_irq(adapter);
> > +             if (rc)
> > +                     goto err_irq;
> >
> >               e1000e_up(adapter);
> >       }
> >
> >       netif_device_attach(netdev);
> > -
> > -     return 0;
> > +     rtnl_unlock();
> > +err_irq:
> > +     return rc;
> >  }
> >
> In e1000e_pm_thaw(), these 2 lines need to switch order to avoid
> deadlock.
> from:
> +       rtnl_unlock();
> +err_irq:
>
> to:
> +err_irq:
> +       rtnl_unlock();
>
> I will find hardware to test this patch next week. Will update the test
> result later.
>
> Thanks! - David

Thanks for spotting that. I will update my copy of the patch for when
I submit the final revision.

I'll probably wait to submit it for acceptance until you have had a
chance to verify that it resolves the issue you were seeing.

Thanks.

- Alex
