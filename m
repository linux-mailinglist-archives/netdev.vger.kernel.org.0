Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E4049155F
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245403AbiARC1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:27:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42510 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245410AbiARCZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:25:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C06360A6B;
        Tue, 18 Jan 2022 02:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4AFC36AE3;
        Tue, 18 Jan 2022 02:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472734;
        bh=NrDQkO4I+cVBZBVA1n3ItY4WmFP9x95zh+C06Zuohno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btvQ2z+j/RpBiFS5AGd3UzcR/lEXwg1sUmLnybAaBI9/yAWICQmYHEg9pY4nSpXzQ
         v1MCSeUV26Ac4BNArAalpreHUgkrIFp6UvZjqKXy4Cw7wRshaicWC8WTx/HlMmCv91
         i8CipWsXQbU6J7+XZD2B8E7Ez17+s83/koVib4f0Am0SpiwOOKgEuO0BkFlB4GPOJv
         aaVUfpRiIQw5mWn6GorSjAfnD1ubx0ZmY9LWV14saW4tJKf10UEn/2/26Gt6wA/ma0
         vDF5WBcaVWshXb+QIORQjmPAMbwrp3H2Fljva+K9EakMxH4Sxxqn1G0M6e6qzSlyK0
         0VosqtWjkcTDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     xu xin <xu.xin16@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Joanne Koong <joannekoong@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        daniel@iogearbox.net, dsahern@kernel.org, roopa@nvidia.com,
        edumazet@google.com, chinagar@codeaurora.org, yajun.deng@linux.dev,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 118/217] net: Enable neighbor sysctls that is save for userns root
Date:   Mon, 17 Jan 2022 21:18:01 -0500
Message-Id: <20220118021940.1942199-118-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

[ Upstream commit 8c8b7aa7fb0cf9e1cc9204e6bc6e1353b8393502 ]

Inside netns owned by non-init userns, sysctls about ARP/neighbor is
currently not visible and configurable.

For the attributes these sysctls correspond to, any modifications make
effects on the performance of networking(ARP, especilly) only in the
scope of netns, which does not affect other netns.

Actually, some tools via netlink can modify these attribute. iproute2 is
an example. see as follows:

$ unshare -ur -n
$ cat /proc/sys/net/ipv4/neigh/lo/retrans_time
cat: can't open '/proc/sys/net/ipv4/neigh/lo/retrans_time': No such file
or directory
$ ip ntable show dev lo
inet arp_cache
    dev lo
    refcnt 1 reachable 19494 base_reachable 30000 retrans 1000
    gc_stale 60000 delay_probe 5000 queue 101
    app_probes 0 ucast_probes 3 mcast_probes 3
    anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 1000

inet6 ndisc_cache
    dev lo
    refcnt 1 reachable 42394 base_reachable 30000 retrans 1000
    gc_stale 60000 delay_probe 5000 queue 101
    app_probes 0 ucast_probes 3 mcast_probes 3
    anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 0
$ ip ntable change name arp_cache dev <if> retrans 2000
inet arp_cache
    dev lo
    refcnt 1 reachable 22917 base_reachable 30000 retrans 2000
    gc_stale 60000 delay_probe 5000 queue 101
    app_probes 0 ucast_probes 3 mcast_probes 3
    anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 1000

inet6 ndisc_cache
    dev lo
    refcnt 1 reachable 35524 base_reachable 30000 retrans 1000
    gc_stale 60000 delay_probe 5000 queue 101
    app_probes 0 ucast_probes 3 mcast_probes 3
    anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 0

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Acked-by: Joanne Koong <joannekoong@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index dda12fbd177ba..559928a1defb4 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3770,10 +3770,6 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
 			neigh_proc_base_reachable_time;
 	}
 
-	/* Don't export sysctls to unprivileged users */
-	if (neigh_parms_net(p)->user_ns != &init_user_ns)
-		t->neigh_vars[0].procname = NULL;
-
 	switch (neigh_parms_family(p)) {
 	case AF_INET:
 	      p_name = "ipv4";
-- 
2.34.1

