Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61724777B6
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 17:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbhLPQPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 11:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235883AbhLPQPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 11:15:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7D3C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 08:15:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB169B824F1
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 16:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE92C36AE5;
        Thu, 16 Dec 2021 16:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639671309;
        bh=MCJvaG1bRPjYX5shVDYCuXVkFSM9jknErCpoTjNy+6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qi0Ho/r09qp4iS1ioLDRtiVMrzL8doZlEwz+WYFYhiH4oPjuxJqaXBxN8S+AjCAUx
         92WE0qmUquiaErlNMDq2cYLj5KyqLqLxzSdgQ98NEk68BRkn58bOxAHzGB4asRwLpW
         FmNaTvIG29p0y01kCSKgJapx0a9pcibPrTNuQ0vdNzC6y6UNXmApSxK8SHTGYUAQ4d
         cR82s5pYQXX6SKGK0OPPoGPvyR+TpwML5tsgSBU6g0kpl/NvncXpcESYAgERS4PpBB
         pGNmI/pCUKmEY+go7nC8Rjw8O9QvnrYMfFGP2UH3JxAHVyakybS/B2aJNS1d8DLGI+
         GD9XZreVIcB2w==
Date:   Thu, 16 Dec 2021 08:15:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH net-next v2 0/7] net: phylink: add PCS validation
Message-ID: <20211216081508.08f63520@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YboKxwxonGND3Mom@shell.armlinux.org.uk>
References: <YboKxwxonGND3Mom@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 15:33:27 +0000 Russell King (Oracle) wrote:
> This series allows phylink to include the PCS in its validation step.
> There are two reasons to make this change:
> 
> 1. Some of the network drivers that are making use of the split PCS
>    support are already manually calling into their PCS drivers to
>    perform validation. E.g. stmmac with xpcs.
> 
> 2. Logically, some network drivers such as mvneta and mvpp2, the
>    restriction we impose in the validate() callback is a property of
>    the "PCS" block that we provide rather than the MAC.
> 
> This series:
> 
> 1. Gives phylink a mechanism to query the MAC driver which PCS is
>    wishes to use for the PHY interface mode. This is necessary to allow
>    the PCS to be involved in the validation step without making changes
>    to the configuration.
> 
> 2. Provide a pcs_validate() method that PCS can implement. This follows
>    a similar model to the MAC's validate() callback, but with some minor
>    differences due to observations from the various implementations.
>    E.g. returning an error code for not-supported and the way the
>    advertising bitmap is masked.
> 
> 3. Convert mvpp2 and mvneta to this as examples of its use. Further
>    Conversions are in the pipeline, including for stmmac+xpcs, as well
>    as some DSA drivers. Note that DSA conversion to this is conditional
>    upon all DSA drivers populating their supported_interfaces bitmap,
>    since this is required before mac_select_pcs() can be used.
> 
> Existing drivers that set a PCS in mac_prepare() or mac_config(), or
> shortly after phylink_create() will continue to work. However, it should
> be noted that mac_select_pcs() will be called during phylink_create(),
> and thus any PCS returned by mac_select_pcs() must be available by this
> time - or we drop the check in phylink_create().
> 
> v2: fix kerneldoc typo in patch 1.

Not sure if you got a notification but this had been applied, thanks!
