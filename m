Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CA943B176
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 13:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbhJZLqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 07:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbhJZLqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 07:46:19 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8D1C061745;
        Tue, 26 Oct 2021 04:43:55 -0700 (PDT)
Date:   Tue, 26 Oct 2021 13:43:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1635248632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eZ4neUNOghjf5S1JjI+gn7geqrIVxjnymAdwbN+Ka6Q=;
        b=Vv3MANl93vmVT+PzjlUy9IAiN9eKvoX68WnqLW71WE8b0BJ3XZJfgPJwb0BGI8l2gDk6TZ
        nENdV+Lg0/GOd5s6xk6Rw4OdU2ONT0B1zLtcqycvmbUo7lkLbiQO3BIxMVfNxjXxNMevAi
        +ufx6mjfKntjwHy+ACeTYNI4OFLX4i73WT9KXjW6G70iXuNpBcnrDca5aLJQXAnPTDYloo
        VRV3sVXvJGh6zii+0MYL+iZhQUdrsKlWlI2TdwtxFR4vMahAl6nw1sEAqu2Md0X5w6/WKQ
        Fri219z+Vo4cs5zeUY6DyO7DlfEqVzsQccMb+mMSsUZrrei9oaF8cFRe6uPS7A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1635248632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eZ4neUNOghjf5S1JjI+gn7geqrIVxjnymAdwbN+Ka6Q=;
        b=FgUEv64Zmy/r7unL5ZMoMgqlnWZ4zbAa/Wg3P+hi61SIGHjQ0KezBbUujwbpNsUwnPEk2o
        GHXm6gPoHKb7CaDA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Denis Kirjanov <dkirjanov@suse.de>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v3] net: sched: gred: dynamically allocate
 tc_gred_qopt_offload
Message-ID: <20211026114351.sq2qlpbfptd7hyxm@linutronix.de>
References: <20211026100711.nalhttf6mbe6sudx@linutronix.de>
 <3bf1e148-14fc-98f6-5319-78046a7b9565@suse.de>
 <20211026105104.vhfxrwisqcbvsxiq@linutronix.de>
 <d3a32766-550c-11a1-4364-98f876e7ce12@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <d3a32766-550c-11a1-4364-98f876e7ce12@suse.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-26 14:16:16 [+0300], Denis Kirjanov wrote:
> 10/26/21 1:51 PM, Sebastian Andrzej Siewior =D0=BF=D0=B8=D1=88=D0=B5=D1=
=82:
> > On 2021-10-26 13:42:24 [+0300], Denis Kirjanov wrote:
> > > > diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
> > > > index 72de08ef8335e..1073c76d05c45 100644
> > > > --- a/net/sched/sch_gred.c
> > > > +++ b/net/sched/sch_gred.c
> > > > @@ -311,42 +312,43 @@ static void gred_offload(struct Qdisc *sch, e=
num tc_gred_command command)
> > > >    {
> > > >    	struct gred_sched *table =3D qdisc_priv(sch);
> > > >    	struct net_device *dev =3D qdisc_dev(sch);
> > > > -	struct tc_gred_qopt_offload opt =3D {
> > > > -		.command	=3D command,
> > > > -		.handle		=3D sch->handle,
> > > > -		.parent		=3D sch->parent,
> > > > -	};
> > > > +	struct tc_gred_qopt_offload *opt =3D table->opt;
> > > >    	if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
> > > >    		return;
> > > > +	memset(opt, 0, sizeof(*opt));
> > >=20
> > > It's zeroed in kzalloc()
> >=20
> > but it is not limited to a single invocation?
>=20
> I meant that all fields are set in the function as it was with the stack
> storage.

What about?
|                for (i =3D 0; i < table->DPs; i++) {
|                        struct gred_sched_data *q =3D table->tab[i];
|=20
|                        if (!q)
|                                continue;

The stack storage version has an implicit memset().

Sebastian
