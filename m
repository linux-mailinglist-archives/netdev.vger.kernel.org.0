Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23F45F8502
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 13:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiJHLeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 07:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJHLeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 07:34:23 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D9247B99;
        Sat,  8 Oct 2022 04:34:19 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 1067E1884502;
        Sat,  8 Oct 2022 11:34:17 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 062492503DE3;
        Sat,  8 Oct 2022 11:34:17 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id F11D99120FED; Sat,  8 Oct 2022 11:34:16 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sat, 08 Oct 2022 13:34:16 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 net-next 9/9] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
In-Reply-To: <YzrmaixRZ3k/alPh@shredder>
References: <20220928150256.115248-1-netdev@kapio-technology.com>
 <20220928150256.115248-10-netdev@kapio-technology.com>
 <YzrmaixRZ3k/alPh@shredder>
User-Agent: Gigahost Webmail
Message-ID: <c25d21e4f3a8d825a4ceb3069b05c6d9@kapio-technology.com>
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

On 2022-10-03 15:40, Ido Schimmel wrote:
>> +locked_port_station_move()
>> +{
>> +	local mac=a0:b0:c0:c0:b0:a0
>> +
>> +	RET=0
>> +	check_locked_port_support || return 0
>> +
>> +	bridge link set dev $swp1 locked on
> 
> It is quite pointless to check that an entry cannot roam to a port that
> has learning disabled... Need:
> 
> bridge link set dev $swp1 locked on learning on
> 
>> +
>> +	$MZ $h1 -q -t udp -a $mac -b rand
>> +	bridge fdb show dev $swp1 | grep "$mac vlan 1" | grep -q "master 
>> br0"
> 
> bridge fdb get ...
> 
> Same in other places
> 

It seems that the output of 'bridge fdb get' does not respect the dev it 
is given as input and outputs the (MAC,vlan) when found on another 
dev...
