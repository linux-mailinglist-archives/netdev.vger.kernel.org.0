Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F378868765E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 08:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbjBBH2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 02:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjBBH2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 02:28:41 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB8067783;
        Wed,  1 Feb 2023 23:28:39 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id D7B7F1883955;
        Thu,  2 Feb 2023 07:28:36 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id C6C2C250007B;
        Thu,  2 Feb 2023 07:28:36 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id A3BBE9B403E3; Thu,  2 Feb 2023 07:28:36 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 02 Feb 2023 08:28:36 +0100
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@idosch.org>
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
Subject: Re: [PATCH net-next 1/5] net: bridge: add dynamic flag to switchdev
 notifier
In-Reply-To: <Y9qrAup9Xt/ZDEG0@shredder>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-2-netdev@kapio-technology.com>
 <Y9qrAup9Xt/ZDEG0@shredder>
User-Agent: Gigahost Webmail
Message-ID: <f27dd18d9d0b7ff8b693af8a58ea8616@kapio-technology.com>
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

On 2023-02-01 19:10, Ido Schimmel wrote:
> On Mon, Jan 30, 2023 at 06:34:25PM +0100, Hans J. Schultz wrote:
>> To be able to add dynamic FDB entries to drivers from userspace, the
>> dynamic flag must be added when sending RTM_NEWNEIGH events down.
>> 
>> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
>> ---
>>  include/net/switchdev.h   | 1 +
>>  net/bridge/br_switchdev.c | 2 ++
>>  2 files changed, 3 insertions(+)
>> 
>> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
>> index ca0312b78294..aaf918d4ba67 100644
>> --- a/include/net/switchdev.h
>> +++ b/include/net/switchdev.h
>> @@ -249,6 +249,7 @@ struct switchdev_notifier_fdb_info {
>>  	u8 added_by_user:1,
>>  	   is_local:1,
>>  	   locked:1,
>> +	   is_dyn:1,
>>  	   offloaded:1;
>>  };
>> 
>> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
>> index 7eb6fd5bb917..4420fcbbfdb2 100644
>> --- a/net/bridge/br_switchdev.c
>> +++ b/net/bridge/br_switchdev.c
>> @@ -136,6 +136,8 @@ static void br_switchdev_fdb_populate(struct 
>> net_bridge *br,
>>  	item->added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
>>  	item->offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
>>  	item->is_local = test_bit(BR_FDB_LOCAL, &fdb->flags);
>> +	item->is_dyn = !test_bit(BR_FDB_STATIC, &fdb->flags) &&
> 
> Why not 'is_static' and be consistent with the bridge flag like all the
> other fields?
> 
> Regardless of how you name this field, it is irrelevant for
> 'SWITCHDEV_FDB_ADD_TO_BRIDGE' notifications that all add FDB entries
> with the 'BR_FDB_ADDED_BY_EXT_LEARN' flag set, which makes
> 'BR_FDB_STATIC' irrelevant.
> 
>> +		item->added_by_user;
> 
> Unclear why this is needed...
> 

The answer to those two questions lies in my earlier correspondences 
(with Oltean) on the RFC version.
