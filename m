Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E090437072B
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 14:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhEAM0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 08:26:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:38634 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231960AbhEAM0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 May 2021 08:26:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C8910B172;
        Sat,  1 May 2021 12:25:22 +0000 (UTC)
Subject: Re: [RFC PATCH v4 10/27] nvme-tcp-offload: Add device scan
 implementation
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com,
        Dean Balandin <dbalandin@marvell.com>
References: <20210429190926.5086-1-smalin@marvell.com>
 <20210429190926.5086-11-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <02a740cd-e765-1197-9c5d-78ce602ba7a1@suse.de>
Date:   Sat, 1 May 2021 14:25:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-11-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:09 PM, Shai Malin wrote:
> From: Dean Balandin <dbalandin@marvell.com>
> 
> As part of create_ctrl(), it scans the registered devices and calls
> the claim_dev op on each of them, to find the first devices that matches
> the connection params. Once the correct devices is found (claim_dev
> returns true), we raise the refcnt of that device and return that device
> as the device to be used for ctrl currently being created.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/host/tcp-offload.c | 94 +++++++++++++++++++++++++++++++++
>   1 file changed, 94 insertions(+)
> 
> diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> index 711232eba339..aa7cc239abf2 100644
> --- a/drivers/nvme/host/tcp-offload.c
> +++ b/drivers/nvme/host/tcp-offload.c
> @@ -13,6 +13,11 @@
>   static LIST_HEAD(nvme_tcp_ofld_devices);
>   static DECLARE_RWSEM(nvme_tcp_ofld_devices_rwsem);
>   
> +static inline struct nvme_tcp_ofld_ctrl *to_tcp_ofld_ctrl(struct nvme_ctrl *nctrl)
> +{
> +	return container_of(nctrl, struct nvme_tcp_ofld_ctrl, nctrl);
> +}
> +
>   /**
>    * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
>    * function.
> @@ -98,6 +103,94 @@ void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
>   	/* Placeholder - complete request with/without error */
>   }
>   
> +struct nvme_tcp_ofld_dev *
> +nvme_tcp_ofld_lookup_dev(struct nvme_tcp_ofld_ctrl *ctrl)
> +{
> +	struct nvme_tcp_ofld_dev *dev;
> +
> +	down_read(&nvme_tcp_ofld_devices_rwsem);
> +	list_for_each_entry(dev, &nvme_tcp_ofld_devices, entry) {
> +		if (dev->ops->claim_dev(dev, &ctrl->conn_params)) {
> +			/* Increase driver refcnt */
> +			if (!try_module_get(dev->ops->module)) {
> +				pr_err("try_module_get failed\n");
> +				dev = NULL;
> +			}
> +
> +			goto out;
> +		}
> +	}
> +
> +	dev = NULL;
> +out:
> +	up_read(&nvme_tcp_ofld_devices_rwsem);
> +
> +	return dev;
> +}
> +
> +static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
> +{
> +	/* Placeholder - validates inputs and creates admin and IO queues */
> +
> +	return 0;
> +}
> +
> +static struct nvme_ctrl *
> +nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_options *opts)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl;
> +	struct nvme_tcp_ofld_dev *dev;
> +	struct nvme_ctrl *nctrl;
> +	int rc = 0;
> +
> +	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
> +	if (!ctrl)
> +		return ERR_PTR(-ENOMEM);
> +
> +	nctrl = &ctrl->nctrl;
> +
> +	/* Init nvme_tcp_ofld_ctrl and nvme_ctrl params based on received opts */
> +
> +	/* Find device that can reach the dest addr */
> +	dev = nvme_tcp_ofld_lookup_dev(ctrl);
> +	if (!dev) {
> +		pr_info("no device found for addr %s:%s.\n",
> +			opts->traddr, opts->trsvcid);
> +		rc = -EINVAL;
> +		goto out_free_ctrl;
> +	}
> +
> +	ctrl->dev = dev;
> +
> +	if (ctrl->dev->ops->max_hw_sectors)
> +		nctrl->max_hw_sectors = ctrl->dev->ops->max_hw_sectors;
> +	if (ctrl->dev->ops->max_segments)
> +		nctrl->max_segments = ctrl->dev->ops->max_segments;
> +
> +	/* Init queues */
> +
> +	/* Call nvme_init_ctrl */
> +
> +	rc = ctrl->dev->ops->setup_ctrl(ctrl, true);
> +	if (rc)
> +		goto out_module_put;
> +
> +	rc = nvme_tcp_ofld_setup_ctrl(nctrl, true);
> +	if (rc)
> +		goto out_uninit_ctrl;
> +
> +	return nctrl;
> +
> +out_uninit_ctrl:
> +	ctrl->dev->ops->release_ctrl(ctrl);
> +out_module_put:
> +	module_put(dev->ops->module);
> +out_free_ctrl:
> +	kfree(ctrl);
> +
> +	return ERR_PTR(rc);
> +}
> +
>   static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
>   	.name		= "tcp_offload",
>   	.module		= THIS_MODULE,
> @@ -107,6 +200,7 @@ static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
>   			  NVMF_OPT_RECONNECT_DELAY | NVMF_OPT_HDR_DIGEST |
>   			  NVMF_OPT_DATA_DIGEST | NVMF_OPT_NR_POLL_QUEUES |
>   			  NVMF_OPT_TOS,
> +	.create_ctrl	= nvme_tcp_ofld_create_ctrl,
>   };
>   
>   static int __init nvme_tcp_ofld_init_module(void)
> 
I wonder if we shouldn't take the approach from Martin Belanger, and 
introduce a new option 'host_iface' to select the interface to use.
That is, _if_ the nvme-tcp offload driver would present itself as a 
network interface; one might argue that it would put too much 
restriction on the implementations.
But if it does not present itself as a network interface, how do we 
address it? And if it does, wouldn't we be better off to specify the 
interface directly, and not try to imply the interface from the IP address?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
