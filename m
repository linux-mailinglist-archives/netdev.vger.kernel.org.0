Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C1B14423A
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgAUQdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:33:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:38216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbgAUQdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 11:33:25 -0500
Received: from cakuba (unknown [199.201.64.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E58E206A2;
        Tue, 21 Jan 2020 16:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579624404;
        bh=nAQOs03AKB0azD1TRHPJhACdKTBj+xIsAfJYE5xQ2GY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Li0bZGj7t0wjOQXddCxHoFJYNoVRrwYWwSJ0+F7J4XDLwnaIHrKmXRIHGqaumzYgI
         RT7Xla1/uRg+FqxKNkzM2kbRLl7t1ZX35uSNouy3M0VI4YRn0Lf+gajJkXl2NK6zri
         1H5N3A5d8knRXqiAk6y1+VjcYmgh0VnaguePyfoc=
Date:   Tue, 21 Jan 2020 08:33:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v4 06/17] octeontx2-pf: Receive packet handling support
Message-ID: <20200121083322.1d0b6e86@cakuba>
In-Reply-To: <1579612911-24497-7-git-send-email-sunil.kovvuri@gmail.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
        <1579612911-24497-7-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jan 2020 18:51:40 +0530, sunil.kovvuri@gmail.com wrote:
>  static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
>  				struct napi_struct *napi,
>  				struct otx2_cq_queue *cq, int budget)

> +	int processed_cqe = 0;
> +	s64 bufptr;
> +
> +	/* Make sure HW writes to CQ are done */
> +	dma_rmb();

What is this memory barrier between?

Usually dma_rmb() barrier is placed between accesses to the part of the
descriptor which tells us device is done and the rest of descriptor
accesses.

> +	while (likely(processed_cqe < budget)) {
> +		cqe = (struct nix_cqe_rx_s *)CQE_ADDR(cq, cq->cq_head);
> +		if (cqe->hdr.cqe_type == NIX_XQE_TYPE_INVALID ||
> +		    !cqe->sg.subdc) {
> +			if (!processed_cqe)
> +				return 0;
> +			break;
> +		}
> +		cq->cq_head++;
> +		cq->cq_head &= (cq->cqe_cnt - 1);
> +
> +		otx2_rcv_pkt_handler(pfvf, napi, cq, cqe);
> +
> +		cqe->hdr.cqe_type = NIX_XQE_TYPE_INVALID;
> +		cqe->sg.subdc = NIX_SUBDC_NOP;
> +		processed_cqe++;
> +	}

> +void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
> +{
> +	struct nix_cqe_rx_s *cqe;
> +	int processed_cqe = 0;
> +	u64 iova, pa;
> +
> +	/* Make sure HW writes to CQ are done */
> +	dma_rmb();

ditto

> +	while ((cqe = (struct nix_cqe_rx_s *)otx2_get_next_cqe(cq))) {
> +		if (!cqe->sg.subdc)
> +			continue;
> +		iova = cqe->sg.seg_addr - OTX2_HEAD_ROOM;
> +		pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
> +		otx2_dma_unmap_page(pfvf, iova, pfvf->rbsize, DMA_FROM_DEVICE);
> +		put_page(virt_to_page(phys_to_virt(pa)));
> +		processed_cqe++;
> +	}
> +
> +	/* Free CQEs to HW */
> +	otx2_write64(pfvf, NIX_LF_CQ_OP_DOOR,
> +		     ((u64)cq->cq_idx << 32) | processed_cqe);
> +}
