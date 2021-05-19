Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7282E388E1B
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353378AbhESMdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353232AbhESMdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 08:33:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1B22611AE;
        Wed, 19 May 2021 12:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621427505;
        bh=3cBi6fz+/eFP9LuW39RB4wx6VaBTUibEBtExViotDuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MGM0vZrGMOv8kXu2F6kBqWXB8Id2PBrm/vHvZqGg1pTm9t4a6xu5LMyct7Fn0GB/V
         cT9Hopw3g/y7NqlLfXTuIFWyTGsv8UWAQ6BFq+Wa/ymi94ros3bc/90jiZgYHE7RZp
         M+M2hXFnEv8pqEvXjvM737cNe9BkCavdQGnCqfzXawC2S0QGuZcqaFyyAVwWuMD5QF
         tiJgVz46W2ESJyBAjNNX6d+3Wr5zkWa4GAqb14pe3QBh+/XJBCT9wFZGRm7mgwPrNw
         ezKn/6veXJ8XurmDrUZnkixLOrjemUpUnOwHxLsWH0Eval1l7HShCW5dcf67UvfYVZ
         oMZmpCSjR0wSg==
Date:   Wed, 19 May 2021 15:31:41 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        davem@davemloft.net, kuba@kernel.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, aelior@marvell.com,
        mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Dean Balandin <dbalandin@marvell.com>
Subject: Re: [RFC PATCH v5 17/27] qedn: Add qedn probe
Message-ID: <YKUFLVHrUdzEsUeq@unreal>
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-18-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519111340.20613-18-smalin@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 02:13:30PM +0300, Shai Malin wrote:
> This patch introduces the functionality of loading and unloading
> physical function.
> qedn_probe() loads the offload device PF(physical function), and
> initialize the HW and the FW with the PF parameters using the
> HW ops->qed_nvmetcp_ops, which are similar to other "qed_*_ops" which
> are used by the qede, qedr, qedf and qedi device drivers.
> qedn_remove() unloads the offload device PF, re-initialize the HW and
> the FW with the PF parameters.
> 
> The struct qedn_ctx is per PF container for PF-specific attributes and
> resources.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/nvme/hw/Kconfig          |   1 +
>  drivers/nvme/hw/qedn/qedn.h      |  35 +++++++
>  drivers/nvme/hw/qedn/qedn_main.c | 159 ++++++++++++++++++++++++++++++-
>  3 files changed, 190 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/nvme/hw/Kconfig b/drivers/nvme/hw/Kconfig
> index 374f1f9dbd3d..91b1bd6f07d8 100644
> --- a/drivers/nvme/hw/Kconfig
> +++ b/drivers/nvme/hw/Kconfig
> @@ -2,6 +2,7 @@
>  config NVME_QEDN
>  	tristate "Marvell NVM Express over Fabrics TCP offload"
>  	depends on NVME_TCP_OFFLOAD
> +	select QED_NVMETCP
>  	help
>  	  This enables the Marvell NVMe TCP offload support (qedn).
>  
> diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
> index bcd0748a10fd..f13073afbced 100644
> --- a/drivers/nvme/hw/qedn/qedn.h
> +++ b/drivers/nvme/hw/qedn/qedn.h
> @@ -6,14 +6,49 @@
>  #ifndef _QEDN_H_
>  #define _QEDN_H_
>  
> +#include <linux/qed/qed_if.h>
> +#include <linux/qed/qed_nvmetcp_if.h>
> +
>  /* Driver includes */
>  #include "../../host/tcp-offload.h"
>  
> +#define QEDN_MAJOR_VERSION		8
> +#define QEDN_MINOR_VERSION		62
> +#define QEDN_REVISION_VERSION		10
> +#define QEDN_ENGINEERING_VERSION	0
> +#define DRV_MODULE_VERSION __stringify(QEDE_MAJOR_VERSION) "."	\
> +		__stringify(QEDE_MINOR_VERSION) "."		\
> +		__stringify(QEDE_REVISION_VERSION) "."		\
> +		__stringify(QEDE_ENGINEERING_VERSION)
> +

This driver module version is not used in this series and more
important the module version have no meaning in upstream at all
and the community strongly against addition of new such code.

>  #define QEDN_MODULE_NAME "qedn"

And the general note, it will be great if you convert your probe/remove
flows to use auxiliary bus like other drivers that cross subsystems.

Thanks
