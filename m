Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0BD5A4478
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiH2IE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiH2IE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:04:28 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308F64F654;
        Mon, 29 Aug 2022 01:04:27 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 8D99C1883996;
        Mon, 29 Aug 2022 08:04:25 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 82C7625032B7;
        Mon, 29 Aug 2022 08:04:25 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 72B209EC0004; Mon, 29 Aug 2022 08:04:25 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Mon, 29 Aug 2022 10:04:25 +0200
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
Subject: Re: [PATCH v5 net-next 1/6] net: bridge: add locked entry fdb flag to
 extend locked port feature
In-Reply-To: <YwxwPJOx/n5SHZM5@shredder>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
 <20220826114538.705433-2-netdev@kapio-technology.com>
 <Ywo16vHMqxxszWzX@shredder>
 <dd9a4156fe421f6be3a49f5b928ef77e@kapio-technology.com>
 <YwxwPJOx/n5SHZM5@shredder>
User-Agent: Gigahost Webmail
Message-ID: <7e4b58a75ece9cce4c841c33d7d66265@kapio-technology.com>
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

On 2022-08-29 09:52, Ido Schimmel wrote:
> On Sun, Aug 28, 2022 at 12:23:30PM +0200, netdev@kapio-technology.com 
> wrote:
>> On 2022-08-27 17:19, Ido Schimmel wrote:
>> > On Fri, Aug 26, 2022 at 01:45:33PM +0200, Hans Schultz wrote:
>> > >
>> > >  	nbp_switchdev_frame_mark(p, skb);
>> > > @@ -943,6 +946,10 @@ static int br_setport(struct net_bridge_port
>> > > *p, struct nlattr *tb[],
>> > >  	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS,
>> > > BR_NEIGH_SUPPRESS);
>> > >  	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
>> > >  	br_set_port_flag(p, tb, IFLA_BRPORT_LOCKED, BR_PORT_LOCKED);
>> > > +	br_set_port_flag(p, tb, IFLA_BRPORT_MAB, BR_PORT_MAB);
>> > > +
>> > > +	if (!(p->flags & BR_PORT_LOCKED))
>> > > +		p->flags &= ~BR_PORT_MAB;
>> 
>> The reason for this is that I wanted it to be so that if you have MAB
>> enabled (and locked of course) and unlock the port, it will 
>> automatically
>> clear both flags instead of having to first disable MAB and then 
>> unlock the
>> port.
> 
> User space can just do:
> 
> # bridge link set dev swp1 locked off mab off
> 
> I prefer not to push such logic into the kernel and instead fail
> explicitly. I won't argue if more people are in favor.

I shall do it as you suggest. It sounds fair. :-)
