Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C55E1C9B18
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 21:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgEGTaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 15:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgEGTaA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 15:30:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B51720CC7;
        Thu,  7 May 2020 19:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588879799;
        bh=pXnEGT4dONImvx6xzc21bnn5kRprj8/jQkS/jDE/T+g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cgu9DhUyhRRs/iF2OpKadRWe/PhrUTERE33DbcFdb/Ujw4Drbwfwg/jY5gZwoKXZQ
         pvhH4N3xlleL2mat9ACSnhiwYHzRniyR6Gxr5c2PFpFyJxzS++JLKWFNO7Y0tP7eeT
         1p0SfUnTpnPlKDN++ARbZEacxaQY8C39f1oNvLWQ=
Date:   Thu, 7 May 2020 12:29:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: Re: [PATCH net-next 7/7] net: atlantic: unify get_mac_permanent
Message-ID: <20200507122957.5dd4b84b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200507081510.2120-8-irusskikh@marvell.com>
References: <20200507081510.2120-1-irusskikh@marvell.com>
        <20200507081510.2120-8-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 May 2020 11:15:10 +0300 Igor Russkikh wrote:
> From: Mark Starovoytov <mstarovoitov@marvell.com>
> 
> MAC generation in case if MAC is not populated is the same for both A1 and
> A2.
> This patch moves MAC generation into a separate function, which is called
> from both places to reduce the amount of copy/paste.

Right, but why do you have your own mac generation rather than using
eth_hw_addr_random(). You need to set NET_ADDR_RANDOM for example,
just use standard helpers, please.

> Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> ---
>  .../ethernet/aquantia/atlantic/aq_hw_utils.c  | 41 +++++++++++++++++--
>  .../ethernet/aquantia/atlantic/aq_hw_utils.h  |  9 ++--
>  .../atlantic/hw_atl/hw_atl_utils_fw2x.c       | 23 +----------
>  .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 24 ++---------
>  4 files changed, 49 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
> index 7dbf49adcea6..0bc01772ead2 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_hw_utils.c
> @@ -1,7 +1,8 @@
>  // SPDX-License-Identifier: GPL-2.0-only
> -/*
> - * aQuantia Corporation Network Driver
> - * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
> +/* Atlantic Network Driver
> + *
> + * Copyright (C) 2014-2019 aQuantia Corporation
> + * Copyright (C) 2019-2020 Marvell International Ltd.
>   */
>  
>  /* File aq_hw_utils.c: Definitions of helper functions used across
> @@ -79,3 +80,37 @@ int aq_hw_err_from_flags(struct aq_hw_s *hw)
>  err_exit:
>  	return err;
>  }
> +
> +static inline bool aq_hw_is_zero_ether_addr(const u8 *addr)

No static inlines in C files, please. Let compiler decide inlineing &
generate a warning when function becomes unused.

> +{
> +	return (*(const u16 *)(addr) | addr[2]) == 0;

It's probably fine in practice but the potentially u16 read is entirely
unnecessary. This is not performance sensitive code.

> +}
> +
> +bool aq_hw_is_valid_ether_addr(const u8 *addr)
> +{
> +	return !is_multicast_ether_addr(addr) &&
> +	       !aq_hw_is_zero_ether_addr(addr);
> +}
> +
> +void aq_hw_eth_random_addr(u8 *mac)
> +{
> +	unsigned int rnd = 0;
> +	u32 h = 0U;
> +	u32 l = 0U;
> +
> +	get_random_bytes(&rnd, sizeof(unsigned int));
> +	l = 0xE300 0000U | (0xFFFFU & rnd) | (0x00 << 16);
> +	h = 0x8001300EU;
> +
> +	mac[5] = (u8)(0xFFU & l);
> +	l >>= 8;
> +	mac[4] = (u8)(0xFFU & l);
> +	l >>= 8;
> +	mac[3] = (u8)(0xFFU & l);
> +	l >>= 8;
> +	mac[2] = (u8)(0xFFU & l);
> +	mac[1] = (u8)(0xFFU & h);
> +	h >>= 8;
> +	mac[0] = (u8)(0xFFU & h);

This can be greatly simplified using helpers from etherdevice.h, if
it's really needed.

> +}

