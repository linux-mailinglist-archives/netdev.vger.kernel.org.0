Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076B11D2A0E
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgENI2c convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 May 2020 04:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725925AbgENI2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:28:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D505C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:28:31 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jZ9E3-00034w-Gf; Thu, 14 May 2020 10:28:19 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jZ9Dx-00079a-7M; Thu, 14 May 2020 10:28:13 +0200
Date:   Thu, 14 May 2020 10:28:13 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Christian Herber <christian.herber@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        Marek Vasut <marex@denx.de>
Subject: Re: [EXT] Re: signal quality and cable diagnostic
Message-ID: <20200514082813.GA1896@pengutronix.de>
References: <20200511141310.GA2543@pengutronix.de>
 <20200511143337.GC413878@lunn.ch>
 <20200512082201.GB16536@pengutronix.de>
 <AM0PR04MB7041DE18F2966573DB6E078586BC0@AM0PR04MB7041.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AM0PR04MB7041DE18F2966573DB6E078586BC0@AM0PR04MB7041.eurprd04.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:10:16 up 245 days, 20:58, 472 users,  load average: 45.38,
 32.12, 24.29
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

On Thu, May 14, 2020 at 07:13:30AM +0000, Christian Herber wrote:
> On Tue, May 12, 2020 at 10:22:01AM +0200, Oleksij Rempel wrote:
> 
> > So I think we should pass raw SQI value to user space, at least in the
> > first implementation.
> 
> > What do you think about this?
> 
> Hi Oleksij,
> 
> I had a check about the background of this SQI thing. The table you reference with concrete SNR values is informative only and not a requirement. The requirements are rather loose.
> 
> This is from OA:
> - Only for SQI=0 a link loss shall occur.
> - The indicated signal quality shall monotonic increasing /decreasing with noise level.
> - It shall be indicated in the datasheet at which level a BER<10^-10 (better than 10^-10) is achieved (e.g. "from SQI=3 to SQI=7 the link has a BER<10^-10 (better than 10^-10)")
> 
> I.e. SQI does not need to have a direct correlation with SNR. The fundamental underlying metric is the BER.
> You can report the raw SQI level and users would have to look up what it means in the respective data sheet. There is no guaranteed relation between SQI levels of different devices, i.e. SQI 5 can have lower BER than SQI 6 on another device.
> Alternatively, you could report BER < x for the different SQI levels. However, this requires the information to be available. While I could provide these for NXP, it might not be easily available for other vendors.
> If reporting raw SQI, at least the SQI level for BER<10^-10 should be presented to give any meaning to the value.

So the question is, which values to provide via KAPI to user space?

- SQI
  The PHY can probably measure the SNR quite fast and has some internal
  function or lookup table to deduct the SQI from the measured SNR.

  If I understand you correctly, we can only compare SQI values of the
  same PHY, as different PHYs give different SQIs for the same link
  characteristics (=SNR).
- SNR range
  We read the SQI from the PHY look up the SNR range for that value from
  the data sheet and provide that value to use space. This gives a
  better description of the quality of the link.
- "guestimated" BER
  The manufacturer of the PHY has probably done some extensive testing
  that a measured SNR can be correlated to some BER. This value may be
  provided in the data sheet, too.

The SNR seems to be most universal value, when it comes to comparing
different situations (different links and different PHYs). The
resolution of BER is not that detailed, for the NXP PHY is says only
"BER below 1e-10" or not.

> While I could provide these for NXP, it might not be easily available
> for other vendors.

It will be great if you can provide this information. It may force other
vendors to do the same :)

The actual procedure to measure the BER is the following testing
strategy suggested by opensig[1]:
--------------------------------------------------------------------------------
Procedure:
1. Configure the DUT as MASTER.
2. Connect the packet monitoring station to the automotive cable.
3. Connect the DUT to the automotive cable.
4. Send 2,470,000 1,518-byte packets (for a 10 -10 BER) and the monitor will
   count the number of packet errors.
5. Repeat step 4 for the remaining automotive cables.
6. Repeat steps 4-5 with the DUT configured as SLAVE.
--------------------------------------------------------------------------------

[1] http://www.opensig.org/download/document/225/Open_Alliance_100BASE-T1_PMA_Test_Suite_v1.0-dec.pdf

Regards,
Oleksij & Marc

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
