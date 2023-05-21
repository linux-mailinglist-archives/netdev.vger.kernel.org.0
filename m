Return-Path: <netdev+bounces-4088-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27FDA70AC5D
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 06:39:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46382281071
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 04:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 514B57EF;
	Sun, 21 May 2023 04:38:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F61A29
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 04:38:56 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F6510D
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 21:38:55 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q0aqD-0005hY-W3; Sun, 21 May 2023 06:38:46 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q0aq9-0000RO-Na; Sun, 21 May 2023 06:38:41 +0200
Date: Sun, 21 May 2023 06:38:41 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Woojung Huh <woojung.huh@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	UNGLinuxDriver@microchip.com,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 1/2] net: dsa: microchip: ksz8: Make flow
 control, speed, and duplex on CPU port configurable
Message-ID: <20230521043841.GA22442@pengutronix.de>
References: <20230519124700.635041-1-o.rempel@pengutronix.de>
 <20230519124700.635041-2-o.rempel@pengutronix.de>
 <20230519143004.luvz73jiyvnqxk4y@skbuf>
 <20230519185015.GA18246@pengutronix.de>
 <20230519203449.pc5vbfgbfc6rdo6i@skbuf>
 <20230520050317.GC18246@pengutronix.de>
 <20230520151708.24duenxufth4xsh5@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230520151708.24duenxufth4xsh5@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
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

On Sat, May 20, 2023 at 06:17:08PM +0300, Vladimir Oltean wrote:
> On Sat, May 20, 2023 at 07:03:17AM +0200, Oleksij Rempel wrote:
> > On Fri, May 19, 2023 at 11:34:49PM +0300, Vladimir Oltean wrote:
> > > On Fri, May 19, 2023 at 08:50:15PM +0200, Oleksij Rempel wrote:
> > > > Thank you for your feedback. I see your point. 
> > > > 
> > > > We need to remember that the KSZ switch series has different types of
> > > > ports. Specifically, for the KSZ8 series, there's a unique port. This
> > > > port is unique because it's the only one that can be configured with
> > > > global registers, and it is only one supports tail tagging. This special
> > > > port is already referenced in the driver by "dev->cpu_port", so I continued
> > > > using it in my patch.
> > > 
> > > Ok, I understand, so for the KSZ8 family, the assumption about which
> > > port will use tail tagging is baked into the hardware.
> > > 
> > > > It is important to note that while this port has an xMII interface, it
> > > > is not the only port that could have an xMII interface. Therefore, using
> > > > "dev->info->internal_phy" may not be the best way to identify this port,
> > > > because there can be ports that are not global/cpu, have an xMII
> > > > interface, but don't have an internal PHY.
> > > 
> > > Right, but since we're talking about phylink, the goal is to identify
> > > the xMII ports, not the CPU ports... This is a particularly denatured
> > > case because the xMII port is global and is also the CPU port.
> > 
> > I see. Do you have any suggestions for a better or more suitable
> > implementation? I'm open to ideas.
> 
> Trying to answer here for both questions. In the RFC/RFT patch set I had
> posted, I introduced the concept of "wacky" registers, which are registers
> which should be per port (and are accessed as per-port by the driver),
> but because there is a single such port in the switch, the hardware
> design degenerated into moving them in the global area. Nonetheless,
> treating the xMII global registers as per-port makes it possible for the
> common driver to share more code between KSZ8 and others.
> 
> If you look at ksz9477_phylink_mac_link_up() - renamed to just
> ksz_phylink_mac_link_up() in my patch set - hard enough, you can see
> that it makes an attempt to generalize the "link up" procedure for all
> switch families, via these regs and fields. At the end of that regfield
> series, I theoretically converted KSZ8765/KSZ8794/KSZ8795 to reuse
> ksz9477_phylink_mac_link_up(). Theoretically because no one commented
> on whether the result still worked.
> 
> I think that regfields and that KSZ_WACKY_REG_FIELD_8() are an avenue
> worth exploring here.
> 

Looks good, I like the idea with "wacky" registers!

Would you prefer that I start working on adapting your patch set to the
KSZ8873? Or should I make a review to move forward the existing patch set?

Just a heads up, I don't have access to the KSZ87xx series switches, so
I won't be able to test the changes on these models.

Let me know what you think and how we should proceed.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

