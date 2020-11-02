Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755862A24D3
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 07:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgKBGh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 01:37:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgKBGh4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 01:37:56 -0500
Received: from localhost (host-213-179-129-39.customer.m-online.net [213.179.129.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F9CE221FF;
        Mon,  2 Nov 2020 06:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604299076;
        bh=8BcVj2gBNOXnnMhrEt9cGloQ12Ld5Sii+nKHpr0EcLU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f5VCXjEjlPCGxvLNAGZJTL0eJuDUxxSUTaa7JKHNaToYdzA+VRvs8pyOy4QnbFb/Z
         ZSY+qoAevJyjnlwZuBWMB8cT8Lpynzvw16NOV9Ye+t2alloxJj5PDrH1i978NVBAh8
         zpzsMo3pcFMFKWxlJPAQK6BElTW85eD6+hOaxUnY=
Date:   Mon, 2 Nov 2020 08:37:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Petr Machata <me@pmachata.org>, netdev@vger.kernel.org,
        stephen@networkplumber.org, john.fastabend@gmail.com,
        jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
Subject: Re: [PATCH iproute2-next v2 03/11] lib: utils: Add
 print_on_off_bool()
Message-ID: <20201102063752.GE5429@unreal>
References: <cover.1604059429.git.me@pmachata.org>
 <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org>
 <0f017fbd-b8f5-0ebe-0c16-0d441b1d4310@gmail.com>
 <87o8kihyy9.fsf@nvidia.com>
 <b0cc6bd4-e4e6-22ba-429d-4cea7996ccd4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0cc6bd4-e4e6-22ba-429d-4cea7996ccd4@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 04:55:42PM -0700, David Ahern wrote:
> On 10/31/20 3:23 PM, Petr Machata wrote:
> >
> > David Ahern <dsahern@gmail.com> writes:
> >
> >> On 10/30/20 6:29 AM, Petr Machata wrote:
> >>> diff --git a/lib/utils.c b/lib/utils.c
> >>> index 930877ae0f0d..8deec86ecbcd 100644
> >>> --- a/lib/utils.c
> >>> +++ b/lib/utils.c
> >>> @@ -1763,3 +1763,11 @@ int parse_on_off(const char *msg, const char *realval, int *p_err)
> >>>
> >>>  	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
> >>>  }
> >>> +
> >>> +void print_on_off_bool(FILE *fp, const char *flag, bool val)
> >>> +{
> >>> +	if (is_json_context())
> >>> +		print_bool(PRINT_JSON, flag, NULL, val);
> >>> +	else
> >>> +		fprintf(fp, "%s %s ", flag, val ? "on" : "off");
> >>> +}
> >>>
> >>
> >> I think print_on_off should be fine and aligns with parse_on_off once it
> >> returns a bool.
> >
> > print_on_off() is already used in the RDMA tool, and actually outputs
> > "on" and "off", unlike this. So I chose this instead.
> >
> > I could rename the RDMA one though -- it's used in two places, whereas
> > this is used in about two dozen instances across the codebase.
> >
>
> yes, the rdma utils are using generic function names. The rdma version
> should be renamed; perhaps rd_print_on_off. That seems to be once common
> prefix. Added Leon.

I made fast experiment and the output for the code proposed here and existed
in the RDMAtool - result the same. So the good thing will be to delete the
function from the RDMA after print_on_off_bool() will be improved.

However I don't understand why print_on_off_bool() is implemented in
utils.c and not in lib/json_print.c that properly handles JSON context,
provide colorized output and doesn't require to supply FILE *fp.

Thanks
