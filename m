Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5949100D93
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfKRVVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:21:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36442 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726638AbfKRVVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 16:21:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574112106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZNPo8iycYDA0YdHBvkMLuOs/0Vv+KmCYVnKCpQlb+qM=;
        b=IGSUN1Sj9idn/Z7SxQVRisOqD4eH+zPYVbJ2AddqBrZG5I0WA2X0wt9+DDHAVf8ireL7ux
        0/LAliaTsIbN0KNSXdqpSHekXzIZdlAF3E7ppw4moX0rLGIkjdi2zOvr1nlIW6Q3YXUVjJ
        Fe/q7Mf3wL6o5+cnTaX5d3p0iTGZSI4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-ssnoJYSINkeQ2-hm1f9CVQ-1; Mon, 18 Nov 2019 16:21:43 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 547FD8018A3;
        Mon, 18 Nov 2019 21:21:41 +0000 (UTC)
Received: from dhcp-25.97.bos.redhat.com (unknown [10.18.25.127])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FADC1BC76;
        Mon, 18 Nov 2019 21:21:40 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, paulb@mellanox.com
Subject: Re: [PATCH net 2/2] act_ct: support asymmetric conntrack
References: <20191108210714.12426-1-aconole@redhat.com>
        <20191108210714.12426-2-aconole@redhat.com>
        <20191114162949.GB3419@localhost.localdomain>
Date:   Mon, 18 Nov 2019 16:21:39 -0500
In-Reply-To: <20191114162949.GB3419@localhost.localdomain> (Marcelo Ricardo
        Leitner's message of "Thu, 14 Nov 2019 13:29:49 -0300")
Message-ID: <f7to8x8yj6k.fsf@dhcp-25.97.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: ssnoJYSINkeQ2-hm1f9CVQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> writes:

> On Fri, Nov 08, 2019 at 04:07:14PM -0500, Aaron Conole wrote:
>> The act_ct TC module shares a common conntrack and NAT infrastructure
>> exposed via netfilter.  It's possible that a packet needs both SNAT and
>> DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
>> this because it runs through the NAT table twice - once on ingress and
>> again after egress.  The act_ct action doesn't have such capability.
>>=20
>> Like netfilter hook infrastructure, we should run through NAT twice to
>> keep the symmetry.
>>=20
>> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
>>=20
>> Signed-off-by: Aaron Conole <aconole@redhat.com>
>> ---
>>  net/sched/act_ct.c | 13 ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index fcc46025e790..f3232a00970f 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -329,6 +329,7 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>>  =09=09=09  bool commit)
>>  {
>>  #if IS_ENABLED(CONFIG_NF_NAT)
>> +=09int err;
>>  =09enum nf_nat_manip_type maniptype;
>> =20
>>  =09if (!(ct_action & TCA_CT_ACT_NAT))
>> @@ -359,7 +360,17 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>>  =09=09return NF_ACCEPT;
>>  =09}
>> =20
>> -=09return ct_nat_execute(skb, ct, ctinfo, range, maniptype);
>> +=09err =3D ct_nat_execute(skb, ct, ctinfo, range, maniptype);
>> +=09if (err =3D=3D NF_ACCEPT &&
>> +=09    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
>> +=09=09if (maniptype =3D=3D NF_NAT_MANIP_SRC)
>> +=09=09=09maniptype =3D NF_NAT_MANIP_DST;
>> +=09=09else
>> +=09=09=09maniptype =3D NF_NAT_MANIP_SRC;
>> +
>> +=09=09err =3D ct_nat_execute(skb, ct, ctinfo, range, maniptype);
>> +=09}
>
> I keep thinking about this and I'm not entirely convinced that this
> shouldn't be simpler. More like:
>
> if (DNAT)
> =09DNAT
> if (SNAT)
> =09SNAT
>
> So it always does DNAT before SNAT, similarly to what iptables would
> do on PRE/POSTROUTING chains.

I can rewrite the whole function, but I wanted to start with the smaller
fix that worked.  I also think it needs more testing then (since it's
something of a rewrite of the function).

I guess it's not too important - do you think it gives any readability
to do it this way?  If so, I can respin the patch changing it like you
describe.

>> +=09return err;
>>  #else
>>  =09return NF_ACCEPT;
>>  #endif
>> --=20
>> 2.21.0
>>=20

