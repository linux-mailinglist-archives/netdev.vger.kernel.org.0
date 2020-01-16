Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5EE13EE0E
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405108AbgAPRjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:39:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729819AbgAPRjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:39:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02B71246EC;
        Thu, 16 Jan 2020 17:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196359;
        bh=ygK505ucu28K+j2DmCyX0sygillEdeqRWh+0QpfzkLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gX1AtvSxRuJEJdJHWnOI3FzsFkNmTvQvfowTvAJ52WEYVgjbZg6csg5DWSXFbJCSe
         lKkGEwQ8Flk7AFvo4YHMGZLHZCZLn+p2VvhPfjUWo0Z+ZUV9gYdMmjppCNktFOF/M2
         ZgJLCrll/wC5i5ehqPVIg6NjQE4m67pxgxgx7ETs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 150/251] inet: frags: call inet_frags_fini() after unregister_pernet_subsys()
Date:   Thu, 16 Jan 2020 12:34:59 -0500
Message-Id: <20200116173641.22137-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
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
index c01df341b5f6..5936bfafb1c4 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -633,7 +633,7 @@ int __init lowpan_net_frag_init(void)
 
 void lowpan_net_frag_exit(void)
 {
-	inet_frags_fini(&lowpan_frags);
 	lowpan_frags_sysctl_unregister();
 	unregister_pernet_subsys(&lowpan_frags_ops);
+	inet_frags_fini(&lowpan_frags);
 }
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 4aed9c45a91a..3f488555999e 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -592,8 +592,8 @@ int __init ipv6_frag_init(void)
 
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

