Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C5710798A
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 21:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfKVUj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 15:39:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59876 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726089AbfKVUj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 15:39:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574455167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V/dlCJK+i6cXX9AuNkha8Hfa/aQ9TDGvh5ka3yqobAs=;
        b=Se850C/Ogt11AV1fMU2ytvwZGYSwBqA15N+fQEHr4Ive0LxPc6HWly5Wcj14BdmoFlfARN
        7KBRGKsW7BURaR41KXzjqcLteYGyfLSovDtIS2OAp9m08KmaZmRezJc2DHumbnFu+IcCQQ
        J3gwlqymFyAQ4mqZv6d4vPIby04SNTc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-DMVZQvRcOuKSr86Ijn8kOQ-1; Fri, 22 Nov 2019 15:39:24 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C7DE8038A1;
        Fri, 22 Nov 2019 20:39:21 +0000 (UTC)
Received: from dhcp-25.97.bos.redhat.com (unknown [10.18.25.127])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D4B4E6084E;
        Fri, 22 Nov 2019 20:39:17 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, paulb@mellanox.com,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net 2/2] act_ct: support asymmetric conntrack
References: <20191108210714.12426-1-aconole@redhat.com>
        <20191108210714.12426-2-aconole@redhat.com>
        <20191114162949.GB3419@localhost.localdomain>
        <f7to8x8yj6k.fsf@dhcp-25.97.bos.redhat.com>
        <20191118224054.GB388551@localhost.localdomain>
Date:   Fri, 22 Nov 2019 15:39:16 -0500
In-Reply-To: <20191118224054.GB388551@localhost.localdomain> (Marcelo Ricardo
        Leitner's message of "Mon, 18 Nov 2019 19:40:54 -0300")
Message-ID: <f7tv9rbmyrv.fsf@dhcp-25.97.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: DMVZQvRcOuKSr86Ijn8kOQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> writes:

> On Mon, Nov 18, 2019 at 04:21:39PM -0500, Aaron Conole wrote:
>> Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> writes:
>>=20
>> > On Fri, Nov 08, 2019 at 04:07:14PM -0500, Aaron Conole wrote:
>> >> The act_ct TC module shares a common conntrack and NAT infrastructure
>> >> exposed via netfilter.  It's possible that a packet needs both SNAT a=
nd
>> >> DNAT manipulation, due to e.g. tuple collision.  Netfilter can suppor=
t
>> >> this because it runs through the NAT table twice - once on ingress an=
d
>> >> again after egress.  The act_ct action doesn't have such capability.
>> >>=20
>> >> Like netfilter hook infrastructure, we should run through NAT twice t=
o
>> >> keep the symmetry.
>> >>=20
>> >> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
>> >>=20
>> >> Signed-off-by: Aaron Conole <aconole@redhat.com>
>> >> ---
>> >>  net/sched/act_ct.c | 13 ++++++++++++-
>> >>  1 file changed, 12 insertions(+), 1 deletion(-)
>> >>=20
>> >> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> >> index fcc46025e790..f3232a00970f 100644
>> >> --- a/net/sched/act_ct.c
>> >> +++ b/net/sched/act_ct.c
>> >> @@ -329,6 +329,7 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>> >>  =09=09=09  bool commit)
>> >>  {
>> >>  #if IS_ENABLED(CONFIG_NF_NAT)
>> >> +=09int err;
>> >>  =09enum nf_nat_manip_type maniptype;
>> >> =20
>> >>  =09if (!(ct_action & TCA_CT_ACT_NAT))
>> >> @@ -359,7 +360,17 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>> >>  =09=09return NF_ACCEPT;
>> >>  =09}
>> >> =20
>> >> -=09return ct_nat_execute(skb, ct, ctinfo, range, maniptype);
>> >> +=09err =3D ct_nat_execute(skb, ct, ctinfo, range, maniptype);
>> >> +=09if (err =3D=3D NF_ACCEPT &&
>> >> +=09    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
>> >> +=09=09if (maniptype =3D=3D NF_NAT_MANIP_SRC)
>> >> +=09=09=09maniptype =3D NF_NAT_MANIP_DST;
>> >> +=09=09else
>> >> +=09=09=09maniptype =3D NF_NAT_MANIP_SRC;
>> >> +
>> >> +=09=09err =3D ct_nat_execute(skb, ct, ctinfo, range, maniptype);
>> >> +=09}
>> >
>> > I keep thinking about this and I'm not entirely convinced that this
>> > shouldn't be simpler. More like:
>> >
>> > if (DNAT)
>> > =09DNAT
>> > if (SNAT)
>> > =09SNAT
>> >
>> > So it always does DNAT before SNAT, similarly to what iptables would
>> > do on PRE/POSTROUTING chains.
>>=20
>> I can rewrite the whole function, but I wanted to start with the smaller
>> fix that worked.  I also think it needs more testing then (since it's
>> something of a rewrite of the function).
>>=20
>> I guess it's not too important - do you think it gives any readability
>> to do it this way?  If so, I can respin the patch changing it like you
>> describe.
>
> I didn't mean a rewrite, but just to never handle SNAT before DNAT. So
> the fix here would be like:
>
> -=09return ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> +=09err =3D ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> +=09if (err =3D=3D NF_ACCEPT && maniptype =3D=3D NF_NAT_MANIP_DST &&
> +=09    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
> +=09=09maniptype =3D NF_NAT_MANIP_SRC;
> +=09=09err =3D ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> +=09}
> +=09return err;

But the maniptype of the first call could be NAT_MANIP_SRC.  In fact,
that's what I see if the packet is reply direction && !related.

So, we need the block to invert the manipulation type.  Otherwise, we
miss the DNAT manipulation.

So I don't think I can use that block.

>> >> +=09return err;
>> >>  #else
>> >>  =09return NF_ACCEPT;
>> >>  #endif
>> >> --=20
>> >> 2.21.0
>> >>=20
>>=20

