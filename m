Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FD9306DBA
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhA1Gli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:41:38 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:54363 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhA1Glh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:41:37 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1l50xy-00009M-56; Thu, 28 Jan 2021 07:39:42 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1l50xx-000094-1D; Thu, 28 Jan 2021 07:39:41 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id E9BF6240041;
        Thu, 28 Jan 2021 07:39:39 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 5D5D2240040;
        Thu, 28 Jan 2021 07:39:39 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id CAB7121C58;
        Thu, 28 Jan 2021 07:39:38 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 28 Jan 2021 07:39:38 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net] net: hdlc_x25: Use qdisc to queue outgoing LAPB
 frames
Organization: TDT AG
In-Reply-To: <CAJht_ENmxCBk=h68CN55qySMAiYhcgS0AtVzo6RvS5xf_6EkRw@mail.gmail.com>
References: <20210127090747.364951-1-xie.he.0141@gmail.com>
 <77971dffcff441c3ad3d257825dc214b@AcuMS.aculab.com>
 <CAJht_ENmxCBk=h68CN55qySMAiYhcgS0AtVzo6RvS5xf_6EkRw@mail.gmail.com>
Message-ID: <2b14439178ff54e991c45a9a1574243e@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1611815981-00004C0A-619C0A3A/0/0
X-purgate: clean
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-27 21:29, Xie He wrote:
> On Wed, Jan 27, 2021 at 2:14 AM David Laight <David.Laight@aculab.com> 
> wrote:
>> 
>> If I read this correctly it adds a (potentially big) queue between the
>> LAPB code that adds the sequence numbers to the frames and the 
>> hardware
>> that actually sends them.
> 
> Yes. The actual number of outgoing LAPB frames being queued depends on
> how long the hardware driver stays in the TX busy state, and is
> limited by the LAPB sending window.
> 
>> IIRC [1] there is a general expectation that the NR in a transmitted 
>> frame
>> will be the same as the last received NS unless acks are being delayed
>> for flow control reasons.
>> 
>> You definitely want to be able to ack a received frame while 
>> transmitting
>> back-to-back I-frames.
>> 
>> This really means that you only want 2 frames in the hardware driver.
>> The one being transmitted and the next one - so it gets sent with a
>> shared flag.
>> There is no point sending an RR unless the hardware link is actually 
>> idle.
> 
> If I understand correctly, what you mean is that the frames sent on
> the wire should reflect the most up-to-date status of what is received
> from the wire, so queueing outgoing LAPB frames is not appropriate.
> 
> But this would require us to deal with the "TX busy" issue in the LAPB
> module. This is (as I said) not easy to do. I currently can't think of
> a good way of doing this.
> 
> Instead, we can think of the TX queue as part of the "wire". We can
> think of the wire as long and having a little higher latency. I
> believe the LAPB protocol has no problem in handling long wires.
> 
> What do you think?

David: Can you please elaborate on your concerns a little bit more?

I think Xie's approach is not bad at all. LAPB (L2) has no idea about L1
(apart from the link state) and sends as many packets as possible, which
of course we should not discard. The remaining window determines how
many packets are put into this queue.
Since we can't send anything over the line due to the TX Busy state, the
remote station (due to lack of ACKs) will also stop sending anything
at some point.

When the link goes down, all buffers/queues must be cleared.
