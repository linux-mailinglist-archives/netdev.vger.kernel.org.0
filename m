Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC340301CA6
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 15:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbhAXOTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 09:19:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbhAXOTl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 09:19:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5477222D6E;
        Sun, 24 Jan 2021 14:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611497940;
        bh=WoUImpSEYpTtMEx4LB9LuXLCIxy/ln1cx+nADzMNnU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LrzDXjoTw+fpEUJ4qu+ET6JsGYbPdMI7t3ljgpnE6ql6+gk60F1aAUr2JQud20oDv
         fxwkybuOXlCLxeIkatCe1qkoApfgXlfiEeX1Y/rbc4Iu/fKB6ynodttly4ZguO9REz
         lEe5Quwt776PkdwUU09oLXJ9reSZkGTkaCGGdROwGsL4gI/uWCp8hp/6vBL5io3an/
         A9PwSbwG7KfocuMYcGAuRvue43Y72IhdNlfK09dXvnmIWsq+qDWBdr1XTTZDPDLM54
         sLWJ3LLqb/OUjXwm7pC6E3rbLVrsyRH5wUUjsDJ0S3ri9Yhf69IKwcmKvZTn/SgJ6o
         /mCn36VImHjGQ==
Date:   Sun, 24 Jan 2021 16:18:56 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, linux-rdma@vger.kernel.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH 15/22] RDMA/irdma: Implement device supported verb APIs
Message-ID: <20210124141856.GC5038@unreal>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-16-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122234827.1353-16-shiraz.saleem@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 05:48:20PM -0600, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail@intel.com>
>
> Implement device supported verb APIs. The supported APIs
> vary based on the underlying transport the ibdev is
> registered as (i.e. iWARP or RoCEv2).
>
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> ---
>  drivers/infiniband/hw/irdma/verbs.c     | 4617 +++++++++++++++++++++++++++++++
>  drivers/infiniband/hw/irdma/verbs.h     |  218 ++
>  include/uapi/rdma/ib_user_ioctl_verbs.h |    1 +
>  3 files changed, 4836 insertions(+)
>  create mode 100644 drivers/infiniband/hw/irdma/verbs.c
>  create mode 100644 drivers/infiniband/hw/irdma/verbs.h

<...>

> +	if (req.userspace_ver > IRDMA_ABI_VER)
> +		goto ver_error;
> +
> +	ucontext->iwdev = iwdev;
> +	ucontext->abi_ver = req.userspace_ver;
> +
> +	uk_attrs = &iwdev->rf->sc_dev.hw_attrs.uk_attrs;
> +	/* GEN_1 legacy support with libi40iw */
> +	if (req.userspace_ver <= 5) {
> +		if (uk_attrs->hw_rev != IRDMA_GEN_1)
> +			goto ver_error;
> +
> +		uresp_gen1.max_qps = iwdev->rf->max_qp;
> +		uresp_gen1.max_pds = iwdev->rf->sc_dev.hw_attrs.max_hw_pds;
> +		uresp_gen1.wq_size = iwdev->rf->sc_dev.hw_attrs.max_qp_wr * 2;
> +		uresp_gen1.kernel_ver = req.userspace_ver;
> +		if (ib_copy_to_udata(udata, &uresp_gen1,
> +				     min(sizeof(uresp_gen1), udata->outlen)))
> +			return -EFAULT;
> +	} else {
> +		u64 bar_off =
> +		    (uintptr_t)iwdev->rf->sc_dev.hw_regs[IRDMA_DB_ADDR_OFFSET];
> +		ucontext->db_mmap_entry =
> +			irdma_user_mmap_entry_insert(ucontext, bar_off,
> +						     IRDMA_MMAP_IO_NC,
> +						     &uresp.db_mmap_key);
> +
> +		if (!ucontext->db_mmap_entry)
> +			return -ENOMEM;
> +
> +		uresp.kernel_ver = IRDMA_ABI_VER;
> +		uresp.feature_flags = uk_attrs->feature_flags;
> +		uresp.max_hw_wq_frags = uk_attrs->max_hw_wq_frags;
> +		uresp.max_hw_read_sges = uk_attrs->max_hw_read_sges;
> +		uresp.max_hw_inline = uk_attrs->max_hw_inline;
> +		uresp.max_hw_rq_quanta = uk_attrs->max_hw_rq_quanta;
> +		uresp.max_hw_wq_quanta = uk_attrs->max_hw_wq_quanta;
> +		uresp.max_hw_sq_chunk = uk_attrs->max_hw_sq_chunk;
> +		uresp.max_hw_cq_size = uk_attrs->max_hw_cq_size;
> +		uresp.min_hw_cq_size = uk_attrs->min_hw_cq_size;
> +		uresp.hw_rev = uk_attrs->hw_rev;
> +		if (ib_copy_to_udata(udata, &uresp,
> +				     min(sizeof(uresp), udata->outlen)))
> +			return -EFAULT;
> +	}

i40iw has different logic here, and in old code, if user supplied "req.userspace_ver < 4",
he will get an error. In new code, it will pass and probably fail later.

Thanks
