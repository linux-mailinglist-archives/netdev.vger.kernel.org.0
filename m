Return-Path: <netdev+bounces-11685-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7F48733EC6
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:42:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 103521C2107C
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1FAB46BD;
	Sat, 17 Jun 2023 06:42:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A2C46B1
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 06:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF812C433C0;
	Sat, 17 Jun 2023 06:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686984140;
	bh=FAR5g4heOhDUhqBDGst7pbs0jTO0En2U7jBOtmZHEr4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hTEPVi4qJrmK6Kej9YNsAIDUI8SPBZQXMQ+/FW2aPX0Senti/XubfXZZH1tAzzrTY
	 VBnP08L2cg//cFiuonTiXZWTnfbZGGeo01j/9cXej4hhtLrI/CkOKkhWykUbAglkwe
	 9c+xBhjidzRwR2SpmiVVVOTAVt8jQeZVDEbh54kLa0XLDTMK9QUzg/BEFalMx/y+/e
	 1Mj+h91+4KRGWVqETh50sh86qfdb5t+fcQmD9WALTxmOecLb1ywVNKax2An9xunlol
	 M1KQA8u77jCdoDVXwXGul92Dc9BRz9P6VPIvauj1amPng81v/OUtsFkLXx2nS+c4iM
	 ELIQYfiFnCbIA==
Date: Fri, 16 Jun 2023 23:42:18 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 netdev@vger.kernel.org, Joshua Hay <joshua.a.hay@intel.com>,
 pavan.kumar.linga@intel.com, emil.s.tantilov@intel.com,
 jesse.brandeburg@intel.com, sridhar.samudrala@intel.com,
 shiraz.saleem@intel.com, sindhu.devale@intel.com, willemb@google.com,
 decot@google.com, andrew@lunn.ch, leon@kernel.org, mst@redhat.com,
 simon.horman@corigine.com, shannon.nelson@amd.com,
 stephen@networkplumber.org, Alan Brady <alan.brady@intel.com>, Madhu
 Chittim <madhu.chittim@intel.com>, Phani Burra <phani.r.burra@intel.com>,
 Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
Subject: Re: [PATCH net-next v2 03/15] idpf: add controlq init and reset
 checks
Message-ID: <20230616234218.58760587@kernel.org>
In-Reply-To: <20230614171428.1504179-4-anthony.l.nguyen@intel.com>
References: <20230614171428.1504179-1-anthony.l.nguyen@intel.com>
	<20230614171428.1504179-4-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 10:14:16 -0700 Tony Nguyen wrote:
> +static void idpf_ctlq_init_rxq_bufs(struct idpf_ctlq_info *cq)
> +{
> +	int i = 0;
> +
> +	for (i = 0; i < cq->ring_size; i++) {

no need to init i twice

> +	if (!qinfo->len || !qinfo->buf_size ||
> +	    qinfo->len > IDPF_CTLQ_MAX_RING_SIZE ||
> +	    qinfo->buf_size > IDPF_CTLQ_MAX_BUF_LEN)
> +		return -EINVAL;

Looks like defensive programming, it's generally discouraged in 
the kernel.

> +init_free_q:
> +	kfree(cq);
> +	cq = NULL;

no need to clear local variables

> +	return err;
> +}

> +	int i = 0;
> +
> +	INIT_LIST_HEAD(&hw->cq_list_head);
> +
> +	for (i = 0; i < num_q; i++) {

init, again, please fix throughout

> +		struct idpf_ctlq_create_info *qinfo = q_info + i;
> +
> +		err = idpf_ctlq_add(hw, qinfo, &cq);
> +		if (err)
> +			goto init_destroy_qs;
> +	}
> +
> +	return err;

return 0 is more idiomatic, you can't reach it with an errno


> +void idpf_ctlq_deinit(struct idpf_hw *hw)
> +{
> +	struct idpf_ctlq_info *cq = NULL, *tmp = NULL;

You really like to init the stack :S

> +	list_for_each_entry_safe(cq, tmp, &hw->cq_list_head, cq_list)
> +		idpf_ctlq_remove(hw, cq);
> +}

> +	if (!cq || !cq->ring_size)
> +		return -ENOBUFS;

even worse defensive programming

> +	mutex_lock(&cq->cq_lock);
> +
> +	/* Ensure there are enough descriptors to send all messages */
> +	num_desc_avail = IDPF_CTLQ_DESC_UNUSED(cq);
> +	if (num_desc_avail == 0 || num_desc_avail < num_q_msg) {
> +		err = -ENOSPC;
> +		goto sq_send_command_out;

name labels after what they jump to, err_unlock

> +void *idpf_alloc_dma_mem(struct idpf_hw *hw, struct idpf_dma_mem *mem, u64 size)
> +{
> +	struct idpf_adapter *adapter = hw->back;
> +	size_t sz = ALIGN(size, 4096);
> +
> +	mem->va = dma_alloc_coherent(&adapter->pdev->dev, sz,
> +				     &mem->pa, GFP_KERNEL | __GFP_ZERO);

DMA API always zeros memory, I thought cocci warns about this
Did you run cocci checks?


