Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0485B2B3169
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 00:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgKNXfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 18:35:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgKNXfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 18:35:03 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4DDB24137;
        Sat, 14 Nov 2020 23:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605396903;
        bh=s9LmfnlBd6X9FQ2JJqe9YkY9PUM+P1pzFglNu4NzenE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a3hkq6994bhB9cavqK6NCPIPZfxYZV23S/xMP0C60Y3Ey3mdDbmfxnYcot8Wbri0c
         /FO6Xtmsirm/PbcNorKRsL9JgGgVI6cMD9azcWGFBeSA87qIW6IuFDT40DuYv98xYN
         7niWW+1Jls6GUJusktlhLQM4tipuS6z4U9czB8ic=
Date:   Sat, 14 Nov 2020 15:35:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        ricklind@linux.ibm.com
Subject: Re: [PATCH net-next 02/12] ibmvnic: Introduce indirect subordinate
 Command Response Queue buffer
Message-ID: <20201114153501.66072756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605208207-1896-3-git-send-email-tlfalcon@linux.ibm.com>
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
        <1605208207-1896-3-git-send-email-tlfalcon@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 13:09:57 -0600 Thomas Falcon wrote:
> This patch introduces the infrastructure to send batched subordinate
> Command Response Queue descriptors, which are used by the ibmvnic
> driver to send TX frame and RX buffer descriptors.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

> @@ -2957,6 +2963,19 @@ static struct ibmvnic_sub_crq_queue *init_sub_crq_queue(struct ibmvnic_adapter
>  
>  	scrq->adapter = adapter;
>  	scrq->size = 4 * PAGE_SIZE / sizeof(*scrq->msgs);
> +	scrq->ind_buf.index = 0;
> +
> +	scrq->ind_buf.indir_arr =
> +		dma_alloc_coherent(dev,
> +				   IBMVNIC_IND_ARR_SZ,
> +				   &scrq->ind_buf.indir_dma,
> +				   GFP_KERNEL);
> +
> +	if (!scrq->ind_buf.indir_arr) {
> +		dev_err(dev, "Couldn't allocate indirect scrq buffer\n");

This warning/error is not necessary, memory allocation will trigger an
OOM message already.

> +		goto reg_failed;

Don't you have to do something like 

                        rc = plpar_hcall_norets(H_FREE_SUB_CRQ,                 
                                                adapter->vdev->unit_address,    
                                                scrq->crq_num); 

?

> +	}
> +
>  	spin_lock_init(&scrq->lock);
>  
