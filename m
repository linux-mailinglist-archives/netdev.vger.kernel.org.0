Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA4A3263F9
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 15:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhBZOWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 09:22:55 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:58921 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhBZOWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 09:22:51 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1lFdzG-000FB0-Ps; Fri, 26 Feb 2021 15:20:58 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1lFdzF-000PO6-IK; Fri, 26 Feb 2021 15:20:57 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id B884A240041;
        Fri, 26 Feb 2021 15:20:56 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 12F2E240040;
        Fri, 26 Feb 2021 15:20:56 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 7E2A4200E1;
        Fri, 26 Feb 2021 15:20:55 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 26 Feb 2021 15:20:55 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
Organization: TDT AG
In-Reply-To: <CAJht_EPBJhhdCBoon=WMuPBk-sxaeYOq3veOpAd2jq5kFqQHBg@mail.gmail.com>
References: <20210216201813.60394-1-xie.he.0141@gmail.com>
 <YC4sB9OCl5mm3JAw@unreal>
 <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
 <YC5DVTHHd6OOs459@unreal>
 <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
 <YC7GHgYfGmL2wVRR@unreal>
 <CAJht_EPZ7rVFd-XD6EQD2VJTDtmZZv0HuZvii+7=yhFgVz68VQ@mail.gmail.com>
 <CAJht_EPPMhB0JTtjWtMcGbRYNiZwJeMLWSC5hS6WhWuw5FgZtg@mail.gmail.com>
 <20210219103948.6644e61f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOru3pW6AHN4QVjiaERpLSfg-0G0ZEaqU_hkhX1acv0HQ@mail.gmail.com>
 <906d8114f1965965749f1890680f2547@dev.tdt.de>
 <CAJht_EPBJhhdCBoon=WMuPBk-sxaeYOq3veOpAd2jq5kFqQHBg@mail.gmail.com>
Message-ID: <e1750da4179aca52960703890e985af3@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.16
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate: clean
X-purgate-ID: 151534::1614349258-000052FF-44B5BAFB/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-02-22 09:56, Xie He wrote:
> On Sun, Feb 21, 2021 at 11:14 PM Martin Schiller <ms@dev.tdt.de> wrote:
>> 
>> I'm not really happy with this change because it breaks compatibility.
>> We then suddenly have 2 interfaces; the X.25 routings are to be set 
>> via
>> the "new" hdlc<x>_x25 interfaces instead of the hdlc<x> interfaces.
>> 
>> I currently just don't have a nicer solution to fix this queueing
>> problem either. On the other hand, since the many years we have been
>> using the current state, I have never noticed any problems with
>> discarded frames. So it might be more a theoretical problem than a
>> practical one.
> 
> This problem becomes very serious when we use AF_PACKET sockets,
> because the majority of frames would be dropped by the hardware
> driver, which significantly impacts transmission speed. What I am
> really doing is to enable adequate support for AF_PACKET sockets,
> allowing users to use the bare (raw) LAPB protocol. If we take this
> into consideration, this problem is no longer just a theoretical
> problem, but a real practical issue.

I have now had a look at it. It works as expected.
I just wonder if it would not be more appropriate to call
the lapb_register() already in x25_hdlc_open(), so that the layer2
(lapb) can already "work" before the hdlc<x>_x25 interface is up.


Also, I have a hard time assessing if such a wrap is really enforceable.
Unfortunately I have no idea how many users there actually are.


> 
> If we don't want to break backward compatibility, there is another 
> option:
> We can create a new API for the HDLC subsystem for stopping/restarting
> the TX queue, and replace all HDLC hardware drivers' netif_stop_queue
> and netif_wake_queue calls with calls to this new API. This new API
> would then call hdlc_x25 to stop/restart its internal queue.
> 
> But this option would require modifying all HDLC hardware drivers'
> code, and frankly, not all HDLC hardware drivers' developers care
> about running X.25 protocols on their hardware. So this would cause
> both hardware driver instabilities and confusion for hardware driver
> developers.
