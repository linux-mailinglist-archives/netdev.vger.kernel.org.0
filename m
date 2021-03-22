Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB43343A65
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 08:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCVHNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 03:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229990AbhCVHN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 03:13:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E91661924;
        Mon, 22 Mar 2021 07:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616397208;
        bh=LFgbb7l9KEu7Z6OAYZRvyu6Do2gcidBM2ddbIvOEWrA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zd3+s2OeoaOuzP1Xenkromp3abbFxeEdHfs6d7rqu0IVAMmK+ykrB9MRNcHuNJ2MR
         vkHlkZWY0FilJxuZCdG3GGRLDZ0PC3Rm+xM0y6bHgYqcXg0Cx3xrrmH0Evgrp2IyS6
         kg/W95bfTCSERGyq9naq2YYwqdRZ3DqD61CQhEEIFhYnhFyCpsCQSu3C6GYLl0GDBs
         wWBLVXJRpdJxeLsnFjmV8FqIX36ZAQMmks+JUrdpDmpF8mUGUplaM/IG3LFtnl9iP1
         CCvwIktMW6m1AarZ3tfDhyPeeDVzpRDmGI4Alvab1O8ZxhUxfrgAHtLlHpvnJrZInP
         LSHX4pxgZd4RA==
Date:   Mon, 22 Mar 2021 09:13:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc:     "Hsu, Chiahao" <andyhsu@amazon.com>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, wei.liu@kernel.org, paul@xen.org,
        davem@davemloft.net, kuba@kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable
 ctrl-ring
Message-ID: <YFhDlLkXLSs30/Ci@unreal>
References: <YE3foiFJ4sfiFex2@unreal>
 <64f5c7a8-cc09-3a7f-b33b-a64d373aed60@amazon.com>
 <YFI676dumSDJvTlV@unreal>
 <f3b76d9b-7c82-d3bd-7858-9e831198e33c@amazon.com>
 <YFeAzfJsHAqPvPuY@unreal>
 <12f643b5-7a35-d960-9b1f-22853aea4b4c@amazon.com>
 <YFgtf6NBPMjD/U89@unreal>
 <c7b2a12d-bf81-3d5f-40ae-f70e6cfa1637@suse.com>
 <YFg9w980NkZzEHmb@unreal>
 <facd5d2e-510e-4fc4-5e22-c934ea237b1b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <facd5d2e-510e-4fc4-5e22-c934ea237b1b@suse.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 08:01:17AM +0100, J=FCrgen Gro=DF wrote:
> On 22.03.21 07:48, Leon Romanovsky wrote:
> > On Mon, Mar 22, 2021 at 06:58:34AM +0100, J=FCrgen Gro=DF wrote:
> > > On 22.03.21 06:39, Leon Romanovsky wrote:
> > > > On Sun, Mar 21, 2021 at 06:54:52PM +0100, Hsu, Chiahao wrote:
> > > > >=20
> > > >=20
> > > > <...>
> > > >=20
> > > > > > > Typically there should be one VM running netback on each host,
> > > > > > > and having control over what interfaces or features it expose=
s is also
> > > > > > > important for stability.
> > > > > > > How about we create a 'feature flags' modparam, each bits is =
specified for
> > > > > > > different new features?
> > > > > > At the end, it will be more granular module parameter that user=
 still
> > > > > > will need to guess.
> > > > > I believe users always need to know any parameter or any tool's f=
lag before
> > > > > they use it.
> > > > > For example, before user try to set/clear this ctrl_ring_enabled,=
 they
> > > > > should already have basic knowledge about this feature,
> > > > > or else they shouldn't use it (the default value is same as befor=
e), and
> > > > > that's also why we use the 'ctrl_ring_enabled' as parameter name.
> > > >=20
> > > > It solves only forward migration flow. Move from machine A with no
> > > > option X to machine B with option X. It doesn't work for backward
> > > > flow. Move from machine B to A back will probably break.
> > > >=20
> > > > In your flow, you want that users will set all module parameters for
> > > > every upgrade and keep those parameters differently per-version.
> > >=20
> > > I think the flag should be a per guest config item. Adding this item =
to
> > > the backend Xenstore nodes for netback to consume it should be rather
> > > easy.
> > >=20
> > > Yes, this would need a change in Xen tools, too, but it is the most
> > > flexible way to handle it. And in case of migration the information
> > > would be just migrated to the new host with the guest's config data.
> >=20
> > Yes, it will overcome global nature of module parameters, but how does
> > it solve backward compatibility concern?
>=20
> When creating a guest on A the (unknown) feature will not be set to
> any value in the guest's config data. A migration stream not having any
> value for that feature on B should set it to "false".
>=20
> When creating a guest on B it will either have the feature value set
> explicitly in the guest config (either true or false), or it will get
> the server's default (this value should be configurable in a global
> config file, default for that global value would be "true").
>=20
> So with the guest created on B with feature specified as "false" (either
> for this guest only, or per global config), it will be migratable to
> machine A without problem. Migrating it back to B would work the same
> way as above. Trying to migrate a guest with feature set to "true" to
> B would not work, but this would be the host admin's fault due to not
> configuring the guest correctly.

As long as all new features are disabled by default, it will be ok.

Thanks

>=20
>=20
> Juergen





