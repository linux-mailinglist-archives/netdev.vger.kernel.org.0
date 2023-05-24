Return-Path: <netdev+bounces-5153-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5002970FD40
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CBA828131E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8721A20696;
	Wed, 24 May 2023 17:53:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7448A1D2C1
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:53:17 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4244D3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 10:53:15 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q1sfc-0000HV-6w; Wed, 24 May 2023 19:53:08 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q1sfb-0002aT-4A; Wed, 24 May 2023 19:53:07 +0200
Date: Wed, 24 May 2023 19:53:07 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
	Eric Dumazet <edumazet@google.com>,
	Vladimir Oltean <olteanv@gmail.com>, kernel@pengutronix.de,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 2/5] net: dsa: microchip: add an enum for
 regmap widths
Message-ID: <20230524175307.GB7074@pengutronix.de>
References: <20230524123220.2481565-1-o.rempel@pengutronix.de>
 <20230524123220.2481565-3-o.rempel@pengutronix.de>
 <9b1b2f17-0489-4adb-8e17-594a813c2dc9@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9b1b2f17-0489-4adb-8e17-594a813c2dc9@lunn.ch>
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

On Wed, May 24, 2023 at 07:03:38PM +0200, Andrew Lunn wrote:
> On Wed, May 24, 2023 at 02:32:17PM +0200, Oleksij Rempel wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > It is not immediately obvious that this driver allocates, via the
> > KSZ_REGMAP_TABLE() macro, 3 regmaps for register access: dev->regmap[0]
> > for 8-bit access, dev->regmap[1] for 16-bit and dev->regmap[2] for
> > 32-bit access.
> > 
> > In future changes that add support for reg_fields, each field will have
> > to specify through which of the 3 regmaps it's going to go. Add an enum
> > now, to denote one of the 3 register access widths, and make the code go
> > through some wrapper functions for easier review and further
> > modification.
> 
> Given the patches in this series, it is not obvious why the wrapper is
> needed.
> 
> dev->regmap[KSZ_REGMAP_8] is just as readable as ksz_regmap_8(dev).
>
> Do future changes add extra parameters to ksz_regmap_8()?

As for me, it looks short. Less problems with line length restrictions.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

