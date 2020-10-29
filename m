Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DD329F8D2
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 00:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgJ2XDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 19:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgJ2XDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 19:03:07 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C4CC2076D;
        Thu, 29 Oct 2020 23:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604012498;
        bh=6fFvE2Ch2iQWRXn75cYjBioKvANy6i3hM4HmSZO7Eek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uD83vYAR/aMqYJG56d9FKSSdIkO+tY9LMWSVuJ9EojNk/AhvsUPHpSYKrUwUzT6kK
         ta+suVCUu02xPc1U4I8yLrGxdpVj+eZOBzFGoojBnbcsi0arcNSA9hPlgEy8RMnu5J
         XtXu8ZpamHMVIA9U2sPYyareS9kP2uY05e3pFw7g=
Date:   Thu, 29 Oct 2020 16:01:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Zou Wei <zou_wei@huawei.com>, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: stmmac: platform: remove useless if/else
Message-ID: <20201029160137.5d8093a7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029123445.GH933237@lunn.ch>
References: <1603938832-53705-1-git-send-email-zou_wei@huawei.com>
        <20201029123445.GH933237@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 13:34:45 +0100 Andrew Lunn wrote:
> On Thu, Oct 29, 2020 at 10:33:52AM +0800, Zou Wei wrote:
> > Fix the following coccinelle report:
> > 
> > ./drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:233:6-8:
> > WARNING: possible condition with no effect (if == else)
> > 
> > Both branches are the same, so remove the else if/else altogether.
> > 
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Zou Wei <zou_wei@huawei.com>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > index af34a4c..f6c69d0 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> > @@ -230,8 +230,6 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
> >  		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_WFQ;
> >  	else if (of_property_read_bool(tx_node, "snps,tx-sched-dwrr"))
> >  		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_DWRR;
> > -	else if (of_property_read_bool(tx_node, "snps,tx-sched-sp"))
> > -		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_SP;
> >  	else
> >  		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_SP;  
> 
> I actually prefer the original code. Code is also documentation. It
> documents the fact, if "snps,tx-sched-sp" is in device tree, we use
> MTL_TX_ALGORITHM_SP, but otherwise we default to MTL_TX_ALGORITHM_SP.
> 
> As with my suggestion for forcedeth, i would move the default setting
> to before the whole if/else if/else block to document it is the
> default.
> 
> Or just consider this a false positive and leave it alone. I can see
> value in the coccinelle script, but it is going to have a lot of false
> positive cases, so i'm not sure there is value in working around them
> all.

Annoyingly this is not the first time this exact patch is submitted :/

I think your forcedeth suggestion is a nice compromise.
