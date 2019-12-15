Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15B2A11F71D
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 11:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfLOKN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 05:13:29 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:36475 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbfLOKN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 05:13:29 -0500
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 26B5E440777;
        Sun, 15 Dec 2019 12:13:26 +0200 (IST)
References: <20191211131111.GK16369@lunn.ch> <87fthqu6y6.fsf@tarshish> <20191211174938.GB30053@lunn.ch> <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il> <20191212131448.GA9959@lunn.ch> <20191212150810.zx6o26jnk5croh4r@sapphire.tkos.co.il> <20191212151355.GE30053@lunn.ch> <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il> <20191212193611.63111051@nic.cz> <20191212190640.6vki2pjfacdnxihh@sapphire.tkos.co.il> <20191212193129.GF30053@lunn.ch> <20191212204141.16a406cd@nic.cz>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
In-reply-to: <20191212204141.16a406cd@nic.cz>
Date:   Sun, 15 Dec 2019 12:13:25 +0200
Message-ID: <8736dlucai.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Thu, Dec 12 2019, Marek Behun wrote:

> On Thu, 12 Dec 2019 20:31:29 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
>
>> > diff --git a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
>> > index bd881497b872..8f61cae9d3b0 100644
>> > --- a/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
>> > +++ b/arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts
>> > @@ -408,6 +408,11 @@ port@5 {
>> >  				reg = <5>;
>> >  				label = "cpu";
>> >  				ethernet = <&cp1_eth2>;
>> > +
>> > +				fixed-link {
>> > +					speed = <2500>;
>> > +					full-duplex;
>> > +				};
>> >  			};
>> >  		};
>>
>> The DSA driver is expected to configure the CPU port at its maximum
>> speed. You should only add a fixed link if you need to slow it down.
>> I expect 2500 is the maximum speed of this port.
>
> Baruch, if the cpu port is in 2500 base-x, remove the fixed-link and do
> this:
>
> port@5 {
> 	reg = <5>;
> 	label = "cpu";
> 	ethernet = <&cp1_eth2>;
> 	phy-mode = "2500base-x";
> 	managed = "in-band-status";
> };

Thanks. That is enough to fix the phylink issue triggered by commit
7fb5a711545 ("net: dsa: mv88e6xxx: drop adjust_link to enabled
phylink").

The Clearfog GT-8K DT has also this on the cpu side:

&cp1_eth2 {
        status = "okay";
        phy-mode = "2500base-x";
        phys = <&cp1_comphy5 2>;
        fixed-link {
                speed = <2500>;
                full-duplex;
        };
};

Should I drop fixed-link here as well?

The call to mv88e6341_port_set_cmode() introduced in commit 7a3007d22e8
("net: dsa: mv88e6xxx: fully support SERDES on Topaz family") still
breaks port 5 (cpu) configuration. When called, its mode parameter is
set to PHY_INTERFACE_MODE_2500BASEX (19).

Any idea?

Thanks,
baruch

--
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
