Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43C36466BC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 03:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiLHCGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 21:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiLHCGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 21:06:51 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30A992A3A
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 18:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eyUXfsI4dtBNDU5lgrTV1MV6ytIxYwlQIHcfVVd+m+w=; b=yeqShgQLNu+81U8XN1BhssBTEt
        f/n9laHBQUX78TRXaPNOWdYuuiKFzdwMy6thSgIBAzkobGKcjZCbcXWR+iBgqYey1uMGSwS+tAuyb
        RH/CV5QdxhvGST0XBNd2u43hSzOhUK8kz2hoHkCPfhNWQDcN9Ri35pX7ud4qxMRv1xsk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p36J5-004i7u-B4; Thu, 08 Dec 2022 03:06:39 +0100
Date:   Thu, 8 Dec 2022 03:06:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 06/13] ethtool: fix uninitialized local
 variable use
Message-ID: <Y5FGr9Tgmta0Qwpn@lunn.ch>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
 <20221208011122.2343363-7-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208011122.2343363-7-jesse.brandeburg@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 05:11:15PM -0800, Jesse Brandeburg wrote:
> '$ scan-build make' reports:
> 
> netlink/parser.c:252:25: warning: The left operand of '*' is a garbage value [core.UndefinedBinaryOperatorResult]
>         cm = (uint32_t)(meters * 100 + 0.5);
>                         ~~~~~~ ^
> 
> This is a little more complicated than it seems, but for some
> unexplained reason, parse_float always returns integers but was declared
> to return a float.

Looks like i got that wrong. Duh!

> This is confusing at best. In the case of the error
> above, parse_float could conceivably return without initializing it's
> output variable, and because the function return variable was declared
> as float but downgraded to an int via assignment (-Wconversion anyone?)
> upon the return, the return value could be ignored.
> 
> To fix the bug above, declare an initial value for meters, and make sure
> that parse_float() always returns an integer value.
> 
> It would probably be even more ideal if parse_float always initialized
> it's output variables before even checking for input errors, but that's
> for some future day.

It is also following the pattern of other parse_foo functions. None of
them set the result in case of errors.

> 
> CC: Andrew Lunn <andrew@lunn.ch>
> Fixes: 9561db9b76f4 ("Add cable test TDR support")
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
>  netlink/parser.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/netlink/parser.c b/netlink/parser.c
> index f982f229a040..70f451008eb4 100644
> --- a/netlink/parser.c
> +++ b/netlink/parser.c
> @@ -54,8 +54,7 @@ static bool __prefix_0x(const char *p)
>  	return p[0] == '0' && (p[1] == 'x' || p[1] == 'X');
>  }
>  
> -static float parse_float(const char *arg, float *result, float min,
> -			 float max)
> +static int parse_float(const char *arg, float *result, float min, float max)
>  {
>  	char *endptr;
>  	float val;
> @@ -237,7 +236,7 @@ int nl_parse_direct_m2cm(struct nl_context *nlctx, uint16_t type,
>  			 struct nl_msg_buff *msgbuff, void *dest)
>  {
>  	const char *arg = *nlctx->argp;
> -	float meters;
> +	float meters = 0;
>  	uint32_t cm;
>  	int ret;

Should this actually be 0.0? Otherwise if -Wconversion gets turned on,
you have an int being converted to a float?

Anyway:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
