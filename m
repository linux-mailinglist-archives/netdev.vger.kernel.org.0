Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B632A36E6
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgKBXFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgKBXFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 18:05:30 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41D8C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 15:05:29 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CQ7mk0pXvzQlB2;
        Tue,  3 Nov 2020 00:05:26 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604358324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+M48Wh23aINc2ZS4RkM4uRkUt0sUzDc26fJ0GJZ0zSg=;
        b=NeQQMHHddhp77LKouHNyf/4XG8DV4h9oPgIJ8xcHRUgGmINtNmTQC+rGl4e2im4jdJlV1X
        mixyR2/nViwF8J2eILZA9f15h/5VzWvlYRYzu9Ky128yCqDT+uAH/Hd40x3o+t7mTUa2+N
        HKuN/7XFIGnSky5dL7MNSM1FU20WmYLkCZ/fHio42zFRCebXv88myYltSoGYINdqei8NVH
        hZsMjZaFu/9Af7Mft1XWBIQb+wB2udFwbvhvINQDTqFIHLlAtbdnfq6vMMRCtg1Pf+eHxE
        +uYyU8Je3XG07+v8DSp/YiszeKDdx+gBtfv7vC9anYvp4PI9kPXNVCy2l9EVfA==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id LjdF8itt85n2; Tue,  3 Nov 2020 00:05:22 +0100 (CET)
References: <cover.1604059429.git.me@pmachata.org> <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org> <0f017fbd-b8f5-0ebe-0c16-0d441b1d4310@gmail.com> <87o8kihyy9.fsf@nvidia.com> <b0cc6bd4-e4e6-22ba-429d-4cea7996ccd4@gmail.com> <20201102063752.GE5429@unreal>
From:   Petr Machata <me@pmachata.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
Subject: Re: [PATCH iproute2-next v2 03/11] lib: utils: Add print_on_off_bool()
In-reply-to: <20201102063752.GE5429@unreal>
Date:   Tue, 03 Nov 2020 00:05:20 +0100
Message-ID: <87h7q7iclr.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.41 / 15.00 / 15.00
X-Rspamd-Queue-Id: CF18C170E
X-Rspamd-UID: bf94b5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Leon Romanovsky <leon@kernel.org> writes:

> On Sun, Nov 01, 2020 at 04:55:42PM -0700, David Ahern wrote:
>> On 10/31/20 3:23 PM, Petr Machata wrote:
>> >
>> > David Ahern <dsahern@gmail.com> writes:
>> >
>> >> On 10/30/20 6:29 AM, Petr Machata wrote:
>> >>> diff --git a/lib/utils.c b/lib/utils.c
>> >>> index 930877ae0f0d..8deec86ecbcd 100644
>> >>> --- a/lib/utils.c
>> >>> +++ b/lib/utils.c
>> >>> @@ -1763,3 +1763,11 @@ int parse_on_off(const char *msg, const char *realval, int *p_err)
>> >>>
>> >>>  	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
>> >>>  }
>> >>> +
>> >>> +void print_on_off_bool(FILE *fp, const char *flag, bool val)
>> >>> +{
>> >>> +	if (is_json_context())
>> >>> +		print_bool(PRINT_JSON, flag, NULL, val);
>> >>> +	else
>> >>> +		fprintf(fp, "%s %s ", flag, val ? "on" : "off");
>> >>> +}
>> >>>
>> >>
>> >> I think print_on_off should be fine and aligns with parse_on_off once it
>> >> returns a bool.
>> >
>> > print_on_off() is already used in the RDMA tool, and actually outputs
>> > "on" and "off", unlike this. So I chose this instead.
>> >
>> > I could rename the RDMA one though -- it's used in two places, whereas
>> > this is used in about two dozen instances across the codebase.
>> >
>>
>> yes, the rdma utils are using generic function names. The rdma version
>> should be renamed; perhaps rd_print_on_off. That seems to be once common
>> prefix. Added Leon.
>
> I made fast experiment and the output for the code proposed here and existed
> in the RDMAtool - result the same. So the good thing will be to delete the
> function from the RDMA after print_on_off_bool() will be improved.

The RDMAtool uses literal "on" and "off" as values in JSON, not
booleans. Moving over to print_on_off_bool() would be a breaking change,
which is problematic especially in JSON output.

> However I don't understand why print_on_off_bool() is implemented in
> utils.c and not in lib/json_print.c that properly handles JSON context,

There's a whole lot of print_X functions for printing non-fundamental
data types in utils.c. Seemed obvious to put it there. I can move it to
json_print.c, no problem.

I think the current function does handle JSON context, what else do
you have in mind?

> provide colorized output and doesn't require to supply FILE *fp.

Stephen Hemminger already pointed out the FILE *fp bit, I'll be removing
it.
