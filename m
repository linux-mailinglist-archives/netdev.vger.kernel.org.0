Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F00941E151
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 20:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhI3Sjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 14:39:41 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:44670 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhI3Sjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 14:39:40 -0400
Received: by mail-ot1-f42.google.com with SMTP id h9-20020a9d2f09000000b005453f95356cso8490427otb.11;
        Thu, 30 Sep 2021 11:37:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lUkADYfUz5un8GeU7MGDH79pA82yqB0rhOdsDK8eU6A=;
        b=u0s0nDA+OMPfuAp4lAsYh1ZxN61uhu0FRDlVTL9ukW5nnMVD+XITgN6Ebzqp2crNU3
         SN5RFRfOQDv+FPTtd+zQwwrBmyLMMbVxWgXbO+cauZkyY0EAipg8MSVHrckUd5m6WUOg
         FQTZ9cR1VNViNiUZuPxDxviQvfHF/Mo6Pe6mZuO/K+BzN/n0S+TxqDO0F9hISlzlZtA+
         KrAmR7SPpFaOb4tyPWU557EQF994n3rMxNZ0aKYXERYT5m0+tM0jbFJAblx2higZmYHy
         lN0Ui1wdMjsHZQPZJJci4p3kuUk2eazli6UVBNIxTfYiROiNpoaw+YWhuMOS9X6nRlT8
         QIBw==
X-Gm-Message-State: AOAM532jREbViNULhqWYcHkN+ZDBJq9ejgYR9qrQ97n5mUEA4DUM7HT5
        uj/nVkUW0ONDBwhMCT4Xe9Rn4dzXCJSCvh6fH1ZCMu6v69g=
X-Google-Smtp-Source: ABdhPJxIUnhHcEe7tzABklGIDEk7KBcPhVF+HiFLTsPIM+LNOIuhSRT/2BAbMOSwjMmdBscnqUc9bevf8EFVlXM2zTo=
X-Received: by 2002:a05:6830:165a:: with SMTP id h26mr6707745otr.301.1633027076597;
 Thu, 30 Sep 2021 11:37:56 -0700 (PDT)
MIME-Version: 1.0
References: <8e4bbd5c59de31db71f718556654c0aa077df03d.camel@linux.ibm.com>
 <5ea40608-388e-1137-9b86-85aad1cad6f6@intel.com> <b9e461a5-75de-6f45-1709-d9573492f7ac@intel.com>
 <CAJZ5v0gpxRDt0V3Eh1_edZAudxyL3-ik4MhT7TzijTYeOd=_Vg@mail.gmail.com>
In-Reply-To: <CAJZ5v0gpxRDt0V3Eh1_edZAudxyL3-ik4MhT7TzijTYeOd=_Vg@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 30 Sep 2021 20:37:45 +0200
Message-ID: <CAJZ5v0hsQvHp2PqFjxvyx4tPCnNC7BCWyfPj-eADFa1w68BCMQ@mail.gmail.com>
Subject: Re: Oops in during sriov_enable with ixgbe driver
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 8:20 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> On Thu, Sep 30, 2021 at 7:38 PM Rafael J. Wysocki
> <rafael.j.wysocki@intel.com> wrote:
> >
> > On 9/30/2021 7:31 PM, Jesse Brandeburg wrote:
> > > On 9/28/2021 4:56 AM, Niklas Schnelle wrote:
> > >> Hi Jesse, Hi Tony,
> > >>
> > >> Since v5.15-rc1 I've been having problems with enabling SR-IOV VFs on
> > >> my private workstation with an Intel 82599 NIC with the ixgbe driver. I
> > >> haven't had time to bisect or look closer but since it still happens on
> > >> v5.15-rc3 I wanted to at least check if you're aware of the problem as
> > >> I couldn't find anything on the web.
> > > We haven't heard anything of this problem.
> > >
> > >
> > >> I get below Oops when trying "echo 2 > /sys/bus/pci/.../sriov_numvfs"
> > >> and suspect that the earlier ACPI messages could have something to do
> > >> with that, absolutely not an ACPI expert though. If there is a need I
> > >> could do a bisect.
> > > Hi Niklas, thanks for the report, I added the Intel Driver's list for
> > > more exposure.
> > >
> > > I asked the developers working on that driver to take a look and they
> > > tried to reproduce, and were unable to do so. This might be related to
> > > your platform, which strongly suggests that the ACPI stuff may be related.
> > >
> > > We have tried to reproduce but everything works fine no call trace in
> > > scenario with creating VF.
> > >
> > > This is good in that it doesn't seem to be a general failure, you may
> > > want to file a kernel bugzilla (bugzilla.kernel.org) to track the issue,
> > > and I hope that @Rafael might have some insight.
> > >
> > > This issue may be related to changes in acpi_pci_find_companion,
> > > but as I say, we are not able to reproduce this.
> > >
> > > commit 59dc33252ee777e02332774fbdf3381b1d5d5f5d
> > > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > Date:   Tue Aug 24 16:43:55 2021 +0200
> > >      PCI: VMD: ACPI: Make ACPI companion lookup work for VMD bus
> >
> > This change doesn't affect any devices beyond the ones on the VMD bus.
>
> The only failing case I can see is when the device is on the VMD bus
> and its bus pointer is NULL, so the dereference in
> vmd_acpi_find_companion() crashes.
>
> Can anything like that happen?

Not really, because pci_iov_add_virtfn() sets virtfn->bus.

However, it doesn\t set virtfn->dev.parent AFAICS, so when that gets
dereferenced by ACPI_COMPANIO(dev->parent) in
acpi_pci_find_companion(), the crash occurs.

We need a !dev->parent check in acpi_pci_find_companion() I suppose:

Does the following change help?

Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -1243,6 +1243,9 @@ static struct acpi_device *acpi_pci_find
     bool check_children;
     u64 addr;

+    if (!dev->parent)
+        return NULL;
+
     down_read(&pci_acpi_companion_lookup_sem);

     adev = pci_acpi_find_companion_hook ?
