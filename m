Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5190E5ABC6D
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 04:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiICCuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 22:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiICCuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 22:50:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48315007F;
        Fri,  2 Sep 2022 19:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A28D2B82D0E;
        Sat,  3 Sep 2022 02:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEADC433D6;
        Sat,  3 Sep 2022 02:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662173409;
        bh=x7AJOvmatw37iAWqWym8U5Ez6tAqtDaKH6PPmaWjdtE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V8UKzxvsZ11Hc0XF4uNg7dnJs1ESe/yXiWQU4ATvyxHuuUBtAkx2JeuXArfYS2RSN
         iJ0IhcGxoQksY5WTSHjemao/QTebvE/VwjwFRzXbMbom56CN86V9F8h2KeZ3nICV7k
         v9wIZtRVw/8m1u9QB2+b/dDgi8PIP1qzRQbm9pK0ZuUrjVh3HejG296SGVDn51AAnB
         YclvujsXD1FNEIxbmuyokEASknyR4HeZKoBq4XKHNqLSfnaQWHhPARn78VqQARo4JV
         hHAuP+7VsI0l6EUfwsuu9/lmvz4e0G9LAaRzxAIA0AxWcvW3Otuyx+gm9pEL913shx
         A9mw/RiG4+Weg==
Date:   Sat, 3 Sep 2022 04:50:00 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part
 4)
Message-ID: <20220903045000.6df542a9@thinkpad>
In-Reply-To: <63124f17.170a0220.80d35.2d31@mx.google.com>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
        <63124f17.170a0220.80d35.2d31@mx.google.com>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Sep 2022 20:44:37 +0200
Christian Marangi <ansuelsmth@gmail.com> wrote:

> On Tue, Aug 30, 2022 at 10:59:23PM +0300, Vladimir Oltean wrote:
> > Those who have been following part 1:
> > https://patchwork.kernel.org/project/netdevbpf/cover/20220511095020.562461-1-vladimir.oltean@nxp.com/
> > part 2:
> > https://patchwork.kernel.org/project/netdevbpf/cover/20220521213743.2735445-1-vladimir.oltean@nxp.com/
> > and part 3:
> > https://patchwork.kernel.org/project/netdevbpf/cover/20220819174820.3585002-1-vladimir.oltean@nxp.com/
> > will know that I am trying to enable the second internal port pair from
> > the NXP LS1028A Felix switch for DSA-tagged traffic via "ocelot-8021q".
> > 
> > This series represents the final part of that effort. We have:
> > 
> > - the introduction of new UAPI in the form of IFLA_DSA_MASTER
> > 
> > - preparation for LAG DSA masters in terms of suppressing some
> >   operations for masters in the DSA core that simply don't make sense
> >   when those masters are a bonding/team interface
> > 
> > - handling all the net device events that occur between DSA and a
> >   LAG DSA master, including migration to a different DSA master when the
> >   current master joins a LAG, or the LAG gets destroyed
> > 
> > - updating documentation
> > 
> > - adding an implementation for NXP LS1028A, where things are insanely
> >   complicated due to hardware limitations. We have 2 tagging protocols:
> > 
> >   * the native "ocelot" protocol (NPI port mode). This does not support
> >     CPU ports in a LAG, and supports a single DSA master. The DSA master
> >     can be changed between eno2 (2.5G) and eno3 (1G), but all ports must
> >     be down during the changing process, and user ports assigned to the
> >     old DSA master will refuse to come up if the user requests that
> >     during a "transient" state.
> > 
> >   * the "ocelot-8021q" software-defined protocol, where the Ethernet
> >     ports connected to the CPU are not actually "god mode" ports as far
> >     as the hardware is concerned. So here, static assignment between
> >     user and CPU ports is possible by editing the PGID_SRC masks for
> >     the port-based forwarding matrix, and "CPU ports in a LAG" simply
> >     means "a LAG like any other".
> > 
> > The series was regression-tested on LS1028A using the local_termination.sh
> > kselftest, in most of the possible operating modes and tagging protocols.
> > I have not done a detailed performance evaluation yet, but using LAG, is
> > possible to exceed the termination bandwidth of a single CPU port in an
> > iperf3 test with multiple senders and multiple receivers.
> > 
> > There was a previous RFC posted, which contains most of these changes,
> > however it's so old by now that it's unlikely anyone of the reviewers
> > remembers it in detail. I've applied most of the feedback requested by
> > Florian and Ansuel there.
> > https://lore.kernel.org/netdev/20220523104256.3556016-1-olteanv@gmail.com/  
> 
> Hi,
> I would love to test this but for me it's a bit problematic to use a
> net-next kernel. I wonder if it's possible to backport the 4 part to
> older kernel or other prereq are needed. (I know backporting the 4 part
> will be crazy but it's something that has to be done anyway to actually
> use this on OpenWrt where we currently use 5.10 and 5.15)
> 
> Would be good to know if the 4 part require other changes to dsa core to
> make a LAG implementation working. (talking for 5.15 since backporting
> this to 5.10 is a nono...)

Just use the newest kernel. Trust me, backporting new DSA changes to
5.15 is painful. And to 5.10 and earlier it is a literal hell.

:) Marek
