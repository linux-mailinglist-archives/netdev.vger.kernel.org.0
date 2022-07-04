Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82AE564DA1
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiGDGT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiGDGTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:19:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 830D05FAA
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656915563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Li8ThBWAqJMFEkzTAJ9iYj5JlWkGm0J0qjrPjZmAGdc=;
        b=e/UjD/6g/jDB6tF/2DS1NQlqVy9JPHYy7derFlXnfPmN9SC/EvtKpT+w3VHimMV5IrvSXQ
        +6xR11FPyeZRx+2Y/uGgudeIqVPJtPeyDxdb/CxQptrKrIaS3XpdCuaJW7j85u2Y0TmeN3
        0wdYyn3+XJ0UAgDj1X1ckx/nNvS3NEc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-3Zy1xgpoPhiseM-jk4Hluw-1; Mon, 04 Jul 2022 02:19:21 -0400
X-MC-Unique: 3Zy1xgpoPhiseM-jk4Hluw-1
Received: by mail-wr1-f72.google.com with SMTP id f20-20020adfc994000000b0021d4aca9d0eso1070200wrh.0
        for <netdev@vger.kernel.org>; Sun, 03 Jul 2022 23:19:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Li8ThBWAqJMFEkzTAJ9iYj5JlWkGm0J0qjrPjZmAGdc=;
        b=Dg+X91CySnPEdodLzlEfbg46zcStYXqH6xkHPRJcmhKW1m4xaRM111UoYDCeKR9Xnd
         phPG2C/HUBQZDEHh8y9g7OINAQwPcP7RLQaW40cljyhQ+3FmCvtUIvYrW4OLJ/Czta8z
         AokPqo1eoKRHMvxM6PHYghBfkPdaxCIn+01K5kxXTdUojeBMF90kRSa2bfvFWKfsqv/T
         oK3i1miRVpdzx6Tw6T2mx+j/RigYuI8b3V1nBDRrgpVeD2KoJ7UQcYA/RHZ9Rocxj7HH
         oS0G5Auard2h/QO6p53/IRMCsfZ5HKk8KnbaNdrSAf5zl8CCuA9m7D7p01dy0m3jxJU/
         ln7A==
X-Gm-Message-State: AJIora8kVhuUrb0nRHyGeWdTvezsAM1gH9ILwCMFOcaGEWWdTxx431kk
        r5YmSu6SAB5Vy2VsbnLLblVqYzXFrj+6clBqny1mzfodLlFYdFLaMazwM5oj4y9ZM6Je5qzI2oP
        6LUruqyjD+PFBWfga
X-Received: by 2002:a7b:c381:0:b0:3a2:aef9:8dc8 with SMTP id s1-20020a7bc381000000b003a2aef98dc8mr2099565wmj.51.1656915559062;
        Sun, 03 Jul 2022 23:19:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vb8OWaxZMEaK1FVxHFS5+2MNbMSus77mjJpPRtJuXLL43LelWqsLqpI6jq4oBd0BpiXnOj2A==
X-Received: by 2002:a7b:c381:0:b0:3a2:aef9:8dc8 with SMTP id s1-20020a7bc381000000b003a2aef98dc8mr2099547wmj.51.1656915558801;
        Sun, 03 Jul 2022 23:19:18 -0700 (PDT)
Received: from redhat.com ([2.55.35.209])
        by smtp.gmail.com with ESMTPSA id i8-20020a05600c354800b0039c4e2ff7cfsm15276865wmq.43.2022.07.03.23.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jul 2022 23:19:18 -0700 (PDT)
Date:   Mon, 4 Jul 2022 02:19:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V4] virtio-net: fix the race between refill work and
 close
Message-ID: <20220704021656-mutt-send-email-mst@kernel.org>
References: <20220704041948.13212-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704041948.13212-1-jasowang@redhat.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 12:19:48PM +0800, Jason Wang wrote:
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
> ---
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
> index 356cf8dd4164..68430d7923ac 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -251,6 +251,12 @@ struct virtnet_info {
>  	/* Does the affinity hint is set for virtqueues? */
>  	bool affinity_hint_set;
>  
> +	/* Is refill work enabled? */

refilling enabled

> +	bool refill_work_enabled;


refill_work -> refill?

> +
> +	/* The lock to synchronize the access to refill_work_enabled */

.. and refill

And maybe put these field near the refill field.

> +	spinlock_t refill_lock;
> +
>  	/* CPU hotplug instances for online & dead */
>  	struct hlist_node node;
>  	struct hlist_node node_dead;
> @@ -348,6 +354,20 @@ static struct page *get_a_page(struct receive_queue *rq, gfp_t gfp_mask)
>  	return p;
>  }
>  
> +static void enable_refill_work(struct virtnet_info *vi)
> +{
> +	spin_lock_bh(&vi->refill_lock);
> +	vi->refill_work_enabled = true;
> +	spin_unlock_bh(&vi->refill_lock);
> +}
> +
> +static void disable_refill_work(struct virtnet_info *vi)
> +{
> +	spin_lock_bh(&vi->refill_lock);
> +	vi->refill_work_enabled = false;
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
> +			if (vi->refill_work_enabled)
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
> +	enable_refill_work(vi);
> +
>  	for (i = 0; i < vi->max_queue_pairs; i++) {
>  		if (i < vi->curr_queue_pairs)
>  			/* Make sure we have some buffers: if oom use wq. */
> @@ -2033,6 +2059,8 @@ static int virtnet_close(struct net_device *dev)
>  	struct virtnet_info *vi = netdev_priv(dev);
>  	int i;
>  
> +	/* Make sure NAPI doesn't schedule refill work */
> +	disable_refill_work(vi);
>  	/* Make sure refill_work doesn't re-enable napi! */
>  	cancel_delayed_work_sync(&vi->refill);
>  
> @@ -2792,6 +2820,8 @@ static int virtnet_restore_up(struct virtio_device *vdev)
>  
>  	virtio_device_ready(vdev);
>  
> +	enable_refill_work(vi);
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

