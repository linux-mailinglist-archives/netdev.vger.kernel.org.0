Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD1142DFCB
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbhJNRBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 13:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhJNRBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 13:01:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40CB060F6F;
        Thu, 14 Oct 2021 16:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634230786;
        bh=ePmktYSbM4vrbKVFnxw0eSDaj2BMTsH0eZf//RlZJ14=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JtBvhNlFhFSRYGJV2o9zR6vztkRKQqYo2vkDTdCt0kL3I89fN3O7M+cbRpqib4Imi
         0+GqHy343/XcKRqG5UXafgaxPrXoEpL6Fl4vgcUehrLkaO+0kDe86TfU1tGyRhbzq1
         mEoj+4Y0Cieryu/gZEhPXxmyejVP0wvRSg0tKIbcZFHSbPsLU3utIryMI51E26HpJ5
         Bl1nkxwRNDb6dIUmyoeVtLnjYu4Mr3u31zVUmWdm2joJ2uW+e4vyy6cTp10dbk1Oku
         KFFQqkET0xeqO1fgz1cdnL58/mLPH7e/xS1WHYmuA9vpYt3GoK4xjXv7I/IBMB+ef8
         nz3EtYrrZR11A==
Date:   Thu, 14 Oct 2021 09:59:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     James Prestwood <prestwoj@gmail.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/4] net: arp: introduce arp_evict_nocarrier sysctl
 parameter
Message-ID: <20211014095945.0767b4ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <10e8c5b435c3d19d062581b31e34de8e8511f75d.camel@gmail.com>
References: <20211013222710.4162634-1-prestwoj@gmail.com>
        <20211013163714.63abdd44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <10e8c5b435c3d19d062581b31e34de8e8511f75d.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 09:29:05 -0700 James Prestwood wrote:
> > > diff --git a/include/linux/inetdevice.h
> > > b/include/linux/inetdevice.h
> > > index 53aa0343bf69..63180170fdbd 100644
> > > --- a/include/linux/inetdevice.h
> > > +++ b/include/linux/inetdevice.h
> > > @@ -133,6 +133,7 @@ static inline void ipv4_devconf_setall(struct
> > > in_device *in_dev)
> > > =C2=A0#define IN_DEV_ARP_ANNOUNCE(in_dev)=C2=A0=C2=A0=C2=A0=C2=A0IN_D=
EV_MAXCONF((in_dev),
> > > ARP_ANNOUNCE)
> > > =C2=A0#define IN_DEV_ARP_IGNORE(in_dev)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0IN_DEV_MAXCONF((in_dev),
> > > ARP_IGNORE)
> > > =C2=A0#define IN_DEV_ARP_NOTIFY(in_dev)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0IN_DEV_MAXCONF((in_dev),
> > > ARP_NOTIFY)
> > > +#define IN_DEV_ARP_EVICT_NOCARRIER(in_dev)
> > > IN_DEV_CONF_GET((in_dev), ARP_EVICT_NOCARRIER) =20
> >=20
> > IN_DEV_ANDCONF() makes most sense, I'd think. =20
>=20
> So given we want '1' as the default as well as the ability to toggle
> this option per-netdev I thought this was more appropriate. One caviat
> is this would not work for setting ALL netdev's, but I don't think this
> is a valid use case; or at least I can't imagine why you'd want to ever
> do this.
>=20
> This is a whole new area to me though, so if I'm understanding these
> macros wrong please educate me :)

Yeah, TBH I'm not sure what the best practice is here. I know we
weren't very consistent in the past. Having a knob for "all" which=20
is 100% ignored seems like the worst option. Let me CC Dave Ahern,
please make sure you CC him on v2 as well.

