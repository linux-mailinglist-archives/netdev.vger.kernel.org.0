Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7579B2C037A
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 11:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbgKWKin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 05:38:43 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:52431 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbgKWKim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 05:38:42 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kh9Ey-0006Lm-RV; Mon, 23 Nov 2020 11:38:36 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kh9Ex-0007AY-QM; Mon, 23 Nov 2020 11:38:35 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 60F53240041;
        Mon, 23 Nov 2020 11:38:35 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id D7AE8240040;
        Mon, 23 Nov 2020 11:38:34 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 7EC19203C7;
        Mon, 23 Nov 2020 11:38:34 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 23 Nov 2020 11:38:34 +0100
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
In-Reply-To: <CAJht_EO+enBOFMkVVB5y6aRnyMEsOZtUBJcAvOFBS91y7CauyQ@mail.gmail.com>
References: <20201120054036.15199-1-ms@dev.tdt.de>
 <20201120054036.15199-3-ms@dev.tdt.de>
 <CAJht_EONd3+S12upVPk2K3PWvzMLdE3BkzY_7c5gA493NHcGnA@mail.gmail.com>
 <CAJht_EP_oqCDs6mMThBZNtz4sgpbyQgMhKkHeqfS_7JmfEzfQg@mail.gmail.com>
 <87a620b6a55ea8386bffefca0a1f8b77@dev.tdt.de>
 <CAJht_EPc8MF1TjznSjWTPyMbsrw3JVqxST5g=eF0yf_zasUdeA@mail.gmail.com>
 <d85a4543eae46bac1de28ec17a2389dd@dev.tdt.de>
 <CAJht_EMjO_Tkm93QmAeK_2jg2KbLdv2744kCSHiZLy48aXiHnw@mail.gmail.com>
 <CAJht_EO+enBOFMkVVB5y6aRnyMEsOZtUBJcAvOFBS91y7CauyQ@mail.gmail.com>
Message-ID: <16b7e74e6e221f43420da7836659d7df@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-ID: 151534::1606127916-000074F7-5C8CC61A/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-23 11:08, Xie He wrote:
> On Mon, Nov 23, 2020 at 1:36 AM Xie He <xie.he.0141@gmail.com> wrote:
>> 
>> Some drivers don't support carrier status and will never change it.
>> Their carrier status will always be UP. There will not be a
>> NETDEV_CHANGE event.

Well, one could argue that we would have to repair these drivers, but I
don't think that will get us anywhere.

 From this point of view it will be the best to handle the NETDEV_UP in
the lapb event handler and establish the link analog to the
NETDEV_CHANGE event if the carrier is UP.

>> 
>> lapbether doesn't change carrier status. I also have my own virtual
>> HDLC WAN driver (for testing) which also doesn't change carrier
>> status.
>> 
>> I just tested with lapbether. When I bring up the interface, there
>> will only be NETDEV_PRE_UP and then NETDEV_UP. There will not be
>> NETDEV_CHANGE. The carrier status is alway UP.
>> 
>> I haven't tested whether a device can receive NETDEV_CHANGE when it is
>> down. It's possible for a device driver to call netif_carrier_on when
>> the interface is down. Do you know what will happen if a device driver
>> calls netif_carrier_on when the interface is down?
> 
> I just did a test on lapbether and saw there would be no NETDEV_CHANGE
> event when the netif is down, even if netif_carrier_on/off is called.
> So we can rest assured of this part.
