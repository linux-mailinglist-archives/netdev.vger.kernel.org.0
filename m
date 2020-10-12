Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4B028B033
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgJLIZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:25:53 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:57395 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgJLIZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:25:53 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4C8sFV2Bgyz1r6n6;
        Mon, 12 Oct 2020 10:25:50 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4C8sFT6mDMz1qtZD;
        Mon, 12 Oct 2020 10:25:49 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id PMlXL_AF067s; Mon, 12 Oct 2020 10:25:47 +0200 (CEST)
X-Auth-Info: IUOEMG6j6w6T+7mO+bcViJsS5TlYYJ79Hmo2WCJ5uFE=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 12 Oct 2020 10:25:47 +0200 (CEST)
Subject: Re: PHY reset question
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Bruno Thomsen <bruno.thomsen@gmail.com>
Cc:     Fabio Estevam <festevam@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        David Jander <david@protonic.nl>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20201006080424.GA6988@pengutronix.de>
 <CAOMZO5Ds7mm4dWdt_a+HU=V40zjp006JQJbozRCicx9yiqacgg@mail.gmail.com>
 <CAH+2xPD=CE+pk_cEC=cLv1nebBBg7X+xDpOFANf3rQ4V2+2Cvw@mail.gmail.com>
 <20201012054839.n6do5ruxhbhc7h7n@pengutronix.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <cbb3aecd-5bcd-7221-2b0a-0ba91c9a55c0@denx.de>
Date:   Mon, 12 Oct 2020 10:25:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201012054839.n6do5ruxhbhc7h7n@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/20 7:48 AM, Oleksij Rempel wrote:
> Hi all,
> 
> thank you for the feedback!
> 
> On Fri, Oct 09, 2020 at 04:25:49PM +0200, Bruno Thomsen wrote:
>> Hi Fabio and Oleksij
>>
>> Den ons. 7. okt. 2020 kl. 11.50 skrev Fabio Estevam <festevam@gmail.com>:
>>>
>>> Hi Oleksij,
>>>
>>> On Tue, Oct 6, 2020 at 5:05 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>>>>
>>>> Hello PHY experts,
>>>>
>>>> Short version:
>>>> what is the proper way to handle the PHY reset before identifying PHY?
>>>>
>>>> Long version:
>>>> I stumbled over following issue:
>>>> If PHY reset is registered within PHY node. Then, sometimes,  we will not be
>>>> able to identify it (read PHY ID), because PHY is under reset.
>>>>
>>>> mdio {
>>>>         compatible = "virtual,mdio-gpio";
>>>>
>>>>         [...]
>>>>
>>>>         /* Microchip KSZ8081 */
>>>>         usbeth_phy: ethernet-phy@3 {
>>>>                 reg = <0x3>;
>>>>
>>>>                 interrupts-extended = <&gpio5 12 IRQ_TYPE_LEVEL_LOW>;
>>>>                 reset-gpios = <&gpio5 11 GPIO_ACTIVE_LOW>;
>>>>                 reset-assert-us = <500>;
>>>>                 reset-deassert-us = <1000>;
>>>>         };
>>>>
>>>>         [...]
>>>> };
>>>>
>>>> On simple boards with one PHY per MDIO bus, it is easy to workaround by using
>>>> phy-reset-gpios withing MAC node (illustrated in below DT example), instead of
>>>> using reset-gpios within PHY node (see above DT example).
>>>>
>>>> &fec {
>>>>         [...]
>>>>         phy-mode = "rmii";
>>>>         phy-reset-gpios = <&gpio4 12 GPIO_ACTIVE_LOW>;
>>>>         [...]
>>>
>>> I thought this has been fixed by Bruno's series:
>>> https://www.spinics.net/lists/netdev/msg673611.html
>>
>> Yes, that has fixed the Microchip/Micrel PHY ID auto detection
>> issue. I have send a DTS patch v3 that makes use of the newly
>> added device tree parameter:
>> https://lkml.org/lkml/2020/9/23/595
> 
> This way is suitable only for boards with single PHY and single reset
> line. But it is not scale on boards with multiple PHY and multiple reset
> lines.
> 
> So far, it looks like using compatible like "ethernet-phy-idXXXX.XXXX"
> is the only way to go.

I did further digging in this, and I agree it is either this or reset in
boot loader, sigh.
