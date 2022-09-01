Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886CB5A8C0C
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 05:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbiIADu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 23:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiIADuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 23:50:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E608A54645;
        Wed, 31 Aug 2022 20:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38DAE60FD2;
        Thu,  1 Sep 2022 03:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C839FC433D6;
        Thu,  1 Sep 2022 03:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662004222;
        bh=NPbps7uPi2UsccwPgkn9NiGkpZleO4/g+eTbkUXig4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WRYNiJHkkijy4XhK08vHhmuHFAK6ZNTm8q/gu0t1Hl6+uNLCJXJmiqO6Ft1BUyhG2
         tIousn1ukS0L3HRngmo9sLCUA2p60Wx3kJO529qJvkRQzxFsvzMMaNHAXL3NyelVlw
         OUccvDPZssOUjvlpdzp8YF10FEf4Zs5CozJ90QbhceTTXfzDo6TghxeGhX/dpcaXD2
         rwCDWVzXGfM33dxa8Ol6s+F3xs2S0ptnuZ/YOh5mW8YWm1t9EwWHWxbx0ryZCLH3dV
         ySsOAVULIXjUbke2Q2CejP6PsL2OgdbhhZ5rYNgvMx3QFvebX8Kb8jGR5/wxFmHTWg
         CaBeyl2igvcKA==
Date:   Wed, 31 Aug 2022 20:50:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH net-next 3/9] net: dsa: allow the DSA master to be seen
 and changed through rtnetlink
Message-ID: <20220831205020.28fbfcc5@kernel.org>
In-Reply-To: <20220830195932.683432-4-vladimir.oltean@nxp.com>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
        <20220830195932.683432-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 22:59:26 +0300 Vladimir Oltean wrote:
> Some DSA switches have multiple CPU ports, which can be used to improve
> CPU termination throughput, but DSA, through dsa_tree_setup_cpu_ports(),
> sets up only the first one, leading to suboptimal use of hardware.
>=20
> The desire is to not change the default configuration but to permit the
> user to create a dynamic mapping between individual user ports and the
> CPU port that they are served by, configurable through rtnetlink. It is
> also intended to permit load balancing between CPU ports, and in that
> case, the foreseen model is for the DSA master to be a bonding interface
> whose lowers are the physical DSA masters.
>=20
> To that end, we create a struct rtnl_link_ops for DSA user ports with
> the "dsa" kind. We expose the IFLA_DSA_MASTER link attribute that
> contains the ifindex of the newly desired DSA master.

net/dsa/port.c: In function =E2=80=98dsa_port_change_master=E2=80=99:
net/dsa/port.c:1414:13: warning: unused variable =E2=80=98port=E2=80=99 [-W=
unused-variable]
 1414 |         int port =3D dp->index;
      |             ^~~~

I presume you had a look around what side effects setting rtnl_link_ops
will have? Should .netns_refund be true?
