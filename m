Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4A9672B5F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 23:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjARWfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 17:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjARWfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 17:35:13 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11D15CFC8;
        Wed, 18 Jan 2023 14:35:10 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 3957518839F7;
        Wed, 18 Jan 2023 22:35:09 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id D5A7B25003AB;
        Wed, 18 Jan 2023 22:35:08 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id BD31391201E4; Wed, 18 Jan 2023 22:35:08 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Wed, 18 Jan 2023 23:35:08 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
        =?UTF-8?Q?Cl=C3=A9ment_L=C3=A9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
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
Subject: Re: [RFC PATCH net-next 2/5] net: dsa: propagate flags down towards
 drivers
In-Reply-To: <20230117231750.r5jr4hwvpadgopmf@skbuf>
References: <20230117185714.3058453-1-netdev@kapio-technology.com>
 <20230117185714.3058453-3-netdev@kapio-technology.com>
 <20230117231750.r5jr4hwvpadgopmf@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <e4acb7edb300d41a9459890133b928b4@kapio-technology.com>
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

On 2023-01-18 00:17, Vladimir Oltean wrote:
> On Tue, Jan 17, 2023 at 07:57:11PM +0100, Hans J. Schultz wrote:
>> Dynamic FDB flag needs to be propagated through the DSA layer to be
>> added to drivers.
>> Use a u16 for fdb flags for future use, so that other flags can also 
>> be
>> sent the same way without having to change function interfaces.
>> 
>> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
>> ---
>> @@ -3364,6 +3368,7 @@ static int dsa_slave_fdb_event(struct net_device 
>> *dev,
>>  	struct dsa_port *dp = dsa_slave_to_port(dev);
>>  	bool host_addr = fdb_info->is_local;
>>  	struct dsa_switch *ds = dp->ds;
>> +	u16 fdb_flags = 0;
>> 
>>  	if (ctx && ctx != dp)
>>  		return 0;
>> @@ -3410,6 +3415,9 @@ static int dsa_slave_fdb_event(struct net_device 
>> *dev,
>>  		   orig_dev->name, fdb_info->addr, fdb_info->vid,
>>  		   host_addr ? " as host address" : "");
>> 
>> +	if (fdb_info->is_dyn)
>> +		fdb_flags |= DSA_FDB_FLAG_DYNAMIC;
>> +
> 
> Hmm, I don't think this is going to work with the 
> assisted_learning_on_cpu_port
> feature ("if (switchdev_fdb_is_dynamically_learned(fdb_info))"). The
> reason being
> that a "dynamically learned" FDB entry (defined as this):
> 
> static inline bool
> switchdev_fdb_is_dynamically_learned(const struct
> switchdev_notifier_fdb_info *fdb_info)
> {
> 	return !fdb_info->added_by_user && !fdb_info->is_local;
> }
> 
> is also dynamic in the DSA_FDB_FLAG_DYNAMIC sense. But we install a
> static FDB entry for it on the CPU port.
> 
> And in your follow-up patch 3/5, you make all drivers except mv88e6xxx
> ignore all DSA_FDB_FLAG_DYNAMIC entries (including the ones snooped 
> from
> address learning on software interfaces). So this breaks those drivers
> which don't implement DSA_FDB_FLAG_DYNAMIC but do set
> ds->assisted_learning_on_cpu_port
> to true.

I am not sure I understand you entirely.
 From my standpoint I see it as so: that until now any fdb entry coming 
to port_fdb_add() (or port_fdb_del()) are seen as static entries. And 
this changes nothing with respect to those static entries as how drivers 
handle them.
When the new dynamic flag is true, all drivers will ignore it in patch 
#3, so basically nothing will change by that. Then in patch #5 the 
dynamic flag is handled by the mv88e6xxx driver.

I don't know the assisted_learning_on_cpu_port feature you mention, but 
there has still not been anything but static entries going towards 
port_fdb_add() yet...

> 
> I think you also want to look at the added_by_user flag to disambiguate
> between a dynamic FDB entry added from learning (which it's ok to
> offload as static, because software ageing will remove it) and one 
> added
> by the user.
> 
>>  	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
>>  	switchdev_work->event = event;
>>  	switchdev_work->dev = dev;
>> @@ -3418,6 +3426,7 @@ static int dsa_slave_fdb_event(struct net_device 
>> *dev,
>>  	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
>>  	switchdev_work->vid = fdb_info->vid;
>>  	switchdev_work->host_addr = host_addr;
>> +	switchdev_work->fdb_flags = fdb_flags;
>> 
>>  	dsa_schedule_work(&switchdev_work->work);
>> 
