Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738D220FA0B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 19:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389944AbgF3RAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 13:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbgF3RAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 13:00:31 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E81C061755;
        Tue, 30 Jun 2020 10:00:31 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id AC28422F53;
        Tue, 30 Jun 2020 19:00:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1593536427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UDbH7pLz+12WxuhpnPo2DJiE1S7gV9ax36puEK6+/QY=;
        b=oc98M6IfaUjWWnZvhfzupxBBG5qhZ9Uk28Ad8ZN4cLXuQ+UU3G4zUr1YS0/Y9L9rJwGDlN
        Mfa5ibwsl2C4NvLtQc8g3+FBXRJRBGVZzCxlRaUevToaAUiU2k/jGWkOhO7jP61kjTRqxL
        sDWxJ1RonQP9IApCA+hxEbLXmn3B3pQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 30 Jun 2020 19:00:26 +0200
From:   Michael Walle <michael@walle.cc>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 2/2] can: flexcan: add support for ISO CAN-FD
In-Reply-To: <5f6e0843-8504-e941-b6a3-1dc8599db39e@hartkopp.net>
References: <20200629181809.25338-1-michael@walle.cc>
 <20200629181809.25338-3-michael@walle.cc>
 <DB8PR04MB679504980A67DB8B1EEC8386E66F0@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <a42e035c8ee3334a721a089b5f8f0580@walle.cc>
 <5f6e0843-8504-e941-b6a3-1dc8599db39e@hartkopp.net>
User-Agent: Roundcube Webmail/1.4.6
Message-ID: <e5b56262c291422160e822e4a378dd2c@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-06-30 18:15, schrieb Oliver Hartkopp:
> On 30.06.20 07:53, Michael Walle wrote:
>> [+ Oliver]
>> 
>> Hi Joakim,
>> 
>> Am 2020-06-30 04:42, schrieb Joakim Zhang:
>>>> -----Original Message-----
>>>> From: Michael Walle <michael@walle.cc>
>>>> Sent: 2020年6月30日 2:18
>>>> To: linux-can@vger.kernel.org; netdev@vger.kernel.org;
>>>> linux-kernel@vger.kernel.org
>>>> Cc: Wolfgang Grandegger <wg@grandegger.com>; Marc Kleine-Budde
>>>> <mkl@pengutronix.de>; David S . Miller <davem@davemloft.net>; Jakub
>>>> Kicinski <kuba@kernel.org>; Joakim Zhang <qiangqing.zhang@nxp.com>;
>>>> dl-linux-imx <linux-imx@nxp.com>; Michael Walle <michael@walle.cc>
>>>> Subject: [PATCH 2/2] can: flexcan: add support for ISO CAN-FD
>>>> 
>>>> Up until now, the controller used non-ISO CAN-FD mode, although it 
>>>> supports it.
>>>> Add support for ISO mode, too. By default the hardware is in non-ISO 
>>>> mode and
>>>> an enable bit has to be explicitly set.
>>>> 
>>>> Signed-off-by: Michael Walle <michael@walle.cc>
>>>> ---
>>>>  drivers/net/can/flexcan.c | 19 ++++++++++++++++---
>>>>  1 file changed, 16 insertions(+), 3 deletions(-)
>>>> 
>>>> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c 
>>>> index
>>>> 183e094f8d66..a92d3cdf4195 100644
>>>> --- a/drivers/net/can/flexcan.c
>>>> +++ b/drivers/net/can/flexcan.c
>>>> @@ -94,6 +94,7 @@
>>>>  #define FLEXCAN_CTRL2_MRP        BIT(18)
>>>>  #define FLEXCAN_CTRL2_RRS        BIT(17)
>>>>  #define FLEXCAN_CTRL2_EACEN        BIT(16)
>>>> +#define FLEXCAN_CTRL2_ISOCANFDEN    BIT(12)
>>>> 
>>>>  /* FLEXCAN memory error control register (MECR) bits */
>>>>  #define FLEXCAN_MECR_ECRWRDIS        BIT(31)
>>>> @@ -1344,14 +1345,25 @@ static int flexcan_chip_start(struct 
>>>> net_device
>>>> *dev)
>>>>      else
>>>>          reg_mcr |= FLEXCAN_MCR_SRX_DIS;
>>>> 
>>>> -    /* MCR - CAN-FD */
>>>> -    if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
>>>> +    /* MCR, CTRL2
>>>> +     *
>>>> +     * CAN-FD mode
>>>> +     * ISO CAN-FD mode
>>>> +     */
>>>> +    reg_ctrl2 = priv->read(&regs->ctrl2);
>>>> +    if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
>>>>          reg_mcr |= FLEXCAN_MCR_FDEN;
>>>> -    else
>>>> +        reg_ctrl2 |= FLEXCAN_CTRL2_ISOCANFDEN;
>>>> +    } else {
>>>>          reg_mcr &= ~FLEXCAN_MCR_FDEN;
>>>> +    }
>>>> +
>>>> +    if (priv->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO)
>>>> +        reg_ctrl2 &= ~FLEXCAN_CTRL2_ISOCANFDEN;

[1]

>> [..]
>>> ip link set can0 up type can bitrate 1000000 dbitrate 5000000 fd on
>>> ip link set can0 up type can bitrate 1000000 dbitrate 5000000 fd on \
>>>    fd-non-iso on
>> 
>> vs.
>> 
>>> ip link set can0 up type can bitrate 1000000 dbitrate 5000000 
>>> fd-non-iso on
>> 
>> I haven't found anything if CAN_CTRLMODE_FD_NON_ISO depends on
>> CAN_CTRLMODE_FD. I.e. wether CAN_CTRLMODE_FD_NON_ISO can only be set 
>> if
>> CAN_CTRLMODE_FD is also set.
>> 
>> Only the following piece of code, which might be a hint that you
>> have to set CAN_CTRLMODE_FD if you wan't to use 
>> CAN_CTRLMODE_FD_NON_ISO:
>> 
>> drivers/net/can/dev.c:
>>    /* do not check for static fd-non-iso if 'fd' is disabled */
>>    if (!(maskedflags & CAN_CTRLMODE_FD))
>>            ctrlstatic &= ~CAN_CTRLMODE_FD_NON_ISO;
>> 
>> If CAN_CTRLMODE_FD_NON_ISO can be set without CAN_CTRLMODE_FD, what
>> should be the mode if both are set at the same time?
> 
> CAN_CTRLMODE_FD_NON_ISO is only relevant when CAN_CTRLMODE_FD is set.
> 
> So in the example from above
> 
> ip link set can0 up type can bitrate 1000000 dbitrate 5000000 
> fd-non-iso on
> 
> either the setting of 'dbitrate 5000000' and 'fd-non-iso on' is 
> pointless.
> 
> When switching to FD-mode with 'fd on' the FD relevant settings need
> to be applied.
> 
> FD ISO is the default.
> 
> Did this help or did I get anything wrong?

Thanks for the explanation. Yes this helped a great deal and this
patch should be correct; it sets ISO mode if CAN_CTRLMODE_FD is set
and masks it again if CAN_CTRLMODE_FD_NON_ISO is set. See [1].

-michael
