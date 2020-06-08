Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C07E1F23D3
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbgFHXQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730314AbgFHXQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0253820801;
        Mon,  8 Jun 2020 23:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658202;
        bh=c5eiPu2dbd+pDztLejTMF6S4xO95QJd761VA4H594WQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pf08Ct3IzuU9LK9NxS86fP0QrMdtNw8ZPFx0sS8RCWucr4P7xZe9GyXMxqDyyU6xm
         VCfv/azYrk2S8xPbivldjOSm70ZVvo8bVNEQyFj3OsAlecgsFnw71NqzZ7iRdW0f7d
         v90FBI2eLfq5aKadVAzCx+fQ4nTvrudZHM7OS3dM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuqi Jin <jinyuqi@huawei.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Jiong Wang <jiongwang@huawei.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 221/606] net: revert "net: get rid of an signed integer overflow in ip_idents_reserve()"
Date:   Mon,  8 Jun 2020 19:05:46 -0400
Message-Id: <20200608231211.3363633-221-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuqi Jin <jinyuqi@huawei.com>

[ Upstream commit a6211caa634da39d861a47437ffcda8b38ef421b ]

Commit adb03115f459 ("net: get rid of an signed integer overflow in ip_idents_reserve()")
used atomic_cmpxchg to replace "atomic_add_return" inside the function
"ip_idents_reserve". The reason was to avoid UBSAN warning.
However, this change has caused performance degrade and in GCC-8,
fno-strict-overflow is now mapped to -fwrapv -fwrapv-pointer
and signed integer overflow is now undefined by default at all
optimization levels[1]. Moreover, it was a bug in UBSAN vs -fwrapv
/-fno-strict-overflow, so Let's revert it safely.

[1] https://gcc.gnu.org/gcc-8/changes.html

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jiong Wang <jiongwang@huawei.com>
Signed-off-by: Yuqi Jin <jinyuqi@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index ef6b70774fe1..fea6a8a11183 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -491,18 +491,16 @@ u32 ip_idents_reserve(u32 hash, int segs)
 	atomic_t *p_id = ip_idents + hash % IP_IDENTS_SZ;
 	u32 old = READ_ONCE(*p_tstamp);
 	u32 now = (u32)jiffies;
-	u32 new, delta = 0;
+	u32 delta = 0;
 
 	if (old != now && cmpxchg(p_tstamp, old, now) == old)
 		delta = prandom_u32_max(now - old);
 
-	/* Do not use atomic_add_return() as it makes UBSAN unhappy */
-	do {
-		old = (u32)atomic_read(p_id);
-		new = old + delta + segs;
-	} while (atomic_cmpxchg(p_id, old, new) != old);
-
-	return new - segs;
+	/* If UBSAN reports an error there, please make sure your compiler
+	 * supports -fno-strict-overflow before reporting it that was a bug
+	 * in UBSAN, and it has been fixed in GCC-8.
+	 */
+	return atomic_add_return(segs + delta, p_id) - segs;
 }
 EXPORT_SYMBOL(ip_idents_reserve);
 
-- 
2.25.1

