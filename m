Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83362FAF82
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 05:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732009AbhASEgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 23:36:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731315AbhASEeY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 23:34:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58474224B1;
        Tue, 19 Jan 2021 04:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611030817;
        bh=mDDU4zp6bMqJF1sx8LcutXoJE7mN0gRYqr/JsJ87F78=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QCw6yZjHJSD2XmYKYmAIwJzpk0W4u8gx7yEp9mYJZR5WDF1rMNmvn/2sLUG0fPi5f
         i3YzboPblSLIidnw4S4jaCQHjbAdnyelFU1lenHwHBqpsyeGTtIzFmDLxMH0FWUyIk
         UyUOGojcSjUE9tGQDe8IDj0f6bkKSySvGtgH6bDkA54ZJTsVHUZL+8isBp/JrHO2md
         903bq0eMqbsrIVDUCEOCIlC5Rlc+ctOIk2KMWwxn989pahjFdafLQX2ds7f9eq5GTk
         0cUF4HQ91vdmJprbQ7FFa2VEwdb+PMYHLKdJj6QjfkowNhrbuX6ryIVm/hYaA0TXfG
         658DuUEtAIoeA==
Date:   Mon, 18 Jan 2021 20:33:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net/qla3xxx: switch from 'pci_' to 'dma_' API
Message-ID: <20210118203336.6e7170a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210117081542.560021-1-christophe.jaillet@wanadoo.fr>
References: <20210117081542.560021-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Jan 2021 09:15:42 +0100 Christophe JAILLET wrote:
> @@ -2525,9 +2519,8 @@ static int ql_alloc_net_req_rsp_queues(struct ql3_adapter *qdev)
>  	wmb();
>  
>  	qdev->req_q_virt_addr =
> -	    pci_alloc_consistent(qdev->pdev,
> -				 (size_t) qdev->req_q_size,
> -				 &qdev->req_q_phy_addr);
> +	    dma_alloc_coherent(&qdev->pdev->dev, (size_t)qdev->req_q_size,
> +			       &qdev->req_q_phy_addr, GFP_KERNEL);
>  
>  	if ((qdev->req_q_virt_addr == NULL) ||
>  	    LS_64BITS(qdev->req_q_phy_addr) & (qdev->req_q_size - 1)) {
> @@ -2536,16 +2529,14 @@ static int ql_alloc_net_req_rsp_queues(struct ql3_adapter *qdev)
>  	}
>  
>  	qdev->rsp_q_virt_addr =
> -	    pci_alloc_consistent(qdev->pdev,
> -				 (size_t) qdev->rsp_q_size,
> -				 &qdev->rsp_q_phy_addr);
> +	    dma_alloc_coherent(&qdev->pdev->dev, (size_t)qdev->rsp_q_size,
> +			       &qdev->rsp_q_phy_addr, GFP_KERNEL);
>  
>  	if ((qdev->rsp_q_virt_addr == NULL) ||
>  	    LS_64BITS(qdev->rsp_q_phy_addr) & (qdev->rsp_q_size - 1)) {
>  		netdev_err(qdev->ndev, "rspQ allocation failed\n");
> -		pci_free_consistent(qdev->pdev, (size_t) qdev->req_q_size,
> -				    qdev->req_q_virt_addr,
> -				    qdev->req_q_phy_addr);
> +		dma_free_coherent(&qdev->pdev->dev, (size_t)qdev->req_q_size,
> +				  qdev->req_q_virt_addr, qdev->req_q_phy_addr);
>  		return -ENOMEM;
>  	}

Something to follow up on - the error handling in this function looks
pretty sketchy. Looks like if the buffer was allocated but these
alignment conditions trigger the buffer is not freed. Happens both for
req and rsp buffer.

Applied, thanks!
