Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4C020F94F
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 18:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387425AbgF3QVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 12:21:15 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:20704 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgF3QVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 12:21:15 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jun 2020 12:21:13 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1593534072;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=UQbMuL5GteFYcEkQVqGEO+2ozDFITfnMDX6You1TvZU=;
        b=jk5DchApm8GpDQjKpzBfcfoN1S9ys3DkJE8UgDhBZdE6Qn78RmZxNQNd43APAVTNuE
        HjcjbCQskPG1lKUQxeZBIDzu4SZUntJRm2oL4UScwRJpem2Oq6mxatb9I21/viCqLi03
        XrY3/GSi/0Glh11CeATcP9CRNFj4b2DY9AkAOBHYPEbXa2BmnDluWRxu4Ioial7vPQDr
        6a7caZBG8SUi8WMB3zbJmi86NOpR6e7or1Y5ZpMwgUh5hmizrNLSs7tcYhs8UyVLtPT4
        Nn4HZ2j9+//NpYViUpoZLguzu6E4/QQ7GJoPV1Ly/sp+PnzE8i0dp/RIeLonf4C+kUG+
        EvhA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJV8h7kyA="
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id R09ac6w5UGF6I1A
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 30 Jun 2020 18:15:06 +0200 (CEST)
Subject: Re: [PATCH 2/2] can: flexcan: add support for ISO CAN-FD
To:     Michael Walle <michael@walle.cc>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20200629181809.25338-1-michael@walle.cc>
 <20200629181809.25338-3-michael@walle.cc>
 <DB8PR04MB679504980A67DB8B1EEC8386E66F0@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <a42e035c8ee3334a721a089b5f8f0580@walle.cc>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <5f6e0843-8504-e941-b6a3-1dc8599db39e@hartkopp.net>
Date:   Tue, 30 Jun 2020 18:15:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <a42e035c8ee3334a721a089b5f8f0580@walle.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30.06.20 07:53, Michael Walle wrote:
> [+ Oliver]
> 
> Hi Joakim,
> 
> Am 2020-06-30 04:42, schrieb Joakim Zhang:
>>> -----Original Message-----
>>> From: Michael Walle <michael@walle.cc>
>>> Sent: 2020年6月30日 2:18
>>> To: linux-can@vger.kernel.org; netdev@vger.kernel.org;
>>> linux-kernel@vger.kernel.org
>>> Cc: Wolfgang Grandegger <wg@grandegger.com>; Marc Kleine-Budde
>>> <mkl@pengutronix.de>; David S . Miller <davem@davemloft.net>; Jakub
>>> Kicinski <kuba@kernel.org>; Joakim Zhang <qiangqing.zhang@nxp.com>;
>>> dl-linux-imx <linux-imx@nxp.com>; Michael Walle <michael@walle.cc>
>>> Subject: [PATCH 2/2] can: flexcan: add support for ISO CAN-FD
>>>
>>> Up until now, the controller used non-ISO CAN-FD mode, although it 
>>> supports it.
>>> Add support for ISO mode, too. By default the hardware is in non-ISO 
>>> mode and
>>> an enable bit has to be explicitly set.
>>>
>>> Signed-off-by: Michael Walle <michael@walle.cc>
>>> ---
>>>  drivers/net/can/flexcan.c | 19 ++++++++++++++++---
>>>  1 file changed, 16 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c index
>>> 183e094f8d66..a92d3cdf4195 100644
>>> --- a/drivers/net/can/flexcan.c
>>> +++ b/drivers/net/can/flexcan.c
>>> @@ -94,6 +94,7 @@
>>>  #define FLEXCAN_CTRL2_MRP        BIT(18)
>>>  #define FLEXCAN_CTRL2_RRS        BIT(17)
>>>  #define FLEXCAN_CTRL2_EACEN        BIT(16)
>>> +#define FLEXCAN_CTRL2_ISOCANFDEN    BIT(12)
>>>
>>>  /* FLEXCAN memory error control register (MECR) bits */
>>>  #define FLEXCAN_MECR_ECRWRDIS        BIT(31)
>>> @@ -1344,14 +1345,25 @@ static int flexcan_chip_start(struct net_device
>>> *dev)
>>>      else
>>>          reg_mcr |= FLEXCAN_MCR_SRX_DIS;
>>>
>>> -    /* MCR - CAN-FD */
>>> -    if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
>>> +    /* MCR, CTRL2
>>> +     *
>>> +     * CAN-FD mode
>>> +     * ISO CAN-FD mode
>>> +     */
>>> +    reg_ctrl2 = priv->read(&regs->ctrl2);
>>> +    if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
>>>          reg_mcr |= FLEXCAN_MCR_FDEN;
>>> -    else
>>> +        reg_ctrl2 |= FLEXCAN_CTRL2_ISOCANFDEN;
>>> +    } else {
>>>          reg_mcr &= ~FLEXCAN_MCR_FDEN;
>>> +    }
>>> +
>>> +    if (priv->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO)
>>> +        reg_ctrl2 &= ~FLEXCAN_CTRL2_ISOCANFDEN;
>>
>>
> 
> [..]
>> ip link set can0 up type can bitrate 1000000 dbitrate 5000000 fd on
>> ip link set can0 up type can bitrate 1000000 dbitrate 5000000 fd on \
>>    fd-non-iso on
> 
> vs.
> 
>> ip link set can0 up type can bitrate 1000000 dbitrate 5000000 
>> fd-non-iso on
> 
> I haven't found anything if CAN_CTRLMODE_FD_NON_ISO depends on
> CAN_CTRLMODE_FD. I.e. wether CAN_CTRLMODE_FD_NON_ISO can only be set if
> CAN_CTRLMODE_FD is also set.
> 
> Only the following piece of code, which might be a hint that you
> have to set CAN_CTRLMODE_FD if you wan't to use CAN_CTRLMODE_FD_NON_ISO:
> 
> drivers/net/can/dev.c:
>    /* do not check for static fd-non-iso if 'fd' is disabled */
>    if (!(maskedflags & CAN_CTRLMODE_FD))
>            ctrlstatic &= ~CAN_CTRLMODE_FD_NON_ISO;
> 
> If CAN_CTRLMODE_FD_NON_ISO can be set without CAN_CTRLMODE_FD, what
> should be the mode if both are set at the same time?

CAN_CTRLMODE_FD_NON_ISO is only relevant when CAN_CTRLMODE_FD is set.

So in the example from above

ip link set can0 up type can bitrate 1000000 dbitrate 5000000 fd-non-iso on

either the setting of 'dbitrate 5000000' and 'fd-non-iso on' is pointless.

When switching to FD-mode with 'fd on' the FD relevant settings need to 
be applied.

FD ISO is the default.

Did this help or did I get anything wrong?

Best,
Oliver
