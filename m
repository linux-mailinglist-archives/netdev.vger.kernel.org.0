Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0882E58718C
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbiHATmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiHATmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:42:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78707D3
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 12:42:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16F756130A
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 19:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2666CC433C1;
        Mon,  1 Aug 2022 19:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659382960;
        bh=Oj6DwQ8+kZS+UNrKAdYhDHSaOmmRtCiZMMiufCdCj48=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N+2KSAdHxExgnhpE6/Syus7gRYMPqiEonp53XMWHb2vvoOwPUIX+ZldeABKWIXQg0
         WefWuJsOgFXMANvaymD/txM/Qu+0YLgOKMu0H3Zk1P6qIR33i296z1Y3avS6qE6i1X
         1tdae//78W08DSUf0kQxwfDlkpAZtsKpLYxreV4AXsxtSX+S6/ZSDoI+F9MEBRAMUy
         9ooOTAuAgXo6i5tr39HFmkkA0mDF7k81n5HKD4itpy8YG8x1PsCRDEE3oNNl0ltYX+
         7sfQeBBU1oaCf1SE+wOq/fgesYca72B7YLoFy72nx+39HpjDWh/lEG6XMaCJC+G0ol
         MHLzK0jLXr9ww==
Date:   Mon, 1 Aug 2022 12:42:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Gal Pressman <gal@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/tls: Use RCU API to access tls_ctx->netdev
Message-ID: <20220801124239.067573de@kernel.org>
In-Reply-To: <20220801080053.21849-1-maximmi@nvidia.com>
References: <20220801080053.21849-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Aug 2022 11:00:53 +0300 Maxim Mikityanskiy wrote:
> @@ -1329,7 +1345,11 @@ static int tls_device_down(struct net_device *netdev)
>  
>  	spin_lock_irqsave(&tls_device_lock, flags);
>  	list_for_each_entry_safe(ctx, tmp, &tls_device_list, list) {
> -		if (ctx->netdev != netdev ||
> +		struct net_device *ctx_netdev =
> +			rcu_dereference_protected(ctx->netdev,
> +						  lockdep_is_held(&device_offload_lock));
> +
> +		if (ctx_netdev != netdev ||
>  		    !refcount_inc_not_zero(&ctx->refcount))
>  			continue;

For cases like this where we don't actually hold onto the object, just
take a peek at the address of it we can save a handful of LoC by using
rcu_access_pointer(). 
