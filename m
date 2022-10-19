Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D9260504A
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 21:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiJSTUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 15:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiJSTUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 15:20:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7225CFAA59
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 12:20:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90081B825C3
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 19:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D290FC433D6;
        Wed, 19 Oct 2022 19:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666207241;
        bh=IBRDaY+mjXhTRj2gZlFtRhTrxP29bAy3xMiBB0w772M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=STDHHqSaEMqwaPsIsSHIaD3Fr3DrQwaJndlRfJXX+SFEDN8d8EMRcA+HLWBxupJIe
         LTyP41Y273hcJP/esJFIoXrHeibvrcJjREwQZKjPOgYT+QnyOv+1ND60v/t7t46oc0
         HeofIaLzaHGQNW177GWIEakK15vlsrJv/Kc1R7MaVqjahPG7go6dg2kIeh/ffygRzs
         mkUqKNj2XoucEh21UKJTahifMV5Y14hHVrXlaG5jNU0bx3HTm4bNjE2Hwu+ND1ehjN
         35ui2aGhsKJvb0ctMmI+j2wCAe3RGa8j1UBlTPnWQmtRlQU6wmPnJonSm3hLA4xCTQ
         vDGGy2GdV43mw==
Date:   Wed, 19 Oct 2022 12:20:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de
Subject: Re: [PATCH net-next 04/13] genetlink: load policy based on
 validation flags
Message-ID: <20221019122039.7aff557c@kernel.org>
In-Reply-To: <4c0f8e0aa1ed0b84bf7074bd963fcaec96eff515.camel@sipsolutions.net>
References: <20221018230728.1039524-1-kuba@kernel.org>
        <20221018230728.1039524-5-kuba@kernel.org>
        <4c0f8e0aa1ed0b84bf7074bd963fcaec96eff515.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 10:01:04 +0200 Johannes Berg wrote:
> On Tue, 2022-10-18 at 16:07 -0700, Jakub Kicinski wrote:
> > Set the policy and maxattr pointers based on validation flags.  
> 
> I feel like you could have more commit message here
> 
> >  	ops = ctx->ops;
> > -	if (ops->validate & GENL_DONT_VALIDATE_DUMP)
> > -		goto no_attrs;
> > -
> > -	if (ctx->nlh->nlmsg_len < nlmsg_msg_size(ctx->hdrlen))
> > +	if (!(ops->validate & GENL_DONT_VALIDATE_DUMP) &&
> > +	    ctx->nlh->nlmsg_len < nlmsg_msg_size(ctx->hdrlen))
> >  		return -EINVAL;
> >  
> >  	attrs = genl_family_rcv_msg_attrs_parse(ctx->family, ctx->nlh, ctx->extack,  
> 
> especially since this actually changes things to *have* the attrs, but
> not have *validated* them, which feels a bit strange and error-prone in
> the future maybe?

Do you mean that we no longer populate op->maxattr / op->policy and
some op may be reading those? I don't see any family code looking at
info->op.policy / maxattr.

First thing genl_family_rcv_msg_attrs_parse() does is:

	if (!ops->maxattr)
		return NULL;

So whether we skip it or call it - no difference.
