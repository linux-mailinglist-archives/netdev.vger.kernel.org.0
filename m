Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A3641E0FA
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 20:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350715AbhI3SWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 14:22:03 -0400
Received: from mail-oi1-f176.google.com ([209.85.167.176]:42635 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348239AbhI3SWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 14:22:02 -0400
Received: by mail-oi1-f176.google.com with SMTP id x124so8407172oix.9;
        Thu, 30 Sep 2021 11:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ef7KENLW1l1PGesfqJMrkuTOmq0xzY2aXbR1ZPKfeKo=;
        b=xSGMF7xAyaMcnlihuCFjEglZ1OAaAs+43FO8RnEa+FXTIcFXT45nQNN1cdWlnI0GWd
         eKrQE2Fwrnl20UsFLJGyOBJBIhcwfmETUDYqhVx+Fh03T0M/1jRpvJAbjN5ku9yTI5AF
         lyv335JsWGjM48sKZJrUVEflwLJ5xobKZ2lIuFteifqEqpRzqgIjAkM6SvO7u26ty4YC
         ZM0pXt7IgPfeRePrPxfCOrahV8u8w0a+R3FPK/u+17z/gLLrzgQFfbLljq6TN1gA58mU
         gZ8AoZWpXEbEOV9T0ZSsClIfvoWi+u5CwW5Yrsk9YSQ4owCdNi4QeM3K40QAZtrlkzQN
         RLKg==
X-Gm-Message-State: AOAM533nDSwEYxwxMbNYz/hW1z16aF0kh1APP9h2r0O6wzBetB9e2KVr
        6g61ekFs2DdbUDYv74BnOux3u3j5HOuEkbquzC1FZuWvOqw=
X-Google-Smtp-Source: ABdhPJyVi3QhT6Mkd8Puepw6tOTOAjfQnSqEQnm9+cc/GmJMrXSfrSb1F04tCCjt8i30lNWilUXd9wAmy8RPIkpHreA=
X-Received: by 2002:a05:6808:178c:: with SMTP id bg12mr537861oib.157.1633026019701;
 Thu, 30 Sep 2021 11:20:19 -0700 (PDT)
MIME-Version: 1.0
References: <8e4bbd5c59de31db71f718556654c0aa077df03d.camel@linux.ibm.com>
 <5ea40608-388e-1137-9b86-85aad1cad6f6@intel.com> <b9e461a5-75de-6f45-1709-d9573492f7ac@intel.com>
In-Reply-To: <b9e461a5-75de-6f45-1709-d9573492f7ac@intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 30 Sep 2021 20:20:08 +0200
Message-ID: <CAJZ5v0gpxRDt0V3Eh1_edZAudxyL3-ik4MhT7TzijTYeOd=_Vg@mail.gmail.com>
Subject: Re: Oops in during sriov_enable with ixgbe driver
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 7:38 PM Rafael J. Wysocki
<rafael.j.wysocki@intel.com> wrote:
>
> On 9/30/2021 7:31 PM, Jesse Brandeburg wrote:
> > On 9/28/2021 4:56 AM, Niklas Schnelle wrote:
> >> Hi Jesse, Hi Tony,
> >>
> >> Since v5.15-rc1 I've been having problems with enabling SR-IOV VFs on
> >> my private workstation with an Intel 82599 NIC with the ixgbe driver. I
> >> haven't had time to bisect or look closer but since it still happens on
> >> v5.15-rc3 I wanted to at least check if you're aware of the problem as
> >> I couldn't find anything on the web.
> > We haven't heard anything of this problem.
> >
> >
> >> I get below Oops when trying "echo 2 > /sys/bus/pci/.../sriov_numvfs"
> >> and suspect that the earlier ACPI messages could have something to do
> >> with that, absolutely not an ACPI expert though. If there is a need I
> >> could do a bisect.
> > Hi Niklas, thanks for the report, I added the Intel Driver's list for
> > more exposure.
> >
> > I asked the developers working on that driver to take a look and they
> > tried to reproduce, and were unable to do so. This might be related to
> > your platform, which strongly suggests that the ACPI stuff may be related.
> >
> > We have tried to reproduce but everything works fine no call trace in
> > scenario with creating VF.
> >
> > This is good in that it doesn't seem to be a general failure, you may
> > want to file a kernel bugzilla (bugzilla.kernel.org) to track the issue,
> > and I hope that @Rafael might have some insight.
> >
> > This issue may be related to changes in acpi_pci_find_companion,
> > but as I say, we are not able to reproduce this.
> >
> > commit 59dc33252ee777e02332774fbdf3381b1d5d5f5d
> > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Date:   Tue Aug 24 16:43:55 2021 +0200
> >      PCI: VMD: ACPI: Make ACPI companion lookup work for VMD bus
>
> This change doesn't affect any devices beyond the ones on the VMD bus.

The only failing case I can see is when the device is on the VMD bus
and its bus pointer is NULL, so the dereference in
vmd_acpi_find_companion() crashes.

Can anything like that happen?

> > At this point maybe a bisect would be helpful, since this seems to be a
> > corner case that we used to handle but no longer do.
