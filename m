Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3999D6B963C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCNNa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjCNNaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:30:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA94A335B;
        Tue, 14 Mar 2023 06:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 598EB61769;
        Tue, 14 Mar 2023 13:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55288C4339B;
        Tue, 14 Mar 2023 13:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678800428;
        bh=tCzKnFRK0qIH4wtFgcRS/5fElFtUpjFMb3tMtIuGDog=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aep7dIbi1hQyEHkUrTxbDG8NRyLsdSEwkML/h3wrsqUvWw067VuA5c+dt1ilX0bzj
         NluuSTHHQeEuGzYV9cVS6eEK2oKAiwIHnA8uFm35NrL82WWo3phtr6qJD5pqJ91vFq
         MFTM15unZCOz1euIEoTZMyAWKxVtVN+eM2xfxF/pOjS0XOHlHCnrxDDNkbWalOkQt9
         Myj5BcE7i6tMGCyByhEfQF0MpAMjSlc7GfcJfE8QaE0psAuhOElvKnT10eOZOh/LZz
         UgjIGocClO58k70nrxbljpbDYtCMIRqrrkxuFMaEwWlw+UurvSGBtmszxDAjfhQga0
         OicfsKfD3RzKA==
Date:   Tue, 14 Mar 2023 15:27:05 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakob Koschel <jkl820.git@gmail.com>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH net-next] net/mlx5e: avoid usage of list iterator after
 loop
Message-ID: <20230314132705.GE36557@unreal>
References: <20230301-net-mlx5e-avoid-iter-after-loop-v1-1-064c0e9b1505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301-net-mlx5e-avoid-iter-after-loop-v1-1-064c0e9b1505@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 04:26:02PM +0100, Jakob Koschel wrote:
> If potentially no valid element is found, 'priv_rx' would contain an
> invalid pointer past the iterator loop. To ensure 'priv_rx' is always
> valid, we only set it if the correct element was found. That allows
> adding a WARN_ON() in case the code works incorrectly, exposing
> currently undetectable potential bugs.
> 
> Additionally, Linus proposed to avoid any use of the list iterator
> variable after the loop, in the attempt to move the list iterator
> variable declaration into the macro to avoid any potential misuse after
> the loop [1].
> 
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
> Signed-off-by: Jakob Koschel <jkl820.git@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
