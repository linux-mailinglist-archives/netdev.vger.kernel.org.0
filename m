Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25B412CFDB
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 21:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfE1T6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 15:58:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36628 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfE1T6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 15:58:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BWe5zGzKFERdpiJ1zILX3VirELrzcDLhsUJV15QK4s4=; b=gPHL83CJgIwzEfYZD+a+XBjko5
        aMtLPgDcr6SSE7VJx+2Ej5DsNIM32nawNSfqHheLQiBvhh9IYSxo9Rg+aj/EPDn+1njT2/Y+CREg9
        Kwp74QFQSaQUyYrc2Qg9hIIixXXfmxK7UzKkIBdoW/khSYO5eRhu4ruH2eV1N+gV4v4g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hViEY-0002j0-Dq; Tue, 28 May 2019 21:58:06 +0200
Date:   Tue, 28 May 2019 21:58:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH V2] net: phy: tja11xx: Add IRQ support to the driver
Message-ID: <20190528195806.GV18059@lunn.ch>
References: <20190528192324.28862-1-marex@denx.de>
 <96793717-a55c-7844-f7c0-cc357c774a19@gmail.com>
 <4f33b529-6c3c-07ee-6177-2d332de514c6@denx.de>
 <cc8db234-4534-674d-eece-5a797a530cdf@gmail.com>
 <ca63964a-242c-bb46-bd4e-76a270dbedb3@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca63964a-242c-bb46-bd4e-76a270dbedb3@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 09:46:47PM +0200, Marek Vasut wrote:
> On 5/28/19 9:35 PM, Heiner Kallweit wrote:
> > On 28.05.2019 21:31, Marek Vasut wrote:
> >> On 5/28/19 9:28 PM, Heiner Kallweit wrote:
> >>> On 28.05.2019 21:23, Marek Vasut wrote:
> >>>> Add support for handling the TJA11xx PHY IRQ signal.
> >>>>
> >>>> Signed-off-by: Marek Vasut <marex@denx.de>
> >>>> Cc: Andrew Lunn <andrew@lunn.ch>
> >>>> Cc: Florian Fainelli <f.fainelli@gmail.com>
> >>>> Cc: Guenter Roeck <linux@roeck-us.net>
> >>>> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> >>>> Cc: Jean Delvare <jdelvare@suse.com>
> >>>> Cc: linux-hwmon@vger.kernel.org
> >>>> ---
> >>>> V2: - Define each bit of the MII_INTEN register and a mask
> >>>>     - Drop IRQ acking from tja11xx_config_intr()
> >>>> ---
> >>>>  drivers/net/phy/nxp-tja11xx.c | 48 +++++++++++++++++++++++++++++++++++
> >>>>  1 file changed, 48 insertions(+)
> >>>>
> >>>> diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
> >>>> index b705d0bd798b..b41af609607d 100644
> >>>> --- a/drivers/net/phy/nxp-tja11xx.c
> >>>> +++ b/drivers/net/phy/nxp-tja11xx.c
 > >>>> @@ -40,6 +40,29 @@
> >>>>  #define MII_INTSRC_TEMP_ERR		BIT(1)
> >>>>  #define MII_INTSRC_UV_ERR		BIT(3)
> >>>>  
> >>>> +#define MII_INTEN			22
> >>>> +#define MII_INTEN_PWON_EN		BIT(15)
> >>>> +#define MII_INTEN_WAKEUP_EN		BIT(14)
> >>>> +#define MII_INTEN_PHY_INIT_FAIL_EN	BIT(11)
> >>>> +#define MII_INTEN_LINK_STATUS_FAIL_EN	BIT(10)
> >>>> +#define MII_INTEN_LINK_STATUS_UP_EN	BIT(9)
> >>>> +#define MII_INTEN_SYM_ERR_EN		BIT(8)
> >>>> +#define MII_INTEN_TRAINING_FAILED_EN	BIT(7)
> >>>> +#define MII_INTEN_SQI_WARNING_EN	BIT(6)
> >>>> +#define MII_INTEN_CONTROL_ERR_EN	BIT(5)
> >>>> +#define MII_INTEN_UV_ERR_EN		BIT(3)
> >>>> +#define MII_INTEN_UV_RECOVERY_EN	BIT(2)
> >>>> +#define MII_INTEN_TEMP_ERR_EN		BIT(1)
> >>>> +#define MII_INTEN_SLEEP_ABORT_EN	BIT(0)
> >>>> +#define MII_INTEN_MASK							\
> >>>> +	(MII_INTEN_PWON_EN | MII_INTEN_WAKEUP_EN |			\
> >>>> +	MII_INTEN_PHY_INIT_FAIL_EN | MII_INTEN_LINK_STATUS_FAIL_EN |	\
> >>>> +	MII_INTEN_LINK_STATUS_UP_EN | MII_INTEN_SYM_ERR_EN |		\
> >>>> +	MII_INTEN_TRAINING_FAILED_EN | MII_INTEN_SQI_WARNING_EN |	\
> >>>> +	MII_INTEN_CONTROL_ERR_EN | MII_INTEN_UV_ERR_EN |		\
> >>>> +	MII_INTEN_UV_RECOVERY_EN | MII_INTEN_TEMP_ERR_EN |		\
> >>>> +	MII_INTEN_SLEEP_ABORT_EN)
> >>>
> >>> Why do you enable all these interrupt sources? As I said, phylib needs
> >>> link change info only.
> >>
> >> Because I need them to reliably detect that the link state changed.

Hi Marek

That statement suggests you started with just bits 10 and 9 and it
failed to detect some sort of link up/down event? What was missed?

       Andrew
