Return-Path: <netdev+bounces-3355-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F22706A04
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:36:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD91F1C20E03
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9AD71DDDD;
	Wed, 17 May 2023 13:36:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB57418B0D
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 13:36:22 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96263527D
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 06:36:20 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1pzHJm-0007qT-Sa; Wed, 17 May 2023 15:35:50 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1pzHJl-0006VT-4O; Wed, 17 May 2023 15:35:49 +0200
Date: Wed, 17 May 2023 15:35:49 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>, kernel@pengutronix.de,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v2 1/2] net: dsa: microchip: ksz8: Make flow
 control, speed, and duplex on CPU port configurable
Message-ID: <20230517133549.GA8586@pengutronix.de>
References: <20230517121034.3801640-1-o.rempel@pengutronix.de>
 <20230517121034.3801640-2-o.rempel@pengutronix.de>
 <ZGTMepjv33bJbck/@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZGTMepjv33bJbck/@shell.armlinux.org.uk>
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
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 01:45:46PM +0100, Russell King (Oracle) wrote:
> On Wed, May 17, 2023 at 02:10:33PM +0200, Oleksij Rempel wrote:
> > +/**
> > + * ksz8_upstram_link_up - Configures the CPU/upstream port of the switch.
> > + * @dev: The KSZ device instance.
> > + * @port: The port number to configure.
> > + * @speed: The desired link speed.
> > + * @duplex: The desired duplex mode.
> > + * @tx_pause: If true, enables transmit pause.
> > + * @rx_pause: If true, enables receive pause.
> > + *
> > + * Description:
> > + * The function configures flow control and speed settings for the CPU/upstream
> > + * port of the switch based on the desired settings, current duplex mode, and
> > + * speed.
> > + */
> > +static void ksz8_upstram_link_up(struct ksz_device *dev, int port, int speed,
> > +				 int duplex, bool tx_pause, bool rx_pause)
> > +{
> > +	u8 ctrl = 0;
> > +
> > +	if (duplex) {
> > +		if (tx_pause || rx_pause)
> > +			ctrl |= SW_FLOW_CTRL;
> > +	} else {
> > +		ctrl |= SW_HALF_DUPLEX;
> > +		if (tx_pause || rx_pause)
> > +			ctrl |= SW_HALF_DUPLEX_FLOW_CTRL;
> 
> It's come up before whether the pause settings should be used to control
> half-duplex flow control, and I believe the decision was they shouldn't.

Got it, back pressure and pause for flow control are two different
things. I'll remove the half-duplex back pressure control using pause
settings from the patch.

> The other thing I find slightly weird is that this is only being done
> for upstream ports - why would a port that's between switches or the
> switch and the CPU be in half duplex mode?

As for the CPU port half-duplex mode, it's currently configurable via
the device tree. I don't have a specific use case for it, but it's there
if needed. If it's causing confusion though, I'm open to removing it.
What do you think?

> Also, why would such a port want to use some kind of flow control? If
> the CPU starts sending pause frames because its got stuck, doesn't
> that eventually kill the entire network? Also doesn't it limit the
> network bandwidth to the ability of the host CPU *not* to send
> pause frames?

Before this patch, flow control on the CPU port was indeed hard-coded.
This patch lets us disable it if we want to, giving us a bit more
flexibility.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

