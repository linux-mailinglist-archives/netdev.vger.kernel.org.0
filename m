Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F24E370B56
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 13:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhEBLdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 07:33:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:41840 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230120AbhEBLdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 07:33:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 75B53AD22;
        Sun,  2 May 2021 11:32:23 +0000 (UTC)
Subject: Re: [RFC PATCH v4 19/27] qedn: Add IRQ and fast-path resources
 initializations
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com
References: <20210429190926.5086-1-smalin@marvell.com>
 <20210429190926.5086-20-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <555ecff4-29bd-2013-a9e9-a439f32db70d@suse.de>
Date:   Sun, 2 May 2021 13:32:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-20-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:09 PM, Shai Malin wrote:
> This patch will present the adding of qedn_fp_queue - this is a per cpu
> core element which handles all of the connections on that cpu core.
> The qedn_fp_queue will handle a group of connections (NVMeoF QPs) which
> are handled on the same cpu core, and will only use the same FW-driver
> resources with no need to be related to the same NVMeoF controller.
> 
> The per qedn_fq_queue resources are the FW CQ and FW status block:
> - The FW CQ will be used for the FW to notify the driver that the
>    the exchange has ended and the FW will pass the incoming NVMeoF CQE
>    (if exist) to the driver.
> - FW status block - which is used for the FW to notify the driver with
>    the producer update of the FW CQE chain.
> 
> The FW fast-path queues are based on qed_chain.h
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/hw/qedn/qedn.h      |  26 +++
>   drivers/nvme/hw/qedn/qedn_main.c | 287 ++++++++++++++++++++++++++++++-
>   2 files changed, 310 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/nvme/hw/qedn/qedn.h b/drivers/nvme/hw/qedn/qedn.h
> index 7efe2366eb7c..5d4d04d144e4 100644
> --- a/drivers/nvme/hw/qedn/qedn.h
> +++ b/drivers/nvme/hw/qedn/qedn.h
> @@ -33,18 +33,41 @@
>   #define QEDN_PROTO_CQ_PROD_IDX	0
>   #define QEDN_NVMETCP_NUM_FW_CONN_QUEUE_PAGES 2
>   
> +#define QEDN_PAGE_SIZE	4096 /* FW page size - Configurable */
> +#define QEDN_IRQ_NAME_LEN 24
> +#define QEDN_IRQ_NO_FLAGS 0
> +
> +/* TCP defines */
> +#define QEDN_TCP_RTO_DEFAULT 280
> +
>   enum qedn_state {
>   	QEDN_STATE_CORE_PROBED = 0,
>   	QEDN_STATE_CORE_OPEN,
>   	QEDN_STATE_GL_PF_LIST_ADDED,
>   	QEDN_STATE_MFW_STATE,
> +	QEDN_STATE_NVMETCP_OPEN,
> +	QEDN_STATE_IRQ_SET,
> +	QEDN_STATE_FP_WORK_THREAD_SET,
>   	QEDN_STATE_REGISTERED_OFFLOAD_DEV,
>   	QEDN_STATE_MODULE_REMOVE_ONGOING,
>   };
>   
> +/* Per CPU core params */
> +struct qedn_fp_queue {
> +	struct qed_chain cq_chain;
> +	u16 *cq_prod;
> +	struct mutex cq_mutex; /* cq handler mutex */
> +	struct qedn_ctx	*qedn;
> +	struct qed_sb_info *sb_info;
> +	unsigned int cpu;
> +	u16 sb_id;
> +	char irqname[QEDN_IRQ_NAME_LEN];
> +};
> +
>   struct qedn_ctx {
>   	struct pci_dev *pdev;
>   	struct qed_dev *cdev;
> +	struct qed_int_info int_info;
>   	struct qed_dev_nvmetcp_info dev_info;
>   	struct nvme_tcp_ofld_dev qedn_ofld_dev;
>   	struct qed_pf_params pf_params;
> @@ -57,6 +80,9 @@ struct qedn_ctx {
>   
>   	/* Fast path queues */
>   	u8 num_fw_cqs;
> +	struct qedn_fp_queue *fp_q_arr;
> +	struct nvmetcp_glbl_queue_entry *fw_cq_array_virt;
> +	dma_addr_t fw_cq_array_phy; /* Physical address of fw_cq_array_virt */
>   };
>   
>   struct qedn_global {
> diff --git a/drivers/nvme/hw/qedn/qedn_main.c b/drivers/nvme/hw/qedn/qedn_main.c
> index 52007d35622d..0135a1f490da 100644
> --- a/drivers/nvme/hw/qedn/qedn_main.c
> +++ b/drivers/nvme/hw/qedn/qedn_main.c
> @@ -141,6 +141,104 @@ static struct nvme_tcp_ofld_ops qedn_ofld_ops = {
>   	.commit_rqs = qedn_commit_rqs,
>   };
>   
> +/* Fastpath IRQ handler */
> +static irqreturn_t qedn_irq_handler(int irq, void *dev_id)
> +{
> +	/* Placeholder */
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void qedn_sync_free_irqs(struct qedn_ctx *qedn)
> +{
> +	u16 vector_idx;
> +	int i;
> +
> +	for (i = 0; i < qedn->num_fw_cqs; i++) {
> +		vector_idx = i * qedn->dev_info.common.num_hwfns +
> +			     qed_ops->common->get_affin_hwfn_idx(qedn->cdev);
> +		synchronize_irq(qedn->int_info.msix[vector_idx].vector);
> +		irq_set_affinity_hint(qedn->int_info.msix[vector_idx].vector,
> +				      NULL);
> +		free_irq(qedn->int_info.msix[vector_idx].vector,
> +			 &qedn->fp_q_arr[i]);
> +	}
> +
> +	qedn->int_info.used_cnt = 0;
> +	qed_ops->common->set_fp_int(qedn->cdev, 0);
> +}
> +
> +static int qedn_request_msix_irq(struct qedn_ctx *qedn)
> +{
> +	struct pci_dev *pdev = qedn->pdev;
> +	struct qedn_fp_queue *fp_q = NULL;
> +	int i, rc, cpu;
> +	u16 vector_idx;
> +	u32 vector;
> +
> +	/* numa-awareness will be added in future enhancements */
> +	cpu = cpumask_first(cpu_online_mask);
> +	for (i = 0; i < qedn->num_fw_cqs; i++) {
> +		fp_q = &qedn->fp_q_arr[i];
> +		vector_idx = i * qedn->dev_info.common.num_hwfns +
> +			     qed_ops->common->get_affin_hwfn_idx(qedn->cdev);
> +		vector = qedn->int_info.msix[vector_idx].vector;
> +		sprintf(fp_q->irqname, "qedn_queue_%x.%x.%x_%d",
> +			pdev->bus->number, PCI_SLOT(pdev->devfn),
> +			PCI_FUNC(pdev->devfn), i);
> +		rc = request_irq(vector, qedn_irq_handler, QEDN_IRQ_NO_FLAGS,
> +				 fp_q->irqname, fp_q);
> +		if (rc) {
> +			pr_err("request_irq failed.\n");
> +			qedn_sync_free_irqs(qedn);
> +
> +			return rc;
> +		}
> +
> +		fp_q->cpu = cpu;
> +		qedn->int_info.used_cnt++;
> +		rc = irq_set_affinity_hint(vector, get_cpu_mask(cpu));
> +		cpu = cpumask_next_wrap(cpu, cpu_online_mask, -1, false);
> +	}
> +
> +	return 0;
> +}
> +

Hah. I knew it.
So you _do_ have a limited number of MSIx interrupts.
And that should limit the number of queue pairs, too.

> +static int qedn_setup_irq(struct qedn_ctx *qedn)
> +{
> +	int rc = 0;
> +	u8 rval;
> +
> +	rval = qed_ops->common->set_fp_int(qedn->cdev, qedn->num_fw_cqs);
> +	if (rval < qedn->num_fw_cqs) {
> +		qedn->num_fw_cqs = rval;
> +		if (rval == 0) {
> +			pr_err("set_fp_int return 0 IRQs\n");
> +
> +			return -ENODEV;
> +		}
> +	}
> +
> +	rc = qed_ops->common->get_fp_int(qedn->cdev, &qedn->int_info);
> +	if (rc) {
> +		pr_err("get_fp_int failed\n");
> +		goto exit_setup_int;
> +	}
> +
> +	if (qedn->int_info.msix_cnt) {
> +		rc = qedn_request_msix_irq(qedn);
> +		goto exit_setup_int;
> +	} else {
> +		pr_err("msix_cnt = 0\n");
> +		rc = -EINVAL;
> +		goto exit_setup_int;
> +	}
> +
> +exit_setup_int:
> +
> +	return rc;
> +}
> +
>   static inline void qedn_init_pf_struct(struct qedn_ctx *qedn)
>   {
>   	/* Placeholder - Initialize qedn fields */
> @@ -185,21 +283,173 @@ static void qedn_remove_pf_from_gl_list(struct qedn_ctx *qedn)
>   	mutex_unlock(&qedn_glb.glb_mutex);
>   }
>   
> +static void qedn_free_function_queues(struct qedn_ctx *qedn)
> +{
> +	struct qed_sb_info *sb_info = NULL;
> +	struct qedn_fp_queue *fp_q;
> +	int i;
> +
> +	/* Free workqueues */
> +
> +	/* Free the fast path queues*/
> +	for (i = 0; i < qedn->num_fw_cqs; i++) {
> +		fp_q = &qedn->fp_q_arr[i];
> +
> +		/* Free SB */
> +		sb_info = fp_q->sb_info;
> +		if (sb_info->sb_virt) {
> +			qed_ops->common->sb_release(qedn->cdev, sb_info,
> +						    fp_q->sb_id,
> +						    QED_SB_TYPE_STORAGE);
> +			dma_free_coherent(&qedn->pdev->dev,
> +					  sizeof(*sb_info->sb_virt),
> +					  (void *)sb_info->sb_virt,
> +					  sb_info->sb_phys);
> +			memset(sb_info, 0, sizeof(*sb_info));
> +			kfree(sb_info);
> +			fp_q->sb_info = NULL;
> +		}
> +
> +		qed_ops->common->chain_free(qedn->cdev, &fp_q->cq_chain);
> +	}
> +
> +	if (qedn->fw_cq_array_virt)
> +		dma_free_coherent(&qedn->pdev->dev,
> +				  qedn->num_fw_cqs * sizeof(u64),
> +				  qedn->fw_cq_array_virt,
> +				  qedn->fw_cq_array_phy);
> +	kfree(qedn->fp_q_arr);
> +	qedn->fp_q_arr = NULL;
> +}
> +
> +static int qedn_alloc_and_init_sb(struct qedn_ctx *qedn,
> +				  struct qed_sb_info *sb_info, u16 sb_id)
> +{
> +	int rc = 0;
> +
> +	sb_info->sb_virt = dma_alloc_coherent(&qedn->pdev->dev,
> +					      sizeof(struct status_block_e4),
> +					      &sb_info->sb_phys, GFP_KERNEL);
> +	if (!sb_info->sb_virt) {
> +		pr_err("Status block allocation failed\n");
> +
> +		return -ENOMEM;
> +	}
> +
> +	rc = qed_ops->common->sb_init(qedn->cdev, sb_info, sb_info->sb_virt,
> +				      sb_info->sb_phys, sb_id,
> +				      QED_SB_TYPE_STORAGE);
> +	if (rc) {
> +		pr_err("Status block initialization failed\n");
> +
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +static int qedn_alloc_function_queues(struct qedn_ctx *qedn)
> +{
> +	struct qed_chain_init_params chain_params = {};
> +	struct status_block_e4 *sb = NULL;  /* To change to status_block_e4 */
> +	struct qedn_fp_queue *fp_q = NULL;
> +	int rc = 0, arr_size;
> +	u64 cq_phy_addr;
> +	int i;
> +
> +	/* Place holder - IO-path workqueues */
> +
> +	qedn->fp_q_arr = kcalloc(qedn->num_fw_cqs,
> +				 sizeof(struct qedn_fp_queue), GFP_KERNEL);
> +	if (!qedn->fp_q_arr)
> +		return -ENOMEM;
> +
> +	arr_size = qedn->num_fw_cqs * sizeof(struct nvmetcp_glbl_queue_entry);
> +	qedn->fw_cq_array_virt = dma_alloc_coherent(&qedn->pdev->dev,
> +						    arr_size,
> +						    &qedn->fw_cq_array_phy,
> +						    GFP_KERNEL);
> +	if (!qedn->fw_cq_array_virt) {
> +		rc = -ENOMEM;
> +		goto mem_alloc_failure;
> +	}
> +
> +	/* placeholder - create task pools */
> +
> +	for (i = 0; i < qedn->num_fw_cqs; i++) {
> +		fp_q = &qedn->fp_q_arr[i];
> +		mutex_init(&fp_q->cq_mutex);
> +
> +		/* FW CQ */
> +		chain_params.intended_use = QED_CHAIN_USE_TO_CONSUME,
> +		chain_params.mode = QED_CHAIN_MODE_PBL,
> +		chain_params.cnt_type = QED_CHAIN_CNT_TYPE_U16,
> +		chain_params.num_elems = QEDN_FW_CQ_SIZE;
> +		chain_params.elem_size = 64; /*Placeholder - sizeof(struct nvmetcp_fw_cqe)*/
> +
> +		rc = qed_ops->common->chain_alloc(qedn->cdev,
> +						  &fp_q->cq_chain,
> +						  &chain_params);
> +		if (rc) {
> +			pr_err("CQ chain pci_alloc_consistent fail\n");
> +			goto mem_alloc_failure;
> +		}
> +
> +		cq_phy_addr = qed_chain_get_pbl_phys(&fp_q->cq_chain);
> +		qedn->fw_cq_array_virt[i].cq_pbl_addr.hi = PTR_HI(cq_phy_addr);
> +		qedn->fw_cq_array_virt[i].cq_pbl_addr.lo = PTR_LO(cq_phy_addr);
> +
> +		/* SB */
> +		fp_q->sb_info = kzalloc(sizeof(*fp_q->sb_info), GFP_KERNEL);
> +		if (!fp_q->sb_info)
> +			goto mem_alloc_failure;
> +
> +		fp_q->sb_id = i;
> +		rc = qedn_alloc_and_init_sb(qedn, fp_q->sb_info, fp_q->sb_id);
> +		if (rc) {
> +			pr_err("SB allocation and initialization failed.\n");
> +			goto mem_alloc_failure;
> +		}
> +
> +		sb = fp_q->sb_info->sb_virt;
> +		fp_q->cq_prod = (u16 *)&sb->pi_array[QEDN_PROTO_CQ_PROD_IDX];
> +		fp_q->qedn = qedn;
> +
> +		/* Placeholder - Init IO-path workqueue */
> +
> +		/* Placeholder - Init IO-path resources */
> +	}
> +
> +	return 0;
> +
> +mem_alloc_failure:
> +	pr_err("Function allocation failed\n");
> +	qedn_free_function_queues(qedn);
> +
> +	return rc;
> +}
> +
>   static int qedn_set_nvmetcp_pf_param(struct qedn_ctx *qedn)
>   {
>   	u32 fw_conn_queue_pages = QEDN_NVMETCP_NUM_FW_CONN_QUEUE_PAGES;
>   	struct qed_nvmetcp_pf_params *pf_params;
> +	int rc;
>   
>   	pf_params = &qedn->pf_params.nvmetcp_pf_params;
>   	memset(pf_params, 0, sizeof(*pf_params));
>   	qedn->num_fw_cqs = min_t(u8, qedn->dev_info.num_cqs, num_online_cpus());
> +	pr_info("Num qedn CPU cores is %u\n", qedn->num_fw_cqs);
>   
>   	pf_params->num_cons = QEDN_MAX_CONNS_PER_PF;
>   	pf_params->num_tasks = QEDN_MAX_TASKS_PER_PF;
>   
> -	/* Placeholder - Initialize function level queues */
> +	rc = qedn_alloc_function_queues(qedn);
> +	if (rc) {
> +		pr_err("Global queue allocation failed.\n");
> +		goto err_alloc_mem;
> +	}
>   
> -	/* Placeholder - Initialize TCP params */
> +	set_bit(QEDN_STATE_FP_WORK_THREAD_SET, &qedn->state);
>   
>   	/* Queues */
>   	pf_params->num_sq_pages_in_ring = fw_conn_queue_pages;
> @@ -207,11 +457,14 @@ static int qedn_set_nvmetcp_pf_param(struct qedn_ctx *qedn)
>   	pf_params->num_uhq_pages_in_ring = fw_conn_queue_pages;
>   	pf_params->num_queues = qedn->num_fw_cqs;
>   	pf_params->cq_num_entries = QEDN_FW_CQ_SIZE;
> +	pf_params->glbl_q_params_addr = qedn->fw_cq_array_phy;
>   
>   	/* the CQ SB pi */
>   	pf_params->gl_rq_pi = QEDN_PROTO_CQ_PROD_IDX;
>   
> -	return 0;
> +err_alloc_mem:
> +
> +	return rc;
>   }
>   
>   static inline int qedn_slowpath_start(struct qedn_ctx *qedn)
> @@ -255,6 +508,12 @@ static void __qedn_remove(struct pci_dev *pdev)
>   	else
>   		pr_err("Failed to remove from global PF list\n");
>   
> +	if (test_and_clear_bit(QEDN_STATE_IRQ_SET, &qedn->state))
> +		qedn_sync_free_irqs(qedn);
> +
> +	if (test_and_clear_bit(QEDN_STATE_NVMETCP_OPEN, &qedn->state))
> +		qed_ops->stop(qedn->cdev);
> +
>   	if (test_and_clear_bit(QEDN_STATE_MFW_STATE, &qedn->state)) {
>   		rc = qed_ops->common->update_drv_state(qedn->cdev, false);
>   		if (rc)
> @@ -264,6 +523,9 @@ static void __qedn_remove(struct pci_dev *pdev)
>   	if (test_and_clear_bit(QEDN_STATE_CORE_OPEN, &qedn->state))
>   		qed_ops->common->slowpath_stop(qedn->cdev);
>   
> +	if (test_and_clear_bit(QEDN_STATE_FP_WORK_THREAD_SET, &qedn->state))
> +		qedn_free_function_queues(qedn);
> +
>   	if (test_and_clear_bit(QEDN_STATE_CORE_PROBED, &qedn->state))
>   		qed_ops->common->remove(qedn->cdev);
>   
> @@ -335,6 +597,25 @@ static int __qedn_probe(struct pci_dev *pdev)
>   
>   	set_bit(QEDN_STATE_CORE_OPEN, &qedn->state);
>   
> +	rc = qedn_setup_irq(qedn);
> +	if (rc)
> +		goto exit_probe_and_release_mem;
> +
> +	set_bit(QEDN_STATE_IRQ_SET, &qedn->state);
> +
> +	/* NVMeTCP start HW PF */
> +	rc = qed_ops->start(qedn->cdev,
> +			    NULL /* Placeholder for FW IO-path resources */,
> +			    qedn,
> +			    NULL /* Placeholder for FW Event callback */);
> +	if (rc) {
> +		rc = -ENODEV;
> +		pr_err("Cannot start NVMeTCP Function\n");
> +		goto exit_probe_and_release_mem;
> +	}
> +
> +	set_bit(QEDN_STATE_NVMETCP_OPEN, &qedn->state);
> +
>   	rc = qed_ops->common->update_drv_state(qedn->cdev, true);
>   	if (rc) {
>   		pr_err("Failed to send drv state to MFW\n");
> 
So you have a limited number of MSI-x interrupts, but don't limit the 
number of hw queues to that. Why?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
