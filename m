Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D646B8C58
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjCNIBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCNIBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:01:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193DD58C33
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 01:01:20 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pbzav-0001sE-7V; Tue, 14 Mar 2023 09:01:17 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pbzas-0003Eh-ER; Tue, 14 Mar 2023 09:01:14 +0100
Date:   Tue, 14 Mar 2023 09:01:14 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>, kernel@pengutronix.de,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 0/2] net: dsa: microchip: tc-ets support
Message-ID: <20230314080114.GA28733@pengutronix.de>
References: <20230310090809.220764-1-o.rempel@pengutronix.de>
 <20230313121833.1942244e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230313121833.1942244e@kernel.org>
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 12:18:33PM -0700, Jakub Kicinski wrote:
> On Fri, 10 Mar 2023 10:08:07 +0100 Oleksij Rempel wrote:
> > changes v3:
> > - add tc_ets_supported to match supported devices
> > - dynamically regenerated default TC to queue map.
> > - add Acked-by to the first patch
> > 
> > changes v2:
> > - run egress limit configuration on all queue separately. Otherwise
> >   configuration may not apply correctly.
> 
> I thought Vladimir was suggesting mqprio, could you summarize the take
> aways from that discussion?

Both Qdiscs are suitable for my use case, but I prefer tc-ets because it
aligns better with the abilities of the KSZ9477 family of switches.
However, I won't be able to support only the deficit round-robin
functionality of tc-ets with this hardware. On the other hand, tc-mqprio
has more features that are not supported by this switch, such as TXQ
grouping, bandwidth limit, and DCB support. The advanced mapping
functionality of tc-mqprio, which involves mapping SO_PRIORITY to TCs
and then to TXQ groups, can also be confusing. For my use case, only TC
to TXQ mapping is needed.

Futures of tc-mqprio:
- all TXQ groups use a strict priority transmission selection algorithm
  (TSA). Within one TXQ group probably round robin robin TSA is used.
- Number of supported traffic classes (TCs) is equal to the number of
  TXQ groups.
- TCs have predefined priorities. TC0 == minimal prio and transmitted
  last if TCn> TC0 exists.
- flexible mapping of all SO_PRIORITYs to TCs
- flexible mapping of TCs to TXQ groups.
- configurable bandwidth limit per TXQ group.

Futures of tc-ets:
- supports strict priority and deficit round robin (DRR) TSA. Both
  variants can be combined.
- quantum of each DRR band can be flexibly configured.
- each band has predefined priority and mapped directly to a TXQ.
- Supports max 16 TCs. Each TC can be flexibly mapped to a band==TXQ.

Futures of KSZ9477 family:
- Supports up to 4 TXQs. LANxxxx variants support up to 8 TXQs
- Each TXQ can be configured to strict priority or to weighted round
  robin (WRR) TSA.
- If bandwidth configuration per TXQ is used TSA falls back to simple
  round robin.
- TXQs can’t be grouped without breaking strict priority TSA
- Max 8 TCs are supported and can be flexibly mapped to TXQs

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
