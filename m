Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C63D4FA6FA
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 13:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241487AbiDILHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 07:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241475AbiDILHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 07:07:10 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0449024058C
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 04:04:56 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g20so12687003edw.6
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 04:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ruKthvyRBdKBojJ9cI3HF+YHEwKh0vpzBB/A3CTMky8=;
        b=6Lxea4KtEreyzkvQXC0nXxpr8fx0jK/b9OrGY4V/fWEGgtpTyMivpumpy3aP/IakOl
         tqVLSodTNTYTpQ7nOYxeY3DWoUkI9LM4YNnXNIig8zMAbaaZ8LFKcq6lVH4Hg9WbSkwU
         jTRbFngE6hu3Xu3J2kVRxEMKESXUSZW3ey55pOVgGeAsnL8nsATeU2BIyhIJfSJ8A3aO
         Em6+F2H38vxyVEYmwaXQmrYtUnZ1AZrDD/rwvwLZfTCGD2vkgvjKhTrffJLfn4krZwcy
         pCIyS4zrwr7HuYVY2dX1o81fiyK0PS3A//+MMjEsSS4E+eOtJmNuC6vHi9ZM4oQVFR6V
         5cyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ruKthvyRBdKBojJ9cI3HF+YHEwKh0vpzBB/A3CTMky8=;
        b=GNXlNybzbkNa0My/61LFNH1gnQnxRuRHxiSt9BfR7+T2t/Hal+dQ2LBL12N3WErXja
         FuZ6qAseo1EdWMTgfZ4Zr7kpS0IGDVNhqX86COho5pD1BpCoWGemIpqEKKLo8PnhWihX
         fRJ9GFWww1yLWOvhp2qSeMaYhsT2lfzoNNL+rR+jqfc9We8jhg+JiEsSNjxxPaWjUdll
         xc0PLzHb1o08LoOdOtDkGCgMm6EhvHnnNgZabTAOifHOl2bH9zZivR9EypgpziTjfEkS
         Ei9vGpiB70np8Ak76wwJRtJsLxcd0SdJvFXTxo4cD5yBZbQ7gFJhtaRKtUEffuJ20UTd
         Tdiw==
X-Gm-Message-State: AOAM531EQr51ymx4ihDAS/6SFK4+VEjwuGyUPLCL50xKMDj7X22mKGhh
        rLZH/TgUq+ypAerr5X+FJut7HlzAVIBha403DdM=
X-Google-Smtp-Source: ABdhPJwcaCWCNll8VthWgjCMOUW/rW1g9RgnU8vk5G+v2JLm8Bb+cuJ3ez96x+uRgXD37ZMt8TsErA==
X-Received: by 2002:a05:6402:1e92:b0:41d:219:d936 with SMTP id f18-20020a0564021e9200b0041d0219d936mr13400331edf.383.1649502294074;
        Sat, 09 Apr 2022 04:04:54 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id r11-20020a1709064d0b00b006e87938318dsm179574eju.39.2022.04.09.04.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 04:04:53 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next 5/6] net: bridge: fdb: add support for flush filtering based on ifindex
Date:   Sat,  9 Apr 2022 13:58:56 +0300
Message-Id: <20220409105857.803667-6-razor@blackwall.org>
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

Add support for fdb flush filtering based on destination ifindex. The
ifindex must either match a port's device ifindex or the bridge's.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 include/uapi/linux/if_bridge.h | 1 +
 net/bridge/br_fdb.c            | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 4638d7e39f2a..67ee12586844 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -819,6 +819,7 @@ enum {
 	FDB_FLUSH_NDM_STATE_MASK,
 	FDB_FLUSH_NDM_FLAGS,
 	FDB_FLUSH_NDM_FLAGS_MASK,
+	FDB_FLUSH_PORT_IFINDEX,
 	__FDB_FLUSH_MAX
 };
 #define FDB_FLUSH_MAX (__FDB_FLUSH_MAX - 1)
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 340a2ace1d5e..53208adf7474 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -628,6 +628,7 @@ static const struct nla_policy br_fdb_flush_policy[FDB_FLUSH_MAX + 1] = {
 	[FDB_FLUSH_NDM_FLAGS]	= { .type = NLA_U16 },
 	[FDB_FLUSH_NDM_STATE_MASK]	= { .type = NLA_U16 },
 	[FDB_FLUSH_NDM_FLAGS_MASK]	= { .type = NLA_U16 },
+	[FDB_FLUSH_PORT_IFINDEX]	= { .type = NLA_S32 },
 };
 
 int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
@@ -664,6 +665,12 @@ int br_fdb_flush_nlattr(struct net_bridge *br, struct nlattr *fdb_flush_attr,
 		ndm_flags_mask = nla_get_u16(fdb_flush_tb[FDB_FLUSH_NDM_FLAGS_MASK]);
 		desc.flags_mask |= __ndm_flags_to_fdb_flags(ndm_flags_mask);
 	}
+	if (fdb_flush_tb[FDB_FLUSH_PORT_IFINDEX]) {
+		int port_ifidx;
+
+		port_ifidx = nla_get_u32(fdb_flush_tb[FDB_FLUSH_PORT_IFINDEX]);
+		desc.port_ifindex = port_ifidx;
+	}
 
 	br_debug(br, "flushing port ifindex: %d vlan id: %u flags: 0x%lx flags mask: 0x%lx\n",
 		 desc.port_ifindex, desc.vlan_id, desc.flags, desc.flags_mask);
-- 
2.35.1

