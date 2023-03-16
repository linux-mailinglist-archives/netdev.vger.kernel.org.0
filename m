Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F080F6BC5B5
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 06:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjCPFhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 01:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCPFhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 01:37:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CB5392A6;
        Wed, 15 Mar 2023 22:37:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95D26B81F98;
        Thu, 16 Mar 2023 05:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B93DC433D2;
        Thu, 16 Mar 2023 05:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678945037;
        bh=7oxy9Opsdf9PTZQrh5EeJWYiT74ecEyp2R9NyvW2Tdw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jfyy5P5uX93ykyYvWiGd/82rW/80/SQ4+4Abz7twKQ7WC6igENdFesAFSHF09/J0+
         dTjrub35uRtEObXvzQx/G8QNKkHNmQTH/dKo1/EZgl+KK0Nf3q8vaCmYw/ZCh+C0NZ
         6UHFys24Pi1onwFBT3DjvKnamW3sjyluhwnapznDkfSHLUCCshr2z8FdcBEk7TkyAX
         +1irUby1P4hQFqW1nXDG5DkgYqY4twfnqqY5EhP/7Jh3ITAKX7YA6VhHYR/tEXwMli
         1q+2jwkmaFN7KzSU8Q4kKEo8HuOMdAragLMDtowWZtXDmuDnGEYU5uOD4EC3noeYVz
         U54ee6Xmf05CA==
Date:   Wed, 15 Mar 2023 22:37:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, saeedm@nvidia.com,
        leon@kernel.org, shayagr@amazon.com, akiyano@amazon.com,
        darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com,
        ttoukan.linux@gmail.com
Subject: Re: [PATCH net v2 7/8] net/mlx5e: take into account device
 reconfiguration for xdp_features flag
Message-ID: <20230315223715.702f0900@kernel.org>
In-Reply-To: <ZBKjHwr8jPl4sBFl@x130>
References: <cover.1678364612.git.lorenzo@kernel.org>
        <16c37367670903e86f863cc8c481100dd4b3a323.1678364613.git.lorenzo@kernel.org>
        <20230315163900.381dd25e@kernel.org>
        <20230315172932.71de01fa@kernel.org>
        <ZBKC8lxQurwQpj4k@x130>
        <20230315195338.563e1399@kernel.org>
        <ZBKjHwr8jPl4sBFl@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 22:03:27 -0700 Saeed Mahameed wrote:
> Yes, completely different, Tariq's fix is in mlx5 only.
> He splits the xdp  feature setting into two functions, 
> one to initialize the netdev's xdp before registration,
> and another one to update xpd features and call the notifier in the
> "after" registration set_features flows.
> 
> I like our solution more, since it's more explicit and doesn't require
> patching xdp stack because mlx5 abused xdp_set_features_flag, unless other
> drivers have the same issue.

I reckon there's nothing wrong with calling xdp_set_features_flag()
before registration, I didn't do much research, but
netif_set_real_num_*x_queues() come to mind, and they can be called
at any time. The stack should act accordingly.

Many drivers may need to work around an issue which can be handled
centrally.

Let's see if Lorenzo disagrees.

> >https://patchwork.kernel.org/project/netdevbpf/patch/20230316002903.492497-1-kuba@kernel.org/
> >  
> 
> I don't see anything wrong with your patch though.. it also looks more
> elegant, i dunno, I will let you decide, here's our patch:
> https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/commit/?h=testing/xdp-features-fix&id=72e2266525948ba1498e6a3f2d63ea10d5ee86f5

