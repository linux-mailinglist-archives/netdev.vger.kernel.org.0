Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3303D5162BD
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 10:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245109AbiEAIfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 04:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235721AbiEAIfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 04:35:21 -0400
Received: from mail.tkos.co.il (mail.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C7A1A39E
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 01:31:56 -0700 (PDT)
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id 2A983440538;
        Sun,  1 May 2022 11:31:04 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1651393864;
        bh=bvBBIHWqQQTUQeDmLVmvqeGbw+FFDgsEiTGnOxBRlIg=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=UAsowb9Zllra4PODvZU/5tb8RAksIgDdRH6RAp8oAjaL3ntUaynAV0r/bK7iVcbEh
         5QOj9mSehh1SCpc0qN6azupDjP7KMdNfT5GbxotADlZI46SVFMhwJ5JqmwLVRzeD9G
         HxC3MkPCPn5Sj+8paTdWIihx9L/NEIqmSew9XXnM85gqkKKWlm14E20ZjPuAqQSopM
         EGV15fKZtE1uBIV/OAishKAewuMIdEyUwyHxHh3UPYDCSOyHjv6NeqcO+Yd0Xs5aPP
         FfxKBn5RsTGsB73mBwZRrTKgNeRqLfhzVP1wnj/5Ov4/Yg6WfS1San54n7wphglfyG
         Qk51Z4dC9p9yw==
References: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
 <CAPv3WKf5dnOrzkm6uaFYHkuZZ2ANrr3PMNrUhU5SV6TFAJE2Qw@mail.gmail.com>
 <87levpzcds.fsf@tarshish>
 <CAPv3WKc1eM4gyD_VG2M+ozzvLYrDAXiKGvK6Ej_ykRVf-Zf9Mw@mail.gmail.com>
 <87czh1yn4x.fsf@tarshish> <878rrlznvu.fsf@tarshish>
 <CAPv3WKfC25Uh2ufDh-4+5UPdyU7BLevmXw01pjFOM-kNrVQMeA@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
Date:   Sun, 01 May 2022 11:28:28 +0300
In-reply-to: <CAPv3WKfC25Uh2ufDh-4+5UPdyU7BLevmXw01pjFOM-kNrVQMeA@mail.gmail.com>
Message-ID: <874k29zm9y.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin,

On Sun, May 01 2022, Marcin Wojtas wrote:
> niedz., 1 maj 2022 o 09:57 Baruch Siach <baruch@tkos.co.il> napisa=C5=82(=
a):
>> On Thu, Apr 28 2022, Baruch Siach wrote:
>> > On Thu, Apr 28 2022, Marcin Wojtas wrote:
>> >> I booted MacchiatoBin doubleshot with DT (phy-mode set to "10gbase-r")
>> >> without your patch and the 3310 PHY is connected to 1G e1000 card.
>> >> After `ifconfig eth0 up` it properly drops to SGMII without any issue
>> >> in my setup:
>> >>
>> >> # ifconfig eth0 up
>> >> [   62.006580] mvpp2 f2000000.ethernet eth0: PHY
>> >> [f212a600.mdio-mii:00] driver [mv88x3310] (irq=3DPOLL)
>> >> [   62.016777] mvpp2 f2000000.ethernet eth0: configuring for phy/sgmi=
i link mode
>> >> # [   66.110289] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full
>> >> - flow control rx/tx
>> >> [   66.118270] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>> >> # ifconfig eth0 192.168.1.1
>> >> # ping 192.168.1.2
>> >> PING 192.168.1.2 (192.168.1.2): 56 data bytes
>> >> 64 bytes from 192.168.1.2: seq=3D0 ttl=3D64 time=3D0.511 ms
>> >> 64 bytes from 192.168.1.2: seq=3D1 ttl=3D64 time=3D0.212 ms
>> >
>> > This is what I see here:
>> >
>> > [   46.097184] mvpp2 f2000000.ethernet eth0: PHY [f212a600.mdio-mii:02=
] driver [mv88x3310] (irq=3DPOLL)
>> > [   46.115071] mvpp2 f2000000.ethernet eth0: configuring for phy/10gba=
se-r link mode
>> > [   50.249513] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full -=
 flow control rx/tx
>> > [   50.257539] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>> >
>> > It is almost the same except from the link mode. Why does it try sgmii
>> > even before auto-negotiation takes place?
>>
>> I have now tested on my Macchiatobin, and the issue does not
>> reproduce. PHY firmware version here:
>>
>> [    1.074605] mv88x3310 f212a600.mdio-mii:00: Firmware version 0.2.1.0
>>
>> But still I see that pl->link_config.interface is initially set to
>> PHY_INTERFACE_MODE_10GBASER:
>>
>> [   13.518118] mvpp2 f2000000.ethernet eth0: configuring for phy/10gbase=
-r link mode
>>
>> This is set in phylink_create() based on DT phy-mode. After interface
>> down/up sequence pl->link_config.interface matches the 1G wire rate:
>>
>> [   33.383971] mvpp2 f2000000.ethernet eth0: configuring for phy/sgmii l=
ink mode
>>
>> Do you have any idea where your initial PHY_INTERFACE_MODE_SGMII comes
>> from?
>>
>
> I have the same behavior, the link configured to 10GBASER and switches
> to 1G by linux init scripts. When I do the first ifconfig up, it's
> already at SGMII state:
>
> # dmesg | grep eth1
> [    2.071753] mvpp2 f2000000.ethernet eth1: Using random mac address
> 12:27:35:ff:2d:48
> [    3.461338] mvpp2 f2000000.ethernet eth1: PHY
> [f212a600.mdio-mii:00] driver [mv88x3310] (irq=3DPOLL)
> [    3.679714] mvpp2 f2000000.ethernet eth1: configuring for
> phy/10gbase-r link mode
> [    7.775483] mvpp2 f2000000.ethernet eth1: Link is Up - 1Gbps/Full -
> flow control rx/tx
> [    7.783455] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> [    8.801107] mvpp2 f2000000.ethernet eth1: Link is Down
> # ifconfig eth1 up
> [   37.498617] mvpp2 f2000000.ethernet eth1: PHY
> [f212a600.mdio-mii:00] driver [mv88x3310] (irq=3DPOLL)
> [   37.508812] mvpp2 f2000000.ethernet eth1: configuring for phy/sgmii li=
nk mode
> [   41.598331] mvpp2 f2000000.ethernet eth1: Link is Up - 1Gbps/Full -
> flow control rx/tx
> [   41.606309] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready

No wonder why you don't see this issue. Interface down/up sequence is
one of the "fixes" I tested.

Does it work for you if you remove the init script on first interface
up?

Thanks for testing,
baruch

--=20
                                                     ~. .~   Tk Open Systems
=3D}------------------------------------------------ooO--U--Ooo------------=
{=3D
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
