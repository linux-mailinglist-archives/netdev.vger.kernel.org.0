Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C91339E48
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 14:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbhCMNax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 08:30:53 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:17620 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbhCMNaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 08:30:39 -0500
Date:   Sat, 13 Mar 2021 13:30:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615642236; bh=6r1N5OSEeyM3HNy+jVrlMhPyXWgVSnlITt0tT5FGaWU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=CTgpkDnM5DFkOhsoutj5H+n+LLd0lnuqmRm9fsR3jKhJfiCVKfBcS0G5U3xihok23
         PRk8Ygz0XEKq4fu+OZrbyVk8G8/di1dlGIdBUkYF2hbJN5SOjnkFgBGB6nOUsCuUgC
         8Mr2IkI9xqrbSeISjIm93HXg6Oy3UVx39hWWPOdmYqwf2q1Zj1K384wYhIxRZVH4AX
         IOsMfRCmlVjWbkmD81MSQzDOZGGd1CtbilKOpRTvpGZk4KcjLL2gG/pPA/BZQbCmDL
         zJ+BNWXHd3qDYMPQ1Am1ybNWR0S3JXXgjy7wB5NICMMByVD6YDp75ioNHrHuI4FWy0
         p9Uf3yMsS8JnA==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Wang Qing <wangqing@vivo.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 net-next 0/6] skbuff: micro-optimize flow dissection
Message-ID: <20210313132956.647745-1-alobakin@pm.me>
In-Reply-To: <20210313113645.5949-1-alobakin@pm.me>
References: <20210313113645.5949-1-alobakin@pm.me>
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

From: Alexander Lobakin <alobakin@pm.me>
Date: Sat, 13 Mar 2021 11:37:03 +0000

> This little number makes all of the flow dissection functions take
> raw input data pointer as const (1-5) and shuffles the branches in
> __skb_header_pointer() according to their hit probability.
>
> The result is +20 Mbps per flow/core with one Flow Dissector pass
> per packet. This affects RPS (with software hashing), drivers that
> use eth_get_headlen() on their Rx path and so on.
>
> Since v1 [0]:
>  - rebase on top of the latest net-next. This was super-weird, but
>    I double-checked that the series applies with no conflicts, and
>    then on Patchwork it didn't;

Still failing on Patchwork. I rebased it ten thousand times, rebuilt
the patches manually, tried previous stable Git version and the
latest CVS snapshot, and always got the same series that successfully
applies to next-next.
Can you please take a look?

>  - no other changes.
>
> [0] https://lore.kernel.org/netdev/20210312194538.337504-1-alobakin@pm.me
>
> Alexander Lobakin (6):
>   flow_dissector: constify bpf_flow_dissector's data pointers
>   skbuff: make __skb_header_pointer()'s data argument const
>   flow_dissector: constify raw input @data argument
>   linux/etherdevice.h: misc trailing whitespace cleanup
>   ethernet: constify eth_get_headlen()'s @data argument
>   skbuff: micro-optimize {,__}skb_header_pointer()
>
>  include/linux/etherdevice.h  |  4 ++--
>  include/linux/skbuff.h       | 26 +++++++++++------------
>  include/net/flow_dissector.h |  6 +++---
>  net/core/flow_dissector.c    | 41 +++++++++++++++++++-----------------
>  net/ethernet/eth.c           |  2 +-
>  5 files changed, 40 insertions(+), 39 deletions(-)
>
> --
> 2.30.2

Thanks,
Al

