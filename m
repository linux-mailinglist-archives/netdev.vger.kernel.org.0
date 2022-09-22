Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D2C5E6D14
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiIVUfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiIVUfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:35:12 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3C22F67E;
        Thu, 22 Sep 2022 13:35:05 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 26825188497F;
        Thu, 22 Sep 2022 20:35:03 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 18FB6250007B;
        Thu, 22 Sep 2022 20:35:03 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id ECB6C9EC0002; Thu, 22 Sep 2022 20:35:02 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 22 Sep 2022 22:35:02 +0200
From:   netdev@kapio-technology.com
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
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
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 net-next 6/6] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
In-Reply-To: <Yyq6BnUfctLeerqE@shredder>
References: <YxNo/0+/Sbg9svid@shredder>
 <5cee059b65f6f7671e099150f9da79c1@kapio-technology.com>
 <Yxmgs7Du62V1zyjK@shredder>
 <8dfc9b525f084fa5ad55019f4418a35e@kapio-technology.com>
 <20220908112044.czjh3xkzb4r27ohq@skbuf>
 <152c0ceadefbd742331c340bec2f50c0@kapio-technology.com>
 <20220911001346.qno33l47i6nvgiwy@skbuf>
 <15ee472a68beca4a151118179da5e663@kapio-technology.com>
 <Yx73FOpN5uhPQhFl@shredder>
 <086704ce7f323cc1b3cca78670b42095@kapio-technology.com>
 <Yyq6BnUfctLeerqE@shredder>
User-Agent: Gigahost Webmail
Message-ID: <d559df70d75b3f5db2815f3038be3e3a@kapio-technology.com>
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

On 2022-09-21 09:15, Ido Schimmel wrote:
> On Tue, Sep 20, 2022 at 11:29:12PM +0200, netdev@kapio-technology.com 
> wrote:
>> I have made a blackhole selftest, which looks like this:
>> 
>> test_blackhole_fdb()
>> {
>>         RET=0
>> 
>>         check_blackhole_fdb_support || return 0
>> 
>>         tcpdump_start $h2
>>         $MZ $h1 -q -t udp -a $h1 -b $h2
> 
> I don't think you can give an interface name to '-a' and '-b'?
> 
>>         tcpdump_stop
>>         tcpdump_show | grep -q udp
>>         check_err $? "test_blackhole_fdb: No packet seen on initial"
>>         tcpdump_cleanup
>> 
>>         bridge fdb add `mac_get $h2` dev br0 blackhole
>>         bridge fdb show dev br0 | grep -q "blackhole"
> 
> Make this grep more specific so that we are sure it is the entry user
> space installed. Something like this:
> 
> bridge fdb get `mac_get $h2` br br0 | grep -q blackhole
> 
>>         check_err $? "test_blackhole_fdb: No blackhole FDB entry 
>> found"
>> 
>>         tcpdump_start $h2
>>         $MZ $h1 -q -t udp -a $h1 -b $h2
>>         tcpdump_stop
>>         tcpdump_show | grep -q udp
>>         check_fail $? "test_blackhole_fdb: packet seen with blackhole 
>> fdb
>> entry"
>>         tcpdump_cleanup
> 
> The tcpdump filter is not specific enough. It can catch other UDP
> packets (e.g., multicast) being received by $h2. Anyway, to be sure the
> feature works as expected we need to make sure that the packets are not
> even egressing $swp2. Checking that they are not received by $h2 is not
> enough. See this (untested) suggestion [1] that uses a tc filter on the
> egress of $swp2.
> 
>> 
>>         bridge fdb del `mac_get $h2` dev br0 blackhole
>>         bridge fdb show dev br0 | grep -q "blackhole"
>>         check_fail $? "test_blackhole_fdb: Blackhole FDB entry not 
>> deleted"
>> 
>>         tcpdump_start $h2
>>         $MZ $h1 -q -t udp -a $h1 -b $h2
>>         tcpdump_stop
>>         tcpdump_show | grep -q udp
>>         check_err $? "test_blackhole_fdb: No packet seen after 
>> removing
>> blackhole FDB entry"
>>         tcpdump_cleanup
>> 
>>         log_test "Blackhole FDB entry test"
>> }
>> 
>> the setup is simple and is the same as in bridge_sticky_fdb.sh.
>> 
>> Does the test look sound or is there obvious mistakes?
> 
> [1]
> blackhole_fdb()
> {
> 	RET=0
> 
> 	tc filter add dev $swp2 egress protocol ip pref 1 handle 1 flower \
> 		dst_ip 192.0.2.2 ip_proto udp dst_port 12345 action pass
> 
> 	$MZ $h1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
> 		-a own -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q
> 
> 	tc_check_packets "dev $swp2 egress" 1 1
> 	check_err $? "Packet not seen on egress before adding blackhole entry"
> 
> 	bridge fdb add `mac_get $h2` dev br0 blackhole
> 	bridge fdb get `mac_get $h2` br br0 | grep -q blackhole
> 	check_err $? "Blackhole entry not found"
> 
> 	$MZ $h1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
> 		-a own -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q
> 
> 	tc_check_packets "dev $swp2 egress" 1 1
> 	check_err $? "Packet seen on egress after adding blackhole entry"
> 
> 	# Check blackhole entries can be replaced.
> 	bridge fdb replace `mac_get $h2` dev $swp2 master static
> 	bridge fdb get `mac_get $h2` br br0 | grep -q blackhole
> 	check_fail $? "Blackhole entry found after replacement"
> 
> 	$MZ $h1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
> 		-a own -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q
> 
> 	tc_check_packets "dev $swp2 egress" 1 2
> 	check_err $? "Packet not seen on egress after replacing blackhole 
> entry"
> 
> 	bridge fdb del `mac_get $h2` dev $swp2 master static
> 	tc filter del dev $swp2 egress protocol ip pref 1 handle 1 flower
> 
> 	log_test "Blackhole FDB entry"
> }

Thx, looks good.
I have tried to run the test as far as I can manually, but I don't seem 
to have 'busywait' in the system, which tc_check_packets() depends on, 
and I couldn't find any 'busywait' in Buildroot.
