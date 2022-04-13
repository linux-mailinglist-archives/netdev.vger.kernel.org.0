Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31B34FFD09
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbiDMRp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236323AbiDMRpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:45:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03396CA66
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:43:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EA3DB826A9
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDE9C385A8;
        Wed, 13 Apr 2022 17:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649871811;
        bh=G014dzYjZiA7PFihVFG9EOc1YDDoCgF7ABuTjE5FIj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tw5VTvSbQ5AB5ih86y6M6w6fLBNeIw1DOBrZXOoM1xk1tdKDtAkydhobo234tUokX
         lxcbhfvgh4muIBZFk0oM2XWu3+pFpFYEhreCyrByS0li6RZmwhFbhrX3MP3yARS/3v
         h194z3jXCU47UOXTfM3buYOtw0kYEZQNRvCio3u1f/BU0q/BsSy2zMigX3HDF1kmuG
         FDyINcKTtkG5ImcOoPSq7lth1ImkTsofAyuGkXpqu9mm0sQCC0IdDTQR3KkZLDniNb
         9CJTAfHbFhX9A+BjMBbJP2RfTFI3BbqHCBHtRQWKR8LVOxR7bC5DKv2aSlWwp9EW1g
         clqh8w7iHvuBw==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com
Cc:     David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Alexis Bauvin <abauvin@scaleway.com>
Subject: [PATCH net 1/2] l3mdev: l3mdev_master_upper_ifindex_by_index_rcu should be using netdev_master_upper_dev_get_rcu
Date:   Wed, 13 Apr 2022 11:43:19 -0600
Message-Id: <20220413174320.28989-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220413174320.28989-1-dsahern@kernel.org>
References: <20220413174320.28989-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Next patch uses l3mdev_master_upper_ifindex_by_index_rcu which throws
a splat with debug kernels:

[13783.087570] ------------[ cut here ]------------
[13783.093974] RTNL: assertion failed at net/core/dev.c (6702)
[13783.100761] WARNING: CPU: 3 PID: 51132 at net/core/dev.c:6702 netdev_master_upper_dev_get+0x16a/0x1a0

[13783.184226] CPU: 3 PID: 51132 Comm: kworker/3:3 Not tainted 5.17.0-custom-100090-g6f963aafb1cc #682
[13783.194788] Hardware name: Mellanox Technologies Ltd. MSN2010/SA002610, BIOS 5.6.5 08/24/2017
[13783.204755] Workqueue: mld mld_ifc_work [ipv6]
[13783.210338] RIP: 0010:netdev_master_upper_dev_get+0x16a/0x1a0
[13783.217209] Code: 0f 85 e3 fe ff ff e8 65 ac ec fe ba 2e 1a 00 00 48 c7 c6 60 6f 38 83 48 c7 c7 c0 70 38 83 c6 05 5e b5 d7 01 01 e8 c6 29 52 00 <0f> 0b e9 b8 fe ff ff e8 5a 6c 35 ff e9 1c ff ff ff 48 89 ef e8 7d
[13783.238659] RSP: 0018:ffffc9000b37f5a8 EFLAGS: 00010286
[13783.244995] RAX: 0000000000000000 RBX: ffff88812ee5c000 RCX: 0000000000000000
[13783.253379] RDX: ffff88811ce09d40 RSI: ffffffff812d0fcd RDI: fffff5200166fea7
[13783.261769] RBP: 0000000000000000 R08: 0000000000000001 R09: ffff8882375f4287
[13783.270138] R10: ffffed1046ebe850 R11: 0000000000000001 R12: dffffc0000000000
[13783.278510] R13: 0000000000000275 R14: ffffc9000b37f688 R15: ffff8881273b4af8
[13783.286870] FS:  0000000000000000(0000) GS:ffff888237400000(0000) knlGS:0000000000000000
[13783.296352] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[13783.303177] CR2: 00007ff25fc9b2e8 CR3: 0000000174d23000 CR4: 00000000001006e0
[13783.311546] Call Trace:
[13783.314660]  <TASK>
[13783.317553]  l3mdev_master_upper_ifindex_by_index_rcu+0x43/0xe0
...

Change l3mdev_master_upper_ifindex_by_index_rcu to use
netdev_master_upper_dev_get_rcu.

Fixes: 6a6d6681ac1a ("l3mdev: add function to retreive upper master")
Signed-off-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Alexis Bauvin <abauvin@scaleway.com>
---
 net/l3mdev/l3mdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/l3mdev/l3mdev.c b/net/l3mdev/l3mdev.c
index 4eb8892fb2ff..ca10916340b0 100644
--- a/net/l3mdev/l3mdev.c
+++ b/net/l3mdev/l3mdev.c
@@ -147,7 +147,7 @@ int l3mdev_master_upper_ifindex_by_index_rcu(struct net *net, int ifindex)
 
 	dev = dev_get_by_index_rcu(net, ifindex);
 	while (dev && !netif_is_l3_master(dev))
-		dev = netdev_master_upper_dev_get(dev);
+		dev = netdev_master_upper_dev_get_rcu(dev);
 
 	return dev ? dev->ifindex : 0;
 }
-- 
2.24.3 (Apple Git-128)

