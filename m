Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F04552F5F0
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 01:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353561AbiETXD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 19:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240765AbiETXDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 19:03:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8B5190D21
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 16:03:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE784B82E72
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 23:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05530C385A9;
        Fri, 20 May 2022 23:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653087801;
        bh=QhYtaxOdux673WFzp/dctZDtj2XCe1V52fJchSnsRX8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HKkTfzhFd7uFg5RyRCTc9vdsnopBpJhC/Y/QV9EXYHD/MgmFkIf7EkW1SCwz/eDO1
         NXFoyv3ovc3RF/fyu0VOkJD+q9r/7ebj58ICWR3cFmbDg54TKxzwUI6GxzC7DZ+EoD
         vP+728SRcRyBCr3MwTHXV3dUdyg/BkBGnLKTWk8jE3TVM5Q4s+Xlyh73tmVmpln9we
         n1NC/KGdbUzj8SrrGBsYKGfSVCqZfJHSQh4plWIiFGTsCBbSSufatL59oIvqyE7ozD
         dkSK0YVFb7UHkI5Mak8Qf3SLRvbtBjdbTrYxJfKCRF/ILV8B+g2vldfFQV6mbyUv0k
         UgoSKq6blqJ7g==
Date:   Fri, 20 May 2022 16:03:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux@armlinux.org.uk, olteanv@gmail.com, hkallweit1@gmail.com,
        f.fainelli@gmail.com, michael.chan@broadcom.com
Subject: Re: [RFC net-next] net: track locally triggered link loss
Message-ID: <20220520160319.15ed87b9@kernel.org>
In-Reply-To: <20220520220832.kh4lndzy7hvyus6f@sx1>
References: <20220520004500.2250674-1-kuba@kernel.org>
        <YoeIj2Ew5MPvPcvA@lunn.ch>
        <20220520111407.2bce7cb3@kernel.org>
        <YofidJtb+kVtFr6L@lunn.ch>
        <20220520220832.kh4lndzy7hvyus6f@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 15:08:32 -0700 Saeed Mahameed wrote:
> >I'm not sure this is a good example. If the PHY is doing an autoneg,
> >the link really is down for around a second. The link peer will also
> >so the link go down and come back up. So this seems like a legitimate
> >time to set the carrier off and then back on again.
> >  
> +1
> 
> also looks very racy, what happens if a real phy link event happens in
> between carrier_change_start() and carrier_change_end() ?

But physical world is racy. What if the link flaps twice while the IRQs
are masked? There will always be cases where we miss or miscount events.

> I think you shouldn't treat configuration flows where the driver actually
> toggles the phy link as a special case, they should be counted as a real
> link flap.. because they are.

That's not the direction of the patch at all - I'm counting locally
generated events, I don't care as much if the link went down or not.

I believe that creating a system which would at scale try to correlate
events between peers is impractical.

> It's impossible from the driver level to know if a FW link event is
> due to configuration causes or external forces !

You mean because FW or another entity (other than local host) asked for
the link to be reset? How is that different from switch taking it down?
Either way the host has lost link due to a non-local event. (3a) or (3b)

> the new 3 APIs are going to be a heavy burden on drivers to maintain. if
> you agree with the above and treat all phy link events as one, then we end
> up with one new API drivers has to maintain "net_if_carrier_admin_off()"
> which is manageable.

I really don't think it's that hard...

> But what about SW netdevices, should all of them change to use the "admin"
> version ?

The new statistic is an opt-in (via netdev->has_carrier_down_local)
I think the same rules as to real devices should apply to SW devices
but I don't intend to implement the changes for any.

> We should keep current carrier logic as is and add new state/counter
> to count real phy link state.
> 
> netif_phy_link_down(netdev) {
>     set_bit(__LINK_STATE_NOPHYLINK, &dev->state);
>     atomic_inc(netdev->phy_link_down);
>     netif_carrier_off(ndetdev);
> }
> 
> netif_phy_link_up(netdev) {...}
> 
> such API should be maintained by real HW device drivers. 

"phy_link_down" has a ring of "API v2 this time we'll get it right".

Does this differentiate between locally vs non-locally generated events?

PTAL at the categorization in the commit message. There are three
classes of events, we need three counters. local vs non-local and
link went down vs flow was paused by SW are independent and overlapping.
Doesn't matter what the counters are called, translating between them 
is basic math.
