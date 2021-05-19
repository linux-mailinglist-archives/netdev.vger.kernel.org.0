Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920AF389090
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345897AbhESOTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347357AbhESOT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 10:19:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84FA461244;
        Wed, 19 May 2021 14:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621433889;
        bh=0pvunetzygNqY35KHnnR9Jx2D12exeL0Npca5/mUUOg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bgigDgU9etIAgCNfP0yys107j8RkZ/rYbGLc+9nAKo/TdLpvxeq14yOM+zHdORoVB
         AF2gy0O6MnEkA+WXCb8d5WAxDiP0ipTq/gjwjo2vGVrm/pUkPDDO8KSZrDcNbvRHJ/
         BDvBRZDCzrcdLc6mD5O/X1cbpmuWCGUsPSDSJaBB+/hNojnzwRHw31wWfSM9xUuH5Y
         H3Q3NtEZL65rwR+EhAvFGnn58Sj4dWuhOXfG653SovAE6XStdm7UC2jNtH/ZjRU/zF
         2blWFcAGvoH4BlBWvn7u4ujlQvi1IMRfHNI08/9LROtnq14BeaRJ47ajAMsdsFzhUN
         y57g0RBE25bgA==
Date:   Wed, 19 May 2021 19:48:01 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] net: qrtr: ns: Fix error return code in
 qrtr_ns_init()
Message-ID: <20210519141801.GB119648@thinkpad>
References: <20210519141621.3044684-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519141621.3044684-1-weiyongjun1@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 02:16:21PM +0000, Wei Yongjun wrote:
> Fix to return a negative error code -ENOMEM from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

You might want to add Fixes tag:

Fixes: c6e08d6251f3 ("net: qrtr: Allocate workqueue before kernel_bind")

Thanks,
Mani

> ---
>  net/qrtr/ns.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> index 8d00dfe8139e..1990d496fcfc 100644
> --- a/net/qrtr/ns.c
> +++ b/net/qrtr/ns.c
> @@ -775,8 +775,10 @@ int qrtr_ns_init(void)
>  	}
>  
>  	qrtr_ns.workqueue = alloc_workqueue("qrtr_ns_handler", WQ_UNBOUND, 1);
> -	if (!qrtr_ns.workqueue)
> +	if (!qrtr_ns.workqueue) {
> +		ret = -ENOMEM;
>  		goto err_sock;
> +	}
>  
>  	qrtr_ns.sock->sk->sk_data_ready = qrtr_ns_data_ready;
>  
> 
