Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55DAB5A3D71
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 14:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiH1MAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 08:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiH1MAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 08:00:34 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF4F18B31;
        Sun, 28 Aug 2022 05:00:31 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 829B718845C3;
        Sun, 28 Aug 2022 12:00:29 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 797F325032B7;
        Sun, 28 Aug 2022 12:00:29 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 6C87D9EC0008; Sun, 28 Aug 2022 12:00:29 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Sun, 28 Aug 2022 14:00:29 +0200
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
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 net-next 6/6] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
In-Reply-To: <YwpgvkojEdytzCAB@shredder>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
 <20220826114538.705433-7-netdev@kapio-technology.com>
 <YwpgvkojEdytzCAB@shredder>
User-Agent: Gigahost Webmail
Message-ID: <7654860e4d7d43c15d482c6caeb6a773@kapio-technology.com>
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

On 2022-08-27 20:21, Ido Schimmel wrote:
> On Fri, Aug 26, 2022 at 01:45:38PM +0200, Hans Schultz wrote:
>> +locked_port_mab()
>> +{
>> +	RET=0
>> +	check_locked_port_support || return 0
>> +
>> +	ping_do $h1 192.0.2.2
>> +	check_err $? "MAB: Ping did not work before locking port"
>> +
>> +	bridge link set dev $swp1 locked on
>> +	bridge link set dev $swp1 learning on
> 
> "locked on learning on" is counter intuitive and IMO very much a
> misconfiguration that we should have disallowed when the "locked" 
> option
> was introduced. It is my understanding that the only reason we are even
> talking about it is because mv88e6xxx needs it for MAB for some reason.

As the way mv88e6xxx implements "learning off" is to remove port 
association for ingress packets on a port, but that breaks many other 
things such as refreshing ATU entries and violation interrupts, so it is 
needed and the question is then what is the worst to have 'learning on' 
on a locked port or to have the locked port enabling learning in the 
driver silently?

Opinions seem to differ. Note that even on locked ports without MAB, 
port association on ingress is still needed in future as I have a 
dynamic ATU patch set coming, that uses age out violation and hardware 
refreshing to let the hardware keep the dynamic entries as long as the 
authorized station is sending, but will age the entry out if the station 
keeps silent for the ageing time. But that patch set is dependent on 
this patch set, and I don't think I can send it before this is 
accepted...

> Please avoid leaking this implementation detail to user space and
> instead use the "MAB" flag to enable learning if you need it in
> mv88e6xxx.
> 
