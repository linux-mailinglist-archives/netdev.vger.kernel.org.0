Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63B0339DDE
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 12:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhCMLiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 06:38:06 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:61436 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbhCMLhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 06:37:37 -0500
Date:   Sat, 13 Mar 2021 11:37:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615635455; bh=EIiFbrmD/indnpcTrZ7NYILlHLrlH6BrrsiydQMtKf0=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=WKdqu0D8cGyUsredOXFY+Cc7MKKPcIU5jqupM6RP6LBlyN9QX7T4OHYqkotQY55kc
         5qMx02/7KpAH9JdVgUN4XywIdGnOg6TAw4QEKR7w9ia/PAT39UI7geGAfXq/L5+CDj
         UfwriMJI68TYt8BzpKc7g7mbkDv7+5YvgR88cYCUuM3kfP+C9eVnY+5CzaflJDC4l8
         14u9vV86otX1QX7pFA1j8yQN4ozUKKqP3fO/PYGBod2GPRtGP+oyz8gPjLmM2jvrIB
         JzRahz7Z49N9IWl58D4ex6nAVR7pfvvyKR9kuqRyzc7p6l2IdxkXxzVxsSE4bfFJhe
         BINNQbTzr/RYA==
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
Subject: [PATCH v2 net-next 2/6] skbuff: make __skb_header_pointer()'s data argument const
Message-ID: <20210313113645.5949-3-alobakin@pm.me>
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

The function never modifies the input buffer, so @data argument
can be marked as const.
This implies one harmless cast-away.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/skbuff.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 483e89348f78..d6ea3dc3eddb 100644
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


