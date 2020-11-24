Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F492C2571
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 13:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733306AbgKXMOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 07:14:05 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8642 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729172AbgKXMOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 07:14:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbcf9130000>; Tue, 24 Nov 2020 04:14:11 -0800
Received: from [172.27.14.166] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Nov
 2020 12:13:54 +0000
Subject: Re: [PATCH iproute2-next v2] tc flower: use right ethertype in
 icmp/arp parsing
From:   Roi Dayan <roid@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        Zahari Doychev <zahari.doychev@linux.com>,
        <netdev@vger.kernel.org>
CC:     <simon.horman@netronome.com>, <jhs@mojatatu.com>,
        <jianbol@mellanox.com>
References: <20201110075355.52075-1-zahari.doychev@linux.com>
 <c51abdae-6596-54ec-2b96-9b010c27cdb1@gmail.com>
 <3ae696c9-b4dd-a2e5-77d5-c572e98a4000@nvidia.com>
Message-ID: <6bf5c24a-13bf-afbd-0b45-1488c09ecc56@nvidia.com>
Date:   Tue, 24 Nov 2020 14:13:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <3ae696c9-b4dd-a2e5-77d5-c572e98a4000@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606220051; bh=Nz+SeA9JhiwgaYXlIGE5BRHYkTNCAj/vZhSd2BXy2cI=;
        h=Subject:From:To:CC:References:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=mioN7SobBmTjXDPqXCcurWMNTNDfuSBbi46Dy3bOEKKVKBW03wWtIkZOyND+FvhEO
         Sd9qmp4bkH7YxTpQkg4RMS9WtoaIyLgw6fREAOLrT+6vpAOqf+rkdy1N0nFmPT0LwS
         M8cXZZF4kut2TgdCRIPz/giayWKgRShX27PGEdPryWSA3JyyvXmf6t5RU4mNgPHBXJ
         XSRzsvPa4EpWND9OyAXLOS06eKiHHpAEL6bOZ2iWGEkze2f0m73CgrGURypYxQMbrM
         UZQCNbeJ3QgDzJBh9Go5nQeitrDphiAegQuPZecwAqL/VDrOxbU6BKjhCIwpY0v1s/
         Prmw5NWUd1TGA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-11-24 11:39 AM, Roi Dayan wrote:
>=20
>=20
> On 2020-11-14 5:12 AM, David Ahern wrote:
>> On 11/10/20 12:53 AM, Zahari Doychev wrote:
>>> Currently the icmp and arp parsing functions are called with incorrect
>>> ethtype in case of vlan or cvlan filter options. In this case either
>>> cvlan_ethtype or vlan_ethtype has to be used. The ethtype is now update=
d
>>> each time a vlan ethtype is matched during parsing.
>>>
>>> Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
>>> ---
>>> =C2=A0 tc/f_flower.c | 52 +++++++++++++++++++++++----------------------=
------
>>> =C2=A0 1 file changed, 23 insertions(+), 29 deletions(-)
>>>
>>
>> Thanks, looks much better.
>>
>> applied to iproute2-next.
>>
>=20
> Hi,
>=20
> I didn't debug yet but with this commit I am failing to add a tc
> rule I always could before. also the error msg doesn't make sense.
>=20
> Example:
>=20
> # tc filter add dev enp8s0f0 protocol 802.1Q parent ffff: prio 1 flower\
>  =C2=A0skip_hw dst_mac e4:11:22:11:4a:51 src_mac e4:11:22:11:4a:50\
>  =C2=A0vlan_ethtype 0x800 vlan_id 100 vlan_prio 0 action vlan pop action\
>  =C2=A0mirred egress redirect dev enp8s0f0_0
>=20
>=20
> Can't set "vlan_id" if ethertype isn't 802.1Q or 802.1AD
>=20
>=20
> I used protocol 802.1Q and vlan_ethtype 0x800.
> am i missing something? the rule should look different now?
>=20
> Thanks,
> Roi


Hi,

I debugged this and it break vlan rules.
The issue is from this part of the change


@@ -1464,6 +1464,8 @@ static int flower_parse_opt(struct filter_util=20
*qu, char *handle,
                                                  &vlan_ethtype, n);
                         if (ret < 0)
                                 return -1;
+                       /* get new ethtype for later parsing  */
+                       eth_type =3D vlan_ethtype;



Now params vlan_id, vlan_prio check if eth_type is vlan but it's not.
it's 0x0800 as the example as it was set to the vlan_ethtype.

Need to continue check the outer, so tc_proto.
i'll prep a fix commit for review.


Thanks,
Roi
