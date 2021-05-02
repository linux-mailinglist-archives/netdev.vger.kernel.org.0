Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B767370B66
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 13:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhEBLzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 07:55:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:47306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230221AbhEBLzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 07:55:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 14CFBB199;
        Sun,  2 May 2021 11:54:59 +0000 (UTC)
Subject: Re: [RFC PATCH v4 25/27] qedn: Add IO level fastpath functionality
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com
References: <20210429190926.5086-1-smalin@marvell.com>
 <20210429190926.5086-26-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <92c994a9-004e-55b0-b345-6c555953bab0@suse.de>
Date:   Sun, 2 May 2021 13:54:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-26-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:09 PM, Shai Malin wrote:
> This patch will present the IO level functionality of qedn
> nvme-tcp-offload host mode. The qedn_task_ctx structure is containing
> various params and state of the current IO, and is mapped 1x1 to the
> fw_task_ctx which is a HW and FW IO context.
> A qedn_task is mapped directly to its parent connection.
> For every new IO a qedn_task structure will be assigned and they will be
> linked for the entire IO's life span.
> 
> The patch will include 2 flows:
>    1. Send new command to the FW:
> 	 The flow is: nvme_tcp_ofld_queue_rq() which invokes qedn_send_req()
> 	 which invokes qedn_queue_request() which will:
>       - Assign fw_task_ctx.
> 	 - Prepare the Read/Write SG buffer.
> 	 -  Initialize the HW and FW context.
> 	 - Pass the IO to the FW.
> 
>    2. Process the IO completion:
>       The flow is: qedn_irq_handler() which invokes qedn_fw_cq_fp_handler()
> 	 which invokes qedn_io_work_cq() which will:
> 	 - process the FW completion.
> 	 - Return the fw_task_ctx to the task pool.
> 	 - complete the nvme req.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/hw/qedn/qedn.h      |   4 +
>   drivers/nvme/hw/qedn/qedn_conn.c |   1 +
>   drivers/nvme/hw/qedn/qedn_task.c | 269 ++++++++++++++++++++++++++++++-
>   3 files changed, 272 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
