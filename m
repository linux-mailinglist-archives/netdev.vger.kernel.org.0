Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2E31767AE
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 23:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgCBWtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 17:49:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbgCBWtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 17:49:32 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6742C208C3;
        Mon,  2 Mar 2020 22:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583189371;
        bh=wmG7nx2gKT1ej2x9EGIjzDwZjQRIEbOxHvYx2O8/GNc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g4vnX1NnfAqIGFss7C95ORBUJ2Gyj7CxJVVwMf+erdB285lm4aKcaRKyb62bR7aLX
         6IoEAS56a6QAmjug8KZ9S6mpZlbPwtfsccMjWh1lD+3RJ/5vFYS+tHN1Y9MVp/Gw3t
         KQiBv8nuM/DQBhqnZeOS/DKMTTk6yBsT2MHHVTNI=
Date:   Mon, 2 Mar 2020 14:49:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Edward Cree <ecree@solarflare.com>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mlxsw@mellanox.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [patch net-next v2 01/12] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200302144928.0aca19a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200302214659.v4zm2whrv4qjz3pe@salvia>
References: <20200228172505.14386-1-jiri@resnulli.us>
        <20200228172505.14386-2-jiri@resnulli.us>
        <20200229192947.oaclokcpn4fjbhzr@salvia>
        <20200301084443.GQ26061@nanopsycho>
        <20200302132016.trhysqfkojgx2snt@salvia>
        <1da092c0-3018-7107-78d3-4496098825a3@solarflare.com>
        <20200302192437.wtge3ze775thigzp@salvia>
        <20200302121852.50a4fccc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200302214659.v4zm2whrv4qjz3pe@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Mar 2020 22:46:59 +0100 Pablo Neira Ayuso wrote:
> On Mon, Mar 02, 2020 at 12:18:52PM -0800, Jakub Kicinski wrote:
> > On Mon, 2 Mar 2020 20:24:37 +0100 Pablo Neira Ayuso wrote: =20
> > > On Mon, Mar 02, 2020 at 04:29:32PM +0000, Edward Cree wrote: =20
> > > > On 02/03/2020 13:20, Pablo Neira Ayuso wrote:   =20
> > > > > 2) explicit counter action, in this case the user specifies expli=
citly
> > > > >    that it needs a counter in a given position of the rule. This
> > > > >    counter might come before or after the actual action.   =20
> > > >
> > > > But the existing API can already do this, with a gact pipe.=C2=A0 P=
lus, Jiri's
> > > > =C2=A0new API will allow specifying a counter on any action (rather=
 than only,
> > > > =C2=A0implicitly, those which have .stats_update()) should that pro=
ve to be
> > > > =C2=A0necessary.
> > > >=20
> > > > I really think the 'explicit counter action' is a solution in searc=
h of a
> > > > =C2=A0problem, let's not add random orthogonality violations.=C2=A0=
 (Equally if the
> > > > =C2=A0counter action had been there first, I'd be against adding co=
unters to
> > > > =C2=A0the other actions.)   =20
> > >=20
> > > It looks to me that you want to restrict the API to tc for no good
> > > _technical_ reason. =20
> >=20
> > Undeniably part of the reason is that given how complex flow offloads
> > got there may be some resistance to large re-factoring. IMHO well
> > thought out refactoring of stats is needed.. but I'm not convinced=20
> > this is the direction.
> >
> > Could you give us clearer understanding of what the use cases for the
> > counter action is?
> >=20
> > AFAIK right now actions do the accounting on input. That seems like the
> > only logical option. Either action takes the packet out of the action
> > pipeline, in which case even the counter action after will not see it,
> > or it doesn't and the input counter of the next action can be used.
> >
> > Given counters must be next to real actions and not other counter
> > to have value, having them as a separate action seems to make no
> > difference at all (if users are silly, we can use the pipe/no-op). =20
>=20
> This model that is proposed here is correct in the tc world, where
> counters are tied to actions (as you describe above). However, the
> flow_offload API already supports for ethtool and netfilter these
> days.
>=20
> In Netfilter, counters are detached from actions. Obviously, a counter
> must be placed before the action _if_ the action gets the packet out
> of the pipeline, e.g.
>=20
>      ip saddr 1.1.1.1 counter drop
>=20
> In this case, the counter is placed before the 'drop' action. Users
> that need no counters have to remove 'counter' from the rule syntax to
> opt-out.

In Jiri's set if counter exists DROP should get the ANY flag, if
counter is not there - DISABLED.

> > IOW modeling the stats as attribute of other actions or a separate
> > action is entirely equivalent, and there's nothing to be gained from
> > moving from the existing scheme to explicit actions... other than it'd
> > make it look more like nft actions... :) =20
>=20
> I just wonder if a model that allows tc and netfilter to use this new
> statistics infrastructure would make everyone happy. My understanding
> is that it is not far away from what this patchset provides.
>=20
> The retorical question here probably is if you still want to allow the
> Netfilter front-end to benefit from this new flow_action API
> extension.
>=20
> The real question is: if you think this tc counter+action scheme can
> be used by netfilter, then please explain how.

In Jiri's latest patch set the counter type is per action, so just
"merge right" the counter info into the next action and the models=20
are converted.

If user is silly and has multiple counter actions in a row - the
pipe/no-op action comes into play (that isn't part of this set,=20
as Jiri said).

Can you give us examples of what wouldn't work? Can you for instance
share the counter across rules?

Also neither proposal addresses the problem of reporting _different_
counter values at different stages in the pipeline, i.e. moving from
stats per flow to per action. But nobody seems to be willing to work=20
on that.

AFAICT with Jiri's change we only need one check in the drivers to
convert from old scheme to new, with explicit action we need two
(additional one being ignoring the counter action). Not a big deal,
but 1 is less than 2 =F0=9F=A4=B7=E2=80=8D=E2=99=82=EF=B8=8F
