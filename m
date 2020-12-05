Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF452CFF2A
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgLEVUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:20:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEVUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 16:20:10 -0500
Date:   Sat, 5 Dec 2020 13:19:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607203170;
        bh=PyjM1pGVTFHxUehGtpwFnMJ3A9jzuRhj8X6L8VDNDQo=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=IomTqf+w6S260Krot3AzLA96YRLEmUE+dTNDRNGda8WX41gmHH8hyEIa3DF96Wc03
         QpS/knU4Z8zTv6zTDgxt97BNT/vJ+EesFz5kZqDIvT/w6pAF5UoDUKhtWrLce1CRsA
         DFaMJnbtcUIao87SqdFnFi5RCdwFij6fIHQ19rG0D1Sb219fjP1hxOhzFqNCGRJWao
         Ju4epsvDrCq+1fjJBVTjEa+ORIpDHP81zXEVzoEfuvnHY49ZHXJXnYyi5lPqI3Ea6m
         aTce8LCME5vTq5eG7uxqQLJlE4JNKnnk+j56wQhzFp6GAMVxnM71gsC3kR8fOTi7hI
         Sn7EiyZoxM6lQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/20] ethernet: ucc_geth: fix use-after-free in
 ucc_geth_remove()
Message-ID: <20201205131928.7d5c8e59@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <4d35ef11-b1eb-c450-2937-94e20fa9a213@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
        <20201205191744.7847-12-rasmus.villemoes@prevas.dk>
        <20201205124859.60d045e6@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <4d35ef11-b1eb-c450-2937-94e20fa9a213@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Dec 2020 22:04:28 +0100 Rasmus Villemoes wrote:
> On 05/12/2020 21.48, Jakub Kicinski wrote:
> > On Sat,  5 Dec 2020 20:17:34 +0100 Rasmus Villemoes wrote:  
> >> -	unregister_netdev(dev);
> >> -	free_netdev(dev);
> >>  	ucc_geth_memclean(ugeth);
> >>  	if (of_phy_is_fixed_link(np))
> >>  		of_phy_deregister_fixed_link(np);
> >>  	of_node_put(ugeth->ug_info->tbi_node);
> >>  	of_node_put(ugeth->ug_info->phy_node);
> >> +	unregister_netdev(dev);
> >> +	free_netdev(dev);  
> > 
> > Are you sure you want to move the unregister_netdev() as well as the
> > free?
> 
> Hm, dunno, I don't think it's needed per se, but it also shouldn't hurt
> from what I can tell. It seems more natural that they go together, but
> if you prefer a minimal patch that's of course also possible.

I was concerned about the fact that we free things and release
references while the device may still be up (given that it's
unregister_netdev() that will take it down).

> I only noticed because I needed to add a free of the ug_info in a later
> patch.
