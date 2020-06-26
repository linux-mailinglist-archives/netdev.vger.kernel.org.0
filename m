Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D123F20B8AE
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgFZSxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:53:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24950 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725275AbgFZSxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593197582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1e3Je3CvRXCn2FCurufE5KrNGI10dNhePZ25XKirunk=;
        b=DE3gP5dFJw3Kgkxn12QxdmrxCjViUkEQEF2zoPe/KgByCpvysplQNPJI1jBzCNr0LreJ+A
        Oab9e1T40vMhrTMlQRujHG4LA5hSuT7BZEYF1YkvOdJN/Esau6mb5AJQDH0c/pZHbL+oz1
        mLfj6MS6Pi5Vn6PxfvDA50pUbAgdRDE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-leFRgResPtWdb9EFsvrU5Q-1; Fri, 26 Jun 2020 14:52:58 -0400
X-MC-Unique: leFRgResPtWdb9EFsvrU5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DE39802ED4;
        Fri, 26 Jun 2020 18:52:56 +0000 (UTC)
Received: from new-host-5 (unknown [10.40.194.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98DF9768DA;
        Fri, 26 Jun 2020 18:52:51 +0000 (UTC)
Message-ID: <ee1936f7382461fda0e3e7f03f7dd12cf506891c.camel@redhat.com>
Subject: Re: [Cake] [PATCH net-next 1/5] sch_cake: fix IP protocol handling
 in the presence of VLAN tags
From:   Davide Caratti <dcaratti@redhat.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     cake@lists.bufferbloat.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <87h7uyhtuz.fsf@toke.dk>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk>
         <159308610390.190211.17831843954243284203.stgit@toke.dk>
         <20200625.122945.321093402617646704.davem@davemloft.net>
         <87k0zuj50u.fsf@toke.dk>
         <240fc14da96a6212a98dd9ef43b4777a9f28f250.camel@redhat.com>
         <87h7uyhtuz.fsf@toke.dk>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 26 Jun 2020 20:52:50 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Toke,

thanks for answering.

On Fri, 2020-06-26 at 14:52 +0200, Toke Høiland-Jørgensen wrote:
> Davide Caratti <dcaratti@redhat.com> writes:

[...]

> > 
> > >  I guess I can trying going through them all and figuring out if
> > > there's a more generic solution.
> > 
> > For sch_cake, I think that the qdisc shouldn't look at the IP header when
> > it schedules packets having a VLAN tag.
> > 
> > Probably, when tc_skb_protocol() returns ETH_P_8021Q or ETH_P_8021AD, we
> > should look at the VLAN priority (PCP) bits (and that's something that
> > cake doesn't do currently - but I have a small patch in my stash that
> > implements this: please let me know if you are interested in seeing it :)
> > ).
> > 
> > Then, to ensure that the IP precedence is respected, even with different
> > VLAN tags, users should explicitly configure TC filters that "map" the
> > DSCP value to a PCP value. This would ensure that configured priority is
> > respected by the scheduler, and would also be flexible enough to allow
> > different "mappings".
> 
> I think you have this the wrong way around :)
> 
> I.e., classifying based on VLAN priority is even more esoteric than
> using diffserv markings,

is it so uncommon? I knew that almost every wifi card did something
similar with 802.11 'access categories'. More generally, I'm not sure if
it's ok to ignore any QoS information present in the L2 header. Anyway,

> so that should not be the default. Making it
> the default would also make the behaviour change for the same traffic if
> there's a VLAN tag present, which is bound to confuse people. I suppose
> it could be an option, but not really sure that's needed, since as you
> say you could just implement it with your own TC filters...

you caught me :) ,

I wrote that patch in my stash to fix cake on my home router, where voice
and data are encapsulated in IP over PPPoE over VLANs, and different
services go over different VLAN ids (one VLAN dedicated for voice, the
other one for data) [1]. The quickest thing I did was: to prioritize
packets having VLAN id equal to 1035.

Now that I look at cake code again (where again means: after almost 1
year) it would be probably better to assign skb->priority using flower +
act_skbedit, and then prioritize in the qdisc: if I read the code well,
this would avoid voice and data falling into the same traffic class (that
was my original problem).

please note: I didn't try this patch - but I think that even with this
code I would have voice and data mixed together, because there is PPPoE
between VLAN and IP.

> > Sure, my proposal does not cover the problem of mangling the CE bit
> > inside VLAN-tagged packets, i.e. if we should understand if qdiscs
> > should allow it or not.
> 
> Hmm, yeah, that's the rub, isn't it? I think this is related to this
> commit, which first introduced tc_skb_protocol():
> 
> d8b9605d2697 ("net: sched: fix skb->protocol use in case of accelerated vlan path")
> 
> That commit at least made the behaviour consistent across
> accelerated/non-accelerated VLANs. However, the patch description
> asserts that 'tc code .. expects vlan protocol type [in skb->protocol]'.
> Looking at the various callers, I'm not actually sure that's true, in
> the sense that most of the callers don't handle VLAN ethertypes at all,
> but expects to find an IP header. This is the case for at least:
> 
> - act_ctinfo
> - act_skbedit
> - cls_flow
> - em_ipset
> - em_ipt
> - sch_cake
> - sch_dsmark

sure, I'm not saying it's not possible to look inside IP headers. What I
understood from Cong's replies [2], and he sort-of convinced me, was: when
I have IP and one or more VLAN tags, no matter whether it is accelerated
or not, it should be sufficient to access the IP header daisy-chaining
'act_vlan pop actions' -> access to the IP header -> ' act_vlan push
actions (in the reversed order).

oh well, that's still not sufficient in my home router because of PPPoE. I
should practice with cls_bpf more seriously :-) 

or write act_pppoe.c :D

> In fact the only caller that explicitly handles a VLAN ethertype seems
> to be act_csum; and that handles it in a way that also just skips the
> VLAN headers, albeit by skb_pull()'ing the header.


> cls_api, em_meta and sch_teql don't explicitly handle it; but returning
> the VLAN ethertypes to those does seem to make sense, since they just
> pass the value somewhere else.
> 
> So my suggestion would be to add a new helper that skips the VLAN tags
> and finds the L3 ethertype (i.e., basically cake_skb_proto() as
> introduced in this patch), then switch all the callers listed above, as
> well as the INET_ECN_set_ce() over to using that. Maybe something like
> 'skb_l3_protocol()' which could go into skbuff.h itself, so the ECN code
> can also find it?

for setting the CE bit, that's understandable - in one way or the other,
the behaviour should be made consistent.

> Any objections to this? It's not actually clear to me how the discussion
> you quoted above landed; but this will at least make things consistent
> across all the different actions/etc.

well, it just didn't "land". But I agree, inconsistency here can make some
TC configurations "unreliable" (i.e., they don't do the job they were
configured for).

thanks!

-- 
davide

[1] https://gist.github.com/teknoraver/9524e539061d0b1e9f8774aa96902082
(by the way, thanks to Matteo Croce for this :) )
[2] https://lore.kernel.org/netdev/CAM_iQpWir7R3AQ7KSeFA5QNXSPHGK-1Nc7WsRM1vhkFyxB5ekA@mail.gmail.com/

