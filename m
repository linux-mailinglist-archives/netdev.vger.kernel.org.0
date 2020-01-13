Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428BB1390F3
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 13:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgAMMTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 07:19:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgAMMTY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 07:19:24 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 606F02080D;
        Mon, 13 Jan 2020 12:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578917963;
        bh=7WDo7+l4lvljEYpDDi92RV1oftJHjP1GVnFfM1/IiYw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jOUAveGX29gHW8IaGdRIYfK9dfuXAzLU774cnW1CtIT4gix5NGcfoX7Zasv2MlH9Y
         +mTL8j94vJioUf9UJ58S+vF7OiGFlSbyo/+pYHzyFxPYTmlO2p/JFfcUBgD7A35q10
         oszL/9xCatynzXhujhmdy+HI+2y6/LgNgCKCwz4o=
Date:   Mon, 13 Jan 2020 04:19:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     gautamramk@gmail.com, netdev@vger.kernel.org,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>
Subject: Re: [PATCH net-next v3 2/2] net: sched: add Flow Queue PIE packet
 scheduler
Message-ID: <20200113041922.25282650@cakuba>
In-Reply-To: <87eew3wpg9.fsf@toke.dk>
References: <20200110062657.7217-1-gautamramk@gmail.com>
        <20200110062657.7217-3-gautamramk@gmail.com>
        <20200112173624.5f7b754b@cakuba>
        <87eew3wpg9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 12:44:38 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > On Fri, 10 Jan 2020 11:56:57 +0530, gautamramk@gmail.com wrote: =20
> >> From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
> >>=20
> >> Principles:
> >>   - Packets are classified on flows.
> >>   - This is a Stochastic model (as we use a hash, several flows might
> >>                                 be hashed on the same slot)
> >>   - Each flow has a PIE managed queue.
> >>   - Flows are linked onto two (Round Robin) lists,
> >>     so that new flows have priority on old ones.
> >>   - For a given flow, packets are not reordered.
> >>   - Drops during enqueue only.
> >>   - ECN capability is off by default.
> >>   - ECN threshold is at 10% by default.
> >>   - Uses timestamps to calculate queue delay by default.
> >>=20
> >> Usage:
> >> tc qdisc ... fq_pie [ limit PACKETS ] [ flows NUMBER ]
> >>                     [ alpha NUMBER ] [ beta NUMBER ]
> >>                     [ target TIME us ] [ tupdate TIME us ]
> >>                     [ memory_limit BYTES ] [ quantum BYTES ]
> >>                     [ ecnprob PERCENTAGE ] [ [no]ecn ]
> >>                     [ [no]bytemode ] [ [no_]dq_rate_estimator ]
> >>=20
> >> defaults:
> >>   limit: 10240 packets, flows: 1024
> >>   alpha: 1/8, beta : 5/4
> >>   target: 15 ms, tupdate: 15 ms (in jiffies)
> >>   memory_limit: 32 Mb, quantum: device MTU
> >>   ecnprob: 10%, ecn: off
> >>   bytemode: off, dq_rate_estimator: off =20
> >
> > Some reviews below, but hopefully someone who knows more about qdiscs
> > will still review :) =20
>=20
> I looked it over, and didn't find anything you hadn't already pointed
> out below. It's pretty obvious that this started out as a copy of
> sch_fq_codel. Which is good, because that's pretty solid. And bad,
> because that means it introduces another almost-identical qdisc without
> sharing any of the code...
>=20
> I think it would be worthwhile to try to consolidate things at some
> point. Either by just merging code from fq_{codel,pie}, but another
> option would be to express fq_codel and fq_pie using the fq{,_impl}.h
> includes. Maybe even sch_cake as well, but that may take a bit more
> work. Not sure if we should require this before merging fq_pie, or just
> leave it as a possible enhancement for later? WDYT?

Tricky :/ No strong opinion on my side. I'm already a little weary of
added function calls in the fast path (e.g. pie_drop_early()), but using
some static inlines wouldn't hurt... Then again since fq_codel doesn't
use fq{,_impl}.h it indeed seems like a bigger project to clean things
up.

IMHO if this qdisc works and is useful it could probably be merged as
is. Hopefully we can get an opinion on this from Stephen or others.
