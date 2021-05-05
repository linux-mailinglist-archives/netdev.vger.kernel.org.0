Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B374C3734BA
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 07:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhEEFdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 01:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhEEFdl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 01:33:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5F816101C;
        Wed,  5 May 2021 05:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620192765;
        bh=eiQCf1dLQWj8H9E4qPkyTSvxlC8PV5M5PrwcasMAhk8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JO4YLBoYE4iTp5W7L815FxnrtJk2NGdUjupo6WXwhvWW8GwLKmQCDIw5k7l11ibzr
         7Dj63lsBek7Hf9ZVbc+sT8biepOWSw9Bf9YGXAf5SjtTZQp8VVKf9xtpvSFe/ah020
         iPZH0KkkF7LdWmpfZ3KTOu+QeO+QFgYon2gliaUz9I2QSAaVAUj078mypokd26+J2u
         7e9nCUcvIpsf067DObVM4sCtFgRcPDe7ITnYCORpICiiW+meQtt2XRaU+vqMToG7IK
         DqZ3lDaGL6XF/KO0rEBuHGUYxLBlK0W6sRD4omzH5jSXSEzunWq2Oe6IkoOURqFvrb
         PD19d5bKlpePA==
Date:   Wed, 5 May 2021 08:32:41 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH v2 net] ionic: fix ptp support config breakage
Message-ID: <YJIt+cm6dAOQmU0g@unreal>
References: <20210505000059.59760-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505000059.59760-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 05:00:59PM -0700, Shannon Nelson wrote:
> Driver link failed with undefined references in some
> kernel config variations.
> 
> v2 - added Fixes tag

Changelogs should be below "---" line.
We don't need them in commit message history.

> 
> Fixes: 61db421da31b ("ionic: link in the new hw timestamp code")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/Makefile    | 3 +--
>  drivers/net/ethernet/pensando/ionic/ionic_phc.c | 3 +++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
> index 4e7642a2d25f..61c40169cb1f 100644
> --- a/drivers/net/ethernet/pensando/ionic/Makefile
> +++ b/drivers/net/ethernet/pensando/ionic/Makefile
> @@ -5,5 +5,4 @@ obj-$(CONFIG_IONIC) := ionic.o
>  
>  ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
>  	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
> -	   ionic_txrx.o ionic_stats.o ionic_fw.o
> -ionic-$(CONFIG_PTP_1588_CLOCK) += ionic_phc.o
> +	   ionic_txrx.o ionic_stats.o ionic_fw.o ionic_phc.o
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
> index a87c87e86aef..30c78808c45a 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
> @@ -1,6 +1,8 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright(c) 2017 - 2021 Pensando Systems, Inc */
>  
> +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)

I'm not sure, but think that IS_ENABLED() is intended to be used inside
functions/macros as boolean expression.

For other places like this, "#if CONFIG_PTP_1588_CLOCK" is better fit.

Thanks
