Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF363E7D8F
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 18:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbhHJQgi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 10 Aug 2021 12:36:38 -0400
Received: from lixid.tarent.de ([193.107.123.118]:57409 "EHLO mail.lixid.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233274AbhHJQgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 12:36:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 25E5E140F0B;
        Tue, 10 Aug 2021 18:36:14 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id 19XXeJS4oXlb; Tue, 10 Aug 2021 18:36:07 +0200 (CEST)
Received: from tglase-nb.lan.tarent.de (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id C55FD14020D;
        Tue, 10 Aug 2021 18:36:07 +0200 (CEST)
Received: by tglase-nb.lan.tarent.de (Postfix, from userid 1000)
        id 7C96F52086B; Tue, 10 Aug 2021 18:36:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by tglase-nb.lan.tarent.de (Postfix) with ESMTP id 7971A5205FC;
        Tue, 10 Aug 2021 18:36:07 +0200 (CEST)
Date:   Tue, 10 Aug 2021 18:36:07 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: Intro into qdisc writing?
In-Reply-To: <da23ab42-6b99-4981-97f0-3cd7a76c96b8@redhat.com>
Message-ID: <c9abbcd-c351-2a51-3c7d-232c9ef3ff2@tarent.de>
References: <1e2625bd-f0e5-b5cf-8f57-c58968a0d1e5@tarent.de> <d14be9a8-85b2-010e-16f3-cae1587f8471@gmail.com> <da23ab42-6b99-4981-97f0-3cd7a76c96b8@redhat.com>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021, Jesper Dangaard Brouer wrote:

> > Instead of writing a new qdisc, you could simply use FQ packet scheduler,
> > and a eBPF program adjusting skb->tstamp depending on your needs.

Hmm, this opens another magnitude of complexity I’m not sure I’m ready
to tackle right now. So let me explain the specific scenarios more (I
had hoped to get more general advice first):

There are two operation modes. One uses netem to limit bandwidth and
introduce latency. The other, which I’ve been working on, uses htb to
limit bandwidth (not my part until now) with a sub-qdisc fq_codel to
do ECN CE marking. (As you might have seen from the other link, those
ECN markings are what we’re actually after, not so much the traffic
behaviour.) I forked fq_codel into something else to change the way it
does the ECN marking, to match the scenario we’re modelling more closely.

There’s a controlling application running on the router which sets up
these qdiscs. It also changes the htb qdisc to increase or reduce the
bandwidth available to the fq_codel fork, currently every second or so,
but the goal is to do this every 10ms or so (that’s a ton of tc(8) in‐
vocations, I know…); this is, again, not my department.

There are two more specific delays to be introduced now. I think they
need to be introduced to both scenarios (and I was told netem doesn’t
play with fq_codel; I’m not sure if the netem scenario also uses htb to
control bandwidth or not).

One is that “on command” all traffic needs to stop for, say 20, 30 ms.
I was thinking of adding a flag to htb that, when set on tc, does this
(oneshot), since tc is called to reconfigure htb often enough anyway.
This doesn’t happen often, maybe once every few minutes.

The other is a running counter over the packets sent out, and every
n-th packet must be delayed by an additional x ms. Every n*n-th packet
by 2*x ms even. I was considering putting those aside, sending out the
next packets that arrive, or if none, returning NULL from the dequeue
function, but when I do that I need to be called again in x ms, so I
need the watchdog, right?

So this is all very static, and I’m familiar enough with C to implement
things there, but not with BPF let alone Linux’ eBPF. I’m also not sure
how to get the “on command” thing done there.

Perhaps the entire “playlist” of network behaviour could be moved there,
but there is, again, much more involved than I am even familiar with or
told about. There is, at least, limiting bandwidth, then either introducing
latency (with jitter) or doing the ECN marking, then introducing additional
“dead times” for individual packets or all traffic, and there probably will
be more. We’re approaching this piece by piece as we’re learning about the
to-be-modelled environment, which in itself is *also* still under develop‐
ment (with feedback from the simulator to the environment as well). I’m
just the one C guy involved ☺

> > https://legacy.netdevconf.info/0x14/session.html?talk-replacing-HTB-with-EDT-and-BPF

> If you want to see some code doing this via BPF see:
> https://github.com/xdp-project/bpf-examples/blob/master/traffic-pacing-edt/

> The comments in the code and scripts should hopefully be enough for you to
> understand the concept. Eric's slides describe the overall concept and
> background.

I’ll definitely look into them, but…

> > > Similarily, is there an intro of sorts for qdisc writing, the things
> > > to know, concepts, locking, whatever is needed?

… is there something more general for starters?

Ah Eric, did you even see my earlier mail about the fq_codel undocumented
flag? I wrote up what I could gather from the code and some websites about
fq_codel and documented that (as part of documenting the changed version)
in https://github.com/tarent/sch_jens/blob/master/man/man8/tc-jens.8 and
was thinking of isolating the fq_codel part and submitting it as replacement
for the current tc-fq_codel(8) manpage; review of that (for correctness of
the documentation) would be welcome if you’re available…

//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

*************************************************

Mit dem tarent-Newsletter nichts mehr verpassen: www.tarent.de/newsletter

*************************************************
