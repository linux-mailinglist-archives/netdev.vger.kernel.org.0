Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601843209AF
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 12:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhBUK7J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 21 Feb 2021 05:59:09 -0500
Received: from mailer.bingner.com ([64.62.210.4]:29170 "EHLO mail.bingner.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229540AbhBUK7H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Feb 2021 05:59:07 -0500
X-Greylist: delayed 941 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2021 05:59:07 EST
Received: from EX02.ds.sbdhi.com (2001:470:3c:1::22) by EX01.ds.sbdhi.com
 (2001:470:3c:1::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Sun, 21 Feb
 2021 00:42:44 -1000
Received: from EX02.ds.sbdhi.com ([fe80::8911:a681:797:3bb6]) by
 EX02.ds.sbdhi.com ([fe80::8911:a681:797:3bb6%2]) with mapi id 15.01.2044.004;
 Sun, 21 Feb 2021 00:42:44 -1000
From:   Sam Bingner <sam@bingner.com>
To:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Martin Habets <mhabets@solarflare.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matti Vuorela <matti.vuorela@bitfactor.fi>,
        Jakub Kicinski <kuba@kernel.org>,
        "Yves-Alexis Perez" <corsac@corsac.net>
Subject: Re: [PATCH] usbnet: ipheth: fix connectivity with iOS 14
Thread-Topic: Re: [PATCH] usbnet: ipheth: fix connectivity with iOS 14
Thread-Index: AdcIPCziP88UnOb2Try4p4IFfkZ3BQ==
Date:   Sun, 21 Feb 2021 10:42:44 +0000
Message-ID: <370902e520c44890a44cb5dd0cb1595f@bingner.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.155.121.8]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There seems to be a problem with this patch:

Whenever the iPhone sends a packet to the tethered device that is 1500 bytes long, it gets the error "ipheth 1-1:4.2: ipheth_rcvbulk_callback: urb status: -79" on the connected device and stops passing traffic.  I am able to bring it back up by shutting and unshutting the interface, but the same thing happens very quickly.   I noticed that this patch dropped the max USB packet size from 1516 to 1514 bytes, so I decided to try lowering the MTU to 1498; this made the connection reliable and no more errors occurred.

It appears to me that the iPhone is still sending out 1516 bytes over USB for a 1500 byte packet and this patch makes USB abort when that happens?  I could duplicate reliably by sending a ping from the iphone (ping -s 1472) to the connected device, or vice versa as the reply would then break it.

I apologize if this reply doesn't end up where it should - I tried to reply to the last message in this thread but I wasn't actually *on* the thread so I had to just build it as much as possible myself.

Sam
