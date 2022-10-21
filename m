Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033DD607D4D
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 19:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiJURTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 13:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiJURTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 13:19:05 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2811ABA01;
        Fri, 21 Oct 2022 10:19:02 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id BD5431884D31;
        Fri, 21 Oct 2022 17:18:59 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 7E0FF250007B;
        Fri, 21 Oct 2022 17:18:59 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 7497A9EC0007; Fri, 21 Oct 2022 17:18:59 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 21 Oct 2022 19:18:59 +0200
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
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
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 10/12] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20221021163005.xljk2j3fkikr6uge@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221020132538.reirrskemcjwih2m@skbuf>
 <2565c09bb95d69142522c3c3bcaa599e@kapio-technology.com>
 <20221020225719.l5iw6vndmm7gvjo3@skbuf>
 <82d23b100b8d2c9e4647b8a134d5cbbf@kapio-technology.com>
 <20221021112216.6bw6sjrieh2znlti@skbuf>
 <7bfaae46b1913fe81654a4cd257d98b1@kapio-technology.com>
 <20221021163005.xljk2j3fkikr6uge@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <d1fb07de4b55d64f98425fe66156c4e4@kapio-technology.com>
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

On 2022-10-21 18:30, Vladimir Oltean wrote:
> On Fri, Oct 21, 2022 at 03:16:21PM +0200, netdev@kapio-technology.com 
> wrote:
>> As it is now in the bridge, the locked port part is handled before 
>> learning
>> in the ingress data path, so with BR_LEARNING and BR_PORT_LOCKED, I 
>> think it
>> will work as it does now except link local packages.
> 
> If link-local learning is enabled on a locked port, I think those
> addresses should also be learned with the BR_FDB_LOCKED flag. The
> creation of those locked FDB entries can be further suppressed by the
> BROPT_NO_LL_LEARN flag.
> 
>> If your suggestion of BR_LEARNING causing BR_FDB_LOCKED on a locked 
>> port, I
>> guess it would be implemented under br_fdb_update() and BR_LEARNING +
>> BR_PORT_LOCKED would go together, forcing BR_LEARNING in this case, 
>> thus also
>> for all drivers?
> 
> Yes, basically where this is placed right now (in 
> br_handle_frame_finish):
> 
> 	if (p->flags & BR_PORT_LOCKED) {
> 		struct net_bridge_fdb_entry *fdb_src =
> 			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
> 
> 		if (!fdb_src) {
> 			unsigned long flags = 0;
> 
> 			if (p->flags & BR_PORT_MAB) {
> 			   ~~~~~~~~~~~~~~~~~~~~~~~~
> 			   except check for BR_LEARNING
> 
> 				__set_bit(BR_FDB_LOCKED, &flags);
> 				br_fdb_update(br, p, eth_hdr(skb)->h_source,
> 					      vid, flags);
> 			}
> 			goto drop;
> 		} else if (READ_ONCE(fdb_src->dst) != p ||
> 			   test_bit(BR_FDB_LOCAL, &fdb_src->flags) ||
> 			   test_bit(BR_FDB_LOCKED, &fdb_src->flags)) {
> 			goto drop;
> 		}
> 	}

As I don't know what implications it would have for other drivers to 
have learning
forced enabled on locked ports, I cannot say if it is a good idea or 
not. Right now
learning is not forced either way as is, but the consensus is that 
learning should
be off with locked ports, which it would be either way in the common 
case I think.
