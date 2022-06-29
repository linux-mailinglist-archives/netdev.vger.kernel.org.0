Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50DB55F798
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiF2HIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 03:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbiF2HHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 03:07:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD5A6378
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 00:07:28 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o6RnJ-00031c-Tu; Wed, 29 Jun 2022 09:07:25 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o6RnH-0002BP-Lg; Wed, 29 Jun 2022 09:07:23 +0200
Date:   Wed, 29 Jun 2022 09:07:23 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Woojung Huh <woojung.huh@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Lukas Wunner <lukas@wunner.de>, kernel@pengutronix.de,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/3] net: dsa: ar9331: add support for pause
 stats
Message-ID: <20220629070723.GA951@pengutronix.de>
References: <20220624125902.4068436-1-o.rempel@pengutronix.de>
 <20220624125902.4068436-2-o.rempel@pengutronix.de>
 <20220624220317.ckhx6z7cmzegvoqi@skbuf>
 <20220626171008.GA7581@pengutronix.de>
 <20220627091521.3b80a4e8@kernel.org>
 <20220627200238.en2b5zij4sakau2t@skbuf>
 <20220627200959.683de11b@kernel.org>
 <YrqsTY0uUy4AwKHN@lunn.ch>
 <20220628084504.GA31626@pengutronix.de>
 <20220628091027.3693f3f9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220628091027.3693f3f9@kernel.org>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 09:10:27AM -0700, Jakub Kicinski wrote:
> On Tue, 28 Jun 2022 10:45:04 +0200 Oleksij Rempel wrote:
> > After I started investigating this topic, I was really frustrated. It is
> > has hard to find what is wrong: my patch is not working and flow
> > controller is not triggered? Or every HW/driver implements counters in
> > some own way. Same is about byte counts: for same packet with different
> > NICs i have at least 3 different results: 50, 64 and 68.
> > It makes testing and validation a nightmare. 
> 
> Yeah, I was gonna mention QA in my reply. The very practical reason I've
> gone no-CRC, no-flow control in the driver stats in the past was that it
> made it possible to test the counters are correct and the match far end.
> I mean SW matches HW, and they both match between sender/receiver
> (testing NIC-switch-NIC if either link does flow control the counters
> on NICs won't match).

Hm, may be it make sense to provide extra information on what the HW
counters do actually count? For example set flags, caps, for HW counting
pause frames in the main counter. I do not know if there are other use
cases where data is transferred but not counted except for FCS.

In case someone will hit a switch counting pause frames (like KSZ9477 do),
it will be better to know about it from user space. Instead of making
source code archeology.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
