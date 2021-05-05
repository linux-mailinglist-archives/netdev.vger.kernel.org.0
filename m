Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DA9374190
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235252AbhEEQjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235101AbhEEQhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:37:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABC846145E;
        Wed,  5 May 2021 16:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232405;
        bh=8vdi0o9dKNdzAyIYJMghwa/S09pJ00H4wLWn9brOe8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZTZEol7yG9uvWjOuhD/hofEHFcylLsvvt4UlUcv/0Kylc1FYBOdkuExuHXwTCYWzP
         1QtJLpqbnCLirafiXB5MxsS4rVemM5KFixXForLeQEIchb57GAoMfQ3hlvdzOPX74O
         Jggi4ahzXqIQkJZA4HkIhm8t9WhGsxrgeVb9iaTdg99wzmftqTraLG+Uq55QIiJiLw
         F80eW8R6j2xi3GZ9KNugUvr0rpjHcdD2fk7gxRZyRs84SbZnltA/s1iuGsZYiysfRb
         Yw7AUUr0+0/zqLUjsBjq8JmTAbCDwKmL9SMoCrZYBc1E2edAAHFtkCjIs1f8YOPtW3
         +5aF8kh4EzTcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 085/116] flow_dissector: Fix out-of-bounds warning in __skb_flow_bpf_to_target()
Date:   Wed,  5 May 2021 12:30:53 -0400
Message-Id: <20210505163125.3460440-85-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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
index a96a4f5de0ce..3f36b04d86a0 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -828,8 +828,10 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
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

