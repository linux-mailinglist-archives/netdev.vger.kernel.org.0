Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B772F2B42
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 10:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403805AbhALJ1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 04:27:51 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11346 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387783AbhALJ1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 04:27:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffd6b6e0000>; Tue, 12 Jan 2021 01:27:10 -0800
Received: from [172.27.12.183] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Jan
 2021 09:27:07 +0000
Subject: Re: [net-next 08/15] net/mlx5e: CT: Preparation for offloading
 +trk+new ct rules
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Roi Dayan <roid@nvidia.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
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
From:   Oz Shlomo <ozsh@nvidia.com>
Message-ID: <f25eee28-4c4a-9036-8c3d-d84b15a8b5e7@nvidia.com>
Date:   Tue, 12 Jan 2021 11:27:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210111235116.GA2595@horizon.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610443630; bh=m+1jTPunNoBDrWF+1ZU6ibPljI+fSAmAA9rDhmrQazE=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=jkzsCkx79MqozvwIsT6UMIXYlTbyZkndBt2q3v3joEqIubN05B1UwvmZoDS0e/TbP
         H19+IaugX9hig5Hg5sv6FkZiMtAmg7BaX0hH5nHE1BZyrj93bZjKUkn/Vn1D6FuTaa
         M/VB/VouwJY2BSLeE3yi+z5juH/9rkYY71hLeScn0ZmWPHRrx88mtiGffErpx2Wf7x
         yqzcPoNWIKHfGXa990JZsGFqN5JssIXueLtb+eBI4bj6zPSGbCfggpd6zSWciKXq9I
         UZelBaYtcKuEiAStnAMjGQyhm9Q+FeereP9T5Hq/AuGQ9G5qTvHo62UOVLJoCrZMbF
         oVmrX4tNwvobA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/12/2021 1:51 AM, Marcelo Ricardo Leitner wrote:
> On Sun, Jan 10, 2021 at 09:52:55AM +0200, Roi Dayan wrote:
>>
>>
>> On 2021-01-10 9:45 AM, Roi Dayan wrote:
>>>
>>>
>>> On 2021-01-08 11:48 PM, Marcelo Ricardo Leitner wrote:
>>>> Hi,
>>>>
>>>> On Thu, Jan 07, 2021 at 09:30:47PM -0800, Saeed Mahameed wrote:
>>>>> From: Roi Dayan <roid@nvidia.com>
>>>>>
>>>>> Connection tracking associates the connection state per packet. The
>>>>> first packet of a connection is assigned with the +trk+new state. The
>>>>> connection enters the established state once a packet is seen on the
>>>>> other direction.
>>>>>
>>>>> Currently we offload only the established flows. However, UDP traffic
>>>>> using source port entropy (e.g. vxlan, RoCE) will never enter the
>>>>> established state. Such protocols do not require stateful processing,
>>>>> and therefore could be offloaded.
>>>>
>>>> If it doesn't require stateful processing, please enlight me on why
>>>> conntrack is being used in the first place. What's the use case here?
>>>>
>>>
>>> The use case for example is when we have vxlan traffic but we do
>>> conntrack on the inner packet (rules on the physical port) so
>>> we never get established but on miss we can still offload as normal
>>> vxlan traffic.
>>>
>>
>> my mistake about "inner packet". we do CT on the underlay network, i.e.
>> the outer header.
>=20
> I miss why the CT match is being used there then. Isn't it a config
> issue/waste of resources? What is CT adding to the matches/actions
> being done on these flows?
>=20

Consider a use case where the network port receives both east-west encapsul=
ated traffic and=20
north-south non-encapsulated traffic that requires NAT.

One possible configuration is to first apply the CT-NAT action.
Established north-south connections will successfully execute the nat actio=
n and will set the +est=20
ct state.
However, the +new state may apply either for valid east-west traffic (e.g. =
vxlan) due to source port=20
entropy, or to insecure north-south traffic that the fw should block. The u=
ser may distinguish=20
between the two cases, for example, by matching on the dest udp port.


>>
>>>>>
>>>>> The change in the model is that a miss on the CT table will be forwar=
ded
>>>>> to a new +trk+new ct table and a miss there will be forwarded to
>>>>> the slow
>>>>> path table.
>>>>
>>>> AFAICU this new +trk+new ct table is a wildcard match on sport with
>>>> specific dports. Also AFAICU, such entries will not be visible to the
>>>> userspace then. Is this right?
>>>>
>>>>  =C2=A0=C2=A0 Marcelo
>>>>
>>>
>>> right.
>=20
> Thanks,
> Marcelo
>=20
