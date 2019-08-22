Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE8A999F44
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 20:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391185AbfHVS6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 14:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731854AbfHVS6u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 14:58:50 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52F50233A2;
        Thu, 22 Aug 2019 18:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566500328;
        bh=uw+zZayE9pWlGqZpCmNG0u1fWQ7raTr8S9YCtjJzvp4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i4rGBMlt9whPcPtvpCvx5qsrpW4BSfOJeQ7EmDLxfgtqXij5gcuNYuIU1g645PjaY
         hqTMg4bdY+AcABHH+NkFdmeRh/swCDoZ+AP2SFnpcFIpi/TvrwhJCHeMVzpSZSJTDl
         DTX0QxI0wpqRiq59Pmmhn3J5Xk3UEvnv9OlaX+14=
Date:   Thu, 22 Aug 2019 21:58:47 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "eranbe@mellanox.com" <eranbe@mellanox.com>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next,v4, 4/6] net/mlx5: Add HV VHCA infrastructure
Message-ID: <20190822185847.GP29433@mtr-leonro.mtl.com>
References: <1566450236-36757-1-git-send-email-haiyangz@microsoft.com>
 <1566450236-36757-5-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566450236-36757-5-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 05:05:51AM +0000, Haiyang Zhang wrote:
> From: Eran Ben Elisha <eranbe@mellanox.com>
>
> HV VHCA is a layer which provides PF to VF communication channel based on
> HyperV PCI config channel. It implements Mellanox's Inter VHCA control
> communication protocol. The protocol contains control block in order to
> pass messages between the PF and VF drivers, and data blocks in order to
> pass actual data.
>
> The infrastructure is agent based. Each agent will be responsible of
> contiguous buffer blocks in the VHCA config space. This infrastructure will
> bind agents to their blocks, and those agents can only access read/write
> the buffer blocks assigned to them. Each agent will provide three
> callbacks (control, invalidate, cleanup). Control will be invoked when
> block-0 is invalidated with a command that concerns this agent. Invalidate
> callback will be invoked if one of the blocks assigned to this agent was
> invalidated. Cleanup will be invoked before the agent is being freed in
> order to clean all of its open resources or deferred works.
>
> Block-0 serves as the control block. All execution commands from the PF
> will be written by the PF over this block. VF will ack on those by
> writing on block-0 as well. Its format is described by struct
> mlx5_hv_vhca_control_block layout.
>
> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
>  .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c  | 253 +++++++++++++++++++++
>  .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h  | 102 +++++++++
>  drivers/net/ethernet/mellanox/mlx5/core/main.c     |   7 +
>  include/linux/mlx5/driver.h                        |   2 +
>  5 files changed, 365 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
> index fd32a5b..8d443fc 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
> @@ -45,7 +45,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)   += eswitch.o eswitch_offloads.o eswitch_offlo
>  mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
>  mlx5_core-$(CONFIG_VXLAN)          += lib/vxlan.o
>  mlx5_core-$(CONFIG_PTP_1588_CLOCK) += lib/clock.o
> -mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) += lib/hv.o
> +mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) += lib/hv.o lib/hv_vhca.o
>
>  #
>  # Ipoib netdev
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
> new file mode 100644
> index 0000000..84d1d75
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.c
> @@ -0,0 +1,253 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +// Copyright (c) 2018 Mellanox Technologies
> +
> +#include <linux/hyperv.h>
> +#include "mlx5_core.h"
> +#include "lib/hv.h"
> +#include "lib/hv_vhca.h"
> +
> +struct mlx5_hv_vhca {
> +	struct mlx5_core_dev       *dev;
> +	struct workqueue_struct    *work_queue;
> +	struct mlx5_hv_vhca_agent  *agents[MLX5_HV_VHCA_AGENT_MAX];
> +	struct mutex                agents_lock; /* Protect agents array */
> +};
> +
> +struct mlx5_hv_vhca_work {
> +	struct work_struct     invalidate_work;
> +	struct mlx5_hv_vhca   *hv_vhca;
> +	u64                    block_mask;
> +};
> +
> +struct mlx5_hv_vhca_data_block {
> +	u16     sequence;
> +	u16     offset;
> +	u8      reserved[4];
> +	u64     data[15];
> +};
> +
> +struct mlx5_hv_vhca_agent {
> +	enum mlx5_hv_vhca_agent_type	 type;
> +	struct mlx5_hv_vhca		*hv_vhca;
> +	void				*priv;
> +	u16                              seq;
> +	void (*control)(struct mlx5_hv_vhca_agent *agent,
> +			struct mlx5_hv_vhca_control_block *block);
> +	void (*invalidate)(struct mlx5_hv_vhca_agent *agent,
> +			   u64 block_mask);
> +	void (*cleanup)(struct mlx5_hv_vhca_agent *agent);
> +};
> +
> +struct mlx5_hv_vhca *mlx5_hv_vhca_create(struct mlx5_core_dev *dev)
> +{
> +	struct mlx5_hv_vhca *hv_vhca = NULL;
> +
> +	hv_vhca = kzalloc(sizeof(*hv_vhca), GFP_KERNEL);
> +	if (!hv_vhca)
> +		return ERR_PTR(-ENOMEM);
> +
> +	hv_vhca->work_queue = create_singlethread_workqueue("mlx5_hv_vhca");

I was under impression that usage of create_* interfaces is discouraged,
It has WQ_MEMORY_LEGACY flag inside and commit b71ab8c2025ca talks about
this interface as legacy one.

> +	if (!hv_vhca->work_queue) {
> +		kfree(hv_vhca);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	hv_vhca->dev = dev;
> +	mutex_init(&hv_vhca->agents_lock);
> +
> +	return hv_vhca;
> +}
> +
> +void mlx5_hv_vhca_destroy(struct mlx5_hv_vhca *hv_vhca)
> +{
> +	if (IS_ERR_OR_NULL(hv_vhca))
> +		return;
> +
> +	destroy_workqueue(hv_vhca->work_queue);
> +	kfree(hv_vhca);
> +}
> +
> +static void mlx5_hv_vhca_invalidate_work(struct work_struct *work)
> +{
> +	struct mlx5_hv_vhca_work *hwork;
> +	struct mlx5_hv_vhca *hv_vhca;
> +	int i;
> +
> +	hwork = container_of(work, struct mlx5_hv_vhca_work, invalidate_work);
> +	hv_vhca = hwork->hv_vhca;
> +
> +	mutex_lock(&hv_vhca->agents_lock);
> +	for (i = 0; i < MLX5_HV_VHCA_AGENT_MAX; i++) {
> +		struct mlx5_hv_vhca_agent *agent = hv_vhca->agents[i];
> +
> +		if (!agent || !agent->invalidate)
> +			continue;
> +
> +		if (!(BIT(agent->type) & hwork->block_mask))
> +			continue;
> +
> +		agent->invalidate(agent, hwork->block_mask);
> +	}
> +	mutex_unlock(&hv_vhca->agents_lock);
> +
> +	kfree(hwork);
> +}
> +
> +void mlx5_hv_vhca_invalidate(void *context, u64 block_mask)
> +{
> +	struct mlx5_hv_vhca *hv_vhca = (struct mlx5_hv_vhca *)context;
> +	struct mlx5_hv_vhca_work *work;
> +
> +	work = kzalloc(sizeof(*work), GFP_ATOMIC);
> +	if (!work)
> +		return;
> +
> +	INIT_WORK(&work->invalidate_work, mlx5_hv_vhca_invalidate_work);
> +	work->hv_vhca    = hv_vhca;
> +	work->block_mask = block_mask;
> +
> +	queue_work(hv_vhca->work_queue, &work->invalidate_work);
> +}
> +
> +int mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca)
> +{
> +	if (IS_ERR_OR_NULL(hv_vhca))
> +		return IS_ERR_OR_NULL(hv_vhca);
> +
> +	return mlx5_hv_register_invalidate(hv_vhca->dev, hv_vhca,
> +					   mlx5_hv_vhca_invalidate);
> +}
> +
> +void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca)
> +{
> +	int i;
> +
> +	if (IS_ERR_OR_NULL(hv_vhca))
> +		return;
> +
> +	mutex_lock(&hv_vhca->agents_lock);
> +	for (i = 0; i < MLX5_HV_VHCA_AGENT_MAX; i++)
> +		WARN_ON(hv_vhca->agents[i]);
> +
> +	mutex_unlock(&hv_vhca->agents_lock);
> +
> +	mlx5_hv_unregister_invalidate(hv_vhca->dev);
> +}
> +
> +struct mlx5_hv_vhca_agent *
> +mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
> +			  enum mlx5_hv_vhca_agent_type type,
> +			  void (*control)(struct mlx5_hv_vhca_agent*,
> +					  struct mlx5_hv_vhca_control_block *block),
> +			  void (*invalidate)(struct mlx5_hv_vhca_agent*,
> +					     u64 block_mask),
> +			  void (*cleaup)(struct mlx5_hv_vhca_agent *agent),
> +			  void *priv)
> +{
> +	struct mlx5_hv_vhca_agent *agent;
> +
> +	if (IS_ERR_OR_NULL(hv_vhca))
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (type >= MLX5_HV_VHCA_AGENT_MAX)
> +		return ERR_PTR(-EINVAL);
> +
> +	mutex_lock(&hv_vhca->agents_lock);
> +	if (hv_vhca->agents[type]) {
> +		mutex_unlock(&hv_vhca->agents_lock);
> +		return ERR_PTR(-EINVAL);
> +	}
> +	mutex_unlock(&hv_vhca->agents_lock);
> +
> +	agent = kzalloc(sizeof(*agent), GFP_KERNEL);
> +	if (!agent)
> +		return ERR_PTR(-ENOMEM);
> +
> +	agent->type      = type;
> +	agent->hv_vhca   = hv_vhca;
> +	agent->priv      = priv;
> +	agent->control   = control;
> +	agent->invalidate = invalidate;
> +	agent->cleanup   = cleaup;
> +
> +	mutex_lock(&hv_vhca->agents_lock);
> +	hv_vhca->agents[type] = agent;
> +	mutex_unlock(&hv_vhca->agents_lock);
> +
> +	return agent;
> +}
> +
> +void mlx5_hv_vhca_agent_destroy(struct mlx5_hv_vhca_agent *agent)
> +{
> +	struct mlx5_hv_vhca *hv_vhca = agent->hv_vhca;
> +
> +	mutex_lock(&hv_vhca->agents_lock);
> +
> +	if (WARN_ON(agent != hv_vhca->agents[agent->type])) {
> +		mutex_unlock(&hv_vhca->agents_lock);
> +		return;
> +	}
> +
> +	hv_vhca->agents[agent->type] = NULL;
> +	mutex_unlock(&hv_vhca->agents_lock);
> +
> +	if (agent->cleanup)
> +		agent->cleanup(agent);
> +
> +	kfree(agent);
> +}
> +
> +static int mlx5_hv_vhca_data_block_prepare(struct mlx5_hv_vhca_agent *agent,
> +					   struct mlx5_hv_vhca_data_block *data_block,
> +					   void *src, int len, int *offset)
> +{
> +	int bytes = min_t(int, (int)sizeof(data_block->data), len);
> +
> +	data_block->sequence = agent->seq;
> +	data_block->offset   = (*offset)++;
> +	memcpy(data_block->data, src, bytes);
> +
> +	return bytes;
> +}
> +
> +static void mlx5_hv_vhca_agent_seq_update(struct mlx5_hv_vhca_agent *agent)
> +{
> +	agent->seq++;
> +}
> +
> +int mlx5_hv_vhca_agent_write(struct mlx5_hv_vhca_agent *agent,
> +			     void *buf, int len)
> +{
> +	int offset = agent->type * HV_CONFIG_BLOCK_SIZE_MAX;
> +	int block_offset = 0;
> +	int total = 0;
> +	int err;
> +
> +	while (len) {
> +		struct mlx5_hv_vhca_data_block data_block = {0};
> +		int bytes;
> +
> +		bytes = mlx5_hv_vhca_data_block_prepare(agent, &data_block,
> +							buf + total,
> +							len, &block_offset);
> +		if (!bytes)
> +			return -ENOMEM;
> +
> +		err = mlx5_hv_write_config(agent->hv_vhca->dev, &data_block,
> +					   sizeof(data_block), offset);
> +		if (err)
> +			return err;
> +
> +		total += bytes;
> +		len   -= bytes;
> +	}
> +
> +	mlx5_hv_vhca_agent_seq_update(agent);
> +
> +	return 0;
> +}
> +
> +void *mlx5_hv_vhca_agent_priv(struct mlx5_hv_vhca_agent *agent)
> +{
> +	return agent->priv;
> +}
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
> new file mode 100644
> index 0000000..cdf1303
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
> @@ -0,0 +1,102 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
> +/* Copyright (c) 2019 Mellanox Technologies. */
> +
> +#ifndef __LIB_HV_VHCA_H__
> +#define __LIB_HV_VHCA_H__
> +
> +#include "en.h"
> +#include "lib/hv.h"
> +
> +struct mlx5_hv_vhca_agent;
> +struct mlx5_hv_vhca;
> +struct mlx5_hv_vhca_control_block;
> +
> +enum mlx5_hv_vhca_agent_type {
> +	MLX5_HV_VHCA_AGENT_MAX = 32,
> +};
> +
> +#if IS_ENABLED(CONFIG_PCI_HYPERV_INTERFACE)
> +
> +struct mlx5_hv_vhca_control_block {
> +	u32     capabilities;
> +	u32     control;
> +	u16     command;
> +	u16     command_ack;
> +	u16     version;
> +	u16     rings;
> +	u32     reserved1[28];
> +};
> +
> +struct mlx5_hv_vhca *mlx5_hv_vhca_create(struct mlx5_core_dev *dev);
> +void mlx5_hv_vhca_destroy(struct mlx5_hv_vhca *hv_vhca);
> +int mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca);
> +void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca);
> +void mlx5_hv_vhca_invalidate(void *context, u64 block_mask);
> +
> +struct mlx5_hv_vhca_agent *
> +mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
> +			  enum mlx5_hv_vhca_agent_type type,
> +			  void (*control)(struct mlx5_hv_vhca_agent*,
> +					  struct mlx5_hv_vhca_control_block *block),
> +			  void (*invalidate)(struct mlx5_hv_vhca_agent*,
> +					     u64 block_mask),
> +			  void (*cleanup)(struct mlx5_hv_vhca_agent *agent),
> +			  void *context);
> +
> +void mlx5_hv_vhca_agent_destroy(struct mlx5_hv_vhca_agent *agent);
> +int mlx5_hv_vhca_agent_write(struct mlx5_hv_vhca_agent *agent,
> +			     void *buf, int len);
> +void *mlx5_hv_vhca_agent_priv(struct mlx5_hv_vhca_agent *agent);
> +
> +#else
> +
> +static inline struct mlx5_hv_vhca *
> +mlx5_hv_vhca_create(struct mlx5_core_dev *dev)
> +{
> +	return NULL;
> +}
> +
> +static inline void mlx5_hv_vhca_destroy(struct mlx5_hv_vhca *hv_vhca)
> +{
> +}
> +
> +static inline int mlx5_hv_vhca_init(struct mlx5_hv_vhca *hv_vhca)
> +{
> +	return 0;
> +}
> +
> +static inline void mlx5_hv_vhca_cleanup(struct mlx5_hv_vhca *hv_vhca)
> +{
> +}
> +
> +static inline void mlx5_hv_vhca_invalidate(void *context,
> +					   u64 block_mask)
> +{
> +}
> +
> +static inline struct mlx5_hv_vhca_agent *
> +mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
> +			  enum mlx5_hv_vhca_agent_type type,
> +			  void (*control)(struct mlx5_hv_vhca_agent*,
> +					  struct mlx5_hv_vhca_control_block *block),
> +			  void (*invalidate)(struct mlx5_hv_vhca_agent*,
> +					     u64 block_mask),
> +			  void (*cleanup)(struct mlx5_hv_vhca_agent *agent),
> +			  void *context)
> +{
> +	return NULL;
> +}
> +
> +static inline void mlx5_hv_vhca_agent_destroy(struct mlx5_hv_vhca_agent *agent)
> +{
> +}
> +
> +static inline int
> +mlx5_hv_vhca_write_agent(struct mlx5_hv_vhca_agent *agent,
> +			 void *buf, int len)
> +{
> +	return 0;
> +}
> +#endif
> +
> +#endif /* __LIB_HV_VHCA_H__ */
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 0b70b1d..61388ca 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -69,6 +69,7 @@
>  #include "lib/pci_vsc.h"
>  #include "diag/fw_tracer.h"
>  #include "ecpf.h"
> +#include "lib/hv_vhca.h"
>
>  MODULE_AUTHOR("Eli Cohen <eli@mellanox.com>");
>  MODULE_DESCRIPTION("Mellanox 5th generation network adapters (ConnectX series) core driver");
> @@ -870,6 +871,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
>  	}
>
>  	dev->tracer = mlx5_fw_tracer_create(dev);
> +	dev->hv_vhca = mlx5_hv_vhca_create(dev);
>
>  	return 0;
>
> @@ -900,6 +902,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
>
>  static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
>  {
> +	mlx5_hv_vhca_destroy(dev->hv_vhca);
>  	mlx5_fw_tracer_destroy(dev->tracer);
>  	mlx5_fpga_cleanup(dev);
>  	mlx5_eswitch_cleanup(dev->priv.eswitch);
> @@ -1067,6 +1070,8 @@ static int mlx5_load(struct mlx5_core_dev *dev)
>  		goto err_fw_tracer;
>  	}
>
> +	mlx5_hv_vhca_init(dev->hv_vhca);

What is the point to declare this function as "int ..." if you are not
interested in result?

> +
>  	err = mlx5_fpga_device_start(dev);
>  	if (err) {
>  		mlx5_core_err(dev, "fpga device start failed %d\n", err);
> @@ -1122,6 +1127,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
>  err_ipsec_start:
>  	mlx5_fpga_device_stop(dev);
>  err_fpga_start:
> +	mlx5_hv_vhca_cleanup(dev->hv_vhca);
>  	mlx5_fw_tracer_cleanup(dev->tracer);
>  err_fw_tracer:
>  	mlx5_eq_table_destroy(dev);
> @@ -1142,6 +1148,7 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
>  	mlx5_accel_ipsec_cleanup(dev);
>  	mlx5_accel_tls_cleanup(dev);
>  	mlx5_fpga_device_stop(dev);
> +	mlx5_hv_vhca_cleanup(dev->hv_vhca);
>  	mlx5_fw_tracer_cleanup(dev->tracer);
>  	mlx5_eq_table_destroy(dev);
>  	mlx5_irq_table_destroy(dev);
> diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
> index df23f17..13b4cf2 100644
> --- a/include/linux/mlx5/driver.h
> +++ b/include/linux/mlx5/driver.h
> @@ -659,6 +659,7 @@ struct mlx5_clock {
>  struct mlx5_fw_tracer;
>  struct mlx5_vxlan;
>  struct mlx5_geneve;
> +struct mlx5_hv_vhca;
>
>  struct mlx5_core_dev {
>  	struct device *device;
> @@ -706,6 +707,7 @@ struct mlx5_core_dev {
>  	struct mlx5_ib_clock_info  *clock_info;
>  	struct mlx5_fw_tracer   *tracer;
>  	u32                      vsc_addr;
> +	struct mlx5_hv_vhca	*hv_vhca;
>  };
>
>  struct mlx5_db {
> --
> 1.8.3.1
>
