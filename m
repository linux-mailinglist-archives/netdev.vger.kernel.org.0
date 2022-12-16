Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F0064EFD1
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiLPQyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiLPQyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:54:22 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A032D2634;
        Fri, 16 Dec 2022 08:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0ykrJHbPVroq1EZ3qDmhugzC+Dqya9lG2NHOM0fSuHo=; b=Nzz4oLZvxjnZJ/8f/1N6BhL8ca
        oatlFMYFm9EO7tvvsgF4t+Hu7LI9qAMNkukyxGE8x82AK4apeFpPHobtr6Ch9KSuc907mVa4mGVeU
        JKL1ozX4sUcshfL6OODBLA/sLBNoh4FNzOZwXYcg8W32uXvRR7goqUhhRWLqbQ7AxXv6KQ8l8dfED
        z3kOtY8IwcZxtksSb7FXSEZiCbGzilFT/mYRz7qE9UJOYCFSrMXtgu80V+CVPw+g9XowT4edei3S8
        QST1vWz7F9yqH9bmlk7mHs6zsIaWq5xfsldUZLJKAzCNdvnVDlOT3SiWxJ7j46ZJPuZy7yHsvnjay
        SbC2QElA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35746)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p6DyU-00089h-5t; Fri, 16 Dec 2022 16:54:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p6DyS-00012U-KR; Fri, 16 Dec 2022 16:54:16 +0000
Date:   Fri, 16 Dec 2022 16:54:16 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v4 0/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <Y5yiuJYfqQlS0DX8@shell.armlinux.org.uk>
References: <20221216164851.2932043-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216164851.2932043-1-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

Please note net-next is currently closed due to the merge window, so
please don't send patches for it. However, feel free to send RFC
patches for net-next so that reviews can still happen.

Thanks!

On Fri, Dec 16, 2022 at 11:48:47AM -0500, Sean Anderson wrote:
> This attempts to address the problems first reported in [1]. Tim has an
> Aquantia phy where the firmware is set up to use "5G XFI" (underclocked
> 10GBASE-R) when rate adapting lower speeds. This results in us
> advertising that we support lower speeds and then failing to bring the
> link up. To avoid this, determine whether to enable rate adaptation
> based on what's programmed by the firmware. This is "the worst choice"
> [2], but we can't really do better until we have more insight into
> what the firmware is doing. At the very least, we can prevent bad
> firmware from causing us to advertise the wrong modes.
> 
> Past submissions may be found at [3, 4].
> 
> [1] https://lore.kernel.org/netdev/CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com/
> [2] https://lore.kernel.org/netdev/20221118171643.vu6uxbnmog4sna65@skbuf/
> [3] https://lore.kernel.org/netdev/20221114210740.3332937-1-sean.anderson@seco.com/
> [4] https://lore.kernel.org/netdev/20221128195409.100873-1-sean.anderson@seco.com/
> 
> Changes in v4:
> - Reorganize MDIO defines
> - Fix kerneldoc using - instead of : for parameters
> 
> Changes in v3:
> - Update speed register bits
> - Fix incorrect bits for PMA/PMD speed
> 
> Changes in v2:
> - Move/rename phylink_interface_max_speed
> - Rework to just validate things instead of modifying registers
> 
> Sean Anderson (4):
>   net: phy: Move/rename phylink_interface_max_speed
>   phy: mdio: Reorganize defines
>   net: mdio: Update speed register bits
>   phy: aquantia: Determine rate adaptation support from registers
> 
>  drivers/net/phy/aquantia_main.c | 160 ++++++++++++++++++++++++++++++--
>  drivers/net/phy/phy-core.c      |  70 ++++++++++++++
>  drivers/net/phy/phylink.c       |  75 +--------------
>  include/linux/phy.h             |   1 +
>  include/uapi/linux/mdio.h       | 109 ++++++++++++++--------
>  5 files changed, 299 insertions(+), 116 deletions(-)
> 
> -- 
> 2.35.1.1320.gc452695387.dirty
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
