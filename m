Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0812BB38E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbgKTSgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:36:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730756AbgKTSgJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:36:09 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC5AC24181;
        Fri, 20 Nov 2020 18:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897369;
        bh=rS0YIKVVRyNsQkOKK/tQWxOgQxXTreze2rRFeXKvEAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ae5q+qbX2Ydk70fnDMl48LIk1P2S/4MDkuwNjbtleQb++tsjDbGotfTJnGH34l1kC
         vXniBm9JvI2cw4ikXSU9SOQBGRGn8OYEjvcCJ9rE1OySjTEVCDAFAYK3y0JkDy7q0p
         0ivbooo94Lx4kQ9rok53FeHGhXkufJP+S+AOPq9A=
Date:   Fri, 20 Nov 2020 10:36:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [net] ch_ktls: lock is not freed
Message-ID: <20201120103607.58074173@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201118082107.7551-1-rohitm@chelsio.com>
References: <20201118082107.7551-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 13:51:07 +0530 Rohit Maheshwari wrote:
> Currently lock gets freed only if timeout expires, but missed a
> case when HW returns failure and goes for cleanup.
> 
> Fixes: efca3878a5fb ("ch_ktls: Issue if connection offload fails")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> ---
>  .../net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c   | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> index c24485c0d512..1f521751666d 100644
> --- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> +++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
> @@ -594,9 +594,10 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
>  free_l2t:
>  	cxgb4_l2t_release(tx_info->l2te);
>  free_tx_info:
> -	if (tx_info->pending_close)
> +	if (tx_info->open_state)
>  		spin_unlock_bh(&tx_info->lock);
> -	else
> +
> +	if (!tx_info->pending_close)
>  		kvfree(tx_info);
>  out:
>  	atomic64_inc(&port_stats->ktls_tx_connection_fail);

Are you 100% sure about this fix? The code seems to be jumping to the
error handler with or without this lock held. E.g. on line 558.

Please release the lock before jumping, in the two places that hold it.
It's far less complicated and actually fewer LoC.
