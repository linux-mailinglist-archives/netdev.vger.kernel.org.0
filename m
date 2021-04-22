Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4693678AC
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 06:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhDVE0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 00:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhDVE0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 00:26:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E640160698;
        Thu, 22 Apr 2021 04:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619065573;
        bh=M9WEz3stHuTUGOfvNJEUfe/rwnc74K79vU61YmvGy0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q+rDhgjON4c6Nb4n2eD5hZDXOs2ZmfIz1ofKdwD4pMNcbPm7z5kZj5jSJX0iwsk8C
         HeFzHgtv96tefEI7bFgKNMsNTNzId6f8MlUtXLpZ0anZc3UMSfzEfFgR5mWBGiLh4X
         mOckdniayURhzzP2A41yXkTJEDxeWLffHa1xxB147y5g5vkl9uy7PX1lKAFB4ODiWP
         /hJDOArWoWIkuK6CsSl6ff0WGhw5XpXYP7f0hXcBvuru8StEt8Mws15v7654fiCZkK
         YJiD/u5d4+r7NtPD7MnnLN0RsQCZW1PfRMs2EpPYqQ5I5HPSKFHn7ZgcAV4OQVZW9f
         p6ag06Tz8ERkA==
Date:   Thu, 22 Apr 2021 09:56:04 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: Avoid potential use after free in MHI send
Message-ID: <20210422042604.GB14470@work>
References: <20210421174007.2954194-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421174007.2954194-1-bjorn.andersson@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 10:40:07AM -0700, Bjorn Andersson wrote:
> It is possible that the MHI ul_callback will be invoked immediately
> following the queueing of the skb for transmission, leading to the
> callback decrementing the refcount of the associated sk and freeing the
> skb.
> 
> As such the dereference of skb and the increment of the sk refcount must
> happen before the skb is queued, to avoid the skb to be used after free
> and potentially the sk to drop its last refcount..
> 
> Fixes: 6e728f321393 ("net: qrtr: Add MHI transport layer")
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  net/qrtr/mhi.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
> index 2bf2b1943e61..fa611678af05 100644
> --- a/net/qrtr/mhi.c
> +++ b/net/qrtr/mhi.c
> @@ -50,6 +50,9 @@ static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
>  	struct qrtr_mhi_dev *qdev = container_of(ep, struct qrtr_mhi_dev, ep);
>  	int rc;
>  
> +	if (skb->sk)
> +		sock_hold(skb->sk);
> +
>  	rc = skb_linearize(skb);
>  	if (rc)
>  		goto free_skb;
> @@ -59,12 +62,11 @@ static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
>  	if (rc)
>  		goto free_skb;
>  
> -	if (skb->sk)
> -		sock_hold(skb->sk);
> -
>  	return rc;
>  
>  free_skb:
> +	if (skb->sk)
> +		sock_put(skb->sk);
>  	kfree_skb(skb);
>  
>  	return rc;
> -- 
> 2.29.2
> 
