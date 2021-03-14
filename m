Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496F133A465
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 12:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbhCNLLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 07:11:34 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:40514 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbhCNLLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 07:11:19 -0400
Date:   Sun, 14 Mar 2021 11:11:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615720277; bh=KbKHs69Z30MoR2CtDmYVM6+lpepKa3puU+bMA1kdp8c=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=ZdCyRk1nOKrJG9lLfRFY2DXyTZAKrUppPS7VAtbmlZW5RfaBw4OV8z3FHGoTxIyT7
         srv3DCI7hjaJILMJ9XOXoGAaAqhHLd4QM6UBj348vDscQ1JP78agr3WvekdPUkWfF/
         iUbfuBD11PlYbQ3dFACoHmxr1XxTKW6X9BGFSsVnh9+D21LFybgWgMT8qemg+1NvbQ
         ksArYh3bbbYGsH7eN6PBPH8PKPSam6RrT/FOwo8eL/N/2SOrjxsOxmhqq6lDouCovP
         aa4pXInD4BGp2UxLpkTQFvTSJHw1zgJBLJ6QyVzYOtkQ9CqIgjlMw0WpNMSrLG25Xp
         F0LxaSBgOA4hQ==
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
Subject: [PATCH v3 net-next 2/6] skbuff: make __skb_header_pointer()'s data argument const
Message-ID: <20210314111027.7657-3-alobakin@pm.me>
In-Reply-To: <20210314111027.7657-1-alobakin@pm.me>
References: <20210314111027.7657-1-alobakin@pm.me>
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

The function never modifies the input buffer, so 'data' argument
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


