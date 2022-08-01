Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59D9587193
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbiHAToZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234082AbiHAToW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:44:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4686E10575
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 12:44:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D610B6130A
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 19:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44A4C433C1;
        Mon,  1 Aug 2022 19:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659383061;
        bh=HfPRiVQyuE6sX7scm9c5+wUAlPsp+HyFo1NgT0RmWsc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B4nK7Oyv34NdyN/0zBeo86ad76Hu2/2kbFY1/cGssLS+ldbu2671ShuRhIgoI+UY3
         +hmFPOFwnS48d+Hq9Vp+lDUULz+WiMKM1wemMcV3gfNRonRYsPo0ZK5/25th6yl0/6
         5tAiMMpjolRQBByogc0dMNAlqitkc2s9vghQBOAiIt1F90Zf3/fGRE/oBkAaWQUZWs
         +E0CSbwW+2pgK5wJz1SQql3ezjkBDBSBS8QBc56nbQVEAx7KS5lef/PYzmsYjUcZhu
         kwkWWSJ5y8d/R3NfelHCel524GfGLmwTWyWe4JGIcnI6L85mU1OZcdK43vQWA1dOBj
         4x9qvoorvAlSQ==
Date:   Mon, 1 Aug 2022 12:44:19 -0700
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
Message-ID: <20220801124419.4aaffcac@kernel.org>
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
> Currently, tls_device_down synchronizes with tls_device_resync_rx using
> RCU, however, the pointer to netdev is stored using WRITE_ONCE and
> loaded using READ_ONCE.
> 
> Although such approach is technically correct (rcu_dereference is
> essentially a READ_ONCE, and rcu_assign_pointer uses WRITE_ONCE to store
> NULL), using special RCU helpers for pointers is more valid, as it
> includes additional checks and might change the implementation
> transparently to the callers.
> 
> Mark the netdev pointer as __rcu and use the correct RCU helpers to
> access it. For non-concurrent access pass the right conditions that
> guarantee safe access (locks taken, refcount value). Also use the
> correct helper in mlx5e, where even READ_ONCE was missing.

Oops, looks like we also got some new sparse warnings from this:

2 new warnings in drivers/net/bonding/bond_main.c
1 new warning  in drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
