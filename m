Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5D8C2733
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731051AbfI3UtW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Sep 2019 16:49:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38043 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfI3UtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:49:22 -0400
Received: from c-67-160-6-8.hsd1.wa.comcast.net ([67.160.6.8] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1iF2bI-0001tC-QZ; Mon, 30 Sep 2019 20:48:57 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 1390C5FF6C; Mon, 30 Sep 2019 13:48:55 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 0BA3EA9BF8;
        Mon, 30 Sep 2019 13:48:55 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Taehee Yoo <ap420073@gmail.com>
cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, jakub.kicinski@netronome.com,
        johannes@sipsolutions.net, vfalico@gmail.com, andy@greyhouse.net,
        jiri@resnulli.us, sd@queasysnail.net, roopa@cumulusnetworks.com,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        stephen@networkplumber.org, sashal@kernel.org, hare@suse.de,
        varun@chelsio.com, ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        schuffelen@google.com, bjorn@mork.no
Subject: Re: [PATCH net v4 03/12] bonding: fix unexpected IFF_BONDING bit unset
In-reply-to: <20190928164843.31800-4-ap420073@gmail.com>
References: <20190928164843.31800-1-ap420073@gmail.com> <20190928164843.31800-4-ap420073@gmail.com>
Comments: In-reply-to Taehee Yoo <ap420073@gmail.com>
   message dated "Sat, 28 Sep 2019 16:48:34 -0000."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <26314.1569876535.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Mon, 30 Sep 2019 13:48:55 -0700
Message-ID: <26315.1569876535@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Taehee Yoo <ap420073@gmail.com> wrote:

>The IFF_BONDING means bonding master or bonding slave device.
>->ndo_add_slave() sets IFF_BONDING flag and ->ndo_del_slave() unsets
>IFF_BONDING flag.
>
>bond0<--bond1
>
>Both bond0 and bond1 are bonding device and these should keep having
>IFF_BONDING flag until they are removed.
>But bond1 would lose IFF_BONDING at ->ndo_del_slave() because that routine
>do not check whether the slave device is the bonding type or not.
>This patch adds the interface type check routine before removing
>IFF_BONDING flag.
>
>Test commands:
>    ip link add bond0 type bond
>    ip link add bond1 type bond
>    ip link set bond1 master bond0
>    ip link set bond1 nomaster
>    ip link del bond1 type bond
>    ip link add bond1 type bond
>
>Splat looks like:
>[   38.843933] proc_dir_entry 'bonding/bond1' already registered                                                         
>[   38.844741] WARNING: CPU: 1 PID: 631 at fs/proc/generic.c:361 proc_register+0x2a9/0x3e0                               
>[   38.845741] Modules linked in: bonding ip_tables x_tables                                                             
>[   38.846432] CPU: 1 PID: 631 Comm: ip Not tainted 5.3.0+ #3                                                            
>[   38.847234] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006                             
>[   38.848489] RIP: 0010:proc_register+0x2a9/0x3e0                                                                       
>[   38.849164] Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 39 01 00 00 48 8b 04 24 48 89 ea 48 c7 c7 e0 2b 34 b3 48 8b b0 e
>0 00 00 00 e8 c7 b6 89 ff <0f> 0b 48 c7 c7 40 3d c5 b3 e8 99 7a 38 01 48 8b 4c 24 10 48 b8 00                            
>[   38.851317] RSP: 0018:ffff888061527078 EFLAGS: 00010282
>[   38.851902] RAX: dffffc0000000008 RBX: ffff888064dc8cb0 RCX: ffffffffb1d252a2
>[   38.852684] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff88806cbf6b8c
>[   38.853464] RBP: ffff888064dc8f33 R08: ffffed100d980019 R09: ffffed100d980019
>[   38.854242] R10: 0000000000000001 R11: ffffed100d980018 R12: ffff888064dc8e48
>[   38.855929] R13: ffff888064dc8f32 R14: dffffc0000000000 R15: ffffed100c9b91e6
>[   38.856695] FS:  00007fc9fcc230c0(0000) GS:ffff88806ca00000(0000) knlGS:0000000000000000
>[   38.857541] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[   38.858150] CR2: 000055948b91c118 CR3: 0000000057110006 CR4: 00000000000606e0
>[   38.858957] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>[   38.859785] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>[   38.860700] Call Trace:                             
>[   38.861004]  proc_create_seq_private+0xb3/0xf0
>[   38.861460]  bond_create_proc_entry+0x1b3/0x3f0 [bonding]
>[   38.862113]  bond_netdev_event+0x433/0x970 [bonding]
>[   38.862762]  ? __module_text_address+0x13/0x140
>[   38.867678]  notifier_call_chain+0x90/0x160
>[   38.868257]  register_netdevice+0x9b3/0xd80
>[   38.868791]  ? alloc_netdev_mqs+0x854/0xc10  
>[   38.869335]  ? netdev_change_features+0xa0/0xa0
>[   38.869852]  ? rtnl_create_link+0x2ed/0xad0
>[   38.870423]  bond_newlink+0x2a/0x60 [bonding]
>[   38.870935]  __rtnl_newlink+0xb9f/0x11b0
>[ ... ]
>Fixes: 0b680e753724 ("[PATCH] bonding: Add priv_flag to avoid event mishandling")
>Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>

>---
>
>v2 -> v4 :
> - This patch is not changed
>v1 -> v2 :
>  - Do not add a new priv_flag.
>
> drivers/net/bonding/bond_main.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 931d9d935686..0db12fcfc953 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1816,7 +1816,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> 	slave_disable_netpoll(new_slave);
> 
> err_close:
>-	slave_dev->priv_flags &= ~IFF_BONDING;
>+	if (!netif_is_bond_master(slave_dev))
>+		slave_dev->priv_flags &= ~IFF_BONDING;
> 	dev_close(slave_dev);
> 
> err_restore_mac:
>@@ -2017,7 +2018,8 @@ static int __bond_release_one(struct net_device *bond_dev,
> 	else
> 		dev_set_mtu(slave_dev, slave->original_mtu);
> 
>-	slave_dev->priv_flags &= ~IFF_BONDING;
>+	if (!netif_is_bond_master(slave_dev))
>+		slave_dev->priv_flags &= ~IFF_BONDING;
> 
> 	bond_free_slave(slave);
> 
>-- 
>2.17.1
>
