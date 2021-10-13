Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CFA42C5A7
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbhJMQCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:02:45 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35944 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233774AbhJMQCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 12:02:44 -0400
Date:   Wed, 13 Oct 2021 18:00:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634140840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aZHn2trmmMVA7Ygu7KPIaVXOAKKUgWOhHi3Wv9auq/I=;
        b=ZzokKvQZurTx9cxx3LShyN6WgPaPsDmiuQqtaMqN9TKO01u9uvmFzxepVLj0IGXk/pQ3E7
        p5kV4/2nFYBz0fzsnx3dCsi4g3wed6pGHBT9aoJAvwniBnztd7r42n4iLsex/gR9yOkk76
        UXbezdTkuGUyCikls3XKalyGZczht1EPmWefAQlbVPUuFVIFDobG5x0jUBFMPL2i5iDZCg
        /746mappKYmoZqj//xEJwGHjRicpNf2y3TrSEBpATBeqrfydmtil4ojfffULKYUN+t3TMK
        oLa9YVCDfjwWI00g4H34jL6+PdQmVHEam3vLZSDvMgSABPUA4XEscv94cQhdCw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634140840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aZHn2trmmMVA7Ygu7KPIaVXOAKKUgWOhHi3Wv9auq/I=;
        b=IXZhB+xgnrMjFyl020bwglpX2U/9SGI5vA82quwv44didopNJX6eY/jTraiLw22Fn0h5ka
        c170ULmF4Cn/WDBg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH net-next 3/4] gen_stats: Add instead Set the value in
 __gnet_stats_copy_queue().
Message-ID: <20211013160039.wkalyseuzz6xlf4v@linutronix.de>
References: <20211007175000.2334713-1-bigeasy@linutronix.de>
 <20211007175000.2334713-4-bigeasy@linutronix.de>
 <20211008163851.3963b94e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211008163851.3963b94e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-08 16:38:51 [-0700], Jakub Kicinski wrote:
> On Thu,  7 Oct 2021 19:49:59 +0200 Sebastian Andrzej Siewior wrote:
> > --- a/net/core/gen_stats.c
> > +++ b/net/core/gen_stats.c
> > @@ -312,14 +312,14 @@ void __gnet_stats_copy_queue(struct gnet_stats_qu=
eue *qstats,
> >  	if (cpu) {
> >  		__gnet_stats_copy_queue_cpu(qstats, cpu);
> >  	} else {
> > -		qstats->qlen =3D q->qlen;
> > -		qstats->backlog =3D q->backlog;
> > -		qstats->drops =3D q->drops;
> > -		qstats->requeues =3D q->requeues;
> > -		qstats->overlimits =3D q->overlimits;
> > +		qstats->qlen +=3D q->qlen;
> > +		qstats->backlog +=3D q->backlog;
> > +		qstats->drops +=3D q->drops;
> > +		qstats->requeues +=3D q->requeues;
> > +		qstats->overlimits +=3D q->overlimits;
> >  	}
> > =20
> > -	qstats->qlen =3D qlen;
> > +	qstats->qlen +=3D qlen;
>=20
> Looks like qlen is going to be added twice for the non-per-cpu case?

Hmmm. Let me dive into unknown territory=E2=80=A6

Yes, it does. Also in the pcpu-case it does not look very straight what
goes on:
	qlen =3D qdisc_qlen_sum(qdisc); /* sum of per-CPU cpu_qstat.qlen */
	__gnet_stats_copy_queue() /* sch.qstats.qlen =3D qlen */
	sch->q.qlen     +=3D qlen;

sch->qstats.qlen is qdisc_qlen_sum() of the qdisc from last for loop.
sch->q.qlen contains qdisc_qlen_sum() of all qdiscs from the for loop. I
doubt this is intended.
My guess is that a sum (like in the !pcpu case is intended).

We have
- qdisc.q.qlen qdisc_skb_head::qlen
- qdisc.qstats.qlen aka gnet_stats_queue::qlen.

qdisc_skb_head::qlen is incremented if skbs are added to the qdisc which
are about to be sent. Usually the skb is added to the qdisc_skb_head but
some scheduling classes have their own queues (say sch_sfq) and probably
increment this field just to keep things like qdisc_is_empty() working.

gnet_stats_queue::qlen is the number of skbs either in Qdisc::skb_bad_txq or
Qdisc::gso_skb.

qdisc_update_stats_at_enqueue() increments in percpu case the per-CPU
gnet_stats_queue::qlen but in the !percpu case it increments
qdisc_skb_head::qlen. But there is the qstats member which is also if
type gnet_stats_queue. For backlog, the gnet_stats_queue struct is
always used, either per-CPU or the global one. Not here. Not sure if it
on purpose or not. The same true for qdisc_enqueue_skb_bad_txq() and
dev_requeue_skb() plus their counterpart so it consistent.

This brings me to __gnet_stats_copy_queue(). In the percpu case,
caller's gnet_stats_queue::qlen is set to 0 multiple times. And then
caller's qlen argument is assigned to the qlen member. In !percpu
case it copies gnet_stats_queue::qlen. But I don't see an
increment/decrement of that field here so it has to be zero. Also at the
end it sets the field to caller's qlen. So=E2=80=A6

This probably works because callers of __gnet_stats_copy_queue() invoke
qdisc_qlen_sum() which returns the sum of:
  qstats::qlen (0) +=20
     per-CPU qstats::qlen || !per-CPU qdisc_skb_head::qlen

So in the end the caller figures out qlen is and passes it as a
argument. The copy process of qlen ist decoy.

But then there is gnet_stats_copy_queue().
sch_fq_codel modifies qdisc_skb_head::qlen on fq_codel_enqueue()/
fq_codel_dequeue(). But fq_codel_dump_class_stats() returns statistics
for a specific flow so it counts the number of skb which is less than
the value qdisc_skb_head.qlen if multiple flows are configured.

So I think I could remove the qlen argument from
__gnet_stats_copy_queue() and just copy what is there. And make a real
copy, not just summing all qlen into qdisc_skb_head.qlen and leaving
gnet_stats_queue.qlen with the last value.

Sebastian
