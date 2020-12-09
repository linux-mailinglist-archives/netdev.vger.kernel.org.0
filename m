Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251042D49B1
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 20:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387423AbgLITBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 14:01:24 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:53861 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgLITBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 14:01:24 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607540465; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=5GfzdzbB+fwsvf0AVai9LJH91I0i8wyoAJ2b7YZ6u9M=; b=GpWvq+RsJse3ke3R0XIc744jUv4JXjPwKn22Ab/0ZCoW89Ea481oGCKwSzDhcSTcu2R0N0J3
 UqbuIuLJtkkjWMjxZ0r0ZCQ6r7pmJ7GlPKMyLtq5bdfMbyDQRdk5LU1C6AU5U6n8MxzFMIoZ
 30Ail4IW0WTU69LOnKXMxNopDAo=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-west-2.postgun.com with SMTP id
 5fd11ee7395c822bfe0d6fab (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 09 Dec 2020 19:00:55
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C0180C43462; Wed,  9 Dec 2020 19:00:55 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [10.46.162.249] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1A861C433C6;
        Wed,  9 Dec 2020 19:00:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1A861C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH 3/3] net: mhi: Add dedicated alloc thread
To:     Loic Poulain <loic.poulain@linaro.org>, kuba@kernel.org
Cc:     manivannan.sadhasivam@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net
References: <1607526183-25652-1-git-send-email-loic.poulain@linaro.org>
 <1607526183-25652-3-git-send-email-loic.poulain@linaro.org>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <9b4aa706-ce32-0dff-f6d6-28e2e394783e@codeaurora.org>
Date:   Wed, 9 Dec 2020 11:00:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1607526183-25652-3-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/9/20 7:03 AM, Loic Poulain wrote:
> The buffer allocation for RX path is currently done by a work executed
> in the system workqueue. The work to do is quite simple and consists
> mostly in allocating and queueing as much as possible buffers to the MHI
queuing
> RX channel.
> 
> It appears that using a dedicated kthread would be more appropriate to
> prevent
> 1. RX allocation latency introduced by the system queue
> 2. Unbounded work execution, the work only returning when queue is
> full, it can possibly monopolise the workqueue thread on slower systems.
> 
> This patch replaces the system work with a simple kthread that loops on
> buffer allocation and sleeps when queue is full. Moreover it gets rid
> of the local rx_queued variable (to track buffer count), and instead,
> relies on the new mhi_get_free_desc_count helper.
> 
> After pratical testing on a x86_64 machine, this change improves
practical ?
> - Peek throughput (slightly, by few mbps)
> - Throughput stability when concurrent loads are running (stress)
> - CPU usage, less CPU cycles dedicated to the task
> 
> Below is the powertop output for RX allocation task before and after
> this change, when performing UDP download at 6Gbps. Mostly to highlight
> the improvement in term of CPU usage.
> 
> older (system workqueue):
> Usage       Events/s    Category       Description
> 63,2 ms/s     134,0        kWork          mhi_net_rx_refill_work
> 62,8 ms/s     134,3        kWork          mhi_net_rx_refill_work
> 60,8 ms/s     141,4        kWork          mhi_net_rx_refill_work
> 
> newer (dedicated kthread):
> Usage       Events/s    Category       Description
> 20,7 ms/s     155,6        Process        [PID 3360] [mhi-net-rx]
> 22,2 ms/s     169,6        Process        [PID 3360] [mhi-net-rx]
> 22,3 ms/s     150,2        Process        [PID 3360] [mhi-net-rx]
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>   drivers/net/mhi_net.c | 98 ++++++++++++++++++++++++++-------------------------
>   1 file changed, 50 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> index 0333e07..eef40f5 100644
> --- a/drivers/net/mhi_net.c
> +++ b/drivers/net/mhi_net.c
> @@ -5,6 +5,7 @@
>    */
>   
>   #include <linux/if_arp.h>
> +#include <linux/kthread.h>
>   #include <linux/mhi.h>
>   #include <linux/mod_devicetable.h>
>   #include <linux/module.h>
> @@ -25,7 +26,6 @@ struct mhi_net_stats {
>   	u64_stats_t tx_bytes;
>   	u64_stats_t tx_errors;
>   	u64_stats_t tx_dropped;
> -	atomic_t rx_queued;
>   	struct u64_stats_sync tx_syncp;
>   	struct u64_stats_sync rx_syncp;
>   };
> @@ -33,17 +33,59 @@ struct mhi_net_stats {
>   struct mhi_net_dev {
>   	struct mhi_device *mdev;
>   	struct net_device *ndev;
> -	struct delayed_work rx_refill;
> +	struct task_struct *refill_task;
> +	wait_queue_head_t refill_wq;
>   	struct mhi_net_stats stats;
>   	u32 rx_queue_sz;
>   };
>   
> +static int mhi_net_refill_thread(void *data)
> +{
> +	struct mhi_net_dev *mhi_netdev = data;
> +	struct net_device *ndev = mhi_netdev->ndev;
> +	struct mhi_device *mdev = mhi_netdev->mdev;
> +	int size = READ_ONCE(ndev->mtu);
> +	struct sk_buff *skb;
> +	int err;
> +
> +	while (1) {
> +		err = wait_event_interruptible(mhi_netdev->refill_wq,
> +					       !mhi_queue_is_full(mdev, DMA_FROM_DEVICE)
> +					       || kthread_should_stop());
> +		if (err || kthread_should_stop())
> +			break;
> +
> +		skb = netdev_alloc_skb(ndev, size);
> +		if (unlikely(!skb)) {
> +			/* No memory, retry later */
> +			schedule_timeout_interruptible(msecs_to_jiffies(250));
> +			continue;
> +		}
> +
> +		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, size, MHI_EOT);
> +		if (unlikely(err)) {
> +			net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
> +					    ndev->name, err);
> +			kfree_skb(skb);
> +			break;
> +		}
> +
> +		/* Do not hog the CPU */
> +		cond_resched();
> +	}
> +
> +	return 0;
> +}
> +
>   static int mhi_ndo_open(struct net_device *ndev)
>   {
>   	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
>   
> -	/* Feed the rx buffer pool */
> -	schedule_delayed_work(&mhi_netdev->rx_refill, 0);
> +	mhi_netdev->refill_task = kthread_run(mhi_net_refill_thread, mhi_netdev,
> +					      "mhi-net-rx");
> +	if (IS_ERR(mhi_netdev->refill_task)) {
nit: you can remove curly brace for single statement
> +		return PTR_ERR(mhi_netdev->refill_task);
> +	}
>   
>   	/* Carrier is established via out-of-band channel (e.g. qmi) */
>   	netif_carrier_on(ndev);
> @@ -57,9 +99,9 @@ static int mhi_ndo_stop(struct net_device *ndev)
>   {
>   	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
>   
> +	kthread_stop(mhi_netdev->refill_task);
>   	netif_stop_queue(ndev);
>   	netif_carrier_off(ndev);
> -	cancel_delayed_work_sync(&mhi_netdev->rx_refill);
>   
>   	return 0;
>   }
> @@ -138,9 +180,6 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
>   {
>   	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
>   	struct sk_buff *skb = mhi_res->buf_addr;
> -	int remaining;
> -
> -	remaining = atomic_dec_return(&mhi_netdev->stats.rx_queued);
>   
>   	if (unlikely(mhi_res->transaction_status)) {
>   		dev_kfree_skb_any(skb);
> @@ -163,9 +202,8 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
>   		netif_rx(skb);
>   	}
>   
> -	/* Refill if RX buffers queue becomes low */
> -	if (remaining <= mhi_netdev->rx_queue_sz / 2)
> -		schedule_delayed_work(&mhi_netdev->rx_refill, 0);
> +	if (mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE) >= mhi_netdev->rx_queue_sz / 3)
would it be helpful to add a module param instead of rx_queue_sz/3, 
which can help to fine tune when you wake up kthread at run time. 
Comparing to the value used last used now you are dividing by 3.
> +		wake_up_interruptible(&mhi_netdev->refill_wq);
>   }
>   
>   static void mhi_net_ul_callback(struct mhi_device *mhi_dev,
> @@ -200,42 +238,6 @@ static void mhi_net_ul_callback(struct mhi_device *mhi_dev,
>   		netif_wake_queue(ndev);
>   }
>   
> -static void mhi_net_rx_refill_work(struct work_struct *work)
> -{
> -	struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
> -						      rx_refill.work);
> -	struct net_device *ndev = mhi_netdev->ndev;
> -	struct mhi_device *mdev = mhi_netdev->mdev;
> -	int size = READ_ONCE(ndev->mtu);
> -	struct sk_buff *skb;
> -	int err;
> -
> -	while (atomic_read(&mhi_netdev->stats.rx_queued) < mhi_netdev->rx_queue_sz) {
> -		skb = netdev_alloc_skb(ndev, size);
> -		if (unlikely(!skb))
> -			break;
> -
> -		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, size, MHI_EOT);
> -		if (unlikely(err)) {
> -			net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
> -					    ndev->name, err);
> -			kfree_skb(skb);
> -			break;
> -		}
> -
> -		atomic_inc(&mhi_netdev->stats.rx_queued);
> -
> -		/* Do not hog the CPU if rx buffers are consumed faster than
> -		 * queued (unlikely).
> -		 */
> -		cond_resched();
> -	}
> -
> -	/* If we're still starved of rx buffers, reschedule later */
> -	if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
> -		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
> -}
> -
>   static int mhi_net_probe(struct mhi_device *mhi_dev,
>   			 const struct mhi_device_id *id)
>   {
> @@ -256,7 +258,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
>   	mhi_netdev->mdev = mhi_dev;
>   	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
>   
> -	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
> +	init_waitqueue_head(&mhi_netdev->refill_wq);
>   	u64_stats_init(&mhi_netdev->stats.rx_syncp);
>   	u64_stats_init(&mhi_netdev->stats.tx_syncp);
>   
> 
Thanks,
Hemant
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
