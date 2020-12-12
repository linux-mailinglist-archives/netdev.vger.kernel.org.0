Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AF12D8A12
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 21:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407924AbgLLU4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 15:56:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407890AbgLLU41 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 15:56:27 -0500
Date:   Sat, 12 Dec 2020 12:55:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607806545;
        bh=jPDZXLHAE9lhjzp/ZIWzZzg4LLejXh0bczPZn/7JyiY=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=MvSixJWo4Ckpz3dU1VaMKlsZjXqdRCEK57E73kaFvfj1DSu2NtaGBgkC7K9QLrSuM
         fXRxNiRWp5V3Wlr57GpgunhL77Sy8ISGVOw60NwZM1l3xGkQ3lgnWbwQLDkNo8vKen
         QXxRsfJeVOS/tLzEEsR3bgkYDL11DykVCbbVya6RxAOucK+949jzpkEQCfUHgKs9kS
         LWsP3h4ZATrBWCF+KEN1iQ4qt5SrBTuTE4iLtHumtxzRuyCs0siZGJboCefnijfJtw
         CP+FBQDQWY8T3EVuJahjUP7xHuWgZcQPaUoa2jlWUJ2zkHSAQipbqMzL3BB2Qdgi4O
         WGHdjwH04QBzg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, manivannan.sadhasivam@linaro.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        jhugo@codeaurora.org
Subject: Re: [PATCH v2 3/3] net: mhi: Add dedicated alloc thread
Message-ID: <20201212125544.4857b1cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1607598951-2340-3-git-send-email-loic.poulain@linaro.org>
References: <1607598951-2340-1-git-send-email-loic.poulain@linaro.org>
        <1607598951-2340-3-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Dec 2020 12:15:51 +0100 Loic Poulain wrote:
> The buffer allocation for RX path is currently done by a work executed
> in the system workqueue. The work to do is quite simple and consists
> mostly in allocating and queueing as much as possible buffers to the MHI
> RX channel.
> 
> It appears that using a dedicated kthread would be more appropriate to
> prevent
> 1. RX allocation latency introduced by the system queue

System work queue should not add much latency, you can also create your
own workqueue. Did you intend to modify the priority of the thread you
create?

> 2. Unbounded work execution, the work only returning when queue is
> full, it can possibly monopolise the workqueue thread on slower systems.

Is this something you observed in practice?

> This patch replaces the system work with a simple kthread that loops on
> buffer allocation and sleeps when queue is full. Moreover it gets rid
> of the local rx_queued variable (to track buffer count), and instead,
> relies on the new mhi_get_free_desc_count helper.

Seems unrelated, should probably be a separate patch.

> After pratical testing on a x86_64 machine, this change improves
> - Peek throughput (slightly, by few mbps)
> - Throughput stability when concurrent loads are running (stress)
> - CPU usage, less CPU cycles dedicated to the task

Do you have an explanation why the CPU cycles are lower?

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
>  v2: add module parameter for changing RX refill level

> @@ -16,6 +17,11 @@
>  #define MHI_NET_MAX_MTU		0xffff
>  #define MHI_NET_DEFAULT_MTU	0x4000
>  
> +static unsigned int rx_refill_level = 70;
> +module_param(rx_refill_level, uint, 0600);
> +MODULE_PARM_DESC(rx_refill_level,
> +		 "The minimal RX queue level percentage (0 to 100) under which the RX queue must be refilled");

Sorry you got bad advice in v1 and I didn't catch it. Please avoid
adding module parameters. Many drivers do bulk refill, and don't need
and extra parametrization, I don't see why this one would be special -
if it is please explain.

>  struct mhi_net_stats {
>  	u64_stats_t rx_packets;
>  	u64_stats_t rx_bytes;
> @@ -25,7 +31,6 @@ struct mhi_net_stats {
>  	u64_stats_t tx_bytes;
>  	u64_stats_t tx_errors;
>  	u64_stats_t tx_dropped;
> -	atomic_t rx_queued;
>  	struct u64_stats_sync tx_syncp;
>  	struct u64_stats_sync rx_syncp;
>  };
> @@ -33,17 +38,66 @@ struct mhi_net_stats {
>  struct mhi_net_dev {
>  	struct mhi_device *mdev;
>  	struct net_device *ndev;
> -	struct delayed_work rx_refill;
> +	struct task_struct *refill_task;
> +	wait_queue_head_t refill_wq;
>  	struct mhi_net_stats stats;
>  	u32 rx_queue_sz;
> +	u32 rx_refill_level;
>  };
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

You should have a counter for this, at least for your testing. If this
condition is hit it'll probably have a large impact on the performance.

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
>  static int mhi_ndo_open(struct net_device *ndev)
>  {
>  	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> +	unsigned int qsz = mhi_netdev->rx_queue_sz;
>  
> -	/* Feed the rx buffer pool */
> -	schedule_delayed_work(&mhi_netdev->rx_refill, 0);
> +	if (rx_refill_level >= 100)
> +		mhi_netdev->rx_refill_level = 1;
> +	else
> +		mhi_netdev->rx_refill_level = qsz - qsz * rx_refill_level / 100;

So you're switching from 50% fill level to 70%. Are you sure that's not
the reason the performance gets better? Did you experiments with higher
fill levels?

> +	mhi_netdev->refill_task = kthread_run(mhi_net_refill_thread, mhi_netdev,
> +					      "mhi-net-rx");
> +	if (IS_ERR(mhi_netdev->refill_task)) {
> +		return PTR_ERR(mhi_netdev->refill_task);
> +	}
>  
>  	/* Carrier is established via out-of-band channel (e.g. qmi) */
>  	netif_carrier_on(ndev);
> @@ -57,9 +111,9 @@ static int mhi_ndo_stop(struct net_device *ndev)
>  {
>  	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
>  
> +	kthread_stop(mhi_netdev->refill_task);
>  	netif_stop_queue(ndev);
>  	netif_carrier_off(ndev);
> -	cancel_delayed_work_sync(&mhi_netdev->rx_refill);
>  
>  	return 0;
>  }
> @@ -138,9 +192,6 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
>  {
>  	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
>  	struct sk_buff *skb = mhi_res->buf_addr;
> -	int remaining;
> -
> -	remaining = atomic_dec_return(&mhi_netdev->stats.rx_queued);
>  
>  	if (unlikely(mhi_res->transaction_status)) {
>  		dev_kfree_skb_any(skb);
> @@ -163,9 +214,8 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
>  		netif_rx(skb);
>  	}
>  
> -	/* Refill if RX buffers queue becomes low */
> -	if (remaining <= mhi_netdev->rx_queue_sz / 2)
> -		schedule_delayed_work(&mhi_netdev->rx_refill, 0);
> +	if (mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE) >= mhi_netdev->rx_refill_level)
> +		wake_up_interruptible(&mhi_netdev->refill_wq);
>  }
>  
>  static void mhi_net_ul_callback(struct mhi_device *mhi_dev,

