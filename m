Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597B7374548
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbhEEREf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235399AbhEEQ6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:58:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75B43619AE;
        Wed,  5 May 2021 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232782;
        bh=9HH75c4v++9Tbx5W9V2lcph7xGqf9m1pgli5cM/gmFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZOkjfZ8aTv0dZNTakFXT3FjSRhef+ZeYTuV6o1W05hUTOp3G42omqMS1BLXVHOlH
         lD3/FbV2FMkTPSQVz+CTOaeV/deC15D24WeXtTiuDx2B9x91bBWHGV1ItyyERSQNxO
         mXv3a2lGAm0n7ex0thgEjelB7iZGCJPtcjR7YoOs4X3AmllUnggk/W9qhiVejQBaF1
         9rUyxMQYbzI5V95HUpJ/4CnvQ9p8iwKFgql3j0ziN09+TdPAH8CpUvSrRxZEkyXsRS
         r8YAzAoCJsZOdtvbrxGRxsurD56vwkhUzfxzHrY6skIS3mr4BA9xobulc/7JbxE1bo
         WPwiKlGyynWbg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 31/46] flow_dissector: Fix out-of-bounds warning in __skb_flow_bpf_to_target()
Date:   Wed,  5 May 2021 12:38:41 -0400
Message-Id: <20210505163856.3463279-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163856.3463279-1-sashal@kernel.org>
References: <20210505163856.3463279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

[ Upstream commit 1e3d976dbb23b3fce544752b434bdc32ce64aabc ]

Fix the following out-of-bounds warning:

net/core/flow_dissector.c:835:3: warning: 'memcpy' offset [33, 48] from the object at 'flow_keys' is out of the bounds of referenced subobject 'ipv6_src' with type '__u32[4]' {aka 'unsigned int[4]'} at offset 16 [-Warray-bounds]

The problem is that the original code is trying to copy data into a
couple of struct members adjacent to each other in a single call to
memcpy().  So, the compiler legitimately complains about it. As these
are just a couple of members, fix this by copying each one of them in
separate calls to memcpy().

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index da86c0e1b677..96957a7c732f 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -811,8 +811,10 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
 		key_addrs = skb_flow_dissector_target(flow_dissector,
 						      FLOW_DISSECTOR_KEY_IPV6_ADDRS,
 						      target_container);
-		memcpy(&key_addrs->v6addrs, &flow_keys->ipv6_src,
-		       sizeof(key_addrs->v6addrs));
+		memcpy(&key_addrs->v6addrs.src, &flow_keys->ipv6_src,
+		       sizeof(key_addrs->v6addrs.src));
+		memcpy(&key_addrs->v6addrs.dst, &flow_keys->ipv6_dst,
+		       sizeof(key_addrs->v6addrs.dst));
 		key_control->addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 	}
 
-- 
2.30.2

