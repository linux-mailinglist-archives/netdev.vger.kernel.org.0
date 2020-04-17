Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF681AE668
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 21:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbgDQT7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 15:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730573AbgDQT7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 15:59:34 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1367E2076A;
        Fri, 17 Apr 2020 19:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587153573;
        bh=BjQaMABmwPPxZJ+SYYSyHBQ5+A9wcORK7gUbW1PFPE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ICv0kkq78Lqj8UiBtpeM1mRjf4yb/XpROfZyEhh6pSKfdvBrZ4OrWWdVRhoiWgoGk
         jmIzkxZjFuDiy5/7bpl2ZThQPpLGZ65LdQCoTfFTsoolOuImWyAkgwdxuZkkPfinYB
         IySKIALXV52wIjA783+5aimqsIuih8M88K8sqVNI=
Date:   Fri, 17 Apr 2020 22:59:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     gregkh@linuxfoundation.org, jgg@ziepe.ca,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC PATCH v5 09/16] RDMA/irdma: Implement device supported verb
 APIs
Message-ID: <20200417195928.GE3083@unreal>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-10-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417171251.1533371-10-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 10:12:44AM -0700, Jeff Kirsher wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
>
> Implement device supported verb APIs. The supported APIs
> vary based on the underlying transport the ibdev is
> registered as (i.e. iWARP or RoCEv2).
>
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/infiniband/hw/irdma/verbs.c     | 4555 +++++++++++++++++++++++
>  drivers/infiniband/hw/irdma/verbs.h     |  213 ++
>  include/uapi/rdma/ib_user_ioctl_verbs.h |    1 +
>  3 files changed, 4769 insertions(+)
>  create mode 100644 drivers/infiniband/hw/irdma/verbs.c
>  create mode 100644 drivers/infiniband/hw/irdma/verbs.h

<...>

> +static int irdma_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
> +{
> +	struct irdma_qp *iwqp = to_iwqp(ibqp);
> +
> +	iwqp->destroyed = 1;
> +	if (iwqp->ibqp_state >= IB_QPS_INIT && iwqp->ibqp_state < IB_QPS_RTS)
> +		irdma_next_iw_state(iwqp, IRDMA_QP_STATE_ERROR, 0, 0, 0);
> +
> +	if (!iwqp->user_mode) {
> +		if (iwqp->iwscq) {
> +			irdma_clean_cqes(iwqp, iwqp->iwscq);
> +			if (iwqp->iwrcq != iwqp->iwscq)
> +				irdma_clean_cqes(iwqp, iwqp->iwrcq);
> +		}
> +	}
> +
> +	irdma_remove_push_mmap_entries(iwqp);
> +	irdma_free_lsmm_rsrc(iwqp);
> +	irdma_rem_ref(&iwqp->ibqp);

No, please ensure that call to destroy_qp is kfree QP without any need
in reference counting. We need this to move QP allocation to be IB/core
responsibility. I hope that all other verbs objects (with MR as
exception) follow the same pattern: create->kzalloc->destroy>kfree.

> +
> +	return 0;
> +}

<...>

> +
> +/**
> + * irdma_create_qp - create qp
> + * @ibpd: ptr of pd
> + * @init_attr: attributes for qp
> + * @udata: user data for create qp
> + */
> +static struct ib_qp *irdma_create_qp(struct ib_pd *ibpd,
> +				     struct ib_qp_init_attr *init_attr,
> +				     struct ib_udata *udata)
> +{
> +	struct irdma_pd *iwpd = to_iwpd(ibpd);
> +	struct irdma_device *iwdev = to_iwdev(ibpd->device);
> +	struct irdma_pci_f *rf = iwdev->rf;
> +	struct irdma_cqp *iwcqp = &rf->cqp;
> +	struct irdma_qp *iwqp;
> +	struct irdma_create_qp_req req;
> +	struct irdma_create_qp_resp uresp = {};
> +	struct i40iw_create_qp_resp uresp_gen1 = {};
> +	u32 qp_num = 0;
> +	void *mem;
> +	enum irdma_status_code ret;
> +	int err_code = 0;
> +	int sq_size;
> +	int rq_size;
> +	struct irdma_sc_qp *qp;
> +	struct irdma_sc_dev *dev = &rf->sc_dev;
> +	struct irdma_uk_attrs *uk_attrs = &dev->hw_attrs.uk_attrs;
> +	struct irdma_qp_init_info init_info = {};
> +	struct irdma_create_qp_info *qp_info;
> +	struct irdma_cqp_request *cqp_request;
> +	struct cqp_cmds_info *cqp_info;
> +	struct irdma_qp_host_ctx_info *ctx_info;
> +	struct irdma_iwarp_offload_info *iwarp_info;
> +	struct irdma_roce_offload_info *roce_info;
> +	struct irdma_udp_offload_info *udp_info;
> +	unsigned long flags;
> +
> +	if (init_attr->create_flags ||
> +	    init_attr->cap.max_inline_data > uk_attrs->max_hw_inline ||
> +	    init_attr->cap.max_send_sge > uk_attrs->max_hw_wq_frags ||
> +	    init_attr->cap.max_recv_sge > uk_attrs->max_hw_wq_frags)
> +		return ERR_PTR(-EINVAL);
> +
> +	sq_size = init_attr->cap.max_send_wr;
> +	rq_size = init_attr->cap.max_recv_wr;
> +
> +	init_info.vsi = &iwdev->vsi;
> +	init_info.qp_uk_init_info.uk_attrs = uk_attrs;
> +	init_info.qp_uk_init_info.sq_size = sq_size;
> +	init_info.qp_uk_init_info.rq_size = rq_size;
> +	init_info.qp_uk_init_info.max_sq_frag_cnt = init_attr->cap.max_send_sge;
> +	init_info.qp_uk_init_info.max_rq_frag_cnt = init_attr->cap.max_recv_sge;
> +	init_info.qp_uk_init_info.max_inline_data = init_attr->cap.max_inline_data;
> +
> +	mem = kzalloc(sizeof(*iwqp), GFP_KERNEL);
> +	if (!mem)
> +		return ERR_PTR(-ENOMEM);
> +
> +	iwqp = mem;

I'm confused, why do you need "mem" in the first place?

> +	qp = &iwqp->sc_qp;
> +	qp->qp_uk.back_qp = (void *)iwqp;
> +	qp->qp_uk.lock = &iwqp->lock;
> +	qp->push_idx = IRDMA_INVALID_PUSH_PAGE_INDEX;
> +
> +	iwqp->q2_ctx_mem.size = ALIGN(IRDMA_Q2_BUF_SIZE + IRDMA_QP_CTX_SIZE,
> +				      256);
> +	iwqp->q2_ctx_mem.va = dma_alloc_coherent(hw_to_dev(dev->hw),
> +						 iwqp->q2_ctx_mem.size,
> +						 &iwqp->q2_ctx_mem.pa,
> +						 GFP_KERNEL);
> +	if (!iwqp->q2_ctx_mem.va) {
> +		err_code = -ENOMEM;
> +		goto error;
> +	}
> +
> +	init_info.q2 = iwqp->q2_ctx_mem.va;
> +	init_info.q2_pa = iwqp->q2_ctx_mem.pa;
> +	init_info.host_ctx = (void *)init_info.q2 + IRDMA_Q2_BUF_SIZE;
> +	init_info.host_ctx_pa = init_info.q2_pa + IRDMA_Q2_BUF_SIZE;
> +
> +	if (init_attr->qp_type == IB_QPT_GSI && !rf->ldev.ftype)
> +		qp_num = 1;
> +	else
> +		err_code = irdma_alloc_rsrc(rf, rf->allocated_qps, rf->max_qp,
> +					    &qp_num, &rf->next_qp);
> +	if (err_code)
> +		goto error;
> +
> +	iwqp->iwdev = iwdev;
> +	iwqp->iwpd = iwpd;
> +	if (init_attr->qp_type == IB_QPT_GSI && !rf->ldev.ftype)
> +		iwqp->ibqp.qp_num = 1;
> +	else
> +		iwqp->ibqp.qp_num = qp_num;
> +
> +	qp = &iwqp->sc_qp;
> +	iwqp->iwscq = to_iwcq(init_attr->send_cq);
> +	iwqp->iwrcq = to_iwcq(init_attr->recv_cq);
> +	iwqp->host_ctx.va = init_info.host_ctx;
> +	iwqp->host_ctx.pa = init_info.host_ctx_pa;
> +	iwqp->host_ctx.size = IRDMA_QP_CTX_SIZE;
> +
> +	init_info.pd = &iwpd->sc_pd;
> +	init_info.qp_uk_init_info.qp_id = iwqp->ibqp.qp_num;
> +	if (!rdma_protocol_roce(&iwdev->ibdev, 1))
> +		init_info.qp_uk_init_info.first_sq_wq = 1;
> +	iwqp->ctx_info.qp_compl_ctx = (uintptr_t)qp;
> +	init_waitqueue_head(&iwqp->waitq);
> +	init_waitqueue_head(&iwqp->mod_qp_waitq);
> +
> +	if (rdma_protocol_roce(&iwdev->ibdev, 1)) {
> +		if (init_attr->qp_type != IB_QPT_RC &&
> +		    init_attr->qp_type != IB_QPT_UD &&
> +		    init_attr->qp_type != IB_QPT_GSI) {
> +			err_code = -EINVAL;
> +			goto error;
> +		}
> +	} else {
> +		if (init_attr->qp_type != IB_QPT_RC) {
> +			err_code = -EINVAL;
> +			goto error;
> +		}
> +	}
> +	if (udata) {
> +		err_code = ib_copy_from_udata(&req, udata,
> +					      min(sizeof(req), udata->inlen));
> +		if (err_code) {
> +			ibdev_dbg(to_ibdev(iwdev),
> +				  "VERBS: ib_copy_from_data fail\n");
> +			goto error;
> +		}
> +
> +		iwqp->ctx_info.qp_compl_ctx = req.user_compl_ctx;
> +		iwqp->user_mode = 1;
> +		if (req.user_wqe_bufs) {
> +			struct irdma_ucontext *ucontext =
> +				rdma_udata_to_drv_context(udata,
> +							  struct irdma_ucontext,
> +							  ibucontext);
> +			spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
> +			iwqp->iwpbl = irdma_get_pbl((unsigned long)req.user_wqe_bufs,
> +						    &ucontext->qp_reg_mem_list);
> +			spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
> +
> +			if (!iwqp->iwpbl) {
> +				err_code = -ENODATA;
> +				ibdev_dbg(to_ibdev(iwdev),
> +					  "VERBS: no pbl info\n");
> +				goto error;
> +			}
> +		}
> +		init_info.qp_uk_init_info.abi_ver = iwpd->sc_pd.abi_ver;
> +		err_code = irdma_setup_virt_qp(iwdev, iwqp, &init_info);
> +	} else {
> +		init_info.qp_uk_init_info.abi_ver = IRDMA_ABI_VER;
> +		err_code = irdma_setup_kmode_qp(iwdev, iwqp, &init_info, init_attr);
> +	}
> +
> +	if (err_code) {
> +		ibdev_dbg(to_ibdev(iwdev), "VERBS: setup qp failed\n");
> +		goto error;
> +	}
> +
> +	if (rdma_protocol_roce(&iwdev->ibdev, 1)) {
> +		if (init_attr->qp_type == IB_QPT_RC) {
> +			init_info.type = IRDMA_QP_TYPE_ROCE_RC;
> +			init_info.qp_uk_init_info.qp_caps = IRDMA_SEND_WITH_IMM |
> +							    IRDMA_WRITE_WITH_IMM |
> +							    IRDMA_ROCE;
> +		} else {
> +			init_info.type = IRDMA_QP_TYPE_ROCE_UD;
> +			init_info.qp_uk_init_info.qp_caps = IRDMA_SEND_WITH_IMM |
> +							    IRDMA_ROCE;
> +		}
> +	} else {
> +		init_info.type = IRDMA_QP_TYPE_IWARP;
> +		init_info.qp_uk_init_info.qp_caps = IRDMA_WRITE_WITH_IMM;
> +	}
> +
> +	ret = dev->iw_priv_qp_ops->qp_init(qp, &init_info);
> +	if (ret) {
> +		err_code = -EPROTO;
> +		ibdev_dbg(to_ibdev(iwdev), "VERBS: qp_init fail\n");
> +		goto error;
> +	}
> +
> +	ctx_info = &iwqp->ctx_info;
> +	if (rdma_protocol_roce(&iwdev->ibdev, 1)) {
> +		iwqp->ctx_info.roce_info = &iwqp->roce_info;
> +		iwqp->ctx_info.udp_info = &iwqp->udp_info;
> +		udp_info = &iwqp->udp_info;
> +		udp_info->snd_mss = irdma_roce_mtu(iwdev->vsi.mtu);
> +		udp_info->cwnd = 0x400;
> +		udp_info->src_port = 0xc000;
> +		udp_info->dst_port = ROCE_V2_UDP_DPORT;
> +		roce_info = &iwqp->roce_info;
> +		ether_addr_copy(roce_info->mac_addr, iwdev->netdev->dev_addr);
> +
> +		if (init_attr->qp_type == IB_QPT_GSI && !rf->sc_dev.privileged)
> +			roce_info->is_qp1 = true;
> +		roce_info->rd_en = true;
> +		roce_info->wr_rdresp_en = true;
> +		roce_info->dcqcn_en = true;
> +
> +		roce_info->ack_credits = 0x1E;
> +		roce_info->ird_size = IRDMA_MAX_ENCODED_IRD_SIZE;
> +		roce_info->ord_size = dev->hw_attrs.max_hw_ord;
> +
> +		if (!iwqp->user_mode) {
> +			roce_info->priv_mode_en = true;
> +			roce_info->fast_reg_en = true;
> +			roce_info->udprivcq_en = true;
> +		}
> +		roce_info->roce_tver = 0;
> +	} else {
> +		iwqp->ctx_info.iwarp_info = &iwqp->iwarp_info;
> +		iwarp_info = &iwqp->iwarp_info;
> +		ether_addr_copy(iwarp_info->mac_addr, iwdev->netdev->dev_addr);
> +		iwarp_info->rd_en = true;
> +		iwarp_info->wr_rdresp_en = true;
> +		iwarp_info->ecn_en = true;
> +
> +		if (dev->hw_attrs.uk_attrs.hw_rev > IRDMA_GEN_1)
> +			iwarp_info->ib_rd_en = true;
> +		if (!iwqp->user_mode) {
> +			iwarp_info->priv_mode_en = true;
> +			iwarp_info->fast_reg_en = true;
> +		}
> +		iwarp_info->ddp_ver = 1;
> +		iwarp_info->rdmap_ver = 1;
> +		ctx_info->iwarp_info_valid = true;
> +	}
> +	ctx_info->send_cq_num = iwqp->iwscq->sc_cq.cq_uk.cq_id;
> +	ctx_info->rcv_cq_num = iwqp->iwrcq->sc_cq.cq_uk.cq_id;
> +	if (rdma_protocol_roce(&iwdev->ibdev, 1)) {
> +		ret = dev->iw_priv_qp_ops->qp_setctx_roce(&iwqp->sc_qp,
> +							  iwqp->host_ctx.va,
> +							  ctx_info);
> +	} else {
> +		ret = dev->iw_priv_qp_ops->qp_setctx(&iwqp->sc_qp,
> +						     iwqp->host_ctx.va,
> +						     ctx_info);
> +		ctx_info->iwarp_info_valid = false;
> +	}
> +
> +	cqp_request = irdma_get_cqp_request(iwcqp, true);
> +	if (!cqp_request) {
> +		err_code = -ENOMEM;
> +		goto error;
> +	}
> +
> +	cqp_info = &cqp_request->info;
> +	qp_info = &cqp_request->info.in.u.qp_create.info;
> +	memset(qp_info, 0, sizeof(*qp_info));
> +	qp_info->mac_valid = true;
> +	qp_info->cq_num_valid = true;
> +	qp_info->next_iwarp_state = IRDMA_QP_STATE_IDLE;
> +
> +	cqp_info->cqp_cmd = IRDMA_OP_QP_CREATE;
> +	cqp_info->post_sq = 1;
> +	cqp_info->in.u.qp_create.qp = qp;
> +	cqp_info->in.u.qp_create.scratch = (uintptr_t)cqp_request;
> +	ret = irdma_handle_cqp_op(rf, cqp_request);
> +	if (ret) {
> +		ibdev_dbg(to_ibdev(iwdev), "VERBS: CQP-OP QP create fail");
> +		err_code = -ENOMEM;
> +		goto error;
> +	}
> +
> +	refcount_set(&iwqp->refcnt, 1);
> +	spin_lock_init(&iwqp->lock);
> +	spin_lock_init(&iwqp->sc_qp.pfpdu.lock);
> +	iwqp->sig_all = (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR) ? 1 : 0;
> +	rf->qp_table[qp_num] = iwqp;
> +	iwqp->max_send_wr = sq_size;
> +	iwqp->max_recv_wr = rq_size;
> +	if (udata) {
> +		/* GEN_1 legacy support with libi40iw */
> +		if (iwpd->sc_pd.abi_ver <= 5) {
> +			uresp_gen1.lsmm = 1;
> +			uresp_gen1.actual_sq_size = sq_size;
> +			uresp_gen1.actual_rq_size = rq_size;
> +			uresp_gen1.qp_id = qp_num;
> +			uresp_gen1.push_idx = IRDMA_INVALID_PUSH_PAGE_INDEX;
> +			uresp_gen1.lsmm = 1;
> +			err_code = ib_copy_to_udata(udata, &uresp_gen1,
> +						    min(sizeof(uresp_gen1), udata->outlen));
> +		} else {
> +			if (rdma_protocol_iwarp(&iwdev->ibdev, 1))
> +				uresp.lsmm = 1;
> +			uresp.actual_sq_size = sq_size;
> +			uresp.actual_rq_size = rq_size;
> +			uresp.qp_id = qp_num;
> +			uresp.qp_caps = qp->qp_uk.qp_caps;
> +
> +			err_code = ib_copy_to_udata(udata, &uresp,
> +						    min(sizeof(uresp), udata->outlen));
> +		}
> +		if (err_code) {
> +			ibdev_dbg(to_ibdev(iwdev),
> +				  "VERBS: copy_to_udata failed\n");
> +			irdma_destroy_qp(&iwqp->ibqp, udata);
> +			return ERR_PTR(err_code);
> +		}
> +	}
> +	init_completion(&iwqp->sq_drained);
> +	init_completion(&iwqp->rq_drained);
> +	return &iwqp->ibqp;
> +
> +error:
> +	irdma_free_qp_rsrc(iwdev, iwqp, qp_num);
> +
> +	return ERR_PTR(err_code);
> +}
> +

This function was too long.

Thanks
