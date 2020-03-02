Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 914E51764CC
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 21:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgCBUS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 15:18:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgCBUSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 15:18:55 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C6A7214DB;
        Mon,  2 Mar 2020 20:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583180334;
        bh=USVMp9N3wGY67WGeSZvztHCNHfpshzncK2NRw4+hyeI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u699LD0MpaUcLbVgrcbM4rYQCOUgCe1NChLsh1k+K0TGR2gbFcglo4t36XUEbXHjh
         5KTNSJNpVGAeNi1wG/jlAjUhFPao5AkSv2/IFnL1LUH88lFSb64MTrDAfFAKDVOXWx
         xstSav0WKVfjZsVhbi1UtFbfircMZk7tKNcwOWUY=
Date:   Mon, 2 Mar 2020 12:18:52 -0800
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
Message-ID: <20200302121852.50a4fccc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200302192437.wtge3ze775thigzp@salvia>
References: <20200228172505.14386-1-jiri@resnulli.us>
        <20200228172505.14386-2-jiri@resnulli.us>
        <20200229192947.oaclokcpn4fjbhzr@salvia>
        <20200301084443.GQ26061@nanopsycho>
        <20200302132016.trhysqfkojgx2snt@salvia>
        <1da092c0-3018-7107-78d3-4496098825a3@solarflare.com>
        <20200302192437.wtge3ze775thigzp@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Mar 2020 20:24:37 +0100 Pablo Neira Ayuso wrote:
> On Mon, Mar 02, 2020 at 04:29:32PM +0000, Edward Cree wrote:
> > On 02/03/2020 13:20, Pablo Neira Ayuso wrote: =20
> > > 2) explicit counter action, in this case the user specifies explicitly
> > >    that it needs a counter in a given position of the rule. This
> > >    counter might come before or after the actual action. =20
> >
> > But the existing API can already do this, with a gact pipe.=C2=A0 Plus,=
 Jiri's
> > =C2=A0new API will allow specifying a counter on any action (rather tha=
n only,
> > =C2=A0implicitly, those which have .stats_update()) should that prove t=
o be
> > =C2=A0necessary.
> >=20
> > I really think the 'explicit counter action' is a solution in search of=
 a
> > =C2=A0problem, let's not add random orthogonality violations.=C2=A0 (Eq=
ually if the
> > =C2=A0counter action had been there first, I'd be against adding counte=
rs to
> > =C2=A0the other actions.) =20
>=20
> It looks to me that you want to restrict the API to tc for no good
> _technical_ reason.

Undeniably part of the reason is that given how complex flow offloads
got there may be some resistance to large re-factoring. IMHO well
thought out refactoring of stats is needed.. but I'm not convinced=20
this is the direction.

Could you give us clearer understanding of what the use cases for the
counter action is?

AFAIK right now actions do the accounting on input. That seems like the
only logical option. Either action takes the packet out of the action
pipeline, in which case even the counter action after will not see it,
or it doesn't and the input counter of the next action can be used.

Given counters must be next to real actions and not other counter
to have value, having them as a separate action seems to make no
difference at all (if users are silly, we can use the pipe/no-op).

IOW modeling the stats as attribute of other actions or a separate
action is entirely equivalent, and there's nothing to be gained from
moving from the existing scheme to explicit actions... other than it'd
make it look more like nft actions... :)
