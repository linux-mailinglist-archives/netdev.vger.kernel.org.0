Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D5530C721
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbhBBRLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:11:53 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8615 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237117AbhBBRJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 12:09:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019871b0001>; Tue, 02 Feb 2021 09:08:43 -0800
Received: from [172.27.14.97] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 17:08:42 +0000
Subject: Re: [PATCH net 1/1] netfilter: conntrack: Check offload bit on table
 dump
To:     Florian Westphal <fw@strlen.de>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>, <netdev@vger.kernel.org>,
        "Paul Blakey" <paulb@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
References: <20210128074052.777999-1-roid@nvidia.com>
 <20210130120114.GA7846@salvia>
 <3a29e9b5-7bf8-5c00-3ede-738f9b4725bf@nvidia.com>
 <997cbda4-acd1-a000-1408-269bc5c3abf3@nvidia.com>
 <20210201030853.GA19878@salvia>
 <1229b966-7772-44bd-6e91-fbde213ceb2d@nvidia.com>
 <20210201115036.GB12443@breakpoint.cc>
 <edb8da93-d859-e7ae-53dd-cae09dff2eba@nvidia.com>
 <20210201152534.GJ12443@breakpoint.cc>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <a908ac8f-1fb4-1427-520d-3a702ecb7597@nvidia.com>
Date:   Tue, 2 Feb 2021 19:08:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210201152534.GJ12443@breakpoint.cc>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612285723; bh=hOSw2ZhXuQOzZH/9k7MBONDijxApRZikufOJeOnJ2Xc=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=ZiYx4R5IaZD0uCNmY4cJEaq/vnSiLIEL2jLyjKoKV56eBPUMUCrB+t28NBuppBBmU
         u9DuSttHqgAW+dBvNx7IQHPalQ5MlwhQqeBAqzQnVnFBYi09g1gfeDeaYXQqToCcN/
         37/YWAcYj8gzCRV9Nlua79DFSd+NbAK6IJaA8Np1MhQdA/05+1N6n6l5/xJ1lExcvU
         ZNWuuFVJAjupoJJ6cxPZOvf+uLwy6yfZZKemZms/vmv4RPf7MNAdM9vNo94tlqkfNF
         RI2TnNEDlPj/oq8LfCl75j/W0TJhBqB5lUTRkzxtIRy2rWQmQL/8kzG6XKLG0sWPEA
         yu5ObGaS2vacg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-02-01 5:25 PM, Florian Westphal wrote:
> Roi Dayan <roid@nvidia.com> wrote:
>>> TCP initial timeout is one minute, UDP 30 seconds.
>>> That should surely be enough to do flow_offload_add (which extends
>>> the timeout)?
>>
>> Yes, flow_offload_add() extends the timeout. but it needs to finish.
>>
>>>
>>> Maybe something is doing flow_offload_add() for unconfirmed conntrack?
>>>
>>> In unconfirmed conntrack case, ct->timeout is absolute timeout value, e.g. for
>>> tcp it will be set to 60 * HZ.
>>
>> When I hit the issue I printed jiffies and ct->timeout and saw they are
>> the same or very close but not an absolute number.
> 
> Thats strange, for new flows they should not be close at all.
> UDP sets a 30 second timeout, TCP sets a 60 second initial timeout.
> 
> Do you think rhashtable_insert_fast() in flow_offload_add() blocks for
> dozens of seconds?

I'm not sure. but its not only that but also the time to be in
established state as only then we offload.

> 
> Thats about the only thing I can see between 'offload bit gets set'
> and 'timeout is extended' in flow_offload_add() that could at least
> spend *some* time.
> 
>> We hit this issue before more easily and pushed this fix
>>
>> 4203b19c2796 netfilter: flowtable: Set offload timeout when adding flow
> 
> This fix makes sense to me.
> 


I just noted we didn't test correctly Pablo's suggestion instead of
to check the bit and extend the timeout in ctnetlink_dump_table() and
ct_seq_show() like GC does.
We replaced nf_conntrack module but not nf_conntrack_netlink and tested
with conntrack -L.
We redo the test and replaced correct modules and it looks ok now.
We still need to run the long test to be sure but is that still
a good option as a fix?

