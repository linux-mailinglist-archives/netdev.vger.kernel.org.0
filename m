Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25ECC602E76
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbiJRO3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiJRO3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:29:13 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C286C58B6;
        Tue, 18 Oct 2022 07:29:08 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 8DDEA18839FE;
        Tue, 18 Oct 2022 14:29:05 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 77D5B25001FA;
        Tue, 18 Oct 2022 14:29:05 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 487C69EC0005; Tue, 18 Oct 2022 14:29:05 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Tue, 18 Oct 2022 16:29:05 +0200
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
Subject: Re: [PATCH v7 net-next 3/9] net: switchdev: add support for
 offloading of the FDB locked flag
In-Reply-To: <Y0gbVoeV/e6wzlbM@shredder>
References: <20221009174052.1927483-1-netdev@kapio-technology.com>
 <20221009174052.1927483-4-netdev@kapio-technology.com>
 <Y0gbVoeV/e6wzlbM@shredder>
User-Agent: Gigahost Webmail
Message-ID: <3246a8d773146f0cbe39dd8ec182efaf@kapio-technology.com>
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

On 2022-10-13 16:06, Ido Schimmel wrote:
> On Sun, Oct 09, 2022 at 07:40:46PM +0200, Hans J. Schultz wrote:
>> Add support for offloading of the MAB/MacAuth feature flag and the FDB
>> locked flag which is used by the Mac-Auth/MAB feature.
>> 
>> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
>> ---
>>  include/net/dsa.h         |  2 ++
>>  include/net/switchdev.h   |  1 +
>>  net/bridge/br.c           |  4 ++--
>>  net/bridge/br_fdb.c       | 12 ++++++++++--
>>  net/bridge/br_private.h   |  2 +-
>>  net/bridge/br_switchdev.c |  3 ++-
>>  net/dsa/dsa_priv.h        |  6 ++++--
>>  net/dsa/port.c            | 10 ++++++----
>>  net/dsa/slave.c           | 10 ++++++++--
>>  net/dsa/switch.c          | 16 ++++++++--------
>>  10 files changed, 44 insertions(+), 22 deletions(-)
> 
> There is more than one logical change here. I suggest splitting it to
> make review easier:
> 
> 1. A patch allowing the bridge driver to install locked entries 
> notified
> from device drivers. These changes:
> 
> include/net/switchdev.h   |  1 +
> net/bridge/br.c           |  4 ++--
> net/bridge/br_fdb.c       | 12 ++++++++++--
> net/bridge/br_private.h   |  2 +-
> 
> And the br_switchdev_fdb_populate() hunk
> 
> 2. A patch allowing DSA core to report locked entries to the bridge
> driver

2. This requires no code in the DSA layer as the bridge listens directly 
to the
kernel switchdev notifications.

> 
> 3. A patch adding the new MAB flag to BR_PORT_FLAGS_HW_OFFLOAD
> 
> 4. A patch allowing DSA core to propagate the MAB flag to device 
> drivers
> 
> [...]
> 
>> diff --git a/net/dsa/port.c b/net/dsa/port.c
>> index e4a0513816bb..eab32b7a945a 100644
>> --- a/net/dsa/port.c
>> +++ b/net/dsa/port.c
>> @@ -304,7 +304,7 @@ static int dsa_port_inherit_brport_flags(struct 
>> dsa_port *dp,
>>  					 struct netlink_ext_ack *extack)
>>  {
>>  	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
>> -				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
>> +				   BR_BCAST_FLOOD;
> 
> Not sure how this is related to the patchset.
> 
>>  	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
>>  	int flag, err;
