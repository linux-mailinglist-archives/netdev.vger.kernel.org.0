Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A687228C37
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731305AbgGUWuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGUWuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:50:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D81C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 15:50:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8847811E45904;
        Tue, 21 Jul 2020 15:33:49 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:50:33 -0700 (PDT)
Message-Id: <20200721.155033.2149733194853712030.davem@davemloft.net>
To:     helmut.grohne@intenta.de
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, Tristram.Ha@microchip.com
Subject: Re: [PATCH v4] net: dsa: microchip: call phy_remove_link_mode
 during probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721110738.GA9008@laureti-dev>
References: <20200720204353.GO1339445@lunn.ch>
        <20200721110738.GA9008@laureti-dev>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:33:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Helmut Grohne <helmut.grohne@intenta.de>
Date: Tue, 21 Jul 2020 13:07:39 +0200

> When doing "ip link set dev ... up" for a ksz9477 backed link,
> ksz9477_phy_setup is called and it calls phy_remove_link_mode to remove
> 1000baseT HDX. During phy_remove_link_mode, phy_advertise_supported is
> called. Doing so reverts any previous change to advertised link modes
> e.g. using a udevd .link file.
> 
> phy_remove_link_mode is not meant to be used while opening a link and
> should be called during phy probe when the link is not yet available to
> userspace.
> 
> Therefore move the phy_remove_link_mode calls into
> ksz9477_switch_register. It indirectly calls dsa_register_switch, which
> creates the relevant struct phy_devices and we update the link modes
> right after that. At that time dev->features is already initialized by
> ksz9477_switch_detect.
> 
> Remove phy_setup from ksz_dev_ops as no users remain.
> 
> Link: https://lore.kernel.org/netdev/20200715192722.GD1256692@lunn.ch/
> Fixes: 42fc6a4c613019 ("net: dsa: microchip: prepare PHY for proper advertisement")
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>

Applied and queued up for -stable, thanks.
