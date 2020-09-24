Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E54277B0D
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 23:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgIXVak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 17:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIXVaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 17:30:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2096023899;
        Thu, 24 Sep 2020 21:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600983039;
        bh=JLTgyx3/ordPQJ0s7RPOOiLnDQrifKOlAyP3ibdH3Lk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XqtUoDjAcfPfpb6PdVr3P1fO7deUhtgOTgwDZVin2Eye60d330C4lNIwuzSCYYOMt
         SVN/kAjw+7w0H2841N7RQRNTM2RFAbhUETBABuu0e77rmDSXFL1Jz8bXd5JG8dT2mL
         pBhFMkmHz2QnECHA53o/hnuCdN00LFw3pYqGwqHQ=
Date:   Thu, 24 Sep 2020 14:30:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [net-next v2 1/3] ch_ktls: Issue if connection offload fails
Message-ID: <20200924143037.6a68a1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200924063639.18005-2-rohitm@chelsio.com>
References: <20200924063639.18005-1-rohitm@chelsio.com>
        <20200924063639.18005-2-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020 12:06:37 +0530 Rohit Maheshwari wrote:
> +	if (chcr_setup_connection(sk, tx_info))
> +		goto put_module;
> +
> +	/* Wait for reply */
> +	wait_for_completion_timeout(&tx_info->completion, 30 * HZ);
> +	if (tx_info->open_pending)
> +		goto put_module;

How do you handle reply coming back after timeout?
Won't chcr_ktls_cpl_act_open_rpl() access tx_info after it has already
been freed?

> +	/* initialize tcb */
> +	reinit_completion(&tx_info->completion);
> +	tx_info->open_pending = true;
> +
> +	if (chcr_init_tcb_fields(tx_info))
> +		goto free_tid;
> +
> +	/* Wait for reply */
> +	wait_for_completion_timeout(&tx_info->completion, 30 * HZ);
> +	if (tx_info->open_pending)
> +		goto free_tid;
> +
> +	if (!cxgb4_check_l2t_valid(tx_info->l2te))
> +		goto close_tcb;
> +
> +	atomic64_inc(&adap->ch_ktls_stats.ktls_tx_ctx);
> +	tx_ctx->chcr_info = tx_info;
>  
> -	atomic64_inc(&adap->ch_ktls_stats.ktls_tx_connection_open);
>  	return 0;
> -out2:
> +
> +close_tcb:
> +	chcr_ktls_mark_tcb_close(tx_info);
> +free_tid:
> +#if IS_ENABLED(CONFIG_IPV6)
> +	/* clear clip entry */
> +	if (tx_info->ip_family == AF_INET6)
> +		cxgb4_clip_release(netdev, (const u32 *)
> +				   &sk->sk_v6_rcv_saddr,
> +				   1);
> +#endif
> +	cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
> +			 tx_info->tid, tx_info->ip_family);
> +
> +put_module:
> +	/* release module refcount */
> +	module_put(THIS_MODULE);
> +free_l2t:
> +	cxgb4_l2t_release(tx_info->l2te);
> +free_tx_info:
>  	kvfree(tx_info);
>  out:
>  	atomic64_inc(&adap->ch_ktls_stats.ktls_tx_connection_fail);
> -	return ret;
> +	return -1;
>  }
