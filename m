Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0F95A02B8
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 22:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240361AbiHXU32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 16:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237076AbiHXU31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 16:29:27 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DCC6B17A;
        Wed, 24 Aug 2022 13:29:23 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id C7A9E188444D;
        Wed, 24 Aug 2022 20:29:20 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id BEA8025032B7;
        Wed, 24 Aug 2022 20:29:20 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id B7D589EC0004; Wed, 24 Aug 2022 20:29:20 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Wed, 24 Aug 2022 22:29:20 +0200
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
In-Reply-To: <YwHZ1J9DZW00aJDU@shredder>
References: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
 <YvkM7UJ0SX+jkts2@shredder>
 <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
 <YwHZ1J9DZW00aJDU@shredder>
User-Agent: Gigahost Webmail
Message-ID: <7016ed2ce9a30537e4278e37878900d8@kapio-technology.com>
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

On 2022-08-21 09:08, Ido Schimmel wrote:
> 
> I assume you want a hub to simulate multiple MACs behind the same port.
> You don't need a hub for that. You can set the MAC using mausezahn. See
> '-a' option:
> 
> "
>    -a <src-mac|keyword>
>        Use specified source MAC address with hexadecimal notation such
> as 00:00:aa:bb:cc:dd.  By default the interface MAC address will be
> used. The  keywords  ''rand''
>        and  ''own''  refer to a random MAC address (only unicast
> addresses are created) and the own address, respectively. You can also
> use the keywords mentioned below
>        although broadcast-type source addresses are officially invalid.
> "
> 


Ido, I am not so known to the selftests, so I am wondering why I don't 
see either check_err or check_fail fail, whichever I use, when I think 
they should and then they are not really checking...


         local mac=10:20:30:30:20:10


         $MZ $h1 -t udp -a $mac -b rand
         bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0 
locked"
         check_err $? "MAB station move: no locked entry on first 
injection"

         $MZ $h2 -t udp -a $mac -b rand
         bridge fdb show dev $swp1 | grep -q "$mac vlan 1 master br0 
locked"
         check_err $? "MAB station move: locked entry did not move"

What is wrong here?

For a mv88e6xxx test I guess I can make a check to verify that this 
driver is in use?
