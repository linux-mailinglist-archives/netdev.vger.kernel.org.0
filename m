Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91821C612E
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgEETnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:43:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgEETnq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 15:43:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 109AE2068E;
        Tue,  5 May 2020 19:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588707825;
        bh=p6nGBFRXHyOqPYnjb79xLxVEAWtsgYAGx+HBrydfzBM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0Kq0Kae9JEnVPXB5vHCCOqZPWtqdnaWFWr8u3U4WyVR+rZQSsRrSbQsnpfdeHvLf0
         0M0o2i1APep2rLStW0UoPnhTOP936L62b4R1cLWw6yo4vSnsCfVNuSkzzA5SLfOgFu
         b7vPgfMG3R8XCEtFoPD8MY0GAL9DCL9nWzMyLiNU=
Date:   Tue, 5 May 2020 12:43:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us, ecree@solarflare.com
Subject: Re: [PATCH net,v2] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200505124343.27897ad6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200505193145.GA9789@salvia>
References: <20200505174736.29414-1-pablo@netfilter.org>
        <20200505114010.132abebd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200505193145.GA9789@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 21:31:45 +0200 Pablo Neira Ayuso wrote:
> On Tue, May 05, 2020 at 11:40:10AM -0700, Jakub Kicinski wrote:
> > On Tue,  5 May 2020 19:47:36 +0200 Pablo Neira Ayuso wrote: =20
> > > This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
> > > that the frontend does not need counters, this hw stats type request
> > > never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly reques=
ts
> > > the driver to disable the stats, however, if the driver cannot disable
> > > counters, it bails out.
> > >=20
> > > TCA_ACT_HW_STATS_* maintains the 1:1 mapping with FLOW_ACTION_HW_STAT=
S_*
> > > except by disabled which is mapped to FLOW_ACTION_HW_STATS_DISABLED
> > > (this is 0 in tc). Add tc_act_hw_stats() to perform the mapping betwe=
en
> > > TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*.
> > >=20
> > > Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats t=
ype")
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > > v2: define FLOW_ACTION_HW_STATS_DISABLED at the end of the enumeration
> > >     as Jiri suggested. Keep the 1:1 mapping between TCA_ACT_HW_STATS_*
> > >     and FLOW_ACTION_HW_STATS_* except by the disabled case.
> > >=20
> > >  include/net/flow_offload.h |  9 ++++++++-
> > >  net/sched/cls_api.c        | 14 ++++++++++++--
> > >  2 files changed, 20 insertions(+), 3 deletions(-)
> > >=20
> > > diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> > > index 3619c6acf60f..efc8350b42fb 100644
> > > --- a/include/net/flow_offload.h
> > > +++ b/include/net/flow_offload.h
> > > @@ -166,15 +166,18 @@ enum flow_action_mangle_base {
> > >  enum flow_action_hw_stats_bit {
> > >  	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
> > >  	FLOW_ACTION_HW_STATS_DELAYED_BIT,
> > > +	FLOW_ACTION_HW_STATS_DISABLED_BIT,
> > >  };
> > > =20
> > >  enum flow_action_hw_stats {
> > > -	FLOW_ACTION_HW_STATS_DISABLED =3D 0,
> > > +	FLOW_ACTION_HW_STATS_DONT_CARE =3D 0, =20
> >=20
> > Why not ~0? Or ANY | DISABLED?=20
> > Otherwise you may confuse drivers which check bit by bit. =20
>=20
> I'm confused, you agreed with this behaviour:

I was expecting the 0 to be exposed at UAPI level, and then kernel
would translate that to a full mask internally.

=46rom the other reply:

> I can send a v3 to handle the _DONT_CARE type from the mlxsw.

Seems a little unnecessary for all drivers to cater to the special
case, when we made the argument be a bitfield specifically so that=20
the drivers can function as long as they match on any of the bits.
