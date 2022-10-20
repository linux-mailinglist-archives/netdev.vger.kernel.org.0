Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859F5606942
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 21:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiJTT7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 15:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiJTT7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 15:59:06 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD23213441;
        Thu, 20 Oct 2022 12:59:04 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 896781884703;
        Thu, 20 Oct 2022 19:59:03 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 6B69E25001FA;
        Thu, 20 Oct 2022 19:59:03 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 62A2E9EC0002; Thu, 20 Oct 2022 19:59:03 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 20 Oct 2022 21:59:03 +0200
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 10/12] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20221020132538.reirrskemcjwih2m@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221020132538.reirrskemcjwih2m@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <77c2b6507fd267cefdaf74e53c2bd325@kapio-technology.com>
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

On 2022-10-20 15:25, Vladimir Oltean wrote:
>> +
>> +#include <net/switchdev.h>
>> +#include <linux/list.h>
>> +#include "chip.h"
>> +#include "global1.h"
>> +#include "switchdev.h"
>> +
>> +static void mv88e6xxx_atu_locked_entry_purge(struct 
>> mv88e6xxx_atu_locked_entry *ale,
>> +					     bool notify, bool take_nl_lock)
>> +{
>> +	struct switchdev_notifier_fdb_info info = {
>> +		.addr = ale->mac,
>> +		.vid = ale->vid,
>> +		.locked = true,
>> +		.offloaded = true,
>> +	};
>> +	struct mv88e6xxx_atu_entry entry;
>> +	struct net_device *brport;
>> +	struct dsa_port *dp;
>> +
>> +	entry.portvec = MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_NO_EGRESS;
>> +	entry.state = MV88E6XXX_G1_ATU_DATA_STATE_UC_UNUSED;
>> +	entry.trunk = false;
>> +	ether_addr_copy(entry.mac, ale->mac);
>> +
>> +	mv88e6xxx_reg_lock(ale->chip);
>> +	mv88e6xxx_g1_atu_loadpurge(ale->chip, ale->fid, &entry);
>> +	mv88e6xxx_reg_unlock(ale->chip);
>> +
>> +	dp = dsa_to_port(ale->chip->ds, ale->port);
>> +
>> +	if (notify) {
>> +		if (take_nl_lock)
>> +			rtnl_lock();
> 
> Is this tested with lockdep? I see the function is called with other
> locks held (p->ale_list_lock). Isn't there a lock inversion anywhere?
> Locks always need to be taken in the same order, and rtnl_lock is a
> pretty high level lock, not exactly the kind you could take just like
> that.
> 

I am very sure that there is no lock inversions or double locks taken.
It is only in the clean-up from time-out of driver locked entries that
the nl lock needs to be taken (as the code reveals). In all other
instances, the nl lock is already taken as far as this implementation 
goes.
