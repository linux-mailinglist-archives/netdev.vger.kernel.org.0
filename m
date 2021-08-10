Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CC73E7C49
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243213AbhHJPat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243043AbhHJPaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 11:30:16 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5740C06179B
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:53 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id i4so9383820wru.0
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nO5OawzfV9xH6SjxhEhhOLYCvCdIGW3fhHV+ketAsFg=;
        b=0N9+Pj5Ut+Y4+wTnZFkox6hGU82MINDqXP3Ng5lzrP7kH7m+zGr5he6W6NQtkYTGNj
         ccTd+0UElz5/gJTLcz5vtWA3dwhoCR07ZIrME3O8vieM+OQuW1gpQyAp38mO4u869sBp
         SIIOLc/EVfFTkc3uFamfJvWCoQ4ks+MzNKUoi988vAE7TaZJ8QlBU0MeFzvcKezhi/hP
         4jnx2/UgSmBAeiNtWDc5wScUmIiUGFRe5avveimAaxF8y2IWmyF7mehJvaRfioFZOgEl
         8ojcP0ZjGU7W/ZyMnlTLVYbGWUDD3othq7rNAGgu3k7WzI2+QkyfZVRywWZ/NohQ9BJP
         UGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nO5OawzfV9xH6SjxhEhhOLYCvCdIGW3fhHV+ketAsFg=;
        b=ncARJ6AngTpXKMRju8rsKvzI6f9/rnewyIngl3yv8aJ8ybz8/NS+joJY9lUwg2NfCv
         cxyhqVnrzgdRf+OAHHXf2sh9W17xMm52HqhiijyXELquOO+tdFIA/1eNriVRSrQ8MW8t
         gW+HHmLu1XHxhF3Q/53yzvjpMXDkZsMbnWAHFGqQ5/dpNdc+yd+TmEQdqvOsBrD2P5qw
         r9rnzxmw3zABufxCddP6DLOHb3nrBP38nW5urwwRrINQAPv7SwXD0HuYpkJHgN7GbK+H
         bX9h+8gu3WcyVHg6mk/4JLboMeZpP7mg0hmNqUIiuES05mn2nbmBr8H1dkQZodNcCWDW
         bxvA==
X-Gm-Message-State: AOAM533dQJiLzAAXfvC7TfWnNZ6hSyv6WDN5j39GTJ3ZHBvRMqp1hUe9
        TryJmD2RreDNM6MJWMGElVTcGFQtD4bg83Bc
X-Google-Smtp-Source: ABdhPJyyRlOgNyzYnX3S9q+wtqqeQC1SweBiLZPV66MZwNV25Oz4+drWs8hVIgU72qfjZdAth79FIQ==
X-Received: by 2002:a05:6000:18c8:: with SMTP id w8mr31173308wrq.90.1628609391988;
        Tue, 10 Aug 2021 08:29:51 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f15sm22848219wrp.12.2021.08.10.08.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 08:29:51 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 07/15] net: bridge: vlan: add support for mcast query interval global option
Date:   Tue, 10 Aug 2021 18:29:25 +0300
Message-Id: <20210810152933.178325-8-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810152933.178325-1-razor@blackwall.org>
References: <20210810152933.178325-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support to change and retrieve global vlan multicast query interval
option.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_private.h        |  2 ++
 net/bridge/br_vlan_options.c   | 13 +++++++++++++
 3 files changed, 16 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 517967b90e1a..371f4f93aaa1 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -557,6 +557,7 @@ enum {
 	BRIDGE_VLANDB_GOPTS_PAD,
 	BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL,
 	BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL,
+	BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL,
 	__BRIDGE_VLANDB_GOPTS_MAX
 };
 #define BRIDGE_VLANDB_GOPTS_MAX (__BRIDGE_VLANDB_GOPTS_MAX - 1)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index df60f8ecc11d..e72805d32458 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1197,6 +1197,8 @@ br_multicast_ctx_options_equal(const struct net_bridge_mcast *brmctx1,
 	       brmctx2->multicast_membership_interval &&
 	       brmctx1->multicast_querier_interval ==
 	       brmctx2->multicast_querier_interval &&
+	       brmctx1->multicast_query_interval ==
+	       brmctx2->multicast_query_interval &&
 #if IS_ENABLED(CONFIG_IPV6)
 	       brmctx1->multicast_mld_version ==
 	       brmctx2->multicast_mld_version &&
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 58ed4277cd1b..10ed84336fd7 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -309,6 +309,10 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 	if (nla_put_u64_64bit(skb, BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL,
 			      clockval, BRIDGE_VLANDB_GOPTS_PAD))
 		goto out_err;
+	clockval = jiffies_to_clock_t(v_opts->br_mcast_ctx.multicast_query_interval);
+	if (nla_put_u64_64bit(skb, BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL,
+			      clockval, BRIDGE_VLANDB_GOPTS_PAD))
+		goto out_err;
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION,
@@ -340,6 +344,7 @@ static size_t rtnl_vlan_global_opts_nlmsg_size(void)
 		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL */
 		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL */
 		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_QUERIER_INTVL */
+		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL */
 #endif
 		+ nla_total_size(sizeof(u16)); /* BRIDGE_VLANDB_GOPTS_RANGE */
 }
@@ -449,6 +454,13 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 		v->br_mcast_ctx.multicast_querier_interval = clock_t_to_jiffies(val);
 		*changed = true;
 	}
+	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL]) {
+		u64 val;
+
+		val = nla_get_u64(tb[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL]);
+		v->br_mcast_ctx.multicast_query_interval = clock_t_to_jiffies(val);
+		*changed = true;
+	}
 #if IS_ENABLED(CONFIG_IPV6)
 	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]) {
 		u8 ver;
@@ -470,6 +482,7 @@ static const struct nla_policy br_vlan_db_gpol[BRIDGE_VLANDB_GOPTS_MAX + 1] = {
 	[BRIDGE_VLANDB_GOPTS_RANGE]	= { .type = NLA_U16 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]	= { .type = NLA_U8 },
+	[BRIDGE_VLANDB_GOPTS_MCAST_QUERY_INTVL]	= { .type = NLA_U64 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT]	= { .type = NLA_U32 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT]	= { .type = NLA_U32 },
-- 
2.31.1

