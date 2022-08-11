Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C562D58FE1A
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 16:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbiHKOM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 10:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiHKOM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 10:12:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E0E64FD
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 07:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pqpfrjNo925kqjlZNWOT7G0b+jlXTS8ZjYzV9/DPllI=; b=y0WpkPMTYro5r8CMxHhMKWUDpf
        ISSCeTvBVpE+sCn5Z9lKjotSXiNyZ7HEVCyQ2IuEh0uWnVuXxqWUZyT0bs+S4AWPgk9ygFSYtG2Ag
        vSYVvXoGxPCPKPQeAuXc9ODNnrgnzyCoE3ESrBvNpwi4n/FzWrTBd8DDIwZS6vSBLg6U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oM8vC-00D2A2-0W; Thu, 11 Aug 2022 16:12:26 +0200
Date:   Thu, 11 Aug 2022 16:12:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6060: report max mtu 1536
Message-ID: <YvUOSWxZPXa2JX8o@lunn.ch>
References: <20220810082745.1466895-1-saproj@gmail.com>
 <20220810100818.greurtz6csgnfggv@skbuf>
 <CABikg9zb7z8p7tE0H+fpmB_NSK3YVS-Sy4sqWbihziFdPBoL+Q@mail.gmail.com>
 <20220810133531.wia2oznylkjrgje2@skbuf>
 <CABikg9yVpQaU_cf+iuPn5EV0Hn9ydwigdmZrrdStq7y-y+=YsQ@mail.gmail.com>
 <20220810193825.vq7rdgwx7xua5amj@skbuf>
 <CABikg9wUtyNGJ+SvASGC==qezh2eghJ=SyM5hECYVguR3BmGQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABikg9wUtyNGJ+SvASGC==qezh2eghJ=SyM5hECYVguR3BmGQQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > 2: eth0: <BROADCAST,MULTICAST> mtu 1504 qdisc noop qlen 1000
> > >     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
> >
> > The DSA master is super odd for starting with an all-zero MAC address.
> > What driver handles this part? Normally, drivers are expected to work
> > with a MAC address provided by the firmware (of_get_mac_address or
> > other, perhaps proprietary, means) and fall back to eth_random_addr()
> > if that is missing.
> 
> eth0 is handled by the CONFIG_ARM_MOXART_ETHER driver. By the way, I
> had to change some code in it to make it work, and I am going to
> submit a patch or two later.
> The driver does not know its MAC address initially. On my hardware it
> is stored in a flash memory chip, so I assign it using "ip link set
> ..." either manually or from an /etc/init.d script. A solution with
> early MAC assignment in the moxart_mac_probe() function is doable. Do
> you think I should implement it?

I would suggest a few patches:

1) Use eth_hw_addr_random() to assign a random MAC address during probe.
2) Remove is_valid_ether_addr() from moxart_mac_open()
3) Add a call to platform_get_ethdev_address() during probe
4) Remove is_valid_ether_addr() from moxart_set_mac_address(). The core does this

platform_get_ethdev_address() will call of_get_mac_addr_nvmem() which
might be able to get your MAC address out of flash, without user space
being involved.

      Andrew
