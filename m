Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECB9B3C59
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 16:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388586AbfIPORI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Sep 2019 10:17:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47731 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfIPORH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 10:17:07 -0400
Received: from static-dcd-cqq-121001.business.bouyguestelecom.com ([212.194.121.1] helo=nyx.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1i9roB-00070y-KZ; Mon, 16 Sep 2019 14:16:51 +0000
Received: by nyx.localdomain (Postfix, from userid 1000)
        id 57B2D2415B1; Mon, 16 Sep 2019 16:16:51 +0200 (CEST)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id 514ED289C56;
        Mon, 16 Sep 2019 16:16:51 +0200 (CEST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Taehee Yoo <ap420073@gmail.com>
cc:     davem@davemloft.net, netdev@vger.kernel.org, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com
Subject: Re: [PATCH net v3 03/11] bonding: fix unexpected IFF_BONDING bit unset
In-reply-to: <20190916134802.8252-4-ap420073@gmail.com>
References: <20190916134802.8252-1-ap420073@gmail.com> <20190916134802.8252-4-ap420073@gmail.com>
Comments: In-reply-to Taehee Yoo <ap420073@gmail.com>
   message dated "Mon, 16 Sep 2019 22:47:54 +0900."
X-Mailer: MH-E 8.5+bzr; nmh 1.7.1-RC3; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25559.1568643411.1@nyx>
Content-Transfer-Encoding: 8BIT
Date:   Mon, 16 Sep 2019 16:16:51 +0200
Message-ID: <25560.1568643411@nyx>
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
>[   58.210981] proc_dir_entry 'bonding/bond1' already registered
>[   58.463875] WARNING: CPU: 0 PID: 955 at fs/proc/generic.c:361 proc_register+0x2a9/0x3e0
>[   58.466423] Modules linked in: bonding veth openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nfs
>[   58.483855] CPU: 0 PID: 955 Comm: ip Not tainted 5.3.0-rc8+ #179
>[   58.484657] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
>[   58.485779] RIP: 0010:proc_register+0x2a9/0x3e0
>[   58.486377] Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 39 01 00 00 48 8b 04 24 48 89 ea 48 c7 c7 60 0f 14 bd 480
>[   58.489003] RSP: 0018:ffff8880cc007078 EFLAGS: 00010282
>[   58.553743] RAX: dffffc0000000008 RBX: ffff8880ce23c0d0 RCX: ffffffffbbd021e2
>[   58.584076] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffff8880da5f6b8c
>[   58.584901] RBP: ffff8880ce23c353 R08: ffffed101b4bff91 R09: ffffed101b4bff91
>[   58.585724] R10: 0000000000000001 R11: ffffed101b4bff90 R12: ffff8880ce23c268
>[   58.586508] R13: ffff8880ce23c352 R14: dffffc0000000000 R15: ffffed1019c4786a
>[   58.587296] FS:  00007f52d53b60c0(0000) GS:ffff8880da400000(0000) knlGS:0000000000000000
>[   58.588247] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[   58.653694] CR2: 00007f31a9df9320 CR3: 00000000cd4ea006 CR4: 00000000000606f0
>[   58.654591] Call Trace:
>[   58.654895]  proc_create_seq_private+0xb3/0xf0
>[   58.655400]  bond_create_proc_entry+0x1b3/0x3f0 [bonding]
>[   58.655985]  bond_netdev_event+0x433/0x970 [bonding]
>[   58.656545]  ? __module_text_address+0x13/0x140
>[   58.657038]  notifier_call_chain+0x90/0x160
>[   58.657541]  register_netdevice+0x9b3/0xd80
>[   58.657999]  ? alloc_netdev_mqs+0x854/0xc10
>[   58.658476]  ? netdev_change_features+0xa0/0xa0
>[   58.663592]  ? rtnl_create_link+0x2ed/0xad0
>[   58.664049]  bond_newlink+0x2a/0x60 [bonding]
>[   58.664529]  __rtnl_newlink+0xb9f/0x11b0
>[   58.665014]  ? rtnl_link_unregister+0x230/0x230
>[ ... ]
>
>Fixes: 0b680e753724 ("[PATCH] bonding: Add priv_flag to avoid event mishandling")
>Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>


>---
>
>v2 -> v3 :
> - This patch is not changed
>v1 -> v2 :
> - Do not add a new priv_flag.
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
