Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303B3664E64
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 22:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbjAJV7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 16:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbjAJV61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 16:58:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3EE5E66E;
        Tue, 10 Jan 2023 13:58:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD8C9B819B4;
        Tue, 10 Jan 2023 21:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D61AC433D2;
        Tue, 10 Jan 2023 21:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673387902;
        bh=M6PirtylDWfnwWQmbjPEjODf22EUW9BcFhvH7EqNPYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sU9s4by+WCKy6xxqQ+Aiitpj7ZvPzszpLBJf5jHuPpEujM1ElylI5DbW1fiKfERil
         GfvNgssm59seDKEOBa8gZAWyyGSTddXmEH82vECUpHhwldJDu5Y6DR9FpOXUQeGpkg
         3FcUsj8hpSArzsGYOO2orIGYWamVRoNzFetbDo5yYwP/KWz3RzZ9YCmsQxFWdjt09c
         sbJtTXXTZQmDyViTKMTQ/39WBz5IHPYJvaWmnj4cIYavt9jVUABfHMPI8naobJRc68
         39SMg5DjPcgoA3PQVY8buOuktbE8bH2QMDpG9w6nkQkKcXNZe5UwpQJVHipAPWhV/O
         aite6/RGqReWA==
Date:   Tue, 10 Jan 2023 13:58:21 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: Replace 0-length array with flexible array
Message-ID: <Y73ffWiXFar9xNQM@x130>
References: <20230105223642.never.980-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230105223642.never.980-kees@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05 Jan 14:36, Kees Cook wrote:
>Zero-length arrays are deprecated[1]. Replace struct mlx5e_rx_wqe_cyc's
>"data" 0-length array with a flexible array. Detected with GCC 13,
>using -fstrict-flex-arrays=3:
>
>drivers/net/ethernet/mellanox/mlx5/core/en_main.c: In function 'mlx5e_alloc_rq':
>drivers/net/ethernet/mellanox/mlx5/core/en_main.c:827:42: warning: array subscript f is outside array bounds of 'struct mlx5_wqe_data_seg[0]' [-Warray-bounds=]
>  827 |                                 wqe->data[f].byte_count = 0;
>      |                                 ~~~~~~~~~^~~
>In file included from drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h:11,
>                 from drivers/net/ethernet/mellanox/mlx5/core/eswitch.h:48,
>                 from drivers/net/ethernet/mellanox/mlx5/core/en_main.c:42:
>drivers/net/ethernet/mellanox/mlx5/core/en.h:250:39: note: while referencing 'data'
>  250 |         struct mlx5_wqe_data_seg      data[0];
>      |                                       ^~~~
>
>[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays
>
>Cc: Saeed Mahameed <saeedm@nvidia.com>
>Cc: Leon Romanovsky <leon@kernel.org>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Eric Dumazet <edumazet@google.com>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Paolo Abeni <pabeni@redhat.com>
>Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
>Cc: netdev@vger.kernel.org
>Cc: linux-rdma@vger.kernel.org
>Signed-off-by: Kees Cook <keescook@chromium.org>

Applied to net-next-mlx5, Thanks!

