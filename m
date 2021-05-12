Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4035A37C044
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhELOhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhELOg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 10:36:59 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A545C061574;
        Wed, 12 May 2021 07:35:51 -0700 (PDT)
Received: from localhost ([127.0.0.1] helo=bute.mt.lv)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lgpxO-0006fy-AC; Wed, 12 May 2021 17:35:26 +0300
MIME-Version: 1.0
Date:   Wed, 12 May 2021 17:35:26 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     Chris Snook <chris.snook@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        jesse.brandeburg@intel.com, dchickles@marvell.com,
        tully@mikrotik.com, Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/4] atl1c: improve performance by avoiding
 unnecessary pcie writes on xmit
In-Reply-To: <CAMXMK6tkPYLLQzq65uFVd-aCWaVHSne16MBEo7o6fGDTDA0rpw@mail.gmail.com>
References: <20210511190518.8901-1-gatis@mikrotik.com>
 <20210511190518.8901-3-gatis@mikrotik.com>
 <CAMXMK6tkPYLLQzq65uFVd-aCWaVHSne16MBEo7o6fGDTDA0rpw@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <c7ae91ea1d8aec340202c67cd4c85d30@mikrotik.com>
X-Sender: gatis@mikrotik.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-05-12 05:39, Chris Snook wrote:
> Increases in latency tend to hurt more on single-queue devices. Has
> this been tested on the original gigabit atl1c?

Thank you Chris, for checking this out!

I did test the atl1c driver with and without this change on actual
AR8151 hardware.

My test system was Intel(R) Core(TM) i7-4790K + RB44Ge.
That is a 4 port 1G AR8151 based card.

I measured latency with external traffic generator with test system
doing L2 forwarding. Receiving traffic on one atl1c interface and
transmitting over another atl1c interface. I had default 1000 packet
pfifo queue configured on the atl1c interfaces.

Max 64 byte packet L2 forward pps rate improved 860K -> 1070K.

Any latency difference at 800Kpps was lost in the noise - with the
particular traffic generator system (a linux based RouterOS 
traffic-gen).
I measured average 285us for a 30 second run in both cases. Note that
this includes any traffic generator "internal" latency.

Note that I had to tweak atl1c tx interrupt moderation to get these
numbers. With default tx_imt = 1000 no matter what I get only 500
tx interrupts/sec. Since the tx clean is fast and do not get polled
repeatedly and ring size is 1024 I am limited to ~500Kpps.
tx_imt = 500 dobubles that, I used tx_imt = 200 for this test.

As a side note that still relates to latency discussion on AR8151
hardware what I did find out however is that rx interrupt moderation
timer value has a big effect on latency. Changing rx_imt
from 200 to 10 resulted in considerable improvement from 285us to 41us
average latency as measured by traffic generator. I do not have
enough knowledge of the quirks of all the hardware supported by
the driver to confidently put this in a patch though.

Mikrotik 10/25G NIC has its own interrupt moderation mechanism,
so this is not relevant to that if anyone is interested.


> 
> - Chris
> 
> On Tue, May 11, 2021 at 12:05 PM Gatis Peisenieks <gatis@mikrotik.com> 
> wrote:
>> 
>> The kernel has xmit_more facility that hints the networking driver 
>> xmit
>> path about whether more packets are coming soon. This information can 
>> be
>> used to avoid unnecessary expensive PCIe transaction per tx packet at 
>> a
>> slight increase in latency.
>> 
>> Max TX pps on Mikrotik 10/25G NIC in a Threadripper 3960X system
>> improved from 1150Kpps to 1700Kpps.
>> 
