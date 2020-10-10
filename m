Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A186C28A443
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388332AbgJJWxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:53:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730332AbgJJSve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 14:51:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85F37223BD;
        Sat, 10 Oct 2020 18:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602355893;
        bh=JNOsIeD12F+9MNDjjZnrguy+mJxJuiZof73TVNTcE20=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rEXl9wcPr0Fk2GdrRdnUdN5oEt+tn3s0k2niNZMlB9NSsp82pnNmtZ1vMNgWQ9Li3
         HEijIFb3iN3qpL7PnwSW09MEM5H0HRcsKQdnBa5pCiAeXElLOx4Ln0192b51SapwzH
         UWg8ajlyeldlTFEFg9q+5kcZP9RO8zUA6riKcMOA=
Date:   Sat, 10 Oct 2020 11:51:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <kernel-team@fb.com>
Subject: Re: [PATCH net-next] virtio_net: handle non-napi callers to
 virtnet_poll_tx
Message-ID: <20201010115131.559376e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008183436.3093286-1-jonathan.lemon@gmail.com>
References: <20201008183436.3093286-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Oct 2020 11:34:36 -0700 Jonathan Lemon wrote:
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 21b71148c532..59f65ac9e4c7 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1518,7 +1518,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>  
>  	txq = netdev_get_tx_queue(vi->dev, index);
>  	__netif_tx_lock(txq, raw_smp_processor_id());
> -	free_old_xmit_skbs(sq, true);
> +	free_old_xmit_skbs(sq, budget != 0);
>  	__netif_tx_unlock(txq);
>  
>  	virtqueue_napi_complete(napi, sq->vq, 0);

Looks like virtnet_poll_cleantx() needs the same treatment.
