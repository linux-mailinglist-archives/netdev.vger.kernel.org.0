Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D3A52FED3
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 20:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344524AbiEUSjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 14:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235790AbiEUSjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 14:39:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E44D3CA43
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 11:39:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AD4BB80A07
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 18:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C7FC385A5;
        Sat, 21 May 2022 18:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653158339;
        bh=0+98ExCR6jEO0EgneTa7JIVpYO0UmnBiFS1XUEF4NT0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pyx5MVhRkX43uaH/oA4TBKqIF45BMKLB9rcmktSaccNgjXiKChSUWW+jVtN33kkHo
         k4bHs0Fo4xP8Fx5+zUii/paRZ/6kJNqe2JgiIZ6n5lBoyvr638rOxeagDvDzBFeHiQ
         O6n20vEHMAPUpbZ+vVJdTCsjWTYs+nPsbIN3GA/MJ2I0cXSzU+2Hcx3uIoY4yKq4JN
         xdwAp6b8/VQGTNzF5cLORTBaj3CWyBFF2jDfT4KnBYCe4XP/NpiTUNHEM+7IaqLlWa
         Nrnag0vAu2YBx9zy42xpdzWlUhn43kf0qId4IPbxG43kXzPDb6HvEddh2Hw1gzFXZ2
         enLFZaD9wJhhw==
Date:   Sat, 21 May 2022 11:38:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux@armlinux.org.uk, olteanv@gmail.com, hkallweit1@gmail.com,
        f.fainelli@gmail.com, michael.chan@broadcom.com
Subject: Re: [RFC net-next] net: track locally triggered link loss
Message-ID: <20220521113857.48aeffbb@kernel.org>
In-Reply-To: <20220521050834.legbzeumzgqwldqp@sx1>
References: <20220520004500.2250674-1-kuba@kernel.org>
        <YoeIj2Ew5MPvPcvA@lunn.ch>
        <20220520111407.2bce7cb3@kernel.org>
        <YofidJtb+kVtFr6L@lunn.ch>
        <20220520220832.kh4lndzy7hvyus6f@sx1>
        <20220520160319.15ed87b9@kernel.org>
        <20220521050834.legbzeumzgqwldqp@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 22:08:34 -0700 Saeed Mahameed wrote:
> >> It's impossible from the driver level to know if a FW link event is
> >> due to configuration causes or external forces !  
> >
> >You mean because FW or another entity (other than local host) asked for
> >the link to be reset? How is that different from switch taking it down?
> >Either way the host has lost link due to a non-local event. (3a) or (3b)
> >  
> 
> I was talking about (1) vs (2), how do you know when the IRQ/FW event
> arrives what caused it ?  Maybe I just don't understand how you plan to use the
> new API when re-config brings link down. 
> 
> for example: 
> driver_reconfig() {
>     maybe_close_rings();
>     exec_fw_command(); //link will flap, events are triggered asynchronously.
>     maybe_open_rings();
> }
> 
> how do you wrap this with netif_carrier_change_start/end() when the link
> events are async ? 

Yeah :/ I was worried that we may need to do some queue flushing or
waiting in the _end() to make sure the event has arrived. Remains to 
be seen.

> >> We should keep current carrier logic as is and add new state/counter
> >> to count real phy link state.
> >>
> >> netif_phy_link_down(netdev) {
> >>     set_bit(__LINK_STATE_NOPHYLINK, &dev->state);
> >>     atomic_inc(netdev->phy_link_down);
> >>     netif_carrier_off(ndetdev);
> >> }
> >>
> >> netif_phy_link_up(netdev) {...}
> >>
> >> such API should be maintained by real HW device drivers.  
> >
> >"phy_link_down" has a ring of "API v2 this time we'll get it right".
> >  
> 
> c'mon .. same goes for netif_carrier_local_changes_start/end and
> netif_carrier_admin_off().

Not exactly - admin_off() is different because it tells you local 
vs non-local. That information is not provided by current APIs.

> >Does this differentiate between locally vs non-locally generated events?
> 
> no
> 
> >PTAL at the categorization in the commit message. There are three
> >classes of events, we need three counters. local vs non-local and
> >link went down vs flow was paused by SW are independent and overlapping.
> >Doesn't matter what the counters are called, translating between them
> >is basic math.  
> 
> Ok if you want to go with this I am fine, just let's not add more peppered
> confusing single purpose API calls into drivers to get some counters right,
> let's implement one multi-purpose infrastructure and use it where it's needed.
> It appears that all you need is for the driver to notify the stack when it's
> going down for a re-config and when it comes back up, thus put all the
> interesting heavy lifting logic in the stack, e.g link event classification,
> freezing/flushing TX queues, flushing offloaded resources (VXALN, TLS, IPSec),
> etc .. 
> currently all of the above are and will be duplicated in every driver, when
> all you need is a generic hint from the driver.

How would the core know which resources need to be re-programmed?
This seems hard, we can't get caps properly expressed in most places,
let alone pulling up orchestration into the stack.

Maybe I'm unfair but I can't think of many examples of reworks trying
to pull out management logic out of NIC drivers. All I can think of was
my VXLAN rework. I'm happy to start nacking all the shim APIs which do
little to nothing in the core and just punt all requests to the drivers
or FW :/ I think we veered off course tho...
