Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E39D41EE6F
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhJANW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:22:57 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:46030 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbhJANW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:22:56 -0400
Received: by mail-ot1-f47.google.com with SMTP id e66-20020a9d2ac8000000b0054da8bdf2aeso9220526otb.12;
        Fri, 01 Oct 2021 06:21:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ccQjIYZZTjb3miwbaozC6bIs/tTh0jmSzaX5X7213ro=;
        b=qekQdMh8DTHoovrcuAD/tHiCte90YVLYbcxfNO1tHnzm1LUE/xmzZ7iM0Lni9sxq8L
         rjOSCR7uPsLATeOWCsPO4GuTi+aUuulpc7eQ23+ccqUCjOz24TZt3Q3JuJ8hawp8q/H+
         omZv4bXTO6VhEkhNrM9dSpP+UHI0QzPFcJ+Sw4KRvbSESfvLH6ZJvt6RKFrjKlWrVJMh
         ekpn//Dha2qep/fzj02fArjSB2BnA0IbjRqBUW03rlNDRhFQTh64up+MDNS3W2kKbG9T
         XRNnzNkdKb7CiiT0WGYvmedxA4cm2zBo5WR+bvUNPQNUxEaHy1tWKMgOnIvZK17IQADk
         yzig==
X-Gm-Message-State: AOAM533u73BTCZwu3kSwH/H+S1q+lU/toeb5EZHzQgJeUzVk5epQWg3l
        WspoiqFnN2TIrHRxS7/cQiFgtHqtgoggkR8PlaU=
X-Google-Smtp-Source: ABdhPJwCR2Wo/1OGr5zYsrtobZFZbORlSmd2mGjDR3WPp/zNEIwNKDJ5dHmcYFsgX+IzZPHVm/q359uINdGv0p+dKT4=
X-Received: by 2002:a05:6830:82b:: with SMTP id t11mr10127019ots.319.1633094471783;
 Fri, 01 Oct 2021 06:21:11 -0700 (PDT)
MIME-Version: 1.0
References: <8e4bbd5c59de31db71f718556654c0aa077df03d.camel@linux.ibm.com>
 <5ea40608-388e-1137-9b86-85aad1cad6f6@intel.com> <b9e461a5-75de-6f45-1709-d9573492f7ac@intel.com>
 <CAJZ5v0gpxRDt0V3Eh1_edZAudxyL3-ik4MhT7TzijTYeOd=_Vg@mail.gmail.com>
 <CAJZ5v0hsQvHp2PqFjxvyx4tPCnNC7BCWyfPj-eADFa1w68BCMQ@mail.gmail.com> <924c2d6ef51a83cce5c9bcf4004bbf1506c5a768.camel@linux.ibm.com>
In-Reply-To: <924c2d6ef51a83cce5c9bcf4004bbf1506c5a768.camel@linux.ibm.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 1 Oct 2021 15:21:00 +0200
Message-ID: <CAJZ5v0hoYfSE3MCuFeHYjuD5trznCJWDthWwUFp9M52m3FK-zg@mail.gmail.com>
Subject: Re: Oops in during sriov_enable with ixgbe driver
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 1, 2021 at 10:23 AM Niklas Schnelle <schnelle@linux.ibm.com> wrote:
>
> On Thu, 2021-09-30 at 20:37 +0200, Rafael J. Wysocki wrote:
> > On Thu, Sep 30, 2021 at 8:20 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > > On Thu, Sep 30, 2021 at 7:38 PM Rafael J. Wysocki
> > > <rafael.j.wysocki@intel.com> wrote:
> > > > On 9/30/2021 7:31 PM, Jesse Brandeburg wrote:
> > > > > On 9/28/2021 4:56 AM, Niklas Schnelle wrote:
> > > > > > Hi Jesse, Hi Tony,
> > > > > >
> > > > > > Since v5.15-rc1 I've been having problems with enabling SR-IOV VFs on
> > > > > > my private workstation with an Intel 82599 NIC with the ixgbe driver. I
> > > > > > haven't had time to bisect or look closer but since it still happens on
> > > > > > v5.15-rc3 I wanted to at least check if you're aware of the problem as
> > > > > > I couldn't find anything on the web.
> > > > > We haven't heard anything of this problem.
> > > > >
> > > > >
> > > > > > I get below Oops when trying "echo 2 > /sys/bus/pci/.../sriov_numvfs"
> > > > > > and suspect that the earlier ACPI messages could have something to do
> > > > > > with that, absolutely not an ACPI expert though. If there is a need I
> > > > > > could do a bisect.
> > > > > Hi Niklas, thanks for the report, I added the Intel Driver's list for
> > > > > more exposure.
> > > > >
> > > > > I asked the developers working on that driver to take a look and they
> > > > > tried to reproduce, and were unable to do so. This might be related to
> > > > > your platform, which strongly suggests that the ACPI stuff may be related.
> > > > >
> > > > > We have tried to reproduce but everything works fine no call trace in
> > > > > scenario with creating VF.
> > > > >
> > > > > This is good in that it doesn't seem to be a general failure, you may
> > > > > want to file a kernel bugzilla (bugzilla.kernel.org) to track the issue,
> > > > > and I hope that @Rafael might have some insight.
> > > > >
> > > > > This issue may be related to changes in acpi_pci_find_companion,
> > > > > but as I say, we are not able to reproduce this.
> > > > >
> > > > > commit 59dc33252ee777e02332774fbdf3381b1d5d5f5d
> > > > > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > > > Date:   Tue Aug 24 16:43:55 2021 +0200
> > > > >      PCI: VMD: ACPI: Make ACPI companion lookup work for VMD bus
> > > >
> > > > This change doesn't affect any devices beyond the ones on the VMD bus.
> > >
> > > The only failing case I can see is when the device is on the VMD bus
> > > and its bus pointer is NULL, so the dereference in
> > > vmd_acpi_find_companion() crashes.
> > >
> > > Can anything like that happen?
> >
> > Not really, because pci_iov_add_virtfn() sets virtfn->bus.
> >
> > However, it doesn\t set virtfn->dev.parent AFAICS, so when that gets
> > dereferenced by ACPI_COMPANIO(dev->parent) in
> > acpi_pci_find_companion(), the crash occurs.
> >
> > We need a !dev->parent check in acpi_pci_find_companion() I suppose:
> >
> > Does the following change help?
> >
> > Index: linux-pm/drivers/pci/pci-acpi.c
> > ===================================================================
> > --- linux-pm.orig/drivers/pci/pci-acpi.c
> > +++ linux-pm/drivers/pci/pci-acpi.c
> > @@ -1243,6 +1243,9 @@ static struct acpi_device *acpi_pci_find
> >      bool check_children;
> >      u64 addr;
> >
> > +    if (!dev->parent)
> > +        return NULL;
> > +
> >      down_read(&pci_acpi_companion_lookup_sem);
> >
> >      adev = pci_acpi_find_companion_hook ?
>
>
> Yes the above change fixes the problem for me. SR-IOV enables
> successfully and the VFs are fully usable. Thanks!

Thanks for the confirmation!

> Just out of curiosity and because I use this system to test common code
> PCI changed. Do you have an idea what makes my system special here?
>
> The call to pci_set_acpi_fwnode() in pci_setup_device() is
> unconditional and should do the same on any ACPI enabled system.
> Also nothing in your explanation sounds specific to my system.

Right, it is not special and I'm not really sure why others don't see
this breakage.

That's one of the reasons why it is key to report problems early: this
may help to protect others from being hit by those problems.

Let me post an "official" patch for this.
