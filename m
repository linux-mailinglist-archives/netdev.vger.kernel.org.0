Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03DA3E7C46
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243144AbhHJPao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243074AbhHJPaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 11:30:16 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC46CC0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:52 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id d131-20020a1c1d890000b02902516717f562so2814194wmd.3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Jpb4hMQMXBG+9lrXYyA9pshH9Cm5F4c6nhvqppjODo=;
        b=sqOXSDJlzug7wtrS9UjmYsmoE4XY6Vy9LYMGnE9g0ZSffoFMTVfnNk8NlYkZgEdD+q
         NDciUuSVwTuwCy0ooW8YPgik6jAvVO6rZyrP6W9sQt52KWNbNrR1cuIQqTXIc1Rny1Ul
         hlFcNRBH/ybJ6ei2ea6Yun869XWQCGa0gdnx1He085n3lx8M5bY9aAAihcrzYtdg1gDy
         c9G5JQxFS33tDIgg//Flidexzy6ic58+33Hfl6HBRJJvEgoY0nyMJFw7eNnAtm/cunA+
         RrwexcDRFlblqZJxtFO6uHlpcixA7o9ASjXZ1Pzb4GHOKtYBQrCy1JTvGDaLArVatci2
         z77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Jpb4hMQMXBG+9lrXYyA9pshH9Cm5F4c6nhvqppjODo=;
        b=e076fEbE54AFa5Ity1dOTf/0NKy/sqNhuTmXzb9vHopg0VFUi4E1Rr9JS6xonT8Wl0
         DQaQ259riUj3o71nl1cpM+CAoB/0dJl7edtlQcbS1FnRd8RDh2Z5yAB0obbQYBGxcC2q
         IaKcqYYD8rcZ38M7A+M91KKiIvgr1Wt8Wn4E2+X5DI7xSXIVdtw3GQN0xvjKJNeJRo9+
         vYOSpV02ZvbAWHTzoSn2JKarhLAE9chS3ZBvrIG51jrA612EmZBE2ZZiG24+51owlkrD
         gqQfYRSQshEBhPjm9wo9RsMwBFvk9qXIHhVT74A5FjuhcEjufoWb2R8hHfFh/cm5zmCI
         qg0g==
X-Gm-Message-State: AOAM531S5GYbOSKP+ExE5Cp+jkmi+9eAOE4TivG4sQsDYM5b4AcG0EZL
        1qJ45mvfw3NU/Sot5kqKXN9OSf93x5Hkj06F
X-Google-Smtp-Source: ABdhPJzrQdpL13Tt18MA20xS5ecNxiSYYqU90VKMMJtbUbhnq+5seUR1g6FKFc3c7SiFVLaT0Ee/4Q==
X-Received: by 2002:a7b:cb02:: with SMTP id u2mr2407038wmj.103.1628609391053;
        Tue, 10 Aug 2021 08:29:51 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f15sm22848219wrp.12.2021.08.10.08.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 08:29:50 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 06/15] net: bridge: vlan: add support for mcast querier interval global option
Date:   Tue, 10 Aug 2021 18:29:24 +0300
Message-Id: <20210810152933.178325-7-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810152933.178325-1-razor@blackwall.org>
References: <20210810152933.178325-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support to change and retrieve global vlan multicast querier interval
option.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_private.h        |  2 ++
 net/bridge/br_vlan_options.c   | 13 +++++++++++++
 3 files changed, 16 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index fd62c5a3cffe..517967b90e1a 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -556,6 +556,7 @@ enum {
 	BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL,
 	BRIDGE_VLANDB_GOPTS_PAD,
 	BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL,
+	BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL,
 	__BRIDGE_VLANDB_GOPTS_MAX
 };
 #define BRIDGE_VLANDB_GOPTS_MAX (__BRIDGE_VLANDB_GOPTS_MAX - 1)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 96c080cf5bc3..df60f8ecc11d 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1195,6 +1195,8 @@ br_multicast_ctx_options_equal(const struct net_bridge_mcast *brmctx1,
 	       brmctx2->multicast_last_member_interval &&
 	       brmctx1->multicast_membership_interval ==
 	       brmctx2->multicast_membership_interval &&
+	       brmctx1->multicast_querier_interval ==
+	       brmctx2->multicast_querier_interval &&
 #if IS_ENABLED(CONFIG_IPV6)
 	       brmctx1->multicast_mld_version ==
 	       brmctx2->multicast_mld_version &&
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 9d695a63732c..58ed4277cd1b 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -305,6 +305,10 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 	if (nla_put_u64_64bit(skb, BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL,
 			      clockval, BRIDGE_VLANDB_GOPTS_PAD))
 		goto out_err;
+	clockval = jiffies_to_clock_t(v_opts->br_mcast_ctx.multicast_querier_interval);
+	if (nla_put_u64_64bit(skb, BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL,
+			      clockval, BRIDGE_VLANDB_GOPTS_PAD))
+		goto out_err;
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION,
@@ -335,6 +339,7 @@ static size_t rtnl_vlan_global_opts_nlmsg_size(void)
 		+ nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT */
 		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL */
 		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL */
+		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL */
 #endif
 		+ nla_total_size(sizeof(u16)); /* BRIDGE_VLANDB_GOPTS_RANGE */
 }
@@ -437,6 +442,13 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 		v->br_mcast_ctx.multicast_membership_interval = clock_t_to_jiffies(val);
 		*changed = true;
 	}
+	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL]) {
+		u64 val;
+
+		val = nla_get_u64(tb[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL]);
+		v->br_mcast_ctx.multicast_querier_interval = clock_t_to_jiffies(val);
+		*changed = true;
+	}
 #if IS_ENABLED(CONFIG_IPV6)
 	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]) {
 		u8 ver;
@@ -463,6 +475,7 @@ static const struct nla_policy br_vlan_db_gpol[BRIDGE_VLANDB_GOPTS_MAX + 1] = {
 	[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT]	= { .type = NLA_U32 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL]	= { .type = NLA_U64 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL]	= { .type = NLA_U64 },
+	[BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL]	= { .type = NLA_U64 },
 };
 
 int br_vlan_rtm_process_global_options(struct net_device *dev,
-- 
2.31.1

