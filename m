Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DB2337ECD
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhCKUMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhCKUML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 15:12:11 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433ABC061574;
        Thu, 11 Mar 2021 12:12:11 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id o11so23357977iob.1;
        Thu, 11 Mar 2021 12:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0BWzRRmxcHXMo1GESs4pU1GSd6L40zWcyadyEujahI8=;
        b=KRf84g2Npibxl0qELT/JLkyVIT/Z6l9FevlNRXCjezPmNdSOUMnq0pmaKZrXs4vn6d
         wZB/MIY2rfNQxyPgV5YTy2PYFYoF4O7+AZyhQrl5ek4Tl/mjEBPBeKLN6deowiTPpVJ9
         O78TZmt3D3iaGpce4002oBKtHZnKVtLaeCMVHp66FND8wcuMVwKJW3ED3QfSl+V9PmKG
         JFWg6vejVZw7QHSJkoiIW8uhDXZdgVNfuc65/Y6qSOzhIVOHF4sA6xvxjZNfMrXrmFRL
         aRi6i10L30yK679BxVVyeNWvhFtW0Capo3KW2RuM5OJDXiqXEaQxhPKcjI/ass53JhLU
         dv+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0BWzRRmxcHXMo1GESs4pU1GSd6L40zWcyadyEujahI8=;
        b=pNs5bzOZSzvmmwwgv8V2yepXMHd2jn45xy8a3eywI6jrvBOvZlFp326Ke9QczVB5sK
         Yg8FIndBUL/ZlvyosfWNmRC7c6Xs6oq0tdBrUEmONAgFkpIeBnAEahmc2doF0z0Y5BrS
         DbV9FZQiTXTJWlq9ZL63SkRjEchukxY+6zoGn+Bh80eNTACYqekSvasD8tsNosiyox0e
         F6dbb05XzEnBWIV6NP9digMQ5e6Q/D/aBbGNngyPqrgTBx87J5qXnm6493Jt9RvqhBRK
         m7Gt2yuWfSlgyhYli7FgTQ/jLHHHKfzerGwbHGzDMK5hyS63oGMCzpmrDrZqHgDKVSLX
         GPPQ==
X-Gm-Message-State: AOAM531TjcBBS5DBvB/ni68HPSICpgJKGcgQ2uhmMaaecOr5IMdg3mcA
        LXy0c+QKezBA57VRRp5Mm+mB9DtMB9jnriJdkRY=
X-Google-Smtp-Source: ABdhPJw054MpAcEdRnSJVTojPnIUo5su5huEFuZV55yOCCRdcJhaILMUr2dNUkdgob4ObL/tKjH5Zm4+cvftiYuhcgE=
X-Received: by 2002:a02:53:: with SMTP id 80mr5369628jaa.96.1615493530582;
 Thu, 11 Mar 2021 12:12:10 -0800 (PST)
MIME-Version: 1.0
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520> <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
 <YEp01m0GiNzOSUV8@unreal>
In-Reply-To: <YEp01m0GiNzOSUV8@unreal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 11 Mar 2021 12:11:59 -0800
Message-ID: <CAKgT0Ue363fZEwqGUa1UAAYotUYH8QpEADW1U5yfNS7XkOLx0Q@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 11:51 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Thu, Mar 11, 2021 at 11:37:28AM -0800, Alexander Duyck wrote:
> > On Thu, Mar 11, 2021 at 10:17 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > >
> > > On Wed, Mar 10, 2021 at 03:34:01PM -0800, Alexander Duyck wrote:
> > > > On Wed, Mar 10, 2021 at 11:09 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > > > On Sun, Mar 07, 2021 at 10:55:24AM -0800, Alexander Duyck wrote:
> > > > > > On Sun, Feb 28, 2021 at 11:55 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > >
> > > > > > > @Alexander Duyck, please update me if I can add your ROB tag again
> > > > > > > to the series, because you liked v6 more.
> > > > > > >
> > > > > > > Thanks
> > > > > > >
> > > > > > > ---------------------------------------------------------------------------------
> > > > > > > Changelog
> > > > > > > v7:
> > > > > > >  * Rebase on top v5.12-rc1
> > > > > > >  * More english fixes
> > > > > > >  * Returned to static sysfs creation model as was implemented in v0/v1.
>
> <...>
>
> > > > representors rather than being actual PCIe devices. Having
> > > > functionality that only works when the VF driver is not loaded just
> > > > feels off. The VF sysfs directory feels like it is being used as a
> > > > subdirectory of the PF rather than being a device on its own.
> > >
> > > Moving "virtfnX_msix_count" to the PF seems like it would mitigate
> > > this somewhat.  I don't know how to make this work while a VF driver
> > > is bound without making the VF feel even less like a PCIe device,
> > > i.e., we won't be able to use the standard MSI-X model.
> >
> > Yeah, I actually do kind of like that idea. In addition it would
> > address one of the things I pointed out as an issue before as you
> > could place the virtfn values that the total value in the same folder
> > so that it is all in one central spot rather than having to walk all
> > over the sysfs hierarchy to check the setting for each VF when trying
> > to figure out how the vectors are currently distributed.
>
> User binds specific VF with specific PCI ID to VM, so instead of
> changing MSI-X table for that specific VF, he will need to translate
> from virtfn25_msix_count to PCI ID.

Wouldn't that just be a matter of changing the naming so that the PCI
ID was present in the virtfn name?

> I also gave an example of my system where I have many PFs and VFs
> function numbers are not distributed nicely. On that system virtfn25_msix_count
> won't translate to AA:BB:CC.25 but to something else.

That isn't too surprising since normally we only support 7 functions
per device. I am okay with not using the name virtfnX. If you wanted
to embed the bus, device, func in the naming scheme that would work
for me too.

Really in general as a naming scheme just using a logical number have
probably never provided all that much value. There may be an argument
to be made for renaming the virtfn symlinks to include bus, device,
function instead.
