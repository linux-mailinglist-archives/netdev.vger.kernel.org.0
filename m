Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BFC287ECA
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 00:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730578AbgJHWrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 18:47:46 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55775 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgJHWrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 18:47:45 -0400
Received: by mail-wm1-f67.google.com with SMTP id d4so7950962wmd.5
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 15:47:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=myET8DqnZqvbDgPBngwcFUQxMHa6/4RcZksUikkSMe8=;
        b=jCPTRWNE2G7Atdg4zROv7ujA05R2Kg4YujvV+ccLW/+PX/jz/fF5s+f82aAmVQFBvp
         FZsxpIMDSJ5BB3aHBihIr4B09FBYSYAlEbnMnGFKOF1RTMnTaPb+oisb6k2645GAkXwL
         GGLrNuhotFjCA+mdvqzQZhDUH7D4nKffYxlHGLr2G3LKhxTp3dN3kT4Pj+z7duzQOqBI
         F6tBJEc4pz3Jq/qlqFyEuRug2N+9egYmF5YAzDSHMrD5OcbVjoX/mzN7Q9rxVGqR0VrV
         PL/NfLhe/AfIpXMTI+/v9y9XVnyZpXsOdR9rMK38ce+cHzUsrxKHchOuF/uzF5qPbLfj
         5JoQ==
X-Gm-Message-State: AOAM533YWjjZuk9GdwJmDqSqFxvxZJ5eXNsyOjq47eX4HPUwDK66W92p
        c5u5/Gpb6y//FuDSqoSyn5Y=
X-Google-Smtp-Source: ABdhPJyT43XB0vMUH89OAuDnOhzflLVRD7yxBGR62gVIcWU1MGydvxwjPXNofkMxxcCcVaoBH0gnBw==
X-Received: by 2002:a7b:c935:: with SMTP id h21mr10377582wml.99.1602197263796;
        Thu, 08 Oct 2020 15:47:43 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:68d6:3fd5:5a8b:9959? ([2601:647:4802:9070:68d6:3fd5:5a8b:9959])
        by smtp.gmail.com with ESMTPSA id q20sm8805434wmc.39.2020.10.08.15.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 15:47:43 -0700 (PDT)
Subject: Re: [PATCH net-next RFC v1 08/10] nvme-tcp: Deal with netdevice DOWN
 events
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-9-borisp@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <67e29f83-5bab-4abd-44c0-9c5ae29d5784@grimberg.me>
Date:   Thu, 8 Oct 2020 15:47:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200930162010.21610-9-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/20 9:20 AM, Boris Pismenny wrote:
> From: Or Gerlitz <ogerlitz@mellanox.com>
> 
> For ddp setup/teardown and resync, the offloading logic
> uses HW resources at the NIC driver such as SQ and CQ.
> 
> These resources are destroyed when the netdevice does down
> and hence we must stop using them before the NIC driver
> destroyes them.
> 
> Use netdevice notifier for that matter -- offloaded connections
> are stopped before the stack continues to call the NIC driver
> close ndo.
> 
> We use the existing recovery flow which has the advantage
> of resuming the offload once the connection is re-set.
> 
> Since the recovery flow runs in a separate/dedicated WQ
> we need to wait in the notifier code for an ACK that all
> offloaded queues were stopped which means that the teardown
> queue offload ndo was called and the NIC doesn't have any
> resources related to that connection any more.
> 
> This also buys us proper handling for the UNREGISTER event
> b/c our offloading starts in the UP state, and down is always
> there between up to unregister.
> 
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
> Signed-off-by: Yoray Zack <yorayz@mellanox.com>
> ---
>   drivers/nvme/host/tcp.c | 39 +++++++++++++++++++++++++++++++++++++--
>   1 file changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
> index 9a620d1dacb4..7569b47f0414 100644
> --- a/drivers/nvme/host/tcp.c
> +++ b/drivers/nvme/host/tcp.c
> @@ -144,6 +144,7 @@ struct nvme_tcp_ctrl {
>   
>   static LIST_HEAD(nvme_tcp_ctrl_list);
>   static DEFINE_MUTEX(nvme_tcp_ctrl_mutex);
> +static struct notifier_block nvme_tcp_netdevice_nb;
>   static struct workqueue_struct *nvme_tcp_wq;
>   static const struct blk_mq_ops nvme_tcp_mq_ops;
>   static const struct blk_mq_ops nvme_tcp_admin_mq_ops;
> @@ -412,8 +413,6 @@ int nvme_tcp_offload_limits(struct nvme_tcp_queue *queue,
>   		queue->ctrl->ctrl.max_segments = limits->max_ddp_sgl_len;
>   		queue->ctrl->ctrl.max_hw_sectors =
>   			limits->max_ddp_sgl_len << (ilog2(SZ_4K) - 9);
> -	} else {
> -		queue->ctrl->offloading_netdev = NULL;

Squash this change to the patch that introduced it.

>   	}
>   
>   	dev_put(netdev);
> @@ -1992,6 +1991,8 @@ static int nvme_tcp_alloc_admin_queue(struct nvme_ctrl *ctrl)
>   {
>   	int ret;
>   
> +	to_tcp_ctrl(ctrl)->offloading_netdev = NULL;
> +
>   	ret = nvme_tcp_alloc_queue(ctrl, 0, NVME_AQ_DEPTH);
>   	if (ret)
>   		return ret;
> @@ -2885,6 +2886,26 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
>   	return ERR_PTR(ret);
>   }
>   
> +static int nvme_tcp_netdev_event(struct notifier_block *this,
> +				 unsigned long event, void *ptr)
> +{
> +	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
> +	struct nvme_tcp_ctrl *ctrl;
> +
> +	switch (event) {
> +	case NETDEV_GOING_DOWN:
> +		mutex_lock(&nvme_tcp_ctrl_mutex);
> +		list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list) {
> +			if (ndev != ctrl->offloading_netdev)
> +				continue;
> +			nvme_tcp_error_recovery(&ctrl->ctrl);
> +		}
> +		mutex_unlock(&nvme_tcp_ctrl_mutex);
> +		flush_workqueue(nvme_reset_wq);

Worth a small comment that this we want the err_work to complete
here. So if someone changes workqueues he may see this.

> +	}
> +	return NOTIFY_DONE;
> +}
> +
>   static struct nvmf_transport_ops nvme_tcp_transport = {
>   	.name		= "tcp",
>   	.module		= THIS_MODULE,
