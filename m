Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794503E7C4B
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240233AbhHJPax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243081AbhHJPaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 11:30:18 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C783EC0613C1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:55 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id f5so11058237wrm.13
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zy+5j+qnJPP2DcQ6ppQltCiNmcX/igd0j9tkuJSlWao=;
        b=TNiJBiTYzPvblJXXa6uu/WugVsjzum3kaqyZI6xRSd/PHP95DmvLvf9GDjM7FCRcRE
         K/Y13m7TKFYgy39C8vwhjMw7rRn6QTYvexzAsBLpM1UCtYg3GUfb8CSgqay7Eyglhgpm
         efxC00gAJu/c7uQ5MjAuBnnEd3DHpop7KKxPTlPCosxnXCgv9niVlHJPgAwshn0eoA2d
         SkG3HIUCE9W2nv0RoRgbgNnQlX2tWdDuGK9B7somdJajPN063sPSLAB7ccsOqH+cnLTz
         zFDicoluFQthXNPguiR7t3bx2dIjNf3eQOZIaEzs+a49buY4nEVPM8hcKSdCQ+bXj7cb
         +/ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zy+5j+qnJPP2DcQ6ppQltCiNmcX/igd0j9tkuJSlWao=;
        b=KJtk7/Gl28WCNJeT2DN1pNFtoVuo1YGZC+ht2rtw7N1yQTvXwV2McJiF7NnctdUal/
         P9wwzhHIq75fuFEYq64FY3vCrtr56yg4QimUafyo1cOUOaHUYOhNZF8fXgWd/n3Qfl6J
         QBerNewPhBjeKjRmH/jAhTgIsuSoh4dN+alBYiyV7MRlA/BD2nfL7aSx03crE+n+XbEq
         QiYYz8gE4p7Z0MVfPYOc05Mv5OpLghKkgOcCQZKQA2ofi04tk0sqSnHtdRfFhyl5jU5M
         0kXLEr/pbrq6toPw9LtU9brNJSVkQrMbYC0SOTdIWTNBCqRclAeDAw/orERVmN2+KdYo
         IWwA==
X-Gm-Message-State: AOAM532piOyF/Lzcu1H1rWvBue5PrHvFCatJ5VNH/nqW5Z06K/7w6Qlj
        QycPcKQ/ew4dS9/Rph+w+Pl+QToeZokG/HCm
X-Google-Smtp-Source: ABdhPJxC4Q3tJQJEiIQbnbdPbwkIpqoXknmGIHhW7+FY6Z9YJY9/fGO6yAqZ63oL9yEKiCXNWnmXNQ==
X-Received: by 2002:a5d:5343:: with SMTP id t3mr19266580wrv.273.1628609394058;
        Tue, 10 Aug 2021 08:29:54 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f15sm22848219wrp.12.2021.08.10.08.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 08:29:53 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 09/15] net: bridge: vlan: add support for mcast startup query interval global option
Date:   Tue, 10 Aug 2021 18:29:27 +0300
Message-Id: <20210810152933.178325-10-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810152933.178325-1-razor@blackwall.org>
References: <20210810152933.178325-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support to change and retrieve global vlan multicast startup query
interval option.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_private.h        |  2 ++
 net/bridge/br_vlan_options.c   | 13 +++++++++++++
 3 files changed, 16 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 9a30c4d92626..ea8773cce9e9 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -559,6 +559,7 @@ enum {
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL,
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL,
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL,
+	BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL,
 	__BRIDGE_VLANDB_GOPTS_MAX
 };
 #define BRIDGE_VLANDB_GOPTS_MAX (__BRIDGE_VLANDB_GOPTS_MAX - 1)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index d63520718ae9..4cdd71526145 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1201,6 +1201,8 @@ br_multicast_ctx_options_equal(const struct net_bridge_mcast *brmctx1,
 	       brmctx2->multicast_query_interval &&
 	       brmctx1->multicast_query_response_interval ==
 	       brmctx2->multicast_query_response_interval &&
+	       brmctx1->multicast_startup_query_interval ==
+	       brmctx2->multicast_startup_query_interval &&
 #if IS_ENABLED(CONFIG_IPV6)
 	       brmctx1->multicast_mld_version ==
 	       brmctx2->multicast_mld_version &&
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index cd8320b22a89..7b8dfd138045 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -317,6 +317,10 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 	if (nla_put_u64_64bit(skb, BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL,
 			      clockval, BRIDGE_VLANDB_GOPTS_PAD))
 		goto out_err;
+	clockval = jiffies_to_clock_t(v_opts->br_mcast_ctx.multicast_startup_query_interval);
+	if (nla_put_u64_64bit(skb, BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL,
+			      clockval, BRIDGE_VLANDB_GOPTS_PAD))
+		goto out_err;
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION,
@@ -350,6 +354,7 @@ static size_t rtnl_vlan_global_opts_nlmsg_size(void)
 		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL */
 		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL */
 		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL */
+		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL */
 #endif
 		+ nla_total_size(sizeof(u16)); /* BRIDGE_VLANDB_GOPTS_RANGE */
 }
@@ -473,6 +478,13 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 		v->br_mcast_ctx.multicast_query_response_interval = clock_t_to_jiffies(val);
 		*changed = true;
 	}
+	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL]) {
+		u64 val;
+
+		val = nla_get_u64(tb[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL]);
+		v->br_mcast_ctx.multicast_startup_query_interval = clock_t_to_jiffies(val);
+		*changed = true;
+	}
 #if IS_ENABLED(CONFIG_IPV6)
 	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]) {
 		u8 ver;
@@ -501,6 +513,7 @@ static const struct nla_policy br_vlan_db_gpol[BRIDGE_VLANDB_GOPTS_MAX + 1] = {
 	[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL]	= { .type = NLA_U64 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL]	= { .type = NLA_U64 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL]	= { .type = NLA_U64 },
+	[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_INTVL]	= { .type = NLA_U64 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_RESPONSE_INTVL] = { .type = NLA_U64 },
 };
 
-- 
2.31.1

