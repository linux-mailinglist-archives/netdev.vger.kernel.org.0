Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09E61DC041
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 22:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgETUeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 16:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgETUeb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 16:34:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB104207E8;
        Wed, 20 May 2020 20:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590006871;
        bh=71WOyBBzruggZxARTe02iQRXeL86FOMExg/5GLlrMxY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E+PD1LJEEcpD+1YtpL78ArPde7fE9l9xXmOyF/goVBvetXLS2AVsKInMq3kKy73pJ
         wXBg5Ej+GpYhVRwUchP2Kc7FNeUVas9JO5mvILJTxn90ZNS25UdT3bGgxOCy8eMeyF
         ZYobM/W67g+m8UPg9BnF2RZCjmADpgVK3D4QHuv4=
Date:   Wed, 20 May 2020 13:34:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net] net/tls: Fix driver request resync
Message-ID: <20200520133428.786bd4ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200520151408.8080-1-tariqt@mellanox.com>
References: <20200520151408.8080-1-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 18:14:08 +0300 Tariq Toukan wrote:
> From: Boris Pismenny <borisp@mellanox.com>
> 
> In driver request resync, the hardware requests a resynchronization
> request at some TCP sequence number. If that TCP sequence number does
> not point to a TLS record header, then the resync attempt has failed.
> 
> Failed resync should reset the resync request to avoid spurious resyncs
> after the TCP sequence number has wrapped around.
> 
> Fix this by resetting the resync request when the TLS record header
> sequence number is not before the requested sequence number.
> As a result, drivers may be called with a sequence number that is not
> equal to the requested sequence number.
> 
> Fixes: f953d33ba122 ("net/tls: add kernel-driven TLS RX resync")
> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  net/tls/tls_device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index a562ebaaa33c..cbb13001b4a9 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -714,7 +714,7 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
>  		seq += TLS_HEADER_SIZE - 1;
>  		is_req_pending = resync_req;
>  
> -		if (likely(!is_req_pending) || req_seq != seq ||
> +		if (likely(!is_req_pending) || before(seq, req_seq) ||

So the kernel is going to send the sync message to the device with at
sequence number the device never asked about? 

Kernel usually can't guarantee that the notification will happen,
(memory allocation errors, etc.) so the device needs to do the
restarting itself. The notification should not be necessary.

>  		    !atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0))
>  			return;
>  		break;
