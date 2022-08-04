Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA71589F39
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 18:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiHDQSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 12:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbiHDQSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 12:18:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A436733E2A
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 09:18:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A956B8253E
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 16:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E25EC433C1;
        Thu,  4 Aug 2022 16:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659629886;
        bh=2d9erdklrmfAoihhc55K+pRVlCOJEtntjFbSbrQf878=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qs9RMmr1rzi0WXyixHwuKtec2UNByG/biMwBqrfHd1qKxciptQMIKjbXMrrpQBlYj
         l/PDBU7dVayyGA60lOxYUqWLp+yw/g5P6DyDPTdwhsnbvB8U5mPi1i/GJ8U6NtIgNv
         x8NsydqwZ+PrCbA9N83JXLt0XPUMbc0pAbB0IgzRn/i2rG25CjwXOcRRz+OsAHvLFB
         10eKqe/lYHUM8wkaAFuWMS0cg/CDjItFQwKy0REhF/k9dYBm/mGDbYHi2J915K8mQI
         yzaMHpPDC8eqLo4PIu2LkISaDcjaY80yk5x8u9HFwtWmoB2T5nYSDcpZAD8usnCqXR
         jCU01z/9aSNXw==
Date:   Thu, 4 Aug 2022 09:18:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "paulmck@kernel.org" <paulmck@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH net-next] net/tls: Use RCU API to access tls_ctx->netdev
Message-ID: <20220804091804.77d87fcc@kernel.org>
In-Reply-To: <dc8a86b89350e05841aaecfba5939cfb63a084ba.camel@nvidia.com>
References: <20220801080053.21849-1-maximmi@nvidia.com>
        <20220801124239.067573de@kernel.org>
        <380eb27278e581012524cdc16f99e1872cee9be0.camel@nvidia.com>
        <20220802083731.22291c3b@kernel.org>
        <8bf08924a111d4e0875721af264f082cc9c44587.camel@nvidia.com>
        <20220803074957.33783ad4@kernel.org>
        <20220803163437.GF2125313@paulmck-ThinkPad-P17-Gen-1>
        <dc8a86b89350e05841aaecfba5939cfb63a084ba.camel@nvidia.com>
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

On Thu, 4 Aug 2022 08:08:37 +0000 Maxim Mikityanskiy wrote:
> 2. ctx->refcount goes down to 0, no one can access ctx->netdev anymore,
> we tear down ctx and need to check whether ctx->netdev is NULL.
> 
>  if (!refcount_dec_and_test(&ctx->refcount))
>          return;
>  netdev = rcu_dereference_protected(ctx->netdev,
>                                     !refcount_read(&ctx->refcount));
>  if (netdev)
>          queue_work(...);
> 
> It's somewhat similar to the "structure is beyond being updated" case,
> but it's ensured by refcount, not by RCU (i.e. you example assigned
> my_rcu_pointer = NULL and called synchronize_rcu() to ensure no one
> touches it, and I ensure that we are the only user of ctx by dropping
> refcount to zero).
> 
> So, hoping that my understanding of your explanation is correct, both
> cases can use any of rcu_access_pointer or rcu_dereference_protected.
> Is there some rule of thumb which one to pick in such case?

IMHO, rcu_dereference_protected() documents why it's safe to
dereference the pointer outside of the rcu read section. 

We are only documenting the writer side locking. The fact that there
is a RCU pointer involved is coincidental - I think we could 
as well be checking the TLS_RX_DEV_DEGRADED bit here.

We can add asserts or comments to document the writer side locking.
Piggy backing on RCU seems coincidental. But again, I'm fine either 
way. I'm just saying this because I really doubt there is a rule of
thumb for this level of detail. It's most likely your call.
