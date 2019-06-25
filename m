Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 077E9559C3
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfFYVOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:14:20 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39316 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYVOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:14:20 -0400
Received: by mail-oi1-f196.google.com with SMTP id m202so249601oig.6;
        Tue, 25 Jun 2019 14:14:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wnw6wjI7S5ZzMobxPMeZ85qxHfts3VnOb06gyBkQGVw=;
        b=DnOBIbBrufbJZK81x/wN3K+mtOLj+EMUiWU5ZO1JOkd/Oif1smCJLUj3Coxo/FJXzs
         gyJF4yUBMkSxA5N+xkhZ1HRfCFi1vVFYXy8aDP9nDXRSA4V4kIWu8Oez1DPBuLBC7lpw
         7dNHiXa45aDmSQevc7wFqSbZNLbmaszT6zz6mKUiR+podaeaFcQH4j5DXIHU+h+5rVoQ
         2qoufabt6r7Ovfcopjcn9X2HP5D4/c5/cZ8Y33m6Xn1xiIHxZcB6W7oXfy2pnvJHgjJF
         3m+ncLvpeBiXEIRpkS3Z9kEv1UwYaLEc+IEoSozU2YRBNHrpPigUMoog1oXB0CHKoqTP
         W2EA==
X-Gm-Message-State: APjAAAXs2D+DEHhNfoKbWs/k1tuY2s71fJs4fUHHpSWEj5M9KiatjjS4
        e4uQgWZ3mcYDkF2L45rjQ4k=
X-Google-Smtp-Source: APXvYqxg2/T3hbxLJxyKUhGchj/IryTqMjuSOVZb/Ri45KdHJGi/XOSRUlG7bBVsTyLt1Vz83b1t3A==
X-Received: by 2002:aca:aa93:: with SMTP id t141mr15850578oie.128.1561497259817;
        Tue, 25 Jun 2019 14:14:19 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id r129sm6086657oih.16.2019.06.25.14.14.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 14:14:19 -0700 (PDT)
Subject: Re: [for-next V2 10/10] RDMA/core: Provide RDMA DIM support for ULPs
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yamin Friedman <yaminf@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-11-saeedm@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <adb3687a-6db3-b1a4-cd32-8b4889550c81@grimberg.me>
Date:   Tue, 25 Jun 2019 14:14:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625205701.17849-11-saeedm@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> +static int ib_poll_dim_handler(struct irq_poll *iop, int budget)
> +{
> +	struct ib_cq *cq = container_of(iop, struct ib_cq, iop);
> +	struct dim *dim = cq->dim;
> +	int completed;
> +
> +	completed = __ib_process_cq(cq, budget, cq->wc, IB_POLL_BATCH);
> +	if (completed < budget) {
> +		irq_poll_complete(&cq->iop);
> +		if (ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
> +			irq_poll_sched(&cq->iop);
> +	}
> +
> +	rdma_dim(dim, completed);

Why duplicate the entire thing for a one-liner?

> +
> +	return completed;
> +}
> +
>   static void ib_cq_completion_softirq(struct ib_cq *cq, void *private)
>   {
>   	irq_poll_sched(&cq->iop);
> @@ -105,14 +157,18 @@ static void ib_cq_completion_softirq(struct ib_cq *cq, void *private)
>   
>   static void ib_cq_poll_work(struct work_struct *work)
>   {
> -	struct ib_cq *cq = container_of(work, struct ib_cq, work);
> +	struct ib_cq *cq = container_of(work, struct ib_cq,
> +					work);

Why was that changed?

>   	int completed;
>   
>   	completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE, cq->wc,
>   				    IB_POLL_BATCH);
> +

newline?

>   	if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
>   	    ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
>   		queue_work(cq->comp_wq, &cq->work);
> +	else if (cq->dim)
> +		rdma_dim(cq->dim, completed);
>   }
>   
>   static void ib_cq_completion_workqueue(struct ib_cq *cq, void *private)
> @@ -166,6 +222,8 @@ struct ib_cq *__ib_alloc_cq_user(struct ib_device *dev, void *private,
>   	rdma_restrack_set_task(&cq->res, caller);
>   	rdma_restrack_kadd(&cq->res);
>   
> +	rdma_dim_init(cq);
> +
>   	switch (cq->poll_ctx) {
>   	case IB_POLL_DIRECT:
>   		cq->comp_handler = ib_cq_completion_direct;
> @@ -173,7 +231,13 @@ struct ib_cq *__ib_alloc_cq_user(struct ib_device *dev, void *private,
>   	case IB_POLL_SOFTIRQ:
>   		cq->comp_handler = ib_cq_completion_softirq;
>   
> -		irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ, ib_poll_handler);
> +		if (cq->dim) {
> +			irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ,
> +				      ib_poll_dim_handler);
> +		} else
> +			irq_poll_init(&cq->iop, IB_POLL_BUDGET_IRQ,
> +				      ib_poll_handler);
> +
>   		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
>   		break;
>   	case IB_POLL_WORKQUEUE:
> @@ -226,6 +290,9 @@ void ib_free_cq_user(struct ib_cq *cq, struct ib_udata *udata)
>   		WARN_ON_ONCE(1);
>   	}
>   
> +	if (cq->dim)
> +		cancel_work_sync(&cq->dim->work);
> +	kfree(cq->dim);
>   	kfree(cq->wc);
>   	rdma_restrack_del(&cq->res);
>   	ret = cq->device->ops.destroy_cq(cq, udata);
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index abac70ad5c7c..b1b45dbe24a5 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -6305,6 +6305,8 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
>   	     MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
>   		mutex_init(&dev->lb.mutex);
>   
> +	dev->ib_dev.use_cq_dim = true;
> +

Please don't. This is a bad choice to opt it in by default.
