Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F38569844
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 04:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbiGGChs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 22:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235011AbiGGChj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 22:37:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E993EB5
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 19:37:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4EAAB81F44
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 02:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45471C341C6;
        Thu,  7 Jul 2022 02:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657161456;
        bh=IJRIxOmyCRxqRD6kK6334kr2360kQdOjcS/uV2zNkwE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uoOpKi5QIE6Rwrgy2PztrkOZlkJK5xYsIWFrwlTT84s3T+qobZ2NMJY+wNXtX/ZfW
         XFdIve/x1ClAgIOU6FmWe54MT76QTKjfAfgTQ682MOtnhhsCCY8fWaD3UY9BoiAdXR
         TtH3pgcIxD/mI/122osdy71iu22GD/rwzrBiLXjgyfhC9rqtXhw1mJ5o4mSuTB8jQV
         JTS8lOOInWdkRVwkzAQi4WkTKNZfUHtTfz2WDJX6aSR+N+6cKXGhNkGBwKQbMInB/M
         0B6u3KWOxDUIgBYCfoalYwiotAPaxGam+UZp6eff7l0pu4hte7ZvjuMR3+rK2j1Gxe
         eqKoNIYYZ/R7A==
Date:   Wed, 6 Jul 2022 19:37:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [net-next 11/15] net/tls: Multi-threaded calls to TX
 tls_dev_del
Message-ID: <20220706193735.49d5f081@kernel.org>
In-Reply-To: <20220706232421.41269-12-saeed@kernel.org>
References: <20220706232421.41269-1-saeed@kernel.org>
        <20220706232421.41269-12-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Jul 2022 16:24:17 -0700 Saeed Mahameed wrote:
> diff --git a/include/net/tls.h b/include/net/tls.h
> index 4fc16ca5f469..c4be74635502 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -163,6 +163,11 @@ struct tls_record_info {
>  	skb_frag_t frags[MAX_SKB_FRAGS];
>  };
>  
> +struct destruct_work {
> +	struct work_struct work;
> +	struct tls_context *ctx;

Pretty strange to bundle the back-pointer with the work.
Why not put it directly in struct tls_offload_context_tx?

Also now that we have the backpointer, can we move the list member of
struct tls_context to the offload context? (I haven't checked if its
used in other places)

>  
>  	up_write(&device_offload_lock);
>  
> -	flush_work(&tls_device_gc_work);
> -
>  	return NOTIFY_DONE;
>  }
>  
> @@ -1435,6 +1416,5 @@ void __init tls_device_init(void)
>  void __exit tls_device_cleanup(void)
>  {
>  	unregister_netdevice_notifier(&tls_dev_notifier);
> -	flush_work(&tls_device_gc_work);
>  	clean_acked_data_flush();
>  }

Why don't we need the flush any more? The module reference is gone as
soon as destructor runs (i.e. on ULP cleanup), the work can still be
pending, no?
