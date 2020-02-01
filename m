Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3EC14FA9E
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 22:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgBAVLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 16:11:12 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:39177 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbgBAVLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 16:11:12 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 79A626740109;
        Sat,  1 Feb 2020 22:11:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1580591467; x=1582405868; bh=zb8PYceQJ+
        nPq3GpfH07dSub449JlOHkbGHvrkPcCG0=; b=ni69s9z3/q1r8kaJjDHjr9b1n0
        vuBhLiGYpdsXZ50uO+tv+yKHVFU2p4o1P2W/ixr/Hp4cHzGyC2JFVdzxafXAWbs4
        L9rKbAPqAR9ZfltLkQyRnxev5kOIG/+jQ28jItsis3LBs2v12bCW2bBrftoWppWL
        wZCg87NpCe5Wf6+3s=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sat,  1 Feb 2020 22:11:07 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp0.kfki.hu (Postfix) with ESMTP id C953A6740108;
        Sat,  1 Feb 2020 22:11:04 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 8E6932166D; Sat,  1 Feb 2020 22:11:04 +0100 (CET)
Date:   Sat, 1 Feb 2020 22:11:04 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Jakub Kicinski <kuba@kernel.org>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Greg KH <greg@kroah.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        netfilter-devel@vger.kernel.org,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/6] netfilter: ipset: fix suspicious RCU usage in
 find_set_and_id
In-Reply-To: <20200201130549.3ee9a6b7@cakuba.hsd1.ca.comcast.net>
Message-ID: <alpine.DEB.2.20.2002012207290.32505@blackhole.kfki.hu>
References: <20200131192428.167274-1-pablo@netfilter.org>        <20200131192428.167274-2-pablo@netfilter.org>        <20200201125736.453a0fec@cakuba.hsd1.ca.comcast.net> <20200201130549.3ee9a6b7@cakuba.hsd1.ca.comcast.net>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="110363376-27872340-1580591464=:32505"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-27872340-1580591464=:32505
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 1 Feb 2020, Jakub Kicinski wrote:

> On Sat, 1 Feb 2020 12:57:36 -0800, Jakub Kicinski wrote:
> > On Fri, 31 Jan 2020 20:24:23 +0100, Pablo Neira Ayuso wrote:
> > > From: Kadlecsik J=C3=B3zsef <kadlec@blackhole.kfki.hu>
> > >=20
> > > find_set_and_id() is called when the NFNL_SUBSYS_IPSET mutex is held.
> > > However, in the error path there can be a follow-up recvmsg() without
> > > the mutex held. Use the start() function of struct netlink_dump_contr=
ol
> > > instead of dump() to verify and report if the specified set does not
> > > exist.
> > >=20
> > > Thanks to Pablo Neira Ayuso for helping me to understand the subletie=
s
> > > of the netlink protocol.
> > >=20
> > > Reported-by: syzbot+fc69d7cb21258ab4ae4d@syzkaller.appspotmail.com
> > > Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org> =20
> >=20
> > This will trigger a missing signed-off-by check:
> >=20
> > Commit 5038517119d5 ("netfilter: ipset: fix suspicious RCU usage in fin=
d_set_and_id")
> > =09author Signed-off-by missing
> > =09author email:    kadlec@blackhole.kfki.hu
> > =09committer email: pablo@netfilter.org
> > =09Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> > =09Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> >=20
> > Problem is that the name differs by 'o' vs '=C3=B3' (J=C3=B3zsef Kadlec=
sik).
> >=20
> > I wonder if it's worth getting rid of diacritics for the comparison..
>=20
> Mm.. also the name and surname are the other way around :S

Oh, my... Hungarian names... :-) But I also should set my sender email=20
address to kadlec@netfilter.org.

What's the best approach for this patch? Shall I resend it?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-27872340-1580591464=:32505--
