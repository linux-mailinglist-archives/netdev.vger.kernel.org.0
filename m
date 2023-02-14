Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8D56970C5
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjBNWeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjBNWeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:34:14 -0500
X-Greylist: delayed 2399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Feb 2023 14:34:11 PST
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08292CFDA
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:34:11 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 53CD71884412;
        Tue, 14 Feb 2023 21:16:59 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 48AD725002E1;
        Tue, 14 Feb 2023 21:16:59 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 407DC9B403E3; Tue, 14 Feb 2023 21:16:59 +0000 (UTC)
X-Screener-Id: e32ae469fa6e394734d05373d3a705875723cf1e
Received: from fujitsu (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 8F0F391201E3;
        Tue, 14 Feb 2023 21:16:58 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?Q?Cl=C3=A9ment_L=C3=A9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 5/5] net: dsa: mv88e6xxx: implementation of
 dynamic ATU entries
In-Reply-To: <Y+EkiAyexZrPoCpP@corigine.com>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-6-netdev@kapio-technology.com>
 <Y9lkXlyXg1d1D0j3@corigine.com>
 <9b12275969a204739ccfab972d90f20f@kapio-technology.com>
 <Y9zDxlwSn1EfCTba@corigine.com> <20230203204422.4wrhyathxfhj6hdt@skbuf>
 <Y94TebdRQRHMMj/c@corigine.com>
 <4abbe32d007240b9c3aea9c8ca936fa3@kapio-technology.com>
 <Y+EkiAyexZrPoCpP@corigine.com>
Date:   Tue, 14 Feb 2023 22:14:55 +0100
Message-ID: <87fsb83q5s.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 17:02, Simon Horman <simon.horman@corigine.com> wrote:
>
> Just to clarify my suggestion one last time, it would be along the lines
> of the following (completely untested!). I feel that it robustly covers
> all cases for fdb_flags. And as a bonus doesn't need to be modified
> if other (unsupported) flags are added in future.
>
> 	if (fdb_flags & ~(DSA_FDB_FLAG_DYNAMIC))
> 		return -EOPNOTSUPP;
>
> 	is_dynamic = !!(fdb_flags & DSA_FDB_FLAG_DYNAMIC)
> 	if (is_dynamic)
> 		state = MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_7_NEWEST;
>
>
> And perhaps for other drivers:
>
> 	if (fdb_flags & ~(DSA_FDB_FLAG_DYNAMIC))
> 		return -EOPNOTSUPP;
> 	if (fdb_flags)
> 		return 0;
>
> Perhaps a helper would be warranted for the above.

How would such a helper look? Inline function is not clean.

>
> But in writing this I think that, perhaps drivers could return -EOPNOTSUPP
> for the DSA_FDB_FLAG_DYNAMIC case and the caller can handle, rather tha
> propagate, -EOPNOTSUPP.

I looked at that, but changing the caller is also a bit ugly.

>
> Returning -EOPNOTSUPP is the normal way to drivers to respond to requests
> for unsupported hardware offloads. Sticking to that may be clearner
> in the long run. That said, I do agree your current patch is correct
> given the flag that is defined (by your patchset).
