Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05385A160D
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242755AbiHYPqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 11:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242072AbiHYPqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:46:51 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99CCB02BC;
        Thu, 25 Aug 2022 08:46:50 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d16so19858072wrr.3;
        Thu, 25 Aug 2022 08:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=X9MHTgsIwaJa51FzMjWGj/DuVB/5l++H+9kOvAZB8+o=;
        b=QSKJrOTfmOFioZgeywxZnzwhfAVqHuQFXpO+XRuoFkPiTlgWRie4APijgfdWQPeyDd
         e72Q0RmIWKrjypcwRJzO2BRU+zLRTnBoGKl+8RMJGIi4RZq6yTB/O9SAS+vUKdw3RmPc
         3X+IimO4x11gAlXcrHHx2RTd6NKFuHyfN7yY1P2dW08UnODI+eytcww9S899RQjVWyts
         5sk/G2nhlA24+V21jYbsmvGIfVWBOZ3sp3WkIpAwdlVWjz3nHDnSwINlXV9Lob/A++PH
         QFS14LvBRe/LTJ5XArZ/DVXjrOnQEgUtHKJX+lyzI7X6IQKXtpKVvUqfGk1zRCDuzc2w
         Xq3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=X9MHTgsIwaJa51FzMjWGj/DuVB/5l++H+9kOvAZB8+o=;
        b=oSWXr5IzbTQsf06yAJMolFbdGr+ddHdJbME7FytF/IIMUeq1aRrQXAB4M4wTJRS97G
         NFX/z/Xg30biwYWQP0xUXbKj4xgSCUO4M0BQeQ/gAZBO6+3xMnz80cq5N9yIMXx+4/uO
         yTl0si6z2jyIHxXXnfiDQUh15ntnRpP/8fa+eDgU+AWXpA9PB3l2hZoMPi1Omy3e7xV/
         qgJAI9rfI7WbKiXn/jIestLp0RlrsE6vZG6O9Nm51wAFQfq5Nj1KV3rYR00wty5Qacys
         yJYnkf6ISnDq1xVAq0oBl+DEGCOw97XLs/dVpiO3bC1Boeu9COaemS79JH/mdvzqeWaB
         nNAw==
X-Gm-Message-State: ACgBeo33ZUZRB4JtZ3mjbsWoGw6O/izVjWUrIORJVLMTEq3lNwQGu/Na
        7++V6Gu2vS+1v3s7+Tq37iY=
X-Google-Smtp-Source: AA6agR6W5K5tqmVjc58ii564Ny194NNhgDmaKfDtvLKze2DUcrPawrPENZmhS6IZtXPNIb2Bj1sepg==
X-Received: by 2002:a5d:5509:0:b0:225:20ac:37fb with SMTP id b9-20020a5d5509000000b0022520ac37fbmr2835721wrv.38.1661442410256;
        Thu, 25 Aug 2022 08:46:50 -0700 (PDT)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id ay17-20020a05600c1e1100b003a541d893desm5661496wmb.38.2022.08.25.08.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 08:46:49 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com, razor@blackwall.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next,v3 1/3] net: allow storing xfrm interface metadata in metadata_dst
Date:   Thu, 25 Aug 2022 18:46:28 +0300
Message-Id: <20220825154630.2174742-2-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220825154630.2174742-1-eyal.birger@gmail.com>
References: <20220825154630.2174742-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

----

v2: add "link" property as suggested by Nicolas Dichtel
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
2.34.1

