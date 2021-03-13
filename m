Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA610339DEB
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 12:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbhCMLil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 06:38:41 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:60278 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbhCMLiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 06:38:20 -0500
Date:   Sat, 13 Mar 2021 11:38:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615635498; bh=5MpWKAjO4E1TpGup0jNHoJh4fKp9mBQ4WRLVO089bHE=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=lJosGFsIHUoNJ7eKfmhWt2Fru4UoM5jFXEAsiNn5NDRGwCJGYg4NvdQ38WsnfNHj2
         a1r70/D7C1YtcSVIuzNOJqzHw2CcebtcZ/mVXMqrDTcRiyh4XDpd3xtIbqXr/lc2EE
         oiaC5h0TeGNlcFzcr7UPVZJcjpRNhA3O9n/sFsTuMBwtjVuHam9CmkQ+aWmpYaYhWs
         /DXzzRntt/lyDy0E2koNv5SroShb81BlO6uctaqRp+OQhmegZ8ky/xFIkVWotQyHby
         lYnBuBni7bVaa8J6VQopc7g3htNmt1C3RBCMOaay4d7veR6qVPr2Pb+1jixjUFFQrS
         R9gITd9sNnnbQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
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
Subject: [PATCH v2 net-next 6/6] skbuff: micro-optimize {,__}skb_header_pointer()
Message-ID: <20210313113645.5949-7-alobakin@pm.me>
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

{,__}skb_header_pointer() helpers exist mainly for preventing
accesses-beyond-end of the linear data.
In the vast majorify of cases, they bail out on the first condition.
All code going after is mostly a fallback.
Mark the most common branch as 'likely' one to move it in-line.
Also, skb_copy_bits() can return negative values only when the input
arguments are invalid, e.g. offset is greater than skb->len. It can
be safely marked as 'unlikely' branch, assuming that hotpath code
provides sane input to not fail here.

These two bump the throughput with a single Flow Dissector pass on
every packet (e.g. with RPS or driver that uses eth_get_headlen())
on 20 Mbps per flow/core.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/skbuff.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 46c61e127e9f..ecc029674ae4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3680,11 +3680,10 @@ static inline void * __must_check
 __skb_header_pointer(const struct sk_buff *skb, int offset, int len,
 =09=09     const void *data, int hlen, void *buffer)
 {
-=09if (hlen - offset >=3D len)
+=09if (likely(hlen - offset >=3D len))
 =09=09return (void *)data + offset;

-=09if (!skb ||
-=09    skb_copy_bits(skb, offset, buffer, len) < 0)
+=09if (!skb || unlikely(skb_copy_bits(skb, offset, buffer, len) < 0))
 =09=09return NULL;

 =09return buffer;
--
2.30.2


