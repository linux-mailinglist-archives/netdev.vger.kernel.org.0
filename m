Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DD95741BE
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbiGNDK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiGNDKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:10:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD59252A6
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC2B8B82271
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E19C34114;
        Thu, 14 Jul 2022 03:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657768251;
        bh=EDEGOZ9ujGMKXTygHaFXLu2WFBnUa7gj7ZwWDQgOqck=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OfAT/Mw3IudvyKVbZGhF3RB46VacqEgpknCP0eexQbdVebU5zb8br2dfFhR+Ti5lo
         aRuKEMEMRk4Nba418j3ybsedB01Gjb8Y4eLnzM1DRaVsYSqO2R04GRSiJYjjyQ/BqH
         e9sUglNPqDDOF0V5l7yrYU9faKNFf05uD3jo08UQr5PAOFAVt3/04Vfdv6LJOqiTx2
         j8p54VSYooD5wjw+NRTf9JLu7lZCmQG/8K3VYvuuARD1iPP27RBiYlbuNiXSNqlgZc
         E/AvI0GfjcjtHIR9sJJX972KPVo0cKJFcAuMSTn//j5KFT7w6MM7E6QqxMJw7vEVmJ
         JVMdsCKul6f5Q==
Date:   Wed, 13 Jul 2022 20:10:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <galp@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [PATCH net-next V2 2/6] net/tls: Multi-threaded calls to TX
 tls_dev_del
Message-ID: <20220713201050.3aab0cb8@kernel.org>
In-Reply-To: <20220713051603.14014-3-tariqt@nvidia.com>
References: <20220713051603.14014-1-tariqt@nvidia.com>
        <20220713051603.14014-3-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 08:15:59 +0300 Tariq Toukan wrote:
> @@ -99,21 +85,17 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
>  	bool async_cleanup;
>  
>  	spin_lock_irqsave(&tls_device_lock, flags);
> +	list_del(&ctx->list); /* Remove from tls_device_list / tls_device_down_list */
> +	spin_unlock_irqrestore(&tls_device_lock, flags);
> +
>  	async_cleanup = ctx->netdev && ctx->tx_conf == TLS_HW;
>  	if (async_cleanup) {
> -		list_move_tail(&ctx->list, &tls_device_gc_list);
> +		struct tls_offload_context_tx *offload_ctx = tls_offload_ctx_tx(ctx);
>  
> -		/* schedule_work inside the spinlock
> -		 * to make sure tls_device_down waits for that work.
> -		 */
> -		schedule_work(&tls_device_gc_work);
> +		queue_work(destruct_wq, &offload_ctx->destruct_work);

Doesn't queue_work() need to be under the tls_device_lock?
Otherwise I think there's a race between removing the context from 
the list and the netdev down notifier searching that list and flushing
the wq.

>  	} else {
> -		list_del(&ctx->list);
> -	}
> -	spin_unlock_irqrestore(&tls_device_lock, flags);
> -
> -	if (!async_cleanup)
>  		tls_device_free_ctx(ctx);
> +	}
>  }
>  
>  /* We assume that the socket is already connected */
> @@ -1150,6 +1132,9 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
>  	start_marker_record->len = 0;
>  	start_marker_record->num_frags = 0;
>  
> +	INIT_WORK(&offload_ctx->destruct_work, tls_device_tx_del_task);
> +	offload_ctx->ctx = ctx;
> +
>  	INIT_LIST_HEAD(&offload_ctx->records_list);
>  	list_add_tail(&start_marker_record->list, &offload_ctx->records_list);
>  	spin_lock_init(&offload_ctx->lock);
> @@ -1389,7 +1374,7 @@ static int tls_device_down(struct net_device *netdev)
>  
>  	up_write(&device_offload_lock);
>  
> -	flush_work(&tls_device_gc_work);
> +	flush_workqueue(destruct_wq);
>  
>  	return NOTIFY_DONE;
>  }
> @@ -1428,14 +1413,20 @@ static struct notifier_block tls_dev_notifier = {
>  	.notifier_call	= tls_dev_event,
>  };
>  
> -void __init tls_device_init(void)
> +int __init tls_device_init(void)
>  {
> +	destruct_wq = alloc_workqueue("ktls_device_destruct", 0, 0);
> +	if (!destruct_wq)
> +		return -ENOMEM;
> +
>  	register_netdevice_notifier(&tls_dev_notifier);

For a future cleanup - we should probably check for errors here.
Or perhaps we should take the fix via net? If you spin a quick
patch it can still make tomorrows net -> net-next merge.

> +	return 0;
>  }
