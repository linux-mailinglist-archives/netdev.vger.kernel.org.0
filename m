Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFB131AC25
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 15:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhBMOOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 09:14:45 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:38425 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbhBMONh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 09:13:37 -0500
Date:   Sat, 13 Feb 2021 14:12:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613225574; bh=HLAVfjIlwGNW478FWp4tyY59eFbEvOz5vX71ZQBVijk=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=OX2dhEc9PulcqcVVekXlCqwMCvOCBQJU+xltx3p2J181V/lZ2211AdiQihOqP6gd0
         o4rv90C/zI7jaWCvNdMaCTs6OTq9UIHEi6pRaVOO60tk83d+HlNK68l7jIl40PVxAy
         LOON0Hdhvm9OJz7VQgie2Au+6IpzDYOT2gu8F/1CcVUwFIQZI+ZUSDFg+Q3sIIRIfB
         yX7x2SpHplFN7UhwRyh38JOSsVib+EXwrHjs3+NK+ZvysCbnXbLiJ0ErnbPb7/Cy94
         poIC6l8hRSK3JQb8vD7tiCTMjliBKFys1ZYH5oDatMtz813RNCCLmy3V+CVZY0uBsN
         8ldqkdAyJVmCQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Taehee Yoo <ap420073@gmail.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v6 net-next 10/11] skbuff: allow to use NAPI cache from __napi_alloc_skb()
Message-ID: <20210213141021.87840-11-alobakin@pm.me>
In-Reply-To: <20210213141021.87840-1-alobakin@pm.me>
References: <20210213141021.87840-1-alobakin@pm.me>
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

{,__}napi_alloc_skb() is mostly used either for optional non-linear
receive methods (usually controlled via Ethtool private flags and off
by default) and/or for Rx copybreaks.
Use __napi_build_skb() here for obtaining skbuff_heads from NAPI cache
instead of inplace allocations. This includes both kmalloc and page
frag paths.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a80581eed7fc..875e1a453f7e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -562,7 +562,8 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *na=
pi, unsigned int len,
 =09if (len <=3D SKB_WITH_OVERHEAD(1024) ||
 =09    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
 =09    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
-=09=09skb =3D __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
+=09=09skb =3D __alloc_skb(len, gfp_mask, SKB_ALLOC_RX | SKB_ALLOC_NAPI,
+=09=09=09=09  NUMA_NO_NODE);
 =09=09if (!skb)
 =09=09=09goto skb_fail;
 =09=09goto skb_success;
@@ -579,7 +580,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *na=
pi, unsigned int len,
 =09if (unlikely(!data))
 =09=09return NULL;
=20
-=09skb =3D __build_skb(data, len);
+=09skb =3D __napi_build_skb(data, len);
 =09if (unlikely(!skb)) {
 =09=09skb_free_frag(data);
 =09=09return NULL;
--=20
2.30.1


