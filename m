Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD6E606865
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiJTSrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiJTSrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:47:45 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCDD20B110;
        Thu, 20 Oct 2022 11:47:41 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 56E301884CB9;
        Thu, 20 Oct 2022 18:47:39 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 4421F25001FA;
        Thu, 20 Oct 2022 18:47:39 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 38C139EC0005; Thu, 20 Oct 2022 18:47:39 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 20 Oct 2022 20:47:39 +0200
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
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
Subject: Re: [PATCH v8 net-next 05/12] net: dsa: propagate the locked flag
 down through the DSA layer
In-Reply-To: <20221020133506.76wroc7owpwjzrkg@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221020130224.6ralzvteoxfdwseb@skbuf> <Y1FMAI9BzDRUPi5Y@shredder>
 <20221020133506.76wroc7owpwjzrkg@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <8456155b8e0f6327e4fb595c7a08399b@kapio-technology.com>
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

On 2022-10-20 15:35, Vladimir Oltean wrote:
> On Thu, Oct 20, 2022 at 04:24:16PM +0300, Ido Schimmel wrote:
>> On Thu, Oct 20, 2022 at 04:02:24PM +0300, Vladimir Oltean wrote:
>> > On Tue, Oct 18, 2022 at 06:56:12PM +0200, Hans J. Schultz wrote:
>> > > @@ -3315,6 +3316,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
>> > >  	struct dsa_port *dp = dsa_slave_to_port(dev);
>> > >  	bool host_addr = fdb_info->is_local;
>> > >  	struct dsa_switch *ds = dp->ds;
>> > > +	u16 fdb_flags = 0;
>> > >
>> > >  	if (ctx && ctx != dp)
>> > >  		return 0;
>> > > @@ -3361,6 +3363,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
>> > >  		   orig_dev->name, fdb_info->addr, fdb_info->vid,
>> > >  		   host_addr ? " as host address" : "");
>> > >
>> > > +	if (fdb_info->locked)
>> > > +		fdb_flags |= DSA_FDB_FLAG_LOCKED;
>> >
>> > This is the bridge->driver direction. In which of the changes up until
>> > now/through which mechanism will the bridge emit a
>> > SWITCHDEV_FDB_ADD_TO_DEVICE with fdb_info->locked = true?
>> 
>> I believe it can happen in the following call chain:
>> 
>> br_handle_frame_finish
>>    br_fdb_update // p->flags & BR_PORT_MAB
>>        fdb_notify
>>            br_switchdev_fdb_notify
>> 
>> This can happen with Spectrum when a packet ingresses via a locked 
>> port
>> and incurs an FDB miss in hardware. The packet will be trapped and
>> injected to the Rx path where it should invoke the above call chain.
> 
> Ah, so this is the case which in mv88e6xxx would generate an ATU
> violation interrupt; in the Spectrum case it generates a special 
> packet.
> Right now this packet isn't generated, right?
> 
> I think we have the same thing in ocelot, a port can be configured to
> send "learn frames" to the CPU.
> 
> Should these packets be injected into the bridge RX path in the first
> place? They reach the CPU because of an FDB miss, not because the CPU
> was the intended destination.

Just to add to it, now that there is a u16 for flags in the 
bridge->driver
direction, making it easier to add such flags, I expect that for the
mv88e6xxx driver there shall be a 'IS_DYNAMIC' flag also, as authorized
hosts will have their authorized FDB entries added with dynamic 
entries...

Now as the bridge will not be able to refresh such authorized FDB 
entries
based on unicast incoming traffic on the locked port in the offloaded 
case,
besides we don't want the CPU to do such in this case anyway, to keep 
the
authorized line alive without having to reauthorize in like every 5 
minutes,
the driver needs to do the ageing (and refreshing) of the dynamic entry
added from userspace. When the entry "ages" out, there is the HoldAt1
feature and Age Out Violations that should be used to tell userspace
(plus bridge) that this authorization has been removed by the driver as
the host has gone quiet.

So all in all, there is the need of another flag from
userspace->bridge->driver, telling that we want a dynamic ATU entry 
(with
mv88e6xxx it will start at age 7).
