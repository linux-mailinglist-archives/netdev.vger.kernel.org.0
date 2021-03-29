Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9B334D62E
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 19:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhC2Rky convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Mar 2021 13:40:54 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:36058 "EHLO unicorn.mansr.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhC2Rkh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 13:40:37 -0400
Received: from raven.mansr.com (raven.mansr.com [IPv6:2001:8b0:ca0d:8d8e::3])
        by unicorn.mansr.com (Postfix) with ESMTPS id 5083115360;
        Mon, 29 Mar 2021 18:40:35 +0100 (BST)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id 42E1121A6CA; Mon, 29 Mar 2021 18:40:35 +0100 (BST)
From:   =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To:     <Andre.Edich@microchip.com>
Cc:     <Parthiban.Veerasooran@microchip.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: phy: lan87xx: fix access to wrong
 register of LAN87xx
References: <20210329094536.3118619-1-andre.edich@microchip.com>
        <yw1xblb2fbrg.fsf@mansr.com>
        <53b244ad343f4fa9533ff5fa1e2b0b25ba92a984.camel@microchip.com>
Date:   Mon, 29 Mar 2021 18:40:35 +0100
In-Reply-To: <53b244ad343f4fa9533ff5fa1e2b0b25ba92a984.camel@microchip.com>
        (Andre Edich's message of "Mon, 29 Mar 2021 12:07:28 +0000")
Message-ID: <yw1x7dlpg8oc.fsf@mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<Andre.Edich@microchip.com> writes:

> On Mon, 2021-03-29 at 12:19 +0100, Måns Rullgård wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know
>> the content is safe
>> 
>> Andre Edich <andre.edich@microchip.com> writes:
>> 
>> > The function lan87xx_config_aneg_ext was introduced to configure
>> > LAN95xxA but as well writes to undocumented register of LAN87xx.
>> > This fix prevents that access.
>> > 
>> > The function lan87xx_config_aneg_ext gets more suitable for the new
>> > behavior name.
>> > 
>> > Reported-by: Måns Rullgård <mans@mansr.com>
>> > Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
>> > Signed-off-by: Andre Edich <andre.edich@microchip.com>
>> > ---
>> >  drivers/net/phy/smsc.c | 7 +++++--
>> >  1 file changed, 5 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
>> > index ddb78fb4d6dc..d8cac02a79b9 100644
>> > --- a/drivers/net/phy/smsc.c
>> > +++ b/drivers/net/phy/smsc.c
>> > @@ -185,10 +185,13 @@ static int lan87xx_config_aneg(struct
>> > phy_device *phydev)
>> >       return genphy_config_aneg(phydev);
>> >  }
>> > 
>> > -static int lan87xx_config_aneg_ext(struct phy_device *phydev)
>> > +static int lan95xx_config_aneg_ext(struct phy_device *phydev)
>> >  {
>> >       int rc;
>> > 
>> > +     if (phydev->phy_id != 0x0007c0f0) /* not (LAN9500A or LAN9505A)
>> > */
>> > +             return lan87xx_config_aneg(phydev);
>> > +
>> >       /* Extend Manual AutoMDIX timer */
>> >       rc = phy_read(phydev, PHY_EDPD_CONFIG);
>> >       if (rc < 0)
>> > @@ -441,7 +444,7 @@ static struct phy_driver smsc_phy_driver[] = {
>> >       .read_status    = lan87xx_read_status,
>> >       .config_init    = smsc_phy_config_init,
>> >       .soft_reset     = smsc_phy_reset,
>> > -     .config_aneg    = lan87xx_config_aneg_ext,
>> > +     .config_aneg    = lan95xx_config_aneg_ext,
>> > 
>> >       /* IRQ related */
>> >       .config_intr    = smsc_phy_config_intr,
>> > --
>> 
>> This seems to differentiate based on the "revision" field of the ID
>> register.  Can we be certain that a future update of chip won't break
>> this assumption?
>
> The way to fail would be to "fix" and release any of LAN95xxA in the
> way that the register map will is changed or feature is disabled but
> the Phy ID  remains the same.  This is very unlikely and obviously
> wrong.  I don't believe this may happen.
>
> If a new chip with the different Phy ID but the same feature will be
> released, then it must be explicitly added into the table.
>
> Is there a third case I don't see?

I was thinking that an updated LAN9500A might get the revision field set
to 1, making it indistinguishable from a LAN8710A.  That wouldn't break
anything as such, but that bit wouldn't get set either.  It seems
unlikely that this will ever happen, though, and it if it does, it can
be dealt with then.

Some rummaging in my boxes of old boards turned up both A and B
revisions of the LAN8720A, and they both have the same ID register value
(0xc0f1).  I had wondered if the A version might have had the revision
field set to 0, but apparently not.

-- 
Måns Rullgård
