Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785A72C2B61
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389745AbgKXPcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:32:52 -0500
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:58121 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389078AbgKXPcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 10:32:51 -0500
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0AOFWFUL031036;
        Tue, 24 Nov 2020 16:32:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=STMicroelectronics;
 bh=Ypt08g8yC5E1a0xePLAiZgQfojweHehBCCzNvuLtWM8=;
 b=ct7IcYWFG9R1S++YtI/eB2Q8vNwL6mXtwZlS2wUZq07usEjhSZD7BLNSBiVxQgI0YE6H
 50lJkKkHklPp1rD9O+aZhvbEGPFdmniLjpQjP4Wns0NEuLQEUlLdm7z7cUWH8Fg/t5oR
 /Wf+o7sMQr29/Ks6YbiDniNXGqF/tWNDE3u9i72WtV4mVxe6DXg50Y4OcKG7DMkLXl6u
 cHalXrkDGDXFofZnexU1DdnXaJ+A6K7Namw3ZmD3tbzRNbmXo4srOuXSqDWpWAMwoZPK
 xRA8Uys5hcX8RKXplwdNcgGh0HO9ZvL+Gfj39jTMBSkm8L37ycix4du1ZtEdtuAdqnWi mw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 34y05h898p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:32:33 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 7000F10002A;
        Tue, 24 Nov 2020 16:32:32 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag1node3.st.com [10.75.127.3])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 562A52568E0;
        Tue, 24 Nov 2020 16:32:32 +0100 (CET)
Received: from [10.129.7.42] (10.75.127.50) by SFHDAG1NODE3.st.com
 (10.75.127.3) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Nov
 2020 16:32:30 +0100
Message-ID: <e6cd5bdc3b50dedc4b751f86b8769dad6219591e.camel@st.com>
Subject: Re: [PATCH] net: phy: fix auto-negotiation in case of 'down-shift'
From:   Antonio Borneo <antonio.borneo@st.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        <stable@vger.kernel.org>, <linuxarm@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>
Date:   Tue, 24 Nov 2020 16:31:40 +0100
In-Reply-To: <20201124151716.GG1551@shell.armlinux.org.uk>
References: <20201124143848.874894-1-antonio.borneo@st.com>
         <4684304a-37f5-e0cd-91cf-3f86318979c3@gmail.com>
         <20201124151716.GG1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG1NODE2.st.com (10.75.127.2) To SFHDAG1NODE3.st.com
 (10.75.127.3)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_04:2020-11-24,2020-11-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-24 at 15:17 +0000, Russell King - ARM Linux admin wrote:
> On Tue, Nov 24, 2020 at 04:03:40PM +0100, Heiner Kallweit wrote:
> > Am 24.11.2020 um 15:38 schrieb Antonio Borneo:
> > > If the auto-negotiation fails to establish a gigabit link, the phy
> > > can try to 'down-shift': it resets the bits in MII_CTRL1000 to
> > > stop advertising 1Gbps and retries the negotiation at 100Mbps.
> > > 
> > I see that Russell answered already. My 2cts:
> > 
> > Are you sure all PHY's supporting downshift adjust the
> > advertisement bits? IIRC an Aquantia PHY I dealt with does not.
> > And if a PHY does so I'd consider this problematic:
> > Let's say you have a broken cable and the PHY downshifts to
> > 100Mbps. If you change the cable then the PHY would still negotiate
> > 100Mbps only.
> 
> From what I've seen, that is not how downshift works, at least on
> the PHYs I've seen.
> 
> When the PHY downshifts, it modifies the advertisement registers,
> but it also remembers the original value. When the cable is
> unplugged, it restores the setting to what was previously set.

In fact, at least rtl8211f is able to recover the original settings and
returns to 1Gbps once a decent cable gets plugged-in.

> 
> It is _far_ from nice, but the fact is that your patch that Antonio
> identified has broken previously working support, something that I
> brought up when I patched one of the PHY drivers that was broken by
> this very same problem by your patch.

The idea to fix it for a general case was indeed triggered by the fact that
before commit 5502b218e001 this was the norm. I considered it as a
regression.

> 
> That said, _if_ the PHY has a way to read the resolved state rather
> than reading the advertisement registers, that is what should be
> used (as I said previously) rather than trying to decode the
> advertisement registers ourselves. That is normally more reliable
> for speed and duplex.
> 

Wrt rtl8211f I don't have info other then the public datasheet, and there I
didn't found any way other than reading the advertisement register.

I have read the latest comment from Heiner. I will check aqr107!

Thanks
Antonio

