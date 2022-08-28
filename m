Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41FB5A3D0C
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 11:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiH1Jzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 05:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiH1Jzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 05:55:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9613C43E5D;
        Sun, 28 Aug 2022 02:55:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A1EDB80A3A;
        Sun, 28 Aug 2022 09:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A978C433C1;
        Sun, 28 Aug 2022 09:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661680546;
        bh=TcwxDWZtQS6kMjN2jg9yz87Lt7T5qZ8ftJVQLc8rmrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rxq1frQ4Y7jG/7PA4ZNlJ7bYY/4+1Ihaz96hMvhmyswpnbYQ9NfPX9HShQ2ybT6pW
         It1NQhz+dlZPJe19lcZ+FwtAT1QC0wS7J1y0qZMHoD7pMwPnwLHGMNDo4YxxCJxpdg
         nDMHMiQE91NuwChoGUW2JC84wJEQOE5uSBM8uP79WzpX9vAq5FH5bhXnTFAkrLlLjx
         v3OlNw401ZIXH6LvhActC8mcqhOjRwjzPO+wygYnRinPMZaebAgt7yWX4EZAMZiQcM
         Lgz0AKaIZMWaXfsiePeR9j5QbrhaGtdZhnfw6+8k071rcdP/AOYfBpyBuuee1BNVGS
         bQmnUOm6KjyYg==
Date:   Sun, 28 Aug 2022 12:55:41 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH net-next] net/mlx5e: Do not use err uninitialized in
 mlx5e_rep_add_meta_tunnel_rule()
Message-ID: <Yws7nQsU8hIf7gZT@unreal>
References: <20220825180607.2707947-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825180607.2707947-1-nathan@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 11:06:07AM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:481:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>           if (IS_ERR(flow_rule)) {
>               ^~~~~~~~~~~~~~~~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:489:9: note: uninitialized use occurs here
>           return err;
>                 ^~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:481:2: note: remove the 'if' if its condition is always true
>           if (IS_ERR(flow_rule)) {
>           ^~~~~~~~~~~~~~~~~~~~~~~
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:474:9: note: initialize the variable 'err' to silence this warning
>           int err;
>                 ^
>                   = 0
>   1 error generated.
> 
> There is little reason to have the 'goto + error variable' construct in
> this function. Get rid of it and just return the PTR_ERR value in the if
> statement and 0 at the end.
> 
> Fixes: 430e2d5e2a98 ("net/mlx5: E-Switch, Move send to vport meta rule creation")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1695
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
