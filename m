Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1AF6884FF
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbjBBRAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbjBBRAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:00:03 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CA5E3B2;
        Thu,  2 Feb 2023 09:00:02 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id B73B0188374A;
        Thu,  2 Feb 2023 17:00:00 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id AA3FC250007B;
        Thu,  2 Feb 2023 17:00:00 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id A43119B403E1; Thu,  2 Feb 2023 17:00:00 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 02 Feb 2023 18:00:00 +0100
From:   netdev@kapio-technology.com
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?Q?Cl=C3=A9m?= =?UTF-8?Q?ent_L=C3=A9ger?= 
        <clement.leger@bootlin.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 5/5] net: dsa: mv88e6xxx: implementation of
 dynamic ATU entries
In-Reply-To: <Y9lkXlyXg1d1D0j3@corigine.com>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-6-netdev@kapio-technology.com>
 <Y9lkXlyXg1d1D0j3@corigine.com>
User-Agent: Gigahost Webmail
Message-ID: <9b12275969a204739ccfab972d90f20f@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-01-31 19:56, Simon Horman wrote:
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -42,6 +42,7 @@
>>  #include "ptp.h"
>>  #include "serdes.h"
>>  #include "smi.h"
>> +#include "switchdev.h"
>> 
>>  static void assert_reg_lock(struct mv88e6xxx_chip *chip)
>>  {
>> @@ -2726,18 +2727,25 @@ static int mv88e6xxx_port_fdb_add(struct 
>> dsa_switch *ds, int port,
>>  				  const unsigned char *addr, u16 vid,
>>  				  u16 fdb_flags, struct dsa_db db)
>>  {
>> +	bool is_dynamic = !!(fdb_flags & DSA_FDB_FLAG_DYNAMIC);
>>  	struct mv88e6xxx_chip *chip = ds->priv;
>> +	u8 state;
>>  	int err;
>> 
>> -	/* Ignore entries with flags set */
>> -	if (fdb_flags)
>> -		return 0;
>> +	state = MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC;
>> +	if (is_dynamic)
>> +		state = MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_7_NEWEST;
> 
> What if flags other than DSA_FDB_FLAG_DYNAMIC are set (in future)?

They will have to be caught and handled here if there is support for it, 
e.g. something like...

else if (someflag)
         dosomething();

For now only one flag will actually be set and they are mutually 
exclusive, as they will not make sense together with the potential flags 
I know, but that can change at some time of course.

> 
>> +	else
>> +		if (fdb_flags)
> 
> nit: else if (fdb_flags)
> 
>> +			return 0;
>> 
> 
> ...
