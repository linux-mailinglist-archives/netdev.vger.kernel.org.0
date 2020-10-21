Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6784F294945
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 10:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502256AbgJUIT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 04:19:58 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4431 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408686AbgJUIT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 04:19:57 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8feecf0000>; Wed, 21 Oct 2020 01:18:23 -0700
Received: from reg-r-vrt-018-180.nvidia.com (172.20.13.39) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 21 Oct 2020 08:19:44 +0000
References: <20201016144205.21787-1-vladbu@nvidia.com> <20201016144205.21787-3-vladbu@nvidia.com> <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com> <87a6wm15rz.fsf@buslov.dev> <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com> <877drn20h3.fsf@buslov.dev> <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com> <87362a1byb.fsf@buslov.dev> <5c79152f-1532-141a-b1d3-729fdd798b3f@mojatatu.com>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Vlad Buslov <vlad@buslov.dev>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <ivecera@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
In-Reply-To: <5c79152f-1532-141a-b1d3-729fdd798b3f@mojatatu.com>
Message-ID: <ygnh8sc03s9u.fsf@nvidia.com>
Date:   Wed, 21 Oct 2020 11:19:41 +0300
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603268303; bh=pXWiSmM4edHjjS3N1NcnwzbdF7SLyaJB5iAtJDQxW3U=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Message-ID:
         Date:MIME-Version:Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=dE4Z32kQkFxCM0krJBgEa5YZZiABoTB10k8HyFzPlCNOEULYDENpJIA83pEFiZvN/
         fhjdQHfj/GOwD/V0s0i4W7iNoSacO3osGUi60MJlFkUquLggpMBJFsusUh+Pyyhikk
         nXFtz8RbQCsEh6DZjQkykM9Qer21JiP4zQhW5bKu4GPvTN8X6o8tuz1Z8epNtyGCrt
         PhaDIIwAvPQyv2cvzijSKqsT5WDEZE8cSWWOiPSLGNp1I63EWiIw2CAPtcrfLFhmRa
         2lcxH/QifDBqpkq62djiPDTmPrFofqiDLQ/rIZYjrK6sVf3TZx4Y64zOZX1wQk/cBO
         hTLKn1rNhRshg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 20 Oct 2020 at 15:29, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2020-10-19 11:18 a.m., Vlad Buslov wrote:
>>
>> On Mon 19 Oct 2020 at 16:48, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>> On 2020-10-18 8:16 a.m., Vlad Buslov wrote:
>
> [..]
>
>>> That could be a good thing, no? you get to see the action name with the
>>> error. Its really not a big deal if you decide to do a->terse_print()
>>> instead.
>>
>> Maybe. Just saying that this change would also change user-visible
>> iproute2 behavior.
>>
>
> You are right(for the non-terse output). tbh, not sure if it is a big
> deal given it happens only for the error case (where scripts look
> for exit codes typically); having said that:
> a ->terse_print() would be ok
>
>> It is not a trivial change. To get this data we need to call
>> tc_action_ops->dump() which puts bunch of other unrelated info in
>> TCA_OPTIONS nested attr. This hurts both dump size and runtime
>> performance. Even if we add another argument to dump "terse dump, print
>> only index", index is still part of larger options structure which
>> includes at least following fields:
>>
>> #define tc_gen \
>> 	__u32                 index; \
>> 	__u32                 capab; \
>> 	int                   action; \
>> 	int                   refcnt; \
>> 	int                   bindcnt
>>
>
>
> index is the _only_ important field for analytics purposes in that list.
> i.e if i know the index i can correlate stats with one or more
> filters (whether shared or not).
> My worry is you have a very specific use case for your hardware or
> maybe it is ovs - where counters are uniquely tied to filters and
> there is no sharing. And possibly maybe only one counter can be tied
> to a filter (was not sure if you could handle more than one action
> in the terse from looking at the code).

OVS uses cookie to uniquely identify the flow and it does support
multiple actions per flow.

> Our assumptions so far had no such constraints.
> Maybe a new TERSE_OPTIONS TLV, and then add an extra flag
> to indicate interest in the tlv? Peharps store the stats in it as well.

Maybe, but wouldn't that require making it a new dump mode? Current
terse dump is already in released kernel and this seems like a
backward-incompatible change.

>
>> This wouldn't be much of a terse dump anymore. What prevents user that
>> needs all action info from calling regular dump? It is not like terse
>> dump substitutes it or somehow makes it harder to use.
>
> Both scaling and correctness are important. You have the cookie
> in the terse dump, thats a lot of data.

Cookie only consumes space in resulting netlink packet if used set the
cookie during action init. Otherwise, the cookie attribute is omitted.

> In our case we totally bypass filters to reduce the amount of data
> crossing to user space (tc action ls). Theres still a lot of data
> crossing which we could trim with a terse dump. All we are interested
> in are stats. Another alternative is perhaps to introduce the index for
> the direct dump.

What is the direct dump?

>
> cheers,
> jamal

