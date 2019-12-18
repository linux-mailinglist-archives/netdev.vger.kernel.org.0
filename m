Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEB4124C71
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 17:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfLRQE5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Dec 2019 11:04:57 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:36862 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbfLRQE5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 11:04:57 -0500
Received: from tarshish (unknown [10.0.8.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 473DF44028D;
        Wed, 18 Dec 2019 18:04:55 +0200 (IST)
References: <20191211131111.GK16369@lunn.ch> <87fthqu6y6.fsf@tarshish> <20191211174938.GB30053@lunn.ch> <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il> <20191212131448.GA9959@lunn.ch> <20191212150810.zx6o26jnk5croh4r@sapphire.tkos.co.il> <20191212151355.GE30053@lunn.ch> <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il> <20191212193611.63111051@nic.cz> <20191212190640.6vki2pjfacdnxihh@sapphire.tkos.co.il> <20191212193129.GF30053@lunn.ch> <20191212204141.16a406cd@nic.cz> <8736dlucai.fsf@tarshish> <20191218153035.11c3486d@dellmb>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Marek =?utf-8?Q?Beh=C3=BAn?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
In-reply-to: <20191218153035.11c3486d@dellmb>
Date:   Wed, 18 Dec 2019 18:04:54 +0200
Message-ID: <87bls5sjq1.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Wed, Dec 18 2019, Marek Behún wrote:
> On Sun, 15 Dec 2019 12:13:25 +0200
> Baruch Siach <baruch@tkos.co.il> wrote:
>
>> Thanks. That is enough to fix the phylink issue triggered by commit
>> 7fb5a711545 ("net: dsa: mv88e6xxx: drop adjust_link to enabled
>> phylink").
>> 
>> The Clearfog GT-8K DT has also this on the cpu side:
>> 
>> &cp1_eth2 {
>>         status = "okay";
>>         phy-mode = "2500base-x";
>>         phys = <&cp1_comphy5 2>;
>>         fixed-link {
>>                 speed = <2500>;
>>                 full-duplex;
>>         };
>> };
>> 
>> Should I drop fixed-link here as well?
>
> I would think yes. phy-mode = 2500base-x should already force 2500mbps,
> the fixed-link should be irrelevant. Whether this is truly the case I
> do not know, but on Turris Mox I do not use fixed-link with these.

OK. I'll test that.

>> The call to mv88e6341_port_set_cmode() introduced in commit
>> 7a3007d22e8 ("net: dsa: mv88e6xxx: fully support SERDES on Topaz
>> family") still breaks port 5 (cpu) configuration. When called, its
>> mode parameter is set to PHY_INTERFACE_MODE_2500BASEX (19).
>> 
>> Any idea?
>
> I shall look into this. On Turris Mox this works, so I will have to do
> some experiments.

I have made some progress on this issue. See my other messages on this
thread. My latest suggestion is here:

  https://lore.kernel.org/netdev/20191217182643.augknhx57pafnelv@sapphire.tkos.co.il/

I now think that the force_cmode field is not necessary. We should just
add a 'force' parameter to mv88e6xxx_port_set_cmode(), and set it true
in mv88e6341_port_set_cmode().

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
