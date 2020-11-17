Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486692B623A
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 14:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731434AbgKQN0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 08:26:34 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:24001 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730813AbgKQN0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 08:26:30 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kf105-00047U-31; Tue, 17 Nov 2020 14:26:25 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kf104-000Jms-7s; Tue, 17 Nov 2020 14:26:24 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 71C91240041;
        Tue, 17 Nov 2020 14:26:23 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id E1E2E240040;
        Tue, 17 Nov 2020 14:26:22 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 1670121EF7;
        Tue, 17 Nov 2020 14:26:22 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 17 Nov 2020 14:26:22 +0100
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
In-Reply-To: <CAJht_EPN=hXsGLsCSxj1bB8yTYNOe=yUzwtrtnMzSybiWhL-9Q@mail.gmail.com>
References: <20201116135522.21791-1-ms@dev.tdt.de>
 <20201116135522.21791-6-ms@dev.tdt.de>
 <CAJht_EM-ic4-jtN7e9F6zcJgG3OTw_ePXiiH1i54M+Sc8zq6bg@mail.gmail.com>
 <f3ab8d522b2bcd96506352656a1ef513@dev.tdt.de>
 <CAJht_EPN=hXsGLsCSxj1bB8yTYNOe=yUzwtrtnMzSybiWhL-9Q@mail.gmail.com>
Message-ID: <c0c2cedad399b12d152d2610748985fc@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate: clean
X-purgate-ID: 151534::1605619584-0001FA9D-13ABCA1E/0/0
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-17 12:32, Xie He wrote:
> On Tue, Nov 17, 2020 at 1:53 AM Martin Schiller <ms@dev.tdt.de> wrote:
>> 
>> On 2020-11-16 21:16, Xie He wrote:
>> > Do you mean we will now automatically establish LAPB connections
>> > without upper layers instructing us to do so?
>> 
>> Yes, as soon as the physical link is established, the L2 and also the
>> L3 layer (restart handshake) is established.
> 
> I see. Looking at your code in Patch 1 and this patch, I see after the
> device goes up, L3 code will instruct L2 to establish the connection,
> and before the device goes down, L3 will instruct L2 to terminate the
> connection. But if there is a carrier up/down event, L2 will
> automatically handle this without being instructed by L3, and it will
> establish the connection automatically when the carrier goes up. L2
> will notify L3 on any L2 link status change.
> 
> Is this right?

Yes, this is right.

> I think for a DCE, it doesn't need to initiate the L2
> connection on device-up. It just needs to wait for a connection to
> come. But L3 seems to be still instructing it to initiate the L2
> connection. This seems to be a problem.

The "ITU-T Recommendation X.25 (10/96) aka "Blue Book" [1] says under
point 2.4.4.1:
"Either the DTE or the DCE may initiate data link set-up."

Experience shows that there are also DTEs that do not establish a
connection themselves.

That is also the reason why I've added this patch:
https://patchwork.kernel.org/project/netdevbpf/patch/20201116135522.21791-7-ms@dev.tdt.de/

> It feels unclean to me that the L2 connection will sometimes be
> initiated by L3 and sometimes by L2 itself. Can we make L2 connections
> always be initiated by L2 itself? If L3 needs to do something after L2
> links up, L2 will notify it anyway.

My original goal was to change as little as possible of the original
code. And in the original code the NETDEV_UP/NETDEV_DOWN events were/are
handled in L3. But it is of course conceivable to shift this to L2.

But you have to keep in mind that the X.25 L3 stack can also be used
with tap interfaces (e.g. for XOT), where you do not have a L2 at all.

> 
>> In this context I also noticed that I should add another patch to this
>> patch-set to correct the restart handling.
> 
> Do you mean you will add code to let L3 restart any L3 connections
> previously abnormally terminated after L2 link up?

No, I mean the handling of Restart Request and Restart Confirm is buggy
and needs to be fixed also.

> 
>> As already mentioned I have a stack of fixes and extensions lying 
>> around
>> that I would like to get upstream.
> 
> Please do so! Thanks!
> 
> I previously found a locking problem in X.25 code and tried to address 
> it in:
> https://patchwork.kernel.org/project/netdevbpf/patch/20201114103625.323919-1-xie.he.0141@gmail.com/
> But later I found I needed to fix more code than I previously thought.
> Do you already have a fix for this problem?

No, sorry.


[1] https://www.itu.int/rec/T-REC-X.25-199610-I/
