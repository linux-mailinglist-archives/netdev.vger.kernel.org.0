Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7056EA187
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbjDUCNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbjDUCNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:13:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71C6138
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 19:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82CD264CF7
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE5EC433D2;
        Fri, 21 Apr 2023 02:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682043199;
        bh=041QFz2IHlxmjNwmjC3ljK4Y1TRhFKpOl+B/WRMWMCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TxMnRTtbDcMYQ2RzI88ZsZ47uxNcWtEp6pw0d9d9lltVyED5FGxf9ZnlncoCkI2jm
         PaNzNWjfK7g8gVKNonbhj/gxTc2Fr8y+lUytn/PGLKjIiOJus6sGYMv/wDromeErcb
         cF/92id73T97pygd/VEA6wvf3s8qelhTUgAjRZjo3wXON8XlIejUwCgxOvcvuIWXDV
         vNJE8g9aN4fNjHPNe9BVXcxlmKq8emCmzWTIObqr7cOHDNmaBJZk+4nWKfXxA8W6Qa
         mY8LRFNXJL0IkQmDIBxRuEaNmrwxcJgerNKEgqBl4Jtvlm/rFz2sigFaTVuwOvHB97
         J2UFX4NQtufEw==
Date:   Thu, 20 Apr 2023 19:13:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [net-next 11/15] net/mlx5e: RX, Hook NAPIs to page pools
Message-ID: <20230420191318.1d332ebb@kernel.org>
In-Reply-To: <20230421013850.349646-12-saeed@kernel.org>
References: <20230421013850.349646-1-saeed@kernel.org>
        <20230421013850.349646-12-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 18:38:46 -0700 Saeed Mahameed wrote:
> From: Dragos Tatulea <dtatulea@nvidia.com>
> 
> Linking the NAPI to the rq page_pool to improve page_pool cache
> usage during skb recycling.
> 
> Here are the observed improvements for a iperf single stream
> test case:
> 
> - For 1500 MTU and legacy rq, seeing a 20% improvement of cache usage.
> 
> - For 9K MTU, seeing 33-40 % page_pool cache usage improvements for
> both striding and legacy rq (depending if the application is running on
> the same core as the rq or not).

I think you'll need a strategically placed page_pool_unlink_napi() once
https://lore.kernel.org/all/20230419182006.719923-1-kuba@kernel.org/
gets merged (which should me in minutes). Would you be able to follow
up on this tomorrow?
