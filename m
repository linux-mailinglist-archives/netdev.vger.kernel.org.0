Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6826968A21D
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 19:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbjBCSlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 13:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjBCSlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 13:41:23 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721071ADDD;
        Fri,  3 Feb 2023 10:41:21 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 8C21D1883921;
        Fri,  3 Feb 2023 18:41:18 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 78969250007B;
        Fri,  3 Feb 2023 18:41:18 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 5F8CC91201E4; Fri,  3 Feb 2023 18:41:18 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 03 Feb 2023 19:41:18 +0100
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
Subject: Re: [PATCH net-next 3/5] drivers: net: dsa: add fdb entry flags
 incoming to switchcore drivers
In-Reply-To: <Y9zDApc6nDO2RzOb@corigine.com>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-4-netdev@kapio-technology.com>
 <Y9lj7RJgyMJfjtGp@corigine.com>
 <0b021777dfc1825b6565c0d9dbd6dbef@kapio-technology.com>
 <Y9zDApc6nDO2RzOb@corigine.com>
User-Agent: Gigahost Webmail
Message-ID: <687a1918326d23ec901c1f53f5860592@kapio-technology.com>
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

On 2023-02-03 09:17, Simon Horman wrote:
> On Thu, Feb 02, 2023 at 05:45:56PM +0100, netdev@kapio-technology.com 
> wrote:
>> On 2023-01-31 19:54, Simon Horman wrote:
>> > > --- a/drivers/net/dsa/b53/b53_common.c
>> > > +++ b/drivers/net/dsa/b53/b53_common.c
>> > > @@ -1684,11 +1684,15 @@ static int b53_arl_op(struct b53_device
>> > > *dev, int op, int port,
>> > >
>> > >  int b53_fdb_add(struct dsa_switch *ds, int port,
>> > >  		const unsigned char *addr, u16 vid,
>> > > -		struct dsa_db db)
>> > > +		u16 fdb_flags, struct dsa_db db)
>> > >  {
>> > >  	struct b53_device *priv = ds->priv;
>> > >  	int ret;
>> > >
>> > > +	/* Ignore entries with set flags */
>> > > +	if (fdb_flags)
>> > > +		return 0;
>> >
>> >
>> > 	Would returning -EOPNOTSUPP be more appropriate?
>> >
>> > ...
>> 
>> I don't think that would be so good, as the command
>> 
>> bridge fdb replace ADDR dev <DEV> master dynamic
>> 
>> is a valid command and should not generate errors. When ignored by the
>> driver, it will just install a dynamic FDB entry in the bridge, and 
>> the
>> bridge will age it.
> 
> Sure, I agree that it's not necessarily an error that needs
> to propagate to the user.
> 
> My assumption, which I now see is likely false, is that drivers
> could return -EOPNOTSUPP, to indicate to higher layers that the 
> operation
> is not supported. But the higher layers may not propagate that.
> 
> But it seems that is not the case here. So I think return 0 is fine
> after all. Sorry for the noise.

No noise at all... I think your concern is quite ligitimate. With this 
flag there is no iproute2 changes, so not to change behaviour of old 
commands the best is to ignore silently. But I have another flag coming 
up that will be accomodated with a new iproute2 command, and then your 
suggestion is more appropriate. The question will then be if the returns 
for that flag should be -EOPNOTSUPP.
