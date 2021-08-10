Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7133E7C44
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243181AbhHJPal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243068AbhHJPaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 11:30:14 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A75C06179A
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:51 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id k29so14056040wrd.7
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UO54odsSP3VjArE2SbHfOg7evttW8AGYkv9ZXQftWqQ=;
        b=JgKsVbIsJFRGQlV4IZ73J/QXgxqfoqi4AC466q/RpxCxk86xV5QRqugie/GONRzM72
         e1zsZTuBn1d/+5/kLvuC6uDwkQ5+9UhbtONCppOMY5yeRZPrn57PTrrbzYZO08qA3Vc7
         LS5pdXEkEiiOEZoUfsRN0A69ASlN1ttH+k6jAJ/tzRvk1m/aaMZB30l5XN87cAoId1Tb
         5IXffWDcK1ipMzCh0ajeO+A/NSqr9njXr2tSDecD6/qQ1Nn1GuKDiM6KYNtYiUbGvZHb
         CcQVi31PYE/rIenXQ8+e9/zJZGPDF5cfu3y0ldvGabkBtupSFBRH5ZqzOcwCzTZP3Xn4
         9tig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UO54odsSP3VjArE2SbHfOg7evttW8AGYkv9ZXQftWqQ=;
        b=paJfUl65UvcT2L5YxA9mz/DW/fVNlCJ9L6nfY1m8heA5COMYjL2kYDQ/XB/Ji6u1xz
         B0FCCAWFlnhJv9FmYC3TSiJ7YvqptAj7GeR6O8OOB6wCeS2p7qVr9K5c+/Irhq8xWYIi
         38Uvt874vYZNNiVeZa72/tJFrfmPeUCYipOanKOCOdkiboqgppE7rvbHKCVz1H0zv4Ng
         rnegReDtdhxbzDyhtIMIMprzhWsOvNlSezpyHkTsK3XXqjV9/Q9MQsZM9bWumzuOLsZO
         Hh2EutlVB9ZZul4adoQMsvUDuqeC3GXM0nvrfxyFwlQgQeEEEn20XDFHTLNIJM6q4RB7
         M5Hw==
X-Gm-Message-State: AOAM5335Q/BbJGJTJblwTfB/WojFCi+BZM2USZL+58ORNtisZvHoUpSe
        MAP6FKVYI4LopQRgMM6QFFQSw9x5R9BNtXum
X-Google-Smtp-Source: ABdhPJx2nSdwWrbtvoVmQTkliH6Bf3gaRseAiGaGzvS6X06j5PVEEY8PHfHZUPmQSOS70PXSpS6xcQ==
X-Received: by 2002:a5d:5382:: with SMTP id d2mr4419978wrv.352.1628609390140;
        Tue, 10 Aug 2021 08:29:50 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f15sm22848219wrp.12.2021.08.10.08.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 08:29:49 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 05/15] net: bridge: vlan: add support for mcast membership interval global option
Date:   Tue, 10 Aug 2021 18:29:23 +0300
Message-Id: <20210810152933.178325-6-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810152933.178325-1-razor@blackwall.org>
References: <20210810152933.178325-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support to change and retrieve global vlan multicast membership
interval option.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_private.h        |  2 ++
 net/bridge/br_vlan_options.c   | 13 +++++++++++++
 3 files changed, 16 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index c19537d36900..fd62c5a3cffe 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -555,6 +555,7 @@ enum {
 	BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT,
 	BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL,
 	BRIDGE_VLANDB_GOPTS_PAD,
+	BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL,
 	__BRIDGE_VLANDB_GOPTS_MAX
 };
 #define BRIDGE_VLANDB_GOPTS_MAX (__BRIDGE_VLANDB_GOPTS_MAX - 1)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e310aff25772..96c080cf5bc3 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1193,6 +1193,8 @@ br_multicast_ctx_options_equal(const struct net_bridge_mcast *brmctx1,
 	       brmctx2->multicast_startup_query_count &&
 	       brmctx1->multicast_last_member_interval ==
 	       brmctx2->multicast_last_member_interval &&
+	       brmctx1->multicast_membership_interval ==
+	       brmctx2->multicast_membership_interval &&
 #if IS_ENABLED(CONFIG_IPV6)
 	       brmctx1->multicast_mld_version ==
 	       brmctx2->multicast_mld_version &&
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index 26f242acef75..9d695a63732c 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -301,6 +301,10 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 	if (nla_put_u64_64bit(skb, BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL,
 			      clockval, BRIDGE_VLANDB_GOPTS_PAD))
 		goto out_err;
+	clockval = jiffies_to_clock_t(v_opts->br_mcast_ctx.multicast_membership_interval);
+	if (nla_put_u64_64bit(skb, BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL,
+			      clockval, BRIDGE_VLANDB_GOPTS_PAD))
+		goto out_err;
 
 #if IS_ENABLED(CONFIG_IPV6)
 	if (nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION,
@@ -330,6 +334,7 @@ static size_t rtnl_vlan_global_opts_nlmsg_size(void)
 		+ nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT */
 		+ nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT */
 		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL */
+		+ nla_total_size(sizeof(u64)) /* BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL */
 #endif
 		+ nla_total_size(sizeof(u16)); /* BRIDGE_VLANDB_GOPTS_RANGE */
 }
@@ -425,6 +430,13 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 		v->br_mcast_ctx.multicast_last_member_interval = clock_t_to_jiffies(val);
 		*changed = true;
 	}
+	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL]) {
+		u64 val;
+
+		val = nla_get_u64(tb[BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL]);
+		v->br_mcast_ctx.multicast_membership_interval = clock_t_to_jiffies(val);
+		*changed = true;
+	}
 #if IS_ENABLED(CONFIG_IPV6)
 	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]) {
 		u8 ver;
@@ -450,6 +462,7 @@ static const struct nla_policy br_vlan_db_gpol[BRIDGE_VLANDB_GOPTS_MAX + 1] = {
 	[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT]	= { .type = NLA_U32 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_STARTUP_QUERY_CNT]	= { .type = NLA_U32 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_INTVL]	= { .type = NLA_U64 },
+	[BRIDGE_VLANDB_GOPTS_MCAST_MEMBERSHIP_INTVL]	= { .type = NLA_U64 },
 };
 
 int br_vlan_rtm_process_global_options(struct net_device *dev,
-- 
2.31.1

