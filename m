Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533B838D0F1
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 00:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhEUWQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 18:16:05 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:35589 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbhEUWPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 18:15:05 -0400
Received: by mail-wr1-f44.google.com with SMTP id a4so22441534wrr.2
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 15:13:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IxSQjVE6BoF+TFgs0otfqF6Tm/CUmp7dqmW/leZzgAU=;
        b=IfEc0q7nbdlF/qssTbzAim0c7NrH22Z+oggfxPYIDcg6q/Pic9D5RuqzjnHX6yI64g
         KiG4lPmRMXkKlxN9CNtrsUbPzo5tydXj48e5rXevzr6FYoH4XeK8h8sPtWqKTVV9SpmZ
         VNckrC9/CVUN4gmo95zo+wuEPwVqJB00H4Q2gEPdTFbUCkU6XuIutGDhirTCqjXz0MJs
         cdPSQe8RH5joKp4QZFIIOJ/vFqT/lP55hA+l31hmC0jSZFXzxEZwldbKBiEBwjf6Wz7J
         s/B/6muq7mCYZXPUIx6qVPjQrSvndnq9fEXGNjFWAjCyBqbT9htKFJqeafaOE9ynsXOl
         L/1A==
X-Gm-Message-State: AOAM530inAbQj6fBIj9wzfO+6xRtBky3VtEYA9mnQHJwtw4GqzvZkw+n
        lNji2sTypYTbQN8pI33ceOs=
X-Google-Smtp-Source: ABdhPJyFgLfqmIooqcegw3qxzGy1rNNrHYr2cLJLfCGL3sfXaaeXqrq5S4UzOxM/N2/b5tD3nb6Ehw==
X-Received: by 2002:adf:f0ca:: with SMTP id x10mr11878204wro.40.1621635219939;
        Fri, 21 May 2021 15:13:39 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:66b2:1988:438b:4253? ([2601:647:4802:9070:66b2:1988:438b:4253])
        by smtp.gmail.com with ESMTPSA id 188sm842167wma.7.2021.05.21.15.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 15:13:39 -0700 (PDT)
Subject: Re: [RFC PATCH v5 01/27] nvme-tcp-offload: Add nvme-tcp-offload -
 NVMeTCP HW offload ULP
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, hch@lst.de, axboe@fb.com, kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Dean Balandin <dbalandin@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-2-smalin@marvell.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <1df61e8a-c579-e945-ec13-9155b86bbbf4@grimberg.me>
Date:   Fri, 21 May 2021 15:13:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210519111340.20613-2-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/21 4:13 AM, Shai Malin wrote:
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
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>   MAINTAINERS                     |   8 ++
>   drivers/nvme/host/Kconfig       |  16 +++
>   drivers/nvme/host/Makefile      |   3 +
>   drivers/nvme/host/tcp-offload.c | 126 +++++++++++++++++++
>   drivers/nvme/host/tcp-offload.h | 212 ++++++++++++++++++++++++++++++++
>   5 files changed, 365 insertions(+)
>   create mode 100644 drivers/nvme/host/tcp-offload.c
>   create mode 100644 drivers/nvme/host/tcp-offload.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bd7aff0c120f..49a4a73ea1c7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13092,6 +13092,14 @@ F:	drivers/nvme/host/
>   F:	include/linux/nvme.h
>   F:	include/uapi/linux/nvme_ioctl.h
>   
> +NVM EXPRESS TCP OFFLOAD TRANSPORT DRIVERS
> +M:	Shai Malin <smalin@marvell.com>
> +M:	Ariel Elior <aelior@marvell.com>
> +L:	linux-nvme@lists.infradead.org
> +S:	Supported
> +F:	drivers/nvme/host/tcp-offload.c
> +F:	drivers/nvme/host/tcp-offload.h
> +
>   NVM EXPRESS FC TRANSPORT DRIVERS
>   M:	James Smart <james.smart@broadcom.com>
>   L:	linux-nvme@lists.infradead.org
> diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
> index a44d49d63968..6e869e94e67f 100644
> --- a/drivers/nvme/host/Kconfig
> +++ b/drivers/nvme/host/Kconfig
> @@ -84,3 +84,19 @@ config NVME_TCP
>   	  from https://github.com/linux-nvme/nvme-cli.
>   
>   	  If unsure, say N.
> +
> +config NVME_TCP_OFFLOAD
> +	tristate "NVM Express over Fabrics TCP offload common layer"
> +	default m
> +	depends on INET
> +	depends on BLK_DEV_NVME

This needs to be: select NVME_CORE

In fact, I've sent a patch that fixes that for nvme-tcp..

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
> diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
> index cbc509784b2e..3c3fdf83ce38 100644
> --- a/drivers/nvme/host/Makefile
> +++ b/drivers/nvme/host/Makefile
> @@ -8,6 +8,7 @@ obj-$(CONFIG_NVME_FABRICS)		+= nvme-fabrics.o
>   obj-$(CONFIG_NVME_RDMA)			+= nvme-rdma.o
>   obj-$(CONFIG_NVME_FC)			+= nvme-fc.o
>   obj-$(CONFIG_NVME_TCP)			+= nvme-tcp.o
> +obj-$(CONFIG_NVME_TCP_OFFLOAD)	+= nvme-tcp-offload.o
>   
>   nvme-core-y				:= core.o ioctl.o
>   nvme-core-$(CONFIG_TRACING)		+= trace.o
> @@ -26,3 +27,5 @@ nvme-rdma-y				+= rdma.o
>   nvme-fc-y				+= fc.o
>   
>   nvme-tcp-y				+= tcp.o
> +
> +nvme-tcp-offload-y		+= tcp-offload.o
> diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> new file mode 100644
> index 000000000000..711232eba339
> --- /dev/null
> +++ b/drivers/nvme/host/tcp-offload.c
> @@ -0,0 +1,126 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright 2021 Marvell. All rights reserved.
> + */
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +/* Kernel includes */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +/* Driver includes */
> +#include "tcp-offload.h"
> +
> +static LIST_HEAD(nvme_tcp_ofld_devices);
> +static DECLARE_RWSEM(nvme_tcp_ofld_devices_rwsem);

Why is that a rwsem?

> +
> +/**
> + * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
> + * function.
> + * @dev:	NVMeTCP offload device instance to be registered to the
> + *		common tcp offload instance.
> + *
> + * API function that registers the type of vendor specific driver
> + * being implemented to the common NVMe over TCP offload library. Part of
> + * the overall init sequence of starting up an offload driver.
> + */
> +int nvme_tcp_ofld_register_dev(struct nvme_tcp_ofld_dev *dev)
> +{
> +	struct nvme_tcp_ofld_ops *ops = dev->ops;
> +
> +	if (!ops->claim_dev ||
> +	    !ops->setup_ctrl ||
> +	    !ops->release_ctrl ||
> +	    !ops->create_queue ||
> +	    !ops->drain_queue ||
> +	    !ops->destroy_queue ||
> +	    !ops->poll_queue ||
> +	    !ops->init_req ||
> +	    !ops->send_req ||
> +	    !ops->commit_rqs)
> +		return -EINVAL;
> +
> +	down_write(&nvme_tcp_ofld_devices_rwsem);
> +	list_add_tail(&dev->entry, &nvme_tcp_ofld_devices);
> +	up_write(&nvme_tcp_ofld_devices_rwsem);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(nvme_tcp_ofld_register_dev);
> +
> +/**
> + * nvme_tcp_ofld_unregister_dev() - NVMeTCP Offload Library unregistration
> + * function.
> + * @dev:	NVMeTCP offload device instance to be unregistered from the
> + *		common tcp offload instance.
> + *
> + * API function that unregisters the type of vendor specific driver being
> + * implemented from the common NVMe over TCP offload library.
> + * Part of the overall exit sequence of unloading the implemented driver.
> + */
> +void nvme_tcp_ofld_unregister_dev(struct nvme_tcp_ofld_dev *dev)
> +{
> +	down_write(&nvme_tcp_ofld_devices_rwsem);
> +	list_del(&dev->entry);
> +	up_write(&nvme_tcp_ofld_devices_rwsem);
> +}
> +EXPORT_SYMBOL_GPL(nvme_tcp_ofld_unregister_dev);
> +
> +/**
> + * nvme_tcp_ofld_report_queue_err() - NVMeTCP Offload report error event
> + * callback function. Pointed to by nvme_tcp_ofld_queue->report_err.
> + * @queue:	NVMeTCP offload queue instance on which the error has occurred.
> + *
> + * API function that allows the vendor specific offload driver to reports errors
> + * to the common offload layer, to invoke error recovery.
> + */
> +int nvme_tcp_ofld_report_queue_err(struct nvme_tcp_ofld_queue *queue)
> +{

No semantics into what was the error?

> +	/* Placeholder - invoke error recovery flow */
> +
> +	return 0;
> +}
> +
> +/**
> + * nvme_tcp_ofld_req_done() - NVMeTCP Offload request done callback
> + * function. Pointed to by nvme_tcp_ofld_req->done.
> + * Handles both NVME_TCP_F_DATA_SUCCESS flag and NVMe CQ.
> + * @req:	NVMeTCP offload request to complete.
> + * @result:     The nvme_result.
> + * @status:     The completion status.
> + *
> + * API function that allows the vendor specific offload driver to report request
> + * completions to the common offload layer.
> + */
> +void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
> +			    union nvme_result *result,
> +			    __le16 status)
> +{

Why do you need to pass back the result? Isn't that a part
of the request?

> +	/* Placeholder - complete request with/without error */
> +}
> +
> +static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
> +	.name		= "tcp_offload",
> +	.module		= THIS_MODULE,
> +	.required_opts	= NVMF_OPT_TRADDR,
> +	.allowed_opts	= NVMF_OPT_TRSVCID | NVMF_OPT_NR_WRITE_QUEUES  |
> +			  NVMF_OPT_HOST_TRADDR | NVMF_OPT_CTRL_LOSS_TMO |
> +			  NVMF_OPT_RECONNECT_DELAY | NVMF_OPT_HDR_DIGEST |
> +			  NVMF_OPT_DATA_DIGEST | NVMF_OPT_NR_POLL_QUEUES |
> +			  NVMF_OPT_TOS,
> +};
> +
> +static int __init nvme_tcp_ofld_init_module(void)
> +{
> +	nvmf_register_transport(&nvme_tcp_ofld_transport);
> +
> +	return 0;
> +}
> +
> +static void __exit nvme_tcp_ofld_cleanup_module(void)
> +{
> +	nvmf_unregister_transport(&nvme_tcp_ofld_transport);
> +}
> +
> +module_init(nvme_tcp_ofld_init_module);
> +module_exit(nvme_tcp_ofld_cleanup_module);
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/nvme/host/tcp-offload.h b/drivers/nvme/host/tcp-offload.h
> new file mode 100644
> index 000000000000..949132ce2ed4
> --- /dev/null
> +++ b/drivers/nvme/host/tcp-offload.h
> @@ -0,0 +1,212 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright 2021 Marvell. All rights reserved.
> + */
> +
> +/* Linux includes */
> +#include <linux/dma-mapping.h>
> +#include <linux/scatterlist.h>
> +#include <linux/types.h>
> +#include <linux/nvme-tcp.h>
> +
> +/* Driver includes */
> +#include "nvme.h"
> +#include "fabrics.h"
> +
> +/* Forward declarations */
> +struct nvme_tcp_ofld_ops;
> +
> +/* Representation of a vendor-specific device. This is the struct used to
> + * register to the offload layer by the vendor-specific driver during its probe
> + * function.
> + * Allocated by vendor-specific driver.
> + */
> +struct nvme_tcp_ofld_dev {
> +	struct list_head entry;
> +	struct net_device *ndev;
> +	struct nvme_tcp_ofld_ops *ops;
> +
> +	/* Vendor specific driver context */
> +	void *private_data;

Usually there is private_data pointer when the upper layer
passes a struct to the lower layer to initialize, that is
not the case here, why don't the device driver just use
container_of to access its internal representation?

> +	int num_hw_vectors;
> +};
> +
> +/* Per IO struct holding the nvme_request and command
> + * Allocated by blk-mq.
> + */
> +struct nvme_tcp_ofld_req {
> +	struct nvme_request req;
> +	struct nvme_command nvme_cmd;
> +	struct list_head queue_entry;
> +	struct nvme_tcp_ofld_queue *queue;
> +	struct request *rq;

Why is there an explicit rq pointer? there are converters from
rq to driver req struct and vice-versa.

> +
> +	/* Vendor specific driver context */
> +	void *private_data;
> +
> +	bool async;
> +	bool last;

Undocumented and unclear why these are needed.

> +
> +	void (*done)(struct nvme_tcp_ofld_req *req,
> +		     union nvme_result *result,
> +		     __le16 status);
> +};
> +
> +enum nvme_tcp_ofld_queue_flags {
> +	NVME_TCP_OFLD_Q_ALLOCATED = 0,
> +	NVME_TCP_OFLD_Q_LIVE = 1,
> +};
> +
> +/* Allocated by nvme_tcp_ofld */
> +struct nvme_tcp_ofld_queue {
> +	/* Offload device associated to this queue */
> +	struct nvme_tcp_ofld_dev *dev;
> +	struct nvme_tcp_ofld_ctrl *ctrl;
> +	unsigned long flags;
> +	size_t cmnd_capsule_len;
> +
> +	u8 hdr_digest;
> +	u8 data_digest;
> +	u8 tos;
> +
> +	/* Vendor specific driver context */
> +	void *private_data;
> +
> +	/* Error callback function */
> +	int (*report_err)(struct nvme_tcp_ofld_queue *queue);
> +};
> +
> +/* Connectivity (routing) params used for establishing a connection */
> +struct nvme_tcp_ofld_ctrl_con_params {
> +	/* Input params */
> +	struct sockaddr_storage remote_ip_addr;
> +
> +	/* If NVMF_OPT_HOST_TRADDR is provided it will be set in local_ip_addr
> +	 * in nvme_tcp_ofld_create_ctrl().
> +	 * If NVMF_OPT_HOST_TRADDR is not provided the local_ip_addr will be
> +	 * initialized by claim_dev().
> +	 */
> +	struct sockaddr_storage local_ip_addr;
> +
> +	/* Output params */
> +	struct sockaddr	remote_mac_addr;
> +	struct sockaddr	local_mac_addr;
> +	u16 vlan_id;

Why should a ULP care about this? It's a red-flag to
me that a tcp ulp needs these params.

> +};
> +
> +/* Allocated by nvme_tcp_ofld */
> +struct nvme_tcp_ofld_ctrl {
> +	struct nvme_ctrl nctrl;
> +	struct list_head list;
> +	struct nvme_tcp_ofld_dev *dev;
> +
> +	/* admin and IO queues */
> +	struct blk_mq_tag_set tag_set;
> +	struct blk_mq_tag_set admin_tag_set;
> +	struct nvme_tcp_ofld_queue *queues;
> +
> +	struct work_struct err_work;
> +	struct delayed_work connect_work;
> +
> +	/*
> +	 * Each entry in the array indicates the number of queues of
> +	 * corresponding type.
> +	 */
> +	u32 io_queues[HCTX_MAX_TYPES];

What if the offload device doesn't support poll queue map?

> +
> +	/* Connectivity params */
> +	struct nvme_tcp_ofld_ctrl_con_params conn_params;
> +
> +	/* Vendor specific driver context */
> +	void *private_data;
> +};
> +
> +struct nvme_tcp_ofld_ops {
> +	const char *name;
> +	struct module *module;
> +
> +	/* For vendor-specific driver to report what opts it supports */
> +	int required_opts; /* bitmap using enum nvmf_parsing_opts */
> +	int allowed_opts; /* bitmap using enum nvmf_parsing_opts */

What is the difference between this one and the ulp one?

> +
> +	/* For vendor-specific max num of segments and IO sizes */
> +	u32 max_hw_sectors;
> +	u32 max_segments;

Understand max_segments maybe needed, but why max_hw_sectors? Is
that something an offload device really cares about?

> +
> +	/**
> +	 * claim_dev: Return True if addr is reachable via offload device.
> +	 * @dev: The offload device to check.
> +	 * @conn_params: ptr to routing params to be filled by the lower
> +	 *               driver. Input+Output argument.
> +	 */
> +	int (*claim_dev)(struct nvme_tcp_ofld_dev *dev,
> +			 struct nvme_tcp_ofld_ctrl_con_params *conn_params);
> +
> +	/**
> +	 * setup_ctrl: Setup device specific controller structures.
> +	 * @ctrl: The offload ctrl.
> +	 * @new: is new setup.
> +	 */
> +	int (*setup_ctrl)(struct nvme_tcp_ofld_ctrl *ctrl, bool new);

I think that the 'new' is really an odd interface, it's ok if its
internal to a driver, but not for an interface...

> +
> +	/**
> +	 * release_ctrl: Release/Free device specific controller structures.
> +	 * @ctrl: The offload ctrl.
> +	 */
> +	int (*release_ctrl)(struct nvme_tcp_ofld_ctrl *ctrl);
> +
> +	/**
> +	 * create_queue: Create offload queue and establish TCP + NVMeTCP
> +	 * (icreq+icresp) connection. Return true on successful connection.
> +	 * Based on nvme_tcp_alloc_queue.
> +	 * @queue: The queue itself - used as input and output.
> +	 * @qid: The queue ID associated with the requested queue.
> +	 * @q_size: The queue depth.
> +	 */
> +	int (*create_queue)(struct nvme_tcp_ofld_queue *queue, int qid,
> +			    size_t q_size);

queue_size

> +
> +	/**
> +	 * drain_queue: Drain a given queue - Returning from this function
> +	 * ensures that no additional completions will arrive on this queue.
> +	 * @queue: The queue to drain.
> +	 */
> +	void (*drain_queue)(struct nvme_tcp_ofld_queue *queue);

I'm assuming this is a blocking call? should probably document it.

> +
> +	/**
> +	 * destroy_queue: Close the TCP + NVMeTCP connection of a given queue
> +	 * and make sure its no longer active (no completions will arrive on the
> +	 * queue).
> +	 * @queue: The queue to destroy.
> +	 */
> +	void (*destroy_queue)(struct nvme_tcp_ofld_queue *queue);
> +
> +	/**
> +	 * poll_queue: Poll a given queue for completions.
> +	 * @queue: The queue to poll.
> +	 */
> +	int (*poll_queue)(struct nvme_tcp_ofld_queue *queue);
> +
> +	/**
> +	 * init_req: Initialize vendor-specific params for a new request.
> +	 * @req: Ptr to request to be initialized. Input+Output argument.
> +	 */
> +	int (*init_req)(struct nvme_tcp_ofld_req *req);

What is this used for?

> +
> +	/**
> +	 * send_req: Dispatch a request. Returns the execution status.
> +	 * @req: Ptr to request to be sent.
> +	 */
> +	int (*send_req)(struct nvme_tcp_ofld_req *req);
> +
> +	/**
> +	 * commit_rqs: Serves the purpose of kicking the hardware in case of
> +	 * errors, otherwise it would have been kicked by the last request.
> +	 * @queue: The queue to drain.
> +	 */
> +	void (*commit_rqs)(struct nvme_tcp_ofld_queue *queue);

Is this something you actually use? And the documentation talks about
errors which doesn't match the name, not sure what is the purpose of
this at all.
