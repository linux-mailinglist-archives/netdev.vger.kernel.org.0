Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367BC516286
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 09:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbiEAIAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 04:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbiEAIAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 04:00:38 -0400
Received: from mail.tkos.co.il (guitar.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1357B574
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 00:57:13 -0700 (PDT)
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id 0362A440538;
        Sun,  1 May 2022 10:56:19 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1651391780;
        bh=FXPiP4eZ50pnNGg1nb6kPa5+xjmitxfddy3qkzOLbpQ=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=be3bv5CG66K2bpExMO12NdvZ/2loD4+gWq5zY7T5QIkB4S03IdSbAk32LaaQVse77
         z3YcfkArluBvhXN+F0epJZn5BVMDZ9fDBP7/CGBjku27S1+rv0804VHk8962JoRvKu
         h4CeUhnO9vR1JVb301/sf6IcI/NnKp2fvlOTFR2oNo4bwfnQkv6/Moyh5iQnbofMx5
         NL+5OKASFb+02vmqEKDLfIajQVfMdsd8KSI06ic3+f+CF/Nl76sCqhZeMMLU42gylH
         8Gl0Q+gLTdFRQ+J9ZeUUCi4AhpHf5MtS0G7tBIKvKLLMTxyCL04Jqho93wziTQtfYV
         r3hmXWb09sl/A==
References: <2460cc37a4138d3cfb598349e78f0c5f3cfa59c7.1651071936.git.baruch@tkos.co.il>
 <CAPv3WKf5dnOrzkm6uaFYHkuZZ2ANrr3PMNrUhU5SV6TFAJE2Qw@mail.gmail.com>
 <87levpzcds.fsf@tarshish>
 <CAPv3WKc1eM4gyD_VG2M+ozzvLYrDAXiKGvK6Ej_ykRVf-Zf9Mw@mail.gmail.com>
 <87czh1yn4x.fsf@tarshish>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: mvpp2: add delay at the end of .mac_prepare
Date:   Sun, 01 May 2022 10:46:25 +0300
In-reply-to: <87czh1yn4x.fsf@tarshish>
Message-ID: <878rrlznvu.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin,

On Thu, Apr 28 2022, Baruch Siach wrote:
> On Thu, Apr 28 2022, Marcin Wojtas wrote:
>> I booted MacchiatoBin doubleshot with DT (phy-mode set to "10gbase-r")
>> without your patch and the 3310 PHY is connected to 1G e1000 card.
>> After `ifconfig eth0 up` it properly drops to SGMII without any issue
>> in my setup:
>>
>> # ifconfig eth0 up
>> [   62.006580] mvpp2 f2000000.ethernet eth0: PHY
>> [f212a600.mdio-mii:00] driver [mv88x3310] (irq=POLL)
>> [   62.016777] mvpp2 f2000000.ethernet eth0: configuring for phy/sgmii link mode
>> # [   66.110289] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full
>> - flow control rx/tx
>> [   66.118270] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>> # ifconfig eth0 192.168.1.1
>> # ping 192.168.1.2
>> PING 192.168.1.2 (192.168.1.2): 56 data bytes
>> 64 bytes from 192.168.1.2: seq=0 ttl=64 time=0.511 ms
>> 64 bytes from 192.168.1.2: seq=1 ttl=64 time=0.212 ms
>
> This is what I see here:
>
> [   46.097184] mvpp2 f2000000.ethernet eth0: PHY [f212a600.mdio-mii:02] driver [mv88x3310] (irq=POLL)
> [   46.115071] mvpp2 f2000000.ethernet eth0: configuring for phy/10gbase-r link mode
> [   50.249513] mvpp2 f2000000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
> [   50.257539] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>
> It is almost the same except from the link mode. Why does it try sgmii
> even before auto-negotiation takes place?

I have now tested on my Macchiatobin, and the issue does not
reproduce. PHY firmware version here:

[    1.074605] mv88x3310 f212a600.mdio-mii:00: Firmware version 0.2.1.0

But still I see that pl->link_config.interface is initially set to
PHY_INTERFACE_MODE_10GBASER:

[   13.518118] mvpp2 f2000000.ethernet eth0: configuring for phy/10gbase-r link mode

This is set in phylink_create() based on DT phy-mode. After interface
down/up sequence pl->link_config.interface matches the 1G wire rate:

[   33.383971] mvpp2 f2000000.ethernet eth0: configuring for phy/sgmii link mode

Do you have any idea where your initial PHY_INTERFACE_MODE_SGMII comes
from?

Thanks,
baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
