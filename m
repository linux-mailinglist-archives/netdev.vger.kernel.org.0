Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99321584DB
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 16:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfF0OuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 10:50:18 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35554 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbfF0OuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 10:50:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id d126so1363199pfd.2
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 07:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=etOcY0stdBOrWRtt1ej3+I1iR0Qfa6CFRpoN8PKZ3D0=;
        b=E7fQQnjStXTG2agoJQ8u0cADUmOFVW+0rDa/fkS9n1kSoi/oqKNK2BiF/TPvSBGCR8
         NlPjt15JLbZeEfVV4EzoyXg8ivkkGsBzu1FemmYQkQJAts8JZb4kHL4iQ2Xky2BuhYtz
         7n2X2Lj64LeoWqViG3JL4BMOLkuNHE6fyQtUhPYZJ5JwhtkuRtfghV6lw+CO85cTnpq2
         aFWFgLDsDlIyhOdJk/r0T3T6j6SlrD62LpFOYcQzB0rQ0bdveLEmh7uhm27F6ZodZqz9
         En9/X6Z8gCEw8p7CFJHQoWQgPCxMaOAC5koCUf9jdJnlTtIbfVywDDPJhQq/MivhMUMU
         3eww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=etOcY0stdBOrWRtt1ej3+I1iR0Qfa6CFRpoN8PKZ3D0=;
        b=EIjl4ypUdOR9WueXF1TXyRulw13fPSYDzOaMLMN7Ts+wb87eUUAfiaAD6uXBH9GeoS
         iEQubpfUBPdoUtKFFwvPKZqoC69QgTvtPwK7AGxl7BmjzG4NiLln2rKOt3XQ88r/azFq
         NHs1Opec6/J4z/2IxwgGoVobVHfa9i5goofPEpPlvnzsEui6l7ab+WiklBVoco31VmKz
         p4IyAfUvuuddnxephxb1Oq2Fr+ffBjCi/lg9Pwa+kja0NiOJNHd22Ee5MwewpFi7vU38
         mdYohnsR5a2OIM97hsJZWZp7vkQJGMmuoc+q63DJFG3yCCE4I7ph7PgjXJ2PWouFSWD6
         jOOg==
X-Gm-Message-State: APjAAAWZ9FGrsP8tt9IZXsQ3nxdx4C4OdCTJMTYJQs8jED8hMIToTwdV
        7J7KUir429H8d6k8IjjbPB0=
X-Google-Smtp-Source: APXvYqwglpUwOAoXHVC0z0bCG2IJB+JuO0E9veOHXjJzotCahBLJzVimOiSWyRAeOVXI9eiwOxWL1Q==
X-Received: by 2002:a65:538d:: with SMTP id x13mr4204936pgq.190.1561647016371;
        Thu, 27 Jun 2019 07:50:16 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id q5sm4326620pgj.49.2019.06.27.07.50.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 07:50:15 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2] vxlan: do not destroy fdb if register_netdevice() is failed
Date:   Thu, 27 Jun 2019 23:50:10 +0900
Message-Id: <20190627145010.21073-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__vxlan_dev_create() destroys FDB using specific pointer which indicates
a fdb when error occurs.
But that pointer should not be used when register_netdevice() fails because
register_netdevice() internally destroys fdb when error occurs.

This patch makes vxlan_fdb_create() to do not link fdb entry to vxlan dev
internally.
Instead, a new function vxlan_fdb_link() is added to link fdb to vxlan dev.

vxlan_fdb_link() is called after calling register_netdevice().
This routine can avoid situation that ->ndo_uninit() destroys fdb entry
in error path of register_netdevice().
Hence, error path of __vxlan_dev_create() routine can have an opportunity
to destroy default fdb entry by hand.

Test command
    ip link add bonding_masters type vxlan id 0 group 239.1.1.1 \
	    dev enp0s9 dstport 4789

Splat looks like:
[  213.392816] kasan: GPF could be caused by NULL-ptr deref or user memory access
[  213.401257] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  213.402178] CPU: 0 PID: 1414 Comm: ip Not tainted 5.2.0-rc5+ #256
[  213.402178] RIP: 0010:vxlan_fdb_destroy+0x120/0x220 [vxlan]
[  213.402178] Code: df 48 8b 2b 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 06 01 00 00 4c 8b 63 08 48 b8 00 00 00 00 00 fc d
[  213.402178] RSP: 0018:ffff88810cb9f0a0 EFLAGS: 00010202
[  213.402178] RAX: dffffc0000000000 RBX: ffff888101d4a8c8 RCX: 0000000000000000
[  213.402178] RDX: 1bd5a00000000040 RSI: ffff888101d4a8c8 RDI: ffff888101d4a8d0
[  213.402178] RBP: 0000000000000000 R08: fffffbfff22b72d9 R09: 0000000000000000
[  213.402178] R10: 00000000ffffffef R11: 0000000000000000 R12: dead000000000200
[  213.402178] R13: ffff88810cb9f1f8 R14: ffff88810efccda0 R15: ffff88810efccda0
[  213.402178] FS:  00007f7f6621a0c0(0000) GS:ffff88811b000000(0000) knlGS:0000000000000000
[  213.402178] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  213.402178] CR2: 000055746f0807d0 CR3: 00000001123e0000 CR4: 00000000001006f0
[  213.402178] Call Trace:
[  213.402178]  __vxlan_dev_create+0x3a9/0x7d0 [vxlan]
[  213.402178]  ? vxlan_changelink+0x740/0x740 [vxlan]
[  213.402178]  ? rcu_read_unlock+0x60/0x60 [vxlan]
[  213.402178]  ? __kasan_kmalloc.constprop.3+0xa0/0xd0
[  213.402178]  vxlan_newlink+0x8d/0xc0 [vxlan]
[  213.402178]  ? __vxlan_dev_create+0x7d0/0x7d0 [vxlan]
[  213.554119]  ? __netlink_ns_capable+0xc3/0xf0
[  213.554119]  __rtnl_newlink+0xb75/0x1180
[  213.554119]  ? rtnl_link_unregister+0x230/0x230
[ ... ]

Fixes: 0241b836732f ("vxlan: fix default fdb entry netlink notify ordering during netdev create")
Suggested-by: Roopa Prabhu <roopa@cumulusnetworks.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2 :
 - Add a new function vxlan_fdb_link().
 - Fix fdb entry leak.
 - Update description.

 drivers/net/vxlan.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 083f3f0bf37f..4066346d6f41 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -804,6 +804,14 @@ static struct vxlan_fdb *vxlan_fdb_alloc(struct vxlan_dev *vxlan,
 	return f;
 }
 
+static void vxlan_fdb_link(struct vxlan_dev *vxlan, const u8 *mac,
+			   __be32 src_vni, struct vxlan_fdb *f)
+{
+	++vxlan->addrcnt;
+	hlist_add_head_rcu(&f->hlist,
+			   vxlan_fdb_head(vxlan, mac, src_vni));
+}
+
 static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 			    const u8 *mac, union vxlan_addr *ip,
 			    __u16 state, __be16 port, __be32 src_vni,
@@ -829,10 +837,6 @@ static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 		return rc;
 	}
 
-	++vxlan->addrcnt;
-	hlist_add_head_rcu(&f->hlist,
-			   vxlan_fdb_head(vxlan, mac, src_vni));
-
 	*fdb = f;
 
 	return 0;
@@ -977,6 +981,7 @@ static int vxlan_fdb_update_create(struct vxlan_dev *vxlan,
 	if (rc < 0)
 		return rc;
 
+	vxlan_fdb_link(vxlan, mac, src_vni, f);
 	rc = vxlan_fdb_notify(vxlan, f, first_remote_rtnl(f), RTM_NEWNEIGH,
 			      swdev_notify, extack);
 	if (rc)
@@ -3571,12 +3576,17 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	if (err)
 		goto errout;
 
-	/* notify default fdb entry */
 	if (f) {
+		vxlan_fdb_link(vxlan, all_zeros_mac,
+			       vxlan->default_dst.remote_vni, f);
+
+		/* notify default fdb entry */
 		err = vxlan_fdb_notify(vxlan, f, first_remote_rtnl(f),
 				       RTM_NEWNEIGH, true, extack);
-		if (err)
-			goto errout;
+		if (err) {
+			vxlan_fdb_destroy(vxlan, f, false, false);
+			goto unregister;
+		}
 	}
 
 	list_add(&vxlan->next, &vn->vxlan_list);
@@ -3588,7 +3598,8 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 	 * destroy the entry by hand here.
 	 */
 	if (f)
-		vxlan_fdb_destroy(vxlan, f, false, false);
+		call_rcu(&f->rcu, vxlan_fdb_free);
+unregister:
 	if (unregister)
 		unregister_netdevice(dev);
 	return err;
-- 
2.17.1

