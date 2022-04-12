Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFF74FE2A0
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355577AbiDLN33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356766AbiDLN2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:28:09 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB68EC22
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:17 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id c64so10176293edf.11
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 06:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5T4/8pEJcOoDDZCRqw+G8YMOs1f4+RCS55Hho9AS8Rc=;
        b=I98pH8/t8476UOYzFQIxzsDoJrWra2RDofkQdd+LhyMO0yps6t0EDsKGBCpr01qgnm
         Ljxw3eYLGqjZBYH30XNAwj6wvAzS0qb8bgIB4Wqhwv20Cx9piWWUDTG4fME4Ap5v1Clt
         d/Os50fL33yVOwMh5jtq9e4B7rOt1R8MZr1wYUkyyW1HOyZWtJ/zg7r/Vtzlujvw+o1k
         ar9QCz/wNuBQ56IUfvCfQz4WR0l9JnpumiWfmA3GV5q1wPaPHvn+HYzF24Jk5lBO8sHX
         BUX7lakKErwTi3qfN3AqYsqa5G0gVFlB0WCZfB7RXWMkLvURx94nQq5TyR9ZYp8UgYNX
         brJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5T4/8pEJcOoDDZCRqw+G8YMOs1f4+RCS55Hho9AS8Rc=;
        b=GYevtwJnkSMUf4vTPnDGa/d3wQkL0TafD4/0l1X+RpC6/9/Dgx+5naayPhXblVy7Wq
         tVBp0l3o3ygJnnIxMGR7Kl1uRY04SqHap5deJnzrmBWTez3Y+mG4gF7+UKqC2CbGn7mz
         Cnyf3+VfsbPBlHxq75s0K3t7mLfo2Mic4fN60wfHcPYiduyT2ppLM8gdJA7u5MOKYVt/
         h+k+tJyr/4THADu8yPFEf53XRgVILfTySR/QhkN6zVge83xFtKf/6uGfqJQgANNLmvwx
         ZzPXp2tRsR6g4m1yUFgZ+SIMVpgw+obrEgSX34ccyyA0mdClAjFq8B8HVfrgxQP6MNsB
         HfyA==
X-Gm-Message-State: AOAM533dRXLV+bUfsC3FA1mVtYekESDMNgQZA2t65fvmETXes8FALQuZ
        VG/Uvtmb3UXL7EbzGQMURwazIpLOYR1yam2x
X-Google-Smtp-Source: ABdhPJw90+TRwJUG0bpnueawVz7O4LRFJtiM7MRRy/Ex0StenQHnAtoT8zYFqIKgpfyy8lcBiZ33ZQ==
X-Received: by 2002:aa7:c489:0:b0:41d:78a0:5b32 with SMTP id m9-20020aa7c489000000b0041d78a05b32mr12478557edq.305.1649769796183;
        Tue, 12 Apr 2022 06:23:16 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z16-20020a17090665d000b006e8789e8cedsm3771301ejn.204.2022.04.12.06.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 06:23:15 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v3 7/8] net: bridge: fdb: add support for flush filtering based on ndm flags and state
Date:   Tue, 12 Apr 2022 16:22:44 +0300
Message-Id: <20220412132245.2148794-8-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412132245.2148794-1-razor@blackwall.org>
References: <20220412132245.2148794-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for fdb flush filtering based on ndm flags and state. NDM
state and flags are mapped to bridge-specific flags and matched
according to the specified masks. NTF_USE is used to represent
added_by_user flag since it sets it on fdb add and we don't have a 1:1
mapping for it. Only allowed bits can be set, NTF_USE and NTF_MASTER are
ignored.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
v2: ignore NTF_USE/NTF_MASTER and reject unknown flags
v3: NDFA -> NDA attributes

 net/bridge/br_fdb.c     | 58 ++++++++++++++++++++++++++++++++++++++---
 net/bridge/br_private.h |  5 ++++
 2 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index f1deac42bc0d..bbb00a75ef0a 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -594,13 +594,40 @@ void __br_fdb_flush(struct net_bridge *br,
 	rcu_read_unlock();
 }
 
+static unsigned long __ndm_state_to_fdb_flags(u16 ndm_state)
+{
+	unsigned long flags = 0;
+
+	if (ndm_state & NUD_PERMANENT)
+		__set_bit(BR_FDB_LOCAL, &flags);
+	if (ndm_state & NUD_NOARP)
+		__set_bit(BR_FDB_STATIC, &flags);
+
+	return flags;
+}
+
+static unsigned long __ndm_flags_to_fdb_flags(u8 ndm_flags)
+{
+	unsigned long flags = 0;
+
+	if (ndm_flags & NTF_USE)
+		__set_bit(BR_FDB_ADDED_BY_USER, &flags);
+	if (ndm_flags & NTF_EXT_LEARNED)
+		__set_bit(BR_FDB_ADDED_BY_EXT_LEARN, &flags);
+	if (ndm_flags & NTF_OFFLOADED)
+		__set_bit(BR_FDB_OFFLOADED, &flags);
+	if (ndm_flags & NTF_STICKY)
+		__set_bit(BR_FDB_STICKY, &flags);
+
+	return flags;
+}
+
 int br_fdb_delete_bulk(struct ndmsg *ndm, struct nlattr *tb[],
 		       struct net_device *dev, u16 vid,
 		       struct netlink_ext_ack *extack)
 {
-	struct net_bridge_fdb_flush_desc desc = {
-		.flags_mask = BR_FDB_STATIC
-	};
+	u8 ndm_flags = ndm->ndm_flags & ~FDB_FLUSH_IGNORED_NDM_FLAGS;
+	struct net_bridge_fdb_flush_desc desc = {};
 	struct net_bridge *br;
 
 	if (netif_is_bridge_master(dev)) {
@@ -615,6 +642,31 @@ int br_fdb_delete_bulk(struct ndmsg *ndm, struct nlattr *tb[],
 		br = p->br;
 	}
 
+	if (ndm_flags & ~FDB_FLUSH_ALLOWED_NDM_FLAGS) {
+		NL_SET_ERR_MSG(extack, "Unsupported fdb flush ndm flag bits set");
+		return -EINVAL;
+	}
+	if (ndm->ndm_state & ~FDB_FLUSH_ALLOWED_NDM_STATES) {
+		NL_SET_ERR_MSG(extack, "Unsupported fdb flush ndm state bits set");
+		return -EINVAL;
+	}
+
+	desc.flags |= __ndm_state_to_fdb_flags(ndm->ndm_state);
+	desc.flags |= __ndm_flags_to_fdb_flags(ndm_flags);
+	if (tb[NDA_NDM_STATE_MASK]) {
+		u16 ndm_state_mask = nla_get_u16(tb[NDA_NDM_STATE_MASK]);
+
+		desc.flags_mask |= __ndm_state_to_fdb_flags(ndm_state_mask);
+	}
+	if (tb[NDA_NDM_FLAGS_MASK]) {
+		u8 ndm_flags_mask = nla_get_u8(tb[NDA_NDM_FLAGS_MASK]);
+
+		desc.flags_mask |= __ndm_flags_to_fdb_flags(ndm_flags_mask);
+	}
+
+	br_debug(br, "flushing port ifindex: %d vlan id: %u flags: 0x%lx flags mask: 0x%lx\n",
+		 desc.port_ifindex, desc.vlan_id, desc.flags, desc.flags_mask);
+
 	__br_fdb_flush(br, &desc);
 
 	return 0;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index dd186ac29737..72b934d1edce 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -762,6 +762,11 @@ static inline void br_netpoll_disable(struct net_bridge_port *p)
 #endif
 
 /* br_fdb.c */
+#define FDB_FLUSH_IGNORED_NDM_FLAGS (NTF_MASTER | NTF_SELF)
+#define FDB_FLUSH_ALLOWED_NDM_STATES (NUD_PERMANENT | NUD_NOARP)
+#define FDB_FLUSH_ALLOWED_NDM_FLAGS (NTF_USE | NTF_EXT_LEARNED | \
+				     NTF_STICKY | NTF_OFFLOADED)
+
 int br_fdb_init(void);
 void br_fdb_fini(void);
 int br_fdb_hash_init(struct net_bridge *br);
-- 
2.35.1

