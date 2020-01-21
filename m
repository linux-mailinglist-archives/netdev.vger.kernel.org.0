Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC88144127
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgAUQAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:00:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbgAUQAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 11:00:40 -0500
Received: from cakuba (unknown [199.201.64.139])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99794217F4;
        Tue, 21 Jan 2020 16:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579622439;
        bh=A+SXT+e2sAcVF3d+bTKfQh+UyMSqSHGPJbWFrbz8m14=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cUARjoCPCzQHmMTN/QRqlZylcFmTD1Ri9piffhzmrmcL2hvPAjJCQMtR7L4ANc/Gd
         O9+5Q36fqADFwQFb8UdbJ49zptjZRHO1Dw0EoBEu9PG0EI1yya3BOB1j9JU2YBNVSV
         7EGHJz6p1nuMTHwQTVxIuHe79ffA8Plx6aTeW8pM=
Date:   Tue, 21 Jan 2020 08:00:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v4 03/17] octeontx2-pf: Attach NIX and NPA block LFs
Message-ID: <20200121080038.0fe6a819@cakuba>
In-Reply-To: <1579612911-24497-4-git-send-email-sunil.kovvuri@gmail.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
        <1579612911-24497-4-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jan 2020 18:51:37 +0530, sunil.kovvuri@gmail.com wrote:
> +int otx2_config_npa(struct otx2_nic *pfvf)
> +{
> +	struct otx2_qset *qset = &pfvf->qset;
> +	struct npa_lf_alloc_req  *npalf;
> +	struct otx2_hw *hw = &pfvf->hw;
> +	int aura_cnt, err;
> +
> +	/* Pool - Stack of free buffer pointers
> +	 * Aura - Alloc/frees pointers from/to pool for NIX DMA.
> +	 */
> +
> +	if (!hw->pool_cnt)
> +		return -EINVAL;
> +
> +	qset->pool = devm_kzalloc(pfvf->dev, sizeof(struct otx2_pool) *
> +				  hw->pool_cnt, GFP_KERNEL);
> +	if (!qset->pool)
> +		return -ENOMEM;
> +
> +	/* Get memory to put this msg */
> +	npalf = otx2_mbox_alloc_msg_npa_lf_alloc(&pfvf->mbox);
> +	if (!npalf)
> +		return -ENOMEM;
> +
> +	/* Set aura and pool counts */
> +	npalf->nr_pools = hw->pool_cnt;
> +	aura_cnt = ilog2(roundup_pow_of_two(hw->pool_cnt));
> +	npalf->aura_sz = (aura_cnt >= ilog2(128)) ? (aura_cnt - 6) : 1;
> +
> +	err = otx2_sync_mbox_msg(&pfvf->mbox);
> +	if (err)
> +		return err;
> +	return 0;

return otx2_sync..

directly

> +}

> +static int otx2_realloc_msix_vectors(struct otx2_nic *pf)
> +{
> +	struct otx2_hw *hw = &pf->hw;
> +	int num_vec, err;
> +
> +	/* NPA interrupts are inot registered, so alloc only
> +	 * upto NIX vector offset.
> +	 */
> +	num_vec = hw->nix_msixoff;
> +#define NIX_LF_CINT_VEC_START			0x40
> +	num_vec += NIX_LF_CINT_VEC_START + hw->max_queues;
> +
> +	otx2_disable_mbox_intr(pf);
> +	pci_free_irq_vectors(hw->pdev);
> +	pci_free_irq_vectors(hw->pdev);
> +	err = pci_alloc_irq_vectors(hw->pdev, num_vec, num_vec, PCI_IRQ_MSIX);
> +	if (err < 0) {
> +		dev_err(pf->dev, "%s: Failed to realloc %d IRQ vectors\n",
> +			__func__, num_vec);
> +		return err;
> +	}
> +
> +	err = otx2_register_mbox_intr(pf, false);
> +	if (err)
> +		return err;
> +	return 0;
> +}

ditto, please fix this everywhere in the submission
