Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC43160842A
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 06:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiJVEIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 00:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJVEIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 00:08:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3BD2ACBDA
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 21:08:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6978160AD1
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 04:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF9EC433D6;
        Sat, 22 Oct 2022 04:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666411696;
        bh=rDnsu7yTybwnpowtByVOyqwIsg8Jh2ttgT+aMo23phk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Cmaqjmud4sPY4mM6iaQFzVcLSAm3hL/GDza2UoPHxDjWQQWKCiHwLmox6jgd9qLbL
         2+xZ5WL+M9r9Qnn+/utVYSZ6z17RB1a58atb1wOVsUlFoDReph3HGSDTInzYWPoOw8
         KOu7RAsi0POZTtczokyU676O4M6ros9uxFCSKwjMsS8SW/+cy2swq7QNmeiiAgzUaI
         dvUnY8pHyCwPLKAdkMQ8TY/JzIt/fPyfNlS3PqCMVENgwSxs/zeEbesN0Z2LNSPJ2k
         WsmCbLmsgJ6ZTsN+LLCOf5iqLHsvskmfsqUbys/DGyf6WBLxiXlgQcgUn9KsJ/HFMX
         JqkiPHtSsQN0w==
Date:   Fri, 21 Oct 2022 21:08:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        jiri@nvidia.com
Subject: Re: [PATCH net] genetlink: piggy back on resv_op to default to a
 reject policy
Message-ID: <20221021210815.44e8220f@kernel.org>
In-Reply-To: <6ba9f727e555fd376623a298d5d305ad408c3d47.camel@sipsolutions.net>
References: <20221021193532.1511293-1-kuba@kernel.org>
        <6ba9f727e555fd376623a298d5d305ad408c3d47.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 21:57:53 +0200 Johannes Berg wrote:
> It feels it might've been easier to implement as simply, apart from the
> doc changes:
> 
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -529,6 +529,10 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
>  	struct nlattr **attrbuf;
>  	int err;
>  
> +	if (ops->cmd >= family->resv_start_op && !ops->maxattr &&
> +	    nlmsg_attrlen(nlh, hdrlen))
> +		return ERR_PTR(-EINVAL);
> +
>  	if (!ops->maxattr)
>  		return NULL;
>
> But maybe I'm missing something in the relation with the new split ops
> etc.

The reason was that payload length check is... "unintrospectable"?
The reject all policy shows up in GETPOLICY. Dunno how much it matters
in practice but that was the motivation. LMK which way you prefer.

> Also, technically, you could now have an op that is >= resv_start_op,
> but sets one of GENL_DONT_VALIDATE{_DUMP,}_STRICT and then gets the old
> behaviour except that attributes 0 and 1 are rejected?
> 
> Any particular reason you chose this implementation here? I can
> understand having chosen it with the yaml things since then you can be
> sure you're not setting GENL_DONT_VALIDATE{_DUMP,}_STRICT and you don't
> have another choice anyway, but here?
> 
> Hmm.
> 
> Then again, maybe anyway we should make sure that
> GENL_DONT_VALIDATE{_DUMP,}_STRICT aren't set for ops >= resv_start_op?
> 
> 
> Anyway, for the intended use it works, and I guess it'd be a stupid
> family that makes sure to set this but then still uses non-strict
> validation, though I've seen people (try to) copy/paste non-strict
> validation into new ops ...

Hm, yeah, adding DONT*_STRICT for new commands would be pretty odd as
you say. Someone may copy & paste an existing command, tho, without
understanding what this flag does. 

I can add a check separately I reckon. It's more of a "no new command
should set this flag" thing rather than inherently related to the
reject-all policy, right?
