Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D1D2B7EB6
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 14:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgKRN5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 08:57:18 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:53307 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgKRN5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 08:57:17 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfNxM-0006lO-Tk; Wed, 18 Nov 2020 14:57:08 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kfNxL-0004WC-U6; Wed, 18 Nov 2020 14:57:07 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 188BB240041;
        Wed, 18 Nov 2020 14:57:04 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 8DE49240040;
        Wed, 18 Nov 2020 14:57:03 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 2B85220370;
        Wed, 18 Nov 2020 14:57:02 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 18 Nov 2020 14:57:02 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 5/6] net/lapb: support netdev events
Organization: TDT AG
In-Reply-To: <CAJht_EMd5iKmdvePgYzWYXnG=5LxQopStzz_Lk9uNSkRyrudqw@mail.gmail.com>
References: <20201116135522.21791-1-ms@dev.tdt.de>
 <20201116135522.21791-6-ms@dev.tdt.de>
 <CAJht_EM-ic4-jtN7e9F6zcJgG3OTw_ePXiiH1i54M+Sc8zq6bg@mail.gmail.com>
 <f3ab8d522b2bcd96506352656a1ef513@dev.tdt.de>
 <CAJht_EPN=hXsGLsCSxj1bB8yTYNOe=yUzwtrtnMzSybiWhL-9Q@mail.gmail.com>
 <c0c2cedad399b12d152d2610748985fc@dev.tdt.de>
 <CAJht_EO=G94_xoCupr_7Tt_-kjYxZVfs2n4CTa14mXtu7oYMjg@mail.gmail.com>
 <c60fe64ff67e244bbe9971cfa08713db@dev.tdt.de>
 <CAJht_EOSZRV9uBcRYq6OBLwFOX7uE9Nox+sFv-U0SXRkLaNBrQ@mail.gmail.com>
 <CAJht_EMd5iKmdvePgYzWYXnG=5LxQopStzz_Lk9uNSkRyrudqw@mail.gmail.com>
Message-ID: <b494372c616c811ab8814e42c907434f@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate: clean
X-purgate-ID: 151534::1605707828-00000FB8-740E6CBA/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-18 14:46, Xie He wrote:
> On Wed, Nov 18, 2020 at 5:03 AM Xie He <xie.he.0141@gmail.com> wrote:
>> 
>> On Wed, Nov 18, 2020 at 12:49 AM Martin Schiller <ms@dev.tdt.de> 
>> wrote:
>> >
>> > I also have a patch here that implements an "on demand" link feature,
>> > which we used for ISDN dialing connections.
>> > As ISDN is de facto dead, this is not relevant anymore. But if we want
>> > such kind of feature, I think we need to stay with the method to control
>> > L2 link state from L3.
>> 
>> I see. Hmm...
>> 
>> I guess for ISDN, the current code (before this patch series) is the
>> best. We only establish the connection when L3 has packets to send.
>> 
>> Can we do this? We let L2 handle all device-up / device-down /
>> carrier-up / carrier-down events. And when L3 has some packets to send
>> but it still finds the L2 link is not up, it will then instruct L2 to
>> connect.
>> 
>> This way we may be able to both keep the logic simple and still keep
>> L3 compatible with ISDN.
> 
> Another solution might be letting ISDN automatically connect when it
> receives the first packet from L3. This way we can still free L3 from
> all handlings of L2 connections.

ISDN is not important now. Also the I4L subsystem has been removed.

I have now completely reworked the patch-set and it is now much tidier.
For now I left the event handling completely in X.25 (L3).

I will now send the whole thing as v3 and we can discuss it further.
