Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49552FD524
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 17:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbhATQLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 11:11:47 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16008 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732749AbhATQKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 11:10:52 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600855d20000>; Wed, 20 Jan 2021 08:09:54 -0800
Received: from [172.27.0.253] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Jan
 2021 16:09:51 +0000
Subject: Re: [net-next 08/15] net/mlx5e: CT: Preparation for offloading
 +trk+new ct rules
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210108053054.660499-1-saeed@kernel.org>
 <20210108053054.660499-9-saeed@kernel.org>
 <20210108214812.GB3678@horizon.localdomain>
 <c11867d2-6fda-d77c-6b52-f4093c751379@nvidia.com>
 <218258b2-3a86-2d87-dfc6-8b3c1e274b26@nvidia.com>
 <20210111235116.GA2595@horizon.localdomain>
 <f25eee28-4c4a-9036-8c3d-d84b15a8b5e7@nvidia.com>
 <20210114130238.GA2676@horizon.localdomain>
 <d1b5b862-8c30-efb6-1a2f-4f9f0d49ef15@nvidia.com>
 <20210114215052.GB2676@horizon.localdomain>
From:   Oz Shlomo <ozsh@nvidia.com>
Message-ID: <009bd8cf-df39-5346-b892-4e68a042c4b4@nvidia.com>
Date:   Wed, 20 Jan 2021 18:09:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210114215052.GB2676@horizon.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611158994; bh=KtvcxdUVYJj2Vk2noaQdHd+Vebf+mMuA7VWF5EwDe5I=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=OPhYBgqraY3ljut+PZI+Hj1JOhSAKibaFQ+EoGYqOdo5poBy02Jc1+rDbil/j7Rji
         mi3wATLfOrgF4MG5W9d1ISzqcAffwqq74XcDlEJRfIEXujwA0qmKbGCnNwEZYYPyYN
         dop3Fudi7gBlhavLDqp8cG1QjlvnNEaEPtc0oqAm6933xhUhNoE87cC6Nrn1yp5ula
         dgXg3jCQcMSE6gyrBMHaU7BFqCbbX6clCYzN1z2lsuIRHyIUP8gWE9FgznKVZ9Tr4v
         vZCzy02xuD2PBaYjSHPLihk3O1LNoQOrfOEviBpQyyeTTJhEfLdBTR36NEqr0vkh+f
         75HjSKs9ppdCw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/14/2021 11:50 PM, Marcelo Ricardo Leitner wrote:
> On Thu, Jan 14, 2021 at 04:03:43PM +0200, Oz Shlomo wrote:
>>
>>
>> On 1/14/2021 3:02 PM, Marcelo Ricardo Leitner wrote:
>>> On Tue, Jan 12, 2021 at 11:27:04AM +0200, Oz Shlomo wrote:
>>>>
>>>>
>>>> On 1/12/2021 1:51 AM, Marcelo Ricardo Leitner wrote:
>>>>> On Sun, Jan 10, 2021 at 09:52:55AM +0200, Roi Dayan wrote:
>>>>>>
>>>>>>
>>>>>> On 2021-01-10 9:45 AM, Roi Dayan wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 2021-01-08 11:48 PM, Marcelo Ricardo Leitner wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> On Thu, Jan 07, 2021 at 09:30:47PM -0800, Saeed Mahameed wrote:
>>>>>>>>> From: Roi Dayan <roid@nvidia.com>
>>>>>>>>>
>>>>>>>>> Connection tracking associates the connection state per packet. T=
he
>>>>>>>>> first packet of a connection is assigned with the +trk+new state.=
 The
>>>>>>>>> connection enters the established state once a packet is seen on =
the
>>>>>>>>> other direction.
>>>>>>>>>
>>>>>>>>> Currently we offload only the established flows. However, UDP tra=
ffic
>>>>>>>>> using source port entropy (e.g. vxlan, RoCE) will never enter the
>>>>>>>>> established state. Such protocols do not require stateful process=
ing,
>>>>>>>>> and therefore could be offloaded.
>>>>>>>>
>>>>>>>> If it doesn't require stateful processing, please enlight me on wh=
y
>>>>>>>> conntrack is being used in the first place. What's the use case he=
re?
>>>>>>>>
>>>>>>>
>>>>>>> The use case for example is when we have vxlan traffic but we do
>>>>>>> conntrack on the inner packet (rules on the physical port) so
>>>>>>> we never get established but on miss we can still offload as normal
>>>>>>> vxlan traffic.
>>>>>>>
>>>>>>
>>>>>> my mistake about "inner packet". we do CT on the underlay network, i=
.e.
>>>>>> the outer header.
>>>>>
>>>>> I miss why the CT match is being used there then. Isn't it a config
>>>>> issue/waste of resources? What is CT adding to the matches/actions
>>>>> being done on these flows?
>>>>>
>>>>
>>>> Consider a use case where the network port receives both east-west
>>>> encapsulated traffic and north-south non-encapsulated traffic that req=
uires
>>>> NAT.
>>>>
>>>> One possible configuration is to first apply the CT-NAT action.
>>>> Established north-south connections will successfully execute the nat =
action
>>>> and will set the +est ct state.
>>>> However, the +new state may apply either for valid east-west traffic (=
e.g.
>>>> vxlan) due to source port entropy, or to insecure north-south traffic =
that
>>>> the fw should block. The user may distinguish between the two cases, f=
or
>>>> example, by matching on the dest udp port.
>>>
>>> Sorry but I still don't see the big picture. :-]
>>>
>>> What do you consider as east-west and north-south traffic? My initial
>>> understanding of east-west is traffic between VFs and north-south
>>> would be in and out to the wire. You mentioned that north-south is
>>> insecure, it would match, but then, non-encapsulated?
>>>
>>> So it seems you referred to the datacenter. East-west is traffic
>>> between hosts on the same datacenter, and north-south is traffic that
>>> goes out of it. This seems to match.
>>
>> Right.
>>
>>>
>>> Assuming it's the latter, then it seems that the idea is to work
>>> around a config simplification that was done by the user.  As
>>> mentioned on the changelog, such protocols do not require stateful
>>> processing, and AFAICU this patch twists conntrack so that the user
>>> can have simplified rules. Why can't the user have specific rules for
>>> the tunnels, and other for dealing with north-south traffic? The fw
>>> would still be able to block unwanted traffic.
>>
>> We cannot control what the user is doing.
>=20
> Right, but we can educate and point them towards better configs. With
> non-optimal configs it's fair to expect non-optimal effects.
>=20
>> This is a valid tc configuration and would work using tc software datapa=
th.
>> However, in such configurations vxlan packets would not be processed in
>> hardware because they are marked as new connections.
>=20
> Makes sense.
>=20
>>
>>>
>>> My main problems with this is this, that it is making conntrack do
>>> stuff that the user may not be expecting it to do, and that packets
>>> may get matched (maybe even unintentionally) and the system won't have
>>> visibility on them. Maybe I'm just missing something?
>>>
>>
>> This is why we restricted this feature to udp protocols that will never
>> enter established state due to source port entropy.
>> Do you see a problematic use case that can arise?
>=20
> For use case, the only one I see is if someone wants to use this
> feature for another application/dstport. It's hardcoded to tunnels
> ones.

It's a hardware offload optimization feature.
This is why we chose to support specific protocols that explicitly define s=
ource port entropy.

>=20
> It feels that the problem is not being solved at the right place. It
> will work well for hardware processing, while for software it will
> work while having a ton of conntrack entries. Different behaviors that
> can lead to people wasting time. Like, trying to debug on why srcport
> is not getting randomized when offloaded, while in fact they are, it's
> just masked.

The SW and HW offload are functionally identical.
You are correct that with this patch the UNREPLIED CT entries will not be v=
isible to the user=20
through /proc/net/nf_conntrack

>=20
> As this is a fallback (iow, search is done in 2 levels at least), I
> wonder what other approaches were considered. I'm thinking two for
> now. One is to add a flag to conntrack entries that allow them to be
> this generic. Finding the right conntrack entry probably gets harder,
> but when the user dumps /proc/net/nf_conntrack, it says something. On
> how/when to add this flag, maybe act_ct can do it if dstport matches
> something and/or a sysctl specifying a port list.
>=20
> The other one may sound an overkill, but is to work with conntrack
> expectations somehow.
>=20
> The first one is closer to the current proposal. It basically makes
> the port list configurable and move the "do it" decision to outside
> the driver, where the admin can have more control. If conntrack itself
> can also leverage it and avoid having tons of entries, even better, as
> then we have both behaviors in sync.

IIUC you propose a mechanism for avoiding CT processing of packets with a c=
ertain mask (e.g. based=20
on dst udp port). Configured by admin and enforced by act_ct or even conntr=
ack itself.

If so, this seems like a fundamental change to nf conntrack requiring it to=
 add packet=20
classification engines.

>=20
> Thoughts?
>=20

I wonder if we should develop a generic mechanism to optimize CT software f=
or a use case that is=20
faulty by design.
This has limited value for software as it would only reduce the conntrack t=
able size (packet=20
classification is still required).
However, this feature may have a big impact on hardware offload.
Normally hardware offload relies on software to handle new connections. Cau=
sing all new connections=20
to be processed by software.
With this patch the hardware may autonomously set the +new connection state=
 for the relevant=20
connections.



>>
>>>>
>>>>
>>>>>>
>>>>>>>>>
>>>>>>>>> The change in the model is that a miss on the CT table will be fo=
rwarded
>>>>>>>>> to a new +trk+new ct table and a miss there will be forwarded to
>>>>>>>>> the slow
>>>>>>>>> path table.
>>>>>>>>
>>>>>>>> AFAICU this new +trk+new ct table is a wildcard match on sport wit=
h
>>>>>>>> specific dports. Also AFAICU, such entries will not be visible to =
the
>>>>>>>> userspace then. Is this right?
>>>>>>>>
>>>>>>>>    =C2=A0=C2=A0 Marcelo
>>>>>>>>
>>>>>>>
>>>>>>> right.
>>>>>
>>>>> Thanks,
>>>>> Marcelo
>>>>>
>>>>
>>
