Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3454565012
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 10:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiGDIxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 04:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiGDIxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 04:53:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62F02B87F
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 01:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656924784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qbVXSgisY5AaoNPEQrLMmraosP7prZp3JNPIrzB+8Vg=;
        b=PqW3lJ6BEN+5G0Cdy+0aG1romgilbrWT/sf7gafYoDXZHgcTP2NCuU3rZfDcZQJ3RunY+R
        IEqf97rsMh9zmM/yHOtQPB96PvqoUEEusfhvSlnbFRfXPW1z0ekAFdpRFPE+i3/zknOMA5
        3FrIHzBZi9PT0fhf2LqTBdd1FLxi13M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-9H25yzhxMGOt1iXFOTqUnQ-1; Mon, 04 Jul 2022 04:53:02 -0400
X-MC-Unique: 9H25yzhxMGOt1iXFOTqUnQ-1
Received: by mail-ed1-f71.google.com with SMTP id y18-20020a056402441200b0043564cdf765so6809673eda.11
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 01:53:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qbVXSgisY5AaoNPEQrLMmraosP7prZp3JNPIrzB+8Vg=;
        b=dnac0az6sxCOU2Cp0INloxRrq4a/TawWjSHqpQQH3zJ7aOzCkHwr/ycEYexeWrymc2
         FihiWCDrIbqk9nNke/bRJmFsPB1qDbo3hBJmjSpRI1Ik9JeHqNucY9POk9+IOrs5+iEc
         lpHiJEvkCJiub0NHny16LopBLsLAC2DKlJ7fw5TZwKKvDshMzDrlVoMevEE8MoAYge6F
         g7MZpCO0dHIrrVhZNtGuXPsFJncaQyAp1zEqCWytLlB0EuRT3VJOzfjzHspUIJ5X7kfa
         IVjfn2RUwuOSJAZKrcF9IweujR6mdq11ffO/fBz/UQ0kgA3jN9rK7TSq4sbCUvBmaDAp
         hjJA==
X-Gm-Message-State: AJIora9ky3t7t6edRxNq2MhNY43Fl4a2rrYZsv8sLpAuFu8Uu0ZakrWS
        XQF8U6+9L7x27VUyhIRSGfDQI2Alys/ZfUwSXCbC12wOFpVEBpLoUXSgBEcUCUDQ2VXYrgRBtck
        K835B6/l1AoeB5TV0
X-Received: by 2002:a05:6402:15a:b0:431:71b9:86f3 with SMTP id s26-20020a056402015a00b0043171b986f3mr36401032edu.249.1656924780884;
        Mon, 04 Jul 2022 01:53:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vTidClko4q95fUuzrkACeMQxysRX5CdJQRf4uacqDZMo8xNc83r+hqmdeB0EHH8h0+Vw5QKw==
X-Received: by 2002:a05:6402:15a:b0:431:71b9:86f3 with SMTP id s26-20020a056402015a00b0043171b986f3mr36401009edu.249.1656924780667;
        Mon, 04 Jul 2022 01:53:00 -0700 (PDT)
Received: from redhat.com ([2.55.35.209])
        by smtp.gmail.com with ESMTPSA id fg8-20020a056402548800b0043a3f52418asm2252759edb.18.2022.07.04.01.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 01:53:00 -0700 (PDT)
Date:   Mon, 4 Jul 2022 04:52:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net V5] virtio-net: fix the race between refill work and
 close
Message-ID: <20220704045034-mutt-send-email-mst@kernel.org>
References: <20220704074859.16912-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704074859.16912-1-jasowang@redhat.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 03:48:59PM +0800, Jason Wang wrote:
> We try using cancel_delayed_work_sync() to prevent the work from
> enabling NAPI. This is insufficient since we don't disable the source
> of the refill work scheduling. This means an NAPI poll callback after
> cancel_delayed_work_sync() can schedule the refill work then can
> re-enable the NAPI that leads to use-after-free [1].
> 
> Since the work can enable NAPI, we can't simply disable NAPI before
> calling cancel_delayed_work_sync(). So fix this by introducing a
> dedicated boolean to control whether or not the work could be
> scheduled from NAPI.
> 
> [1]
> ==================================================================
> BUG: KASAN: use-after-free in refill_work+0x43/0xd4
> Read of size 2 at addr ffff88810562c92e by task kworker/2:1/42
> 
> CPU: 2 PID: 42 Comm: kworker/2:1 Not tainted 5.19.0-rc1+ #480
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> Workqueue: events refill_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x34/0x44
>  print_report.cold+0xbb/0x6ac
>  ? _printk+0xad/0xde
>  ? refill_work+0x43/0xd4
>  kasan_report+0xa8/0x130
>  ? refill_work+0x43/0xd4
>  refill_work+0x43/0xd4
>  process_one_work+0x43d/0x780
>  worker_thread+0x2a0/0x6f0
>  ? process_one_work+0x780/0x780
>  kthread+0x167/0x1a0
>  ? kthread_exit+0x50/0x50
>  ret_from_fork+0x22/0x30
>  </TASK>
> ...
> 
> Fixes: b2baed69e605c ("virtio_net: set/cancel work on ndo_open/ndo_stop")
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> Changes since V4:
> - Tweak the variable name (using delayed_refill)
> Changes since V3:
> - rebase to -net
> Changes since V2:
> - use spin_unlock()/lock_bh() in open/stop to synchronize with bh
> Changes since V1:
> - Tweak the changelog
> ---
>  drivers/net/virtio_net.c | 35 +++++++++++++++++++++++++++++++++--
>  1 file changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 356cf8dd4164..b9ac4431becb 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -245,6 +245,12 @@ struct virtnet_info {
>  	/* Work struct for refilling if we run low on memory. */

let's update this comment to "for delayed refilling" for consistency

>  	struct delayed_work refill;
>  
> +	/* Is delayed refill enabled? */
> +	bool delayed_refill_enabled;


I would keep the name refill_enabled, refill refers to the field "refill"
above.

> +
> +	/* The lock to synchronize the access to delayed_refill_enabled */

add:

... and to refill

> +	spinlock_t refill_lock;
> +
>  	/* Work struct for config space updates */
>  	struct work_struct config_work;
>  
> @@ -348,6 +354,20 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
>  	return p;
>  }
>  
> +static void enable_delayed_refill(struct virtnet_info *vi)
> +{
> +	spin_lock_bh(&vi->refill_lock);
> +	vi->delayed_refill_enabled = true;
> +	spin_unlock_bh(&vi->refill_lock);
> +}
> +
> +static void disable_delayed_refill(struct virtnet_info *vi)
> +{
> +	spin_lock_bh(&vi->refill_lock);
> +	vi->delayed_refill_enabled = false;
> +	spin_unlock_bh(&vi->refill_lock);
> +}
> +
>  static void virtqueue_napi_schedule(struct napi_struct *napi,
>  				    struct virtqueue *vq)
>  {
> @@ -1527,8 +1547,12 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
>  	}
>  
>  	if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
> -		if (!try_fill_recv(vi, rq, GFP_ATOMIC))
> -			schedule_delayed_work(&vi->refill, 0);
> +		if (!try_fill_recv(vi, rq, GFP_ATOMIC)) {
> +			spin_lock(&vi->refill_lock);
> +			if (vi->delayed_refill_enabled)
> +				schedule_delayed_work(&vi->refill, 0);
> +			spin_unlock(&vi->refill_lock);
> +		}
>  	}
>  
>  	u64_stats_update_begin(&rq->stats.syncp);
> @@ -1651,6 +1675,8 @@ static int virtnet_open(struct net_device *dev)
>  	struct virtnet_info *vi = netdev_priv(dev);
>  	int i, err;
>  
> +	enable_delayed_refill(vi);
> +
>  	for (i = 0; i < vi->max_queue_pairs; i++) {
>  		if (i < vi->curr_queue_pairs)
>  			/* Make sure we have some buffers: if oom use wq. */
> @@ -2033,6 +2059,8 @@ static int virtnet_close(struct net_device *dev)
>  	struct virtnet_info *vi = netdev_priv(dev);
>  	int i;
>  
> +	/* Make sure NAPI doesn't schedule refill work */
> +	disable_delayed_refill(vi);
>  	/* Make sure refill_work doesn't re-enable napi! */
>  	cancel_delayed_work_sync(&vi->refill);
>  
> @@ -2792,6 +2820,8 @@ static int virtnet_restore_up(struct virtio_device *vdev)
>  
>  	virtio_device_ready(vdev);
>  
> +	enable_delayed_refill(vi);
> +
>  	if (netif_running(vi->dev)) {
>  		err = virtnet_open(vi->dev);
>  		if (err)
> @@ -3535,6 +3565,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	vdev->priv = vi;
>  
>  	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
> +	spin_lock_init(&vi->refill_lock);
>  
>  	/* If we can receive ANY GSO packets, we must allocate large ones. */
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> -- 
> 2.25.1

