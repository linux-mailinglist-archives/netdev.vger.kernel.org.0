Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0CB32CF5D
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 10:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhCDJKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 04:10:54 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13324 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbhCDJKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 04:10:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6040a3ea0002>; Thu, 04 Mar 2021 01:10:02 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 4 Mar
 2021 09:10:01 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 4 Mar 2021 09:09:50 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <eric.dumazet@gmail.com>,
        <andrew@lunn.ch>, <mkubecek@suse.cz>, <f.fainelli@gmail.com>,
        <acardace@redhat.com>, <irusskikh@marvell.com>,
        <gustavo@embeddedor.com>, <magnus.karlsson@intel.com>,
        <ecree@solarflare.com>, <idosch@nvidia.com>, <jiri@nvidia.com>,
        <mlxsw@nvidia.com>, Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net] ethtool: Add indicator field for link_mode validity to link_ksettings
Date:   Thu, 4 Mar 2021 11:09:33 +0200
Message-ID: <20210304090933.3538255-1-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614849002; bh=yETfaFplCQWdKllUvv8/HYN0gCMLauyj94z6UPsK9uc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=Ru9W+jKwTua5yTYMnhsFt0m7RZk7+HGW2Cdea6YccJxJAp5JgNtcX7GA5gITRL1Oq
         16xmKjQhYa3HU2pF3h/1TQY6StOny0k4bBoonwnBO8UlfOpWn+SnNYk7SIhWV2Liry
         bh0xVOzD2MduPHuHz+0RTvhZWfUdejOfkLEud1uQz7nSq0r6wNlWZoWMMlmgx7wDrx
         M+SQvH30ndobBrU7Ax8cPHokGfT29yMtCBoIloUbqwxn06atTcPskysrUdOkd/w2Us
         GN8KigNWacWxmiOcZwPxf5E0UweLk+lQeEvA5iEOLAqktVYaiRlefmeTTj0VcYd240
         Ulze6DHer4xrg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some drivers clear the 'ethtool_link_ksettings' struct in their
get_link_ksettings() callback, before populating it with actual values.
Such drivers will set the new 'link_mode' field to zero, resulting in
user space receiving wrong link mode information given that zero is a
valid value for the field.

Fix this by introducing a new boolean field ('link_mode_valid'), which
indicates whether the 'link_mode' field is valid or not. Set it in mlxsw
which is currently the only driver supporting the new API.

Another problem is that some drivers (notably tun) can report random
values in the 'link_mode' field. This can result in a general protection
fault when the field is used as an index to the 'link_mode_params' array
[1].

This happens because such drivers implement their set_link_ksettings()
callback by simply overwriting their private copy of
'ethtool_link_ksettings' struct with the one they get from the stack,
which is not always properly initialized.

Fix this by making sure that the new 'link_mode_valid' field is always
initialized to 'false' before invoking the set_link_ksettings()
callback.

[1]
general protection fault, probably for non-canonical address 0xdffffc00f14c=
c32c: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x000000078a661960-0x000000078=
a661967]
CPU: 0 PID: 8452 Comm: syz-executor360 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 01/01/2011
RIP: 0010:__ethtool_get_link_ksettings+0x1a3/0x3a0 net/ethtool/ioctl.c:446
Code: b7 3e fa 83 fd ff 0f 84 30 01 00 00 e8 16 b0 3e fa 48 8d 3c ed 60 d5 =
69 8a 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 8=
9 f8 83 e0 07 83 c0 03
+38 d0 7c 08 84 d2 0f 85 b9
RSP: 0018:ffffc900019df7a0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888026136008 RCX: 0000000000000000
RDX: 00000000f14cc32c RSI: ffffffff873439ca RDI: 000000078a661960
RBP: 00000000ffff8880 R08: 00000000ffffffff R09: ffff88802613606f
R10: ffffffff873439bc R11: 0000000000000000 R12: 0000000000000000
R13: ffff88802613606c R14: ffff888011d0c210 R15: ffff888011d0c210
FS:  0000000000749300(0000) GS:ffff8880b9c00000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004b60f0 CR3: 00000000185c2000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 linkinfo_prepare_data+0xfd/0x280 net/ethtool/linkinfo.c:37
 ethnl_default_notify+0x1dc/0x630 net/ethtool/netlink.c:586
 ethtool_notify+0xbd/0x1f0 net/ethtool/netlink.c:656
 ethtool_set_link_ksettings+0x277/0x330 net/ethtool/ioctl.c:620
 dev_ethtool+0x2b35/0x45d0 net/ethtool/ioctl.c:2842
 dev_ioctl+0x463/0xb70 net/core/dev_ioctl.c:440
 sock_do_ioctl+0x148/0x2d0 net/socket.c:1060
 sock_ioctl+0x477/0x6a0 net/socket.c:1177
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: c8907043c6ac9 ("ethtool: Get link mode in use instead of speed and d=
uplex parameters")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c | 9 ++++-----
 include/linux/ethtool.h                                | 1 +
 net/ethtool/ioctl.c                                    | 6 ++++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drive=
rs/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 0bd64169bf81..66eb1cd17bc4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1232,14 +1232,14 @@ mlxsw_sp1_from_ptys_link_mode(struct mlxsw_sp *mlxs=
w_sp, bool carrier_ok,
 {
 	int i;
=20
-	cmd->link_mode =3D -1;
-
 	if (!carrier_ok)
 		return;
=20
 	for (i =3D 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
-		if (ptys_eth_proto & mlxsw_sp1_port_link_mode[i].mask)
+		if (ptys_eth_proto & mlxsw_sp1_port_link_mode[i].mask) {
 			cmd->link_mode =3D mlxsw_sp1_port_link_mode[i].mask_ethtool;
+			cmd->link_mode_valid =3D true;
+		}
 	}
 }
=20
@@ -1672,8 +1672,6 @@ mlxsw_sp2_from_ptys_link_mode(struct mlxsw_sp *mlxsw_=
sp, bool carrier_ok,
 	struct mlxsw_sp2_port_link_mode link;
 	int i;
=20
-	cmd->link_mode =3D -1;
-
 	if (!carrier_ok)
 		return;
=20
@@ -1681,6 +1679,7 @@ mlxsw_sp2_from_ptys_link_mode(struct mlxsw_sp *mlxsw_=
sp, bool carrier_ok,
 		if (ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask) {
 			link =3D mlxsw_sp2_port_link_mode[i];
 			cmd->link_mode =3D link.mask_ethtool[1];
+			cmd->link_mode_valid =3D true;
 		}
 	}
 }
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index ec4cd3921c67..1f11577dc189 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -130,6 +130,7 @@ struct ethtool_link_ksettings {
 	} link_modes;
 	u32	lanes;
 	enum ethtool_link_mode_bit_indices link_mode;
+	bool link_mode_valid;
 };
=20
 /**
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 24783b71c584..5aafa30f07ad 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -436,12 +436,11 @@ int __ethtool_get_link_ksettings(struct net_device *d=
ev,
=20
 	memset(link_ksettings, 0, sizeof(*link_ksettings));
=20
-	link_ksettings->link_mode =3D -1;
 	err =3D dev->ethtool_ops->get_link_ksettings(dev, link_ksettings);
 	if (err)
 		return err;
=20
-	if (link_ksettings->link_mode !=3D -1) {
+	if (link_ksettings->link_mode_valid) {
 		link_info =3D &link_mode_params[link_ksettings->link_mode];
 		link_ksettings->base.speed =3D link_info->speed;
 		link_ksettings->lanes =3D link_info->lanes;
@@ -615,6 +614,8 @@ static int ethtool_set_link_ksettings(struct net_device=
 *dev,
 	    link_ksettings.base.master_slave_state)
 		return -EINVAL;
=20
+	link_ksettings.link_mode_valid =3D false;
+
 	err =3D dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
 	if (err >=3D 0) {
 		ethtool_notify(dev, ETHTOOL_MSG_LINKINFO_NTF, NULL);
@@ -701,6 +702,7 @@ static int ethtool_set_settings(struct net_device *dev,=
 void __user *useraddr)
=20
 	if (!convert_legacy_settings_to_link_ksettings(&link_ksettings, &cmd))
 		return -EINVAL;
+	link_ksettings.link_mode_valid =3D false;
 	link_ksettings.base.link_mode_masks_nwords =3D
 		__ETHTOOL_LINK_MODE_MASK_NU32;
 	ret =3D dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
--=20
2.26.2

