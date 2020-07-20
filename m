Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FC5226CAA
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389107AbgGTQ6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 12:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389038AbgGTQ6s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 12:58:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FB65206E9;
        Mon, 20 Jul 2020 16:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595264328;
        bh=sjPs+BqHqnMDGn+cHCHrVpz+fXP5EVVq8DfSCXFlYw4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pjKzeGim7g+gmMaBQsfJVvZLBtYO9UWbcVWyp54nZijWVGLEm+hnyoGhZNoQZ5Efs
         iZwIunHHNCaAF614+psXQXIo/5WlU+5EtbH37k7VGacZ+rxih66tyvaWLLwLhyewR+
         RSV6Js1ttikrgFDhMrveIpH9LOW3LlBinzDv42tA=
Date:   Mon, 20 Jul 2020 09:58:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@gmail.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/6] enetc: Add interrupt coalescing support
Message-ID: <20200720095846.18a1ea73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3852bad5-76ca-170c-0bd5-b2cc2156bfea@gmail.com>
References: <1595000224-6883-1-git-send-email-claudiu.manoil@nxp.com>
        <1595000224-6883-6-git-send-email-claudiu.manoil@nxp.com>
        <20200717123239.1ffb5966@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3852bad5-76ca-170c-0bd5-b2cc2156bfea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Jul 2020 20:20:10 +0300 Claudiu Manoil wrote:
> On 17.07.2020 22:32, Jakub Kicinski wrote:
> > On Fri, 17 Jul 2020 18:37:03 +0300 Claudiu Manoil wrote:  
> >> +	if (ic->rx_max_coalesced_frames != ENETC_RXIC_PKTTHR)
> >> +		netif_warn(priv, hw, ndev, "rx-frames fixed to %d\n",
> >> +			   ENETC_RXIC_PKTTHR);
> >> +
> >> +	if (ic->tx_max_coalesced_frames != ENETC_TXIC_PKTTHR)
> >> +		netif_warn(priv, hw, ndev, "tx-frames fixed to %d\n",
> >> +			   ENETC_TXIC_PKTTHR);  
> > 
> > On second thought - why not return an error here? Since only one value
> > is supported seems like the right way to communicate to the users that
> > they can't change this.
> 
> Do you mean to return -EOPNOTSUPP without any error message instead?

Yes.

> If so, I think it's less punishing not to return an error code and 
> invalidate the rest of the ethtool -C parameters that might have been
> correct if the user forgets that rx/tx-frames cannot be changed.

IMHO if configuring manually - user can correct the params on the CLI.
If there's an orchestration system trying to configure those - it's 
better to return an error and alert the administrator than confuse 
the orchestration by allowing a write which is then not reflected 
on read.

> There's also this flag:
> 	.supported_coalesce_params = .. |
> 				     ETHTOOL_COALESCE_MAX_FRAMES |
> 				     ..,
> needed for printing the preconfigured values for the rx/tx packet 
> thresholds, and this flag basically says that the 'rx/tx-frames'
> parameters are supported (just that they cannot be changed... :) ).

Right, unfortunately core can't do the checking here, but I think 
the driver should.

> But I don't have a strong bias for this, if you prefer the return
> -EOPNOTSUPP option I'll make this change, just let me know if I got
> it right.
> 
> >> +	if (netif_running(ndev) && changed) {
> >> +		/* reconfigure the operation mode of h/w interrupts,
> >> +		 * traffic needs to be paused in the process
> >> +		 */
> >> +		enetc_stop(ndev);
> >> +		enetc_start(ndev);  
> > 
> > Is start going to print an error when it fails? Kinda scary if this
> > could turn into a silent failure.
> 
> enetc_start() returns void, just like enetc_stop().  If you look it up
> it only sets some run-time configurable registers and calls some basic
> run-time commands that should no fail like napi_enable(), enable_irq(), 
> phy_start(), all void returning functions. This function doesn't 
> allocate resources or anything of that sort, and should be kept that 
> way. And indeed, it should not fail. But regarding error codes there's
> nothing I can do for this function, as nothing inside it generates any 
> error code.

Got it!
