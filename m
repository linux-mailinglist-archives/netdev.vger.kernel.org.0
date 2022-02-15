Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB954B790D
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244176AbiBOUuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 15:50:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbiBOUub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 15:50:31 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38D8BC11;
        Tue, 15 Feb 2022 12:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4lrhr+dV8IPu+x8jpgGZrTETmOoIr38eeSyjGNpZKeg=; b=Tmsm1Ej+OicaVXFF7AMOvCOdkc
        1WLnzPfTDHtczeIovfpdX7eBowOtlH9xOo9kS4q/KveNysuEd66dS5IgKQMnGVhH8dEwky/b+mipp
        zDApKKgWY1QYL6dtnvMla1/yVStHk5zRO+Ahsj4qqZWsb8G0dpfjl2KeY1egSUN0gkQU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nK4m2-0067US-G8; Tue, 15 Feb 2022 21:50:10 +0100
Date:   Tue, 15 Feb 2022 21:50:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heyi Guo <guoheyi@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Issue report] drivers/ftgmac100: DHCP occasionally fails during
 boot up or link down/up
Message-ID: <YgwSAjGN2eWUpamo@lunn.ch>
References: <0e456c4d-aa22-4e7f-9b2c-3059fe840cb9@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e456c4d-aa22-4e7f-9b2c-3059fe840cb9@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 02:38:51PM +0800, Heyi Guo wrote:
> Hi,
> 
> We are using Aspeed 2600 and found DHCP occasionally fails during boot up or
> link down/up. The DHCP client is systemd 247.6 networkd. Our network device
> is 2600 MAC4 connected to a RGMII PHY module.
> 
> Current investigation shows the first DHCP discovery packet sent by
> systemd-networkd might be corrupted, and sysmtemd-networkd will continue to
> send DHCP discovery packets with the same XID, but no other packets, as
> there is no IP obtained at the moment. However the server side will not
> respond with this serial of DHCP requests, until it receives some other
> packets. This situation can be recovered by another link down/up, or a "ping
> -I eth0 xxx.xxx.xxx.xxx" command to insert some other TX packets.
> 
> Navigating the driver code ftgmac.c, I've some question about the work flow
> from link down to link up. I think the flow is as below:
> 
> 1. ftgmac100_open() will enable net interface with ftgmac100_init_all(), and
> then call phy_start()
> 
> 2. When PHY is link up, it will call netif_carrier_on() and then adjust_link
> interface, which is ftgmac100_adjust_link() for ftgmac100

The order there is questionable. Maybe it should first call the adjust
link callback, and then the netif_carrier_on(). However...

> 
> 3. In ftgmac100_adjust_link(), it will schedule the reset work
> (ftgmac100_reset_task)
> 
> 4. ftgmac100_reset_task() will then reset the MAC

Because of this delayed reset, changing the order will not help this
driver.

> I found networkd will start to send DHCP request immediately after
> netif_carrier_on() called in step 2, but step 4 will reset the MAC, which
> may potentially corrupt the sending packet.

What is not clear to my is why it is scheduling the work rather than
just doing it. At least for adjust_link, it is in a context it can
sleep. ftgmac100_set_ringparam() should also be able to
sleep. ftgmac100_interrupt() cannot sleep, so it does need to schedule
work.

I would suggest you refactor ftgmac100_reset_task() into a function
that actually does the reset, and a wrapper which takes a
work_struct. adjust_link can then directly do the reset, which
probably solves your problem.

	 Andrew
