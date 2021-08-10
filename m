Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74623E5C56
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242095AbhHJN4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:56:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233558AbhHJN4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:56:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33AEB61008;
        Tue, 10 Aug 2021 13:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628603746;
        bh=fZas9mDhDErfOtLmKZvforBNwmzZa6S4b9MrrQS7Vo0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z69p3OrbA2jvpVujt4ajJG2902DLmenfK6bEhO7JbATLSohsG6UOAJ9ArCO9ViH0O
         ThFenw7cKQFgzx2EnW5161a1acXEQxpywJ//Jn9KiuqXu91oaGi8sZUQ+jQ6m3IU2M
         3qtd6n+B2xS1n5qwogQPjtx7dtB/VjeZZSbC10xNUcfY0k3stSE9mQUoO5GuGT1A/E
         XeMMWY8SLdD8ckN8z7iNWgbkv6qr+dxEp9N/k2CwgsrgEY2vCK4X2DHigfNYgXLTAM
         W3Df5ro+eU5uYVuYlrMqHRfwHJYKWd3czJRmnwZGotVVrpknbzI4vYCpHxLGjpzi9A
         mKF/BcpZxgvZg==
Date:   Tue, 10 Aug 2021 16:55:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tuo Li <islituo@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        davem@davemloft.net, kuba@kernel.org,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: Re: [PATCH] net: 9p: Fix possible null-pointer dereference in
 p9_cm_event_handler()
Message-ID: <YRKFXpilGXnKZ2yH@unreal>
References: <20210810132007.296008-1-islituo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810132007.296008-1-islituo@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 06:20:07AM -0700, Tuo Li wrote:
> The variable rdma is checked when event->event is equal to 
> RDMA_CM_EVENT_DISCONNECTED:
>   if (rdma)
> 
> This indicates that it can be NULL. If so, a null-pointer dereference will 
> occur when calling complete():
>   complete(&rdma->cm_done);
> 
> To fix this possible null-pointer dereference, calling complete() only 
> when rdma is not NULL.

You need to explain how is it possible and blindly set if () checks.
I would say first "if (rdma)" is not needed, but don't know for sure.

> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Tuo Li <islituo@gmail.com>
> ---
>  net/9p/trans_rdma.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
> index af0a8a6cd3fd..fb3435dfd071 100644
> --- a/net/9p/trans_rdma.c
> +++ b/net/9p/trans_rdma.c
> @@ -285,7 +285,8 @@ p9_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event)
>  	default:
>  		BUG();
>  	}
> -	complete(&rdma->cm_done);
> +	if (rdma)
> +		complete(&rdma->cm_done);
>  	return 0;
>  }
>  
> -- 
> 2.25.1
> 
