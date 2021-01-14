Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9879A2F62A8
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbhANOEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:04:31 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8424 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbhANOEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 09:04:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60004f460001>; Thu, 14 Jan 2021 06:03:50 -0800
Received: from [172.27.13.148] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 Jan
 2021 14:03:46 +0000
Subject: Re: [net-next 08/15] net/mlx5e: CT: Preparation for offloading
 +trk+new ct rules
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
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
From:   Oz Shlomo <ozsh@nvidia.com>
Message-ID: <d1b5b862-8c30-efb6-1a2f-4f9f0d49ef15@nvidia.com>
Date:   Thu, 14 Jan 2021 16:03:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210114130238.GA2676@horizon.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610633030; bh=T6V6ME2mkN9ZqvK7ZER/M/e3bj/oLyjqDvdc9GAhAHs=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=D/EQ6+4vRaIL+xnNg4TeHH3SPuLqxGuESyHF4sZqwqDAyByYrYvLCCQNW5B+m5zpv
         NqBXKOkyK+XPYGThJAkxrJsWXhNTQOCwgIxNMT7Wk0gBcKoRhA8bZrLcvaLg1MC7HE
         +SXtnaYtuP2J4cKkNZbLVYdpwX1vCpSTq/qOpxkQFmMj577oxBYd37rxmCeEJR5nI9
         Q15HumkG7J0cva3fsXEYwsSvAyrDwAwAIebc60CgNr423yDp9g1wm73VnsZvBz1GDM
         Dbx3uqc6IpytJOIGxH8TToCeapj0Yp35YSO0t6oiPi6oloACnZf0fMZBGO2C2kVPim
         wSd7zqNlsMhnw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/14/2021 3:02 PM, Marcelo Ricardo Leitner wrote:
> On Tue, Jan 12, 2021 at 11:27:04AM +0200, Oz Shlomo wrote:
>>
>>
>> On 1/12/2021 1:51 AM, Marcelo Ricardo Leitner wrote:
>>> On Sun, Jan 10, 2021 at 09:52:55AM +0200, Roi Dayan wrote:
>>>>
>>>>
>>>> On 2021-01-10 9:45 AM, Roi Dayan wrote:
>>>>>
>>>>>
>>>>> On 2021-01-08 11:48 PM, Marcelo Ricardo Leitner wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On Thu, Jan 07, 2021 at 09:30:47PM -0800, Saeed Mahameed wrote:
>>>>>>> From: Roi Dayan <roid@nvidia.com>
>>>>>>>
>>>>>>> Connection tracking associates the connection state per packet. The
>>>>>>> first packet of a connection is assigned with the +trk+new state. T=
he
>>>>>>> connection enters the established state once a packet is seen on th=
e
>>>>>>> other direction.
>>>>>>>
>>>>>>> Currently we offload only the established flows. However, UDP traff=
ic
>>>>>>> using source port entropy (e.g. vxlan, RoCE) will never enter the
>>>>>>> established state. Such protocols do not require stateful processin=
g,
>>>>>>> and therefore could be offloaded.
>>>>>>
>>>>>> If it doesn't require stateful processing, please enlight me on why
>>>>>> conntrack is being used in the first place. What's the use case here=
?
>>>>>>
>>>>>
>>>>> The use case for example is when we have vxlan traffic but we do
>>>>> conntrack on the inner packet (rules on the physical port) so
>>>>> we never get established but on miss we can still offload as normal
>>>>> vxlan traffic.
>>>>>
>>>>
>>>> my mistake about "inner packet". we do CT on the underlay network, i.e=
.
>>>> the outer header.
>>>
>>> I miss why the CT match is being used there then. Isn't it a config
>>> issue/waste of resources? What is CT adding to the matches/actions
>>> being done on these flows?
>>>
>>
>> Consider a use case where the network port receives both east-west
>> encapsulated traffic and north-south non-encapsulated traffic that requi=
res
>> NAT.
>>
>> One possible configuration is to first apply the CT-NAT action.
>> Established north-south connections will successfully execute the nat ac=
tion
>> and will set the +est ct state.
>> However, the +new state may apply either for valid east-west traffic (e.=
g.
>> vxlan) due to source port entropy, or to insecure north-south traffic th=
at
>> the fw should block. The user may distinguish between the two cases, for
>> example, by matching on the dest udp port.
>=20
> Sorry but I still don't see the big picture. :-]
>=20
> What do you consider as east-west and north-south traffic? My initial
> understanding of east-west is traffic between VFs and north-south
> would be in and out to the wire. You mentioned that north-south is
> insecure, it would match, but then, non-encapsulated?
>=20
> So it seems you referred to the datacenter. East-west is traffic
> between hosts on the same datacenter, and north-south is traffic that
> goes out of it. This seems to match.

Right.

>=20
> Assuming it's the latter, then it seems that the idea is to work
> around a config simplification that was done by the user.  As
> mentioned on the changelog, such protocols do not require stateful
> processing, and AFAICU this patch twists conntrack so that the user
> can have simplified rules. Why can't the user have specific rules for
> the tunnels, and other for dealing with north-south traffic? The fw
> would still be able to block unwanted traffic.

We cannot control what the user is doing.
This is a valid tc configuration and would work using tc software datapath.
However, in such configurations vxlan packets would not be processed in har=
dware because they are=20
marked as new connections.

>=20
> My main problems with this is this, that it is making conntrack do
> stuff that the user may not be expecting it to do, and that packets
> may get matched (maybe even unintentionally) and the system won't have
> visibility on them. Maybe I'm just missing something?
>=20

This is why we restricted this feature to udp protocols that will never ent=
er established state due=20
to source port entropy.
Do you see a problematic use case that can arise?

>>
>>
>>>>
>>>>>>>
>>>>>>> The change in the model is that a miss on the CT table will be forw=
arded
>>>>>>> to a new +trk+new ct table and a miss there will be forwarded to
>>>>>>> the slow
>>>>>>> path table.
>>>>>>
>>>>>> AFAICU this new +trk+new ct table is a wildcard match on sport with
>>>>>> specific dports. Also AFAICU, such entries will not be visible to th=
e
>>>>>> userspace then. Is this right?
>>>>>>
>>>>>>   =C2=A0=C2=A0 Marcelo
>>>>>>
>>>>>
>>>>> right.
>>>
>>> Thanks,
>>> Marcelo
>>>
>>
