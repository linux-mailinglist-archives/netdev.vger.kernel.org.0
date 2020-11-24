Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29692C2BB0
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389871AbgKXPqP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Nov 2020 10:46:15 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:58334 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389688AbgKXPqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 10:46:11 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-188-sRZs1I9bOyajyYLjdda6pA-1; Tue, 24 Nov 2020 15:46:07 +0000
X-MC-Unique: sRZs1I9bOyajyYLjdda6pA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 24 Nov 2020 15:46:06 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 24 Nov 2020 15:46:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Russell King - ARM Linux admin' <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Antonio Borneo <antonio.borneo@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: phy: fix auto-negotiation in case of 'down-shift'
Thread-Topic: [PATCH] net: phy: fix auto-negotiation in case of 'down-shift'
Thread-Index: AQHWwnVdqICvBLQKe06JRpLbFKofpqnXaXCA
Date:   Tue, 24 Nov 2020 15:46:06 +0000
Message-ID: <1e3bfaa519954b3586bbf59c065bca6a@AcuMS.aculab.com>
References: <20201124143848.874894-1-antonio.borneo@st.com>
 <4684304a-37f5-e0cd-91cf-3f86318979c3@gmail.com>
 <20201124151716.GG1551@shell.armlinux.org.uk>
In-Reply-To: <20201124151716.GG1551@shell.armlinux.org.uk>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King
> Sent: 24 November 2020 15:17
...
> That said, _if_ the PHY has a way to read the resolved state rather
> than reading the advertisement registers, that is what should be
> used (as I said previously) rather than trying to decode the
> advertisement registers ourselves. That is normally more reliable
> for speed and duplex.

Determining the speed and duplux from the ANAR and ANRR (I can't
remember the name of the response register) has always been
completely broken.

The problems arise when you connect to either a 10M hub or
a 10/100M autodetecting hub (these are a 10M hub and a 100M hub
connected by a bridge).
The PHY will either see single link test pulses (10M hub) or
a simple burst of link test pulses (10/100 hub) and fall back
to 10M HDX or 100M HDX.
Both the 10M hub and 10/100 hub are happy with the link test
pulse stream that contains the ANAR.
However the ANRR register will (typically) contain the value
from the last system that sent it one.
So if you unplug from something that does 100M FDX and plug into
a hub the MAC unit is likely to be misconfigured and do FDX.

Of course, there is no generic way to get the actual mode.
I'm not sure the PHY I was using (a long time ago) even had
any private register that could tell you.

For one system (which was never going to do anything fast)
I just removed the FDX modes from the ANAR.
The MAC didn't care whether it was 10M or 100M.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

