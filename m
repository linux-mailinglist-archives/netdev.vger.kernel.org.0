Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7274B64E1F4
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiLOTrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiLOTrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:47:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494F7532C4
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:47:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA7DC61E5D
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 19:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D665BC433D2;
        Thu, 15 Dec 2022 19:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671133627;
        bh=cH2J1JzoKtErZpR2iCyzV7xZZW0pMey/ksYppj1glVA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pBlo2Diw/Xb0Twg1nbcHa1OSZUPwHLRp1lio7ljMuVWY8xdJ5hPpEq14jhAI+Ul7h
         p/QMGKF6RNbvPaKagNZVdHHj6iR6tIH/D5vD7N/CuEUXunMLTxNUEHces/tS7YpBWz
         OrP4bQaMhlh7tWO/FhkmgZ+3s0yWnK9cyvg86ss4l/TaJhTePT8Ws5RsvyoUeQmrjG
         HmElhNRXpIaZpvzvEyh2+LsKmotd9DPg9QbglEh+o4PGMtiMjDVzMdWLJllEsHbtej
         iesEfr15YbXdpmXeo2NqOXDxBUmbaU0unzqt+GhcTpkDNWlmNtJEDh/KHIu2b9SJHu
         No3yedYf4gL3A==
Date:   Thu, 15 Dec 2022 11:47:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, leon@kernel.org
Subject: Re: [RFC net-next 14/15] devlink: add by-instance dump infra
Message-ID: <20221215114706.42be5299@kernel.org>
In-Reply-To: <Y5rkpxKm/TdGlJHf@nanopsycho>
References: <20221215020155.1619839-1-kuba@kernel.org>
        <20221215020155.1619839-15-kuba@kernel.org>
        <Y5rkpxKm/TdGlJHf@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Dec 2022 10:11:03 +0100 Jiri Pirko wrote:
> Instead of having this extra list of ops struct, woudn't it make sence
> to rather implement this dumpit_one infra directly as a part of generic
> netlink code?

I was wondering about that, but none of the ideas were sufficiently
neat to implement :( There's a lot of improvements that can be done
in the core, starting with making more of the info structures shared
between do and dump in genl :( 

> Something like:
> 
>  	{
>  		.cmd = DEVLINK_CMD_RATE_GET,
>  		.doit = devlink_nl_cmd_rate_get_doit,
> 		.dumpit_one = devlink_nl_cmd_rate_get_dumpit_one,
> 		.dumpit_one_walk = devlink_nl_dumpit_one_walk,
>  		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
>  		/* can be retrieved by unprivileged users */
>  	},

Growing the struct ops (especially the one called _small_) may be 
a hard sale for a single user. For split ops, it's a different story,
because we can possibly have a flag that changes the interpretation
of the union. Maybe.

I'd love to have a way of breaking down the ops so that we can factor
out the filling of the message (the code that is shared between doit
and dump). Just for the walk I don't think it's worth it.

I went in the same direction as ethtool because if over time we arrive
at a similar structure we can use that as a corner stone.

All in all, I think this patch is a reasonable step forward. 
But definitely agree that the genl infra is still painfully basic.
