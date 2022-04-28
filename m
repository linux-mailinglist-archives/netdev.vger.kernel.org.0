Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60639513C99
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 22:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351607AbiD1UZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 16:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbiD1UZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 16:25:10 -0400
Received: from mail.tkos.co.il (guitar.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250ABA5EA2
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 13:21:54 -0700 (PDT)
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id 9423744051C;
        Thu, 28 Apr 2022 23:21:03 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1651177263;
        bh=uGwNeA+8kF4m4k4RGF97qVcnnS1pxd7x623jnNptGRg=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=cibGMeRubYGJQ23PN+Z2Fn+nca8vBinq1QgPjXKaZy13RuXF9WU6hjkCyPI1jLTfW
         mpDHRN9OdWOtQqIUYULnpILRNZQGYSwiJM6muQ6wnpMfkQG/GTcICPn1t9AGw1Zyuf
         i8dnPg1Auivc8DLTrqTwq2GfC12WCRqyZDSaqbLwc2FuIWT5eMBFUtjC7OvaV5+hbW
         AEi2QY/KYQ7SQrmnvsrg70EyPHg7dCNMSVno3ZWUQt1ymdXU6NDA6S6KK6OuXjyJ7P
         nKD+ow1hsTMst3EQiffXKAIAft4UD7p/p2dJXDerrJ9axAhWXVc99eqsnqunkzZD2f
         mEr0I+cCYzUBw==
References: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
 <CAPv3WKf5dnOrzkm6uaFYHkuZZ2ANrr3PMNrUhU5SV6TFAJE2Qw@mail.gmail.com>
 <87levpzcds.fsf@tarshish>
 <CAPv3WKc1eM4gyD_VG2M+ozzvLYrDAXiKGvK6Ej_ykRVf-Zf9Mw@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
Date:   Thu, 28 Apr 2022 23:03:08 +0300
In-reply-to: <CAPv3WKc1eM4gyD_VG2M+ozzvLYrDAXiKGvK6Ej_ykRVf-Zf9Mw@mail.gmail.com>
Message-ID: <87czh1yn4x.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin,

On Thu, Apr 28 2022, Marcin Wojtas wrote:
> czw., 28 kwi 2022 o 13:16 Baruch Siach <baruch@tkos.co.il> napisa=C5=82(a=
):
>> On Thu, Apr 28 2022, Marcin Wojtas wrote:
>> > =C5=9Br., 27 kwi 2022 o 17:05 Baruch Siach <baruch@tkos.co.il> napisa=
=C5=82(a):
>> >>
>> >> From: Baruch Siach <baruch.siach@siklu.com>
>> >>
>> >> Without this delay PHY mode switch from XLG to SGMII fails in a weird
>> >> way. Rx side works. However, Tx appears to work as far as the MAC is
>> >> concerned, but packets don't show up on the wire.
>> >>
>> >> Tested with Marvell 10G 88X3310 PHY.
>> >>
>> >> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
>> >> ---
>> >>
>> >> Not sure this is the right fix. Let me know if you have any better
>> >> suggestion for me to test.
>> >>
>> >> The same issue and fix reproduce with both v5.18-rc4 and v5.10.110.
>> >> ---
>> >>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 ++
>> >>  1 file changed, 2 insertions(+)
>> >>
>> >> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/driver=
s/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> >>n index 1a835b48791b..8823efe396b1 100644
>> >> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> >> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> >> @@ -6432,6 +6432,8 @@ static int mvpp2_mac_prepare(struct phylink_con=
fig *config, unsigned int mode,
>> >>                 }
>> >>         }
>> >>
>> >> +       mdelay(10);
>> >> +
>> >>         return 0;
>> >>  }
>> >
>> > Thank you for the patch and debug effort, however at first glance it
>> > seems that adding delay may be a work-around and cover an actual root
>> > cause (maybe Russell will have more input here).
>>
>> That's my suspicion as well.
>>
>> > Can you share exact reproduction steps?
>>
>> I think I covered all relevant details. Is there anything you find
>> missing?
>>
>> The hardware setup is very similar to the Macchiatobin Doubleshot. I can
>> try to reproduce on that platform next week if it helps.
>>
>> The PHY MAC type (MV_V2_33X0_PORT_CTRL_MACTYPE_MASK) is set to
>> MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER.
>>
>> I can add that DT phy-mode is set to "10gbase-kr" (equivalent to
>> "10gbase-r" in this case). The port cp0_eth0 is connected to a 1G
>> Ethernet switch. Kernel messages indicate that on interface up the MAC
>> is first configured to XLG (10G), but after Ethernet (wire)
>> auto-negotiation that MAC switches to SGMII. If I set DT phy-mode to
>> "sgmii" the issue does not show. Same if I make a down/up cycle of the
>> interface.
>>
>> Thanks for your review.
>
> I booted MacchiatoBin doubleshot with DT (phy-mode set to "10gbase-r")
> without your patch and the 3310 PHY is connected to 1G e1000 card.
> After `ifconfig eth0 up` it properly drops to SGMII without any issue
> in my setup:
>
> # ifconfig eth0 up
> [   62.006580] mvpp2 f2000000.ethernet eth0: PHY
> [f212a600.mdio-mii:00] driver [mv88x3310] (irq=3DPOLL)
> [   62.016777] mvpp2 f2000000.ethernet eth0: configuring for phy/sgmii li=
nk mode
> # [   66.110289] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full
> - flow control rx/tx
> [   66.118270] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> # ifconfig eth0 192.168.1.1
> # ping 192.168.1.2
> PING 192.168.1.2 (192.168.1.2): 56 data bytes
> 64 bytes from 192.168.1.2: seq=3D0 ttl=3D64 time=3D0.511 ms
> 64 bytes from 192.168.1.2: seq=3D1 ttl=3D64 time=3D0.212 ms

This is what I see here:

[   46.097184] mvpp2 f2000000.ethernet eth0: PHY [f212a600.mdio-mii:02] dri=
ver [mv88x3310] (irq=3DPOLL)
[   46.115071] mvpp2 f2000000.ethernet eth0: configuring for phy/10gbase-r =
link mode
[   50.249513] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full - flow=
 control rx/tx
[   50.257539] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

It is almost the same except from the link mode. Why does it try sgmii
even before auto-negotiation takes place?

> Are you aware of the firmware version of the 3310 PHY in your setup?
> In my case it's:
> mv88x3310 f212a600.mdio-mii:00: Firmware version 0.3.3.0

I have a newer version here:

mv88x3310 f212a600.mdio-mii:02: Firmware version 0.3.10.0

This is a timing sensitive issue. Slight change in firmware code might
be significant.

One more detail that might be important is that the PHY firmware is
loaded at run-time using this patch (rebased):

  https://lore.kernel.org/all/13177f5abf60215fb9c5c4251e6f487e4d0d7ff0.1587=
967848.git.baruch@tkos.co.il/

Thanks,
baruch

--=20
                                                     ~. .~   Tk Open Systems
=3D}------------------------------------------------ooO--U--Ooo------------=
{=3D
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
