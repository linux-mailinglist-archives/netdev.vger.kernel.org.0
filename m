Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDD6520AC9
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 03:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbiEJBm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 21:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiEJBmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 21:42:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD0C187
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 18:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAA76B81A69
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C96CC385C2;
        Tue, 10 May 2022 01:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652146734;
        bh=QPt8GZutPwMpMG4T2f0EPYnri0WR5B6W52ltxX+6xbM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eq4QvPnrAe/5W3zJgN2SRum0mIoCz29sdLOtnJJhSJ/KTlnsoBeEbKAOOFZ/EkcHC
         TO5QY/bVBwbscElN1iyzJ/7IN7T0DjzAuuCULd+rqnKGCWmHo6LQ40RwRe5iXMGoyT
         hW1QUgAh0WoDICRuN6RqddPhUwnodtLREZNLVWF/agvRmX6DnUo2j8AmtWtL82pfjq
         9AP1i/fDhZNNDVtuSEn3m3hfEGkfisPbOnrIdnprdcLnI2SaYYEtQ1NO5UdNonxcTk
         9VbVPjpOnLUc4u7dg0rVY8AzjPlqo6hWhnKGQNhO9qwhlaztfOwPmaZ4eyuyEbesi1
         VI4G8C/TjxrFg==
Date:   Mon, 9 May 2022 18:38:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kees Cook <keescook@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v5 net-next 13/13] mlx5: support BIG TCP packets
Message-ID: <20220509183853.23bd409d@kernel.org>
In-Reply-To: <20220509222149.1763877-14-eric.dumazet@gmail.com>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
        <20220509222149.1763877-14-eric.dumazet@gmail.com>
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

On Mon,  9 May 2022 15:21:49 -0700 Eric Dumazet wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> mlx5 supports LSOv2.
> 
> IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
> with JUMBO TLV for big packets.
> 
> We need to ignore/skip this HBH header when populating TX descriptor.
> 
> Note that ipv6_has_hopopt_jumbo() only recognizes very specific packet
> layout, thus mlx5e_sq_xmit_wqe() is taking care of this layout only.
> 
> v2: clear hopbyhop in mlx5e_tx_get_gso_ihs()
> v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=y
> 
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Leon Romanovsky <leon@kernel.org>

So we're leaving the warning for Kees to deal with?

Kees is there some form of "I know what I'm doing" cast 
that you could sneak us under the table?
