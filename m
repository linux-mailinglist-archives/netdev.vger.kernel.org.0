Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B9626E653
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgIQULm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgIQULj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 16:11:39 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E0AE20707;
        Thu, 17 Sep 2020 19:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600371264;
        bh=qyJdM6F52/Q1voZiWeq2UVFE1j/RfRq6JpEmt5HrtKs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nl87bhq0c52XQGZSTqrkMQjJQK2LDpZiLIfNrMmyTyp4HjdmKZyyA/GVJn1T7cv2y
         1ztlfS7jeG9uKgfG0hM9TalYvO6pW26KOD6++2q2bwpphVrqgkvJWEPM09Y322unKU
         nuYQBxFPoXB2fhaYjnMpZYM/BHBSSU5Hmh7UpXFw=
Message-ID: <ef456db1319b0ef390afd3ca7e7f204721d2484c.camel@kernel.org>
Subject: Re: [PATCH -next] vdpa: mlx5: select VHOST to fix build errors
From:   Saeed Mahameed <saeed@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Thu, 17 Sep 2020 12:34:23 -0700
In-Reply-To: <f47e2bab-c19c-fab5-cfb9-e2b5ba1be69a@infradead.org>
References: <f47e2bab-c19c-fab5-cfb9-e2b5ba1be69a@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-09-17 at 11:58 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> drivers/vdpa/mlx5/ uses vhost_iotlb*() interfaces, so select
> VHOST to eliminate build errors.
> 
> ld: drivers/vdpa/mlx5/core/mr.o: in function `add_direct_chain':
> mr.c:(.text+0x106): undefined reference to `vhost_iotlb_itree_first'
> ld: mr.c:(.text+0x1cf): undefined reference to
> `vhost_iotlb_itree_next'
> ld: mr.c:(.text+0x30d): undefined reference to
> `vhost_iotlb_itree_first'
> ld: mr.c:(.text+0x3e8): undefined reference to
> `vhost_iotlb_itree_next'
> ld: drivers/vdpa/mlx5/core/mr.o: in function `_mlx5_vdpa_create_mr':
> mr.c:(.text+0x908): undefined reference to `vhost_iotlb_itree_first'
> ld: mr.c:(.text+0x9e6): undefined reference to
> `vhost_iotlb_itree_next'
> ld: drivers/vdpa/mlx5/core/mr.o: in function
> `mlx5_vdpa_handle_set_map':
> mr.c:(.text+0xf1d): undefined reference to `vhost_iotlb_itree_first'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: netdev@vger.kernel.org
> ---
> Note: This patch may not be the right thing, but it fixes the build
> errors.
> 
>  drivers/vdpa/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20200917.orig/drivers/vdpa/Kconfig
> +++ linux-next-20200917/drivers/vdpa/Kconfig
> @@ -32,6 +32,7 @@ config IFCVF
>  config MLX5_VDPA
>  	bool "MLX5 VDPA support library for ConnectX devices"
>  	depends on MLX5_CORE
> +	select VHOST

select keyword usually complicates things.
It is better if you add a dependency rather than forcing VHOST.
Just do:
depends on VHOST & MLX5_CORE

>  	default n
>  	help
>  	  Support library for Mellanox VDPA drivers. Provides code that
> is
> 

