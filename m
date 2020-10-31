Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956602A1AAE
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 22:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgJaVXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 17:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgJaVXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 17:23:52 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DFDC0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 14:23:51 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4CNscN49cKzQkjS;
        Sat, 31 Oct 2020 22:23:48 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604179426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LT3xg5Ir2jlkFo0Mnm97LXG03kaKxTFztyiisrubyTw=;
        b=W4e3DR0MTY9JVRexbW/rTInlgBzysd6LZ3iwir6LTMNggOu7mpYbEK7JIhiIysdql6+l9M
        oad8COmrrPEpsMgBGZv3yyopvPBT9EIklgHAowf/CNvY0NwCODDjLQyi4Grt1DpyG8/fe/
        sYV7sVvIEG/5yXrzp1x4IQG5/LM+WLFHHtsKtRfop+a83dsXXLH9vQ3phyMp90TjvOzCjY
        53Qw7ueMCl878My94zDrvJgYvxAkKnQg7fmXqjfpvU/K30tlGmcpCbSUx/5+5Yq9x5dCp5
        qRdJf/mn84KIFQYNFV6hMlE1fvPeydumuCyNZNBum+KNFLD1oTybHOrLKkIsAQ==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id KvCINi-HjWHd; Sat, 31 Oct 2020 22:23:45 +0100 (CET)
References: <cover.1604059429.git.me@pmachata.org> <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org> <0f017fbd-b8f5-0ebe-0c16-0d441b1d4310@gmail.com>
From:   Petr Machata <me@pmachata.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
Subject: Re: [PATCH iproute2-next v2 03/11] lib: utils: Add print_on_off_bool()
Message-ID: <87o8kihyy9.fsf@nvidia.com>
In-reply-to: <0f017fbd-b8f5-0ebe-0c16-0d441b1d4310@gmail.com>
Date:   Sat, 31 Oct 2020 22:23:43 +0100
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -2.79 / 15.00 / 15.00
X-Rspamd-Queue-Id: 665A51707
X-Rspamd-UID: 27745e
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

> On 10/30/20 6:29 AM, Petr Machata wrote:
>> diff --git a/lib/utils.c b/lib/utils.c
>> index 930877ae0f0d..8deec86ecbcd 100644
>> --- a/lib/utils.c
>> +++ b/lib/utils.c
>> @@ -1763,3 +1763,11 @@ int parse_on_off(const char *msg, const char *realval, int *p_err)
>>
>>  	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
>>  }
>> +
>> +void print_on_off_bool(FILE *fp, const char *flag, bool val)
>> +{
>> +	if (is_json_context())
>> +		print_bool(PRINT_JSON, flag, NULL, val);
>> +	else
>> +		fprintf(fp, "%s %s ", flag, val ? "on" : "off");
>> +}
>>
>
> I think print_on_off should be fine and aligns with parse_on_off once it
> returns a bool.

print_on_off() is already used in the RDMA tool, and actually outputs
"on" and "off", unlike this. So I chose this instead.

I could rename the RDMA one though -- it's used in two places, whereas
this is used in about two dozen instances across the codebase.
