Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30084C4A32
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235405AbiBYQMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241007AbiBYQMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:12:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67420278CB3
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:12:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EAC8B83258
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 16:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D3EC340E7;
        Fri, 25 Feb 2022 16:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645805533;
        bh=lJBK4pzmHxAsldGTQsNmuTQ0B+9UXC/4TLKV1lDgxis=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CcO6OLO01PxHZye1eguHoIRqQf7GhMpHaOFBFdQ+h2ZxIhL/tjBjUk8bzGW4eRrzX
         Xd8D8ZNxppLKmeXiEq6q59YE2x+G9pUzLh8MtCRRkO9FT2qoQxwEFo2DGb/8T0vEDG
         J25znekSPnFWZt0ryoyoFkGAC1E/t2MqYVRDEZdUukfnlRfPGOaliVxbThMHDXna0E
         IxtTBJoUsg9kOpmb3RFiA+rb7mdDN2/Tmfs3hlbkNDP/hHtyXjU/tqA7TFko9gbJZu
         iNpdDgSm8dNrtQND+bU8v3Y29hJnuWXK0SGaYbBTYheI85k0VKZ/GpuNLzovJH2qie
         pYFjKa9O8xpeA==
Date:   Fri, 25 Feb 2022 08:12:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <jiri@nvidia.com>, <razor@blackwall.org>,
        <roopa@nvidia.com>, <dsahern@gmail.com>, <andrew@lunn.ch>,
        <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 06/14] net: dev: Add hardware stats support
Message-ID: <20220225081212.4b1825f2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <8735k7fg53.fsf@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
        <20220224133335.599529-7-idosch@nvidia.com>
        <20220224222244.0dfadb8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8735k7fg53.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Feb 2022 09:31:23 +0100 Petr Machata wrote:
> >> +	struct rtnl_link_stats64 *offload_xstats_l3;  
> >
> > Does it make sense to stick to rtnl_link_stats64 for this?
> > There's a lot of.. historical baggage in that struct.  
> 
> It seemed like a reasonable default that every tool already understands.
> 
> Was there a discussion in the past about what a cross-vendor stats suite
> should look like? It seems like one of those things that can be bikeshed
> forever...

What I meant is take out all the link-level / PHY stuff, I don't think
any HW would be reporting these above the physical port. Basically when
you look at struct rtnl_link_stats64 we can remove everything starting
from and including collisions, right?

And looking at your patch that'd leave exactly the stats you actually
use..
