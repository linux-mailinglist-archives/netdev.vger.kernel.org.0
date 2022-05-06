Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8053D51CE94
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377568AbiEFBWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 21:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347999AbiEFBWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 21:22:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91BD6129F
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 18:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=89A3BqXn4ZfRMO7Ga9StvWtqN0uFnQeeWAfsGXHRlfI=; b=TSN5kgFyrD/tYwoRaqBN6EsGDD
        0WxhwTFKFyUZJV5sF/y6WmIcP5idQgqlPwU5RvmR5uV38BuYqXo2QofLaN3C1Fa1NNUJKbb15dj65
        KiVfy66yoRToq9J/GR9lOuLniVogpD8CE/oDh0ZVvUSKpEhdkqRoO06aJZimBLYm5EYE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmmbu-001RvF-Kv; Fri, 06 May 2022 03:18:22 +0200
Date:   Fri, 6 May 2022 03:18:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH RFC] net: bridge: Clear offload_fwd_mark when passing
 frame up bridge interface.
Message-ID: <YnR3XikvI4tQy5IL@lunn.ch>
References: <20220505225904.342388-1-andrew@lunn.ch>
 <20220505160720.27358a55@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505160720.27358a55@hermes.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 04:07:20PM -0700, Stephen Hemminger wrote:
> On Fri,  6 May 2022 00:59:04 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > It is possible to stack bridges on top of each other. Consider the
> > following which makes use of an Ethernet switch:
> > 
> >        br1
> >      /    \
> >     /      \
> >    /        \
> >  br0.11    wlan0
> >    |
> >    br0
> >  /  |  \
> > p1  p2  p3
> > 
> > br0 is offloaded to the switch. Above br0 is a vlan interface, for
> > vlan 11. This vlan interface is then a slave of br1. br1 also has
> > wireless interface as a slave. This setup trunks wireless lan traffic
> > over the copper network inside a VLAN.
> > 
> > A frame received on p1 which is passed up to the bridge has the
> > skb->offload_fwd_mark flag set to true, indicating it that the switch
> > has dealt with forwarding the frame out ports p2 and p3 as
> > needed. This flag instructs the software bridge it does not need to
> > pass the frame back down again. However, the flag is not getting reset
> > when the frame is passed upwards. As a result br1 sees the flag,
> > wrongly interprets it, and fails to forward the frame to wlan0.
> > 
> > When passing a frame upwards, clear the flag.
> > 
> > RFC because i don't know the bridge code well enough if this is the
> > correct place to do this, and if there are any side effects, could the
> > skb be a clone, etc.
> > 
> > Fixes: f1c2eddf4cb6 ("bridge: switchdev: Use an helper to clear forward mark")
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> Bridging of bridges is not supposed to be allowed.
> See:
> 
> bridge:br_if.c
> 
> 	/* No bridging of bridges */
> 	if (dev->netdev_ops->ndo_start_xmit == br_dev_xmit) {
> 		NL_SET_ERR_MSG(extack,
> 			       "Can not enslave a bridge to a bridge");
> 		return -ELOOP;
> 	}

This is not direct bridging of bridges. There is a vlan interface in
the middle. And even if it is not supposed to work, it does work, it
is being used, and it regressed. This fixes the regression.

   Andrew
