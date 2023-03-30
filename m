Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01306D0E5F
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 21:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjC3TKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 15:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjC3TKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 15:10:48 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C291C174;
        Thu, 30 Mar 2023 12:10:45 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id B3439188368C;
        Thu, 30 Mar 2023 19:10:33 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id ABED62500389;
        Thu, 30 Mar 2023 19:10:33 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id A2E849B403F4; Thu, 30 Mar 2023 19:10:33 +0000 (UTC)
X-Screener-Id: e32ae469fa6e394734d05373d3a705875723cf1e
Received: from fujitsu (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id EB58791201E3;
        Thu, 30 Mar 2023 19:10:32 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     Ido Schimmel <idosch@nvidia.com>
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
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?Q?Cl=C3=A9ment_L=C3=A9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 6/6] selftests: forwarding: add dynamic FDB
 test
In-Reply-To: <ZCMYbRqd+qZaiHfu@shredder>
References: <20230318141010.513424-1-netdev@kapio-technology.com>
 <20230318141010.513424-7-netdev@kapio-technology.com>
 <ZBgdAo8mxwnl+pEE@shredder> <87a5zzh65p.fsf@kapio-technology.com>
 <ZCMYbRqd+qZaiHfu@shredder>
Date:   Thu, 30 Mar 2023 21:07:53 +0200
Message-ID: <874jq22h2u.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.7 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 19:40, Ido Schimmel <idosch@nvidia.com> wrote:
> On Sun, Mar 26, 2023 at 05:41:06PM +0200, Hans Schultz wrote:
>> On Mon, Mar 20, 2023 at 10:44, Ido Schimmel <idosch@nvidia.com> wrote:
>> >> +	$MZ $swp1 -c 1 -p 128 -t udp "sp=54321,dp=12345" \
>> >> +		-a $mac -b `mac_get $h2` -A 192.0.2.1 -B 192.0.2.2 -q
>> >> +	tc_check_packets "dev $swp2 egress" 1 1
>> >> +	check_fail $? "Dynamic FDB entry did not age out"
>> >
>> > Shouldn't this be check_err()? After the FDB entry was aged you want to
>> > make sure that packets received via $swp1 with SMAC being $mac are no
>> > longer forwarded by the bridge.
>> 
>> I was thinking that check_fail() will pass when tc_check_packets() does
>> not see any packets, thus the test passing here when no packets are forwarded?
>
> What do you mean by "I was *thinking*"? How is it possible that you are
> submitting a selftest that you didn't bother running?!
>
> I see you trimmed my earlier question: "Does this actually work?"
>
> I tried it and it passed:
>
> # ./bridge_locked_port.sh                         
> TEST: Locked port ipv4                                              [ OK ]
> TEST: Locked port ipv6                                              [ OK ]
> TEST: Locked port vlan                                              [ OK ]            
> TEST: Locked port MAB                                               [ OK ]            
> TEST: Locked port MAB roam                                          [ OK ]
> TEST: Locked port MAB configuration                                 [ OK ]
> TEST: Locked port MAB FDB flush                                     [ OK ]
>
> And I couldn't understand how that's even possible. Then I realized that
> the entire test is dead code because the patch is missing this
> fundamental hunk:
>
> ```
> diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> index dbc7017fd45d..5bf6b2aa1098 100755
> --- a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> +++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> @@ -9,6 +9,7 @@ ALL_TESTS="
>         locked_port_mab_roam
>         locked_port_mab_config
>         locked_port_mab_flush
> +       locked_port_dyn_fdb
>  "
>  
>  NUM_NETIFS=4
> ```
>
> Which tells me that you didn't even try running it once.

Not true, it reveals that I forgot to put it in the patch, that's all. As
I cannot run several of these tests because of memory constraints I link
the file to a copy in a rw area where I modify the list and just run one
of the subtests at a time. If I try to run the whole it always fails
after a couple of sub-tests with an error.

It seems to me that these scripts are quite memory consuming as they
accumulate memory consuption in relation to what is loaded along the
way. A major problem with my system.
