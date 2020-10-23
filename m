Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C1D296FB1
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 14:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464051AbgJWMsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 08:48:38 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2321 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S369897AbgJWMsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 08:48:38 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f92d0f50000>; Fri, 23 Oct 2020 05:47:49 -0700
Received: from reg-r-vrt-018-180.nvidia.com (10.124.1.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Fri, 23 Oct 2020 12:48:27 +0000
References: <20201016144205.21787-1-vladbu@nvidia.com> <20201016144205.21787-3-vladbu@nvidia.com> <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com> <87a6wm15rz.fsf@buslov.dev> <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com> <877drn20h3.fsf@buslov.dev> <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com> <87362a1byb.fsf@buslov.dev> <5c79152f-1532-141a-b1d3-729fdd798b3f@mojatatu.com> <ygnh8sc03s9u.fsf@nvidia.com> <e91b2fe6-e2ca-21c7-0d7e-714e5cccc28c@mojatatu.com>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Vlad Buslov <vlad@buslov.dev>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <ivecera@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
In-Reply-To: <e91b2fe6-e2ca-21c7-0d7e-714e5cccc28c@mojatatu.com>
Message-ID: <ygnh4kml9kh3.fsf@nvidia.com>
Date:   Fri, 23 Oct 2020 15:48:24 +0300
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603457269; bh=nGJ+PxyBQ1MxIkYk6m9C6HrKsj0vSvzc12wyAhfhnYw=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Message-ID:
         Date:MIME-Version:Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=ZlOHXLewtVyAEuyHsVBlFJZqdlhLaJ/cpp4SB/qKAaqqFrw4iHjsE0WlqAjE3SVi0
         5l2IA6e/jt00Sb9U+gJq7DIYtAD39gw5SXRdbxrSxya6aVkyL10fHkdPRI9I8THaX6
         tV7hjimy62CrksMvMDms5J1jKVPDaNIYDjYzdoWbgHWOfg/G5aetTNpZAL7/BZi2/g
         JLbBXGRF+bpJdjdLj3dTiHMJTA4/bOTyhXT0Q5yHXDXI8A8HT3F0VgC7FjR1eC+IHg
         xvuqjJBAeUh5dqDaZBPiBojRVdCp4ZHhurgtrcKhUpvq2cqTrE5PKmn/oA+14LN3Ye
         1WZaY2jAq9Yag==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 22 Oct 2020 at 17:05, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2020-10-21 4:19 a.m., Vlad Buslov wrote:
>>
>> On Tue 20 Oct 2020 at 15:29, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>> On 2020-10-19 11:18 a.m., Vlad Buslov wrote:
>>> My worry is you have a very specific use case for your hardware or
>>> maybe it is ovs - where counters are uniquely tied to filters and
>>> there is no sharing. And possibly maybe only one counter can be tied
>>> to a filter (was not sure if you could handle more than one action
>>> in the terse from looking at the code).
>>
>> OVS uses cookie to uniquely identify the flow and it does support
>> multiple actions per flow.
>
>
> ok, so they use it like a flowid/classid to identify the flow.
> In our use case the cookie stores all kinds of other state that
> the controller can avoid to lookup after a query.
> index otoh is universal i.e two different users can intepret it
> per action tying it specific stats.
> IOW: I dont think it replaces the index.
> Do they set cookies on all actions in a flow?

AFAIK on only one action per flow.

>
>
>>> Our assumptions so far had no such constraints.
>>> Maybe a new TERSE_OPTIONS TLV, and then add an extra flag
>>> to indicate interest in the tlv? Peharps store the stats in it as well.
>>
>> Maybe, but wouldn't that require making it a new dump mode? Current
>> terse dump is already in released kernel and this seems like a
>> backward-incompatible change.
>>
>
> I meant you would set a new flag(in addition to TERSE) in a request to
> the kernel to ask for the index to be made available on the response.
> Response comes back in a TLV with just index in it for now.

Makes sense.

>
>>>
>>>> This wouldn't be much of a terse dump anymore. What prevents user that
>>>> needs all action info from calling regular dump? It is not like terse
>>>> dump substitutes it or somehow makes it harder to use.
>>>
>>> Both scaling and correctness are important. You have the cookie
>>> in the terse dump, thats a lot of data.
>>
>> Cookie only consumes space in resulting netlink packet if used set the
>> cookie during action init. Otherwise, the cookie attribute is omitted.
>
> True, but: I am wondering why it is even considered in when terseness
> was a requirement (and index was left out).

There was several reasons for me to include it:

- As I wrote in previous email its TLV is only included in dump if user
  set the cookie. Users who don't use cookies don't lose any performance
  of terse dump.

- Including it didn't require any changes to tc_action_ops->dump() (like
  passing 'terse' flag or introducing dedicated terse_dump() callback)
  because it is processed in tcf_action_dump_1().

- OVS was the main use-case for us because it relies on filter dump for
  flow revalidation and uses cookie to identify the flows.

>
>>> In our case we totally bypass filters to reduce the amount of data
>>> crossing to user space (tc action ls). Theres still a lot of data
>>> crossing which we could trim with a terse dump. All we are interested
>>> in are stats. Another alternative is perhaps to introduce the index for
>>> the direct dump.
>>
>> What is the direct dump?
>
> tc action ls ...
> Like i said in our use cases to get the stats we just dumped the actions
> we wanted. It is a lot less data than having the filter + actions.
> And with your idea of terseness we can trim down further how much
> data by removing all the action attributes coming back if we set TERSE
> flag in such a request. But the index has to be there to make sense.

Yes, that makes sense. I guess introducing something like 'tc action -br
ls ..' mode implemented by means of existing terse flag + new 'also
output action index' flag would achieve that goal.

>
> cheers,
> jamal

