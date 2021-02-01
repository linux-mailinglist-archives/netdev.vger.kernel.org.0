Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4053830A86C
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 14:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhBANQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 08:16:43 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:56701 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhBANQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 08:16:36 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1l6Z2S-0000U7-4Z; Mon, 01 Feb 2021 14:14:44 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1l6Z2R-00031v-0B; Mon, 01 Feb 2021 14:14:43 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 49359240041;
        Mon,  1 Feb 2021 14:14:42 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id BA7C2240040;
        Mon,  1 Feb 2021 14:14:41 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 38CF32007C;
        Mon,  1 Feb 2021 14:14:41 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 01 Feb 2021 14:14:41 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net] net: hdlc_x25: Use qdisc to queue outgoing LAPB
 frames
Organization: TDT AG
In-Reply-To: <CAJht_ENs1Rnf=2iX8M1ufF=StWHKTei3zuKv-xBtkhDsY-xBOA@mail.gmail.com>
References: <20210127090747.364951-1-xie.he.0141@gmail.com>
 <20210128114659.2d81a85f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOSB-m--Ombr6wLMFq4mPy8UTpsBri2CPsaRTU-aks7Uw@mail.gmail.com>
 <3f67b285671aaa4b7903733455a730e1@dev.tdt.de>
 <20210129173650.7c0b7cda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EPMtn5E-Y312vPQfH2AwDAi+j1OP4zzpg+AUKf46XE1Yw@mail.gmail.com>
 <20210130111618.335b6945@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EMQVaKFx7Wjj75F2xVBTCdpmho64wP0bfX6RhFnzNXAZA@mail.gmail.com>
 <36a6c0769c57cd6835d32cc0fb95bca6@dev.tdt.de>
 <CAJht_ENs1Rnf=2iX8M1ufF=StWHKTei3zuKv-xBtkhDsY-xBOA@mail.gmail.com>
Message-ID: <1628f9442ccf18f9c08c98f122053fc0@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1612185283-0000A9C4-9D737842/0/0
X-purgate-type: clean
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-01 12:38, Xie He wrote:
> On Mon, Feb 1, 2021 at 1:18 AM Martin Schiller <ms@dev.tdt.de> wrote:
>> 
>> I have thought about this issue again.
>> 
>> I also have to say that I have never noticed any problems in this area
>> before.
>> 
>> So again for (my) understanding:
>> When a hardware driver calls netif_stop_queue, the frames sent from
>> layer 3 (X.25) with dev_queue_xmit are queued and not passed 
>> "directly"
>> to x25_xmit of the hdlc_x25 driver.
>> 
>> So nothing is added to the write_queue anymore (except possibly
>> un-acked-frames by lapb_requeue_frames).
> 
> If the LAPB module only emits an L2 frame when an L3 packet comes from
> the upper layer, then yes, there would be no problem because the L3
> packet is already controlled by the qdisc and there is no need to
> control the corresponding L2 frame again.
> 
> However, the LAPB module can emits L2 frames when there's no L3 packet
> coming, when 1) there are some packets queued in the LAPB module's
> internal queue; and 2) the LAPB decides to send some control frame
> (e.g. by the timers).

But control frames are currently sent past the lapb write_queue.
So another queue would have to be created.

And wouldn't it be better to have it in the hdlc_x25 driver, leaving
LAPB unaffected?

> 
>> Shouldn't it actually be sufficient to check for netif_queue_stopped 
>> in
>> lapb_kick and then do "nothing" if necessary?
> 
> We can consider this situation: When the upper layer has nothing to
> send, but there are some packets in the LAPB module's internal queue
> waiting to be sent. The LAPB module will try to send the packets, but
> after it has sent out the first packet, it will meet the "queue
> stopped" situation. In this situation, it'd be preferable to
> immediately start sending the second packet after the queue is started
> again. "Doing nothing" in this situation would mean waiting until some
> other events occur, such as receiving responses from the other side,
> or receiving more outgoing packets from L3.
> 
>> As soon as the hardware driver calls netif_wake_queue, the whole thing
>> should just continue running.
> 
> This relies on the fact that the upper layer has something to send. If
> the upper layer has nothing to send, lapb_kick would not be
> automatically called again until some other events occur (such as
> receiving responses from the other side). I think it'd be better if we
> do not rely on the assumption that L3 is going to send more packets to
> us, as L3 itself would assume us to provide it a reliable link service
> and we should fulfill its expectation.
