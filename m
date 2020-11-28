Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCF22C744A
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbgK1Vtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730273AbgK1SDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 13:03:18 -0500
X-Greylist: delayed 168 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 28 Nov 2020 09:26:26 PST
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8D5C025455;
        Sat, 28 Nov 2020 09:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1606584383;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=5iPrgIy7xTZ+IpTz98wlm8W+JTsMsmFczF194/0sF/s=;
        b=cz0e0RC+dXR/M8FVs3Tr6AqKV5Wb8MXQvl+VKZ6N+GTF+6yNas5SJr/TEK60RGxu+6
        J4sGsFLwtUiGeRq8UOiugbTi+9bR768s2AQfeMXvt+Bk5xaX+z8HL6NpF/yZmG7iB4No
        6q1IkIVgQJuh7DlS0dx2+J4DsPQ2yDQJZ4PiJVB09uWUqnj8hnJrVp+7JeHm1+D0M5IK
        1w4AEbab/Huj02Mli4K1kcJaRKi/IQJfkl6lR6msAIkDEjUXYWWi0RnM14PichHvufqc
        cglRSxVnWSkqQvIAm/S1Fnrx9WEOAukwp75kCCWE5jePA7ojlEG83HZvIhoufudTLxSG
        SkGw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTEVR+J8xuzl0="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.177]
        by smtp.strato.de (RZmta 47.3.4 DYNA|AUTH)
        with ESMTPSA id n07f3bwASHNKzj1
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sat, 28 Nov 2020 18:23:20 +0100 (CET)
Subject: Re: [PATCH] can: don't count arbitration lose as an error
To:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "moderated list:ARM/Allwinner sunXi SoC support" 
        <linux-arm-kernel@lists.infradead.org>
References: <20201127095941.21609-1-jhofstee@victronenergy.com>
 <434167b4-c2df-02bf-8a9c-2d4716c5435f@pengutronix.de>
 <f5f93e72-c55f-cfd3-a686-3454e42c4371@victronenergy.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <042ad21c-e238-511b-1282-2ea226e572ff@hartkopp.net>
Date:   Sat, 28 Nov 2020 18:23:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <f5f93e72-c55f-cfd3-a686-3454e42c4371@victronenergy.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27.11.20 12:09, Jeroen Hofstee wrote:
> Hi,
> 
> On 11/27/20 11:30 AM, Marc Kleine-Budde wrote:
>> On 11/27/20 10:59 AM, Jeroen Hofstee wrote:
>>> Losing arbitration is normal in a CAN-bus network, it means that a
>>> higher priority frame is being send and the pending message will be
>>> retried later. Hence most driver only increment arbitration_lost, but
>>> the sja1000 and sun4i driver also incremeant tx_error, causing errors
>>> to be reported on a normal functioning CAN-bus. So stop counting them
>>> as errors.
>> Sounds plausible.
>>
>>> For completeness, the Kvaser USB hybra also increments the tx_error
>>> on arbitration lose, but it does so in single shot. Since in that
>>> case the message is not retried, that behaviour is kept.
>> You mean only in one shot mode?
> 
> Yes, well at least the function is called kvaser_usb_hydra_one_shot_fail.
> 
> 
>>   What about one shot mode on the sja1000 cores?
> 
> 
> That is a good question. I guess it will be counted as error by:
> 
>          if (isrc & IRQ_TI) {
>              /* transmission buffer released */
>              if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
>                  !(status & SR_TCS)) {
>                  stats->tx_errors++;
>                  can_free_echo_skb(dev, 0);
>              } else {
>                  /* transmission complete */
>                  stats->tx_bytes +=
>                      priv->read_reg(priv, SJA1000_FI) & 0xf;
>                  stats->tx_packets++;
>                  can_get_echo_skb(dev, 0);
>              }
>              netif_wake_queue(dev);
>              can_led_event(dev, CAN_LED_EVENT_TX);
>          }
> 
>  From the datasheet, Transmit Interrupt:
> 
> "set; this bit is set whenever the transmit bufferstatus
> changes from ‘0-to-1’ (released) and the TIE bit is set
> within the interrupt enable register".
> 
> I cannot test it though, since I don't have a sja1000.

I have a PCAN-ExpressCard 34 here, which should make it in a test setup 
as it acts as a PCI attached SJA1000.

Will take a look at that arbitration lost behaviour on Monday. A really 
interesting detail!

Best,
Oliver

> 
>>
>>> Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
>> I've split this into two patches, and added Fixes: lines, and pushed 
>> this for
>> now to linux-can/sja1000.
>>
> Thanks, regards,
> 
> Jeroen
> 
> 
