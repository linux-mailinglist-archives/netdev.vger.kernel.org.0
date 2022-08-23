Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A7959EA30
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiHWRtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbiHWRsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:48:38 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9995B08A0;
        Tue, 23 Aug 2022 08:46:15 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n23-20020a7bc5d7000000b003a62f19b453so6753443wmk.3;
        Tue, 23 Aug 2022 08:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=tQE4ydUcPxwbxO0avKpHsCIS7vpKuEprui+Ow5s46Bk=;
        b=pQtzpA+URTbCbEVwWRkaXnaIaFQEMCqVzb77ZpaHZ5y0OBYh7sbB/H9twQEoCdO9f5
         mcNSHak+jPjUTin+aJYAl5p6UGwMprC6QWZd7wGKtBq2UBEXQXU0Q/d6Cu5GSx8KBfXq
         qos/bXKSj3rxu0/2V/5dQqVg3/jGCM+FEkVSEca439Vuhs57S0pk/h/NvfmVWR57ntwL
         BuhMNUbYhvpgwsD4H2lY59HAo9JRU3ytD4hQVLGr8dsdV9RPfohYlxX3ux+7bGrYvc+n
         rVEb7/rhV+JK8EFwn8RuZ1G38PgGEoduXK7yQ0U+T+Z76g4kBv8oSuc2SplROalWWuar
         oLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=tQE4ydUcPxwbxO0avKpHsCIS7vpKuEprui+Ow5s46Bk=;
        b=H1AvWixeH30LcMtOa7vVHqLORqVKYO6i+y7BqAyIiDPYfb05HLpWOkGegju5XXYLl/
         ZmcEb/dkksajpx6kFgv0paWEl+y8xkNxKacqOkegWPHurlIGy5fg7p1UifQ4NS5XVhZg
         aIuM7d77ZG23uXJ5LfK5Bc+9957IELYki5DWtyna38ehw6CuJ2LYZvyYWMi1jeMbhIEl
         BmD541+dgKOV7618NMZE47JHhB4YXAQ0pNuXL43Y6g0SnaoGqM3iu3CFqDMT37qTdaMo
         y5MyWcbojMqnMSEQLoEMqGpYTA6fvMaB9T6CcifKyJFJyjb2bhDTWGcEeCGrbYClE4yZ
         bZKg==
X-Gm-Message-State: ACgBeo3035zcMnSE1CoyCwjnMUjo5FC6MTE72ZUOIbjzpfTSpQ29INSL
        t2eyqHJQXQVww8n8HQAlmcKJvjOkn+46AA==
X-Google-Smtp-Source: AA6agR6dYJzdWDrLD9RAi5VIyK1sGEMhDxiY3xdoWlun3UxW3xK6lKzCzabGa/k4mtlngmdd9X1R8w==
X-Received: by 2002:a05:600c:490:b0:3a5:a6aa:bf2f with SMTP id d16-20020a05600c049000b003a5a6aabf2fmr2618427wme.17.1661269574152;
        Tue, 23 Aug 2022 08:46:14 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id i26-20020a1c541a000000b003a64f684704sm11341211wmb.40.2022.08.23.08.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 08:46:13 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, pablo@netfilter.org,
        contact@proelbtn.com, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, devel@linux-ipsec.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next 1/3] net: allow storing xfrm interface metadata in metadata_dst
Date:   Tue, 23 Aug 2022 18:45:55 +0300
Message-Id: <20220823154557.1400380-2-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220823154557.1400380-1-eyal.birger@gmail.com>
References: <20220823154557.1400380-1-eyal.birger@gmail.com>
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
however, it does not use other ip tunnel information, and may have
additional xfrm related criteria added to it in the future, and it also
does not necessarily represent a tunnel as XFRM interfaces support other
modes of operation.

Therefore, a new metadata type is introduced, to be used in subsequent
patches in the xfrm interface and configuration entities.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 include/net/dst_metadata.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
index adab27ba1ecb..7e13210b868f 100644
--- a/include/net/dst_metadata.h
+++ b/include/net/dst_metadata.h
@@ -9,6 +9,7 @@
 enum metadata_type {
 	METADATA_IP_TUNNEL,
 	METADATA_HW_PORT_MUX,
+	METADATA_XFRM,
 };
 
 struct hw_port_info {
@@ -16,12 +17,17 @@ struct hw_port_info {
 	u32 port_id;
 };
 
+struct xfrm_md_info {
+	u32 if_id;
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
 
@@ -53,6 +59,16 @@ skb_tunnel_info(const struct sk_buff *skb)
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
@@ -82,6 +98,9 @@ static inline int skb_metadata_dst_cmp(const struct sk_buff *skb_a,
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

