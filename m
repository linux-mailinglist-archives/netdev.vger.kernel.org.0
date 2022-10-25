Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1432660C296
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 06:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiJYEY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 00:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiJYEYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 00:24:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049FE638B
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 21:24:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 50543CE1B7D
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC6EC433D6;
        Tue, 25 Oct 2022 04:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666671860;
        bh=6xrZ7p3zp9IDZ36aWUQwITJ2skZp5zc7Iw00IDnWnrQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MZe1JOn1WSvFlvXHer80aaQ+xpV2hCskKg2qHM8HjyMPw6fU0KqkTfTGu/GEfis4D
         XLPvvruVQfBXOjhkXHzSZao8qXaF2746iztjWLKGRIKkLCNd9OgodG1Ta7Vi3MVL4q
         XqUbDQ2Eydhz5tciQnw7homneOJp9Hak2XyJ4LNGv5Dt2ctiOfmO0S0pq07yAolq1r
         9U1nBHkXCw+zaQF5ad2zIicr/u7xPW5v/QSXXqcLNNaCF0D2F42iAVMQBsALwHSfGV
         UZSZx0jVNpaxz1gpnL8DiQT9Jei6GkGOikYpqL1crnOuZPoAELWCS8q7U8kEEWV4kp
         qYO5lNeA+noQg==
Date:   Mon, 24 Oct 2022 21:24:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: Re: [net-next 05/14] net/mlx5: DR, Allocate ste_arr on stack
 instead of dynamically
Message-ID: <20221024212419.003b3056@kernel.org>
In-Reply-To: <20221024135734.69673-6-saeed@kernel.org>
References: <20221024135734.69673-1-saeed@kernel.org>
        <20221024135734.69673-6-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Oct 2022 14:57:25 +0100 Saeed Mahameed wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>=20
> While creting rule, ste_arr is a short array that is allocated in
> the beginning of the function and freed at the end.
> To avoid memory allocation "hiccups" that sometimes take up to 10ms,
> allocate it on stack.

There's a reason, 32bit x86 does not like this:

drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c: In function =E2=
=80=98dr_rule_create_rule_nic=E2=80=99:
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c:1202:1: warning:=
 the frame size of 1568 bytes is larger than 1024 bytes [-Wframe-larger-tha=
n=3D]
1202 | }
     | ^
