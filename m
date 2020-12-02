Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD912CBFE2
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 15:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387399AbgLBOiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 09:38:23 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:12148 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbgLBOiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 09:38:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1606919731;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=AVuvWDbV/9+ouZdVUaYVWFIK1W5CysnFx9kN3a4DlG4=;
        b=WVMfpVMDnHz3in9gx0erNCg9nGzRmfq3jbIKhthbVaDTwXmz353UGVD2vCXStPZTuG
        VUrgWgOjnuIrkFDA2+PzPRefNiCkhXUb+JX0n8QimDnrOu9Tjx99L1OUgazZZ3I/ikCc
        rJ5gkIHnJj2yKE1LKvywgUqMXWpmhJ33umAWiObyc8TuMpTGIZDQcGLzzAQM8pD+saxV
        PyG50Zu6o1bGI6HGKanLLiXaBOI5ZmcjLDhR3EZuBgiojlKOaNxGxEOcVEuvCleEcjKg
        Iw5eZoS5sUf1wr2Mafan/KiteAC5Yl383fFUOfRR2LG5Y6nNRT2DyRt7CBc9clJDYh5u
        BC8g==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTGV1iO89vpw=="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.177]
        by smtp.strato.de (RZmta 47.3.4 DYNA|AUTH)
        with ESMTPSA id n07f3bwB2EZMC8u
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 2 Dec 2020 15:35:22 +0100 (CET)
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
Message-ID: <0988dd09-70d9-3ee8-9945-10c4dea49407@hartkopp.net>
Date:   Wed, 2 Dec 2020 15:35:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <f5f93e72-c55f-cfd3-a686-3454e42c4371@victronenergy.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeroen,

On 27.11.20 12:09, Jeroen Hofstee wrote:
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

I can confirm with CAN_CTRLMODE_ONE_SHOT active and the patch ("can: 
sja1000: sja1000_err(): don't count arbitration lose as an error")

https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git/commit/?h=testing&id=bd0ccb92efb09c7da5b55162b283b42a93539ed7

I now get ONE(!) increment for tx_errors and ONE increment in the 
arbitration-lost counter.

Before the above patch I had TWO tx_errors for each arbitration lost case.

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

Do we agree that in one-shot mode both the tx_errors and the 
arbitration_lost counters are increased in the arbitration-lost case?

At least this would fit to the Kvaser USB behaviour.

And btw. I wondered if we should remove the check for 
CAN_CTRLMODE_ONE_SHOT here, as we ALWAYS should count a tx_error and 
drop the echo_skb when we have a TX-interrupt and TX-complete flag is zero.

So replace:

if (priv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT &&
                   !(status & SR_TCS)) {

with:

if (!(status & SR_TCS)) {

Any suggestions?

Best regards,
Oliver
