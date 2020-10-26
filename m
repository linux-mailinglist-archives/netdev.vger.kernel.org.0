Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A82298C20
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 12:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773802AbgJZL3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 07:29:06 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6498 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1773797AbgJZL3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 07:29:05 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f96b2eb0005>; Mon, 26 Oct 2020 04:28:43 -0700
Received: from reg-r-vrt-018-180.nvidia.com (172.20.13.39) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Mon, 26 Oct 2020 11:28:54 +0000
References: <20201016144205.21787-1-vladbu@nvidia.com> <20201016144205.21787-3-vladbu@nvidia.com> <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com> <87a6wm15rz.fsf@buslov.dev> <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com> <877drn20h3.fsf@buslov.dev> <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com> <87362a1byb.fsf@buslov.dev> <5c79152f-1532-141a-b1d3-729fdd798b3f@mojatatu.com> <ygnh8sc03s9u.fsf@nvidia.com> <e91b2fe6-e2ca-21c7-0d7e-714e5cccc28c@mojatatu.com> <ygnh4kml9kh3.fsf@nvidia.com> <89a5434b-06e9-947a-d364-acd2a306fc4d@mojatatu.com>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Vlad Buslov <vlad@buslov.dev>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <ivecera@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
In-Reply-To: <89a5434b-06e9-947a-d364-acd2a306fc4d@mojatatu.com>
Message-ID: <ygnh7drdz0nf.fsf@nvidia.com>
Date:   Mon, 26 Oct 2020 13:28:52 +0200
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603711723; bh=ZdoAuWOChUe5Sp+ew4uPl+EHHgaPLwQX3PCIU/K5MPk=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Message-ID:
         Date:MIME-Version:Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=Mj38MfFBz45NuwtPQi0LOcPQAAb7lth7UwUoBBXUBelTa2X5zhslH4NbSwtL+v1aH
         KHo/y/jrWDqVh0rcSBOyIbFSR6JX9jjUhwCqwKFaTpFKvb+H16tNX4yKRvH9c16XAN
         gpJ1r1TSqJo+rk9s949A1s30RCpQDKQKquRBldakOx/yn0LRCsnZrTWnj+vXkES1sc
         CpPy3uY98OjpeOTlzyBVY/CzFy8/PQnoGD2XLIIi7HDa6UTyc1di7ar8dXX3j8qfr1
         ohl4tqhvJIZTY9PO6O6HMR6zlFB7iq93wv+E45bYIOFMDfyY6D6YRzTnpRkl6UoiFm
         HDDsaYb9x0HpA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat 24 Oct 2020 at 20:40, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2020-10-23 8:48 a.m., Vlad Buslov wrote:
>> On Thu 22 Oct 2020 at 17:05, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>> On 2020-10-21 4:19 a.m., Vlad Buslov wrote:
>>>>
>>>> On Tue 20 Oct 2020 at 15:29, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>>>> On 2020-10-19 11:18 a.m., Vlad Buslov wrote:
>>>>> My worry is you have a very specific use case for your hardware or
>>>>> maybe it is ovs - where counters are uniquely tied to filters and
>>>>> there is no sharing. And possibly maybe only one counter can be tied
>>>>> to a filter (was not sure if you could handle more than one action
>>>>> in the terse from looking at the code).
>>>>
>>>> OVS uses cookie to uniquely identify the flow and it does support
>>>> multiple actions per flow.
>>>
>>>
>>> ok, so they use it like a flowid/classid to identify the flow.
>>> In our use case the cookie stores all kinds of other state that
>>> the controller can avoid to lookup after a query.
>>> index otoh is universal i.e two different users can intepret it
>>> per action tying it specific stats.
>>> IOW: I dont think it replaces the index.
>>> Do they set cookies on all actions in a flow?
>>
>> AFAIK on only one action per flow.
>>
>
> To each their own i guess. Sounds like it is being used as flowid
> entity.
> We pack a lot of metaencoding into those cookies. And to us
> a "service" is essentially a filter match folowed by a graph
> of actions (which could cyclic).
>
>
>>>> Cookie only consumes space in resulting netlink packet if used set the
>>>> cookie during action init. Otherwise, the cookie attribute is omitted.
>>>
>>> True, but: I am wondering why it is even considered in when terseness
>>> was a requirement (and index was left out).
>>
>> There was several reasons for me to include it:
>>
>> - As I wrote in previous email its TLV is only included in dump if user
>>    set the cookie. Users who don't use cookies don't lose any performance
>>    of terse dump.
>>
>> - Including it didn't require any changes to tc_action_ops->dump() (like
>>    passing 'terse' flag or introducing dedicated terse_dump() callback)
>>    because it is processed in tcf_action_dump_1().
>>
>> - OVS was the main use-case for us because it relies on filter dump for
>>    flow revalidation and uses cookie to identify the flows.
>>
>
> Which is fine - but it is a very ovs specific need.
>>>
>>>>> In our case we totally bypass filters to reduce the amount of data
>>>>> crossing to user space (tc action ls). Theres still a lot of data
>>>>> crossing which we could trim with a terse dump. All we are interested
>>>>> in are stats. Another alternative is perhaps to introduce the index for
>>>>> the direct dump.
>>>>
>>>> What is the direct dump?
>>>
>>> tc action ls ...
>>> Like i said in our use cases to get the stats we just dumped the actions
>>> we wanted. It is a lot less data than having the filter + actions.
>>> And with your idea of terseness we can trim down further how much
>>> data by removing all the action attributes coming back if we set TERSE
>>> flag in such a request. But the index has to be there to make sense.
>>
>> Yes, that makes sense. I guess introducing something like 'tc action -br
>> ls ..' mode implemented by means of existing terse flag + new 'also
>> output action index' flag would achieve that goal.
>>
>
> Right. There should be no interest in the cookie here at all. Maybe
> it could be optional with a flag indication.
> Have time to cook a patch? I'll taste/test it.

Patch to make cookie in filter terse dump optional? That would break
existing terse dump users that rely on it (OVS).

>
> cheers,
> jamal

