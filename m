Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7206C6A2C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 14:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjCWN60 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Mar 2023 09:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjCWN6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 09:58:18 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0EE9001
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 06:58:12 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32NDvZbwD010508, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32NDvZbwD010508
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 23 Mar 2023 21:57:35 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 23 Mar 2023 21:57:50 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 23 Mar 2023 21:57:49 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Thu, 23 Mar 2023 21:57:49 +0800
From:   Hau <hau@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net] r8169: fix rtl8168h rx crc error
Thread-Topic: [PATCH net] r8169: fix rtl8168h rx crc error
Thread-Index: AQHZXIn13gnxa8cqaECWm4Ww3lcREq8F70wAgADCfmCAAACrAIABsdmQ
Date:   Thu, 23 Mar 2023 13:57:48 +0000
Message-ID: <681a087e08f646ceb22f7febcae75332@realtek.com>
References: <20230322064550.2378-1-hau@realtek.com>
        <20230322082104.y6pz7ewu3ojd3esh@soft-dev3-1>
        <3892d440f0194b30aa32ccd93f661dd2@realtek.com>
 <20230322125934.102876c1@kernel.org>
In-Reply-To: <20230322125934.102876c1@kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.228.56]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, 22 Mar 2023 12:13:12 +0000 Hau wrote:
> > > Don't forget to add the fixes tag.
> > > Another comment that I usually get is to replace hardcoded values
> > > with defines, but on the other side I can see that this file already
> > > has plently of hardcoded values.
> >
> > It is not a fix for a specific commit. PHY 10m pll off is an power
> > saving feature which is enabled by H/W default. This issue can be
> > fixed by disable PHY 10m pll off.
> 
> How far back can the issue be reproduced? Is it only possible with certain
> device types? Then the Fixes tag should point at the commit which added
> support for the devices. Was it always present since 2.6 kernels? Put the first
> commit in the git history as Fixes.
> 
RTL8168H is the only chip we know that has this issue. This issue is related to the H/W default setting.
So I will add a Fixes tag to the commit which added support for this chip and submit the patch again.

------Please consider the environment before printing this e-mail.
