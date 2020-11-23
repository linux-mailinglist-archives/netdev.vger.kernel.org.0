Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5E12C01D7
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 10:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgKWJAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 04:00:16 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:54335 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgKWJAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 04:00:16 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kh7he-0007dS-1W; Mon, 23 Nov 2020 10:00:06 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kh7hc-00079Z-Vb; Mon, 23 Nov 2020 10:00:05 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 55B8A240041;
        Mon, 23 Nov 2020 10:00:04 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id C8593240040;
        Mon, 23 Nov 2020 10:00:03 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 8512B203C7;
        Mon, 23 Nov 2020 10:00:02 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 23 Nov 2020 10:00:02 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v4 2/5] net/lapb: support netdev events
Organization: TDT AG
In-Reply-To: <CAJht_EPc8MF1TjznSjWTPyMbsrw3JVqxST5g=eF0yf_zasUdeA@mail.gmail.com>
References: <20201120054036.15199-1-ms@dev.tdt.de>
 <20201120054036.15199-3-ms@dev.tdt.de>
 <CAJht_EONd3+S12upVPk2K3PWvzMLdE3BkzY_7c5gA493NHcGnA@mail.gmail.com>
 <CAJht_EP_oqCDs6mMThBZNtz4sgpbyQgMhKkHeqfS_7JmfEzfQg@mail.gmail.com>
 <87a620b6a55ea8386bffefca0a1f8b77@dev.tdt.de>
 <CAJht_EPc8MF1TjznSjWTPyMbsrw3JVqxST5g=eF0yf_zasUdeA@mail.gmail.com>
Message-ID: <d85a4543eae46bac1de28ec17a2389dd@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-ID: 151534::1606122005-000064E4-D07DD3F9/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-23 09:31, Xie He wrote:
> On Sun, Nov 22, 2020 at 10:55 PM Martin Schiller <ms@dev.tdt.de> wrote:
>> 
>> No, they aren't independent. The carrier can only be up if the device 
>> /
>> interface is UP. And as far as I can see a NETDEV_CHANGE event will 
>> also
>> only be generated on interfaces that are UP.
>> 
>> So you can be sure, that if there is a NETDEV_CHANGE event then the
>> device is UP.
> 
> OK. Thanks for your explanation!
> 
>> I removed the NETDEV_UP handling because I don't think it makes sense
>> to implicitly try to establish layer2 (LAPB) if there is no carrier.
> 
> As I understand, when the device goes up, the carrier can be either
> down or up. Right?
> 
> If this is true, when a device goes up and the carrier then goes up
> after that, L2 will automatically connect, but if a device goes up and
> the carrier is already up, L2 will not automatically connect. I think
> it might be better to eliminate this difference in handling. It might
> be better to make it automatically connect in both situations, or in
> neither situations.

AFAIK the carrier can't be up before the device is up. Therefore, there
will be a NETDEV_CHANGE event after the NETDEV_UP event.

This is what I can see in my tests (with the HDLC interface).

Is the behaviour different for e.g. lapbether?

> 
> If you want to go with the second way (auto connect in neither
> situations), the next (3rd) patch of this series might be also not
> needed.
> 
> I just want to make the behavior of LAPB more consistent. I think we
> should either make LAPB auto-connect in all situations, or make LAPB
> wait for L3's instruction to connect in all situations.
> 
>> And with the first X.25 connection request on that interface, it will
>> be established anyway by x25_transmit_link().
>> 
>> I've tested it here with an HDLC WAN Adapter and it works as expected.
>> 
>> These are also the ideal conditions for the already mentioned "on
>> demand" scenario. The only necessary change would be to call
>> x25_terminate_link() on an interface after clearing the last X.25
>> session.
>> 
>> > On NETDEV_GOING_DOWN, we can also check the carrier status first and
>> > if it is down, we don't need to call lapb_disconnect_request.
>> 
>> This is not necessary because lapb_disconnect_request() checks the
>> current state. And if the carrier is DOWN then the state should also 
>> be
>> LAPB_STATE_0 and so lapb_disconnect_request() does nothing.
> 
> Yes, I understand. I just thought adding this check might make the
> code cleaner. But you are right.
