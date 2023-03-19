Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA1C6C05F6
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 23:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjCSWKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 18:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjCSWKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 18:10:31 -0400
Received: from ocelot.miegl.cz (ocelot.miegl.cz [195.201.216.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ADF6E99;
        Sun, 19 Mar 2023 15:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=miegl.cz; s=dkim;
        t=1679263826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XTvG4gYKA+YtluD3rBPX47zu84nIB9zKoJOoRegJkSU=;
        b=awqSNRPCO3mfVrNW8/NG4mFu3alZvoi3MpisRoNdWbKkhIKj3lB9phr1imFbWCkfCrvjnR
        4pIs22omzhH2tDbydmp7UIdpd5ObP1tak/01T+UbJJXTiGW55LBXN0aeN8iJPjT//j/UeR
        HnSo2lM/w8NKNmGLB97rJ6KdsNJX2jz4Q7RYuNV0RlBuDh/JiZwiJWlrxUozDMjFY8mWY+
        Nv8xbsKCwn7dzr7Nr/YDBTap14/QvIlauyUswTgq4uL9tf+HoPMiygggeIXKKXLZKJZGIJ
        Wp0vftxoyowiNTLWBfkCVMv7qx4hrHxj9mWqvQbGjIVKt7si0MFTHJaCPArE0w==
From:   Josef Miegl <josef@miegl.cz>
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Josef Miegl <josef@miegl.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net: geneve: accept every ethertype
Date:   Sun, 19 Mar 2023 23:09:54 +0100
Message-Id: <20230319220954.21834-1-josef@miegl.cz>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Geneve encapsulation, as defined in RFC 8926, has a Protocol Type
field, which states the Ethertype of the payload appearing after the
Geneve header.

Commit 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
introduced a new IFLA_GENEVE_INNER_PROTO_INHERIT flag that allowed the
use of other Ethertypes than Ethernet. However, it did not get rid of a
restriction that prohibits receiving payloads other than Ethernet,
instead the commit white-listed additional Ethertypes, IPv4 and IPv6.

This patch removes this restriction, making it possible to receive any
Ethertype as a payload, if the IFLA_GENEVE_INNER_PROTO_INHERIT flag is
set.

The restriction was set in place back in commit 0b5e8b8eeae4
("net: Add Geneve tunneling protocol driver"), which implemented a
protocol layer driver for Geneve to be used with Open vSwitch. The
relevant discussion about introducing the Ethertype white-list can be
found here:
https://lore.kernel.org/netdev/CAEP_g=_1q3ACX5NTHxLDnysL+dTMUVzdLpgw1apLKEdDSWPztw@mail.gmail.com/

<quote>
>> +       if (unlikely(geneveh->proto_type != htons(ETH_P_TEB)))
>
> Why? I thought the point of geneve carrying protocol field was to
> allow protocols other than Ethernet... is this temporary maybe?

Yes, it is temporary. Currently OVS only handles Ethernet packets but
this restriction can be lifted once we have a consumer that is capable
of handling other protocols.
</quote>

This white-list was then ported to a generic Geneve netdevice in commit
371bd1061d29 ("geneve: Consolidate Geneve functionality in single
module."). Preserving the Ethertype white-list at this point made sense,
as the Geneve device could send out only Ethernet payloads anyways.

However, now that the Geneve netdevice supports encapsulating other
payloads with IFLA_GENEVE_INNER_PROTO_INHERIT and we have a consumer
capable of other protocols, it seems appropriate to lift the restriction
and allow any Geneve payload to be received.

Signed-off-by: Josef Miegl <josef@miegl.cz>
---
 drivers/net/geneve.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 89ff7f8e8c7e..32684e94eb4f 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -365,13 +365,6 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(geneveh->ver != GENEVE_VER))
 		goto drop;
 
-	inner_proto = geneveh->proto_type;
-
-	if (unlikely((inner_proto != htons(ETH_P_TEB) &&
-		      inner_proto != htons(ETH_P_IP) &&
-		      inner_proto != htons(ETH_P_IPV6))))
-		goto drop;
-
 	gs = rcu_dereference_sk_user_data(sk);
 	if (!gs)
 		goto drop;
@@ -380,6 +373,8 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	if (!geneve)
 		goto drop;
 
+	inner_proto = geneveh->proto_type;
+
 	if (unlikely((!geneve->cfg.inner_proto_inherit &&
 		      inner_proto != htons(ETH_P_TEB)))) {
 		geneve->dev->stats.rx_dropped++;
-- 
2.37.1

