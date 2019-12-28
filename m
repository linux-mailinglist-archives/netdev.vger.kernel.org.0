Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC85B12BE02
	for <lists+netdev@lfdr.de>; Sat, 28 Dec 2019 17:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfL1Q2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Dec 2019 11:28:33 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35342 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfL1Q2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Dec 2019 11:28:32 -0500
Received: by mail-pf1-f196.google.com with SMTP id i23so10803540pfo.2
        for <netdev@vger.kernel.org>; Sat, 28 Dec 2019 08:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eaIEiX/5DbaqEbvsgMIyO6WDIEiCMDx3xTJqLvbUvVo=;
        b=XvJVJXbNL/jgBdGpDxTX/GWHDS+mcwVe9XkkqAX3pGUDGunIlofyImKiv6px7na275
         vlK6cU5JoIxZhZSU9azijBIvfDr84neUUVxie0l1B5eqFYeSWI0tNi8oomGH0/IFKAdw
         pvAh8bUNYRxHY54dZRFup9JOQAtC3Lr90m7sOXl0yBwaltUhINMRD+10WREVJlGx+KyN
         ETVjJyuQMZlJBIx2DQqD8GQFDtmLP2lx2U33SsOc14aROtmnPD8ztd32fncOcK1BjX05
         PgNghLwILxafTx+Ri7tGZ5HB91ITRIEdC8CAuU22S6wYxKVs3w1L2tWDAyX6d9f2AXlq
         w8Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eaIEiX/5DbaqEbvsgMIyO6WDIEiCMDx3xTJqLvbUvVo=;
        b=loIBYh4NMFuB/TQyGiJ9DS9hO6vpU4s1GX0rB+kHilMivKrVUZP7NyujgNvRk6mvuD
         YjBEl7KUK07XSAjRf8GQw9SFKIZ8JZEsno8xUCfd1BDOYSb8hnKfWEK4NDusbYo1o3JE
         1dd0d9KiTQoQWy/xxnLG/zScWYhlolvlH4OPhB0QjxddE7VCNGnXpL7EpGrgoJrc7vpy
         ooRSg5Wixx9iQlGy15p63qC1J+5jyo3k01T51EE6I7dh4auFvMVGKzFLaH3M/DpsL1fi
         CggxiV66tk0s/uo7s339lGd3+GPRPkfRn9mWSoGLw8LLGeFhlSovgqYtiOrDhYd7qa32
         SzyQ==
X-Gm-Message-State: APjAAAVt1pTqCESFVXfNH+PVZYpCzGQhU7mTdZeRgCmZXL4GhOWCHCqU
        XfJiLXjF9UlsKsWgNDKYSZQ=
X-Google-Smtp-Source: APXvYqysmiaEO70JdEBCUx6AY3SbYOzhF44n8nszXwJgjqHi/47+RFF4tfMN+ZD2E9nVTbwvOXxmeA==
X-Received: by 2002:aa7:94b0:: with SMTP id a16mr60582602pfl.35.1577550512055;
        Sat, 28 Dec 2019 08:28:32 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id n1sm44826343pfd.47.2019.12.28.08.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Dec 2019 08:28:30 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] hsr: fix slab-out-of-bounds Read in hsr_debugfs_rename()
Date:   Sat, 28 Dec 2019 16:28:09 +0000
Message-Id: <20191228162809.21370-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hsr slave interfaces don't have debugfs directory.
So, hsr_debugfs_rename() shouldn't be called when hsr slave interface name
is changed.

Test commands:
    ip link add dummy0 type dummy
    ip link add dummy1 type dummy
    ip link add hsr0 type hsr slave1 dummy0 slave2 dummy1
    ip link set dummy0 name ap

Splat looks like:
[21071.899367][T22666] ap: renamed from dummy0
[21071.914005][T22666] ==================================================================
[21071.919008][T22666] BUG: KASAN: slab-out-of-bounds in hsr_debugfs_rename+0xaa/0xb0 [hsr]
[21071.923640][T22666] Read of size 8 at addr ffff88805febcd98 by task ip/22666
[21071.926941][T22666]
[21071.927750][T22666] CPU: 0 PID: 22666 Comm: ip Not tainted 5.5.0-rc2+ #240
[21071.929919][T22666] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[21071.935094][T22666] Call Trace:
[21071.935867][T22666]  dump_stack+0x96/0xdb
[21071.936687][T22666]  ? hsr_debugfs_rename+0xaa/0xb0 [hsr]
[21071.937774][T22666]  print_address_description.constprop.5+0x1be/0x360
[21071.939019][T22666]  ? hsr_debugfs_rename+0xaa/0xb0 [hsr]
[21071.940081][T22666]  ? hsr_debugfs_rename+0xaa/0xb0 [hsr]
[21071.940949][T22666]  __kasan_report+0x12a/0x16f
[21071.941758][T22666]  ? hsr_debugfs_rename+0xaa/0xb0 [hsr]
[21071.942674][T22666]  kasan_report+0xe/0x20
[21071.943325][T22666]  hsr_debugfs_rename+0xaa/0xb0 [hsr]
[21071.944187][T22666]  hsr_netdev_notify+0x1fe/0x9b0 [hsr]
[21071.945052][T22666]  ? __module_text_address+0x13/0x140
[21071.945897][T22666]  notifier_call_chain+0x90/0x160
[21071.946743][T22666]  dev_change_name+0x419/0x840
[21071.947496][T22666]  ? __read_once_size_nocheck.constprop.6+0x10/0x10
[21071.948600][T22666]  ? netdev_adjacent_rename_links+0x280/0x280
[21071.949577][T22666]  ? __read_once_size_nocheck.constprop.6+0x10/0x10
[21071.950672][T22666]  ? lock_downgrade+0x6e0/0x6e0
[21071.951345][T22666]  ? do_setlink+0x811/0x2ef0
[21071.951991][T22666]  do_setlink+0x811/0x2ef0
[21071.952613][T22666]  ? is_bpf_text_address+0x81/0xe0
[ ... ]

Reported-by: syzbot+9328206518f08318a5fd@syzkaller.appspotmail.com
Fixes: 4c2d5e33dcd3 ("hsr: rename debugfs file when interface name is changed")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index d2ee7125a7f1..9e389accbfc7 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -46,7 +46,8 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 		hsr_check_carrier_and_operstate(hsr);
 		break;
 	case NETDEV_CHANGENAME:
-		hsr_debugfs_rename(dev);
+		if (is_hsr_master(dev))
+			hsr_debugfs_rename(dev);
 		break;
 	case NETDEV_CHANGEADDR:
 		if (port->type == HSR_PT_MASTER) {
-- 
2.17.1

