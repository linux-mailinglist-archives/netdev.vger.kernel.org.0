Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E5C602D52
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 15:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiJRNrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 09:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiJRNrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 09:47:32 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9982CBEFBF;
        Tue, 18 Oct 2022 06:47:30 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 13EBB18848B0;
        Tue, 18 Oct 2022 13:47:28 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id F349E25001FA;
        Tue, 18 Oct 2022 13:47:27 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id E7C529EC0009; Tue, 18 Oct 2022 13:47:27 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Tue, 18 Oct 2022 15:47:27 +0200
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
In-Reply-To: <Y05GQWYu0vM+bx5t@shredder>
References: <20221009174052.1927483-1-netdev@kapio-technology.com>
 <20221009174052.1927483-4-netdev@kapio-technology.com>
 <Y0gbVoeV/e6wzlbM@shredder>
 <d314ba738b12e28694a955de1301e906@kapio-technology.com>
 <Y05GQWYu0vM+bx5t@shredder>
User-Agent: Gigahost Webmail
Message-ID: <cd69c33669957099096d84c0ae401108@kapio-technology.com>
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

On 2022-10-18 08:22, Ido Schimmel wrote:
> On Thu, Oct 13, 2022 at 08:58:57PM +0200, netdev@kapio-technology.com 
> wrote:
>> On 2022-10-13 16:06, Ido Schimmel wrote:
>> > > diff --git a/net/dsa/port.c b/net/dsa/port.c
>> > > index e4a0513816bb..eab32b7a945a 100644
>> > > --- a/net/dsa/port.c
>> > > +++ b/net/dsa/port.c
>> > > @@ -304,7 +304,7 @@ static int dsa_port_inherit_brport_flags(struct
>> > > dsa_port *dp,
>> > >  					 struct netlink_ext_ack *extack)
>> > >  {
>> > >  	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
>> > > -				   BR_BCAST_FLOOD | BR_PORT_LOCKED;
>> > > +				   BR_BCAST_FLOOD;
>> >
>> > Not sure how this is related to the patchset.
>> >
>> 
>> In general it is needed as a fix because of the way learning with 
>> locked
>> port is handled in the driver,
>> so as with MAB and also locked port in the future needing a non-zero 
>> Port
>> Association Vector (PAV)
>> for refresh etc to work, inheritance of the locked port flag is a bad 
>> idea
>> (say bug) and shouldn't have
>> been in the first place.
> 
> If it's a fix, then it needs to be submitted to 'net' tree.

It is a 'fix' for this patch set, as it changes 
mv88e6xxx_port_set_lock() to need this change.
It is not strictly necessary to change it for earlier hehaviour.
