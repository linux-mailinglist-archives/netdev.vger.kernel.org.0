Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF702AC988
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbgKIXr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:47:29 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:55815 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKIXr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 18:47:29 -0500
Date:   Mon, 09 Nov 2020 23:47:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604965646; bh=uYN8M4VNUEQtV4L58BW2W4twRUw/8B/3sQ69oqzf5Ik=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=l7C3WflOqe8XWnTmLJY+5gpnzVnH/Mjgx398KZnT/BnobLVmztvbroExU0Dp1Tio+
         RW9bmknOO7ODew6S59iR0JKK3T4mVRpiP4/WWVzZ5ip2x5+IGleQIV5jJdyQxNiex3
         svHiWc6NUOCSszEawyMOelTTyAiLaZmqMYOr+OUCRqNI9A+Pe4+v+znt5uxWS3vaRP
         pQZ3Vo1y9JzyGHEJftnTMFxbV0l2mIbIpYLq7r25dGVVrwqTNYNP5l/jMoZbU/JNSb
         rQMlFRiUkqanXDR9i/d4crF6kY7oFl/a6m4vvax/P8pphaNiNAa1ReX2MrG9njpwaR
         jzhuNk4w0ZH1w==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Eric Dumazet <edumazet@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Willem de Bruijn <willemb@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net-next] net: skb_vlan_untag(): don't reset transport offset if set by GRO layer
Message-ID: <7JgIkgEztzt0W6ZtC9V9Cnk5qfkrUFYcpN871syCi8@cp4-web-040.plabs.ch>
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

Similar to commit fda55eca5a33f
("net: introduce skb_transport_header_was_set()"), avoid resetting
transport offsets that were already set by GRO layer. This not only
mirrors the behavior of __netif_receive_skb_core(), but also makes
sense when it comes to UDP GSO fraglists forwarding: transport offset
of such skbs is set only once by GRO receive callback and remains
untouched and correct up to the xmitting driver in 1:1 case, but
becomes junk after untagging in ingress VLAN case and breaks UDP
GSO offload. This does not happen after this change, and all types
of forwarding of UDP GSO fraglists work as expected.

Since v1 [1]:
 - keep the code 1:1 with __netif_receive_skb_core() (Jakub).

[1] https://lore.kernel.org/netdev/zYurwsZRN7BkqSoikWQLVqHyxz18h4LhHU4NFa2V=
w@cp4-web-038.plabs.ch

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1ba8f0163744..aa3d2828b7a2 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5430,7 +5430,8 @@ struct sk_buff *skb_vlan_untag(struct sk_buff *skb)
 =09=09goto err_free;
=20
 =09skb_reset_network_header(skb);
-=09skb_reset_transport_header(skb);
+=09if (!skb_transport_header_was_set(skb))
+=09=09skb_reset_transport_header(skb);
 =09skb_reset_mac_len(skb);
=20
 =09return skb;
--=20
2.29.2


