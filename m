Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE5921CF9E
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 08:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgGMG2G convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Jul 2020 02:28:06 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:38951 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgGMG2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 02:28:05 -0400
Received: from [192.168.1.91] (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id CFBE6CECA3;
        Mon, 13 Jul 2020 08:38:01 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 1/3] Bluetooth: Add new quirk for broken local ext
 features max_page
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CA+E=qVeYT41Wpp4wHgoVFMa9ty-FPsxxvUB-DJDnj07SpWhpjQ@mail.gmail.com>
Date:   Mon, 13 Jul 2020 08:27:33 +0200
Cc:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        arm-linux <linux-arm-kernel@lists.infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <70578F86-20D3-41C7-A968-83B0605D3526@holtmann.org>
References: <20200705195110.405139-1-anarsoul@gmail.com>
 <20200705195110.405139-2-anarsoul@gmail.com>
 <DF6CC01A-0282-45E2-A437-2E3E58CC2883@holtmann.org>
 <CA+E=qVeYT41Wpp4wHgoVFMa9ty-FPsxxvUB-DJDnj07SpWhpjQ@mail.gmail.com>
To:     Vasily Khoruzhick <anarsoul@gmail.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vasily,

>>> Some adapters (e.g. RTL8723CS) advertise that they have more than
>>> 2 pages for local ext features, but they don't support any features
>>> declared in these pages. RTL8723CS reports max_page = 2 and declares
>>> support for sync train and secure connection, but it responds with
>>> either garbage or with error in status on corresponding commands.
>> 
>> please send the btmon for this so I can see what the controller is responding.
> 
> Here is relevant part:
> 
> < HCI Command: Read Local Extend.. (0x04|0x0004) plen 1  #228 [hci0] 6.889869
>        Page: 2
>> HCI Event: Command Complete (0x0e) plen 14             #229 [hci0] 6.890487
>      Read Local Extended Features (0x04|0x0004) ncmd 2
>        Status: Success (0x00)
>        Page: 2/2
>        Features: 0x5f 0x03 0x00 0x00 0x00 0x00 0x00 0x00
>          Connectionless Slave Broadcast - Master
>          Connectionless Slave Broadcast - Slave
>          Synchronization Train
>          Synchronization Scan
>          Inquiry Response Notification Event
>          Coarse Clock Adjustment
>          Secure Connections (Controller Support)
>          Ping
> < HCI Command: Delete Stored Lin.. (0x03|0x0012) plen 7  #230 [hci0] 6.890559
>        Address: 00:00:00:00:00:00 (OUI 00-00-00)
>        Delete all: 0x01
>> HCI Event: Command Complete (0x0e) plen 6              #231 [hci0] 6.891170
>      Delete Stored Link Key (0x03|0x0012) ncmd 2
>        Status: Success (0x00)
>        Num keys: 0
> < HCI Command: Read Synchronizat.. (0x03|0x0077) plen 0  #232 [hci0] 6.891199
>> HCI Event: Command Complete (0x0e) plen 9              #233 [hci0] 6.891788
>      Read Synchronization Train Parameters (0x03|0x0077) ncmd 2
>        invalid packet size
>        01 ac bd 11 80 80                                ......
> = Close Index: 00:E0:4C:23:99:87                              [hci0] 6.891832
> 
> hci0 registration stops here and bluetoothctl doesn't even see the controller.

maybe just the read sync train params command is broken? Can you change the init code and not send it and see if the rest of the init phase proceeds. I would rather have the secure connections actually tested before dismissing it altogether.

Mind you, there were broken Broadcom implementation of connectionless slave broadcast as well. Maybe this is similar.

Regards

Marcel

