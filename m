Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3900C3E7C45
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243193AbhHJPam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243048AbhHJPaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 11:30:14 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87C3C0613C1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:50 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so2809306wmb.5
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tHSawrgOiEuXROfhF3zdyYRzBieRlUTJnWC8qhgvvXw=;
        b=OATSxsmKymBmFY3WiGGanJCibDQGLlRD+EHLMrax2m/J6No9cR+562Mg5FEV5yQDoo
         0kkTGa+F5KB+egG3DBjgdI0yAdnrCM6zgtchzlgebrQyacY9n4Z5k69ZMb/CKeCyvPmb
         fJsEheJTxeUFgjBh6x5O7l8Z90jCru+VCPHBGGR4BoBs/jkEruvCAj3r9C8yErwYYH4I
         kUzgRuctGR9bQVlkX6bAP0bDkLxhoD3eSVxUxfeiCXS06x8mkBbe7s9P83d2+Zs9jHHp
         mXE33DoP23pCLzBccFVSEHB90TLBugZneZApw+FbINaCkKh6V4AZWuGMVlrastDv79XB
         rjQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tHSawrgOiEuXROfhF3zdyYRzBieRlUTJnWC8qhgvvXw=;
        b=kobd7o38MPhOeIyTZ2e//XvFaYRL8OyEqt7PNE3rOdD9svsqAssZZig9tbD9zD21nT
         AoIyq9N8Fa/ghj3HkLC682RJ4XAmFwWyvqpaYnmiFeg6T7bWKRb1kBj3q8mYPBT4503B
         Naz9gxZ8TdeTf2tiGiSBK+fOeCix7+XGsUOZZFIjGMsuBvU4GlWpxlL8qgMSYFQAwNsZ
         8jurpLQnuhV3xZufkFttMDF8zNEIj3c4ZRC5KOb7Lq0Yl+lsVfftaa+LiEWlg9BVwhED
         GKlxvdVTEuEK1If+T0jj6lr1RW9Oade1hxRvQI+VzuzjEBxrViCsm16s4qAg3RZcIm3Q
         D/Sw==
X-Gm-Message-State: AOAM531gRq3xFmLqbh8G4V1M96TVng36SFOw5UAtWkKxArRYWc9YrXlD
        TYlEumjb5p6Ujc3q0gpOMoMSSldKHMig7Tw+
X-Google-Smtp-Source: ABdhPJx6cClEKdZ8lCIjzJB0gvdThahsU/rmB6ZvL3qbwfGZjDYEMn4IfobEcCS6LUxTQVlrYi3TIA==
X-Received: by 2002:a1c:cc05:: with SMTP id h5mr5375418wmb.5.1628609389194;
        Tue, 10 Aug 2021 08:29:49 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f15sm22848219wrp.12.2021.08.10.08.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 08:29:48 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 04/15] net: bridge: vlan: add support for mcast last member interval global option
Date:   Tue, 10 Aug 2021 18:29:22 +0300
Message-Id: <20210810152933.178325-5-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810152933.178325-1-razor@blackwall.org>
References: <20210810152933.178325-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support to change and retrieve global vlan multicast last member
interval option.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  2 ++
 net/bridge/br_private.h        |  2 ++
 net/bridge/br_vlan_options.c   | 15 +++++++++++++++
 3 files changed, 19 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 62d30153e343..c19537d36900 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -553,6 +553,8 @@ enum {
 	BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION,
 	BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT,
 	BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT,
+	BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL,
+	BRIDGE_VLANDB_GOPTS_PAD,
 	__BRIDGE_VLANDB_GOPTS_MAX
 };
 #define BRIDGE_VLANDB_GOPTS_MAX (__BRIDGE_VLANDB_GOPTS_MAX - 1)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 560c57dd33db..e310aff25772 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1191,6 +1191,8 @@ br_multicast_ctx_options_equal(const struct net_bridge_mcast *brmctx1,
 	       brmctx2->multicast_last_member_count &&
 	       brmctx1->multicast_startup_query_count ==
 	       brmctx2->multicast_startup_query_count &&
+	       brmctx1->multicast_last_member_interval ==
+	       brmctx2->multicast_last_member_interval &&
 #if IS_ENABLED(CONFIG_IPV6)
 	       brmctx1->multicast_mld_version ==
 	       brmctx2->multicast_mld_version &&
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 81a0988b97c1..26f242acef75 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -272,6 +272,7 @@ bool br_vlan_global_opts_can_enter_range(const struct net_bridge_vlan *v_curr,
 bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 			      const struct net_bridge_vlan *v_opts)
 {
+	u64 clockval __maybe_unused;
 	struct nlattr *nest;
 
 	nest = nla_nest_start(skb, BRIDGE_VLANDB_GLOBAL_OPTIONS);
@@ -296,6 +297,11 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 			v_opts->br_mcast_ctx.multicast_startup_query_count))
 		goto out_err;
 
+	clockval = jiffies_to_clock_t(v_opts->br_mcast_ctx.multicast_last_member_interval);
+	if (nla_put_u64_64bit(skb, BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL,
+			      clockval, BRIDGE_VLANDB_GOPTS_PAD))
+		goto out_err;
+
 #if IS_ENABLED(CONFIG_IPV6)
 	if (nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION,
 		       v_opts->br_mcast_ctx.multicast_mld_version))
@@ -323,6 +329,7 @@ static size_t rtnl_vlan_global_opts_nlmsg_size(void)
 		+ nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION */
 		+ nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT */
 		+ nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT */
+		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL */
 #endif
 		+ nla_total_size(sizeof(u16)); /* BRIDGE_VLANDB_GOPTS_RANGE */
 }
@@ -411,6 +418,13 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 		v->br_mcast_ctx.multicast_startup_query_count = cnt;
 		*changed = true;
 	}
+	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL]) {
+		u64 val;
+
+		val = nla_get_u64(tb[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL]);
+		v->br_mcast_ctx.multicast_last_member_interval = clock_t_to_jiffies(val);
+		*changed = true;
+	}
 #if IS_ENABLED(CONFIG_IPV6)
 	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]) {
 		u8 ver;
@@ -435,6 +449,7 @@ static const struct nla_policy br_vlan_db_gpol[BRIDGE_VLANDB_GOPTS_MAX + 1] = {
 	[BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT]	= { .type = NLA_U32 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT]	= { .type = NLA_U32 },
+	[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL]	= { .type = NLA_U64 },
 };
 
 int br_vlan_rtm_process_global_options(struct net_device *dev,
-- 
2.31.1

