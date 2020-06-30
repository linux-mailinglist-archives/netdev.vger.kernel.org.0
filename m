Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A180120EDDE
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 07:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbgF3FxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 01:53:23 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:59993 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgF3FxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 01:53:22 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id AEC6B22FE6;
        Tue, 30 Jun 2020 07:53:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1593496398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/3J76hcrK17yWWFvLZkIrwqhQZNNKtFrVOkMWj39KVI=;
        b=OtK4/+gt1DlGplbsXwddr/jBIl3fKa5KlAqFYne1EA5vNAP8HFsVtpgXqWAqzL6ZswheOy
        d3DPgULwFJKjvEbmYHhS3R3jAVz+aE/YvIi1lVVqoXs/oT4tF5qaXPU83PdEAM2nTlb7Ml
        DgRlMo9LaRH0ZI9H1rPmNDn532/PKfY=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 30 Jun 2020 07:53:17 +0200
From:   Michael Walle <michael@walle.cc>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH 2/2] can: flexcan: add support for ISO CAN-FD
In-Reply-To: <DB8PR04MB679504980A67DB8B1EEC8386E66F0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200629181809.25338-1-michael@walle.cc>
 <20200629181809.25338-3-michael@walle.cc>
 <DB8PR04MB679504980A67DB8B1EEC8386E66F0@DB8PR04MB6795.eurprd04.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.6
Message-ID: <a42e035c8ee3334a721a089b5f8f0580@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+ Oliver]

Hi Joakim,

Am 2020-06-30 04:42, schrieb Joakim Zhang:
>> -----Original Message-----
>> From: Michael Walle <michael@walle.cc>
>> Sent: 2020年6月30日 2:18
>> To: linux-can@vger.kernel.org; netdev@vger.kernel.org;
>> linux-kernel@vger.kernel.org
>> Cc: Wolfgang Grandegger <wg@grandegger.com>; Marc Kleine-Budde
>> <mkl@pengutronix.de>; David S . Miller <davem@davemloft.net>; Jakub
>> Kicinski <kuba@kernel.org>; Joakim Zhang <qiangqing.zhang@nxp.com>;
>> dl-linux-imx <linux-imx@nxp.com>; Michael Walle <michael@walle.cc>
>> Subject: [PATCH 2/2] can: flexcan: add support for ISO CAN-FD
>> 
>> Up until now, the controller used non-ISO CAN-FD mode, although it 
>> supports it.
>> Add support for ISO mode, too. By default the hardware is in non-ISO 
>> mode and
>> an enable bit has to be explicitly set.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  drivers/net/can/flexcan.c | 19 ++++++++++++++++---
>>  1 file changed, 16 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c 
>> index
>> 183e094f8d66..a92d3cdf4195 100644
>> --- a/drivers/net/can/flexcan.c
>> +++ b/drivers/net/can/flexcan.c
>> @@ -94,6 +94,7 @@
>>  #define FLEXCAN_CTRL2_MRP		BIT(18)
>>  #define FLEXCAN_CTRL2_RRS		BIT(17)
>>  #define FLEXCAN_CTRL2_EACEN		BIT(16)
>> +#define FLEXCAN_CTRL2_ISOCANFDEN	BIT(12)
>> 
>>  /* FLEXCAN memory error control register (MECR) bits */
>>  #define FLEXCAN_MECR_ECRWRDIS		BIT(31)
>> @@ -1344,14 +1345,25 @@ static int flexcan_chip_start(struct 
>> net_device
>> *dev)
>>  	else
>>  		reg_mcr |= FLEXCAN_MCR_SRX_DIS;
>> 
>> -	/* MCR - CAN-FD */
>> -	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
>> +	/* MCR, CTRL2
>> +	 *
>> +	 * CAN-FD mode
>> +	 * ISO CAN-FD mode
>> +	 */
>> +	reg_ctrl2 = priv->read(&regs->ctrl2);
>> +	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
>>  		reg_mcr |= FLEXCAN_MCR_FDEN;
>> -	else
>> +		reg_ctrl2 |= FLEXCAN_CTRL2_ISOCANFDEN;
>> +	} else {
>>  		reg_mcr &= ~FLEXCAN_MCR_FDEN;
>> +	}
>> +
>> +	if (priv->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO)
>> +		reg_ctrl2 &= ~FLEXCAN_CTRL2_ISOCANFDEN;
> 
> 

[..]
> ip link set can0 up type can bitrate 1000000 dbitrate 5000000 fd on
> ip link set can0 up type can bitrate 1000000 dbitrate 5000000 fd on \
>    fd-non-iso on

vs.

> ip link set can0 up type can bitrate 1000000 dbitrate 5000000 
> fd-non-iso on

I haven't found anything if CAN_CTRLMODE_FD_NON_ISO depends on
CAN_CTRLMODE_FD. I.e. wether CAN_CTRLMODE_FD_NON_ISO can only be set if
CAN_CTRLMODE_FD is also set.

Only the following piece of code, which might be a hint that you
have to set CAN_CTRLMODE_FD if you wan't to use CAN_CTRLMODE_FD_NON_ISO:

drivers/net/can/dev.c:
   /* do not check for static fd-non-iso if 'fd' is disabled */
   if (!(maskedflags & CAN_CTRLMODE_FD))
           ctrlstatic &= ~CAN_CTRLMODE_FD_NON_ISO;

If CAN_CTRLMODE_FD_NON_ISO can be set without CAN_CTRLMODE_FD, what
should be the mode if both are set at the same time?

Marc? Oliver?

-michael
