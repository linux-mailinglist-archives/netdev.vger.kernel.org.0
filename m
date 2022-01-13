Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB4D48D256
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 07:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiAMGcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 01:32:24 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:15069 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiAMGcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 01:32:24 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1n7teo-000UBX-OK
        for netdev@vger.kernel.org; Thu, 13 Jan 2022 07:32:22 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1n7teo-000QiV-CZ
        for netdev@vger.kernel.org; Thu, 13 Jan 2022 07:32:22 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 5743E24004B
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 07:32:19 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 16A23240049;
        Thu, 13 Jan 2022 07:32:19 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 7399A23BE5;
        Thu, 13 Jan 2022 07:32:13 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 13 Jan 2022 07:32:13 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, hkallweit1@gmail.com,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
Organization: TDT AG
In-Reply-To: <CAJ+vNU1R8fGssHjfoz-jN1zjBLPz4Kg8XEUsy4z4bByKS1PqQA@mail.gmail.com>
References: <20210719082756.15733-1-ms@dev.tdt.de>
 <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
 <94120968908a8ab073fa2fc0dd56b17d@dev.tdt.de>
 <CAJ+vNU2Bn_eks03g191KKLx5uuuekdqovx000aqcT5=f_6Zq=w@mail.gmail.com>
 <Yd7bsbvLyIquY5jn@shell.armlinux.org.uk>
 <CAJ+vNU1R8fGssHjfoz-jN1zjBLPz4Kg8XEUsy4z4bByKS1PqQA@mail.gmail.com>
Message-ID: <81cce37d4222bbbd941fcc78ff9cacca@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.17
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1642055542-0000E498-F5F63140/0/0
X-purgate: clean
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-12 19:25, Tim Harvey wrote:
> On Wed, Jan 12, 2022 at 5:46 AM Russell King (Oracle)
> <linux@armlinux.org.uk> wrote:
>> 
>> On Tue, Jan 11, 2022 at 11:12:33AM -0800, Tim Harvey wrote:
>> > I added a debug statement in xway_gphy_rgmii_init and here you can see
>> > it gets called 'before' the link comes up from the NIC on a board that
>> > has a cable plugged in at power-on. I can tell from testing that the
>> > rx_delay/tx_delay set in xway_gphy_rgmii_init does not actually take
>> > effect unless I then bring the link down and up again manually as you
>> > indicate.
>> >
>> > # dmesg | egrep "xway|nicvf"
>> > [    6.855971] xway_gphy_rgmii_init mdio_thunder MDI_MIICTRL:0xb100
>> > rx_delay=1500 tx_delay=500
>> > [    6.999651] nicvf, ver 1.0
>> > [    7.002478] nicvf 0000:05:00.1: Adding to iommu group 7
>> > [    7.007785] nicvf 0000:05:00.1: enabling device (0004 -> 0006)
>> > [    7.053189] nicvf 0000:05:00.2: Adding to iommu group 8
>> > [    7.058511] nicvf 0000:05:00.2: enabling device (0004 -> 0006)
>> > [   11.044616] nicvf 0000:05:00.2 eth1: Link is Up 1000 Mbps Full duplex
>> 
>> Does the kernel message about the link coming up reflect what is going
>> on physically with the link though?
>> 
>> If a network interface is down, it's entirely possible that the link 
>> is
>> already established at the hardware level, buit the "Link is Up" 
>> message
>> gets reported when the network interface is later brought up. So,
>> debugging this by looking at the kernel messages is unreliable.
>> 
> 
> Russell,
> 
> You are correct... the link doesn't come up at that point its already
> linked. So we need to force a reset or an auto negotiation reset after
> modifying the delays.
> 
> Tim

Setting BMCR_ANRESTART would work, but only if BMCR_ANENABLE is also or
already set. Otherwise BMCR_ANRESTART has no effect (see the note in the
datasheet).

This is the reason why I came up with the idea of BMCR_PDOWN.

Personally I would have no problem with setting BMCR_ANRESTART and
BMCR_ANENABLE, but it would possibly change the existing configuration
if (e.g. by the bootloader) aneg should be disabled.

Martin
