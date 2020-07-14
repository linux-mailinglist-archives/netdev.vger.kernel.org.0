Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1CA21FF91
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgGNVHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 17:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727813AbgGNVHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:07:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A661AC061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 14:07:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A64B815E2C7F7;
        Tue, 14 Jul 2020 14:07:11 -0700 (PDT)
Date:   Tue, 14 Jul 2020 14:07:10 -0700 (PDT)
Message-Id: <20200714.140710.213288407914809619.davem@davemloft.net>
To:     helmut.grohne@intenta.de
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH] net: phy: phy_remove_link_mode should not advertise
 new modes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200714082540.GA31028@laureti-dev>
References: <20200714082540.GA31028@laureti-dev>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jul 2020 14:07:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Helmut Grohne <helmut.grohne@intenta.de>
Date: Tue, 14 Jul 2020 10:25:42 +0200

> When doing "ip link set dev ... up" for a ksz9477 backed link,
> ksz9477_phy_setup is called and it calls phy_remove_link_mode to remove
> 1000baseT HDX. During phy_remove_link_mode, phy_advertise_supported is
> called.
> 
> If one wants to advertise fewer modes than the supported ones, one
> usually reduces the advertised link modes before upping the link (e.g.
> by passing an appropriate .link file to udev).  However upping
> overrwrites the advertised link modes due to the call to
> phy_advertise_supported reverting to the supported link modes.
> 
> It seems unintentional to have phy_remove_link_mode enable advertising
> bits and it does not match its description in any way. Instead of
> calling phy_advertise_supported, we should simply clear the link mode to
> be removed from both supported and advertising.
> 
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
> Fixes: 41124fa64d4b29 ("net: ethernet: Add helper to remove a supported link mode")

The problem is that we can't allow the advertised setting to exceed
what is in the supported list.

That's why this helper is coded this way from day one.
