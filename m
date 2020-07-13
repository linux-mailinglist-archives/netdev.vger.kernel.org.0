Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CA021E2D6
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGMWH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:07:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgGMWH0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 18:07:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D78420663;
        Mon, 13 Jul 2020 22:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594678046;
        bh=b/WR+TM0JrN6blYLDH2UMkzVtAwR8YOSVi6HWlMMjsg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lX0zOmKIxs/cENpAbh/1fnz4sTpi9NIVx3T+4afRZ8Qzy91Qqx6UpB0G6GVzx7sLX
         wDsB1EbsGJ0/D9HaQGfT3rHxWAdqt/U/2Gem7p2ubX5dAkBsa5udPcPW+psQKQoMnC
         uXTseGR3gPdPbSjXe+LFx6JCyHM9qjWeRmiWb7NU=
Date:   Mon, 13 Jul 2020 15:07:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Pavel Belous <pbelous@marvell.com>
Subject: Re: [PATCH net-next 06/10] net: atlantic: add support for 64-bit
 reads/writes
Message-ID: <20200713150724.2e57e905@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200713114233.436-7-irusskikh@marvell.com>
References: <20200713114233.436-1-irusskikh@marvell.com>
        <20200713114233.436-7-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 14:42:29 +0300 Igor Russkikh wrote:
> +#ifdef CONFIG_X86_64
> +	if (hw->aq_nic_cfg->aq_hw_caps->op64bit)
> +		value = readq(hw->mmio + reg);
> +	else
> +#endif
> +	{
> +		value = aq_hw_read_reg(hw, reg);
> +		value |= (u64)aq_hw_read_reg(hw, reg + 4) << 32;
> +	}

I think you just need to include something like:

#include <linux/io-64-nonatomic-lo-hi.h>

You seem to always access the lower half first.
