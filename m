Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3433E7C40
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 17:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243123AbhHJPa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 11:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243031AbhHJPaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 11:30:11 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AF1C061798
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:49 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id b13so26884651wrs.3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 08:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x2ddN55QW8ss1GIleq39Orvx1idPr5wWLIOP8DxelRQ=;
        b=eZMyxB9VVve1mnWXRYqd3nY69gpXjy2E4D72oDNfv8iUmcTuWFAwnDHOUOxTeVDKw9
         pNdBWGf8RHzGX8a34oYo1tGXx9NPI2ZdVe5vCsYDQLHndYR0c1JM/J6vRp6ooKpl1V/z
         9nWfJLiduWS6jI2KgyQhDxI9J5N4ytt/GmDBLiZqwD+W4T8X9ddOmhn4QJZdcupFuwjF
         saQah3SPa5+AQZWKeyadXKYpz0x8SjtrhTm955Cc4bYvQabDjXQR+Fu8/0tg8GUjT5K0
         LNKj8BNpNHQ6gSgTqhQT9AQGqeQeaReihYiVbVCIgdQddaf8UnKcIK73BS6rIDYow02K
         OVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x2ddN55QW8ss1GIleq39Orvx1idPr5wWLIOP8DxelRQ=;
        b=Wq9axlXhM/WrbJXmM/hiETXe31b+4oZ49VrHAvkT/E0TXGFAXako+6D6MnbRAOMVD7
         ihosMywQhA4PPA5LCRHS3OhBJDqiUWxDDJBJIA+w2P6ku06tsKz5bD7KQgdop108Lh1a
         8WIm/7WW/f94jMckRnxX7666VciMa4VZRXAuvtKKJUiVKPLAzCbHCffioA8Pa9JmAUAM
         QR8esmwfjIR50eKUT+7DGmUyJjdWOboBVCHvg0op3dPL5hkdhnL4gHk5WqVzoblGlJj2
         mbbhIWtx/mkCvZnWj58fdEKWxXLTfQDGkEquAE7Z4xCQCF6f5rJXEt4iYqIaGFUIE3I7
         MO0A==
X-Gm-Message-State: AOAM533nCudpKqs1AbVX5ATFXs+FaBLRdrkBPG8Up8j7jYp680DBg3U2
        R7T/v6T8qvC4VVyZiAdYI9hZ2Ppzd066Gw3F
X-Google-Smtp-Source: ABdhPJzfYycbf9Qc8Dlej1cQh88b6a88y5mVJyHi1n8wFD2B2FkXxFxeeXHUEmaiIIV1jcj3rFD5ww==
X-Received: by 2002:a5d:6991:: with SMTP id g17mr32087677wru.253.1628609387323;
        Tue, 10 Aug 2021 08:29:47 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f15sm22848219wrp.12.2021.08.10.08.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 08:29:46 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 02/15] net: bridge: vlan: add support for mcast last member count global option
Date:   Tue, 10 Aug 2021 18:29:20 +0300
Message-Id: <20210810152933.178325-3-razor@blackwall.org>
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
count option.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_private.h        |  2 ++
 net/bridge/br_vlan_options.c   | 13 ++++++++++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 07acfcc0466c..68099c6bc186 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -551,6 +551,7 @@ enum {
 	BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING,
 	BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION,
 	BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION,
+	BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT,
 	__BRIDGE_VLANDB_GOPTS_MAX
 };
 #define BRIDGE_VLANDB_GOPTS_MAX (__BRIDGE_VLANDB_GOPTS_MAX - 1)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 1cc00d2f9156..ca88609c51b7 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1187,6 +1187,8 @@ br_multicast_ctx_options_equal(const struct net_bridge_mcast *brmctx1,
 {
 	return brmctx1->multicast_igmp_version ==
 	       brmctx2->multicast_igmp_version &&
+	       brmctx1->multicast_last_member_count ==
+	       brmctx2->multicast_last_member_count &&
 #if IS_ENABLED(CONFIG_IPV6)
 	       brmctx1->multicast_mld_version ==
 	       brmctx2->multicast_mld_version &&
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index ac32fb40b7ba..75733b5bc6f4 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -289,7 +289,9 @@ bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
 	if (nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING,
 		       !!(v_opts->priv_flags & BR_VLFLAG_GLOBAL_MCAST_ENABLED)) ||
 	    nla_put_u8(skb, BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION,
-		       v_opts->br_mcast_ctx.multicast_igmp_version))
+		       v_opts->br_mcast_ctx.multicast_igmp_version) ||
+	    nla_put_u32(skb, BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT,
+			v_opts->br_mcast_ctx.multicast_last_member_count))
 		goto out_err;
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -317,6 +319,7 @@ static size_t rtnl_vlan_global_opts_nlmsg_size(void)
 		+ nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING */
 		+ nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION */
 		+ nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION */
+		+ nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT */
 #endif
 		+ nla_total_size(sizeof(u16)); /* BRIDGE_VLANDB_GOPTS_RANGE */
 }
@@ -391,6 +394,13 @@ static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 			return err;
 		*changed = true;
 	}
+	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT]) {
+		u32 cnt;
+
+		cnt = nla_get_u32(tb[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT]);
+		v->br_mcast_ctx.multicast_last_member_count = cnt;
+		*changed = true;
+	}
 #if IS_ENABLED(CONFIG_IPV6)
 	if (tb[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]) {
 		u8 ver;
@@ -413,6 +423,7 @@ static const struct nla_policy br_vlan_db_gpol[BRIDGE_VLANDB_GOPTS_MAX + 1] = {
 	[BRIDGE_VLANDB_GOPTS_MCAST_SNOOPING]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_MLD_VERSION]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_GOPTS_MCAST_IGMP_VERSION]	= { .type = NLA_U8 },
+	[BRIDGE_VLANDB_GOPTS_MCAST_LAST_MEMBER_CNT]	= { .type = NLA_U32 },
 };
 
 int br_vlan_rtm_process_global_options(struct net_device *dev,
-- 
2.31.1

