Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E6C13F511
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389551AbgAPSyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:54:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389278AbgAPRIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CB592192A;
        Thu, 16 Jan 2020 17:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194484;
        bh=oLW8bhEuqWvslr3yGFZ5KkqJyKsLCXsxNqmIHwnuDoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxTH9/OEO6pTnNDPpRW5Ljx++8CFOvHD8pyatmLxZYVowwxb65MY/4cbKYIaF/PFw
         JeC0/hnN584QHAX3QleO/xI5cBChVotPlj+67f40LURI2w/fVfU5Z5/D1wqZEvQttt
         wypq/Qepnai5xOp4aSfAbrvrLbUcI9pkVWu6wEXg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 385/671] inet: frags: call inet_frags_fini() after unregister_pernet_subsys()
Date:   Thu, 16 Jan 2020 12:00:23 -0500
Message-Id: <20200116170509.12787-122-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ae7352d384a552d8c799c242e74a934809990a71 ]

Both IPv6 and 6lowpan are calling inet_frags_fini() too soon.

inet_frags_fini() is dismantling a kmem_cache, that might be needed
later when unregister_pernet_subsys() eventually has to remove
frags queues from hash tables and free them.

This fixes potential use-after-free, and is a prereq for the following patch.

Fixes: d4ad4d22e7ac ("inet: frags: use kmem_cache for inet_frag_queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/6lowpan/reassembly.c | 2 +-
 net/ipv6/reassembly.c               | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index e7857a8ac86d..f3074249c6fc 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -629,7 +629,7 @@ int __init lowpan_net_frag_init(void)
 
 void lowpan_net_frag_exit(void)
 {
-	inet_frags_fini(&lowpan_frags);
 	lowpan_frags_sysctl_unregister();
 	unregister_pernet_subsys(&lowpan_frags_ops);
+	inet_frags_fini(&lowpan_frags);
 }
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 095825f964e2..c6132e39ab16 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -593,8 +593,8 @@ int __init ipv6_frag_init(void)
 
 void ipv6_frag_exit(void)
 {
-	inet_frags_fini(&ip6_frags);
 	ip6_frags_sysctl_unregister();
 	unregister_pernet_subsys(&ip6_frags_ops);
 	inet6_del_protocol(&frag_protocol, IPPROTO_FRAGMENT);
+	inet_frags_fini(&ip6_frags);
 }
-- 
2.20.1

