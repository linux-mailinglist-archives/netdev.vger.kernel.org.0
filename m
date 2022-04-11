Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4424FC37A
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 19:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348956AbiDKRdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 13:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348958AbiDKRcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 13:32:21 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AE32E696
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:30:06 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ks6so7713320ejb.1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O/VZLSKKUr9Ihqy6S3wZzx57tDuzGbENOM9GV5qAtjA=;
        b=fFAeWA901r46qOOdPqJ4hjzi3NDTcPdGTCrShzVqlrXGohdJz5OqOhbR53eJj+8/Mz
         jNsj1Ll+69KR3nuryXJWdWkkpKWIrq0tGF98iH4JSZiXpx9yrldzFYvXmWU2LU35kGxI
         2a0zL+wy9JNmACu4OFV0CW+eoeI6F723MISF2PvEnIHToEZ9xwXZtYYRS9/FFpY97Z9d
         L3z1fX9r31aAfIgro65HkUnPXsAkNUU5O+x+VOr+pCw9pmQaThoJ1+usUZFN8fxTEpbw
         DXGDKEZe1rK0SoyB953x362v9H+VCZ7WHPKRd3soJS63WL6Jh7M/9EjYA34boDNsiCU/
         DuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O/VZLSKKUr9Ihqy6S3wZzx57tDuzGbENOM9GV5qAtjA=;
        b=oIe61mVJ5ND2g0UYPohpOMstCKDbOhqmd5HRLfBOusnzw9QJCNnmSTvmCl6vbPI11R
         Fi4UsLg9YcN5mGoMcABtk2RwPGgGRhO3Mleyqmdk4T5fFibB+kjZnn2KPaPzZjQXISeX
         c0SCWOigrwxJREi7PrDPoJMzTFcTvib00n3PhFr+N7B9msTrSz/uC3J5HrSH5vhVgwoz
         SWParoCKc/77nCSFwkFSCLB2l5Zd1v0JkI5Xwfs+gOZVnUI+69bSjvFwxKbV57cN6reZ
         onZFKY98W9KuaubfObzS9uziFiYboMQcxoN65ppYtJuQ66HzC6AWrhv/Y7s2oTwaOO/2
         j2gw==
X-Gm-Message-State: AOAM5330ZxTWb5GPDzQwY22bHem/4BpfVBEQOsunepMt1TWLCC/l1A43
        e2VZ/9g273u1e9rwwkk6KJ7VeLSzsE8qAfOr
X-Google-Smtp-Source: ABdhPJx3nKeCKQpSmaPdqh76RCSsXmqoKXzgCblRjdLmXrHbv2xJUhepqMv+qlK5mBnORk9EyAvm6A==
X-Received: by 2002:a17:906:2c0d:b0:6e8:979c:be8 with SMTP id e13-20020a1709062c0d00b006e8979c0be8mr4246836ejh.239.1649698204541;
        Mon, 11 Apr 2022 10:30:04 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090626c600b006e74ef7f092sm10325084ejc.176.2022.04.11.10.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 10:30:04 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@idosch.org, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v2 8/8] net: bridge: fdb: add support for flush filtering based on ifindex and vlan
Date:   Mon, 11 Apr 2022 20:29:34 +0300
Message-Id: <20220411172934.1813604-9-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411172934.1813604-1-razor@blackwall.org>
References: <20220411172934.1813604-1-razor@blackwall.org>
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

Add support for fdb flush filtering based on destination ifindex and
vlan id. The ifindex must either match a port's device ifindex or the
bridge's. The vlan support is trivial since it's already validated by
rtnl_fdb_flush, we just need to fill it in.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
v2: validate ifindex and fill in vlan id

 net/bridge/br_fdb.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 2cea03cbc55f..b078a656776a 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -622,12 +622,44 @@ static unsigned long __ndm_flags_to_fdb_flags(u8 ndm_flags)
 	return flags;
 }
 
+static int __fdb_flush_validate_ifindex(const struct net_bridge *br,
+					int ifindex,
+					struct netlink_ext_ack *extack)
+{
+	const struct net_device *dev;
+
+	dev = __dev_get_by_index(dev_net(br->dev), ifindex);
+	if (!dev) {
+		NL_SET_ERR_MSG_MOD(extack, "Unknown flush device ifindex");
+		return -ENODEV;
+	}
+	if (!netif_is_bridge_master(dev) && !netif_is_bridge_port(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Flush device is not a bridge or bridge port");
+		return -EINVAL;
+	}
+	if (netif_is_bridge_master(dev) && dev != br->dev) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Flush bridge device does not match target bridge device");
+		return -EINVAL;
+	}
+	if (netif_is_bridge_port(dev)) {
+		struct net_bridge_port *p = br_port_get_rtnl(dev);
+
+		if (p->br != br) {
+			NL_SET_ERR_MSG_MOD(extack, "Port belongs to a different bridge device");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 int br_fdb_flush(struct ndmsg *ndm, struct nlattr *tb[],
 		 struct net_device *dev, u16 vid,
 		 struct netlink_ext_ack *extack)
 {
 	u8 ndm_flags = ndm->ndm_flags & ~FDB_FLUSH_IGNORED_NDM_FLAGS;
-	struct net_bridge_fdb_flush_desc desc = {};
+	struct net_bridge_fdb_flush_desc desc = { .vlan_id = vid };
 	struct net_bridge *br;
 
 	if (netif_is_bridge_master(dev)) {
@@ -663,6 +695,14 @@ int br_fdb_flush(struct ndmsg *ndm, struct nlattr *tb[],
 
 		desc.flags_mask |= __ndm_flags_to_fdb_flags(ndm_flags_mask);
 	}
+	if (tb[NDFA_IFINDEX]) {
+		int err, ifidx = nla_get_s32(tb[NDFA_IFINDEX]);
+
+		err = __fdb_flush_validate_ifindex(br, ifidx, extack);
+		if (err)
+			return err;
+		desc.port_ifindex = ifidx;
+	}
 
 	br_debug(br, "flushing port ifindex: %d vlan id: %u flags: 0x%lx flags mask: 0x%lx\n",
 		 desc.port_ifindex, desc.vlan_id, desc.flags, desc.flags_mask);
-- 
2.35.1

