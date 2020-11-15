Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC302B31F8
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 03:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgKOC0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 21:26:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:53324 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgKOC0E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 21:26:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F3D10AC2D;
        Sun, 15 Nov 2020 02:26:02 +0000 (UTC)
Subject: Re: [PATCH net-next] net: mvneta: Fix validation of 2.5G HSGMII
 without comphy
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <uwe@kleine-koenig.org>,
        Michal Hrusecki <Michal.Hrusecky@nic.cz>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
References: <20201115004151.12899-1-afaerber@suse.de>
 <20201115010241.GF1551@shell.armlinux.org.uk>
From:   =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>
Organization: SUSE Software Solutions Germany GmbH
Message-ID: <4bf5376c-a7d1-17bf-1034-b793113b101e@suse.de>
Date:   Sun, 15 Nov 2020 03:26:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201115010241.GF1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 15.11.20 02:02, Russell King - ARM Linux admin wrote:
> On Sun, Nov 15, 2020 at 01:41:51AM +0100, Andreas Färber wrote:
>> Commit 1a642ca7f38992b086101fe204a1ae3c90ed8016 (net: ethernet: mvneta:
>> Add 2500BaseX support for SoCs without comphy) added support for 2500BaseX.
>>
>> In case a comphy is not provided, mvneta_validate()'s check
>>   state->interface == PHY_INTERFACE_MODE_2500BASEX
>> could never be true (it would've returned with empty bitmask before),
>> so that 2500baseT_Full and 2500baseX_Full do net get added to the mask.
> 
> This makes me nervous. It was intentional that if there is no comphy
> configured in DT for SoCs such as Armada 388, then there is no support
> to switch between 1G and 2.5G speed. Unfortunately, the configuration
> of the comphy is up to the board to do, not the SoC .dtsi, so we can't
> rely on there being a comphy on Armada 388 systems.

Please note that the if clause at the beginning of the validate function
does not check for comphy at all. So even with comphy, if there is a
code path that attempts to validate state 2500BASEX, it is broken, too.

Do you consider the modification of both ifs (validate and power_up) as
correct? Should they be split off from my main _NA change you discuss?

> So, one of the side effects of this patch is it incorrectly opens up
> the possibility of allowing 2.5G support on Armada 388 without a comphy
> configured.
> 
> We really need a better way to solve this; just relying on the lack of
> comphy and poking at a register that has no effect on Armada 388 to
> select 2.5G speed while allowing 1G and 2.5G to be arbitarily chosen
> doesn't sound like a good idea to me.
[snip]

May I add that the comphy needs better documentation?

Marek and I independently came up with <&comphy5 2> in the end, but the
DT binding doesn't explain what the index is supposed to be and how I
might figure it out. It cost me days of reading U-Boot and kernel
sources and playing around with values until I had the working one.

Might be helpful to have a symbolic dt-bindings #define for this 2.

U-Boot v2020.10 on Turris Omnia dumps this table:

 | Lane # | Speed |  Type       |
 --------------------------------
 |   0    |   6   | SATA0       |
 |   1    |   5   | USB3 HOST0  |
 |   2    |   5   | PCIe1       |
 |   3    |   5   | USB3 HOST1  |
 |   4    |   5   | PCIe2       |
 |   5    |   0   | SGMII2      |
 --------------------------------

But IIUC the Linux comphy driver doesn't take any type ID as argument
but rather an index into a table of "ports" which specifies another
index to apply or look up? Terribly indirect and magic to non-experts.

As a DT contributor I would need the binding to tell me that it's an
enum with 2 meaning SGMII2. Not even the max of 2 is documented. The
Linux driver talks of ports, but I don't see that term used in U-Boot,
and U-Boot APIs appeared to pass very different args in the board code.

The binding also still needs to be converted to YAML before we can
extend it with any better explanations. (And before you suggest it:
Since I obviously don't fully understand that hardware, I'm the wrong
person to attempt documenting it. The 38x comphy seems not mentioned in
MAINTAINERS, only the 3700 one.)

Regards,
Andreas

-- 
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer
HRB 36809 (AG Nürnberg)
