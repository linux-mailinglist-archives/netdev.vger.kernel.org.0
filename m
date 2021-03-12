Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DDB339800
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 21:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbhCLUJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 15:09:33 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:49467 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbhCLUJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 15:09:10 -0500
Date:   Fri, 12 Mar 2021 20:08:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615579744; bh=m5YpQ1gg9mlr+QYgTSpX4OBBI/dH4lK1uPJejw2gv10=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=mo4+o0GYaZzYe+GqN6g44ZacwsLT5284lKxGvSuEN6lodY6NVTIqGoRuFKSAfnME0
         4x7PRjPeQbf6sUjFTva8tbaj4UyrcKm6cQHN2sFbkco5E3wGbAXJnvoMRu9V6uOJqr
         bag0QsJXARFBa2TIJu0FKSQuurrjl1SHk09t0D63aDc038iwOaqh1FII2ZI72O1xr6
         vaZlSMs7mMMh4j4IQ+fy+dF/NEEEmKnYZCeki1br+3uWeTL8OpSUdK6yixQSSlEv2f
         HfpbXl7uf7id6OQG5Bl5ME620j17JRLc8qP0toPmMNY6lh9h1xoaEUxrjwSx9ZOYeb
         T0m1Y81D/akhQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Guillaume Nault <gnault@redhat.com>, wenxu <wenxu@ucloud.cn>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net] flow_dissector: fix byteorder of dissected ICMP ID
Message-ID: <20210312200834.370667-1-alobakin@pm.me>
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

flow_dissector_key_icmp::id is of type u16 (CPU byteorder),
ICMP header has its ID field in network byteorder obviously.
Sparse says:

net/core/flow_dissector.c:178:43: warning: restricted __be16 degrades to in=
teger

Convert ID value to CPU byteorder when storing it into
flow_dissector_key_icmp.

Fixes: 5dec597e5cd0 ("flow_dissector: extract more ICMP information")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/flow_dissector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 2ef2224b3bff..a96a4f5de0ce 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -176,7 +176,7 @@ void skb_flow_get_icmp_tci(const struct sk_buff *skb,
 =09 * avoid confusion with packets without such field
 =09 */
 =09if (icmp_has_id(ih->type))
-=09=09key_icmp->id =3D ih->un.echo.id ? : 1;
+=09=09key_icmp->id =3D ih->un.echo.id ? ntohs(ih->un.echo.id) : 1;
 =09else
 =09=09key_icmp->id =3D 0;
 }
--
2.30.2


