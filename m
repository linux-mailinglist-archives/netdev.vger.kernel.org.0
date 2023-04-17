Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EF96E4673
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 13:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjDQL36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 07:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjDQL3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 07:29:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E61D93D6
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 04:28:57 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1poMdd-0000eR-4a; Mon, 17 Apr 2023 13:03:13 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1poMdb-0005No-Nb; Mon, 17 Apr 2023 13:03:11 +0200
Date:   Mon, 17 Apr 2023 13:03:11 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: Add partial ACL
 support for ksz9477 switches
Message-ID: <20230417110311.GA11474@pengutronix.de>
References: <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
 <20230416165658.fuo7vwer7m7ulkg2@skbuf>
 <20230417045710.GB20350@pengutronix.de>
 <20230417101209.m5fhc7njeeomljkf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230417101209.m5fhc7njeeomljkf@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 01:12:09PM +0300, Vladimir Oltean wrote:
> On Mon, Apr 17, 2023 at 06:57:10AM +0200, Oleksij Rempel wrote:
> > > On Tue, Apr 11, 2023 at 07:24:55PM +0200, Oleksij Rempel wrote:
> > > > The ACL also implements a count function, generating an interrupt
> > > > instead of a forwarding action. It can be used as a watchdog timer or an
> > > > event counter.
> > > 
> > > Is the interrupt handled here? I didn't see cls_flower_stats().
> > 
> > No, it is not implemented in this patch. It is generic description of things
> > ACL should be able to do. Is it confusing? Should I remove it?
> 
> No, it's confusing that the ACL statistics are not reported even though
> it's mentioned that it's possible...

Certain aspects of the chip specification appeared ambiguous, leading me
to decide to allocate a separate time slot for investigating the counter
topic if necessary.

For example, according to the
KSZ9477 4.4.18 ACCESS CONTROL LIST (ACL) FILTERING:

"It is also possible to configure the ACL table so that multiple processing
entries specify the same action rule. In this way, the final matching result is
the OR of the matching results from each of the multiple RuleSets.
The 16 ACL rules represent an ordered list, with entry #0 having the highest
priority and entry #15 having the lowest priority. All matching rules are
evaluated. If there are multiple true match results and multiple corresponding
actions, the highest priority (lowest numbered) of those actions will be the
one taken."

A summary of this part of documentation is:
1. ACL table can have multiple entries specifying the same action rule.
2. Final matching result is the OR of multiple RuleSets' results.
3. 16 ACL rules form an ordered list, with priority descending from #0 to #15.
4. All matching rules are evaluated.
5. When multiple true matches and actions occur, the highest priority action is
   executed.

Considering this, there is a possibility that separate action rules would not
be executed, as they might not be the highest priority match.  Since counters
would have separation action rules, they would not be executed or prevent other
action rules from execution.

To confirm my hypothesis, additional time and testing will be required.
Nonetheless, I hope this issue does not impede the progress of this patch.

> > > Have you considered the "skbedit priority" action as opposed to hw_tc?
> > 
> > I had already thought of that, but since bridging is offloaded in the HW
> > no skbs are involved, i thought it will be confusing. Since tc-flower seems to
> > already support hw_tc remapping, I decided to use it. I hope it will not harm,
> > to use it for now as mandatory option and make it optional later if other
> > actions are added, including skbedit.
> 
> Well, skbedit is offloadable, so in that sense, its behavior is defined
> even when no skbs are involved. OTOH, skbedit also has a software data
> path (sets skb->priority), as opposed to hw_tc, which last time I checked,
> did not.

Alright, having tc rules be portable is certainly a benefit. I presume
that in this situation, it's not an exclusive "either...or" choice. Both
variants can coexist, and the skbedit action can be incorporated at a
later time. Is that accurate?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
