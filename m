Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85858100DA5
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfKRVY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:24:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49684 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726706AbfKRVY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 16:24:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574112267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ge9vGJjgG6kVVhSVZ4w0x20DCzDZjaq0NRO09Ry2qdo=;
        b=RguKaIbVj8JMSxFOoBVEMpv7VwZC723YbYsgFiVmRYktg5tyKXuWR9Uua8wYvN/aAKhFeV
        tWjmxwYcHVp1+JbZ75RBiMIto2EP00fZptU5YYCV5s5Ci17Xnv8gbMBwyVpoAxgxpwkTb9
        E2UdNgsjKQIeakBXLObggLBYqf+efek=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-q1JaMczNNhmc929c7UuM9w-1; Mon, 18 Nov 2019 16:24:23 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E6611005502;
        Mon, 18 Nov 2019 21:24:20 +0000 (UTC)
Received: from dhcp-25.97.bos.redhat.com (unknown [10.18.25.127])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6683560D7C;
        Mon, 18 Nov 2019 21:24:19 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Roi Dayan <roid@mellanox.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "dev\@openvswitch.org" <dev@openvswitch.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 2/2] act_ct: support asymmetric conntrack
References: <20191108210714.12426-1-aconole@redhat.com>
        <20191108210714.12426-2-aconole@redhat.com>
        <6917ebfa-6361-5294-d91b-b3c6dd1e8cf5@mellanox.com>
        <80993518-9481-02ca-7705-7417717365c1@mellanox.com>
Date:   Mon, 18 Nov 2019 16:24:18 -0500
In-Reply-To: <80993518-9481-02ca-7705-7417717365c1@mellanox.com> (Paul
        Blakey's message of "Thu, 14 Nov 2019 14:24:21 +0000")
Message-ID: <f7tk17wyj25.fsf@dhcp-25.97.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: q1JaMczNNhmc929c7UuM9w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Blakey <paulb@mellanox.com> writes:

> On 11/14/2019 4:22 PM, Roi Dayan wrote:
>>
>> On 2019-11-08 11:07 PM, Aaron Conole wrote:
>>> The act_ct TC module shares a common conntrack and NAT infrastructure
>>> exposed via netfilter.  It's possible that a packet needs both SNAT and
>>> DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
>>> this because it runs through the NAT table twice - once on ingress and
>>> again after egress.  The act_ct action doesn't have such capability.
>>>
>>> Like netfilter hook infrastructure, we should run through NAT twice to
>>> keep the symmetry.
>>>
>>> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
>>>
>>> Signed-off-by: Aaron Conole <aconole@redhat.com>
>>> ---
>>>   net/sched/act_ct.c | 13 ++++++++++++-
>>>   1 file changed, 12 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>>> index fcc46025e790..f3232a00970f 100644
>>> --- a/net/sched/act_ct.c
>>> +++ b/net/sched/act_ct.c
>>> @@ -329,6 +329,7 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>>>   =09=09=09  bool commit)
>>>   {
>>>   #if IS_ENABLED(CONFIG_NF_NAT)
>>> +=09int err;
>>>   =09enum nf_nat_manip_type maniptype;
>>>  =20
>>>   =09if (!(ct_action & TCA_CT_ACT_NAT))
>>> @@ -359,7 +360,17 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>>>   =09=09return NF_ACCEPT;
>>>   =09}
>>>  =20
>>> -=09return ct_nat_execute(skb, ct, ctinfo, range, maniptype);
>>> +=09err =3D ct_nat_execute(skb, ct, ctinfo, range, maniptype);
>>> +=09if (err =3D=3D NF_ACCEPT &&
>>> +=09    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
>>> +=09=09if (maniptype =3D=3D NF_NAT_MANIP_SRC)
>>> +=09=09=09maniptype =3D NF_NAT_MANIP_DST;
>>> +=09=09else
>>> +=09=09=09maniptype =3D NF_NAT_MANIP_SRC;
>>> +
>>> +=09=09err =3D ct_nat_execute(skb, ct, ctinfo, range, maniptype);
>>> +=09}
>>> +=09return err;
>>>   #else
>>>   =09return NF_ACCEPT;
>>>   #endif
>>>
>> +paul
>
> Hi Aaron,
>
> I think I understand the issue and this looks good,
>
> Can you describe the scenario to reproduce this?

It reproduces with OpenShift 3.10, which makes forward direction packets
between namespaces pump through a tun device that applies NAT rules to
rewrite the dest.  Limit the namespace number of ephemeral sockets using
by editing net.ipv4.ip_local_port_range in the client namespace, and
connect to the server namespace.  That's the mechanism for OvS.  But for
TC I guess there wouldn't be anything convenient avaiable.

I'll try to script up something that doesn't use openshift.

>
> Thanks,
>
> Paul.

