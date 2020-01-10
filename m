Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEE213796F
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 23:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgAJWIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 17:08:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727787AbgAJWFk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 17:05:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC39E20838;
        Fri, 10 Jan 2020 22:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578693939;
        bh=FaD2lQgwj++PgBdNqXW0xbro1IUzunfmBSm2JEWFPHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFvMtK7RSXnbA1hSsulyFrCou5k7vZ8BMwp906IKny9kltJC/VElfEvLzZkj6fclq
         g4LkH8W8tQSe0PB3hYqPu10HKoFDjurNE4xyZdjaBmipXxvPpwtnSr5vsEJQqLLW0a
         L45kE7EKw1vDwRS/sesLPNHw1MokOhkDxGJKi1BE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        syzbot+9328206518f08318a5fd@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/26] hsr: fix slab-out-of-bounds Read in hsr_debugfs_rename()
Date:   Fri, 10 Jan 2020 17:05:14 -0500
Message-Id: <20200110220519.28250-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200110220519.28250-1-sashal@kernel.org>
References: <20200110220519.28250-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 04b69426d846cd04ca9acefff1ea39e1c64d2714 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.20.1

