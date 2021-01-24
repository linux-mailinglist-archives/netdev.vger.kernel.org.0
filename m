Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD21F301999
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 06:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbhAXFJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 00:09:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:48678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbhAXFJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 00:09:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED695224F9;
        Sun, 24 Jan 2021 05:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611464914;
        bh=zcJC9my3DOmBZvjYAol0q9GMo5cwNonaphiRrJzxvcc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qUGxXunePAC7GPvw3tUMuDCf/N59zA9rrffbD9J+EwJknqfPj0g88ja+iNifdKzPm
         fMiAXSNWnEUALUm3X7Jt43syWByMmPz/XFTVf7VYinfzXOtQUzVb5cz/UdwbKuWU0R
         cE92CySb5pm7MUZJp6CTgYdWLKJhX6Zk+zogCEfG8jPWl5atYToXJ3SXeLdGOvoUbB
         kZChykOiy/D+EJqk0VoDEifrEhcQIJ4lfgU4OpQUlAHfBP2svveD0bOKT5fIREtN1M
         qrRbbROjXhLmpe/dSTJp1AT5C28/YtuW39WV8FQsTCHN9QTwWgSOiqZU2wfKfHnrVf
         MHbPvpsJm1tYg==
Date:   Sat, 23 Jan 2021 21:08:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 1/3] ibmvnic: rework to ensure SCRQ entry reads are
 properly ordered
Message-ID: <20210123210833.21f6b8de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121061710.53217-2-ljp@linux.ibm.com>
References: <20210121061710.53217-1-ljp@linux.ibm.com>
        <20210121061710.53217-2-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 00:17:08 -0600 Lijun Pan wrote:
> Move the dma_rmb() between pending_scrq() and ibmvnic_next_scrq()
> into the end of pending_scrq(), and explain why.
> Explain in detail why the dma_rmb() is placed at the end of
> ibmvnic_next_scrq().
> 
> Fixes: b71ec9522346 ("ibmvnic: Ensure that SCRQ entry reads are correctly ordered")
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>

I fail to see why this is a fix. You move the barrier from caller to
callee but there are no new barriers here. Did I miss some?

> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 9778c83150f1..8e043683610f 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2511,12 +2511,6 @@ static int ibmvnic_poll(struct napi_struct *napi, int budget)
>  
>  		if (!pending_scrq(adapter, rx_scrq))
>  			break;
> -		/* The queue entry at the current index is peeked at above
> -		 * to determine that there is a valid descriptor awaiting
> -		 * processing. We want to be sure that the current slot
> -		 * holds a valid descriptor before reading its contents.
> -		 */
> -		dma_rmb();
>  		next = ibmvnic_next_scrq(adapter, rx_scrq);
>  		rx_buff =
>  		    (struct ibmvnic_rx_buff *)be64_to_cpu(next->
> @@ -3256,13 +3250,6 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
>  		int total_bytes = 0;
>  		int num_packets = 0;
>  
> -		/* The queue entry at the current index is peeked at above
> -		 * to determine that there is a valid descriptor awaiting
> -		 * processing. We want to be sure that the current slot
> -		 * holds a valid descriptor before reading its contents.
> -		 */
> -		dma_rmb();
> -
>  		next = ibmvnic_next_scrq(adapter, scrq);
>  		for (i = 0; i < next->tx_comp.num_comps; i++) {
>  			if (next->tx_comp.rcs[i])
> @@ -3636,11 +3623,25 @@ static int pending_scrq(struct ibmvnic_adapter *adapter,
>  			struct ibmvnic_sub_crq_queue *scrq)
>  {
>  	union sub_crq *entry = &scrq->msgs[scrq->cur];
> +	int rc;
>  
>  	if (entry->generic.first & IBMVNIC_CRQ_CMD_RSP)
> -		return 1;
> +		rc = 1;
>  	else
> -		return 0;
> +		rc = 0;
> +
> +	/* Ensure that the entire SCRQ descriptor scrq->msgs
> +	 * has been loaded before reading its contents.

This comment is confusing. IMHO the comments you're removing are much
clearer.

> +	 * This barrier makes sure this function's entry, esp.
> +	 * entry->generic.first & IBMVNIC_CRQ_CMD_RSP
> +	 * 1. is loaded before ibmvnic_next_scrq()'s
> +	 * entry->generic.first & IBMVNIC_CRQ_CMD_RSP;
> +	 * 2. OR is loaded before ibmvnic_poll()'s
> +	 * disable_scrq_irq()'s scrq->hw_irq.
> +	 */
> +	dma_rmb();
> +
> +	return rc;
>  }
>  
>  static union sub_crq *ibmvnic_next_scrq(struct ibmvnic_adapter *adapter,

