Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02B86C9444
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 14:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbjCZMeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 08:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjCZMeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 08:34:25 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F098176BA
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 05:34:23 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id k17so7237140ybm.11
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 05:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1679834063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e8OMItjxzSr7aVzbw5xpsTi4Tr0bLv1FpLf3l/TvJI4=;
        b=wLLItr0EACFXIm0CSLoVDMaPX/5NVclZ6LQ/jK+zPVaCtRQ9G9aLXg4no3g9v/lGBw
         nDMI6et/j1JbeCGMpAe08V7cQwrneXJVTighUxJPSGSj2nGr6xcjVGIFflhUfY7fWG4J
         nWdPHva+d8jTDSJAiIGcLcmlPZnPd8SFgZwF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679834063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e8OMItjxzSr7aVzbw5xpsTi4Tr0bLv1FpLf3l/TvJI4=;
        b=JzQ7TUKHwP9Ee7p7iGkJDvWzXyTFgFlh86uQwLMVsdGKu21uhufEwWSr3usXXu8pwp
         DbxkOqCXPs2ryrXgt1AheLbhXIGXTDfjDZnjqYxGFucWUuxir37+qzRHgRj8GVSJv1Gw
         RrpLvwjbKKzmkRB4ZJvxOjkwarvWkyfJEBzEH1LS079jGntXdxtqi5ujP7qp3yxZ5qdD
         yb1Z4x9TnrOiwFomtk1eUh/lBQnFNtSqsmgUmNBBXoCVhssJ1z46fGmTs/jZoTrCw25e
         Fgl7iN4olkE/tpRiX0rIx3faHHXSlS8Fb46+c8bA9wkyzwxmAqUhF8hrEWID9vs4AONc
         aa1A==
X-Gm-Message-State: AAQBX9dVDtD487Q2+uwKayssXhyak30Jo0FvLdF9lr5cJJHg4I/V0hF3
        SJWhBVaw+EWhNvsP3IJ3+BEP22hIoJC2VL97aUPSKw==
X-Google-Smtp-Source: AKy350aKbdM8jclc2dkRtmhSyetuz9pLI8ATNSKXzWXgQ3AZ9aBe5P/D8j12BQHlrjM/nBPPVNLcYQWbMf9ztJnpm7Y=
X-Received: by 2002:a05:6902:1586:b0:b69:fab9:de39 with SMTP id
 k6-20020a056902158600b00b69fab9de39mr3975809ybu.2.1679834063085; Sun, 26 Mar
 2023 05:34:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230315181902.4177819-1-joel@joelfernandes.org> <20230315181902.4177819-6-joel@joelfernandes.org>
In-Reply-To: <20230315181902.4177819-6-joel@joelfernandes.org>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Sun, 26 Mar 2023 08:34:12 -0400
Message-ID: <CAEXW_YQLQqB9CAzEyddzOJkKx3y268T7g-E313mDsjXVQRT0Dw@mail.gmail.com>
Subject: Re: [PATCH v2 06/14] net/mlx5: Rename kfree_rcu() to kfree_rcu_mightsleep()
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>
Cc:     "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "Paul E . McKenney" <paulmck@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 2:19=E2=80=AFPM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
>
> The kfree_rcu() and kvfree_rcu() macros' single-argument forms are
> deprecated.  Therefore switch to the new kfree_rcu_mightsleep() and
> kvfree_rcu_mightsleep() variants. The goal is to avoid accidental use
> of the single-argument forms, which can introduce functionality bugs in
> atomic contexts and latency bugs in non-atomic contexts.

In a world where patches anxiously await their precious Ack, could
today be our lucky day on this one?

We need Acks to take this in for 6.4. David? Others?

 - Joel


>
> Cc: Ariel Levkovich <lariel@nvidia.com>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c  | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c
> index ca834bbcb44f..8afcec0c5d3c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c
> @@ -242,7 +242,7 @@ mlx5e_int_port_remove(struct mlx5e_tc_int_port_priv *=
priv,
>                 mlx5_del_flow_rules(int_port->rx_rule);
>         mapping_remove(ctx, int_port->mapping);
>         mlx5e_int_port_metadata_free(priv, int_port->match_metadata);
> -       kfree_rcu(int_port);
> +       kfree_rcu_mightsleep(int_port);
>         priv->num_ports--;
>  }
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index 08d0929e8260..b811dad7370a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> @@ -670,7 +670,7 @@ static int mlx5e_macsec_del_txsa(struct macsec_contex=
t *ctx)
>
>         mlx5e_macsec_cleanup_sa(macsec, tx_sa, true);
>         mlx5_destroy_encryption_key(macsec->mdev, tx_sa->enc_key_id);
> -       kfree_rcu(tx_sa);
> +       kfree_rcu_mightsleep(tx_sa);
>         macsec_device->tx_sa[assoc_num] =3D NULL;
>
>  out:
> @@ -849,7 +849,7 @@ static void macsec_del_rxsc_ctx(struct mlx5e_macsec *=
macsec, struct mlx5e_macsec
>         xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
>         metadata_dst_free(rx_sc->md_dst);
>         kfree(rx_sc->sc_xarray_element);
> -       kfree_rcu(rx_sc);
> +       kfree_rcu_mightsleep(rx_sc);
>  }
>
>  static int mlx5e_macsec_del_rxsc(struct macsec_context *ctx)
> --
> 2.40.0.rc1.284.g88254d51c5-goog
>
