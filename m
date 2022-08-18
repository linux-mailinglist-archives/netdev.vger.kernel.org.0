Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8951A598C81
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343815AbiHRT1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbiHRT1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:27:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D2FC9EA8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 12:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YWB8xh/py5bH9cGdR1c68GrZdItJitpeqZsvSRtjWDI=; b=HFZzIyEFtRz7ntbw8sXN1fx8XB
        JDNpCejVsZUFwm4AMHkDiMjKmxhwPgYp/batR8sQ7517utbVJ4IvT6APcAROCt3XSydt0WGZSs6DM
        rZtcsC3KpE86oYa5ktG9RAm5RImGHqL+YcRcTqRzDEWw0AWZUVUxLWQ7q/ODQRpaSlFc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOlAY-00Dpkb-0P; Thu, 18 Aug 2022 21:27:06 +0200
Date:   Thu, 18 Aug 2022 21:27:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH 2/2] net: moxa: prevent double-mapping of DMA areas
Message-ID: <Yv6SiQgzKSRL1Zy6@lunn.ch>
References: <20220818182948.931712-1-saproj@gmail.com>
 <20220818182948.931712-2-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818182948.931712-2-saproj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 09:29:48PM +0300, Sergei Antonov wrote:
> Fix the warning poping up after bringing the link down, then up:
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
> Unmap RX memory areas in moxart_mac_stop(), so that moxart_mac_open()
> will map them anew instead of double-mapping. To avoid code duplication,
> create a new function moxart_mac_unmap_rx(). Nullify unmapped pointers to
> prevent double-unmapping (ex: moxart_mac_stop(), then moxart_remove()).

This makes the code symmetric, which is good.

However, moxart_mac_free_memory() will also free the descriptors,
which is not required. moxart_remove() should undo what the probe did,
nothing more.

	Andrew
