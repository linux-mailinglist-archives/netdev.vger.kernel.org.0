Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21857618F70
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiKDEMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKDEMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:12:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A24F20F6B
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 21:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35B58B82B61
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 04:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D635C433D6;
        Fri,  4 Nov 2022 04:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667535123;
        bh=C5WarGtwX13qUEcPZbC7qKV2yJE90TYS4jvmdndiHKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IcX6ghoYnWDA30dYM3NOWGwYjrbcwXkLsoWVfC30P5aBWS+Yoka9kkLcO5D55Tsg+
         nGD8X3Gz6yAMpBm4Xk5yDJlbNZAKGqMxTAVGW1FW7di7XsrMoFq8C4t3xGAeS8IFDF
         a2pU4WtGbwREfHL+V00ksXlzJCtL9NSWK68Pr0JpodIZxzUUn9WQRwWxY+U5sm2S2o
         728lsVP/k8AlqeoZd8yKN5PuGsd6RMY625PkHoYroqJS3ZC4lfqjYl/gh9d3MIvik7
         7zf9eGkO3wx4T/nhQd5r2+xEMGY3/c93fcYQBFGDJXXmfFncTFWkFdWvwKjEuM5E82
         WT9aL8Lo7L2Kg==
Date:   Thu, 3 Nov 2022 21:12:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [net 06/11] net/mlx5e: Add missing sanity checks for max TX WQE
 size
Message-ID: <20221103211202.42abcfe9@kernel.org>
In-Reply-To: <20221103065547.181550-7-saeed@kernel.org>
References: <20221103065547.181550-1-saeed@kernel.org>
        <20221103065547.181550-7-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Nov 2022 23:55:42 -0700 Saeed Mahameed wrote:
> From: Maxim Mikityanskiy <maximmi@nvidia.com>
>=20
> The commit cited below started using the firmware capability for the
> maximum TX WQE size. This commit adds an important check to verify that
> the driver doesn't attempt to exceed this capability, and also restores
> another check mistakenly removed in the cited commit (a WQE must not
> exceed the page size).
>=20
> Fixes: c27bd1718c06 ("net/mlx5e: Read max WQEBBs on the SQ from firmware")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

32bit is not on board:

drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:323:72: warning: format =E2=
=80=98%lu=E2=80=99 expects argument of type =E2=80=98long unsigned int=E2=
=80=99, but argument 4 has type =E2=80=98unsigned int=E2=80=99 [-Wformat=3D]
  323 |                         netdev_warn(skb->dev, "ds_cnt_inl =3D %u > =
max %lu\n",
      |                                                                    =
  ~~^
      |                                                                    =
    |
      |                                                                    =
    long unsigned int
      |                                                                    =
  %u
