Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE02B4C3E52
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 07:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237768AbiBYGXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 01:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236480AbiBYGXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 01:23:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365391BF924
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 22:22:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA97D61A60
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:22:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DBBC340E7;
        Fri, 25 Feb 2022 06:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645770166;
        bh=mrl5G5s+fzzqe6181xLotakDlEHK2bnuPHXuRsQ3lJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=moD55QlWJA8JTYrkdLeiD4EreDlirk8ojukBnnz9GSIQz1RscFJnru9pu/NSHhxGf
         PwGJ3Il/6Xrl13A63tqdaQaBdnHw01W5IGcrv39niSQvVVXWWAtaB7HJUt1osnNO1Q
         jqWgs29HstBLW061oFBkXWlVPIebh9a8qM2EjO4EIjxoRKzW3bhPHhQKjOLBb/8Q4v
         YN4m+Pc6V6MHzZ68u+rTtydZedCdgw6c/7vmKEXJnASXrqmovzj0BTZslZ1MD5YLvD
         GR7LaUbJXKcGk5+PqJfunUPJo5cu5H2TahK/ozfolOnBUMJ6gmIHj3y1oSdWECBGaG
         WhE7SzB9aukbg==
Date:   Thu, 24 Feb 2022 22:22:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 06/14] net: dev: Add hardware stats support
Message-ID: <20220224222244.0dfadb8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220224133335.599529-7-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
        <20220224133335.599529-7-idosch@nvidia.com>
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

On Thu, 24 Feb 2022 15:33:27 +0200 Ido Schimmel wrote:
> From: Petr Machata <petrm@nvidia.com>
> 
> Offloading switch device drivers may be able to collect statistics of the
> traffic taking place in the HW datapath that pertains to a certain soft
> netdevice, such as VLAN. Add the necessary infrastructure to allow exposing
> these statistics to the offloaded netdevice in question. The API was shaped
> by the following considerations:
> 
> - Collection of HW statistics is not free: there may be a finite number of
>   counters, and the act of counting may have a performance impact. It is
>   therefore necessary to allow toggling whether HW counting should be done
>   for any particular SW netdevice.
> 
> - As the drivers are loaded and removed, a particular device may get
>   offloaded and unoffloaded again. At the same time, the statistics values
>   need to stay monotonous (modulo the eventual 64-bit wraparound),

monotonic

>   increasing only to reflect traffic measured in the device.

> +	struct rtnl_link_stats64 *offload_xstats_l3;

Does it make sense to stick to rtnl_link_stats64 for this?
There's a lot of.. historical baggage in that struct.

