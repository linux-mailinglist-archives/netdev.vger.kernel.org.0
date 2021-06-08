Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229D539F24F
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 11:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhFHJas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 05:30:48 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36752 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFHJar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 05:30:47 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 65DB8219BD;
        Tue,  8 Jun 2021 09:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623144534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ApQjojFmYK9xInKxu2RlyXp4GgfPzo0whl3Ae6gpdDg=;
        b=peTV3z7ImOA3W/CpxJ3LYbOGv1uJPlVMDN7dUO96UXqkW1xVpDt1X9t9hdQebiiB0+yUHO
        0YbwgH3BBBgO5o0yi34wWDryx3KeElcX9VgndlBPD1nI3qrKT0kBx2p4TcWILUraNC+Ij/
        umnxOKFPDtyLELFx+BOMgBurGzcxfkU=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3187FA3B96;
        Tue,  8 Jun 2021 09:28:54 +0000 (UTC)
Date:   Tue, 8 Jun 2021 11:28:53 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        davem@davemloft.net, kuba@kernel.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, aelior@marvell.com,
        mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Dean Balandin <dbalandin@marvell.com>
Subject: Re: [RFC PATCH v5 01/27] nvme-tcp-offload: Add nvme-tcp-offload -
 NVMeTCP HW offload ULP
Message-ID: <YL84VamVh78Ds2Eg@alley>
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-2-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519111340.20613-2-smalin@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2021-05-19 14:13:14, Shai Malin wrote:
> This patch will present the structure for the NVMeTCP offload common
> layer driver. This module is added under "drivers/nvme/host/" and future
> offload drivers which will register to it will be placed under
> "drivers/nvme/hw".
> This new driver will be enabled by the Kconfig "NVM Express over Fabrics
> TCP offload commmon layer".
> In order to support the new transport type, for host mode, no change is
> needed.
> 
> Each new vendor-specific offload driver will register to this ULP during
> its probe function, by filling out the nvme_tcp_ofld_dev->ops and
> nvme_tcp_ofld_dev->private_data and calling nvme_tcp_ofld_register_dev
> with the initialized struct.
> 
> The internal implementation:
> - tcp-offload.h:
>   Includes all common structs and ops to be used and shared by offload
>   drivers.
> 
> - tcp-offload.c:
>   Includes the init function which registers as a NVMf transport just
>   like any other transport.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

> --- a/drivers/nvme/host/Kconfig
> +++ b/drivers/nvme/host/Kconfig
> @@ -84,3 +84,19 @@ config NVME_TCP
>  	  from https://github.com/linux-nvme/nvme-cli.
>  
>  	  If unsure, say N.
> +
> +config NVME_TCP_OFFLOAD
> +	tristate "NVM Express over Fabrics TCP offload common layer"
> +	default m

Is this intentional, please?

> +	depends on INET
> +	depends on BLK_DEV_NVME
> +	select NVME_FABRICS
> +	help
> +	  This provides support for the NVMe over Fabrics protocol using
> +	  the TCP offload transport. This allows you to use remote block devices
> +	  exported using the NVMe protocol set.
> +
> +	  To configure a NVMe over Fabrics controller use the nvme-cli tool
> +	  from https://github.com/linux-nvme/nvme-cli.
> +
> +	  If unsure, say N.

I would expect that the default would be "n" so that people that are
not sure or do not care about NWMe just take the default. IMHO, it is
the usual behavior.

Best Regards,
Petr
