Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC1659AFC5
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 20:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiHTSuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 14:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbiHTSuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 14:50:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3175D2981D
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 11:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eKusj1X7X5v64miOBYpjX0rQ2moFhgmS1hgucUPsy7w=; b=AWeCpsEIHt//kSBgY948bUT7w+
        43agROFugSodobD6VdbX5glUo/QuufgyHPWAER67RdDmqmlmj3Grd5V1aiz3ay8IsFi3E8uJPMKZy
        jUxEmv4kbG3drbaf9qezf+sITrzsIIlw4+xIRntnk6kMEAmxs4DRTWRiXOrZj4fwV87E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oPTYX-00E3qG-Jt; Sat, 20 Aug 2022 20:50:49 +0200
Date:   Sat, 20 Aug 2022 20:50:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2] net: moxa: get rid of asymmetry in DMA
 mapping/unmapping
Message-ID: <YwEtCYcV0TvpjZkK@lunn.ch>
References: <20220819110519.1230877-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819110519.1230877-1-saproj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 02:05:19PM +0300, Sergei Antonov wrote:
> Since priv->rx_mapping[i] is maped in moxart_mac_open(), we
> should unmap it from moxart_mac_stop(). Fixes 2 warnings.
> 
> 1. During error unwinding in moxart_mac_probe(): "goto init_fail;",
> then moxart_mac_free_memory() calls dma_unmap_single() with
> priv->rx_mapping[i] pointers zeroed.
> 
> WARNING: CPU: 0 PID: 1 at kernel/dma/debug.c:963 check_unmap+0x704/0x980
> DMA-API: moxart-ethernet 92000000.mac: device driver tries to free DMA memory it has not allocated [device address=0x0000000000000000] [size=1600 bytes]
> CPU: 0 PID: 1 Comm: swapper Not tainted 5.19.0+ #60
> Hardware name: Generic DT based system
>  unwind_backtrace from show_stack+0x10/0x14
>  show_stack from dump_stack_lvl+0x34/0x44
>  dump_stack_lvl from __warn+0xbc/0x1f0
>  __warn from warn_slowpath_fmt+0x94/0xc8
>  warn_slowpath_fmt from check_unmap+0x704/0x980
>  check_unmap from debug_dma_unmap_page+0x8c/0x9c
>  debug_dma_unmap_page from moxart_mac_free_memory+0x3c/0xa8
>  moxart_mac_free_memory from moxart_mac_probe+0x190/0x218
>  moxart_mac_probe from platform_probe+0x48/0x88
>  platform_probe from really_probe+0xc0/0x2e4
> 
> 2. After commands:
>  ip link set dev eth0 down
>  ip link set dev eth0 up
> 
> WARNING: CPU: 0 PID: 55 at kernel/dma/debug.c:570 add_dma_entry+0x204/0x2ec
> DMA-API: moxart-ethernet 92000000.mac: cacheline tracking EEXIST, overlapping mappings aren't supported
> CPU: 0 PID: 55 Comm: ip Not tainted 5.19.0+ #57
> Hardware name: Generic DT based system
>  unwind_backtrace from show_stack+0x10/0x14
>  show_stack from dump_stack_lvl+0x34/0x44
>  dump_stack_lvl from __warn+0xbc/0x1f0
>  __warn from warn_slowpath_fmt+0x94/0xc8
>  warn_slowpath_fmt from add_dma_entry+0x204/0x2ec
>  add_dma_entry from dma_map_page_attrs+0x110/0x328
>  dma_map_page_attrs from moxart_mac_open+0x134/0x320
>  moxart_mac_open from __dev_open+0x11c/0x1ec
>  __dev_open from __dev_change_flags+0x194/0x22c
>  __dev_change_flags from dev_change_flags+0x14/0x44
>  dev_change_flags from devinet_ioctl+0x6d4/0x93c
>  devinet_ioctl from inet_ioctl+0x1ac/0x25c
> 
> v1 -> v2:
> Extraneous change removed.
> 
> Fixes: 6c821bd9edc9 ("net: Add MOXA ART SoCs ethernet driver")
> Signed-off-by: Sergei Antonov <saproj@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
