Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEBD370728
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 14:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbhEAMTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 08:19:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:35614 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231972AbhEAMTh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 May 2021 08:19:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 487E9B29C;
        Sat,  1 May 2021 12:18:47 +0000 (UTC)
Subject: Re: [RFC PATCH v4 08/27] nvme-tcp-offload: Add nvme-tcp-offload -
 NVMeTCP HW offload ULP
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com,
        Dean Balandin <dbalandin@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
 <20210429190926.5086-9-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7831d4ff-9e47-3c43-8725-95eb0bdd7107@suse.de>
Date:   Sat, 1 May 2021 14:18:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-9-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:09 PM, Shai Malin wrote:
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
>    Includes all common structs and ops to be used and shared by offload
>    drivers.
> 
> - tcp-offload.c:
>    Includes the init function which registers as a NVMf transport just
>    like any other transport.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/host/Kconfig       |  16 +++
>   drivers/nvme/host/Makefile      |   3 +
>   drivers/nvme/host/tcp-offload.c | 126 +++++++++++++++++++
>   drivers/nvme/host/tcp-offload.h | 206 ++++++++++++++++++++++++++++++++
>   4 files changed, 351 insertions(+)
>   create mode 100644 drivers/nvme/host/tcp-offload.c
>   create mode 100644 drivers/nvme/host/tcp-offload.h
> 
It will be tricky to select the correct transport eg when traversing the 
discovery log page; the discovery log page only knows about 'tcp' (not 
'tcp_offload'), so the offload won't be picked up.
But that can we worked on / fixed later on, as it's arguably a policy 
decision.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
