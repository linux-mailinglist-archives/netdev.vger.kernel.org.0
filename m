Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76042A8909
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 22:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgKEV3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 16:29:16 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:11060 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732090AbgKEV3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 16:29:13 -0500
Date:   Thu, 05 Nov 2020 21:29:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604611750; bh=TlTCVc4GsAeJhqQaL3Nb2ua0fbsIOLGFOUjiApOTEkY=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=Qj0/1xbD/DgV5a4CaDmO/eF3yFtVAiacxsFsvvWc92lHdbDAPBmdJqPQxViInw66w
         gsbbwwWdSgO/r5aBPmTCABQYgyDvshldXrPnrN1soieb/uaENRiXiMxwxRtUhd3fvo
         gXJUS8r+HTsS6MCqnXwCik+K+RvAV73elV40HgjLAPjsWlDjqDJ5Pg44RL0mxlrxGX
         9m6aVUGjvZh2yP7f3tDAgNeZmsGBjRf/ocpD6LmZwWoD959VqmncrFFqZyjg5ea4Zl
         7PxkBSCR1NodfrzQoVt7attstz4x+Q7OCtD04NQ6L5PBY8DAdaP3HRoePV+R5xMoU6
         lmOtgOE5/JaIw==
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
Subject: [PATCH net-next] net: skb_vlan_untag(): don't reset transport offset if set by GRO layer
Message-ID: <zYurwsZRN7BkqSoikWQLVqHyxz18h4LhHU4NFa2Vw@cp4-web-038.plabs.ch>
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

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c5e6c0b83a92..39c13b9cf79d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5441,9 +5441,11 @@ struct sk_buff *skb_vlan_untag(struct sk_buff *skb)
 =09=09goto err_free;
=20
 =09skb_reset_network_header(skb);
-=09skb_reset_transport_header(skb);
 =09skb_reset_mac_len(skb);
=20
+=09if (!skb_transport_header_was_set(skb))
+=09=09skb_reset_transport_header(skb);
+
 =09return skb;
=20
 err_free:
--=20
2.29.2


