Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C47A4FA6FD
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 13:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241476AbiDILHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 07:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241482AbiDILHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 07:07:11 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646A8241A10
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 04:04:56 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id w18so12632681edi.13
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 04:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pI4juhDXvvHTh0rGKGfMfLE6PZX77VF+PfLCGPPEVPU=;
        b=7Xj6XrbUXlfjlBFZqVNm3ajjO3GpKvG9FGv29kYvmyM0tZ/j7ilBb7io1qOU53kWbb
         yr4jlrpYDe7dIV7kbQk282i9NwC2uFaWTAwGux3wcAoxVpIUddc1LVr6cnmHxOQjFDg6
         2F+mew77iqtO4+3ht4Rg+43B0GcBiFyMyrPW48qVeHUcd9HilQp0FDei3LEkYybW7O5J
         DvEPuEddTG1Drn3hMrsH005CeJXzgYaJVV2Hj6HDEHi/oWo3/wtq2EXzirUHJY9gXFXg
         +tiwAyrWhoZLoa+lCuh2d4yTc+zkPlGPKWTRSE7hbtm4R2MuL9Wev4RwFd/GpTMEpdgi
         c91A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pI4juhDXvvHTh0rGKGfMfLE6PZX77VF+PfLCGPPEVPU=;
        b=LMGfGZEzwN6xumt5MQQoqCzxEJaUjKVnAYp0gnSwCi6/9TddFKNDgrp8iTqIqwX/Tv
         eeQwXpaF5BGX6lDYCopcA5TUSutWAFy5l6uZkEL6Jv28YbklLkiqxyM6u1s0BC1vbnhm
         GKikCKsVbQ4OLpoKHwZAqnjCxi4jSl9Owd1nbFrJmq6efPgpkOWIqVOCm1n4b86B2dzH
         W2kg86Uwy2kpZaedgqyIh5Tgw6PrBq4bVxudG2HHu1M0YmT2yCychIjOaleasqwICBZT
         yJWOTFIR/P1DUPVzJ9IwbqW2JEQ/qgNRrxNGKNFCY3vCe7LQ8ENQsoQIhLb3T10AlglY
         oong==
X-Gm-Message-State: AOAM533nyrkbeBEIWZi74LZny2dDmkKLO6jslJ477Bgn8NnejJd+VqK3
        ZM/mSRi8P36YOMpYGKPkOzEBxxvsCXiZ244zatQ=
X-Google-Smtp-Source: ABdhPJx4bak1GlJt3DvLQ7SnZM7ZLqBj3nF8XgcBSJrJRibsIUXwPLesQXqb4zLYtnsmq8p0vs8xqg==
X-Received: by 2002:a50:cd19:0:b0:41d:709f:5c57 with SMTP id z25-20020a50cd19000000b0041d709f5c57mr689523edi.227.1649502295159;
        Sat, 09 Apr 2022 04:04:55 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id r11-20020a1709064d0b00b006e87938318dsm179574eju.39.2022.04.09.04.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 04:04:54 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next 6/6] net: bridge: fdb: add support for flush filtering based on vlan id
Date:   Sat,  9 Apr 2022 13:58:57 +0300
Message-Id: <20220409105857.803667-7-razor@blackwall.org>
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

Add support for fdb flush filtering based on vlan id.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/if_bridge.h | 1 +
 net/bridge/br_fdb.c            | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 67ee12586844..7f6730812916 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -820,6 +820,7 @@ enum {
 	FDB_FLUSH_NDM_FLAGS,
 	FDB_FLUSH_NDM_FLAGS_MASK,
 	FDB_FLUSH_PORT_IFINDEX,
+	FDB_FLUSH_VLAN_ID,
 	__FDB_FLUSH_MAX
 };
 #define FDB_FLUSH_MAX (__FDB_FLUSH_MAX - 1)
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 53208adf7474..bc8b5cbde8ed 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -626,6 +626,7 @@ static const struct nla_policy br_fdb_flush_policy[FDB_FLUSH_MAX + 1] = {
 	[FDB_FLUSH_UNSPEC]	= { .type = NLA_REJECT },
 	[FDB_FLUSH_NDM_STATE]	= { .type = NLA_U16 },
 	[FDB_FLUSH_NDM_FLAGS]	= { .type = NLA_U16 },
+	[FDB_FLUSH_VLAN_ID]	= { .type = NLA_U16 },
 	[FDB_FLUSH_NDM_STATE_MASK]	= { .type = NLA_U16 },
 	[FDB_FLUSH_NDM_FLAGS_MASK]	= { .type = NLA_U16 },
 	[FDB_FLUSH_PORT_IFINDEX]	= { .type = NLA_S32 },
@@ -671,6 +672,11 @@ int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
 		port_ifidx = nla_get_u32(fdb_flush_tb[FDB_FLUSH_PORT_IFINDEX]);
 		desc.port_ifindex = port_ifidx;
 	}
+	if (fdb_flush_tb[FDB_FLUSH_VLAN_ID]) {
+		desc.vlan_id = nla_get_u16(fdb_flush_tb[FDB_FLUSH_VLAN_ID]);
+		if (!br_vlan_valid_id(desc.vlan_id, extack))
+			return -EINVAL;
+	}
 
 	br_debug(br, "flushing port ifindex: %d vlan id: %u flags: 0x%lx flags mask: 0x%lx\n",
 		 desc.port_ifindex, desc.vlan_id, desc.flags, desc.flags_mask);
-- 
2.35.1

