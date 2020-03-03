Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25FC3178330
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbgCCTfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:35:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729264AbgCCTfB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 14:35:01 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 373EC2072D;
        Tue,  3 Mar 2020 19:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583264100;
        bh=9Wq1ftIhcbDDIUo1rCbPWUX5kEQ939O6Nl73ti84OCY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UuLJLn+LJM90tiKSEU/3D+xdXJqsEXpsNgQrTup3WcWh5vUzdEebmIbwc3R0YZxG+
         mvyJ4RuHkxtL5N7IlW0ikICuXd5WIC9DggZLbBB01wyTUbfcl0Jbi2FYVA00wQbt00
         6m6yJYOebpJP5BysA5VXVZTdcdXPh2D+rD09OgyY=
Date:   Tue, 3 Mar 2020 11:34:57 -0800
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
Message-ID: <20200303113457.0a622b7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200303172525.2p6jwa6u7qx5onji@salvia>
References: <20200228172505.14386-1-jiri@resnulli.us>
        <20200228172505.14386-2-jiri@resnulli.us>
        <20200229192947.oaclokcpn4fjbhzr@salvia>
        <20200301084443.GQ26061@nanopsycho>
        <20200302132016.trhysqfkojgx2snt@salvia>
        <1da092c0-3018-7107-78d3-4496098825a3@solarflare.com>
        <20200302192437.wtge3ze775thigzp@salvia>
        <20200302121852.50a4fccc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200302214659.v4zm2whrv4qjz3pe@salvia>
        <20200302144928.0aca19a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200303172525.2p6jwa6u7qx5onji@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Mar 2020 18:25:25 +0100 Pablo Neira Ayuso wrote:
> On Mon, Mar 02, 2020 at 02:49:28PM -0800, Jakub Kicinski wrote:
> > On Mon, 2 Mar 2020 22:46:59 +0100 Pablo Neira Ayuso wrote: =20
> [...]
> > > The real question is: if you think this tc counter+action scheme can
> > > be used by netfilter, then please explain how. =20
> >=20
> > In Jiri's latest patch set the counter type is per action, so just
> > "merge right" the counter info into the next action and the models=20
> > are converted. =20
>=20
> The input "merge right" approach might work.
>=20
> > If user is silly and has multiple counter actions in a row - the
> > pipe/no-op action comes into play (that isn't part of this set,=20
> > as Jiri said). =20
>=20
> Probably gact pipe action with counters can be mapped to the counter
> action that netfilter needs. Is this a valid use-case you consider for
> the tc hardware offload?

Once actions can be shared I think it'd be a pretty useful thing for tc
hardware offloads in case HW has limited counters.

> > Can you give us examples of what wouldn't work? Can you for instance
> > share the counter across rules? =20
>=20
> Yes, there might be counters that are shared accross rules, see
> nfacct. Two different rules might refer to the same counter, IIRC
> there is a way to do this in tc too.

Yup, not implemented for offload, tho.

> > Also neither proposal addresses the problem of reporting _different_
> > counter values at different stages in the pipeline, i.e. moving from
> > stats per flow to per action. But nobody seems to be willing to work=20
> > on that. =20
>=20
> You mean, in case that different counter types are specified, eg. one
> action using delayed and another action using immediate?

I meant the work Ed just pointed to, and what you ask about below.

> > AFAICT with Jiri's change we only need one check in the drivers to
> > convert from old scheme to new, with explicit action we need two
> > (additional one being ignoring the counter action). Not a big deal,
> > but 1 is less than 2 =F0=9F=A4=B7=E2=80=8D=E2=99=82=EF=B8=8F =20
>=20
> What changes are expected to retrieve counter stats?
>=20
> Will per-flow stats remain in place after this place?

In theory it doesn't have to, because action stats are more flexible.

In practice I doubt anyone will take on the conversion, so we'll have
to live with two ways for a while..
