Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FE2694F82
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjBMShK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjBMShJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:37:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB4B15570;
        Mon, 13 Feb 2023 10:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7rfb4I3SxniaE1BlvZfDy4F1q3ALKqu8B/i5PxxV7GU=; b=gjmLet4xuyx7JQv5J6gqeg04hD
        6pp7/x4ur4SgpbaO8UzNWitegetwXzcI96bhip3jKSxej8VbmxH/rBS+/uP7e6Cb0cAVB5bayVhSk
        gBOyKrh0RZLciswjXp4e8gKvG3CQsAa3xAqsiGb4eiESv8LMfufySYs65sv6beK8+MIA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pRdEX-004rzX-En; Mon, 13 Feb 2023 19:07:21 +0100
Date:   Mon, 13 Feb 2023 19:07:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     wei.fang@nxp.com, shenwei.wang@nxp.com, xiaoning.wang@nxp.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        netdev@vger.kernel.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next] net: fec: add CBS offload support
Message-ID: <Y+p8WZCPKhp4/RIH@lunn.ch>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
 <ed27795a-f81f-a913-8275-b6f516b4f384@intel.com>
 <Y+pjl3vzi7TQcLKm@lunn.ch>
 <8b25bd1f-4265-33ea-bdb9-bc700eff0b0e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b25bd1f-4265-33ea-bdb9-bc700eff0b0e@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 06:44:05PM +0100, Alexander Lobakin wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Mon, 13 Feb 2023 17:21:43 +0100
> 
> >>> +	if (!speed) {
> >>> +		netdev_err(ndev, "Link speed is 0!\n");
> >>
> >> ??? Is this possible? If so, why is it checked only here and why can it
> >> be possible?
> > 
> > The obvious way this happens is that there is no link partner, so
> > auto-neg has not completed yet. The link speed is unknown.
> 
> Sure, but why treat it an error path then?

You need to treat is somehow. I would actually disagree with
netdev_err(), netdev_dbg() seems more appropriate. But if you don't
know the link speed, you cannot program the scheduler.

This also comes back to my question about what should happen with a TC
configuration which works fine for 1000BaseT, but will not work for
10BaseT. Should the driver accept it only if the current link speed is
sufficient? Should it always accept it, and not program it into the
hardware if the current link speed does not support it?

Since we are talking about hardware acceleration here, what does the
pure software version do? Ideally we want the accelerated version to
do the same as the software version.

Wei, please disable all clever stuff in the hardware, setup a pure
software qdisc and a 10BaseT link. Oversubscribe the link and see what
happens. Does other traffic get starved?

	Andrew
