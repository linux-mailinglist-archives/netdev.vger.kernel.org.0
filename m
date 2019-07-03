Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F33E45DDF4
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 08:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbfGCGQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 02:16:53 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:36369 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfGCGQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 02:16:52 -0400
Received: by mail-pg1-f202.google.com with SMTP id i13so969469pgq.3
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 23:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FvQmzCDUMuWSkMc30pgjNtI5VQcNurV4O3PJ2iqKTVQ=;
        b=K3w2rDHG1tx+Sb7PB0DyznW8dPk5QsgBQ+vHNFpkx0E+8f3dsfM35+lci+cELNGC95
         oNs7Ft1JzVDaPNJME8TEWR4n6FPAkw9kgv1Tjgqn/tA5orHHnF7HhRlRE9IDycHUDG+v
         sQlDPkt/WgkJ/fgqjqkZQIW8PxXvuqMBqSTv13b/kcdUTOpHQxH7ohoaQ7qfUDfQxmd5
         0hbuWHllnY3sRwsVP/aCl2szfs7bi4PpfTww7AHoak5QCs+0bDpgJ9jPV8ENPbthjmWw
         xhOL1ccNHZyysxDOPlsVik7u9/aWA2dLVNgTKgcE4hphY8m2WnYVpV2jSj3djPV4zEvx
         L8Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FvQmzCDUMuWSkMc30pgjNtI5VQcNurV4O3PJ2iqKTVQ=;
        b=bQfZDDzT88+lNysfLvi2Q+QJP0GJJWmfUQUHLGBt6nO+tuHriyULVNiiwXPO0rZhvg
         6VShNrVBgyd0n1R4mJkroEAUcCvgJo2N1qKWVk+XJ0bMtVFpemmF7a6CMZpl9NgsQAvg
         4D+Wjf7VRje7WUx06vJn2DDSJkWVfO4wQumbfTCEqSIXcrOg6Llid3lJ/Tnnr3VP1PFm
         4M6jXWueepbI7WniYBiXD7yavjHyF0AquP1mChf9kiDUvQR8LU5zfwiLvCerc/CE4Ibq
         ak+JGfF9MBF68h73XS0RgQttbzYWow+L4dYVV86sCg2wWUbnUP7nezp/AWvnUHOFQ9u1
         14rA==
X-Gm-Message-State: APjAAAV4Fd5OA4K/Nw7sOhi4T79CPT6zq21ZcyOrDhlTfrfzauTvsEqk
        J04KHX79LN2LFSUvQjWtxRud/Wz554bqSr3YWiSQhdqTZD5oydy7dE4yV3iIynh2aLMCnIZMUa9
        Lat8+aBGYv9ZyLOSibu8qifUhgB2iFwD7tB4qwnxPd/4mK6vXGmUPgKbRDUImoWNp
X-Google-Smtp-Source: APXvYqyeV2u6KyPmmfEiE8wd6n2+fb4M9MJj3Z2WuNm2cZZ0w7LDt6ykuwrMcpXyxwBuf6dv7wa8cpZvl53U
X-Received: by 2002:a63:211c:: with SMTP id h28mr22255743pgh.438.1562134611836;
 Tue, 02 Jul 2019 23:16:51 -0700 (PDT)
Date:   Tue,  2 Jul 2019 23:16:31 -0700
Message-Id: <20190703061631.84485-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH next] loopback: fix lockdep splat
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_init_scheduler() and dev_activate() expect the caller to
hold RTNL. Since we don't want blackhole device to be initialized
per ns, we are initializing at init.

[    3.855027] Call Trace:
[    3.855034]  dump_stack+0x67/0x95
[    3.855037]  lockdep_rcu_suspicious+0xd5/0x110
[    3.855044]  dev_init_scheduler+0xe3/0x120
[    3.855048]  ? net_olddevs_init+0x60/0x60
[    3.855050]  blackhole_netdev_init+0x45/0x6e
[    3.855052]  do_one_initcall+0x6c/0x2fa
[    3.855058]  ? rcu_read_lock_sched_held+0x8c/0xa0
[    3.855066]  kernel_init_freeable+0x1e5/0x288
[    3.855071]  ? rest_init+0x260/0x260
[    3.855074]  kernel_init+0xf/0x180
[    3.855076]  ? rest_init+0x260/0x260
[    3.855078]  ret_from_fork+0x24/0x30

Fixes: 4de83b88c66 ("loopback: create blackhole net device similar to loopack.")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 drivers/net/loopback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 3b39def5471e..14545a8797a8 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -261,8 +261,10 @@ static int __init blackhole_netdev_init(void)
 	if (!blackhole_netdev)
 		return -ENOMEM;
 
+	rtnl_lock();
 	dev_init_scheduler(blackhole_netdev);
 	dev_activate(blackhole_netdev);
+	rtnl_unlock();
 
 	blackhole_netdev->flags |= IFF_UP | IFF_RUNNING;
 	dev_net_set(blackhole_netdev, &init_net);
-- 
2.22.0.410.gd8fdbe21b5-goog

