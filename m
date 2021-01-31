Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B49B309CC6
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 15:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbhAaOSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:18:53 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17648 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhAaNno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 08:43:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6016ae2f0000>; Sun, 31 Jan 2021 05:18:39 -0800
Received: from [172.27.13.84] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 31 Jan
 2021 13:18:37 +0000
Subject: Re: [PATCH net 1/1] netfilter: conntrack: Check offload bit on table
 dump
From:   Roi Dayan <roid@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>
References: <20210128074052.777999-1-roid@nvidia.com>
 <20210130120114.GA7846@salvia>
 <3a29e9b5-7bf8-5c00-3ede-738f9b4725bf@nvidia.com>
Message-ID: <997cbda4-acd1-a000-1408-269bc5c3abf3@nvidia.com>
Date:   Sun, 31 Jan 2021 15:18:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <3a29e9b5-7bf8-5c00-3ede-738f9b4725bf@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612099119; bh=dK1aqpGJLeOrE1XPMeDANKVbsDKsO3U12kdExPfIjPQ=;
        h=Subject:From:To:CC:References:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=ip7mEdoNYnhWaVYXsy2w5ADQhT5aJ66uZ1n0xJAiVsarlGtGR4i4gS84a9S0hn6bW
         ABzFXqNdtuMaAnqcT8O0lKOz60SpD+8krJgMXyto5YNEYygjnehHEafJQHCXmKUK6z
         Y8HiTRvYjK8fU7E8qk5QhYxTC/wmyWBuo35KIa9l4CHVm9cbl+8BmfrhzD4QKIlN0K
         Rt2upzzxgoD6lO2PM4z7e0RUTyKoKud8Bd3CHbru7R6IR/fT9f/mKY24uAHlKSMN+v
         B5dJEJcdgxBA1OIkb/5vbTkpj5UewmayZJzviCtdHN50FYW8myI2+mywlCdZLr4NKm
         uME3HTijo+LQg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-01-31 12:01 PM, Roi Dayan wrote:
>=20
>=20
> On 2021-01-30 2:01 PM, Pablo Neira Ayuso wrote:
>> Hi Roi,
>>
>> On Thu, Jan 28, 2021 at 09:40:52AM +0200, Roi Dayan wrote:
>>> Currently, offloaded flows might be deleted when executing conntrack -L
>>> or cat /proc/net/nf_conntrack while rules being offloaded.
>>> Ct timeout is not maintained for offloaded flows as aging
>>> of offloaded flows are managed by the flow table offload infrastructure=
.
>>>
>>> Don't do garbage collection for offloaded flows when dumping the
>>> entries.
>>>
>>> Fixes: 90964016e5d3 ("netfilter: nf_conntrack: add IPS_OFFLOAD status=20
>>> bit")
>>> Signed-off-by: Roi Dayan <roid@nvidia.com>
>>> Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
>>> ---
>>> =C2=A0 include/net/netfilter/nf_conntrack.h | 2 +-
>>> =C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/include/net/netfilter/nf_conntrack.h=20
>>> b/include/net/netfilter/nf_conntrack.h
>>> index 439379ca9ffa..87c85109946a 100644
>>> --- a/include/net/netfilter/nf_conntrack.h
>>> +++ b/include/net/netfilter/nf_conntrack.h
>>> @@ -276,7 +276,7 @@ static inline bool nf_ct_is_expired(const struct=20
>>> nf_conn *ct)
>>> =C2=A0 static inline bool nf_ct_should_gc(const struct nf_conn *ct)
>>> =C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return nf_ct_is_expired(ct) && nf_ct_is_=
confirmed(ct) &&
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !nf_ct_is=
_dying(ct);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !nf_ct_is=
_dying(ct) && !test_bit(IPS_OFFLOAD_BIT,=20
>>> &ct->status);
>>
>> The gc_worker() calls nf_ct_offload_timeout() if the flow if
>> offloaded, so it extends the timeout to skip the garbage collection.
>>
>> Could you update ctnetlink_dump_table() and ct_seq_show() to extend
>> the timeout if the flow is offloaded?
>>
>> Thanks.
>>
>=20
> sure. i'll submit v2.
> thanks


Hi Pablo,

We did more tests with just updating the timeout in the 2 callers
and it's not enough. We reproduce the issue of rules being timed
out just now frim different place.
There is a 3rd caller nf_ct_gc_expired() which being called by 3
other callers:
____nf_conntrack_find()
nf_conntrack_tuple_taken()
early_drop_list()

only early_drop_list() has a check to skip conns with offload bit
but without extending the timeout.
I didnt do a dump but the issue could be from the other 2 calls.

With current commit as is I didn't need to check more callers as I made
sure all callers will skip the non-offload gc.
Instead of updating more callers and there might be more callers
later why current commit is not enough?
We skip offloaded flows and soon gc_worker() will hit and will update
the timeout anyway.

Thanks,
Roi
