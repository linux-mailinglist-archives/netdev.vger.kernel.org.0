Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1ADA6C4127
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 04:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCVDil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 23:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCVDik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 23:38:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A0026580
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 20:38:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21E9E61F32
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 03:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C11C433D2;
        Wed, 22 Mar 2023 03:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679456318;
        bh=gLUp0cD/dekHocn9k+RGGh2H9rq74WePOC0Uvf/tGCc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NlaPS58kclFxumjA/N9Cyzjp2djT5rLsKJof7ONGQVwZCUNbMsL1MzEEpRZk0rUat
         bApPHKCwDfTPfPXCx5CDNH3fuG2tfMRtDXgolElBGfU8hcLj/rI30W0q5poKy0I6jr
         VPiwGV3WDGJjQ5zOVo7Qpq3b0F0Wl+0aILK32KLickv+v0Hw4ycCTZ6QVqH1yYhWsQ
         KOtd5hUgM/RqWB8MtAJSYF2dUpmCDiK40mzNTuEl6UJOdDZzQ0ALE0dy1HxuaF3Sn1
         fzPhFUcDXbIdcPpeC9IK4KvNue6SF5hrG8+oDkFNcS7VLbUi/3/KDAnUN9NjGUpfUF
         uRAziuYbSUiRw==
Date:   Tue, 21 Mar 2023 20:38:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>
Subject: Re: [net-next 01/14] lib: cpu_rmap: Avoid use after free on
 rmap->obj array entries
Message-ID: <20230321203836.5ab4951e@kernel.org>
In-Reply-To: <20230320175144.153187-2-saeed@kernel.org>
References: <20230320175144.153187-1-saeed@kernel.org>
        <20230320175144.153187-2-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 10:51:31 -0700 Saeed Mahameed wrote:
> From: Eli Cohen <elic@nvidia.com>
> 
> When calling irq_set_affinity_notifier() with NULL at the notify
> argument, it will cause freeing of the glue pointer in the
> corresponding array entry but will leave the pointer in the array. A
> subsequent call to free_irq_cpu_rmap() will try to free this entry again
> leading to possible use after free.
> 
> Fix that by setting NULL to the array entry and checking that we have
> non-zero at the array entry when iterating over the array in
> free_irq_cpu_rmap().

Commit message needs some work. Are you trying to make double
free_irq_cpu_rmap() work fine because of callers? Are there problems
with error path of irq_cpu_rmap_add()? I can tell what you're trying 
to prevent but not why.

> Fixes: c39649c331c7 ("lib: cpu_rmap: CPU affinity reverse-mapping")

What is this Fixes tag doing in a net-next patch :S
If it can be triggered it needs to go to net.

> Signed-off-by: Eli Cohen <elic@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  lib/cpu_rmap.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
> index f08d9c56f712..e77f12bb3c77 100644
> --- a/lib/cpu_rmap.c
> +++ b/lib/cpu_rmap.c
> @@ -232,7 +232,8 @@ void free_irq_cpu_rmap(struct cpu_rmap *rmap)
>  
>  	for (index = 0; index < rmap->used; index++) {

After looking at this code for 10min - isn't the problem that used 
is never decremented on the error path? 

I don't see a way to remove from the map so it can't be sparse.

>  		glue = rmap->obj[index];
> -		irq_set_affinity_notifier(glue->notify.irq, NULL);
> +		if (glue)
> +			irq_set_affinity_notifier(glue->notify.irq, NULL);
>  	}
>  
>  	cpu_rmap_put(rmap);
> @@ -268,6 +269,7 @@ static void irq_cpu_rmap_release(struct kref *ref)
>  		container_of(ref, struct irq_glue, notify.kref);
>  
>  	cpu_rmap_put(glue->rmap);
> +	glue->rmap->obj[glue->index] = NULL;
>  	kfree(glue);
>  }
>  
> @@ -297,6 +299,7 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
>  	rc = irq_set_affinity_notifier(irq, &glue->notify);
>  	if (rc) {
>  		cpu_rmap_put(glue->rmap);
> +		rmap->obj[glue->index] = NULL;
>  		kfree(glue);
>  	}
>  	return rc;

