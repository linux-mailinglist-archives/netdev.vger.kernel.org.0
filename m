Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFC44FA6FC
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 13:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241483AbiDILHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 07:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241473AbiDILHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 07:07:02 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96B523FF17
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 04:04:54 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id dr20so21785923ejc.6
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 04:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=guCQtZJSW+6tAwRjn+xEzfBeefFkGekLuh0Y+O3VkjU=;
        b=bbLtwEAsjB9MTLVpVYrxb3AsIdDdsAXY/PaSdP03vlHL8c/dcfd+Et0gbMMg0K6fR/
         eDjuxvcHs8D/c0Usg9KTbOCYM9jDquU/oVvK/okxHcSF+121z2zgMf1rR0JU6n1cD2U3
         sMSbMW4pQu+USvN+a/xOlLxQR3h+KH3q3Oc4XdI7bEdEq4PRobUoXPDsYMvej1mHljdY
         DxNb8Kfw3DBLUwvrKztbdw2m4qBAauU8M/v1ap3yHlT0ZkZfU0W4scTbVMJregvx3PqO
         tuVR8vRzq0hkxLTBoP7IlBOXp+tuv2ZtAEm+5HlUZSkH1nQORIdvMue809+Qe4wxCQG5
         wQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=guCQtZJSW+6tAwRjn+xEzfBeefFkGekLuh0Y+O3VkjU=;
        b=hkh4mTQVf0z97MszI+st0l/zDC81a7AHwl9b+7XcN3qm5f4MNdGx41PgRBpJcLzdBS
         PKn0PC60Pvdcs+sVTXB3QAHBdFoY+ljRFwWnK969ltxRW2dfwBakC//sXvURBuZGaGeA
         SP9XB+4Nx9j2HDhpu7WTRJjK1TSH/jQ7iRPCIue3+CZ/gWEZVte9fc7n6LVaaU6XVzNO
         3cwG0NPbJ+lUaEObmAlq9K0K9gJdpf9m9T+IkeCjTL5L/3mvBw27WVra1EN350rEz8o1
         /zARxWJtFuDJm7OInGXD3/qoqXrLFe8Zw9/ob4urySILIG2P/FwI3PrN4YsRIZMWcS/f
         Olgw==
X-Gm-Message-State: AOAM531W/KQcZBfehpIZqP0Z2sKwjyKnZGQLMomo958LeWP1rZK97oYh
        9EJtLatxf8b+ihLprjaK1b7FfXi6Gp5vLTc1QJY=
X-Google-Smtp-Source: ABdhPJxTsykKKSk5FioE0+8GII9stuEihStRh+ExC+z5gJiPkOO8jGnT8FIQsbsGcvIlfrklLNqPzQ==
X-Received: by 2002:a17:907:9868:b0:6e8:7ae3:7f42 with SMTP id ko8-20020a170907986800b006e87ae37f42mr266476ejc.224.1649502293056;
        Sat, 09 Apr 2022 04:04:53 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id r11-20020a1709064d0b00b006e87938318dsm179574eju.39.2022.04.09.04.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 04:04:52 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next 4/6] net: bridge: fdb: add support for flush filtering based on ndm flags and state
Date:   Sat,  9 Apr 2022 13:58:55 +0300
Message-Id: <20220409105857.803667-5-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220409105857.803667-1-razor@blackwall.org>
References: <20220409105857.803667-1-razor@blackwall.org>
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

Add support for fdb flush filtering based on ndm flags and state. The
new attributes allow users to specify a mask and value which are mapped
to bridge-specific flags. NTF_USE is used to represent added_by_user
flag since it sets it on fdb add and we don't have a 1:1 mapping for it.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/if_bridge.h |  4 +++
 net/bridge/br_fdb.c            | 55 ++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 2f3799cf14b2..4638d7e39f2a 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -815,6 +815,10 @@ enum {
 /* embedded in BRIDGE_FLUSH_FDB */
 enum {
 	FDB_FLUSH_UNSPEC,
+	FDB_FLUSH_NDM_STATE,
+	FDB_FLUSH_NDM_STATE_MASK,
+	FDB_FLUSH_NDM_FLAGS,
+	FDB_FLUSH_NDM_FLAGS_MASK,
 	__FDB_FLUSH_MAX
 };
 #define FDB_FLUSH_MAX (__FDB_FLUSH_MAX - 1)
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 62f694a739e1..340a2ace1d5e 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -594,8 +594,40 @@ void br_fdb_flush(struct net_bridge *br,
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
+static unsigned long __ndm_flags_to_fdb_flags(u16 ndm_flags)
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
 static const struct nla_policy br_fdb_flush_policy[FDB_FLUSH_MAX + 1] = {
 	[FDB_FLUSH_UNSPEC]	= { .type = NLA_REJECT },
+	[FDB_FLUSH_NDM_STATE]	= { .type = NLA_U16 },
+	[FDB_FLUSH_NDM_FLAGS]	= { .type = NLA_U16 },
+	[FDB_FLUSH_NDM_STATE_MASK]	= { .type = NLA_U16 },
+	[FDB_FLUSH_NDM_FLAGS_MASK]	= { .type = NLA_U16 },
 };
 
 int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
@@ -610,6 +642,29 @@ int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
 	if (err)
 		return err;
 
+	if (fdb_flush_tb[FDB_FLUSH_NDM_STATE]) {
+		u16 ndm_state = nla_get_u16(fdb_flush_tb[FDB_FLUSH_NDM_STATE]);
+
+		desc.flags |= __ndm_state_to_fdb_flags(ndm_state);
+	}
+	if (fdb_flush_tb[FDB_FLUSH_NDM_STATE_MASK]) {
+		u16 ndm_state_mask;
+
+		ndm_state_mask = nla_get_u16(fdb_flush_tb[FDB_FLUSH_NDM_STATE_MASK]);
+		desc.flags_mask |= __ndm_state_to_fdb_flags(ndm_state_mask);
+	}
+	if (fdb_flush_tb[FDB_FLUSH_NDM_FLAGS]) {
+		u16 ndm_flags = nla_get_u16(fdb_flush_tb[FDB_FLUSH_NDM_FLAGS]);
+
+		desc.flags |= __ndm_flags_to_fdb_flags(ndm_flags);
+	}
+	if (fdb_flush_tb[FDB_FLUSH_NDM_FLAGS_MASK]) {
+		u16 ndm_flags_mask;
+
+		ndm_flags_mask = nla_get_u16(fdb_flush_tb[FDB_FLUSH_NDM_FLAGS_MASK]);
+		desc.flags_mask |= __ndm_flags_to_fdb_flags(ndm_flags_mask);
+	}
+
 	br_debug(br, "flushing port ifindex: %d vlan id: %u flags: 0x%lx flags mask: 0x%lx\n",
 		 desc.port_ifindex, desc.vlan_id, desc.flags, desc.flags_mask);
 
-- 
2.35.1

