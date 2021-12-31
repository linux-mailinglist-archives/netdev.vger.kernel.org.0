Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE3D482101
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 01:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242384AbhLaAgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 19:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242373AbhLaAgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 19:36:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF5BC061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 16:36:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A5F461702
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 00:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FCFC36AEC;
        Fri, 31 Dec 2021 00:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640911001;
        bh=FkM2kTZooDmAT+imxE0vorlpfxtNhXDGVhVk06kN5K0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jzE0k56ZzvRr780UwCsf6yRhdaCo9EDkCUllqO+w8fdKZUSCHkFKHDpcZgt9iVGdV
         tCGr3DuzRwc0l8iMgwz4RS+94pbIr53gHrczH5mNsmljQSu1+8Stu++rdAnmAX4sXr
         NmeojMp1P8Ncvyt2gU4YQ6eErU3OSetGLChM9kgXyD4ZzsVwUTie17qwFit+RxQX4d
         YByG478Iy39CbXjKkFbtG6v4T2OU9u0YwHNX2bZA9xNjgpptoVMgPyxcFAtelHzaOm
         QLpSmmnMAuT5UaO/gSJinnroKm3YM5seYbStlqX1uMstYxcOwa+S0VqoCyrvqTbrBA
         QSQUBckSwy8Fg==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH net 2/5] ipv4: Check attribute length for RTA_FLOW in multipath route
Date:   Thu, 30 Dec 2021 17:36:32 -0700
Message-Id: <20211231003635.91219-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20211231003635.91219-1-dsahern@kernel.org>
References: <20211231003635.91219-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure RTA_FLOW is at least 4B before using.

Fixes: 4e902c57417c ("[IPv4]: FIB configuration using struct fib_config")
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/fib_semantics.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index f1caa2c1c041..36bc429f1635 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -731,8 +731,13 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
 			}
 
 			nla = nla_find(attrs, attrlen, RTA_FLOW);
-			if (nla)
+			if (nla) {
+				if (nla_len(nla) < sizeof(u32)) {
+					NL_SET_ERR_MSG(extack, "Invalid RTA_FLOW");
+					return -EINVAL;
+				}
 				fib_cfg.fc_flow = nla_get_u32(nla);
+			}
 
 			fib_cfg.fc_encap = nla_find(attrs, attrlen, RTA_ENCAP);
 			nla = nla_find(attrs, attrlen, RTA_ENCAP_TYPE);
@@ -963,8 +968,14 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
 			nla = nla_find(attrs, attrlen, RTA_FLOW);
-			if (nla && nla_get_u32(nla) != nh->nh_tclassid)
-				return 1;
+			if (nla) {
+				if (nla_len(nla) < sizeof(u32)) {
+					NL_SET_ERR_MSG(extack, "Invalid RTA_FLOW");
+					return -EINVAL;
+				}
+				if (nla_get_u32(nla) != nh->nh_tclassid)
+					return 1;
+			}
 #endif
 		}
 
-- 
2.24.3 (Apple Git-128)

