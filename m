Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652136232D8
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbiKISqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiKISqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:46:34 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7D66567
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=DZcxXNNkxtFe5fUZCH2nVjOPxAGiyC70XgGgdHF6Ah8=; b=dwU1eZNNsGdGS49/1tVd0/iEX3
        8ZW2do9Pe+RrdDurcuKlCAU5eGM5TdJLpFQv7Rh6hyfmio4WrcBcX63TbeKJ0SoCJRHxa4TaT2aeZ
        e8MNLgVaRuxsFZC3H/3Lb6VW2478zWRObZowQbVyRHKKSb/oBA7uNwy5IxhtaVy334QI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osq5l-001wWr-07; Wed, 09 Nov 2022 19:46:29 +0100
Date:   Wed, 9 Nov 2022 19:46:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rodolfo Giometti <giometti@enneenne.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <shemminger@osdl.org>,
        Flavio Leitner <fbl@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net br_netlink.c:y allow non "disabled" state for
 !netif_oper_up() links
Message-ID: <Y2v1hORCE+dPkjwW@lunn.ch>
References: <20221109152410.3572632-1-giometti@enneenne.com>
 <20221109152410.3572632-2-giometti@enneenne.com>
 <Y2vkwYyivfTqAfEp@lunn.ch>
 <1c6ce1f3-a116-7a17-145e-712113a99f1e@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c6ce1f3-a116-7a17-145e-712113a99f1e@enneenne.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 07:19:22PM +0100, Rodolfo Giometti wrote:
> On 09/11/22 18:34, Andrew Lunn wrote:
> > On Wed, Nov 09, 2022 at 04:24:10PM +0100, Rodolfo Giometti wrote:
> > > A generic loop-free network protocol (such as STP or MRP and others) may
> > > require that a link not in an operational state be into a non "disabled"
> > > state (such as listening).
> > > 
> > > For example MRP states that a MRM should set into a "BLOCKED" state (which is
> > > equivalent to the LISTENING state for Linux bridges) one of its ring
> > > connection if it detects that this connection is "DOWN" (that is the
> > > NO-CARRIER status).
> > 
> > Does MRP explain Why?
> > 
> > This change seems odd, and "Because the standard says so" is not the
> > best of explanations.
> 
> A MRM instance has two ports: primary port (PRM_RPort) and secondary port
> (SEC_RPort).
> 
> When both ports are UP (that is the CARRIER is on) the MRM is into the
> Ring_closed state and the PRM_RPort is in forwarding state while the
> SEC_RPort is in blocking state (remember that MRP blocking is equal to Linux
> bridge listening).
> 
> If the PRM_RPort losts its carrier and the link goes down the normative states that:
> 
> - ports role swap (PRM_RPort becomes SEC_RPort and vice versa).
> 
> - SEC_RPort must be set into blocking state.
> 
> - PRM_RPort must be set into forwarding state.
> 
> Then the MRM moves into a new state called Primary-UP. In this state, when
> the SEC_RPort returns to UP state (that is the CARRIER is up) it's returns
> into the Ring_closed state where both ports have the right status, that is
> the PRM_RPort is in forwarding state while the SEC_RPort is in blocking
> state.
> 
> This is just an example of one single case, but consider that, in general,
> when the carrier is lost the port state is moved into blocking so that when
> the carrier returns the port it's already into the right state.
> 
> Hope it's clearer now.

Yes, please add this to the commit message. The commit message is
supposed to explain Why, and this is a good example.
 
> However, despite this special case, I think that kernel code should
> implement mechanisms and not policies, shouldn't it? If user space needs a
> non operational port (that is with no carrier) into the listening state, why
> we should prevent it?

Did you dig deeper? Does the bridge make use of switchdev to tell the
hardware about this state change while the carrier is down? I also
wonder what the hardware drivers do? Since this is a change in
behaviour, they might not actually do anything. So then you have to
consider does it make sense for the bridge to set the state again
after the carrier comes up?

       Andrew
