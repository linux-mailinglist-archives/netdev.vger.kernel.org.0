Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B4611F847
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 16:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfLOPIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 10:08:04 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:36512 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbfLOPIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 10:08:04 -0500
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id AA7E9440808;
        Sun, 15 Dec 2019 17:08:01 +0200 (IST)
References: <20191212131448.GA9959@lunn.ch> <20191212150810.zx6o26jnk5croh4r@sapphire.tkos.co.il> <20191212151355.GE30053@lunn.ch> <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il> <20191212193611.63111051@nic.cz> <20191212190640.6vki2pjfacdnxihh@sapphire.tkos.co.il> <20191212193129.GF30053@lunn.ch> <20191212204141.16a406cd@nic.cz> <8736dlucai.fsf@tarshish> <871rt5u9no.fsf@tarshish> <20191215145349.GB22725@lunn.ch>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek Behun <marek.behun@nic.cz>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
In-reply-to: <20191215145349.GB22725@lunn.ch>
Date:   Sun, 15 Dec 2019 17:08:01 +0200
Message-ID: <87y2vdsk32.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sun, Dec 15 2019, Andrew Lunn wrote:
>> This fixes cpu port configuration for me:
>>
>> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
>> index 7fe256c5739d..a6c320978bcf 100644
>> --- a/drivers/net/dsa/mv88e6xxx/port.c
>> +++ b/drivers/net/dsa/mv88e6xxx/port.c
>> @@ -427,10 +427,6 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>>  		cmode = 0;
>>  	}
>>
>> -	/* cmode doesn't change, nothing to do for us */
>> -	if (cmode == chip->ports[port].cmode)
>> -		return 0;
>> -
>>  	lane = mv88e6xxx_serdes_get_lane(chip, port);
>>  	if (lane) {
>>  		if (chip->ports[port].serdes_irq) {
>>
>> Does that make sense?
>
> This needs testing on a 6390, with a port 9 or 10 using fixed link. We
> have had issues in the past where mac_config() has been called once
> per second, and each time it reconfigured the MAC, causing the link to
> go down/up. So we try to avoid doing work which is not requires and
> which could upset the link.

You refer to ed8fe20205ac ("net: dsa: mv88e6xxx: prevent interrupt storm
caused by mv88e6390x_port_set_cmode") that introduced this code.

The alternative is to call ->port_get_cmode() to refresh the cmode cache
after mv88e6xxx_port_hidden_write().

What do you think?

Thanks,
baruch

--
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
