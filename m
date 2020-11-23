Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615352C005B
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 07:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgKWGz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 01:55:29 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:2187 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbgKWGz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 01:55:28 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kh5kw-000Rnq-HN; Mon, 23 Nov 2020 07:55:22 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kh5kv-000JSp-MD; Mon, 23 Nov 2020 07:55:21 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id E7E79240041;
        Mon, 23 Nov 2020 07:55:20 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 69A4D240040;
        Mon, 23 Nov 2020 07:55:20 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id C2B5220049;
        Mon, 23 Nov 2020 07:55:18 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 23 Nov 2020 07:55:18 +0100
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
In-Reply-To: <CAJht_EP_oqCDs6mMThBZNtz4sgpbyQgMhKkHeqfS_7JmfEzfQg@mail.gmail.com>
References: <20201120054036.15199-1-ms@dev.tdt.de>
 <20201120054036.15199-3-ms@dev.tdt.de>
 <CAJht_EONd3+S12upVPk2K3PWvzMLdE3BkzY_7c5gA493NHcGnA@mail.gmail.com>
 <CAJht_EP_oqCDs6mMThBZNtz4sgpbyQgMhKkHeqfS_7JmfEzfQg@mail.gmail.com>
Message-ID: <87a620b6a55ea8386bffefca0a1f8b77@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate-ID: 151534::1606114522-000035B9-9654EEDC/0/0
X-purgate: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-21 00:50, Xie He wrote:
> On Fri, Nov 20, 2020 at 3:11 PM Xie He <xie.he.0141@gmail.com> wrote:
>> 
>> Should we also handle the NETDEV_UP event here? In previous versions
>> of this patch series you seemed to want to establish the L2 connection
>> on device-up. But in this patch, you didn't handle NETDEV_UP.
>> 
>> Maybe on device-up, we need to check if the carrier is up, and if it
>> is, we do the same thing as we do on carrier-up.
> 
> Are the device up/down status and the carrier up/down status
> independent of each other? If they are, on device-up or carrier-up, we
> only need to try establishing the L2 connection if we see both are up.

No, they aren't independent. The carrier can only be up if the device /
interface is UP. And as far as I can see a NETDEV_CHANGE event will also
only be generated on interfaces that are UP.

So you can be sure, that if there is a NETDEV_CHANGE event then the
device is UP.

I removed the NETDEV_UP handling because I don't think it makes sense
to implicitly try to establish layer2 (LAPB) if there is no carrier.
And with the first X.25 connection request on that interface, it will
be established anyway by x25_transmit_link().

I've tested it here with an HDLC WAN Adapter and it works as expected.

These are also the ideal conditions for the already mentioned "on
demand" scenario. The only necessary change would be to call
x25_terminate_link() on an interface after clearing the last X.25
session.

> On NETDEV_GOING_DOWN, we can also check the carrier status first and
> if it is down, we don't need to call lapb_disconnect_request.

This is not necessary because lapb_disconnect_request() checks the
current state. And if the carrier is DOWN then the state should also be
LAPB_STATE_0 and so lapb_disconnect_request() does nothing.
