Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678A3334C9C
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 00:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbhCJXeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 18:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbhCJXeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 18:34:13 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF47AC061574;
        Wed, 10 Mar 2021 15:34:12 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id o11so19960327iob.1;
        Wed, 10 Mar 2021 15:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Ftr8EVh1d0OJNYhZaEkaL4BbniCbut8QXLo06tX/D8=;
        b=AznE4tLypkWxJTD6kKcS33VCyPouSCd2/v8tRJfF/+ZBxx5YvK0VCda9RKTHI9IpKG
         CkK8fj3Qf/aNTV+rrIv6lW7l80rU/W+kiWbEQ9Xom76Xf7p2behugmx/LlfT8fLYg+w7
         LETcYpsVfQYMybfNXsGSQPz9TAEymJzYVGQ1CeDS8wcwll/IA1vEMHrNwl8S+57Otwpn
         OUp+pOfHQNyAxkJKCLNP/5N5r3su+ME2NOI/BKZCqp+7PztPzrSAji5/UQCqhIQX9Jk6
         qbBZpMIPQKBpZJ7fsviuALY5FbBENLQ4iZkB2bwXjWBq5TN/RZRSUixutIFOt9JXPamD
         xYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Ftr8EVh1d0OJNYhZaEkaL4BbniCbut8QXLo06tX/D8=;
        b=TmViaC4BHX+vA6x1yI12nzlGPZ44leceg3u62eCUNB1VNcdyW6tJ5axJR6bGWgz3TU
         HxjtkF51hAYkr4RFz/wSnblXiUKGZd71luhamzDcR8TL1HAxnmmL7k1E693VTwRbsRek
         ue4XQ7QDRdLdTUByr6cdCF5vnlmuynOoziRcrwhKt/F4uPLPq1vKfQbJ/bqPz0Baywm8
         naIaWm+YQkp/34N89voEbfszgh72agbC9kXem5GqTEGJVIRSjACNDg2qT2wTY2zeCojh
         Ge2Wm9a9qUYblLHGQXdrsQ3yrrDWFWvaYzUn+oY0oikBpCzZ2YqgwC5cy6BqmPzCEwP4
         EmUA==
X-Gm-Message-State: AOAM531Dq5JjOkqCTgyFENPHan5Sj8eUmXgUFmaOiefJXAFpMwFJ+ID9
        NJlaliw29XCkItS9UDB1L75fzikNHHXcaKR4Mxx/1Gphjy8=
X-Google-Smtp-Source: ABdhPJznOmeDauib1GQ0fQyYonSba4BMC/9ETqihEb3lO3d5pRnIFJiaYe59Onf5I2XVKKJ8wjh14Tj1Lscz7eOZ4hU=
X-Received: by 2002:a05:6638:1390:: with SMTP id w16mr900475jad.83.1615419252258;
 Wed, 10 Mar 2021 15:34:12 -0800 (PST)
MIME-Version: 1.0
References: <CAKgT0Ue=g+1pZCct8Kd0OnkPEP0qhggBF96s=noDoWHMJTL6FA@mail.gmail.com>
 <20210310190906.GA2020121@bjorn-Precision-5520>
In-Reply-To: <20210310190906.GA2020121@bjorn-Precision-5520>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 10 Mar 2021 15:34:01 -0800
Message-ID: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
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

On Wed, Mar 10, 2021 at 11:09 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Sun, Mar 07, 2021 at 10:55:24AM -0800, Alexander Duyck wrote:
> > On Sun, Feb 28, 2021 at 11:55 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > @Alexander Duyck, please update me if I can add your ROB tag again
> > > to the series, because you liked v6 more.
> > >
> > > Thanks
> > >
> > > ---------------------------------------------------------------------------------
> > > Changelog
> > > v7:
> > >  * Rebase on top v5.12-rc1
> > >  * More english fixes
> > >  * Returned to static sysfs creation model as was implemented in v0/v1.
> >
> > Yeah, so I am not a fan of the series. The problem is there is only
> > one driver that supports this, all VFs are going to expose this sysfs,
> > and I don't know how likely it is that any others are going to
> > implement this functionality. I feel like you threw out all the
> > progress from v2-v6.
>
> pci_enable_vfs_overlay() turned up in v4, so I think v0-v3 had static
> sysfs files regardless of whether the PF driver was bound.
>
> > I really feel like the big issue is that this model is broken as you
> > have the VFs exposing sysfs interfaces that make use of the PFs to
> > actually implement. Greg's complaint was the PF pushing sysfs onto the
> > VFs. My complaint is VFs sysfs files operating on the PF. The trick is
> > to find a way to address both issues.
> >
> > Maybe the compromise is to reach down into the IOV code and have it
> > register the sysfs interface at device creation time in something like
> > pci_iov_sysfs_link if the PF has the functionality present to support
> > it.
>
> IIUC there are two questions on the table:
>
>   1) Should the sysfs files be visible only when a PF driver that
>      supports MSI-X vector assignment is bound?
>
>      I think this is a cosmetic issue.  The presence of the file is
>      not a reliable signal to management software; it must always
>      tolerate files that don't exist (e.g., on old kernels) or files
>      that are visible but don't work (e.g., vectors may be exhausted).
>
>      If we start with the files always being visible, we should be
>      able to add smarts later to expose them only when the PF driver
>      is bound.
>
>      My concerns with pci_enable_vf_overlay() are that it uses a
>      little more sysfs internals than I'd like (although there are
>      many callers of sysfs_create_files()) and it uses
>      pci_get_domain_bus_and_slot(), which is generally a hack and
>      creates refcounting hassles.  Speaking of which, isn't v6 missing
>      a pci_dev_put() to match the pci_get_domain_bus_and_slot()?

I'm not so much worried about management software as the fact that
this is a vendor specific implementation detail that is shaping how
the kernel interfaces are meant to work. Other than the mlx5 I don't
know if there are any other vendors really onboard with this sort of
solution.

In addition it still feels rather hacky to be modifying read-only PCIe
configuration space on the fly via a backdoor provided by the PF. It
almost feels like this should be some sort of quirk rather than a
standard feature for an SR-IOV VF.

>   2) Should a VF sysfs file use the PF to implement this?
>
>      Can you elaborate on your idea here?  I guess
>      pci_iov_sysfs_link() makes a "virtfnX" link from the PF to the
>      VF, and you're thinking we could also make a "virtfnX_msix_count"
>      in the PF directory?  That's a really interesting idea.

I would honestly be more comfortable if the PF owned these files
instead of the VFs. One of the things I didn't like about this back
during the V1/2 days was the fact that it gave the impression that
MSI-X count was something that is meant to be edited. Since then I
think at least the naming was changed so that it implies that this is
only possible due to SR-IOV.

I also didn't like that it makes the VFs feel like they are port
representors rather than being actual PCIe devices. Having
functionality that only works when the VF driver is not loaded just
feels off. The VF sysfs directory feels like it is being used as a
subdirectory of the PF rather than being a device on its own.

> > Also we might want to double check that the PF cannot be unbound while
> > the VF is present. I know for a while there it was possible to remove
> > the PF driver while the VF was present. The Mellanox drivers may not
> > allow it but it might not hurt to look at taking a reference against
> > the PF driver if you are allocating the VF MSI-X configuration sysfs
> > file.
>
> Unbinding the PF driver will either remove the *_msix_count files or
> make them stop working.  Is that a problem?  I'm not sure we should
> add a magic link that prevents driver unbinding.  Seems like it would
> be hard for users to figure out why the driver can't be removed.

I checked it again, it will make the *_msix_count files stop working.
In order to guarantee it cannot happen in the middle of things though
we are sitting on the device locks for both the PF and the VF. I'm not
a fan of having to hold 2 locks while we perform a firmware operation
for one device, but I couldn't find anything where we would deadlock
so it should be fine.
