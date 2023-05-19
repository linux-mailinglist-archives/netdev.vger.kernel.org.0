Return-Path: <netdev+bounces-3993-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9471C709F6D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 20:51:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 511BB281DC3
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CC4112B95;
	Fri, 19 May 2023 18:51:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD8211C8F
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 18:51:05 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D61110C9
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:50:46 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q05BC-0000rT-Ex; Fri, 19 May 2023 20:50:18 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q05B9-00025q-TE; Fri, 19 May 2023 20:50:15 +0200
Date: Fri, 19 May 2023 20:50:15 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Woojung Huh <woojung.huh@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
	Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 1/2] net: dsa: microchip: ksz8: Make flow
 control, speed, and duplex on CPU port configurable
Message-ID: <20230519185015.GA18246@pengutronix.de>
References: <20230519124700.635041-1-o.rempel@pengutronix.de>
 <20230519124700.635041-2-o.rempel@pengutronix.de>
 <20230519143004.luvz73jiyvnqxk4y@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230519143004.luvz73jiyvnqxk4y@skbuf>
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

Hi Vladimir,

On Fri, May 19, 2023 at 05:30:04PM +0300, Vladimir Oltean wrote:
> On Fri, May 19, 2023 at 02:46:59PM +0200, Oleksij Rempel wrote:
> > +void ksz8_phylink_mac_link_up(struct ksz_device *dev, int port,
> > +			      unsigned int mode, phy_interface_t interface,
> > +			      struct phy_device *phydev, int speed, int duplex,
> > +			      bool tx_pause, bool rx_pause)
> > +{
> > +	/* If the port is the CPU port, apply special handling. Only the CPU
> > +	 * port is configured via global registers.
> > +	 */
> > +	if (dev->cpu_port == port)
> > +		ksz8_cpu_port_link_up(dev, speed, duplex, tx_pause, rx_pause);
> > +}
> 
> I'm sorry, but this is also baking in assumptions related to the
> topology of the tree (that the xMII port is used as a CPU port).
> The ksz8 driver may make this assumption in other places too,
> but I don't want to make it even worse to fix. Is the
> !dev->info->internal_phy[port] condition not enough here?

Thank you for your feedback. I see your point. 

We need to remember that the KSZ switch series has different types of
ports. Specifically, for the KSZ8 series, there's a unique port. This
port is unique because it's the only one that can be configured with
global registers, and it is only one supports tail tagging. This special
port is already referenced in the driver by "dev->cpu_port", so I continued
using it in my patch.

It is important to note that while this port has an xMII interface, it
is not the only port that could have an xMII interface. Therefore, using
"dev->info->internal_phy" may not be the best way to identify this port,
because there can be ports that are not global/cpu, have an xMII
interface, but don't have an internal PHY.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

