Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE4E67D899
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 23:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbjAZWiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 17:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233152AbjAZWiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 17:38:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9211A23658
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 14:37:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A353761987
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 22:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF9FC433D2;
        Thu, 26 Jan 2023 22:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674772645;
        bh=BqN63kESite/GwGbcTDZJEsDxlch3Z0ud2s3mGndcWQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=INWR3luDRDneBE1kaIyoqX5ir2ui75Jg1hfTQ4v5uOOb7PPAyGd/tsdnK4frWHqyz
         u14pLVDKx1ficmtrfRaTNGzIS8sZJfhrIH1cMZhiX08qYmPHPt05Lu4JduSIoiZtQk
         Rnil2Mgt65tZ1olfvzo5pNJmOQrtJk3oCE1f6DnyENi5cSk22EZ9LLS3lQvkI4GRGP
         Y+C7+08o61NZaJ5X8rZ3ePGvBr6Rh9CW8Qc9rY9ncc1wA48WL5b+niacMBXnNkfy7A
         IYJj/U+znQsFdJrfLy9Y5SA6oRCcqD4otWDvGOgwzFRS0fOYXn4lh6bNOEy5aMUZLf
         X1KbQzmB+gjVg==
Date:   Thu, 26 Jan 2023 14:37:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next] netlink: provide an ability to set default
 extack message
Message-ID: <20230126143723.7593ce0b@kernel.org>
In-Reply-To: <20230126223213.riq6i2gdztwuinwi@skbuf>
References: <2919eb55e2e9b92265a3ba600afc8137a901ae5f.1674760340.git.leon@kernel.org>
        <20230126223213.riq6i2gdztwuinwi@skbuf>
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

On Fri, 27 Jan 2023 00:32:13 +0200 Vladimir Oltean wrote:
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

That'd be my preference too, FWIW. It's only the offload cases which
need this sort of fallback.

BTW Vladimir, I remember us discussing this. I was searching the
archive as you sent this, but can't find the thread. Mostly curious
whether I flip flipped on this or I'm not completely useless :)

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
