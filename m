Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE9730A444
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 10:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbhBAJU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 04:20:28 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:60653 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbhBAJUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 04:20:19 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1l6VLl-0004xN-M0; Mon, 01 Feb 2021 10:18:25 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1l6VLk-0002MG-Ia; Mon, 01 Feb 2021 10:18:24 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 2426C240041;
        Mon,  1 Feb 2021 10:18:24 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 97CDE240040;
        Mon,  1 Feb 2021 10:18:23 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 264DB200AA;
        Mon,  1 Feb 2021 10:18:23 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 01 Feb 2021 10:18:23 +0100
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
In-Reply-To: <CAJht_EMQVaKFx7Wjj75F2xVBTCdpmho64wP0bfX6RhFnzNXAZA@mail.gmail.com>
References: <20210127090747.364951-1-xie.he.0141@gmail.com>
 <20210128114659.2d81a85f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOSB-m--Ombr6wLMFq4mPy8UTpsBri2CPsaRTU-aks7Uw@mail.gmail.com>
 <3f67b285671aaa4b7903733455a730e1@dev.tdt.de>
 <20210129173650.7c0b7cda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EPMtn5E-Y312vPQfH2AwDAi+j1OP4zzpg+AUKf46XE1Yw@mail.gmail.com>
 <20210130111618.335b6945@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EMQVaKFx7Wjj75F2xVBTCdpmho64wP0bfX6RhFnzNXAZA@mail.gmail.com>
Message-ID: <36a6c0769c57cd6835d32cc0fb95bca6@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1612171105-0000A9C4-B60B7990/0/0
X-purgate-type: clean
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-31 04:16, Xie He wrote:
> On Sat, Jan 30, 2021 at 11:16 AM Jakub Kicinski <kuba@kernel.org> 
> wrote:
>> 
>> Sounds like too much afford for a sub-optimal workaround.
>> The qdisc semantics are borken in the proposed scheme (double
>> counting packets) - both in term of statistics and if user decides
>> to add a policer, filter etc.
> 
> Hmm...
> 
> Another solution might be creating another virtual device on top of
> the HDLC device (similar to what "hdlc_fr.c" does), so that we can
> first queue L3 packets in the virtual device's qdisc queue, and then
> queue the L2 frames in the actual HDLC device's qdisc queue. This way
> we can avoid the same outgoing data being queued to qdisc twice. But
> this would significantly change the way the user uses the hdlc_x25
> driver.
> 
>> Another worry is that something may just inject a packet with
>> skb->protocol == ETH_P_HDLC but unexpected structure (IDK if
>> that's a real concern).
> 
> This might not be a problem. Ethernet devices also allow the user to
> inject raw frames with user constructed headers. "hdlc_fr.c" also
> allows the user to bypass the virtual circuit interfaces and inject
> raw frames directly on the HDLC interface. I think the receiving side
> should be able to recognize and drop invalid frames.
> 
>> It may be better to teach LAPB to stop / start the internal queue.
>> The lower level drivers just needs to call LAPB instead of making
>> the start/wake calls directly to the stack, and LAPB can call the
>> stack. Would that not work?
> 
> I think this is a good solution. But this requires changing a lot of
> code. The HDLC subsystem needs to be changed to allow HDLC Hardware
> Drivers to ask HDLC Protocol Drivers (like hdlc_x25.c) to stop/wake
> the TX queue. The hdlc_x25.c driver can then ask the LAPB module to
> stop/wake the queue.
> 
> So this means new APIs need to be added to both the HDLC subsystem and
> the LAPB module, and a number of HDLC Hardware Drivers need to be
> changed to call the new API of the HDLC subsystem.
> 
> Martin, do you have any suggestions?

I have thought about this issue again.

I also have to say that I have never noticed any problems in this area
before.

So again for (my) understanding:
When a hardware driver calls netif_stop_queue, the frames sent from
layer 3 (X.25) with dev_queue_xmit are queued and not passed "directly"
to x25_xmit of the hdlc_x25 driver.

So nothing is added to the write_queue anymore (except possibly
un-acked-frames by lapb_requeue_frames).

Shouldn't it actually be sufficient to check for netif_queue_stopped in
lapb_kick and then do "nothing" if necessary?

As soon as the hardware driver calls netif_wake_queue, the whole thing
should just continue running.

Or am I missing something?
