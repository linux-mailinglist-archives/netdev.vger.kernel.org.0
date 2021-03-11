Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B449337E49
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 20:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhCKThy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 14:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhCKThk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 14:37:40 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F67C061574;
        Thu, 11 Mar 2021 11:37:40 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id p10so384562ils.9;
        Thu, 11 Mar 2021 11:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KnI3t+zFMzAxJN4g99Gh2+F3sR8m4ihGBhz5SxC6MLU=;
        b=YYLvRkIrQfDpM9d1w+uEl4WbQQ2FD2mfu8XFFFrtDv68cnKWrDeVRjw2ovTD95Xqoy
         FzJPGIjXEA1WBMZ9Rx1XViQgx9mVCQbhfXh0NlYY1fV24Qq9i1AHocXkeBJW4YefnKa2
         A/JyqeyuSWTJ7/C6N+sUaFV9VxI6TLLjRH5/xaiAu1YLPdE2qhSlIC32i0Wqs2pO7eqZ
         GpSYPZrKZS6ZXnmvEzbTM3m4KNjmmbYPWjTKl4Lmkc4RrmgIE9hoNS5a9N15zDhuLiWS
         Enx1YAZTk8QM+bUTx1vPEpzNdO8PBc9LEsXkNfaal+PX9mE/dK5mGxRhls7yj426zuBC
         Kqmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KnI3t+zFMzAxJN4g99Gh2+F3sR8m4ihGBhz5SxC6MLU=;
        b=Q2YqM/NO0uv1Fl02BqIBeNJh2OwqKu+hrUcgxVzSYDqNumkSlbw61eIL8ABU+C63Pw
         0+db79h5sS1ihJ3QIhWG4CT3IVuNkcMrjW8oI8f+IfJ7Q4PX7DLQZoADWPCN7fBMUKuq
         14G3dzJS3U0Pjp26BBtKkBn7J/wLOl+jGf69gS4SqU4fKpz/wneg3dUm/i1BrhbyHM3i
         eKj1vnvGHyTQTyLbLWtZ4ea+3aLmHqDA6quCnbx2ZlZJ01hjbnrh+p+yCerb772u1Iok
         bzSH3SX5MNniXh6tAblZpbaSmN6cuEtbNI4AjuFmDfyngAKaWp5D60nSALzkUpyCuH7P
         dfFA==
X-Gm-Message-State: AOAM530A04SQutvSw4x8l1xtM4YrO3816GSDFvcleEtLsnJsckIOuV/Z
        WIGLA1ShBhHoe48+VC3xfEgmhq/WmjxhSJ/CWlo=
X-Google-Smtp-Source: ABdhPJwGo6ij+r1OFRXkiJYr/z9THe06G33SZmTgDWp9V1694gJAei99BK2J/JIzS570aGy0z5jIPTLBqFhaZRb1G5A=
X-Received: by 2002:a92:d18c:: with SMTP id z12mr21661ilz.95.1615491459820;
 Thu, 11 Mar 2021 11:37:39 -0800 (PST)
MIME-Version: 1.0
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
In-Reply-To: <20210311181729.GA2148230@bjorn-Precision-5520>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 11 Mar 2021 11:37:28 -0800
Message-ID: <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
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

On Thu, Mar 11, 2021 at 10:17 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Wed, Mar 10, 2021 at 03:34:01PM -0800, Alexander Duyck wrote:
> > On Wed, Mar 10, 2021 at 11:09 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > On Sun, Mar 07, 2021 at 10:55:24AM -0800, Alexander Duyck wrote:
> > > > On Sun, Feb 28, 2021 at 11:55 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > >
> > > > > @Alexander Duyck, please update me if I can add your ROB tag again
> > > > > to the series, because you liked v6 more.
> > > > >
> > > > > Thanks
> > > > >
> > > > > ---------------------------------------------------------------------------------
> > > > > Changelog
> > > > > v7:
> > > > >  * Rebase on top v5.12-rc1
> > > > >  * More english fixes
> > > > >  * Returned to static sysfs creation model as was implemented in v0/v1.
> > > >
> > > > Yeah, so I am not a fan of the series. The problem is there is only
> > > > one driver that supports this, all VFs are going to expose this sysfs,
> > > > and I don't know how likely it is that any others are going to
> > > > implement this functionality. I feel like you threw out all the
> > > > progress from v2-v6.
> > >
> > > pci_enable_vfs_overlay() turned up in v4, so I think v0-v3 had static
> > > sysfs files regardless of whether the PF driver was bound.
> > >
> > > > I really feel like the big issue is that this model is broken as you
> > > > have the VFs exposing sysfs interfaces that make use of the PFs to
> > > > actually implement. Greg's complaint was the PF pushing sysfs onto the
> > > > VFs. My complaint is VFs sysfs files operating on the PF. The trick is
> > > > to find a way to address both issues.
> > > >
> > > > Maybe the compromise is to reach down into the IOV code and have it
> > > > register the sysfs interface at device creation time in something like
> > > > pci_iov_sysfs_link if the PF has the functionality present to support
> > > > it.
> > >
> > > IIUC there are two questions on the table:
> > >
> > >   1) Should the sysfs files be visible only when a PF driver that
> > >      supports MSI-X vector assignment is bound?
> > >
> > >      I think this is a cosmetic issue.  The presence of the file is
> > >      not a reliable signal to management software; it must always
> > >      tolerate files that don't exist (e.g., on old kernels) or files
> > >      that are visible but don't work (e.g., vectors may be exhausted).
> > >
> > >      If we start with the files always being visible, we should be
> > >      able to add smarts later to expose them only when the PF driver
> > >      is bound.
> > >
> > >      My concerns with pci_enable_vf_overlay() are that it uses a
> > >      little more sysfs internals than I'd like (although there are
> > >      many callers of sysfs_create_files()) and it uses
> > >      pci_get_domain_bus_and_slot(), which is generally a hack and
> > >      creates refcounting hassles.  Speaking of which, isn't v6 missing
> > >      a pci_dev_put() to match the pci_get_domain_bus_and_slot()?
> >
> > I'm not so much worried about management software as the fact that
> > this is a vendor specific implementation detail that is shaping how
> > the kernel interfaces are meant to work. Other than the mlx5 I don't
> > know if there are any other vendors really onboard with this sort of
> > solution.
>
> I know this is currently vendor-specific, but I thought the value
> proposition of dynamic configuration of VFs for different clients
> sounded compelling enough that other vendors would do something
> similar.  But I'm not an SR-IOV guy and have no vendor insight, so
> maybe that's not the case?

The problem is there are multiple ways to deal with this issue. I have
worked on parts in the past that simply advertised a fixed table size
and then only allowed for configuring the number of vectors internally
so some vectors simply couldn't be unmasked. I don't know if that was
any better than this though. It is just yet another way to do this.

> > In addition it still feels rather hacky to be modifying read-only PCIe
> > configuration space on the fly via a backdoor provided by the PF. It
> > almost feels like this should be some sort of quirk rather than a
> > standard feature for an SR-IOV VF.
>
> I agree, I'm not 100% comfortable with modifying the read-only Table
> Size register.  Maybe there's another approach that would be better?
> It *is* nice that the current approach doesn't require changes in the
> VF driver.

Changes in the VF driver would be a non-starter since the VF driver
may be running in the guest. One thing that would have been nice is if
the hardware cthis change could have been delayed until the VF went
through something like an FLR where it would have had to unregister
all the MSI-X vectors and then reconfigure them after the reset. It
would have allowed us to get away from needing all the extra locking.
It would then just be something the PF would configure and apply to
the VF following a reset.

> > >   2) Should a VF sysfs file use the PF to implement this?
> > >
> > >      Can you elaborate on your idea here?  I guess
> > >      pci_iov_sysfs_link() makes a "virtfnX" link from the PF to the
> > >      VF, and you're thinking we could also make a "virtfnX_msix_count"
> > >      in the PF directory?  That's a really interesting idea.
> >
> > I would honestly be more comfortable if the PF owned these files
> > instead of the VFs. One of the things I didn't like about this back
> > during the V1/2 days was the fact that it gave the impression that
> > MSI-X count was something that is meant to be edited. Since then I
> > think at least the naming was changed so that it implies that this is
> > only possible due to SR-IOV.
> >
> > I also didn't like that it makes the VFs feel like they are port
> > representors rather than being actual PCIe devices. Having
> > functionality that only works when the VF driver is not loaded just
> > feels off. The VF sysfs directory feels like it is being used as a
> > subdirectory of the PF rather than being a device on its own.
>
> Moving "virtfnX_msix_count" to the PF seems like it would mitigate
> this somewhat.  I don't know how to make this work while a VF driver
> is bound without making the VF feel even less like a PCIe device,
> i.e., we won't be able to use the standard MSI-X model.

Yeah, I actually do kind of like that idea. In addition it would
address one of the things I pointed out as an issue before as you
could place the virtfn values that the total value in the same folder
so that it is all in one central spot rather than having to walk all
over the sysfs hierarchy to check the setting for each VF when trying
to figure out how the vectors are currently distributed.

> > > > Also we might want to double check that the PF cannot be unbound while
> > > > the VF is present. I know for a while there it was possible to remove
> > > > the PF driver while the VF was present. The Mellanox drivers may not
> > > > allow it but it might not hurt to look at taking a reference against
> > > > the PF driver if you are allocating the VF MSI-X configuration sysfs
> > > > file.
> > >
> > > Unbinding the PF driver will either remove the *_msix_count files or
> > > make them stop working.  Is that a problem?  I'm not sure we should
> > > add a magic link that prevents driver unbinding.  Seems like it would
> > > be hard for users to figure out why the driver can't be removed.
> >
> > I checked it again, it will make the *_msix_count files stop working.
> > In order to guarantee it cannot happen in the middle of things though
> > we are sitting on the device locks for both the PF and the VF. I'm not
> > a fan of having to hold 2 locks while we perform a firmware operation
> > for one device, but I couldn't find anything where we would deadlock
> > so it should be fine.
>
> I agree again, it's not ideal to hold two locks.  Is it possible we
> could get by without the VF lock?  If we simply check whether a VF
> driver is bound (without a lock), a VF driver bind can race with the
> PF sriov_set_msix_vec_count().

I wonder if we couldn't do something like a reversible version of the
kill_device function to make it so that a VF is marked as being
blocked from being probed until we come through and release it.

> If the VF driver bind wins, it reads the old Table Size.  If it reads
> a too-small size, it won't use all the vectors.  If it reads a
> too-large size, it will try to use too many vectors and some won't
> work.  But the race would be caused by a bug in the management
> software, and the consequence doesn't seem *terrible*.

Based on the idea I just mentioned above it might make sense to
possibly have an option to mark a device as "stale" instead of "dead",
or maybe we add an extra bit that can flag that it is only "mostly
dead" and we are expecting a recovery soon.

Then the flow for this could be changed where we take the VF lock and
mark it as "stale" to prevent any driver binding and then we can
release the VF lock. Next we would perform the PF operation telling it
to update the VF.  Then we spin on the VF waiting for the stale data
to be updated and once that happens we can pop the indication that the
device is "stale" freeing it for use. If something comes along that
decides it wants to kill it then it just clears the "stale" bit or
"mostly dead" flag indicating that in fact this is "dead" and needs to
be unloaded resulting in the loop being broken.

I feel like that might be a much better fit for the SR-IOV model as it
would be the PF directly disabling, modifying, and then restoring a VF
rather than requesting things from the VF itself.

Thoughts?
