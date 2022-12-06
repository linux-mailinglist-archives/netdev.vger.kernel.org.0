Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45B6644978
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbiLFQiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235595AbiLFQhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:37:52 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BB6DDD;
        Tue,  6 Dec 2022 08:36:58 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 7E78F18839C4;
        Tue,  6 Dec 2022 16:36:47 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 6616525002E1;
        Tue,  6 Dec 2022 16:36:42 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 4EBC691201E4; Tue,  6 Dec 2022 16:36:42 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Tue, 06 Dec 2022 17:36:42 +0100
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <Y487T+pUl7QFeL60@shredder>
References: <20221205185908.217520-1-netdev@kapio-technology.com>
 <20221205185908.217520-4-netdev@kapio-technology.com>
 <Y487T+pUl7QFeL60@shredder>
User-Agent: Gigahost Webmail
Message-ID: <580f6bd5ee7df0c8f0c7623a5b213d8f@kapio-technology.com>
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

On 2022-12-06 13:53, Ido Schimmel wrote:
> On Mon, Dec 05, 2022 at 07:59:08PM +0100, Hans J. Schultz wrote:
>> This implementation for the Marvell mv88e6xxx chip series, is based on
>> handling ATU miss violations occurring when packets ingress on a port
>> that is locked with learning on. This will trigger a
>> SWITCHDEV_FDB_ADD_TO_BRIDGE event, which will result in the bridge 
>> module
>> adding a locked FDB entry. This bridge FDB entry will not age out as
>> it has the extern_learn flag set.
>> 
>> Userspace daemons can listen to these events and either accept or deny
>> access for the host, by either replacing the locked FDB entry with a
>> simple entry or leave the locked entry.
>> 
>> If the host MAC address is already present on another port, a ATU
>> member violation will occur, but to no real effect.
> 
> And the packet will be dropped in hardware, right?

Every packet that enters a locked port and does not have a matching ATU 
entry on the port will be dropped (in HW) afaik.

>> ---
> 
> The changelog from previous versions is missing.
> 

I am afraid because I made a mistake with the version string last, this 
should be regarded as a first. Therefore no changelog.

>>  	err = mv88e6xxx_g1_atu_mac_read(chip, &entry);
>>  	if (err)
>> -		goto out;
>> +		goto out_unlock;
>> +
>> +	mv88e6xxx_reg_unlock(chip);
> 
> I was under the impression that we agreed that the locking change will
> be split to a separate patch.
> 

Sorry, I guess that because of the quite long time that has passed as I 
needed to get this FID=0 issue sorted out, and had many other different 
changes to attend, I forgot. I see an updated version is needed anyhow, 
so I will do it there.

>> 
>>  	spid = entry.state;
