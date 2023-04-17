Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9166E3EA9
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 06:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjDQE5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 00:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjDQE53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 00:57:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3042D69
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 21:57:28 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1poGvQ-0003PV-EK; Mon, 17 Apr 2023 06:57:12 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1poGvO-0006SM-Ob; Mon, 17 Apr 2023 06:57:10 +0200
Date:   Mon, 17 Apr 2023 06:57:10 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: Add partial ACL
 support for ksz9477 switches
Message-ID: <20230417045710.GB20350@pengutronix.de>
References: <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
 <20230416165658.fuo7vwer7m7ulkg2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230416165658.fuo7vwer7m7ulkg2@skbuf>
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

Hi Vladimir,

On Sun, Apr 16, 2023 at 07:56:58PM +0300, Vladimir Oltean wrote:
> Hi Oleksij,
> 
> I only took a superficial look, and hence, here are some superficial comments.
> 
> On Tue, Apr 11, 2023 at 07:24:55PM +0200, Oleksij Rempel wrote:
> > The ACL also implements a count function, generating an interrupt
> > instead of a forwarding action. It can be used as a watchdog timer or an
> > event counter.
> 
> Is the interrupt handled here? I didn't see cls_flower_stats().

No, it is not implemented in this patch. It is generic description of things
ACL should be able to do. Is it confusing? Should I remove it?

> > The ACL consists of three parts: matching rules, action
> > rules, and processing entries. Multiple match conditions can be either
> > AND'ed or OR'ed together.
> > 
> > This patch introduces support for a subset of the available ACL
> > functionality, specifically layer 2 matching and prioritization of
> > matched packets. For example:
> > 
> > tc qdisc add dev lan2 clsact
> > tc filter add dev lan2 ingress protocol 0x88f7 flower skip_sw hw_tc 7
> > 
> > tc qdisc add dev lan1 clsact
> > tc filter add dev lan1 ingress protocol 0x88f7 flower skip_sw hw_tc 7
> 
> Have you considered the "skbedit priority" action as opposed to hw_tc?

I had already thought of that, but since bridging is offloaded in the HW
no skbs are involved, i thought it will be confusing. Since tc-flower seems to
already support hw_tc remapping, I decided to use it. I hope it will not harm,
to use it for now as mandatory option and make it optional later if other
actions are added, including skbedit.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
