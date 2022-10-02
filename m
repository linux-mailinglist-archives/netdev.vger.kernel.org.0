Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4F55F21F8
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiJBIRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiJBIR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:17:27 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76353F1FA
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:17:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2691E20539;
        Sun,  2 Oct 2022 10:17:25 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4h68jo0wpwbP; Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 32D8320547;
        Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 22DA680004A;
        Sun,  2 Oct 2022 10:17:23 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 2 Oct 2022 10:17:22 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 2 Oct
 2022 10:17:22 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E86DC31829EF; Sun,  2 Oct 2022 10:17:21 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 03/24] net: allow storing xfrm interface metadata in metadata_dst
Date:   Sun, 2 Oct 2022 10:16:51 +0200
Message-ID: <20221002081712.757515-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221002081712.757515-1-steffen.klassert@secunet.com>
References: <20221002081712.757515-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

XFRM interfaces provide the association of various XFRM transformations
to a netdevice using an 'if_id' identifier common to both the XFRM data
structures (polcies, states) and the interface. The if_id is configured by
the controlling entity (usually the IKE daemon) and can be used by the
administrator to define logical relations between different connections.

For example, different connections can share the if_id identifier so
that they pass through the same interface, . However, currently it is
not possible for connections using a different if_id to use the same
interface while retaining the logical separation between them, without
using additional criteria such as skb marks or different traffic
selectors.

When having a large number of connections, it is useful to have a the
logical separation offered by the if_id identifier but use a single
network interface. Similar to the way collect_md mode is used in IP
tunnels.

This patch attempts to enable different configuration mechanisms - such
as ebpf programs, LWT encapsulations, and TC - to attach metadata
to skbs which would carry the if_id. This way a single xfrm interface in
collect_md mode can demux traffic based on this configuration on tx and
provide this metadata on rx.

The XFRM metadata is somewhat similar to ip tunnel metadata in that it
has an "id", and shares similar configuration entities (bpf, tc, ...),
however, it does not necessarily represent an IP tunnel or use other
ip tunnel information, and also has an optional "link" property which
can be used for affecting underlying routing decisions.

Additional xfrm related criteria may also be added in the future.

Therefore, a new metadata type is introduced, to be used in subsequent
patches in the xfrm interface and configuration entities.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/dst_metadata.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index adab27ba1ecb..e4b059908cc7 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -9,6 +9,7 @@
 enum metadata_type {
 	METADATA_IP_TUNNEL,
 	METADATA_HW_PORT_MUX,
+	METADATA_XFRM,
 };
 
 struct hw_port_info {
@@ -16,12 +17,18 @@ struct hw_port_info {
 	u32 port_id;
 };
 
+struct xfrm_md_info {
+	u32 if_id;
+	int link;
+};
+
 struct metadata_dst {
 	struct dst_entry		dst;
 	enum metadata_type		type;
 	union {
 		struct ip_tunnel_info	tun_info;
 		struct hw_port_info	port_info;
+		struct xfrm_md_info	xfrm_info;
 	} u;
 };
 
@@ -53,6 +60,16 @@ skb_tunnel_info(const struct sk_buff *skb)
 	return NULL;
 }
 
+static inline struct xfrm_md_info *skb_xfrm_md_info(const struct sk_buff *skb)
+{
+	struct metadata_dst *md_dst = skb_metadata_dst(skb);
+
+	if (md_dst && md_dst->type == METADATA_XFRM)
+		return &md_dst->u.xfrm_info;
+
+	return NULL;
+}
+
 static inline bool skb_valid_dst(const struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
@@ -82,6 +99,9 @@ static inline int skb_metadata_dst_cmp(const struct sk_buff *skb_a,
 		return memcmp(&a->u.tun_info, &b->u.tun_info,
 			      sizeof(a->u.tun_info) +
 					 a->u.tun_info.options_len);
+	case METADATA_XFRM:
+		return memcmp(&a->u.xfrm_info, &b->u.xfrm_info,
+			      sizeof(a->u.xfrm_info));
 	default:
 		return 1;
 	}
-- 
2.25.1

