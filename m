Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB9F218652
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgGHLkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728742AbgGHLkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:40:41 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EDDC08C5DC;
        Wed,  8 Jul 2020 04:40:40 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 26C6A23068;
        Wed,  8 Jul 2020 13:40:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1594208439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nhbzphc6s/8yq5nZ/x51u8ir0EyNta3CXB0NHXBNL44=;
        b=oVO3nZeZvIULdQSkQc4xBlzwi81fGG7by7fvH4hp/qrBXeSMaziHJRSQ3UjJJcQQ6PIG4h
        /Qmk8QWW8Fvi4/Ie8rlb/omJlwhk+OGPlf913fsZ+mobVk4OW8HVTRzcHGiYu4Rk4Ie+cH
        HOuIV/cVIOcNFIuX12m6e/SKOFRGsXk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 08 Jul 2020 13:40:38 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v5 2/4] net: dsa: felix: (re)use already existing
 constants
In-Reply-To: <20200708104756.y42eid56w5jspl6u@skbuf>
References: <20200707212131.15690-1-michael@walle.cc>
 <20200707212131.15690-3-michael@walle.cc>
 <20200708104756.y42eid56w5jspl6u@skbuf>
User-Agent: Roundcube Webmail/1.4.6
Message-ID: <381859c567b9786f0320eb2a3a68c748@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-07-08 12:47, schrieb Vladimir Oltean:
> On Tue, Jul 07, 2020 at 11:21:29PM +0200, Michael Walle wrote:
>> Now that there are USXGMII constants available, drop the old 
>> definitions
>> and reuse the generic ones.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  drivers/net/dsa/ocelot/felix_vsc9959.c | 45 
>> +++++++-------------------
>>  1 file changed, 12 insertions(+), 33 deletions(-)
>> 
>> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c 
>> b/drivers/net/dsa/ocelot/felix_vsc9959.c
>> index 19614537b1ba..4310b1527022 100644
>> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
>> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
>> @@ -10,35 +10,15 @@
>>  #include <soc/mscc/ocelot.h>
>>  #include <net/pkt_sched.h>
>>  #include <linux/iopoll.h>
>> +#include <linux/mdio.h>
>>  #include <linux/pci.h>
>>  #include "felix.h"
>> 
>>  #define VSC9959_VCAP_IS2_CNT		1024
>>  #define VSC9959_VCAP_IS2_ENTRY_WIDTH	376
>>  #define VSC9959_VCAP_PORT_CNT		6
>> -
>> -/* TODO: should find a better place for these */
>> -#define USXGMII_BMCR_RESET		BIT(15)
>> -#define USXGMII_BMCR_AN_EN		BIT(12)
>> -#define USXGMII_BMCR_RST_AN		BIT(9)
>> -#define USXGMII_BMSR_LNKS(status)	(((status) & GENMASK(2, 2)) >> 2)
>> -#define USXGMII_BMSR_AN_CMPL(status)	(((status) & GENMASK(5, 5)) >> 
>> 5)
>> -#define USXGMII_ADVERTISE_LNKS(x)	(((x) << 15) & BIT(15))
>> -#define USXGMII_ADVERTISE_FDX		BIT(12)
>> -#define USXGMII_ADVERTISE_SPEED(x)	(((x) << 9) & GENMASK(11, 9))
>> -#define USXGMII_LPA_LNKS(lpa)		((lpa) >> 15)
>> -#define USXGMII_LPA_DUPLEX(lpa)		(((lpa) & GENMASK(12, 12)) >> 12)
>> -#define USXGMII_LPA_SPEED(lpa)		(((lpa) & GENMASK(11, 9)) >> 9)
>> -
>>  #define VSC9959_TAS_GCL_ENTRY_MAX	63
>> 
>> -enum usxgmii_speed {
>> -	USXGMII_SPEED_10	= 0,
>> -	USXGMII_SPEED_100	= 1,
>> -	USXGMII_SPEED_1000	= 2,
>> -	USXGMII_SPEED_2500	= 4,
>> -};
>> -
>>  static const u32 vsc9959_ana_regmap[] = {
>>  	REG(ANA_ADVLEARN,			0x0089a0),
>>  	REG(ANA_VLANMASK,			0x0089a4),
>> @@ -787,11 +767,10 @@ static void vsc9959_pcs_config_usxgmii(struct 
>> phy_device *pcs,
>>  {
>>  	/* Configure device ability for the USXGMII Replicator */
>>  	phy_write_mmd(pcs, MDIO_MMD_VEND2, MII_ADVERTISE,
>> -		      USXGMII_ADVERTISE_SPEED(USXGMII_SPEED_2500) |
>> -		      USXGMII_ADVERTISE_LNKS(1) |
>> +		      MDIO_LPA_USXGMII_2500FULL |
>> +		      MDIO_LPA_USXGMII_LINK |
>>  		      ADVERTISE_SGMII |
>> -		      ADVERTISE_LPACK |
>> -		      USXGMII_ADVERTISE_FDX);
>> +		      ADVERTISE_LPACK);
>>  }
>> 
>>  static void vsc9959_pcs_config(struct ocelot *ocelot, int port,
>> @@ -1005,8 +984,8 @@ static void vsc9959_pcs_link_state_usxgmii(struct 
>> phy_device *pcs,
>>  		return;
>> 
>>  	pcs->autoneg = true;
>> -	pcs->autoneg_complete = USXGMII_BMSR_AN_CMPL(status);
>> -	pcs->link = USXGMII_BMSR_LNKS(status);
>> +	pcs->autoneg_complete = status & BMSR_ANEGCOMPLETE;
>> +	pcs->link = status & BMSR_LSTATUS;
> 
> These are "unsigned :1" in struct phy_device, and not booleans. I'm not
> sure how the compiler is going to treat this assignment of an integer.
> I have a feeling it may not do the right thing.

Yeah I checked the same and assumed the compiler will convert/cast it, 
so
I deliberatly didn't do the "!!". But thinking about it again; there 
seems
to be no way this could work.

> Could you please do this?

sure.

-michael
