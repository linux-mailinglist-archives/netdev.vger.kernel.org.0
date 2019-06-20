Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E3F4CD1B
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 13:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfFTLvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 07:51:17 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40210 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfFTLvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 07:51:17 -0400
Received: by mail-pf1-f196.google.com with SMTP id p184so1537278pfp.7
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 04:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4qVPpUo96t7fW1xT7laUuFCBqeaMMGxzWSW3DaeTS7I=;
        b=hnsUnl8rr3YuKv5LIBp/cAwPl9Y+tWpvEHTVIduwkzanrcb8w7QfZzhDnB10DcX+yN
         sPKEwBcGivbWLCW8OgRyxiplmGlOvqJGXQSQ574KQhfEJrIYMrFG8IpkNCL52HScWkrb
         dZ6mejKqUR8hILwsXYPQCgr6QM8rFBj0QeiAt9VNDocLrE0Urz0hFvNINGD0SFRvPPED
         8eiQB4gYtV89vSbnXxjsjun7sHEpZMcYBXlVTta5gMQKpROKsxe231zj0kU8D5LszcqH
         lmmAcmoPoyhygqUErOfULD9Q4ltLgRIUrf/mL+yHJx8y+Ai7bV6kL67T5sX5UktpciPC
         p+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4qVPpUo96t7fW1xT7laUuFCBqeaMMGxzWSW3DaeTS7I=;
        b=m7y8XZW32KWh1K5XJQus2ozle1gZDLJbPHGin8OHenlEKmsdOcdFQTu1gj+ZBb5AtW
         CWsiqlOLyELQJj570yfy4Su2Whg0G9yw3zyrdF+u1uiHC56d9B3HiCQokWvFkHmOo8bO
         x70u/VFO/w03SA74GlcKDDbrSwVjfyUfH9TJ8KH+UglDoiY5IFLi9TzSmv1xh1TFyBl6
         aAi6UkzMlGfviECPIgXIALz+fgMi6HPmBog3nYjmw62P3vjo7Lfk2NtiJTupyrUe5gk0
         hHpOsQmG7hHymlaD32hX/BufplWuTBpUQyyhqswOlz4Klk6eiuidV/O+HlrxWx2rWe2B
         Iq6A==
X-Gm-Message-State: APjAAAUs/LGdO9f6/XQvyULneBRO0Sh2/f0uvHmVO9a8wgQRLe9qqouA
        tQaK5UzZNuMULVn4cOHbz5g=
X-Google-Smtp-Source: APXvYqybrsiFKoH+xulm1KR4i7jKz05LUhDec3bAGGBnDFkUi3vOtKstlNV7xj4oi9dFxXiEAk990w==
X-Received: by 2002:a62:d45d:: with SMTP id u29mr65684500pfl.135.1561031476437;
        Thu, 20 Jun 2019 04:51:16 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id d4sm4234101pju.19.2019.06.20.04.51.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 04:51:15 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] vxlan: do not destroy fdb if register_netdevice() is failed
Date:   Thu, 20 Jun 2019 20:51:08 +0900
Message-Id: <20190620115108.5701-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__vxlan_dev_create() destroys FDB using specific pointer which indicates
a fdb when error occurs.
But that pointer should not be used when register_netdevice() fails because
register_netdevice() internally destroys fdb when error occurs.

In order to avoid un-registered dev's notification, fdb destroying routine
checks dev's register status before notification.

Test command
    ip link add bonding_masters type vxlan id 0 group 239.1.1.1 \
	    dev enp0s9 dstport 4789

Splat looks like:
[  130.396714] kasan: CONFIG_KASAN_INLINE enabled
[  130.397649] kasan: GPF could be caused by NULL-ptr deref or user memory access
[  130.398939] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  130.399829] CPU: 0 PID: 991 Comm: ip Not tainted 5.2.0-rc3+ #41
[  130.401581] RIP: 0010:vxlan_fdb_destroy+0x120/0x220 [vxlan]
[  130.402280] Code: df 48 8b 2b 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 06 01 00 00 4c 8b 63 08 48 b8 00 00 00 00d
[  130.404578] RSP: 0018:ffff8880cfac7080 EFLAGS: 00010a02
[  130.405235] RAX: dffffc0000000000 RBX: ffff8880d0613348 RCX: 0000000000000000
[  130.406172] RDX: 1bd5a00000000040 RSI: ffff8880d0613348 RDI: ffff8880d0613350
[  130.407056] RBP: 0000000000000000 R08: fffffbfff4378005 R09: 0000000000000000
[  130.408011] R10: 00000000ffffffef R11: 0000000000000000 R12: dead000000000200
[  130.408921] R13: ffff8880cfac71d8 R14: ffff8880b5d8cda0 R15: ffff8880b5d8cda0
[  130.409811] FS:  00007f9ef157e0c0(0000) GS:ffff8880da400000(0000) knlGS:0000000000000000
[  130.410805] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  130.411515] CR2: 0000560fe8118d54 CR3: 00000000bc684006 CR4: 00000000000606f0
[  130.412385] Call Trace:
[  130.412708]  __vxlan_dev_create+0x3a9/0x7d0 [vxlan]
[  130.413314]  ? vxlan_changelink+0x780/0x780 [vxlan]
[  130.413919]  ? rcu_read_unlock+0x60/0x60 [vxlan]
[  130.414497]  ? __kasan_kmalloc.constprop.3+0xa0/0xd0
[  130.415112]  vxlan_newlink+0x99/0xf0 [vxlan]
[  130.415640]  ? __vxlan_dev_create+0x7d0/0x7d0 [vxlan]
[  130.416270]  ? __netlink_ns_capable+0xc3/0xf0
[  130.416806]  __rtnl_newlink+0xb9f/0x11b0
[ ... ]

Fixes: 0241b836732f ("vxlan: fix default fdb entry netlink notify ordering during netdev create")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/vxlan.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 4c9bc29fe3d5..0bc07e3232c4 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -861,7 +861,7 @@ static void vxlan_fdb_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
 	netdev_dbg(vxlan->dev, "delete %pM\n", f->eth_addr);
 
 	--vxlan->addrcnt;
-	if (do_notify)
+	if (do_notify && vxlan->dev->reg_state >= NETREG_REGISTERED)
 		list_for_each_entry(rd, &f->remotes, list)
 			vxlan_fdb_notify(vxlan, f, rd, RTM_DELNEIGH,
 					 swdev_notify, NULL);
@@ -3542,7 +3542,6 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	struct vxlan_net *vn = net_generic(net, vxlan_net_id);
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	struct vxlan_fdb *f = NULL;
-	bool unregister = false;
 	int err;
 
 	err = vxlan_dev_configure(net, dev, conf, false, extack);
@@ -3567,8 +3566,7 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 
 	err = register_netdevice(dev);
 	if (err)
-		goto errout;
-	unregister = true;
+		return err;
 
 	err = rtnl_configure_link(dev, NULL);
 	if (err)
@@ -3592,8 +3590,7 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	 */
 	if (f)
 		vxlan_fdb_destroy(vxlan, f, false, false);
-	if (unregister)
-		unregister_netdevice(dev);
+	unregister_netdevice(dev);
 	return err;
 }
 
-- 
2.17.1

