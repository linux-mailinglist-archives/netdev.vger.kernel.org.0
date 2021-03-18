Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137C1340D61
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbhCRSmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:42:43 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:31689 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbhCRSmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:42:35 -0400
Date:   Thu, 18 Mar 2021 18:42:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616092953; bh=CZPzXPr6kxKmjKYiFth7lEmlditzWiKAt31a6bYz0BI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=FIaVLXSW92dxr8oytIZCizii/i9XUVemC0T7TIRFjAl8uwZpExxjQ7C3+J5qZMr4W
         wwTyCbbGbZndoyKBBvrGYBmryILMnlvz6RobHBpFBkBBdlQ1i1TT2nqw1WeCuAmYTB
         yDraprzPaWRcHKCv4BKVytT64iZCjXFeB0+XMqZ0rcFlVbUjB57tUVJR5QOtqCAwLe
         8aayIKPCRWVZuQYFOvvVtuYaiA2kx+5bjFKjKFbrFMj9tR4Om6jX8PT0e8zpnuE4tC
         5gpLrw10tKVeR7UODv2P8EOCVlvB5NLFkaXNCHs5srn/NlZ1MGgsv1ROlw4lXYt79u
         EP2wMyhm3hm4Q==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Leon Romanovsky <leon@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 2/4] gro: add combined call_gro_receive() + INDIRECT_CALL_INET() helper
Message-ID: <20210318184157.700604-3-alobakin@pm.me>
In-Reply-To: <20210318184157.700604-1-alobakin@pm.me>
References: <20210318184157.700604-1-alobakin@pm.me>
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

call_gro_receive() is used to limit GRO recursion, but it works only
with callback pointers.
There's a combined version of call_gro_receive() + INDIRECT_CALL_2()
in <net/inet_common.h>, but it doesn't check for IPv6 modularity.
Add a similar new helper to cover both of these. It can and will be
used to avoid retpoline overhead when IP header lies behind another
offloaded proto.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/net/gro.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/net/gro.h b/include/net/gro.h
index 27c38b36df16..01edaf3fdda0 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -14,4 +14,12 @@ INDIRECT_CALLABLE_DECLARE(int ipv6_gro_complete(struct s=
k_buff *, int));
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *inet_gro_receive(struct list_hea=
d *,
 =09=09=09=09=09=09=09   struct sk_buff *));
 INDIRECT_CALLABLE_DECLARE(int inet_gro_complete(struct sk_buff *, int));
+
+#define indirect_call_gro_receive_inet(cb, f2, f1, head, skb)=09\
+({=09=09=09=09=09=09=09=09\
+=09unlikely(gro_recursion_inc_test(skb)) ?=09=09=09\
+=09=09NAPI_GRO_CB(skb)->flush |=3D 1, NULL :=09=09\
+=09=09INDIRECT_CALL_INET(cb, f2, f1, head, skb);=09\
+})
+
 #endif /* _NET_IPV6_GRO_H */
--
2.31.0


