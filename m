Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DAB291748
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 14:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgJRMQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 08:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgJRMQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 08:16:29 -0400
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD15C061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 05:16:29 -0700 (PDT)
Received: from vlad-x1g6 (unknown [IPv6:2a0b:2bc3:193f:1:a5fe:a7d6:6345:fe8d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 552D02028E;
        Sun, 18 Oct 2020 15:16:25 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1603023385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kmLBBKZovlf1n5VOCTxP5OBGJt3u6FcQkw3mYbZICBU=;
        b=OtYjeFsRdqSjwS6zlX14yHq/BM5h+baO2gMhG/57cp74KyOiw8l2ZZl0+l0BABaH36eRBH
        pzl1f4bjxXEZcIMUJktx+kewkhH9QCjwOE2IDdYLSVYNFlCxmJ31OKRiOIC677iFbp9YWY
        6PC8k5GWTHEj9NHrjiurHPg1ZxsrQtD/qVTuNMrURZpMAKjXq5fy8wT7bsphKVUQxylHo/
        4Ca3Gm5qWuietqwq9ytqH5KUz1ulmk2EWdsh0C/IGL0kppKeGrcV5UDcMsMwo00//yxb7x
        6CqhioNuuf61csmT6+DyAFT9B5mJdEOpF2SO94pO+vhJtlYCfUNhe8e17uKaFQ==
References: <20201016144205.21787-1-vladbu@nvidia.com> <20201016144205.21787-3-vladbu@nvidia.com> <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com> <87a6wm15rz.fsf@buslov.dev> <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com>
User-agent: mu4e 1.4.13; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>, dsahern@gmail.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
In-reply-to: <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com>
Date:   Sun, 18 Oct 2020 15:16:24 +0300
Message-ID: <877drn20h3.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 17 Oct 2020 at 14:20, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2020-10-16 12:42 p.m., Vlad Buslov wrote:
>
>>
>> All action print callbacks have arg==NULL check and return at the
>> beginning. To print action type we need either to have dedicated
>> 'brief_dump' callback instead of reusing print_aop() or extend/refactor
>> print_aop() implementation for all actions to always print the type
>> before checking the arg. What do you suggest?
>>
>
> Either one sounds appealing - the refactoring feels simpler
> as opposed to a->terse_print().

With such refactoring we action type will be printed before some basic
validation which can lead to outputting the type together with error
message. Consider tunnel key action output callback as example:

static int print_tunnel_key(struct action_util *au, FILE *f, struct rtattr *arg)
{
	struct rtattr *tb[TCA_TUNNEL_KEY_MAX + 1];
	struct tc_tunnel_key *parm;

	if (!arg)
		return 0;

	parse_rtattr_nested(tb, TCA_TUNNEL_KEY_MAX, arg);

	if (!tb[TCA_TUNNEL_KEY_PARMS]) {
		fprintf(stderr, "Missing tunnel_key parameters\n");
		return -1;
	}
	parm = RTA_DATA(tb[TCA_TUNNEL_KEY_PARMS]);

	print_string(PRINT_ANY, "kind", "%s ", "tunnel_key");

If print "kind" call is moved before checking the arg it will always be
printed, even when immediately followed by "Missing tunnel_key
parameters\n" string. Is this a concern?

>
> BTW: the action index, unless i missed something, is not transported
> from the kernel for terse option. It is an important parameter
> when actions are shared by filters (since they will have the same
> index).
> Am i missing something?

Yes, tc_action_ops->dump(), which outputs action index among other data,
is not called at all by terse dump.

>
> cheers,
> jamal

