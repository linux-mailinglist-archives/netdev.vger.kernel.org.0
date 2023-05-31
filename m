Return-Path: <netdev+bounces-6702-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 558E0717797
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:14:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E784E28136A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD758A922;
	Wed, 31 May 2023 07:14:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9EC7461
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:14:24 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004EC11F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:14:22 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q4G2G-0004zh-Pg; Wed, 31 May 2023 09:14:20 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q4G2F-0001bp-8d; Wed, 31 May 2023 09:14:19 +0200
Date: Wed, 31 May 2023 09:14:19 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
	netdev <netdev@vger.kernel.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [RFC/RFTv3 00/24] net: ethernet: Rework EEE
Message-ID: <20230531071419.GB17237@pengutronix.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <fa21ef50-7f36-3d01-5ecf-4a2832bcec89@gmail.com>
 <ZHZQG+O9HkQ+5K62@shell.armlinux.org.uk>
 <ZHZTXjnvw5nt2rSl@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZHZTXjnvw5nt2rSl@shell.armlinux.org.uk>
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
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Russell,

On Tue, May 30, 2023 at 08:49:50PM +0100, Russell King (Oracle) wrote:
> On Tue, May 30, 2023 at 08:35:55PM +0100, Russell King (Oracle) wrote:
> > Going back to phylib, given this, things get even more "fun" if you have
> > a dual-media PHY. As there's no EEE capability bits for 1000base-X, but
> > a 1000base-X PCS optionally supports EEE. So, even with a zero EEE
> > advertisement with a dual-media PHY that would only affect the copper
> > side, and EEE may still be possible in the fibre side... which makes
> > phylib's new interpretation of "eee_enabled" rather odd.
> > 
> > In any case, "eee_enabled" I don't think has much meaning for the fibre
> > case because there's definitely no control beyond what "tx_lpi_enabled"
> > already offers.
> > 
> > I think this is a classic case where the EEE interface has been designed
> > solely around copper without checking what the situation is for fibre!
> 
> Let me be a bit more explicit on this. If one does (e.g.) this:
> 
> # ethtool --set-eee eth0 advertise 0 tx-lpi on tx-timer 100
> 
> with a dual-media PHY, if the MAC is programmed to enable LPI, the
> dual-media PHY is linked via fibre, and the remote end supports fibre
> EEE, phylib will force "eee" to "off" purely on the grounds that the
> advertisement was empty.
> 
> If one looks at the man page for ethtool, it says:
> 
>            eee on|off
>                   Enables/disables the device support of EEE.
> 
> What does that mean, exactly, and how is it different from:
> 
>            tx-lpi on|off
>                   Determines whether the device should assert its Tx LPI.
> 
> since the only control at the MAC is whether LPI can be asserted or
> not and what the timer is.
> 
> The only control at the PHY end of things is what the advertisement
> is, if an advertisement even exists for the media type in use.
> 
> So, honestly, I don't get what this ethtool interface actually intends
> the "eee_enabled" control to do.

Thank you for your insightful observations on the EEE interface and its
related complexities, particularly in the case of fiber interfaces.

Your comments regarding the functionality of eee_enabled and
tx_lpi_enabled commands have sparked a good amount of thought on the
topic. Based on my understanding and observations, I've put together a
table that outlines the interactions between these commands, and their
influence on the MAC LPI status, PHY EEE advertisement, and the overall
EEE status on the link level.

For Copper assuming link partner advertise EEE as well:
+------+--------+------------+----------------+--------------------------------+---------------------------------+
| eee  | tx-lpi | advertise  | MAC LPI Status | PHY EEE Advertisement Status  | EEE Status on Link Level        |
+------+--------+------------+----------------+--------------------------------+---------------------------------+
| on   | on     |   !=0      | Enabled        | Advertise EEE for supported   | EEE enabled for supported       |
|      |        |            |                | speeds                        | speeds (Full EEE operation)     |
| on   | off    |   !=0      | Disabled       | Advertise EEE for supported   | EEE enabled for RX, disabled    |
|      |        |            |                | speeds                        | for TX (Partial EEE operation)  |
| off  | on     |   !=0      | Disabled       | No EEE advertisement          | EEE disabled                    |
| off  | off    |   !=0      | Disabled       | No EEE advertisement          | EEE disabled                    |
| on   | on     |    0       | Enabled        | No EEE advertisement          | EEE TX enabled, RX depends on   |
|      |        |            |                |                               | link partner                    |
| on   | off    |    0       | Disabled       | No EEE advertisement          | EEE disabled                    |
| off  | on     |    0       | Disabled       | No EEE advertisement          | EEE disabled                    |
| off  | off    |    0       | Disabled       | No EEE advertisement          | EEE disabled                    |
+------+--------+------------+----------------+--------------------------------+---------------------------------+

For Fiber:
+-----------+-----------+-----------------+---------------------+-------------------------+
|     eee   |   tx-lpi  | PHY EEE Adv.    | MAC LPI Status      | EEE Status on Link Level|
+-----------+-----------+-----------------+---------------------+-------------------------+
|     on    |     on    |         NA      | Enabled             | EEE supported           |
|     on    |     off   |         NA      | Disabled            | EEE not supported       |
|     off   |     on    |         NA      | Disabled            | EEE not supported       |
|     off   |     off   |         NA      | Disabled            | EEE not supported       |
+-----------+-----------+-----------------+---------------------+-------------------------+

In my perspective, eee_enabled serves as a global administrative control for
all EEE properties, including PHY EEE advertisement and MAC LPI status. When
EEE is turned off (eee_enabled = off), both PHY EEE advertisement and MAC LPI
status should be disabled, regardless of the tx_lpi_enabled setting.

On the other hand, advertise retains the EEE advertisement configuration, even
when EEE is turned off. This way, users can temporarily disable EEE without
losing their specific advertisement settings, which can then be reinstated when
EEE is turned back on.

In the context of fiber interfaces, where there is no concept of advertisement,
the eee and tx-lpi commands may appear redundant. However, maintaining both
commands could offer consistency across different media types in the ethtool
interface.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

