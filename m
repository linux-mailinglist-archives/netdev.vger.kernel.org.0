Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49675207AD
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbiEIWeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiEIWeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:34:20 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA702B5CEC
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:30:23 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2f7d19cac0bso160567397b3.13
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2qOACNgKCY/8m8M04UUkdLc73pPCtQgz/SpADiD8llQ=;
        b=K3CJWtJyixfVQIjPXb4p1rpgZ3fNig7AOOzhC4R+BWBkiLuRovI1U38UV7ImMbcHgq
         7aEccrQVbkNzshsooVi2LEEIb51hfP9ACjD4cvZV79rRm3nl1OBz9+qugF1In/RRSX3A
         5eKb4e5twy9B3OZPWvwbmPAdzxY8u25VRazwQZayoPhCYdFaSWon8sPwbaN+i/VdKGvX
         SyfGnashxJf6Mm2ZFHYlmFUfcAQiATN2JTCffKDO3qhe8nxNiZ+8zfTB6zrBhi4/+lqX
         SYVCHDTPlFsk3oFVSSk7qbH+JHypsoN/bWCpeURQbefEc1X9H9vEPbn3HPx1+8DZ971Z
         7ntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2qOACNgKCY/8m8M04UUkdLc73pPCtQgz/SpADiD8llQ=;
        b=6+4sbi3nvmoiAuBbhND1VYi4jUzxIxGEYU+x/jakJb8MZcVc0lRBJGABOvfgUzaRKj
         jI4brwnmMhuJ45m6QMtEvaZkMFsAIcHj+8DbC11KN2NxAs1d69T9Dmg+7l7zQJe2YwCX
         YdiyB7RcE5+eLmM8uyb7y8c+TvslZEkTRxSRsziGdLMiSobzpbTsH+CdU4X+Y44vCbiS
         pOpA5Y8XBW7hg2Ial2dTAIil7MFA9CX11DHQPX61LP14LnuPOLCLFY20Ptcu+8Re0Twh
         1I2GCXoAoD95kdBgzbh0G7V7J8udhSCUQnCwfiUm2X69EPAQ9/8nNS0X+oNN4ePHFZvF
         uG0Q==
X-Gm-Message-State: AOAM532ofnwJjG0ksGmZdBLWnmaXXY5W180cmsNJuxX4HtszwiBtc2Lk
        C3wHTtkIzE3IybxIDExcgWCz5MpkH/2XtK24PDn1kA==
X-Google-Smtp-Source: ABdhPJyYYCGdIhFCsoYupunW8FR3IVGwxxpZ292/J67baR9MR2lE+7UiPHNTckhO86QC0rSQSTNzGOO5J5BPLqTGIU8=
X-Received: by 2002:a81:4f0c:0:b0:2f8:46f4:be90 with SMTP id
 d12-20020a814f0c000000b002f846f4be90mr16812620ywb.332.1652135422330; Mon, 09
 May 2022 15:30:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220509222149.1763877-1-eric.dumazet@gmail.com> <20220509222149.1763877-14-eric.dumazet@gmail.com>
In-Reply-To: <20220509222149.1763877-14-eric.dumazet@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 May 2022 15:30:11 -0700
Message-ID: <CANn89i+R4p=wP-++2TXTrxxnOJJ+ObdD=n9-ib6HDENhpSn9yA@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 13/13] mlx5: support BIG TCP packets
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 3:22 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
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
> ---
>  .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
>  .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 84 +++++++++++++++----
>  2 files changed, 69 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index d27986869b8ba070d1a4f8bcdc7e14ab54ae984e..226825410a1aa55b5b7941a7389a78abdb800521 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -4920,6 +4920,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
>
>         netdev->priv_flags       |= IFF_UNICAST_FLT;
>
> +       netif_set_tso_max_size(netdev, 512 * 1024);

Apparently I forgot to amend this part on the final patch of the series.

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 226825410a1aa55b5b7941a7389a78abdb800521..bf3bca79e160124abd128ac1e9910cb2f39a39ff
100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4920,7 +4920,7 @@ static void mlx5e_build_nic_netdev(struct
net_device *netdev)

        netdev->priv_flags       |= IFF_UNICAST_FLT;

-       netif_set_tso_max_size(netdev, 512 * 1024);
+       netif_set_tso_max_size(netdev, GSO_MAX_SIZE);
        mlx5e_set_netdev_dev_addr(netdev);
        mlx5e_ipsec_build_netdev(priv);
        mlx5e_ktls_build_netdev(priv);
