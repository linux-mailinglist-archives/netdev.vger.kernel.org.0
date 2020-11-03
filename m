Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E1E2A3CBE
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 07:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbgKCGYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 01:24:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgKCGYK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 01:24:10 -0500
Received: from localhost (host-213-179-129-39.customer.m-online.net [213.179.129.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C59BA22277;
        Tue,  3 Nov 2020 06:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604384650;
        bh=6kB46InSxG/66gRSc8otCEZ96cpQl84wUgxNRyyUmKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dssoV31DMFDsN8cqYY+nSu60WfrolKVXCO3eBz5u3wFp7lriCgf+iBJKonGkEw4ql
         E64rmBhHB9jQyNNbIIvnBYNZqLeZiWxqK4q7uBPLARnJjQnvSk89SGZBeja2K2QW76
         0fyjlIqVbLNKZvcSmwJsn9r/jXEQ2F7Zu+LBil2M=
Date:   Tue, 3 Nov 2020 08:24:06 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Petr Machata <me@pmachata.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
Subject: Re: [PATCH iproute2-next v2 03/11] lib: utils: Add
 print_on_off_bool()
Message-ID: <20201103062406.GH5429@unreal>
References: <cover.1604059429.git.me@pmachata.org>
 <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org>
 <0f017fbd-b8f5-0ebe-0c16-0d441b1d4310@gmail.com>
 <87o8kihyy9.fsf@nvidia.com>
 <b0cc6bd4-e4e6-22ba-429d-4cea7996ccd4@gmail.com>
 <20201102063752.GE5429@unreal>
 <87h7q7iclr.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7q7iclr.fsf@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 12:05:20AM +0100, Petr Machata wrote:
>
> Leon Romanovsky <leon@kernel.org> writes:
>
> > On Sun, Nov 01, 2020 at 04:55:42PM -0700, David Ahern wrote:
> >> On 10/31/20 3:23 PM, Petr Machata wrote:
> >> >
> >> > David Ahern <dsahern@gmail.com> writes:
> >> >
> >> >> On 10/30/20 6:29 AM, Petr Machata wrote:
> >> >>> diff --git a/lib/utils.c b/lib/utils.c
> >> >>> index 930877ae0f0d..8deec86ecbcd 100644
> >> >>> --- a/lib/utils.c
> >> >>> +++ b/lib/utils.c
> >> >>> @@ -1763,3 +1763,11 @@ int parse_on_off(const char *msg, const char *realval, int *p_err)
> >> >>>
> >> >>>  	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
> >> >>>  }
> >> >>> +
> >> >>> +void print_on_off_bool(FILE *fp, const char *flag, bool val)
> >> >>> +{
> >> >>> +	if (is_json_context())
> >> >>> +		print_bool(PRINT_JSON, flag, NULL, val);
> >> >>> +	else
> >> >>> +		fprintf(fp, "%s %s ", flag, val ? "on" : "off");
> >> >>> +}
> >> >>>
> >> >>
> >> >> I think print_on_off should be fine and aligns with parse_on_off once it
> >> >> returns a bool.
> >> >
> >> > print_on_off() is already used in the RDMA tool, and actually outputs
> >> > "on" and "off", unlike this. So I chose this instead.
> >> >
> >> > I could rename the RDMA one though -- it's used in two places, whereas
> >> > this is used in about two dozen instances across the codebase.
> >> >
> >>
> >> yes, the rdma utils are using generic function names. The rdma version
> >> should be renamed; perhaps rd_print_on_off. That seems to be once common
> >> prefix. Added Leon.
> >
> > I made fast experiment and the output for the code proposed here and existed
> > in the RDMAtool - result the same. So the good thing will be to delete the
> > function from the RDMA after print_on_off_bool() will be improved.
>
> The RDMAtool uses literal "on" and "off" as values in JSON, not
> booleans. Moving over to print_on_off_bool() would be a breaking change,
> which is problematic especially in JSON output.

Nothing prohibits us from adding extra parameter to this new
function/json logic/json type that will control JSON behavior. Personally,
I don't think that json and stdout outputs should be different, e.g. 1/0 for
the json and on/off for the stdout.

>
> > However I don't understand why print_on_off_bool() is implemented in
> > utils.c and not in lib/json_print.c that properly handles JSON context,
>
> There's a whole lot of print_X functions for printing non-fundamental
> data types in utils.c. Seemed obvious to put it there. I can move it to
> json_print.c, no problem.

It looks like it is worth to cleanup util.c and make sure that all
prints are gathered in one place. Out of the scope for this series.

>
> I think the current function does handle JSON context, what else do
> you have in mind?a

It handles, but does it twice, first time for is_json_context() and
second time inside print_bool.

>
> > provide colorized output and doesn't require to supply FILE *fp.
>
> Stephen Hemminger already pointed out the FILE *fp bit, I'll be removing
> it.
