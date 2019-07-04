Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B88235F681
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 12:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfGDKWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 06:22:15 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:50768 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727303AbfGDKWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 06:22:14 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 94CFD201BE;
        Thu,  4 Jul 2019 12:22:12 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XnNP8JPzlgeW; Thu,  4 Jul 2019 12:22:11 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3A805200AC;
        Thu,  4 Jul 2019 12:22:11 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 4 Jul 2019
 12:22:10 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 8EAFE31804EF;
 Thu,  4 Jul 2019 12:22:10 +0200 (CEST)
Date:   Thu, 4 Jul 2019 12:22:10 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        Benedict Wong <benedictwong@google.com>,
        Shannon Nelson <shannon.nelson@oracle.com>,
        Antony Antony <antony@phenome.org>,
        Eyal Birger <eyal.birger@gmail.com>,
        Julien Floret <julien.floret@6wind.com>
Subject: Re: [PATCH ipsec v2] xfrm interface: fix memory leak on creation
Message-ID: <20190704102210.GK17989@gauss3.secunet.de>
References: <20190702155139.11399-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190702155139.11399-1-nicolas.dichtel@6wind.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 05:51:39PM +0200, Nicolas Dichtel wrote:
> The following commands produce a backtrace and return an error but the xfrm
> interface is created (in the wrong netns):
> $ ip netns add foo
> $ ip netns add bar
> $ ip -n foo netns set bar 0
> $ ip -n foo link add xfrmi0 link-netnsid 0 type xfrm dev lo if_id 23
> RTNETLINK answers: Invalid argument
> $ ip -n bar link ls xfrmi0
> 2: xfrmi0@lo: <NOARP,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/none 00:00:00:00:00:00 brd 00:00:00:00:00:00
> 
> Here is the backtrace:
> [   79.879174] WARNING: CPU: 0 PID: 1178 at net/core/dev.c:8172 rollback_registered_many+0x86/0x3c1
> [   79.880260] Modules linked in: xfrm_interface nfsv3 nfs_acl auth_rpcgss nfsv4 nfs lockd grace sunrpc fscache button parport_pc parport serio_raw evdev pcspkr loop ext4 crc16 mbcache jbd2 crc32c_generic ide_cd_mod ide_gd_mod cdrom ata_$
> eneric ata_piix libata scsi_mod 8139too piix psmouse i2c_piix4 ide_core 8139cp mii i2c_core floppy
> [   79.883698] CPU: 0 PID: 1178 Comm: ip Not tainted 5.2.0-rc6+ #106
> [   79.884462] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
> [   79.885447] RIP: 0010:rollback_registered_many+0x86/0x3c1
> [   79.886120] Code: 01 e8 d7 7d c6 ff 0f 0b 48 8b 45 00 4c 8b 20 48 8d 58 90 49 83 ec 70 48 8d 7b 70 48 39 ef 74 44 8a 83 d0 04 00 00 84 c0 75 1f <0f> 0b e8 61 cd ff ff 48 b8 00 01 00 00 00 00 ad de 48 89 43 70 66
> [   79.888667] RSP: 0018:ffffc900015ab740 EFLAGS: 00010246
> [   79.889339] RAX: ffff8882353e5700 RBX: ffff8882353e56a0 RCX: ffff8882353e5710
> [   79.890174] RDX: ffffc900015ab7e0 RSI: ffffc900015ab7e0 RDI: ffff8882353e5710
> [   79.891029] RBP: ffffc900015ab7e0 R08: ffffc900015ab7e0 R09: ffffc900015ab7e0
> [   79.891866] R10: ffffc900015ab7a0 R11: ffffffff82233fec R12: ffffc900015ab770
> [   79.892728] R13: ffffffff81eb7ec0 R14: ffff88822ed6cf00 R15: 00000000ffffffea
> [   79.893557] FS:  00007ff350f31740(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
> [   79.894581] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   79.895317] CR2: 00000000006c8580 CR3: 000000022c272000 CR4: 00000000000006f0
> [   79.896137] Call Trace:
> [   79.896464]  unregister_netdevice_many+0x12/0x6c
> [   79.896998]  __rtnl_newlink+0x6e2/0x73b
> [   79.897446]  ? __kmalloc_node_track_caller+0x15e/0x185
> [   79.898039]  ? pskb_expand_head+0x5f/0x1fe
> [   79.898556]  ? stack_access_ok+0xd/0x2c
> [   79.899009]  ? deref_stack_reg+0x12/0x20
> [   79.899462]  ? stack_access_ok+0xd/0x2c
> [   79.899927]  ? stack_access_ok+0xd/0x2c
> [   79.900404]  ? __module_text_address+0x9/0x4f
> [   79.900910]  ? is_bpf_text_address+0x5/0xc
> [   79.901390]  ? kernel_text_address+0x67/0x7b
> [   79.901884]  ? __kernel_text_address+0x1a/0x25
> [   79.902397]  ? unwind_get_return_address+0x12/0x23
> [   79.903122]  ? __cmpxchg_double_slab.isra.37+0x46/0x77
> [   79.903772]  rtnl_newlink+0x43/0x56
> [   79.904217]  rtnetlink_rcv_msg+0x200/0x24c
> 
> In fact, each time a xfrm interface was created, a netdev was allocated
> by __rtnl_newlink()/rtnl_create_link() and then another one by
> xfrmi_newlink()/xfrmi_create(). Only the second one was registered, it's
> why the previous commands produce a backtrace: dev_change_net_namespace()
> was called on a netdev with reg_state set to NETREG_UNINITIALIZED (the
> first one).
> 
> CC: Lorenzo Colitti <lorenzo@google.com>
> CC: Benedict Wong <benedictwong@google.com>
> CC: Steffen Klassert <steffen.klassert@secunet.com>
> CC: Shannon Nelson <shannon.nelson@oracle.com>
> CC: Antony Antony <antony@phenome.org>
> CC: Eyal Birger <eyal.birger@gmail.com>
> Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
> Reported-by: Julien Floret <julien.floret@6wind.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied, thanks a lot!
