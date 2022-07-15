Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79DE576ACB
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 01:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiGOXiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 19:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiGOXiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 19:38:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE4295B0A
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 16:38:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A60D61DC1
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 23:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1716FC34115;
        Fri, 15 Jul 2022 23:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657928283;
        bh=Oa0db7zuqD53pwFcvK4xXrwv946iYZPVfBWeoJFbTAk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nm7l91PbSYwZ5mXP7sg9RqtysVmuNhzYD+/y074FQ0izzI2F4/iJTqypAs1pMRTR4
         pUy+LboS+JfjtlV7ydtjx4tDeELa8nixXbdxj+2WKN7kHUDRpr9ysSY8YM74MfS2ms
         Zh+t7zbMHVyVlx9XjNYgHAznCgMkigYytIPp5oN+LAA1vPqYzGmGjbW626+BODEsjH
         BAi/1PaRbWuru4nnsqn2RxriLjEM9Pv5tpi98ZROjtxnT06LK46Pfph6Mrbr0q8Gn9
         5TjJLKCc8ULyANSgeY9kSjllVOctjpebUg5nrqTjpO1ULGd6kqtZg5/OLy4ujEXuQw
         KyMhGyEL3QoRw==
Date:   Fri, 15 Jul 2022 16:38:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [PATCH net] net/tls: Fix race in TLS device down flow
Message-ID: <20220715163802.6f49d03d@kernel.org>
In-Reply-To: <20220715084216.4778-1-tariqt@nvidia.com>
References: <20220715084216.4778-1-tariqt@nvidia.com>
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

On Fri, 15 Jul 2022 11:42:16 +0300 Tariq Toukan wrote:
> Socket destruction flow and tls_device_down function sync against each
> other using tls_device_lock and the context refcount, to guarantee the
> device resources are freed via tls_dev_del() by the end of
> tls_device_down.
> 
> In the following unfortunate flow, this won't happen:
> - refcount is decreased to zero in tls_device_sk_destruct.
> - tls_device_down starts, skips the context as refcount is zero, going
>   all the way until it flushes the gc work, and returns without freeing
>   the device resources.
> - only then, tls_device_queue_ctx_destruction is called, queues the gc
>   work and frees the context's device resources.
> 
> Solve it by decreasing the refcount in the socket's destruction flow
> under the tls_device_lock, for perfect synchronization.  This does not
> slow down the common likely destructor flow, in which both the refcount
> is decreased and the spinlock is acquired, anyway.
> 
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Oh, so it was already racy? Sad this has missed the PR, another delay 
for your -next patches :S

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
