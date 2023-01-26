Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0443667D9C5
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 00:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbjAZXkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 18:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233439AbjAZXkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 18:40:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCDF9742
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 15:39:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E6C1619A2
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 23:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776EBC4339C;
        Thu, 26 Jan 2023 23:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674776362;
        bh=oUC5Mvm4GEqJrG9gIHdrxl6F610JpQsy0hRbjNPgPIQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nfxBNs6FM7NZKGVV3BMji9ruWlGp1t/3cOBJWL1bDMYEOk49YqHbDgN2af6DRVY/X
         H7E0DM6x9xalxWAFX7/6tcXHgHKmjRm4uH61vFvCBOr7Cx8Ai9w8BVdkz0FfA1u0Q/
         UShPs3Fuvvwk6ZQ3XAdmBoEFn6RgYhUonCYUeENa5RF7+PHd9pJGHHtKSZWH8//b7o
         GDtI8AZBvWAujDOjOnU43xnR1ePR802WZ0t6C43BqRZ3JpLag97b2N2ZQO+tB0qlFi
         7bmlfxJko+/jvOVyPwS8BviEs2+zesWJTKr3xr5syp9LXYR7Ul97pKEBvIe04lFpXL
         azIZVjSHuQC5g==
Date:   Thu, 26 Jan 2023 15:39:21 -0800
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
Message-ID: <20230126153921.3823054c@kernel.org>
In-Reply-To: <20230126224457.lc2ly5k77gkhycwa@skbuf>
References: <2919eb55e2e9b92265a3ba600afc8137a901ae5f.1674760340.git.leon@kernel.org>
        <20230126223213.riq6i2gdztwuinwi@skbuf>
        <20230126143723.7593ce0b@kernel.org>
        <20230126224457.lc2ly5k77gkhycwa@skbuf>
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

On Fri, 27 Jan 2023 00:44:57 +0200 Vladimir Oltean wrote:
> On Thu, Jan 26, 2023 at 02:37:23PM -0800, Jakub Kicinski wrote:
> > > I would somewhat prefer not doing this, and instead introducing a new
> > > NL_SET_ERR_MSG_WEAK() of sorts.  
> > 
> > That'd be my preference too, FWIW. It's only the offload cases which
> > need this sort of fallback.
> > 
> > BTW Vladimir, I remember us discussing this. I was searching the
> > archive as you sent this, but can't find the thread. Mostly curious
> > whether I flip flipped on this or I'm not completely useless :)  
> 
> What we discussed was on a patch of mine fixing "if (!extack->_msg)" to
> "if (extack && !extack->_msg)". I never proposed a new macro wrapper
> (you did), but I didn't do it at the time because it was a patch for
> "net", and I forgot to put a reminder for the next net->net-next merge.
> https://lore.kernel.org/netdev/20220822182523.6821e176@kernel.org/
> And from there, out of sight, out of mind.

That explains it, I was running blame the message lines, not the if ().
Thanks for digging it up!
