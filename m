Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4666D5634
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 03:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjDDBn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 21:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbjDDBn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 21:43:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B75B124
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 18:43:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBC1E61F8D
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 01:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14ECC433D2;
        Tue,  4 Apr 2023 01:43:12 +0000 (UTC)
Message-ID: <0364516b-83b1-ed00-99d5-309c29a026c1@linux-m68k.org>
Date:   Tue, 4 Apr 2023 11:43:09 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: net: fec: Separate C22 and C45 transactions
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6a1f2f8b-003e-38f3-bd7f-75eeb0520740@linux-m68k.org>
 <c020e318-350c-4688-9851-0474993261ff@lunn.ch>
Content-Language: en-US
From:   Greg Ungerer <gerg@linux-m68k.org>
In-Reply-To: <c020e318-350c-4688-9851-0474993261ff@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 3/4/23 22:20, Andrew Lunn wrote:
> On Mon, Apr 03, 2023 at 02:41:46PM +1000, Greg Ungerer wrote:
>> Hi Andrew,
>>
>> On Mon, Jan 9, at 16:30 Andrew Lunn wrote:
>>> net: fec: Separate C22 and C45 transactions
>>> The fec MDIO bus driver can perform both C22 and C45 transfers.
>>> Create separate functions for each and register the C45 versions using
>>> the new API calls where appropriate.
>>
>> Are you sure that all FEC hardware blocks MDIO bus units support C45
>> transactions?
> 
> Hi Greg
> 
> My aim was to keep the existing behaviour. The old code did not have
> variant specific limitations to C45, so neither does the new. Meaning,
> the driver might of been broken before and it is still broken now. It
> is however more likely that broken behaviour is now invoked while
> scanning the bus for devices.

Yes, that is the case. The change in scanning behavior due to commit
1a136ca2e089 ("net: mdio: scan bus based on bus capabilities for C22
and C45") means that the c45 variant is now called - but wasn't before.


>>  From c4a2c5faf08593d0a3e14fefe996218df11d2c01 Mon Sep 17 00:00:00 2001
>> From: Greg Ungerer <gerg@linux-m68k.org>
>> Date: Mon, 3 Apr 2023 13:36:27 +1000
>> Subject: [PATCH] net: fec: make use of MDIO C45 a quirk
>>
>> Not all fec MDIO bus drivers support C45 mode. The older fec hardware
>> block in many ColdFire SoCs do not appear to support this, at least
>> according to most of the different ColdFire SoC reference manuals.
>> The bits used to generate C45 access on the iMX parts, in the OP field
>> of the MMFR register, are documented as generating non-compliant MII
>> frames (it is not documented as to exactly how they are non-compliant).
>>
>> Commit 8d03ad1ab0b0 ("net: fec: Separate C22 and C45 transactions")
>> means the fec driver will always register c45 MDIO read and write
>> methods. During probe these will always be accessed generating
>> non-complant MII accesses on ColdFire based devices.
>>
>> Add a quirk define, FEC_QUIRK_HAS_MDIO_C45, that can be used to
>> distinguish silicon that supports MDIO C45 framing or not. Add this to
>> all the existing iMX quirks, so they will be behave as they do now (*).
>>
>> (*) it seems that some iMX parts may not support C45 framing either.
>>      The iMX25 and iMX50 Reference Manuals contains similar wording to
>>      the ColdFire Reference Manuals on this.
>>
>> Fixes: 8d03ad1ab0b0 ("net: fec: Separate C22 and C45 transactions")
>> Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
>> ---
>>   drivers/net/ethernet/freescale/fec.h      |  5 ++++
>>   drivers/net/ethernet/freescale/fec_main.c | 32 ++++++++++++++---------
>>   2 files changed, 25 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
>> index 5ba1e0d71c68..9939ccafb556 100644
>> --- a/drivers/net/ethernet/freescale/fec.h
>> +++ b/drivers/net/ethernet/freescale/fec.h
>> @@ -507,6 +507,11 @@ struct bufdesc_ex {
>>   /* i.MX6Q adds pm_qos support */
>>   #define FEC_QUIRK_HAS_PMQOS			BIT(23)
>>   
>> +/* Not all FEC hardware block MDIOs support accesses in C45 mode.
>> + * Older blocks in the ColdFire parts do not support it.
>> + */
>> +#define FEC_QUIRK_HAS_MDIO_C45		BIT(24)
>> +
>>   struct bufdesc_prop {
>>   	int qid;
>>   	/* Address of Rx and Tx buffers */
>> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
>> index f3b16a6673e2..160c1b3525f5 100644
>> --- a/drivers/net/ethernet/freescale/fec_main.c
>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>> @@ -100,18 +100,19 @@ struct fec_devinfo {
>>   
>>   static const struct fec_devinfo fec_imx25_info = {
>>   	.quirks = FEC_QUIRK_USE_GASKET | FEC_QUIRK_MIB_CLEAR |
>> -		  FEC_QUIRK_HAS_FRREG,
>> +		  FEC_QUIRK_HAS_FRREG | FEC_QUIRK_HAS_MDIO_C45,
>>   };
>>   
>>   static const struct fec_devinfo fec_imx27_info = {
>> -	.quirks = FEC_QUIRK_MIB_CLEAR | FEC_QUIRK_HAS_FRREG,
>> +	.quirks = FEC_QUIRK_MIB_CLEAR | FEC_QUIRK_HAS_FRREG |
>> +		  FEC_QUIRK_HAS_MDIO_C45,
>>   };
>>   
>>   static const struct fec_devinfo fec_imx28_info = {
>>   	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
>>   		  FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
>>   		  FEC_QUIRK_HAS_FRREG | FEC_QUIRK_CLEAR_SETUP_MII |
>> -		  FEC_QUIRK_NO_HARD_RESET,
>> +		  FEC_QUIRK_NO_HARD_RESET | FEC_QUIRK_HAS_MDIO_C45,
>>   };
>>   
>>   static const struct fec_devinfo fec_imx6q_info = {
>> @@ -119,11 +120,12 @@ static const struct fec_devinfo fec_imx6q_info = {
>>   		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
>>   		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
>>   		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_CLEAR_SETUP_MII |
>> -		  FEC_QUIRK_HAS_PMQOS,
>> +		  FEC_QUIRK_HAS_PMQOS | FEC_QUIRK_HAS_MDIO_C45,
>>   };
>>   
>>   static const struct fec_devinfo fec_mvf600_info = {
>> -	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_RACC,
>> +	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_RACC |
>> +		  FEC_QUIRK_HAS_MDIO_C45,
>>   };
>>   
>>   static const struct fec_devinfo fec_imx6x_info = {
>> @@ -132,7 +134,8 @@ static const struct fec_devinfo fec_imx6x_info = {
>>   		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
>>   		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
>>   		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
>> -		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES,
>> +		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
>> +		  FEC_QUIRK_HAS_MDIO_C45,
>>   };
>>   
>>   static const struct fec_devinfo fec_imx6ul_info = {
>> @@ -140,7 +143,8 @@ static const struct fec_devinfo fec_imx6ul_info = {
>>   		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
>>   		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
>>   		  FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC |
>> -		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII,
>> +		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII |
>> +		  FEC_QUIRK_HAS_MDIO_C45,
>>   };
>>   
>>   static const struct fec_devinfo fec_imx8mq_info = {
>> @@ -150,7 +154,8 @@ static const struct fec_devinfo fec_imx8mq_info = {
>>   		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
>>   		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
>>   		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
>> -		  FEC_QUIRK_HAS_EEE | FEC_QUIRK_WAKEUP_FROM_INT2,
>> +		  FEC_QUIRK_HAS_EEE | FEC_QUIRK_WAKEUP_FROM_INT2 |
>> +		  FEC_QUIRK_HAS_MDIO_C45,
>>   };
>>   
>>   static const struct fec_devinfo fec_imx8qm_info = {
>> @@ -160,14 +165,15 @@ static const struct fec_devinfo fec_imx8qm_info = {
>>   		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
>>   		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
>>   		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
>> -		  FEC_QUIRK_DELAYED_CLKS_SUPPORT,
>> +		  FEC_QUIRK_DELAYED_CLKS_SUPPORT | FEC_QUIRK_HAS_MDIO_C45,
>>   };
>>   
>>   static const struct fec_devinfo fec_s32v234_info = {
>>   	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
>>   		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
>>   		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
>> -		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE,
>> +		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
>> +		  FEC_QUIRK_HAS_MDIO_C45,
>>   };
>>   
>>   static struct platform_device_id fec_devtype[] = {
>> @@ -2434,8 +2440,10 @@ static int fec_enet_mii_init(struct platform_device *pdev)
>>   	fep->mii_bus->name = "fec_enet_mii_bus";
>>   	fep->mii_bus->read = fec_enet_mdio_read_c22;
>>   	fep->mii_bus->write = fec_enet_mdio_write_c22;
>> -	fep->mii_bus->read_c45 = fec_enet_mdio_read_c45;
>> -	fep->mii_bus->write_c45 = fec_enet_mdio_write_c45;
>> +	if (fep->quirks & FEC_QUIRK_HAS_MDIO_C45) {
>> +		fep->mii_bus->read_c45 = fec_enet_mdio_read_c45;
>> +		fep->mii_bus->write_c45 = fec_enet_mdio_write_c45;
>> +	}
>>   	snprintf(fep->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
>>   		pdev->name, fep->dev_id + 1);
>>   	fep->mii_bus->priv = fep;
>> -- 
>> 2.25.1
>>
> 
> This patch looks reasonable. Please formally submit it.

Ok, will do, thanks.

Regards
Greg


