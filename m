Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59ACA513242
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345472AbiD1LUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345163AbiD1LT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:19:57 -0400
Received: from mail.tkos.co.il (mail.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E1F506DD
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 04:16:34 -0700 (PDT)
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id E1A5F4403E2;
        Thu, 28 Apr 2022 14:15:44 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1651144545;
        bh=bvpzDqNTeja94upg94fWt9+grPVCuInV23odRKhVTpU=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=U7I8xgHQHV80NPtf6Ei4k0pGOdhCIKiz9it4TUkfAa27ar71H1su1ApYu1gRHr46V
         gaohGKk+jd4JnjvGXtWPvs5QJn3Fh7G6DNU+ysjn4GSOrjwobIP3Gt567r5H9KX9R1
         KMN0tZNZFMZGg6s08sdi0RHadIOyDE4S4AzZO5iIaGSCetUKSFL/tHWq42M0jm8gaZ
         enzweovTqM7tTzO3JId0idPupIkaOSF8H8H12jPTonyQMZu/jOAUyo1SZ2Gp0UfpEn
         SADWCKbN4+wiKJlMgCeBZ1W8Y8pba4MzxVKQ9vCFmmpe1evawVgFYs2KZ2D0+MqFdp
         oTtg4z13Nng6Q==
References: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
 <CAPv3WKf5dnOrzkm6uaFYHkuZZ2ANrr3PMNrUhU5SV6TFAJE2Qw@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
Date:   Thu, 28 Apr 2022 13:59:55 +0300
In-reply-to: <CAPv3WKf5dnOrzkm6uaFYHkuZZ2ANrr3PMNrUhU5SV6TFAJE2Qw@mail.gmail.com>
Message-ID: <87levpzcds.fsf@tarshish>
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
> =C5=9Br., 27 kwi 2022 o 17:05 Baruch Siach <baruch@tkos.co.il> napisa=C5=
=82(a):
>>
>> From: Baruch Siach <baruch.siach@siklu.com>
>>
>> Without this delay PHY mode switch from XLG to SGMII fails in a weird
>> way. Rx side works. However, Tx appears to work as far as the MAC is
>> concerned, but packets don't show up on the wire.
>>
>> Tested with Marvell 10G 88X3310 PHY.
>>
>> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
>> ---
>>
>> Not sure this is the right fix. Let me know if you have any better
>> suggestion for me to test.
>>
>> The same issue and fix reproduce with both v5.18-rc4 and v5.10.110.
>> ---
>>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/n=
et/ethernet/marvell/mvpp2/mvpp2_main.c
>>n index 1a835b48791b..8823efe396b1 100644
>> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>> @@ -6432,6 +6432,8 @@ static int mvpp2_mac_prepare(struct phylink_config=
 *config, unsigned int mode,
>>                 }
>>         }
>>
>> +       mdelay(10);
>> +
>>         return 0;
>>  }
>
> Thank you for the patch and debug effort, however at first glance it
> seems that adding delay may be a work-around and cover an actual root
> cause (maybe Russell will have more input here).

That's my suspicion as well.

> Can you share exact reproduction steps?

I think I covered all relevant details. Is there anything you find
missing?

The hardware setup is very similar to the Macchiatobin Doubleshot. I can
try to reproduce on that platform next week if it helps.

The PHY MAC type (MV_V2_33X0_PORT_CTRL_MACTYPE_MASK) is set to
MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER.

I can add that DT phy-mode is set to "10gbase-kr" (equivalent to
"10gbase-r" in this case). The port cp0_eth0 is connected to a 1G
Ethernet switch. Kernel messages indicate that on interface up the MAC
is first configured to XLG (10G), but after Ethernet (wire)
auto-negotiation that MAC switches to SGMII. If I set DT phy-mode to
"sgmii" the issue does not show. Same if I make a down/up cycle of the
interface.

Thanks for your review.

baruch

--=20
                                                     ~. .~   Tk Open Systems
=3D}------------------------------------------------ooO--U--Ooo------------=
{=3D
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
