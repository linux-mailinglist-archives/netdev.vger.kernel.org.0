Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC93422551
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 23:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbfERV6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 17:58:07 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:36093 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbfERV6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 May 2019 17:58:07 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 40AA84047;
        Sat, 18 May 2019 23:58:04 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id f66b25c1;
        Sat, 18 May 2019 23:58:02 +0200 (CEST)
Date:   Sat, 18 May 2019 23:58:02 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Octavio Alvarez <octallk1@alvarezp.org>
Cc:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: PROBLEM: [1/2] Marvell 88E8040 (sky2) stopped working
Message-ID: <20190518215802.GI63920@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <26edfbe4-3c62-184b-b4cc-3d89f21ae394@alvarezp.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26edfbe4-3c62-184b-b4cc-3d89f21ae394@alvarezp.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Octavio,

> PROBLEM: [1/2] Marvell 88E8040 (sky2) stopped working

I'm sorry, that I've ruined your day.

> Linux version 5.1.0-12511-g72cf0b07418a (alvarezp@alvarezp-samsung)

What do I need to do/apply in order to get the same source tree with
72cf0b07418a hash? I'm not able to find that commit.

> [    1.447809] BUG: kernel NULL pointer dereference, address:
> 0000000000000000

Interesting.

> [    1.448476] RIP: 0010:sky2_init_netdev+0x221/0x2e0 [sky2]

 gdb drivers/net/ethernet/marvell/sky2.o
 >>> l *sky2_init_netdev+0x221
 0x828a is in sky2_init_netdev (./include/linux/etherdevice.h:124).
 119	 * By definition the broadcast address is also a multicast address.
 120	 */
 121	static inline bool is_multicast_ether_addr(const u8 *addr)
 122	{
 123	#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 124		u32 a = *(const u32 *)addr;
 125	#else
 126		u16 a = *(const u16 *)addr;
 127	#endif
 128	#ifdef __BIG_ENDIAN

> --- a/drivers/net/ethernet/marvell/sky2.c
> +++ b/drivers/net/ethernet/marvell/sky2.c
> @@ -4808,7 +4808,7 @@ static struct net_device *sky2_init_netdev(struct
> sky2_hw *hw, unsigned port,
>          * 2) from internal registers set by bootloader
>          */
>         iap = of_get_mac_address(hw->pdev->dev.of_node);
> -       if (iap)
> +       if (!IS_ERR(iap))

I'm just shooting out of the blue, as I don't have currently any rational
explanation for that now, but could you please change the line above to
following:

          if (!IS_ERR_OR_NULL(iap))

try again and report back? Thanks!

-- ynezz
