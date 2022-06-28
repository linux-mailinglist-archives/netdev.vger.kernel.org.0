Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFC455DA03
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237786AbiF1Ipn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245489AbiF1Ipk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:45:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D55C48
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 01:45:11 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o66qI-0002yY-8s; Tue, 28 Jun 2022 10:45:06 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o66qG-0000Bz-Ok; Tue, 28 Jun 2022 10:45:04 +0200
Date:   Tue, 28 Jun 2022 10:45:04 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <20220628084504.GA31626@pengutronix.de>
References: <20220624125902.4068436-1-o.rempel@pengutronix.de>
 <20220624125902.4068436-2-o.rempel@pengutronix.de>
 <20220624220317.ckhx6z7cmzegvoqi@skbuf>
 <20220626171008.GA7581@pengutronix.de>
 <20220627091521.3b80a4e8@kernel.org>
 <20220627200238.en2b5zij4sakau2t@skbuf>
 <20220627200959.683de11b@kernel.org>
 <YrqsTY0uUy4AwKHN@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YrqsTY0uUy4AwKHN@lunn.ch>
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

On Tue, Jun 28, 2022 at 09:22:53AM +0200, Andrew Lunn wrote:
> > Yeah, the corrections are always iffy. I understand the doubts, and we
> > can probably leave things "under-specified" until someone with a strong
> > preference comes along. But I hope that the virt example makes it clear
> > that neither of the choices is better (SR-IOV NICs would have to start
> > adding the pause if we declare rtnl stats as inclusive).
> > 
> > I can see advantages to both counting (they are packets) and not
> > counting those frames (Linux doesn't see them, they get "invented" 
> > by HW).
> > 
> > Stats are hard.
> 
> I doubt we can define it either way. I once submitted a patch for one
> driver to make it ignore CRC bytes. It then gave the exact same counts
> as another hardware i was using, making the testing i was doing
> simpler.
> 
> The patch got rejected simply because we have both, with CRC and
> without CRC, neither is correct, neither is wrong.
> 
> So i would keep it KISS, pause frames can be included, but i would not
> go to extra effort to include them, or to exclude them.

After I started investigating this topic, I was really frustrated. It is
has hard to find what is wrong: my patch is not working and flow
controller is not triggered? Or every HW/driver implements counters in
some own way. Same is about byte counts: for same packet with different
NICs i have at least 3 different results: 50, 64 and 68.
It makes testing and validation a nightmare. 

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
