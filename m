Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5812D292A34
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 17:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbgJSPSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 11:18:25 -0400
Received: from mail.buslov.dev ([199.247.26.29]:35337 "EHLO mail.buslov.dev"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729988AbgJSPSZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 11:18:25 -0400
Received: from vlad-x1g6 (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id EDF6A202B2;
        Mon, 19 Oct 2020 18:18:21 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1603120702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dWPtjcNu+EYakWMoGgmfZoLxX6kjw639jztydK2Mp3E=;
        b=SXPRoQ5reJR6Qya+TUQWxpVdTTXs5LwGpt53HW4ZO0jpRvSSHCIBk0VsqjhJSU16W90GAV
        Ye05pHYewa5xPgnpscmOWXxKD0uHA3gNK/FxzXbP4tpzKtK7Bo1sz52RoB7n523UWu7PfV
        M5xW0SEF7veM1vbjChupaU0Fl+Gnyq4zcISCOJ4BjEzKHaiY6Lt241rd54qU1Lx1+L9kN3
        KVJdYFD6wutkJxVLgoNu0qvzB4B8kAHXMP+faCaIwEKHKYPikjOND2ADyjTwpk4cQX9FFY
        7Fxucf9HS5OzriO3vRrYGejtcQrDsg/HhCvX8Tq5ZteD6ENY7PXmAVn1T5pnwA==
References: <20201016144205.21787-1-vladbu@nvidia.com> <20201016144205.21787-3-vladbu@nvidia.com> <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com> <87a6wm15rz.fsf@buslov.dev> <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com> <877drn20h3.fsf@buslov.dev> <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>, dsahern@gmail.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
In-reply-to: <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com>
Date:   Mon, 19 Oct 2020 18:18:20 +0300
Message-ID: <87362a1byb.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 19 Oct 2020 at 16:48, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2020-10-18 8:16 a.m., Vlad Buslov wrote:
>> On Sat 17 Oct 2020 at 14:20, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>> On 2020-10-16 12:42 p.m., Vlad Buslov wrote:
>>>
>
>>> Either one sounds appealing - the refactoring feels simpler
>>> as opposed to a->terse_print().
>>
>> With such refactoring we action type will be printed before some basic
>> validation which can lead to outputting the type together with error
>> message. Consider tunnel key action output callback as example:
>>
>> static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
>> {
>> 	struct rtattr *tb[TCA_TUNNEL_KEY_MAX + 1];
>> 	struct tc_tunnel_key *parm;
>>
>> 	if (!arg)
>> 		return 0;
>>
>> 	parse_rtattr_nested(tb, TCA_TUNNEL_KEY_MAX, arg);
>>
>> 	if (!tb[TCA_TUNNEL_KEY_PARMS]) {
>> 		fprintf(stderr, "Missing tunnel_key parameters\n");
>> 		return -1;
>> 	}
>> 	parm = RTA_DATA(tb[TCA_TUNNEL_KEY_PARMS]);
>>
>> 	print_string(PRINT_ANY, "kind", "%s ", "tunnel_key");
>>
>> If print "kind" call is moved before checking the arg it will always be
>> printed, even when immediately followed by "Missing tunnel_key
>> parameters\n" string. Is this a concern?
>>
>
> That could be a good thing, no? you get to see the action name with the
> error. Its really not a big deal if you decide to do a->terse_print()
> instead.

Maybe. Just saying that this change would also change user-visible
iproute2 behavior.

>
>>>
>>> BTW: the action index, unless i missed something, is not transported
>>> from the kernel for terse option. It is an important parameter
>>> when actions are shared by filters (since they will have the same
>>> index).
>>> Am i missing something?
>>
>> Yes, tc_action_ops->dump(), which outputs action index among other data,
>> is not called at all by terse dump.
>
> I am suggesting it is an important detail that is currently missing.
> Alternatively since you have the cookies in there - it is feasible that
> someone who creates the action could "encode" the index in the cookie.
> But that makes it a "proprietary" choice of whoever is creating
> the filter/action.

It is not a trivial change. To get this data we need to call
tc_action_ops->dump() which puts bunch of other unrelated info in
TCA_OPTIONS nested attr. This hurts both dump size and runtime
performance. Even if we add another argument to dump "terse dump, print
only index", index is still part of larger options structure which
includes at least following fields:

#define tc_gen \
	__u32                 index; \
	__u32                 capab; \
	int                   action; \
	int                   refcnt; \
	int                   bindcnt

This wouldn't be much of a terse dump anymore. What prevents user that
needs all action info from calling regular dump? It is not like terse
dump substitutes it or somehow makes it harder to use.

>
> cheers,
> jamal

