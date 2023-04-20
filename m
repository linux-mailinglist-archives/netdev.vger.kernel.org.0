Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FEE6E94CA
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 14:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjDTMoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 08:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjDTMoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 08:44:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0161D93
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 05:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=cxOAZMCwxd7nzl7PU7dzd/bSP5i8CxvPGUF0wgPolHw=; b=i3
        J4Gs7BvHbJM6pydCXk5/RvjnWkdtA249FSMFI9IZ6ZzR5ko7ifb8kZGSzRy19vV3ZJGuPwgGNoZAD
        hhNM0hghoyvjXgMxwTtqyPuh3z2IN2ld/z0LzouXdGnN0pwd8mV3AqK51E7owt7W3lbi6FWW3Ws4r
        qIk1841zphkCIdg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ppTda-00Amwb-00; Thu, 20 Apr 2023 14:43:46 +0200
Date:   Thu, 20 Apr 2023 14:43:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <b93039ef-a593-4acd-b9c1-3f3e6b79497d@lunn.ch>
References: <ZEATxeT+g5Bx5ml2@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZEATxeT+g5Bx5ml2@debian>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 06:16:05PM +0200, Ramón Nordin Rodriguez wrote:
> Changes:
>     v2:
> - Removed mentioning of not supporting auto-negotiation from commit
>   message
> - Renamed file drivers/net/phy/lan867x.c ->
>   drivers/net/phy/microchip_t1s.c
> - Renamed Kconfig option to reflect implementation filename (from
>   LAN867X_PHY to MICROCHIP_T1S_PHY)
> - Moved entry in drivers/net/phy/KConfig to correct sort order
> - Moved entry in drivers/net/phy/Makefile to correct sort order
> - Moved variable declarations to conform to reverse christmas tree order
>   (in func lan867x_config_init)
> - Moved register write to disable chip interrupts to func lan867x_config_init, when omitting the irq disable all togheter I got null pointer dereference, see the call trace below:
> 
>     Call Trace:
>      <TASK>
>      phy_interrupt+0xa8/0xf0 [libphy]
>      irq_thread_fn+0x1c/0x60
>      irq_thread+0xf7/0x1c0
>      ? __pfx_irq_thread_dtor+0x10/0x10
>      ? __pfx_irq_thread+0x10/0x10
>      kthread+0xe6/0x110
>      ? __pfx_kthread+0x10/0x10
>      ret_from_fork+0x29/0x50
>      </TASK>
> 
> - Removed func lan867x_config_interrupt and removed the member
>   .config_intr from the phy_driver struct
> 
>     v3:
> - Indentation level in drivers/net/phy/Kconfig
> - Moved const arrays into global scope and made them static in order to have
>   them placed in the .rodata section
> - Renamed array variables, since they are no longer as closely scoped as
>   earlier
> - Added comment about why phy_write_mmd is used over phy_modify_mmd
>   (this should have been addressed in the V2 change since it was brought
>   up in the V1 review)
> - Return result of last call instead of saving it in a var and then
>   returning the var (in lan867x_config_init)
> 
> Testing:
> This has been tested with ethtool --set/get-plca-cfg and verified on an
> oscilloscope where it was observed that:
> - The PLCA beacon was enabled/disabled when setting the node-id to 0/not
>   0
> - The PLCA beacon is transmitted with the expected frequency when
>   changing max nodes
> - Two devices using the evaluation board EVB-LAN8670-USB could ping each
>   other
> 
> 
> This patch adds support for the Microchip LAN867x 10BASE-T1S family
> (LAN8670/1/2). The driver supports P2MP with PLCA.
> 
> Signed-off-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>

All the above ends up in the commit message, as you see in git log. So
this last paragraph should really be first. As you have it, the
history of the patch will also be included in the commit. Most Linux
subsystems don't want that, although DaveM has argued it maybe should
be in the commit message. But i personally think we have good archives
of emails, and search engines for those archives, so i don't see the
need.

Anything you put after the --- will get discarded when the Maintainers
perform the merge. So i suggest you move most of what you have in the
commit message below the ---. You can also have two ---, which is how
i tend to do it, so i can keep the history in my git repo, but it then
gets removed when merged upstream.

Additionally, you should add any Reviewed-by:, Acked-by: to your
patches. Only discard them if you make major changed which invalidates
any reviews.

    Andrew
