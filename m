Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D71275CBB
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 18:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgIWQEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 12:04:30 -0400
Received: from mail.efficios.com ([167.114.26.124]:35626 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgIWQE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 12:04:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id EEAFA2CB55D;
        Wed, 23 Sep 2020 12:04:27 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 8lXWDWbGLAAe; Wed, 23 Sep 2020 12:04:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 9287D2CBBAB;
        Wed, 23 Sep 2020 12:04:27 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 9287D2CBBAB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1600877067;
        bh=ilJP4P+b5zd06K+09mhQTiXAXrwBtZ+Qj36UF8Qgz7U=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=mvlAVO287lXGhlqxOYNMvbiTMRkZpQRx3P6vvlaMOlXRnLBNS6qT+NVGjDqgjAbOw
         Y/qxt5WhuhX5+21U/W/Esf+uvBoYrl/QIaBhIfAhmFHdcCu4ZsFfpdhd6PK2iHc2ov
         /5HVa9Y2tA4EHUMagYSeq/XusPO3jk2KYjjQqgQphSaqBSbujSror1hSDtshLdJ+os
         xvJwm1zxFyWdWQOfbsjrejrnGE73Ukphp+/3JwTiQcKV9Tz4pJKpfV6jfyJcF4KY2q
         qj8tsJF25EjUF0pxzzrdobBNovEeOWvdH1F3Jwzr8pegQJkyw5V8IL3vS+TMTiB1/u
         cXRCk7v9Zz/lA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hiXAN2-NHCbA; Wed, 23 Sep 2020 12:04:27 -0400 (EDT)
Received: from [10.10.0.55] (96-127-212-112.qc.cable.ebox.net [96.127.212.112])
        by mail.efficios.com (Postfix) with ESMTPSA id 669042CB676;
        Wed, 23 Sep 2020 12:04:27 -0400 (EDT)
Subject: Re: [RFC PATCH v2 0/3] l3mdev icmp error route lookup fixes
To:     David Ahern <dsahern@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     David <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200918181801.2571-1-mathieu.desnoyers@efficios.com>
 <390b230b-629b-7f96-e7c9-b28f8b592102@gmail.com>
 <1453768496.36855.1600713879236.JavaMail.zimbra@efficios.com>
 <dd1caf15-2ef0-f557-b9a8-26c46739f20b@gmail.com>
 <1383129694.37216.1600716821449.JavaMail.zimbra@efficios.com>
 <1135414696.37989.1600782730509.JavaMail.zimbra@efficios.com>
 <4456259a-979a-7821-ef3d-aed5d330ed2b@gmail.com>
From:   Michael Jeanson <mjeanson@efficios.com>
Message-ID: <730d8a09-7d3b-1033-4131-520dc42e8855@efficios.com>
Date:   Wed, 23 Sep 2020 12:04:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <4456259a-979a-7821-ef3d-aed5d330ed2b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-22 21 h 59, David Ahern wrote:
> On 9/22/20 7:52 AM, Michael Jeanson wrote:
>>>>
>>>> the test setup is bad. You have r1 dropping the MTU in VRF red, but not
>>>> telling VRF red how to send back the ICMP. e.g., for IPv4 add:
>>>>
>>>>     ip -netns r1 ro add vrf red 172.16.1.0/24 dev blue
>>>>
>>>> do the same for v6.
>>>>
>>>> Also, I do not see a reason for r2; I suggest dropping it. What you are
>>>> testing is icmp crossing VRF with route leaking, so there should not be
>>>> a need for r2 which leads to asymmetrical routing (172.16.1.0 via r1 and
>>>> the return via r2).
>>
>> The objective of the test was to replicate a clients environment where
>> packets are crossing from a VRF which has a route back to the source to
>> one which doesn't while reaching a ttl of 0. If the route lookup for the
>> icmp error is done on the interface in the first VRF, it can be routed to
>> the source but not on the interface in the second VRF which is the
>> current behaviour for icmp errors generated while crossing between VRFs.
>>
>> There may be a better test case that doesn't involve asymmetric routing
>> to test this but it's the only way I found to replicate this.
>>
> 
> It should work without asymmetric routing; adding the return route to
> the second vrf as I mentioned above fixes the FRAG_NEEDED problem. It
> should work for TTL as well.
> 
> Adding a second pass on the tests with the return through r2 is fine,
> but add a first pass for the more typical case.

Hi,

Before writing new tests I just want to make sure we are trying to fix 
the same issue. If I add a return route to the red VRF then we don't
need this patchset because whether the ICMP error are routed using the
table from the source or destination interface they will reach the 
source host.

The issue for which this patchset was sent only happens when the 
destination interface's VRF doesn't have a route back to the source 
host. I guess we might question if this is actually a bug or not.

So the question really is, when a packet is forwarded between VRFs 
through route leaking and an icmp error is generated, which table should 
be used for the route lookup? And does it depend on the type of icmp 
error? (e.g. TTL=1 happens before forwarding, but fragmentation needed 
happens after when on the destination interface)

Cheers,

Michael

