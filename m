Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FD026995D
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgINXAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgINW76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 18:59:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 027AE20738;
        Mon, 14 Sep 2020 22:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600124397;
        bh=emunIXKlo2e3QtGdQLYozlvEmC8zJhSPtxtEm8Zd9CY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CLqRijmeCx7TUDq8D/Kvfqr6PZPTWkXq+InHZ6uROvvy59U2mu+fDpo7rl2FTeQBW
         3kYjGfPzInFIM1uzPmBMZqss7yrdm/F0ee8Ln4I8aV69iU3BOaGcBtnC8Po8icMEC6
         1NjwCT2gQwlkOxcSKr993eVxjiYTOeI68A6DmMjo=
Date:   Mon, 14 Sep 2020 15:59:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200914155955.6104c0ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <99ce6f1f-a8e9-3242-a584-e06756d6c606@pensando.io>
References: <20200908224812.63434-1-snelson@pensando.io>
        <20200908224812.63434-3-snelson@pensando.io>
        <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
        <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
        <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
        <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <99ce6f1f-a8e9-3242-a584-e06756d6c606@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 15:02:18 -0700 Shannon Nelson wrote:
> On 9/10/20 10:56 AM, Jakub Kicinski wrote:
> > On Wed, 9 Sep 2020 18:34:57 -0700 Shannon Nelson wrote: =20
> >> On 9/9/20 12:22 PM, Jakub Kicinski wrote: =20
> >>> On Wed, 9 Sep 2020 10:58:19 -0700 Shannon Nelson wrote: =20
> >>>> I'm suggesting that this implementation using the existing devlink
> >>>> logging services should suffice until someone can design, implement,=
 and
> >>>> get accepted a different bit of plumbing.=C2=A0 Unfortunately, that'=
s not a
> >>>> job that I can get to right now. =20
> >>> This hack is too nasty to be accepted. =20
> >> Your comment earlier was
> >> =20
> >>   > I wonder if we can steal a page from systemd's book and display
> >>   > "time until timeout", or whatchamacallit, like systemd does when i=
t's
> >>   > waiting for processes to quit. All drivers have some timeout set o=
n the
> >>   > operation. If users knew the driver sets timeout to n minutes and =
they
> >>   > see the timer ticking up they'd be less likely to think the comman=
d has
> >>   > hanged.. =20
> >>
> >> I implemented the loop such that the timeout value was the 100%, and
> >> each time through the loop the elapsed time value is sent, so the user
> >> gets to see the % value increasing as the wait goes on, in the same way
> >> they see the download progress percentage ticking away. =20
> > Right but you said that in most cases the value never goes up to 25min,
> > so user will see the value increment from 0 to say 5% very slowly and
> > then jump to 100%.
> > =20
> >> This is how I approached the stated requirement of user seeing the
> >> "timer ticking up", using the existing machinery.=C2=A0 This seems to =
be
> >> how devlink_flash_update_status_notify() is expected to be used, so
> >> I'm a little surprised at the critique. =20
> > Sorry, I thought the systemd reference would be clear enough, see the
> > screenshot here:
> >
> > https://images.app.goo.gl/gz1Uwg6mcHEd3D2m7
> >
> > Systemd prints something link:
> >
> > bla bla bla (XXs / YYs)
> >
> > where XX is the timer ticking up, and YY is the timeout value.
> > =20
> >>> So to be clear your options are:
> >>>    - plumb the single extra netlink parameter through to devlink
> >>>    - wait for someone else to do that for you, before you get
> >>> firmware flashing accepted upstream.
> >>>    =20
> >> Since you seem to have something else in mind, a little more detail
> >> would be helpful.
> >>
> >> We currently see devlink updating a percentage, something like:
> >> Downloading:=C2=A0 56%
> >> using backspaces to overwrite the value as the updates are published.
> >>
> >> How do you envision the userland interpretation of the timeout
> >> ticking? Do you want to see something like:
> >> Installing - timeout seconds:=C2=A0 23
> >> as a countdown? =20
> > I was under the impression that the systemd format would be familiar
> > to users, hence:
> >
> > Downloading:=C2=A0 56% (Xm Ys / Zm Vz)
> >
> > The part in brackets only appearing after a few seconds without a
> > notification, otherwise the whole thing would get noisy.
> > =20
> >> So, maybe a flag parameter that can tell the UI to use the raw value
> >> and not massage it into a percentage?
> >>
> >> Do you see this new netlink parameter to be a boolean switch between
> >> the percentage and raw, or maybe a bitflag parameter that might end
> >> up with several bits of context information for userland to interpret?
> >>
> >> Are you thinking of a new flags parameter in
> >> devlink_flash_update_status_notify(), or a new function to service
> >> this?
> >>
> >> If a new parameter to devlink_flash_update_status_notify(), maybe it
> >> is time to make a struct for flash update data rather than adding
> >> more parameters to the function?
> >>
> >> Should we add yet another parameter to replace the '%' with some
> >> other label, so devlink could print something like
> >> Installing - timeout in:=C2=A0 23 secs
> >>
> >> Or could we use a 0 value for total to signify using a raw value and
> >> not need to plumb a new parameter?=C2=A0 Although this might not get a=
long
> >> well with older devlink utilities. =20
> > I was thinking of adding an extra timeout parameter to
> > devlink_flash_update_status_notify() - timeout length in seconds.
> > And an extra netlink attr for that.
> >
> > We could perhaps make:
> >
> > static inline void
> > devlink_flash_update_status_notify( const char *status_msg,
> > 				    unsigned long done, unsigned long total)
> > {
> > 	struct ..._args =3D {
> > 		.status_msg =3D status_msg,
> > 		.done =3D done,
> > 		.total =3D total,
> > 	}
> >
> > 	__devlink_flash_update_status_notify(devlink, &.._args);
> > }
> >
> > IOW drop the component parameter from the normal helper, cause almost
> > nobody uses that. The add a more full featured __ version, which would
> > take the arg struct, the struct would include the timeout value.
> >
> > If the timeout is lower than 15sec drivers will probably have little
> > value in reporting it, so simplified helper should be nice there to sav=
e LOC.
> >
> > The user space can do the counting up trivially using select(),
> > or a syscall timeout. The netlink notification would only carry timeout.
> > (LMK if this is problematic, I haven't looked at the user space part.) =
=20
>=20
> What if we simplify this idea to adding a timeout variant of the=20
> devlink_flash_update_begin_notify()?=C2=A0 Perhaps something like
>  =C2=A0=C2=A0=C2=A0 devlink_flash_update_begin_notify_timeout(struct devl=
ink *devlink,=20
> unsigned int timeout_seconds)

+const char *status_msg, I assume?

> This can pass up a timeout parameter at the beginning of the flash and=20
> the userland utility can do what it needs at that point to set up the UI=
=20
> display.
>=20
> I think using a struct internally to devlink.c/h might still have merit,=
=20
> but I'm not sure there's a need to mess with the rest of the API just yet.

Do you mean that this will set the timeout on the entire operation?=20
And then still trigger notifications with
devlink_flash_update_begin_notify()? I was considering that to avoid
the need to add a new param, but it doesn't match the need all that=20
well, most of time the timeout is on a portion of the operation (e.g.=20
a FW command), not the entire process.

If you mean that we can just provide a simpler helper to the drivers
and internally fill in @done and @total as 0 - that could be a good=20
option. I'd still prefer if there was one devlink_nl_flash_update_fill()=20
that gets a structure.
