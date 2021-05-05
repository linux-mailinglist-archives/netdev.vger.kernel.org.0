Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB7937429D
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235811AbhEEQrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:47:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235954AbhEEQpV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:45:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8035861938;
        Wed,  5 May 2021 16:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232563;
        bh=IE8DMDbdBq7XLA2Cg3C4qy9GDQrXNNS+nLOKSI1DWqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSzgG4Zl3tdHinymqvk2GUrZ1g1WYmyuX06aeKTO5uBoKYF182fQ5eocoXgOuCp8x
         8Q3hPXpk+gAHQejwZBZLT9NJfAerMRjgTByQH+6YoxAQmUqlZrjvYCV/jAC9Uu/akK
         zfU8bllz+YIzFFdVwfAo4lyI6XOojve4vFllPJsqMb7Avsu/iNI2u/Xg519g3CvOAC
         24X4vvaSXc4kzDCKdAjzidXS34JwPp6QpBuK3FnkRNAyofV7Xrniizxqfn0ypoMMx2
         Zj6HN8hV79+fiu+JyONSsFEfFQzZOjRAgX16SdmK6k3ZMYpYqzTl0vpuxz6//Ar3Sn
         vTwaC5i1PCCbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 075/104] flow_dissector: Fix out-of-bounds warning in __skb_flow_bpf_to_target()
Date:   Wed,  5 May 2021 12:33:44 -0400
Message-Id: <20210505163413.3461611-75-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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
index 180be5102efc..aa997de1d44c 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -822,8 +822,10 @@ static void __skb_flow_bpf_to_target(const struct bpf_flow_keys *flow_keys,
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

