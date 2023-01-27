Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5F867DD0E
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 06:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjA0FWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 00:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjA0FWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 00:22:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7E82A98F
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 21:22:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6867061A00
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 05:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A04C433D2;
        Fri, 27 Jan 2023 05:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674796950;
        bh=m2iagu5CoxQcuS9/5fRga1nwz/j2ClImu0ojZzZlsAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u32G2mL+UTO8LhM9W2FwjlI1fdq+nDqO2EosoWBfnLNRlSjQIE9TpMqueVejLyFOY
         IQQmfvLU1druPVdO9xVfrOwbsE8Qi0jGaLJeOQCJ1ApNYwrc0ZrlrHTldn41SDIcof
         o54CTb765BJoZqi1liaozfGIIT8yhn1bsnUWdksGbML/y287YPddaqsVuT5vxVLjJc
         e9q42tNc260SY627J8h84Szkqtn+2ufbpU1VIMufaKq/0E/gFDkrSAeDp7lVxNQ3Q9
         GBoTAxAu5mcPtvar2u++uA3gPj9NM4/klmAXjIZKOJzwSIHnF2RY4/VDW2EMpR3iNB
         HY6YKPR5sP5GQ==
Date:   Fri, 27 Jan 2023 07:22:26 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next] netlink: provide an ability to set default
 extack message
Message-ID: <Y9NfkgRbWAbrxQ1G@unreal>
References: <2919eb55e2e9b92265a3ba600afc8137a901ae5f.1674760340.git.leon@kernel.org>
 <20230126223213.riq6i2gdztwuinwi@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126223213.riq6i2gdztwuinwi@skbuf>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 12:32:13AM +0200, Vladimir Oltean wrote:
> On Thu, Jan 26, 2023 at 09:15:03PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > In netdev common pattern, xxtack pointer is forwarded to the drivers
>                             ~~~~~~
>                             extack
> 
> > to be filled with error message. However, the caller can easily
> > overwrite the filled message.
> > 
> > Instead of adding multiple "if (!extack->_msg)" checks before any
> > NL_SET_ERR_MSG() call, which appears after call to the driver, let's
> > add this check to common code.
> > 
> > [1] https://lore.kernel.org/all/Y9Irgrgf3uxOjwUm@unreal
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> 
> I would somewhat prefer not doing this, and instead introducing a new
> NL_SET_ERR_MSG_WEAK() of sorts.

It means changing ALL error unwind places where extack was forwarded
before to subfunctions.

Places like this:
 ret = func(..., extack)
 if (ret) {
   NL_SET_ERR_MSG_MOD...
   return ret;
 }

will need to be changed to something like this:
 ret = func(..., extack)
 if (ret) {
   NL_SET_ERR_MSG_WEAK...
   return ret;
 }

> 
> The reason has to do with the fact that an extack is sometimes also
> used to convey warnings rather than hard errors, for example right here
> in net/dsa/slave.c:
> 
> 	if (err == -EOPNOTSUPP) {
> 		if (extack && !extack->_msg)
> 			NL_SET_ERR_MSG_MOD(extack,
> 					   "Offloading not supported");
> 		NL_SET_ERR_MSG_MOD(extack,
> 				   "Offloading not supported");
> 		err = 0;
> 	}
> 
> Imagine (not the case here) that below such a "warning extack" lies
> something like this:
> 
> 	if (arg > range) {
> 		NL_SET_ERR_MSG_MOD(extack, "Argument outside expected range");
> 		return -ERANGE;
> 	}
> 
> What you'll get is:
> 
> Error: Offloading not supported (error code -ERANGE).
> 
> whereas before, we relied on any NL_SET_ERR_MSG_MOD() call to overwrite
> the "warning" extack, and that to only be shown on error code 0.

Can we please discuss current code and not over-engineered case which
doesn't exist in the reality?

Even for your case, I would like to see NL_SET_ERR_MSG_FORCE() to
explicitly say that message will be overwritten.

Thanks
