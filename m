Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9360F1AE6D3
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 22:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731038AbgDQUcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 16:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730903AbgDQUcW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 16:32:22 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44D3620B1F;
        Fri, 17 Apr 2020 20:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587155540;
        bh=klKxLxaADQHbGHXrvsIsgTvuM++iadbUwD0/TJQ1I7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sMIPVgw2VjqkyStQGCzjeQBlPWlXPHYnWqxEutCIJ+u/AlVSfvK0R5wrKNId1hbjE
         taqJGOUXyM3YLFYClWZWqRS3nMH9jUQxIMRj36/xkp+2L6CZnWRlOQ8h5MDkxrSE+C
         MDhB8aSVeDUu/6Z+/4m05/xLMsXJrlWUrIhJPG0U=
Date:   Fri, 17 Apr 2020 23:32:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     gregkh@linuxfoundation.org, jgg@ziepe.ca,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC PATCH v5 12/16] RDMA/irdma: Add miscellaneous utility
 definitions
Message-ID: <20200417203216.GH3083@unreal>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-13-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417171251.1533371-13-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 10:12:47AM -0700, Jeff Kirsher wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
>
> Add miscellaneous utility functions and headers.
>
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/infiniband/hw/irdma/osdep.h  |  105 ++
>  drivers/infiniband/hw/irdma/protos.h |   93 +
>  drivers/infiniband/hw/irdma/status.h |   69 +
>  drivers/infiniband/hw/irdma/utils.c  | 2445 ++++++++++++++++++++++++++
>  4 files changed, 2712 insertions(+)
>  create mode 100644 drivers/infiniband/hw/irdma/osdep.h
>  create mode 100644 drivers/infiniband/hw/irdma/protos.h
>  create mode 100644 drivers/infiniband/hw/irdma/status.h
>  create mode 100644 drivers/infiniband/hw/irdma/utils.c
>
> diff --git a/drivers/infiniband/hw/irdma/osdep.h b/drivers/infiniband/hw/irdma/osdep.h
> new file mode 100644
> index 000000000000..23ddfb8e9568
> --- /dev/null
> +++ b/drivers/infiniband/hw/irdma/osdep.h
> @@ -0,0 +1,105 @@
> +/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
> +/* Copyright (c) 2015 - 2019 Intel Corporation */
> +#ifndef IRDMA_OSDEP_H
> +#define IRDMA_OSDEP_H
> +
> +#include <linux/version.h>

Why is that?

> +#include <linux/kernel.h>
> +#include <linux/vmalloc.h>
> +#include <linux/string.h>
> +#include <linux/bitops.h>
> +#include <linux/pci.h>
> +#include <linux/refcount.h>
> +#include <net/tcp.h>
> +#include <crypto/hash.h>
> +/* get readq/writeq support for 32 bit kernels, use the low-first version */
> +#include <linux/io-64-nonatomic-lo-hi.h>
> +
> +#define STATS_TIMER_DELAY	60000
> +#define rfdev_to_dev(ptr)	(&((ptr)->hw->pdev->dev))
> +#define to_ibdev(iwdev)		(&((iwdev)->ibdev))
> +#define hw_to_dev(hw)		(&(hw)->pdev->dev)

I don't know if it is ok, but it is amazing to see how much indirection
layers you have.

> +#define irdma_debug_buf(dev, prefix, desc, buf, size)	\
> +	print_hex_dump_debug(prefix ": " desc " ",	\
> +			     DUMP_PREFIX_OFFSET,	\
> +			     16, 8, buf, size, false)
> +

I think that it can be beneficial to be as ibdev_print_buf().

> +struct irdma_dma_info {
> +	dma_addr_t *dmaaddrs;
> +};
> +
> +struct irdma_dma_mem {
> +	void *va;
> +	dma_addr_t pa;
> +	u32 size;
> +} __packed;
> +
> +struct irdma_virt_mem {
> +	void *va;
> +	u32 size;
> +} __packed;
> +
> +struct irdma_sc_vsi;
> +struct irdma_sc_dev;
> +struct irdma_sc_qp;
> +struct irdma_puda_buf;
> +struct irdma_puda_cmpl_info;
> +struct irdma_update_sds_info;
> +struct irdma_hmc_fcn_info;
> +struct irdma_virtchnl_work_info;
> +struct irdma_manage_vf_pble_info;
> +struct irdma_hw;
> +struct irdma_pci_f;
> +
> +u8 __iomem *irdma_get_hw_addr(void *dev);
> +void irdma_ieq_mpa_crc_ae(struct irdma_sc_dev *dev, struct irdma_sc_qp *qp);
> +enum irdma_status_code irdma_vf_wait_vchnl_resp(struct irdma_sc_dev *dev);
> +bool irdma_vf_clear_to_send(struct irdma_sc_dev *dev);
> +void irdma_add_dev_ref(struct irdma_sc_dev *dev);
> +void irdma_put_dev_ref(struct irdma_sc_dev *dev);
> +enum irdma_status_code irdma_ieq_check_mpacrc(struct shash_desc *desc,
> +					      void *addr, u32 len, u32 val);
> +struct irdma_sc_qp *irdma_ieq_get_qp(struct irdma_sc_dev *dev,
> +				     struct irdma_puda_buf *buf);
> +void irdma_send_ieq_ack(struct irdma_sc_qp *qp);
> +void irdma_ieq_update_tcpip_info(struct irdma_puda_buf *buf, u16 len,
> +				 u32 seqnum);
> +void irdma_free_hash_desc(struct shash_desc *hash_desc);
> +enum irdma_status_code irdma_init_hash_desc(struct shash_desc **hash_desc);
> +enum irdma_status_code
> +irdma_puda_get_tcpip_info(struct irdma_puda_cmpl_info *info,
> +			  struct irdma_puda_buf *buf);
> +enum irdma_status_code irdma_cqp_sds_cmd(struct irdma_sc_dev *dev,
> +					 struct irdma_update_sds_info *info);
> +enum irdma_status_code
> +irdma_cqp_manage_hmc_fcn_cmd(struct irdma_sc_dev *dev,
> +			     struct irdma_hmc_fcn_info *hmcfcninfo);
> +enum irdma_status_code
> +irdma_cqp_query_fpm_val_cmd(struct irdma_sc_dev *dev,
> +			    struct irdma_dma_mem *val_mem, u8 hmc_fn_id);
> +enum irdma_status_code
> +irdma_cqp_commit_fpm_val_cmd(struct irdma_sc_dev *dev,
> +			     struct irdma_dma_mem *val_mem, u8 hmc_fn_id);
> +enum irdma_status_code irdma_alloc_query_fpm_buf(struct irdma_sc_dev *dev,
> +						 struct irdma_dma_mem *mem);
> +enum irdma_status_code
> +irdma_cqp_manage_vf_pble_bp(struct irdma_sc_dev *dev,
> +			    struct irdma_manage_vf_pble_info *info);
> +void irdma_cqp_spawn_worker(struct irdma_sc_dev *dev,
> +			    struct irdma_virtchnl_work_info *work_info,
> +			    u32 iw_vf_idx);
> +void *irdma_remove_cqp_head(struct irdma_sc_dev *dev);
> +void irdma_term_modify_qp(struct irdma_sc_qp *qp, u8 next_state, u8 term,
> +			  u8 term_len);
> +void irdma_terminate_done(struct irdma_sc_qp *qp, int timeout_occurred);
> +void irdma_terminate_start_timer(struct irdma_sc_qp *qp);
> +void irdma_terminate_del_timer(struct irdma_sc_qp *qp);
> +enum irdma_status_code
> +irdma_hw_manage_vf_pble_bp(struct irdma_pci_f *rf,
> +			   struct irdma_manage_vf_pble_info *info, bool wait);
> +void irdma_hw_stats_start_timer(struct irdma_sc_vsi *vsi);
> +void irdma_hw_stats_stop_timer(struct irdma_sc_vsi *vsi);
> +void wr32(struct irdma_hw *hw, u32 reg, u32 val);
> +u32 rd32(struct irdma_hw *hw, u32 reg);
> +u64 rd64(struct irdma_hw *hw, u32 reg);
> +#endif /* IRDMA_OSDEP_H */
> diff --git a/drivers/infiniband/hw/irdma/protos.h b/drivers/infiniband/hw/irdma/protos.h
> new file mode 100644
> index 000000000000..b86efb4ecf81
> --- /dev/null
> +++ b/drivers/infiniband/hw/irdma/protos.h
> @@ -0,0 +1,93 @@
> +/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
> +/* Copyright (c) 2019 Intel Corporation */
> +#ifndef IRDMA_PROTOS_H
> +#define IRDMA_PROTOS_H
> +
> +#define PAUSE_TIMER_VAL		0xffff
> +#define REFRESH_THRESHOLD	0x7fff
> +#define HIGH_THRESHOLD		0x800
> +#define LOW_THRESHOLD		0x200
> +#define ALL_TC2PFC		0xff
> +#define CQP_COMPL_WAIT_TIME_MS	10
> +#define CQP_TIMEOUT_THRESHOLD	500
> +
> +/* init operations */
> +enum irdma_status_code irdma_sc_ctrl_init(enum irdma_vers ver,
> +					  struct irdma_sc_dev *dev,
> +					  struct irdma_device_init_info *info);
> +void irdma_sc_rt_init(struct irdma_sc_dev *dev);
> +void irdma_sc_cqp_post_sq(struct irdma_sc_cqp *cqp);
> +__le64 *irdma_sc_cqp_get_next_send_wqe(struct irdma_sc_cqp *cqp, u64 scratch);
> +enum irdma_status_code
> +irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
> +			  struct irdma_fast_reg_stag_info *info, bool post_sq);
> +/* HMC/FPM functions */
> +enum irdma_status_code irdma_sc_init_iw_hmc(struct irdma_sc_dev *dev,
> +					    u8 hmc_fn_id);
> +/* stats misc */
> +enum irdma_status_code
> +irdma_cqp_gather_stats_cmd(struct irdma_sc_dev *dev,
> +			   struct irdma_vsi_pestat *pestat, bool wait);
> +enum irdma_status_code
> +irdma_cqp_ws_node_cmd(struct irdma_sc_dev *dev, u8 cmd,
> +		      struct irdma_ws_node_info *node_info);
> +enum irdma_status_code irdma_cqp_up_map_cmd(struct irdma_sc_dev *dev, u8 cmd,
> +					    struct irdma_up_info *map_info);
> +enum irdma_status_code irdma_cqp_ceq_cmd(struct irdma_sc_dev *dev,
> +					 struct irdma_sc_ceq *sc_ceq, u8 op);
> +enum irdma_status_code
> +irdma_cqp_stats_inst_cmd(struct irdma_sc_vsi *vsi, u8 cmd,
> +			 struct irdma_stats_inst_info *stats_info);
> +u16 irdma_alloc_ws_node_id(struct irdma_sc_dev *dev);
> +void irdma_free_ws_node_id(struct irdma_sc_dev *dev, u16 node_id);
> +void irdma_update_stats(struct irdma_dev_hw_stats *hw_stats,
> +			struct irdma_gather_stats *gather_stats,
> +			struct irdma_gather_stats *last_gather_stats);
> +/* vsi functions */
> +enum irdma_status_code irdma_vsi_stats_init(struct irdma_sc_vsi *vsi,
> +					    struct irdma_vsi_stats_info *info);
> +void irdma_vsi_stats_free(struct irdma_sc_vsi *vsi);
> +void irdma_sc_vsi_init(struct irdma_sc_vsi *vsi,
> +		       struct irdma_vsi_init_info *info);
> +enum irdma_status_code irdma_sc_add_cq_ctx(struct irdma_sc_ceq *ceq,
> +					   struct irdma_sc_cq *cq);
> +void irdma_sc_remove_cq_ctx(struct irdma_sc_ceq *ceq, struct irdma_sc_cq *cq);
> +/* misc L2 param change functions */
> +void irdma_change_l2params(struct irdma_sc_vsi *vsi,
> +			   struct irdma_l2params *l2params);
> +void irdma_sc_suspend_resume_qps(struct irdma_sc_vsi *vsi, u8 suspend);
> +enum irdma_status_code irdma_cqp_qp_suspend_resume(struct irdma_sc_qp *qp,
> +						   u8 cmd);
> +void irdma_qp_add_qos(struct irdma_sc_qp *qp);
> +void irdma_qp_rem_qos(struct irdma_sc_qp *qp);
> +struct irdma_sc_qp *irdma_get_qp_from_list(struct list_head *head,
> +					   struct irdma_sc_qp *qp);
> +void irdma_reinitialize_ieq(struct irdma_sc_vsi *vsi);
> +u16 irdma_alloc_ws_node_id(struct irdma_sc_dev *dev);
> +void irdma_free_ws_node_id(struct irdma_sc_dev *dev, u16 node_id);
> +/* terminate functions*/
> +void irdma_terminate_send_fin(struct irdma_sc_qp *qp);
> +
> +void irdma_terminate_connection(struct irdma_sc_qp *qp,
> +				struct irdma_aeqe_info *info);
> +
> +void irdma_terminate_received(struct irdma_sc_qp *qp,
> +			      struct irdma_aeqe_info *info);
> +/* dynamic memory allocation */
> +/* misc */
> +u8 irdma_get_encoded_wqe_size(u32 wqsize, bool cqpsq);
> +void irdma_modify_qp_to_err(struct irdma_sc_qp *sc_qp);
> +enum irdma_status_code
> +irdma_sc_static_hmc_pages_allocated(struct irdma_sc_cqp *cqp, u64 scratch,
> +				    u8 hmc_fn_id, bool post_sq,
> +				    bool poll_registers);
> +enum irdma_status_code irdma_cfg_fpm_val(struct irdma_sc_dev *dev,
> +					 u32 qp_count);
> +enum irdma_status_code irdma_get_rdma_features(struct irdma_sc_dev *dev);
> +void free_sd_mem(struct irdma_sc_dev *dev);
> +enum irdma_status_code irdma_process_cqp_cmd(struct irdma_sc_dev *dev,
> +					     struct cqp_cmds_info *pcmdinfo);
> +enum irdma_status_code irdma_process_bh(struct irdma_sc_dev *dev);
> +enum irdma_status_code irdma_cqp_sds_cmd(struct irdma_sc_dev *dev,
> +					 struct irdma_update_sds_info *info);
> +#endif /* IRDMA_PROTOS_H */
> diff --git a/drivers/infiniband/hw/irdma/status.h b/drivers/infiniband/hw/irdma/status.h
> new file mode 100644
> index 000000000000..e894b6b00e89
> --- /dev/null
> +++ b/drivers/infiniband/hw/irdma/status.h
> @@ -0,0 +1,69 @@
> +/* SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB */
> +/* Copyright (c) 2015 - 2019 Intel Corporation */
> +#ifndef IRDMA_STATUS_H
> +#define IRDMA_STATUS_H
> +
> +/* Error Codes */
> +enum irdma_status_code {
> +	IRDMA_SUCCESS				= 0,
> +	IRDMA_ERR_NVM				= -1,
> +	IRDMA_ERR_NVM_CHECKSUM			= -2,
> +	IRDMA_ERR_CFG				= -4,
> +	IRDMA_ERR_PARAM				= -5,
> +	IRDMA_ERR_DEVICE_NOT_SUPPORTED		= -6,
> +	IRDMA_ERR_RESET_FAILED			= -7,
> +	IRDMA_ERR_SWFW_SYNC			= -8,
> +	IRDMA_ERR_NO_MEMORY			= -9,
> +	IRDMA_ERR_BAD_PTR			= -10,
> +	IRDMA_ERR_INVALID_PD_ID			= -11,
> +	IRDMA_ERR_INVALID_QP_ID			= -12,
> +	IRDMA_ERR_INVALID_CQ_ID			= -13,
> +	IRDMA_ERR_INVALID_CEQ_ID		= -14,
> +	IRDMA_ERR_INVALID_AEQ_ID		= -15,
> +	IRDMA_ERR_INVALID_SIZE			= -16,
> +	IRDMA_ERR_INVALID_ARP_INDEX		= -17,
> +	IRDMA_ERR_INVALID_FPM_FUNC_ID		= -18,
> +	IRDMA_ERR_QP_INVALID_MSG_SIZE		= -19,
> +	IRDMA_ERR_QP_TOOMANY_WRS_POSTED		= -20,
> +	IRDMA_ERR_INVALID_FRAG_COUNT		= -21,
> +	IRDMA_ERR_Q_EMPTY			= -22,
> +	IRDMA_ERR_INVALID_ALIGNMENT		= -23,
> +	IRDMA_ERR_FLUSHED_Q			= -24,
> +	IRDMA_ERR_INVALID_PUSH_PAGE_INDEX	= -25,
> +	IRDMA_ERR_INVALID_INLINE_DATA_SIZE	= -26,
> +	IRDMA_ERR_TIMEOUT			= -27,
> +	IRDMA_ERR_OPCODE_MISMATCH		= -28,
> +	IRDMA_ERR_CQP_COMPL_ERROR		= -29,
> +	IRDMA_ERR_INVALID_VF_ID			= -30,
> +	IRDMA_ERR_INVALID_HMCFN_ID		= -31,
> +	IRDMA_ERR_BACKING_PAGE_ERROR		= -32,
> +	IRDMA_ERR_NO_PBLCHUNKS_AVAILABLE	= -33,
> +	IRDMA_ERR_INVALID_PBLE_INDEX		= -34,
> +	IRDMA_ERR_INVALID_SD_INDEX		= -35,
> +	IRDMA_ERR_INVALID_PAGE_DESC_INDEX	= -36,
> +	IRDMA_ERR_INVALID_SD_TYPE		= -37,
> +	IRDMA_ERR_MEMCPY_FAILED			= -38,
> +	IRDMA_ERR_INVALID_HMC_OBJ_INDEX		= -39,
> +	IRDMA_ERR_INVALID_HMC_OBJ_COUNT		= -40,
> +	IRDMA_ERR_BUF_TOO_SHORT			= -43,
> +	IRDMA_ERR_BAD_IWARP_CQE			= -44,
> +	IRDMA_ERR_NVM_BLANK_MODE		= -45,
> +	IRDMA_ERR_NOT_IMPL			= -46,
> +	IRDMA_ERR_PE_DOORBELL_NOT_ENA		= -47,
> +	IRDMA_ERR_NOT_READY			= -48,
> +	IRDMA_NOT_SUPPORTED			= -49,
> +	IRDMA_ERR_FIRMWARE_API_VER		= -50,
> +	IRDMA_ERR_RING_FULL			= -51,
> +	IRDMA_ERR_MPA_CRC			= -61,
> +	IRDMA_ERR_NO_TXBUFS			= -62,
> +	IRDMA_ERR_SEQ_NUM			= -63,
> +	IRDMA_ERR_list_empty			= -64,
> +	IRDMA_ERR_INVALID_MAC_ADDR		= -65,
> +	IRDMA_ERR_BAD_STAG			= -66,
> +	IRDMA_ERR_CQ_COMPL_ERROR		= -67,
> +	IRDMA_ERR_Q_DESTROYED			= -68,
> +	IRDMA_ERR_INVALID_FEAT_CNT		= -69,
> +	IRDMA_ERR_REG_CQ_FULL			= -70,
> +	IRDMA_ERR_VF_MSG_ERROR			= -71,
> +};

Please don't do vertical space alignment in all the places

> +#endif /* IRDMA_STATUS_H */
> diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
> new file mode 100644
> index 000000000000..be46d672afc5
> --- /dev/null
> +++ b/drivers/infiniband/hw/irdma/utils.c
> @@ -0,0 +1,2445 @@
> +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> +/* Copyright (c) 2015 - 2019 Intel Corporation */
> +#include <linux/mii.h>
> +#include <linux/in.h>
> +#include <linux/init.h>
> +#include <asm/irq.h>
> +#include <asm/byteorder.h>
> +#include <net/neighbour.h>
> +#include "main.h"
> +
> +/**
> + * irdma_arp_table -manage arp table
> + * @rf: RDMA PCI function
> + * @ip_addr: ip address for device
> + * @ipv4: IPv4 flag
> + * @mac_addr: mac address ptr
> + * @action: modify, delete or add
> + */
> +int irdma_arp_table(struct irdma_pci_f *rf, u32 *ip_addr, bool ipv4,
> +		    u8 *mac_addr, u32 action)

ARP table in the RDMA driver looks strange, I see that it is legacy
from i40iw, but wonder if it is the right thing to do the same for
the new driver.

Thanks
