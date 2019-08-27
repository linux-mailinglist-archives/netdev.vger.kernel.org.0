Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4AEA9E5B8
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 12:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbfH0KdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 06:33:17 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:38889 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727578AbfH0KdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 06:33:17 -0400
Received: by mail-vs1-f74.google.com with SMTP id d15so4736924vsq.5
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 03:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FsPZ2BRSclzLon8MAOoWezsPJzWdf866m/HLJwzPC/8=;
        b=UEjs93Ij2Vz9gLCyEc7Nv26UU3ILzjN86W5Js5rsOxQ6OvV2HpP5T5daJ/slaJ1b35
         G+9kmTUO6cBuXQojGUcY7UiPd9Ixir0M73vY8rbEuEUU3hn6E9oYnkQJnhn5bpvfGK9Z
         GeIPocZtWls0UfCA7IpTkcz/MkizxKsvAs0av9GqN1yO0LqXL0S6pRreoBJpfG/4iDAG
         5VIrDmK/6iCch3HlZsMlXlH5CxBL/lUZRamBH35xUlHh6Wz86nzNZG4zRLSkDwD/DXmg
         j6I5GvO6vtdRG9+XktHdCQbErHlPZjzgWlYyOMnC+74hUUiehh1+dJBwiVHeJbW+Ts8x
         iYag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FsPZ2BRSclzLon8MAOoWezsPJzWdf866m/HLJwzPC/8=;
        b=H10PASobttkK7uXVZzfwo6j+pzSkradReK7hZTnA3ounZBe9Ky53W1QvgAWILt7HQ0
         zznsSIGQtkW2y5l9RhxEt9U3eRLFCIhDM4VfchOhgGu5hnVKEj2YAKquLJteDiB/Eh2u
         BPXYxcCcxoRptlkwY5u7bAaclDV/kolZlAITjA88AVi3Fq59ht3fmKW6VOqylXIe4vGG
         CkCEfVwIA5vPgDXFuk2JnfWjpuwASCIiDET64IpiGIEBhc/CBv3Vx0hwIlAJFZ73LHpv
         g6DNAnk0MUNGW9yFyn0RH9rTEEBnoeZBSlmtp03w6eZ6VU839DKhbv7f4xya28EFAf7D
         OQAQ==
X-Gm-Message-State: APjAAAV5zpUTbSOs/BnIhQki32bih/87vegjR5/r7hVku5msevLTm/DN
        SKTBycEZtcx3mjeIHC2BXC+/EbP7usf6nA==
X-Google-Smtp-Source: APXvYqyreltMzOvOF9Q87py9BWBduz1DJ++WTPPbBWZuR2VITT1QgTzrJnZDoGBt2RSfzxmZBtLNBoOV0E//oA==
X-Received: by 2002:a67:f983:: with SMTP id b3mr11650277vsq.96.1566901996358;
 Tue, 27 Aug 2019 03:33:16 -0700 (PDT)
Date:   Tue, 27 Aug 2019 03:33:12 -0700
Message-Id: <20190827103312.180258-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH net] mld: fix memory leak in mld_del_delrec()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to the fix done for IPv4 in commit e5b1c6c6277d
("igmp: fix memory leak in igmpv3_del_delrec()"), we need to
make sure mca_tomb and mca_sources are not blindly overwritten.

Using swap() then a call to ip6_mc_clear_src() will take care
of the missing free.

BUG: memory leak
unreferenced object 0xffff888117d9db00 (size 64):
  comm "syz-executor247", pid 6918, jiffies 4294943989 (age 25.350s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 fe 88 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000005b463030>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<000000005b463030>] slab_post_alloc_hook mm/slab.h:522 [inline]
    [<000000005b463030>] slab_alloc mm/slab.c:3319 [inline]
    [<000000005b463030>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
    [<00000000939cbf94>] kmalloc include/linux/slab.h:552 [inline]
    [<00000000939cbf94>] kzalloc include/linux/slab.h:748 [inline]
    [<00000000939cbf94>] ip6_mc_add1_src net/ipv6/mcast.c:2236 [inline]
    [<00000000939cbf94>] ip6_mc_add_src+0x31f/0x420 net/ipv6/mcast.c:2356
    [<00000000d8972221>] ip6_mc_source+0x4a8/0x600 net/ipv6/mcast.c:449
    [<000000002b203d0d>] do_ipv6_setsockopt.isra.0+0x1b92/0x1dd0 net/ipv6/ipv6_sockglue.c:748
    [<000000001f1e2d54>] ipv6_setsockopt+0x89/0xd0 net/ipv6/ipv6_sockglue.c:944
    [<00000000c8f7bdf9>] udpv6_setsockopt+0x4e/0x90 net/ipv6/udp.c:1558
    [<000000005a9a0c5e>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3139
    [<00000000910b37b2>] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
    [<00000000e9108023>] __do_sys_setsockopt net/socket.c:2100 [inline]
    [<00000000e9108023>] __se_sys_setsockopt net/socket.c:2097 [inline]
    [<00000000e9108023>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2097
    [<00000000f4818160>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:296
    [<000000008d367e8f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1666d49e1d41 ("mld: do not remove mld souce list info when set link down")
Fixes: 9c8bb163ae78 ("igmp, mld: Fix memory leak in igmpv3/mld_del_delrec()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv6/mcast.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 7f3f13c3791636f92c5c46aa6235c69682dea151..eaa4c2cc2fbb2e784b5641135d28dd38a0616421 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -787,14 +787,15 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 	if (pmc) {
 		im->idev = pmc->idev;
 		if (im->mca_sfmode == MCAST_INCLUDE) {
-			im->mca_tomb = pmc->mca_tomb;
-			im->mca_sources = pmc->mca_sources;
+			swap(im->mca_tomb, pmc->mca_tomb);
+			swap(im->mca_sources, pmc->mca_sources);
 			for (psf = im->mca_sources; psf; psf = psf->sf_next)
 				psf->sf_crcount = idev->mc_qrv;
 		} else {
 			im->mca_crcount = idev->mc_qrv;
 		}
 		in6_dev_put(pmc->idev);
+		ip6_mc_clear_src(pmc);
 		kfree(pmc);
 	}
 	spin_unlock_bh(&im->mca_lock);
-- 
2.23.0.187.g17f5b7556c-goog

