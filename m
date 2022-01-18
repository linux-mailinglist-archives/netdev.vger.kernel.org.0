Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E272491BC9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346864AbiARDJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344475AbiARDCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:02:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDCEC028B93;
        Mon, 17 Jan 2022 18:47:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C14760AB1;
        Tue, 18 Jan 2022 02:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B6FC36AEB;
        Tue, 18 Jan 2022 02:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474073;
        bh=MKLrJ8FlCvlI9o//6ZJnt/lKxwBZJ03UBn+TH3C0pVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPRhytpb7bqjMMAol4wXHeJe95WI0i9+C3D9HebUGAxYSueOTrKd/AYQ1NngNLZhk
         MXvmELRBmg3KAuaQsIZorrC8muDuZIcwRolk3Eb+QnuqZMeSBj1tNFPQ7MkLOEra2q
         tqD03dlZb/Amr8HIXeRhJFNLRuGuhNIdhqBZ7KNeUnipzk2NYLsgOYLoynPD6lKsZz
         gAYLtGlRRZg3/4q6LLVV7ODVtgLwh0uvcDzfdZ2soYe87oMDQwk76JwRETxDCX6Q+i
         dHhU90iNh+l0Cc1OMWhSrGpuQKZiLy6oMeB3uQMHZaAcfTZex3qXRqSe2JuAm3ldAh
         SvyreFk0x8u2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     xu xin <xu.xin16@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>,
        Joanne Koong <joannekoong@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        daniel@iogearbox.net, dsahern@kernel.org, roopa@nvidia.com,
        edumazet@google.com, yajun.deng@linux.dev, chinagar@codeaurora.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 23/59] net: Enable neighbor sysctls that is save for userns root
Date:   Mon, 17 Jan 2022 21:46:24 -0500
Message-Id: <20220118024701.1952911-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
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
index 6233e9856016e..4c49e4ddabff7 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3239,10 +3239,6 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
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

