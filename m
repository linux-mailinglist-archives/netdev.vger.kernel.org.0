Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACBE815D457
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 10:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgBNJIQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Feb 2020 04:08:16 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:35868 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728691AbgBNJIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 04:08:16 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 01E97nY8000710, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTEXMB06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 01E97nY8000710
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 17:07:49 +0800
Received: from RTEXMB05.realtek.com.tw (172.21.6.98) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 14 Feb 2020 17:07:49 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 14 Feb 2020 17:07:49 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999]) by
 RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999%6]) with mapi id
 15.01.1779.005; Fri, 14 Feb 2020 17:07:49 +0800
From:   Hau <hau@realtek.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>
Subject: RE: SFP+ support for 8168fp/8117
Thread-Topic: SFP+ support for 8168fp/8117
Thread-Index: AQHVwTo87C9FPgb4q0K7N9j/9Mzg+6fW+ByAgAAXwwCAAE15gIAAfZ0AgECGEQCAAkeigA==
Date:   Fri, 14 Feb 2020 09:07:49 +0000
Message-ID: <995bddbc4f9d48cbb3a289a7e9799f15@realtek.com>
References: <2D8F5FFE-3EC3-480B-9D15-23CACE5556DF@canonical.com>
 <20200102152143.GB1397@lunn.ch>
 <DC28A43E-4F1A-40B6-84B0-3E79215527C9@canonical.com>
 <c148fefc-fd56-26a8-9f9b-fbefbaf25050@gmail.com>
 <02F7CBDE-B877-481C-A5AF-2F4CBF830A2C@canonical.com>
 <80E9C881-91C8-4F29-B9CE-652F9EE0B018@canonical.com>
In-Reply-To: <80E9C881-91C8-4F29-B9CE-652F9EE0B018@canonical.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.157]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Chun-Hao,
> 
> > On Jan 3, 2020, at 12:53, Kai-Heng Feng <kai.heng.feng@canonical.com>
> wrote:
> >
> >
> >
> >> On Jan 3, 2020, at 05:24, Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>
> >> On 02.01.2020 17:46, Kai-Heng Feng wrote:
> >>> Hi Andrew,
> >>>
> >>>> On Jan 2, 2020, at 23:21, Andrew Lunn <andrew@lunn.ch> wrote:
> >>>>
> >>>> On Thu, Jan 02, 2020 at 02:59:42PM +0800, Kai Heng Feng wrote:
> >>>>> Hi Heiner,
> >>>>>
> >>>>> There's an 8168fp/8117 chip has SFP+ port instead of RJ45, the phy
> device ID matches "Generic FE-GE Realtek PHY" nevertheless.
> >>>>> The problems is that, since it uses SFP+, both BMCR and BMSR read
> are always zero, so Realtek phylib never knows if the link is up.
> >>>>>
> >>>>> However, the old method to read through MMIO correctly shows the
> link is up:
> >>>>> static unsigned int rtl8169_xmii_link_ok(struct rtl8169_private
> >>>>> *tp) {
> >>>>>     return RTL_R8(tp, PHYstatus) & LinkStatus; }
> >>>>>
> >>>>> Few ideas here:
> >>>>> - Add a link state callback for phylib like phylink's
> phylink_fixed_state_cb(). However there's no guarantee that other parts of
> this chip works.
> >>>>> - Add SFP+ support for this chip. However the phy device matches to
> "Generic FE-GE Realtek PHY" which may complicate things.
> >>>>>
> >>>>> Any advice will be welcome.
> >>>>
> >>>> Hi Kai
> >>>>
> >>>> Is the i2c bus accessible?
> >>>
> >>> I don't think so. It seems to be a regular Realtek 8168 device with generic
> PCI ID [10ec:8168].
> >>>
> >>>> Is there any documentation or example code?
> >>>
> >>> Unfortunately no.
> >>>
> >>>>
> >>>> In order to correctly support SFP+ cages, we need access to the i2c
> >>>> bus to determine what sort of module has been inserted. It would
> >>>> also be good to have access to LOS, transmitter disable, etc, from
> >>>> the SFP cage.
> >>>
> >>> Seems like we need Realtek to provide more information to support this
> chip with SFP+.
> >>>
> >> Indeed it would be good to have some more details how this chip
> >> handles SFP+, therefore I add Hau to the discussion.
> >>
> >> As I see it the PHY registers are simply dummies on this chip. Or
> >> does this chip support both, PHY and SFP+? Hopefully SFP presence can
> >> be autodetected, we could skip the complete PHY handling in this
> >> case. Interesting would be which parts of the SFP interface are exposed
> how via (proprietary) registers.
> >> Recently the STMMAC driver was converted from phylib to phylink,
> >> maybe we have to do the same with r8169 one fine day. But w/o more
> >> details this is just speculation, much appreciated would be
> >> documentation from Realtek about the
> >> SFP+ interface.
> >>
> >> Kai, which hardware/board are we talking about?
> >
> > It's a regular Intel PC.
> >
> > The ethernet is function 1 of the PCI device, function 0 isn't bound to any
> driver:
> > 02:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
> > Device [10ec:816e] (rev 1a)
> > 02:00.1 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
> > RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168]
> > (rev 22)
> 
> Would it be possible to share some info on SFP support?
Hi Kai-Heng,

Could you use r8168 to dump hardware info with following command.
cat /proc/net/r8168/ethx/*

I want to make sure which chip you use and try to add support it in r8168/r8169.

Hau
> 
> Kai-Heng
> 
> >
> > Kai-Heng
> >
> >>
> >>> Kai-Heng
> >>>
> >>>>
> >>>> Andrew
> >>>
> >> Heiner
> >
> 
> 
> ------Please consider the environment before printing this e-mail.
