Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0C752F575
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353801AbiETWDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351380AbiETWDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:03:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAD013F90
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 15:02:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8713161DBF
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 22:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20EBC385A9;
        Fri, 20 May 2022 22:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653084178;
        bh=4CEXSiGkFy32Jura7dcpCDyeTlEBHqr93qsQDKMeGmw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hCdSWaiPsSdkDW5AYaNppAVYnZlBVHRJom7jupbyKRXrv56QsVXNlO9P+eELcRkCw
         75gHXq94Xb3aYvBad0HNRWjjzSpKz3TDxlGbbnwHzy45G63/qGnArDywEpLCIGgNqZ
         /LaX2MAfGUW6Q/3Ag1SP8HOkYZ/FOmM+9Ja7JoRghavhnVDsSVxGJFHu40UGjtJj+/
         F09/e884Uq9rjmH8l4VDnBlYvOwU/R+fkRQwSwRkCN0SBYwPAW4Ib0AvLTgg4NNP9g
         Vz8TSF23x61Na6/Hhz8WJQGlHCBur0umzzizrC5quVh3wOs29HXaTgW1NC+ucJ93kb
         7dKdz2xXBRm2w==
Date:   Fri, 20 May 2022 15:02:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, olteanv@gmail.com,
        hkallweit1@gmail.com, f.fainelli@gmail.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [RFC net-next] net: track locally triggered link loss
Message-ID: <20220520150256.5d9aed65@kernel.org>
In-Reply-To: <YofidJtb+kVtFr6L@lunn.ch>
References: <20220520004500.2250674-1-kuba@kernel.org>
        <YoeIj2Ew5MPvPcvA@lunn.ch>
        <20220520111407.2bce7cb3@kernel.org>
        <YofidJtb+kVtFr6L@lunn.ch>
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

On Fri, 20 May 2022 20:48:20 +0200 Andrew Lunn wrote:
> > I was looking at bnxt because it's relatively standard for DC NICs and
> > doesn't have 10M lines of code.. then again I could be misinterpreting
> > the code, I haven't tested this theory:
> > 
> > In bnxt_set_pauseparam() for example the driver will send a request to
> > the FW which will result in the link coming down and back up with
> > different settings (e.g. when pause autoneg was changed). Since the
> > driver doesn't call netif_carrier_off() explicitly as part of sending
> > the FW message but the link down gets reported thru the usual interrupt
> > (as if someone yanked the cable out) - we need to wrap the FW call with
> > the __LINK_STATE_NOCARRIER_LOCAL  
> 
> I'm not sure this is a good example. If the PHY is doing an autoneg,
> the link really is down for around a second. The link peer will also
> so the link go down and come back up. So this seems like a legitimate
> time to set the carrier off and then back on again.

In the commit message I differentiated between link flaps type (1), 
(2), (3a) and (3b). What we're talking about here is (1) vs (2), and
from the POV of the remote end (3a) vs (3b).

For a system which wants to monitor link quality on the local end =>
i.e. whether physical hardware has to be replaced - differentiating
between (1) and (2) doesn't really matter, they are both non-events.

I admitted somewhere in the commit message that with just the "locally
triggered" vs "non-locally triggered" we still can't tell (1) from (2)
and therefore won't be able to count true "link went down because of
signal integrity" events. Telling (1) from (2) should be easier with
phylib than with FW-managed PHYs. I left it for future work because:

 - in DC environments PHYs are never managed by Linux AFAIK, sadly,
   and unless I convince vendors to do the conversions I'm likely going
   to get the counting between (1) and (2) wrong, not having access to
   FW or any docs;

 - switches don't flap links much, while NIC reconfig can easily produce
   spikes of 5+ carrier changes in close succession so even without
   telling (1) from (2) we can increase the signal of the monitoring
   significantly

I'm happy to add the (1) vs (2) API tho if it's useful, what I'm
explaining is more why I don't feel its useful for my case.

> > > The driver has a few netif_carrier_off() calls changed to
> > > netif_carrier_admin_off(). It is then unclear looking at the code
> > > which of the calls to netif_carrier_on() match the off.  
> > 
> > Right, for bnxt again the carrier_off in bnxt_tx_disable() would become
> > an admin_carrier_off, since it's basically part of closing the netdev.  
> 
> > > Maybe include a driver which makes use of phylib, which should be
> > > doing control of the carrier based on the actual link status.  
> > 
> > For phylib I was thinking of modifying phy_stop()... but I can't
> > grep out where carrier_off gets called. I'll take a closer look.  
> 
> If the driver is calling phy_stop() the link will go down. So again, i
> would say setting the carrier off is correct. If the driver calls
> phy_start() an auto neg is likely to happen and 1 second later the
> link will come up.
> 
> Maybe i'm not understanding what you are trying to count here. If the
> MAC driver needs to stop the MAC in order to reallocate buffers with
> different MTU, or more rings etc, then i can understand not wanting to
> count that as a carrier off, because the carrier does not actually go
> off. But if it is in fact marking the carrier off, it sounds like a
> MAC driver bug, or a firmware bug.

Well, either way the carrier is set to off because of all the calls to
netif_carrier_ok() calls throughout the stack. I'm afraid to change the
semantics of that.

What I want to count is _in_addition_ to whether the link went down or
not - whether the link down was due to local administrative action.

Then user space can do:

	remote_flaps = carrier_down - carrier_down_local
