Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAFF414FB64
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 05:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgBBEVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 23:21:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbgBBEVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 23:21:52 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A56EB2051A;
        Sun,  2 Feb 2020 04:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580617311;
        bh=0jPl9uA05QDugUATN+z1HP/9meGF3qxDNGL2+LE6hBU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FysRIcIPfjNeU/MCUNJMpgz5MI5btO3tg9O/QNCHP7LMEQIfu9B/yOlHi9zkvlEbN
         3PW5DRp+ROnNBHFvBuschbBnKnxOPWj3ecSRqOzyZh5hp+iexA7+8DiKSBEegfEr4j
         xfPIUQtdnPz3jkP79l53oaXWOv4euBRU9dq0Dgg0=
Date:   Sat, 1 Feb 2020 20:21:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        netfilter-devel@vger.kernel.org,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/6] netfilter: ipset: fix suspicious RCU usage in
 find_set_and_id
Message-ID: <20200201202150.0d0019f5@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <alpine.DEB.2.20.2002012207290.32505@blackhole.kfki.hu>
References: <20200131192428.167274-1-pablo@netfilter.org>
        <20200131192428.167274-2-pablo@netfilter.org>
        <20200201125736.453a0fec@cakuba.hsd1.ca.comcast.net>
        <20200201130549.3ee9a6b7@cakuba.hsd1.ca.comcast.net>
        <alpine.DEB.2.20.2002012207290.32505@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Feb 2020 22:11:04 +0100 (CET), Jozsef Kadlecsik wrote:
> On Sat, 1 Feb 2020, Jakub Kicinski wrote:
> > On Sat, 1 Feb 2020 12:57:36 -0800, Jakub Kicinski wrote: =20
> > > On Fri, 31 Jan 2020 20:24:23 +0100, Pablo Neira Ayuso wrote: =20
> > > > From: Kadlecsik J=C3=B3zsef <kadlec@blackhole.kfki.hu>
> > > >=20
> > > > find_set_and_id() is called when the NFNL_SUBSYS_IPSET mutex is hel=
d.
> > > > However, in the error path there can be a follow-up recvmsg() witho=
ut
> > > > the mutex held. Use the start() function of struct netlink_dump_con=
trol
> > > > instead of dump() to verify and report if the specified set does not
> > > > exist.
> > > >=20
> > > > Thanks to Pablo Neira Ayuso for helping me to understand the sublet=
ies
> > > > of the netlink protocol.
> > > >=20
> > > > Reported-by: syzbot+fc69d7cb21258ab4ae4d@syzkaller.appspotmail.com
> > > > Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>   =20
> > >=20
> > > This will trigger a missing signed-off-by check:
> > >=20
> > > Commit 5038517119d5 ("netfilter: ipset: fix suspicious RCU usage in f=
ind_set_and_id")
> > > 	author Signed-off-by missing
> > > 	author email:    kadlec@blackhole.kfki.hu
> > > 	committer email: pablo@netfilter.org
> > > 	Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> > > 	Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > >=20
> > > Problem is that the name differs by 'o' vs '=C3=B3' (J=C3=B3zsef Kadl=
ecsik).
> > >=20
> > > I wonder if it's worth getting rid of diacritics for the comparison..=
 =20
> >=20
> > Mm.. also the name and surname are the other way around :S =20
>=20
> Oh, my... Hungarian names... :-) But I also should set my sender email=20
> address to kadlec@netfilter.org.
>=20
> What's the best approach for this patch? Shall I resend it?

This one is in David Miller's tree already so too late, just fix up
your setup going forward please.

To a fellow Central European Jozsef Kadlecsik and Kadlecsik J=C3=B3zsef=20
are more than interchangeable, but probably not worth teaching the
validation scripts about this.
