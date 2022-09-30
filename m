Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AD25F0B3B
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 14:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiI3MBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 08:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiI3MBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 08:01:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FACF177780;
        Fri, 30 Sep 2022 05:01:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F36EC62305;
        Fri, 30 Sep 2022 12:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDA8C433C1;
        Fri, 30 Sep 2022 12:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664539297;
        bh=WZzX794V9cagudvFHu1WJf2NrlOx/oVKtEOLe82Lt50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TEpa35aPjU1X8g041BdEMvwePCqUTcnpTx0QkQ7wkBLP9onCYsKJ3NRpzsr36mrnt
         EVWUip9v4DqWjRTz79FzpJKdp3iikzn1alAO5MtcsxKunJAYGP55jkEAGEFuzbf7Z2
         PmFtMZX5H8rB5O6ivd9eQ74YMjehU5OQEYoEOcEA=
Date:   Fri, 30 Sep 2022 14:01:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Praghadeesh T K S <praghadeeshthevendria@gmail.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        praghadeeshtks@zohomail.in,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: ethernet/mellanox: fix dereference before null check
Message-ID: <Yzbanh3V4jtgcih0@kroah.com>
References: <20220930114335.608894-1-praghadeeshthevendria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930114335.608894-1-praghadeeshthevendria@gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 05:13:35PM +0530, Praghadeesh T K S wrote:
> net: ethernet/mellanox: fix dereference before null check
> macsec dereferenced before null check
> bug identified by coverity's linux-next weekly scan
> Coverity CID No: 1525317
> 
> Signed-off-by: Praghadeesh T K S <praghadeeshthevendria@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index 5da746d..e822c2a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> @@ -1846,11 +1846,11 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
>  void mlx5e_macsec_cleanup(struct mlx5e_priv *priv)
>  {
>  	struct mlx5e_macsec *macsec = priv->macsec;
> -	struct mlx5_core_dev *mdev = macsec->mdev;
>  
>  	if (!macsec)
>  		return;
>  
> +	struct mlx5_core_dev *mdev = macsec->mdev;
>  	mlx5_notifier_unregister(mdev, &macsec->nb);
>  
>  	mlx5e_macsec_fs_cleanup(macsec->macsec_fs);

Always test-build your changes before you get a grumpy maintainer asking
why you didn't test-build your changes...

Also, the original code is just fine, Coverity is wrong here, don't you
think?  Look at the output of what the code is doing please...

thanks,

greg k-h
