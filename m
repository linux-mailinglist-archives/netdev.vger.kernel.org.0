Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1631F4C01DF
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 20:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiBVTPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 14:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiBVTPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 14:15:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35CD15C9F9;
        Tue, 22 Feb 2022 11:15:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55097615D7;
        Tue, 22 Feb 2022 19:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23712C340EF;
        Tue, 22 Feb 2022 19:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645557324;
        bh=U9jeNgWTnREJMOGMhNcgz9fVNyZ6v4l6J7nfG6DOUbE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kWXWCyLxNVANdV5eeEktWoPfKTJphflfJSUcU4jZVaHQnJS0AraA+Bh2WccNDGPND
         Pti8QeNuH9VF2E7xzHou4j9QEiodZABeC+pcnhnsuoPclcK0Ldy1wmzGaFsdMbkLWT
         gIYz/w3E5EcBBxUBy6ui1nhgwVxRpq4WfiyNESnOHNnsu0dTIPVY+NQvUFhlEzu/ss
         wMrfr3tH9sJyyadZck4iJJdBRodB93wuyZd05mJUmaoZtOZiQnpa4THmg4kF4nTD80
         fmGqUM2ffmFxPPSk3TiZlvFEFWzaIxeUwSYKjK1lJCYYntMBNODSm3spMFLl9rWQUy
         a4FMqFCBPLjpQ==
Date:   Tue, 22 Feb 2022 11:15:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/5] Add support for locked bridge ports
 (for 802.1X)
Message-ID: <20220222111523.030ab13d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220222132818.1180786-1-schultz.hans+netdev@gmail.com>
References: <20220222132818.1180786-1-schultz.hans+netdev@gmail.com>
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

On Tue, 22 Feb 2022 14:28:13 +0100 Hans Schultz wrote:
> This series starts by adding support for SA filtering to the bridge,
> which is then allowed to be offloaded to switchdev devices. Furthermore
> an offloading implementation is supplied for the mv88e6xxx driver.
> 
> Public Local Area Networks are often deployed such that there is a
> risk of unauthorized or unattended clients getting access to the LAN.
> To prevent such access we introduce SA filtering, such that ports
> designated as secure ports are set in locked mode, so that only
> authorized source MAC addresses are given access by adding them to
> the bridges forwarding database. Incoming packets with source MAC
> addresses that are not in the forwarding database of the bridge are
> discarded. It is then the task of user space daemons to populate the
> bridge's forwarding database with static entries of authorized entities.
> 
> The most common approach is to use the IEEE 802.1X protocol to take
> care of the authorization of allowed users to gain access by opening
> for the source address of the authorized host.
> 
> With the current use of the bridge parameter in hostapd, there is
> a limitation in using this for IEEE 802.1X port authentication. It
> depends on hostapd attaching the port on which it has a successful
> authentication to the bridge, but that only allows for a single
> authentication per port. This patch set allows for the use of
> IEEE 802.1X port authentication in a more general network context with
> multiple 802.1X aware hosts behind a single port as depicted, which is
> a commonly used commercial use-case, as it is only the number of
> available entries in the forwarding database that limits the number of
> authenticated clients.
> 
>       +--------------------------------+
>       |                                |
>       |      Bridge/Authenticator      |
>       |                                |
>       +-------------+------------------+
>        802.1X port  |
>                     |
>                     |
>              +------+-------+
>              |              |
>              |  Hub/Switch  |
>              |              |
>              +-+----------+-+
>                |          |
>             +--+--+    +--+--+
>             |     |    |     |
>     Hosts   |  a  |    |  b  |   . . .
>             |     |    |     |
>             +-----+    +-----+
> 
> The 802.1X standard involves three different components, a Supplicant
> (Host), an Authenticator (Network Access Point) and an Authentication
> Server which is typically a Radius server. This patch set thus enables
> the bridge module together with an authenticator application to serve
> as an Authenticator on designated ports.
> 
> 
> For the bridge to become an IEEE 802.1X Authenticator, a solution using
> hostapd with the bridge driver can be found at
> https://github.com/westermo/hostapd/tree/bridge_driver .
> 
> 
> The relevant components work transparently in relation to if it is the
> bridge module or the offloaded switchcore case that is in use.

You still haven't answer my question. Is the data plane clear text in
the deployment you describe?
