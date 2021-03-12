Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 348CD3397AF
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 20:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbhCLTrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 14:47:12 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:51545 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbhCLTqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 14:46:40 -0500
Date:   Fri, 12 Mar 2021 19:46:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615578398; bh=rmYbHL79wt4dhIbnCttbVVGP2ZT2H/KbCOCNp0UQlaM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=NnATg0XMUItsW7CInI6e5paZ1QFL20P+ng7ZZFL/MNPwjsHBBW0hETFmUNezUKdjX
         8KTwO3fS7w4pZpOGUXDTDi3G14R82yf0bXc0LNzsWViev3hjghwRW3ZMbLwRAhL540
         78x8OJfu5bdmPFajVTxmQUXLC1yKnkNuIV7wotsfXfweJ4+JZH04YFE6IaaJFv52l+
         mD0qm3liXPGkK3YDyS2FwEy8VQBfd3UVGJqMJbxedGb50nKLPhS8RIQgE3b+qxLJtO
         2tMVA5oR713TE9sqZlVN/PQ0tY9+14Us5HnvPA9t4K2qU6NvUqimH5sd5sjVI0LMq+
         Hs33ItmmEt5Eg==
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
Subject: [PATCH net-next 2/6] skbuff: make __skb_header_pointer()'s data argument const
Message-ID: <20210312194538.337504-3-alobakin@pm.me>
In-Reply-To: <20210312194538.337504-1-alobakin@pm.me>
References: <20210312194538.337504-1-alobakin@pm.me>
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

The function never modifies the input buffer, so @data argument
can be marked as const.
This implies one harmless cast-away.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/skbuff.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0503c917d773..d93ab74063e5 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3678,11 +3678,11 @@ __wsum skb_checksum(const struct sk_buff *skb, int =
offset, int len,
 =09=09    __wsum csum);

 static inline void * __must_check
-__skb_header_pointer(const struct sk_buff *skb, int offset,
-=09=09     int len, void *data, int hlen, void *buffer)
+__skb_header_pointer(const struct sk_buff *skb, int offset, int len,
+=09=09     const void *data, int hlen, void *buffer)
 {
 =09if (hlen - offset >=3D len)
-=09=09return data + offset;
+=09=09return (void *)data + offset;

 =09if (!skb ||
 =09    skb_copy_bits(skb, offset, buffer, len) < 0)
--
2.30.2


