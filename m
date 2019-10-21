Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1875EDF550
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbfJUSsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:48:33 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46191 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfJUSsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:48:33 -0400
Received: by mail-pf1-f195.google.com with SMTP id q5so8957589pfg.13;
        Mon, 21 Oct 2019 11:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u/4BQ/LF3APbUkXGrSYr1EEGzkov+ZD2GnzwyPSlwuQ=;
        b=F9C9AKRK0PtPDnn9sVpv/7on+N0qnE74IrwU6FmbUL3X6I27zbaTAdSFcFVXYnDhif
         9NIC9q28zzRLGSxTvjLgcxZV/DZ/CyRJVLJEN1s43HpBOJqZ+TeHWLcUJrgnUewqqItx
         gKOVMMNaCmP9v1okRIK8M+Rx4bQp0tTbRXc/3XuyCJ34KbgkPQZNe/ow/uKJT7eNfJRU
         V1Yv4VzFZzxUzoIb1+DEWN5lKVno2yFdurzsXetaVSfam8o2nuNWBjKrXQUCVaYLuiSr
         dzyGc2nqAy9ujsDvcGzH79CZxAxMqDL/2wKeymKD8ix2CQpycb6bboCz0BnKOscbjHnX
         LtZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u/4BQ/LF3APbUkXGrSYr1EEGzkov+ZD2GnzwyPSlwuQ=;
        b=SDxYcTAfp3/TzH/VV1P/N8twkpDoo/m0GQyw0Ru/OOCb6bo4xKpNC+2r51nj4RsX6u
         wLGnwBKv34iGG38utvONCB6jLcxB7psEljNm5GS8MDvrdvAsrdWA4tWu0A9gD8BN5sCq
         HJ+KaCxEJLRlmEv070z+5nj4uy0+5VhG1xEoGejLDjpG/wY4qzALWJ1vOvKfHfqHt3FG
         +Xm9v0lEMOb+yEQJILxZxukmGpFXzqAODF3T5N61cd9qAGyO/F5t2iOwzx8735Y9DVB7
         6fm2LiWTBbaG7krgPVcSpj7lI7jC3H7h7ssQbXUy0k/omEuHo3UbsLndcnwnUVTXk61V
         w+Pg==
X-Gm-Message-State: APjAAAU/RS3hsncvhA/vlBo9f6Io7t1pmlqx9VPiW4TcvNCk86zTy1YJ
        F+UVgNDL+nWV54B6aPtpQeM=
X-Google-Smtp-Source: APXvYqye4BEBGC3E1BtSuszBcZz6wdkotcAyqXjs9rB8SVuk2DwxP1VAVIqosuhqkHV+RN92dMjpgA==
X-Received: by 2002:a65:68c2:: with SMTP id k2mr27084254pgt.241.1571683711752;
        Mon, 21 Oct 2019 11:48:31 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id ev20sm14502835pjb.19.2019.10.21.11.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 11:48:30 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, jakub.kicinski@netronome.com,
        johannes@sipsolutions.net, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Cc:     ap420073@gmail.com
Subject: [PATCH net v5 03/10] bonding: fix unexpected IFF_BONDING bit unset
Date:   Mon, 21 Oct 2019 18:47:52 +0000
Message-Id: <20191021184759.13125-3-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021184759.13125-1-ap420073@gmail.com>
References: <20191021184759.13125-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IFF_BONDING means bonding master or bonding slave device.
->ndo_add_slave() sets IFF_BONDING flag and ->ndo_del_slave() unsets
IFF_BONDING flag.

bond0<--bond1

Both bond0 and bond1 are bonding device and these should keep having
IFF_BONDING flag until they are removed.
But bond1 would lose IFF_BONDING at ->ndo_del_slave() because that routine
do not check whether the slave device is the bonding type or not.
This patch adds the interface type check routine before removing
IFF_BONDING flag.

Test commands:
    ip link add bond0 type bond
    ip link add bond1 type bond
    ip link set bond1 master bond0
    ip link set bond1 nomaster
    ip link del bond1 type bond
    ip link add bond1 type bond

Splat looks like:
[  226.665555] proc_dir_entry 'bonding/bond1' already registered
[  226.666440] WARNING: CPU: 0 PID: 737 at fs/proc/generic.c:361 proc_register+0x2a9/0x3e0
[  226.667571] Modules linked in: bonding af_packet sch_fq_codel ip_tables x_tables unix
[  226.668662] CPU: 0 PID: 737 Comm: ip Not tainted 5.4.0-rc3+ #96
[  226.669508] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  226.670652] RIP: 0010:proc_register+0x2a9/0x3e0
[  226.671612] Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 39 01 00 00 48 8b 04 24 48 89 ea 48 c7 c7 a0 0b 14 9f 48 8b b0 e
0 00 00 00 e8 07 e7 88 ff <0f> 0b 48 c7 c7 40 2d a5 9f e8 59 d6 23 01 48 8b 4c 24 10 48 b8 00
[  226.675007] RSP: 0018:ffff888050e17078 EFLAGS: 00010282
[  226.675761] RAX: dffffc0000000008 RBX: ffff88805fdd0f10 RCX: ffffffff9dd344e2
[  226.676757] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff88806c9f6b8c
[  226.677751] RBP: ffff8880507160f3 R08: ffffed100d940019 R09: ffffed100d940019
[  226.678761] R10: 0000000000000001 R11: ffffed100d940018 R12: ffff888050716008
[  226.679757] R13: ffff8880507160f2 R14: dffffc0000000000 R15: ffffed100a0e2c1e
[  226.680758] FS:  00007fdc217cc0c0(0000) GS:ffff88806c800000(0000) knlGS:0000000000000000
[  226.681886] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  226.682719] CR2: 00007f49313424d0 CR3: 0000000050e46001 CR4: 00000000000606f0
[  226.683727] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  226.684725] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  226.685681] Call Trace:
[  226.687089]  proc_create_seq_private+0xb3/0xf0
[  226.687778]  bond_create_proc_entry+0x1b3/0x3f0 [bonding]
[  226.691458]  bond_netdev_event+0x433/0x970 [bonding]
[  226.692139]  ? __module_text_address+0x13/0x140
[  226.692779]  notifier_call_chain+0x90/0x160
[  226.693401]  register_netdevice+0x9b3/0xd80
[  226.694010]  ? alloc_netdev_mqs+0x854/0xc10
[  226.694629]  ? netdev_change_features+0xa0/0xa0
[  226.695278]  ? rtnl_create_link+0x2ed/0xad0
[  226.695849]  bond_newlink+0x2a/0x60 [bonding]
[  226.696422]  __rtnl_newlink+0xb9f/0x11b0
[  226.696968]  ? rtnl_link_unregister+0x220/0x220
[ ... ]

Fixes: 0b680e753724 ("[PATCH] bonding: Add priv_flag to avoid event mishandling")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2 -> v5 :
 - This patch is not changed
v1 -> v2 :
 - Do not add a new priv_flag.

 drivers/net/bonding/bond_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index ac1b09b56c77..92713b93f66f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1816,7 +1816,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	slave_disable_netpoll(new_slave);
 
 err_close:
-	slave_dev->priv_flags &= ~IFF_BONDING;
+	if (!netif_is_bond_master(slave_dev))
+		slave_dev->priv_flags &= ~IFF_BONDING;
 	dev_close(slave_dev);
 
 err_restore_mac:
@@ -2017,7 +2018,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 	else
 		dev_set_mtu(slave_dev, slave->original_mtu);
 
-	slave_dev->priv_flags &= ~IFF_BONDING;
+	if (!netif_is_bond_master(slave_dev))
+		slave_dev->priv_flags &= ~IFF_BONDING;
 
 	bond_free_slave(slave);
 
-- 
2.17.1

