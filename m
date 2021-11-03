Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B5E443A38
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 01:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhKCAIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 20:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhKCAIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 20:08:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE31361051;
        Wed,  3 Nov 2021 00:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635897933;
        bh=Bnssn3LqCZ80eifiUOFqHIVqphIW0K5AHUtTlX1DdB8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dpI3xFG8Dk/g8Gn6usp2MiLlvsy5JQJ31haxWp19/7pYiYqZQaoAmKDPoSLlBWGhl
         6suhiqLHJyIbma78c3w/5C05k9vhQ0DCZuFUADnBvpC95c0lY159fbwQkngqHOY9jm
         QJyTn5JgaGzH+XRxG4AhKlHGyPaEFIIVrxJe5rJFXm7Bp/b5x5uUTyS860TRP2ro29
         UPhTeDNtIfgZbDAZxFjItkTv1QUZUxptzYKfZgC350vRWsmqCU7+2X3z/hAZnezSoX
         HdGiCIl714nckU+2JURQxBWG21/OVUeRBFp21oLgZfsuyqU9OIMbUCmfEn8UoJgitb
         cDKumOeSzoVgQ==
Date:   Tue, 2 Nov 2021 17:05:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     idosch@idosch.org, edwin.peer@broadcom.com, jiri@resnulli.us,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <20211102170530.49f8ab4e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <YYF//p5mDQ2/reOD@unreal>
References: <20211030231254.2477599-1-kuba@kernel.org>
        <YX5Efghyxu5g8kzY@unreal>
        <20211101073259.33406da3@kicinski-fedora-PC1C0HJN>
        <YYAzn+mtrGp/As74@unreal>
        <20211101141613.3373b7f4@kicinski-fedora-PC1C0HJN>
        <YYDyBxNzJSpKXosy@unreal>
        <20211102081412.6d4e2275@kicinski-fedora-PC1C0HJN>
        <YYF//p5mDQ2/reOD@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Nov 2021 20:14:22 +0200 Leon Romanovsky wrote:
> > > Thanks =20
> >=20
> > Not sure what you're thanking for. I still prefer two explicit APIs.
> > Allowing nesting is not really necessary here. Callers know whether
> > they hold the lock or not. =20
>=20
> I'm doubt about. It maybe easy to tell in reload flow, but it is much
> harder inside eswitch mode change (as an example).

Hm, interesting counter example, why is eswitch mode change harder?
=46rom devlink side they should be locked the same, and I take the
devlink lock on all driver callbacks (probe, remove, sriov).

> > > I need RW as a way to ensure "exclusive" access during _set_ operatio=
n.
> > > It is not an optimization, but simple way to understand if parallel
> > > access is possible at this specific point of time. =20
> >=20
> > How is this not an optimization to allow parallel "reads"? =20
>=20
> You need to stop everything when _set_ command is called. One way is to
> require for all netlink devlink calls to have lock, another solution is
> to use RW semaphore. This is why it is not optimization, but an implement=
ation.
> Parallel "reads" are nice bonus.

Sorry I still don't understand. Why is devlink instance lock not
enough? Are you saying parallel get is a hard requirement for the
rework?

> > > I don't know yet, because as you wrote before netdevsim is for
> > > prototyping and such ABBA deadlock doesn't exist in real devices.
> > >=20
> > > My current focus is real devices for now. =20
> >=20
> > I wrote it with nfp in mind as well. It has a delayed work which needs
> > to take the port lock. Sadly I don't have any nfps handy and I didn't
> > want to post an untested patch. =20
>=20
> Do you remember why was port configuration implemented with delayed work?

IIRC it was because of the FW API for link info, all ports would get
accessed at once so we used a work which would lock out devlink port
splitting and update state of all ports.

Link state has to be read under rtnl_lock, yet port splitting needs=20
to take rtnl_lock to register new netdevs so there was no prettier=20
way to solve this.

> > > I clearly remember this patch and the sentence "...in
> > > some devices' resume function(igb_resum,igc_resume) they calls rtnl_l=
ock()
> > > again". The word "... some ..." hints to me that maintainers have dif=
ferent
> > > opinion on how to use rtnl_lock.
> > >=20
> > > https://lore.kernel.org/netdev/20210809032809.1224002-1-acelan.kao@ca=
nonical.com/ =20
> >=20
> > Yes, using rtnl_lock for PM is certainly a bad idea, and I'm not sure
> > why Intel does it. There are 10s of drivers which take rtnl_lock
> > correctly and it greatly simplifies their lives. =20
>=20
> I would say that you are ignoring that most of such drivers don't add
> new functionality.

You lost me again. You don't disagree that ability to lock out higher
layers is useful for drivers but... ?

> Anyway, I got your point, please give me time to see what I can do.
>=20
> In case, we will adopt your model, will you convert all drivers?

Yes, sure. The way this RFC is done it should be possible to land=20
it without any driver changes and then go driver by driver. I find
that approach much more manageable.
