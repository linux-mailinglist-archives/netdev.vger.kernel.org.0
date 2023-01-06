Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4FDC65FBA2
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjAFGx3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Jan 2023 01:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjAFGx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:53:27 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1E43657B
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:53:24 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3066qGEx9028823, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3066qGEx9028823
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 6 Jan 2023 14:52:17 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Fri, 6 Jan 2023 14:53:13 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 6 Jan 2023 14:53:12 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Fri, 6 Jan 2023 14:53:12 +0800
From:   Hau <hau@realtek.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net] r8169: fix rtl8168h wol fail
Thread-Topic: [PATCH net] r8169: fix rtl8168h wol fail
Thread-Index: AQHZITAeQEw7+pbiWEKyObvpj0H4U66PsbSAgAAedICAARt84A==
Date:   Fri, 6 Jan 2023 06:53:12 +0000
Message-ID: <9ee2f626bab3481697b71c58091e7def@realtek.com>
References: <20230105180408.2998-1-hau@realtek.com>
 <714782c5-b955-4511-23c0-9688224bba84@gmail.com> <Y7dAbxSPeaMnW/ly@lunn.ch>
In-Reply-To: <Y7dAbxSPeaMnW/ly@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.74]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/1/6_=3F=3F_01:27:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > rtl8168h has an application that it will connect to rtl8211fs
> > > through mdi interface. And rtl8211fs will connect to fiber through serdes
> interface.
> > > In this application, rtl8168h revision id will be set to 0x2a.
> > >
> > > Because rtl8211fs's firmware will set link capability to 100M and
> > > GIGA when link is from off to on. So when system suspend and wol is
> > > enabled, rtl8168h will speed down to 100M (because rtl8211fs
> > > advertise 100M and GIGA to rtl8168h). If the link speed between
> rtl81211fs and fiber is GIGA.
> > > The link speed between rtl8168h and fiber will mismatch. That will
> > > cause wol fail.
> > >
> > > In this patch, if rtl8168h is in this kind of application, driver
> > > will not speed down phy when wol is enabled.
> > >
> > I think the patch title is inappropriate because WoL works normally on
> > RTL8168h in the standard setup.
> > What you add isn't a fix but a workaround for a firmware bug in RTL8211FS.
> > As mentioned in a previous review comment: if speed on fibre side is
> > 1Gbps then RTL8211FS shouldn't advertise 100Mbps on MDI/UTP side.
> > Last but not least the user can still use e.g. ethtool to change the
> > speed to 100Mbps thus breaking the link.
> 
> I agree with Heiner here. I assume you cannot fix the firmware?
> 
> So can we detect the broken firmware and correctly set
> phydev->advertising? That will fix WoL and should prevent the user
> from using ethtool to select a slower speed.
> 
It is a rtl8211fs's firmware bug. Because in this application it will support both 100M and GIGA
fiber module, so it cannot just set phydev->advertising to 100M or GIGA. We  may need to 
use bit-bang MDIO to detect fiber link speed and set phydev->advertising properly. But it will
let this patch become more complicated.

 ------Please consider the environment before printing this e-mail.
