Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135AE6D337D
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 21:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjDATY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 15:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDATY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 15:24:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C19810D8
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 12:24:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 663EFB80B2F
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 19:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56C4C433D2;
        Sat,  1 Apr 2023 19:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680377092;
        bh=YT9QXBHGoUcE9Yxr8q9VVq/bvdbiL5kwwPT5iweDD5Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rr3GBMH7BIC0lB2SrIO5FKTxRLb7eZsThPAq7hwem5ubijqYeX/K60fFZN1yvy+2b
         2d1Kc1FigCa4+qVZe8oYdlUgajT+JEqXS+g5xLPEcWyJEA1o7/q0E4+xrLpsuO74fJ
         6RitLLzd7PQ6AGoQBCeRU2iVafM4RTUHp626+5mtYq2g9ehus3aLUILr/SABJ9h8oU
         i43Ybp0+8YXd4XqGVZmrfhclumGZ3qI22JYwEvMgeZDYhkRVjOkZD5E1X/skc2kjXC
         HFPMU9DtLFhUF+C0wOj1Ll9RsCDiuwYEeQZgYkitKRLgfH//3vOaB10hSJoyD0+mPi
         3VOTWmrQyduDA==
Date:   Sat, 1 Apr 2023 12:24:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Max Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Message-ID: <20230401122450.0fd88313@kernel.org>
In-Reply-To: <20230401191215.tvveoi3lkawgg6g4@skbuf>
References: <20230331045619.40256-1-glipus@gmail.com>
        <20230330223519.36ce7d23@kernel.org>
        <CAP5jrPHzQN25gWmNCXYdCO0U7Fxx_wB0WdbKRNd8Owqp1Gftsg@mail.gmail.com>
        <20230331111041.0dc5327c@kernel.org>
        <20230401191215.tvveoi3lkawgg6g4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Apr 2023 22:12:15 +0300 Vladimir Oltean wrote:
> Actually, and here is the problem, DSA will want to see the timestamping
> request with the new code path too, not just with the legacy one.
> But, in this form, the dsa_ndo_eth_ioctl() -> dsa_master_ioctl() code
> path wants to do one of two things: it either denies the configuration,
> or passes it further, unchanged, to the master's netdev_ops->ndo_eth_ioctl().
> 
> By being written around the legacy ndo_eth_ioctl(), dsa_ndo_eth_ioctl()
> places a requirement which conflicts with any attempt to convert any
> kernel driver to the new API, because basically any net device can serve
> as a DSA master, and simply put, DSA wants to see timestamping requests
> to the DSA master, old or new API.
> 
> The only "useful" piece of logic from dsa_master_ioctl() is to deny the
> hwtstamp_set operation in some cases, so it's clear that it's useless
> for dsa_master_ioctl() to have to call the master's netdev_ops->ndo_eth_ioctl()
> when dev_eth_ioctl() already would have done it anyway.

So the current patch can only convert drivers which can't be a DSA
master :( (realistically any big iron NIC for example)
It should be relatively easy to plumb both the ifr and the in-kernel
config thru all the DSA APIs and have it call the right helper, too,
tho? SMOC?

> I can make dsa_ndo_eth_ioctl() disappear and replace it with a netdev
> notifier as per this patch:
> https://lore.kernel.org/netdev/20220317225035.3475538-1-vladimir.oltean@nxp.com/
> 
> My understanding of Jakub's objection is that the scope of the
> NETDEV_ETH_IOCTL is too wide, and as such, it would need to change to
> something like NETDEV_HWTSTAMP_SET. I can make that change if that is
> the only objection, and resubmit that as preparation work for the
> ndo_hwtstamp_set() effort.

My objection to the IOCTL is that there's a lot of boilerplate that 
the drivers have to copy and that it makes it harder to do meaningful
work in the core.
