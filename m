Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067B734632F
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 16:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhCWPlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 11:41:50 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:42137 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbhCWPl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 11:41:29 -0400
Date:   Tue, 23 Mar 2021 15:41:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616514087; bh=KaWZVmNX+s6QYfI2KYune+mRKLP3TY75MHKPJja3S2M=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=dp5Sd5AQuwA0b9Qs8DJ2n3JzCPArI+MsOouma4x+ZCxNtwfvJFSCKA2ucG9bRTydJ
         2N647yAo7GlJvzMxUY4t9L98/M75M2kXAP//dvYDWjg7LD2sfPM5PnC7OTjg7SHnVC
         /q1ZGblusLM4B4Cx4sNLhm7l5+xSnEzfeGr9S9NOWeo3T8idoZWijY/tladMQwqbpf
         cAk/AUZ0Bu8WHuDTN8mHzWYZvRtobcljBdmyd9ph8eZ7/fcS5I+VMLjkWxSADXo4MA
         ABDiBdnydWeO14VJX1JhSCbDxEmaQ0EriuxPuoDtxGER9tBSaZsigjU7fqSoO0KfAb
         OcZY5VsfmfjSQ==
To:     Matteo Croce <mcroce@linux.microsoft.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next 0/6] page_pool: recycle buffers
Message-ID: <20210323154112.131110-1-alobakin@pm.me>
In-Reply-To: <20210322170301.26017-1-mcroce@linux.microsoft.com>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@linux.microsoft.com>
Date: Mon, 22 Mar 2021 18:02:55 +0100

> From: Matteo Croce <mcroce@microsoft.com>
>
> This series enables recycling of the buffers allocated with the page_pool=
 API.
> The first two patches are just prerequisite to save space in a struct and
> avoid recycling pages allocated with other API.
> Patch 2 was based on a previous idea from Jonathan Lemon.
>
> The third one is the real recycling, 4 fixes the compilation of __skb_fra=
g_unref
> users, and 5,6 enable the recycling on two drivers.
>
> In the last two patches I reported the improvement I have with the series=
.
>
> The recycling as is can't be used with drivers like mlx5 which do page sp=
lit,
> but this is documented in a comment.
> In the future, a refcount can be used so to support mlx5 with no changes.
>
> Ilias Apalodimas (2):
>   page_pool: DMA handling and allow to recycles frames via SKB
>   net: change users of __skb_frag_unref() and add an extra argument
>
> Jesper Dangaard Brouer (1):
>   xdp: reduce size of struct xdp_mem_info
>
> Matteo Croce (3):
>   mm: add a signature in struct page
>   mvpp2: recycle buffers
>   mvneta: recycle buffers
>
>  .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  2 +-
>  drivers/net/ethernet/marvell/mvneta.c         |  4 +-
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 17 +++----
>  drivers/net/ethernet/marvell/sky2.c           |  2 +-
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
>  include/linux/mm_types.h                      |  1 +
>  include/linux/skbuff.h                        | 33 +++++++++++--
>  include/net/page_pool.h                       | 15 ++++++
>  include/net/xdp.h                             |  5 +-
>  net/core/page_pool.c                          | 47 +++++++++++++++++++
>  net/core/skbuff.c                             | 20 +++++++-
>  net/core/xdp.c                                | 14 ++++--
>  net/tls/tls_device.c                          |  2 +-
>  13 files changed, 138 insertions(+), 26 deletions(-)

Just for the reference, I've performed some tests on 1G SoC NIC with
this patchset on, here's direct link: [0]

> --
> 2.30.2

[0] https://lore.kernel.org/netdev/20210323153550.130385-1-alobakin@pm.me

Thanks,
Al

