Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497325A0DE0
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 12:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240103AbiHYK1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 06:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235442AbiHYK1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 06:27:08 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984BA9BB62;
        Thu, 25 Aug 2022 03:27:03 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 4C64118849A5;
        Thu, 25 Aug 2022 10:27:01 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 35EB525032B7;
        Thu, 25 Aug 2022 10:27:01 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 2BD179EC0003; Thu, 25 Aug 2022 10:27:01 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 25 Aug 2022 12:27:01 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
In-Reply-To: <Ywc/qTNqVbS4E7zS@shredder>
References: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
 <YvkM7UJ0SX+jkts2@shredder>
 <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
 <YwHZ1J9DZW00aJDU@shredder>
 <7016ed2ce9a30537e4278e37878900d8@kapio-technology.com>
 <Ywc/qTNqVbS4E7zS@shredder>
User-Agent: Gigahost Webmail
Message-ID: <7dfe15571370dfb5348a3d0e5478f62c@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-25 11:23, Ido Schimmel wrote:
>> 
>> 
>> Ido, I am not so known to the selftests, so I am wondering why I don't 
>> see
>> either check_err or check_fail fail, whichever I use, when I think 
>> they
>> should and then they are not really checking...
>> 
>> 
>>         local mac=10:20:30:30:20:10
>> 
>> 
>>         $MZ $h1 -t udp -a $mac -b rand
>>         bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0 
>> locked"
>>         check_err $? "MAB station move: no locked entry on first 
>> injection"
>> 
>>         $MZ $h2 -t udp -a $mac -b rand
>>         bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0 
>> locked"
>>         check_err $? "MAB station move: locked entry did not move"
>> 
>> What is wrong here?
> 
> Did you try adding a sleep between mausezahn and the FDB dump? At least
> that is what learning_test() is doing. It is possible that the packet 
> is
> not sent / processed fast enough for the bridge to learn it before the
> dump.
> 

I missed the call to log_test at the end of the test.

>> 
>> For a mv88e6xxx test I guess I can make a check to verify that this 
>> driver
>> is in use?
> 
> Not in a generic forwarding test. Maybe in
> tools/testing/selftests/drivers/net/dsa/
> 
> My preference would be to get as much tests as possible in
> tools/testing/selftests/net/forwarding/bridge_locked_port.sh.

I now have a roaming test in 
tools/testing/selftests/net/forwarding/bridge_locked_port.sh, but it 
will not pass with mv88e6xxx as it is meant for the SW bridge.

I can check if the sticky flag is set on the locked entry and then skip 
the test if it is.

The bridge_locked_port.sh test is linked in 
tools/testing/selftests/drivers/net/dsa/, but if I cannot check if the 
mv88e6xxx driver or other switchcores are in use, I cannot do more.

> 
> I'm not sure which tests you are planning for mv88e6xxx, but we can 
> pass
> / fail test cases based on the flags we observe in the FDB dump. For
> example, if the entry has the "sticky" flag, then the expectation is
> that the roaming test will fail. Otherwise, it should pass.
