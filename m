Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B10606200
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJTNlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiJTNli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:41:38 -0400
X-Greylist: delayed 902 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 Oct 2022 06:41:26 PDT
Received: from rp02.intra2net.com (rp02.intra2net.com [62.75.181.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B685E1A7A0D
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 06:41:25 -0700 (PDT)
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by rp02.intra2net.com (Postfix) with ESMTPS id 3EE3B100133;
        Thu, 20 Oct 2022 15:16:04 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id 0F85E723;
        Thu, 20 Oct 2022 15:16:04 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.64.212,VDF=8.19.26.100)
X-Spam-Status: 
Received: from localhost (storm.m.i2n [172.16.1.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id B146670D;
        Thu, 20 Oct 2022 15:16:02 +0200 (CEST)
Date:   Thu, 20 Oct 2022 15:16:02 +0200
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, Tobias Brunner <tobias@strongswan.org>
Subject: Re: [PATCH RFC ipsec] xfrm: fix panic in xfrm_delete from userspace
 on ARM 32
Message-ID: <20221020131602.5gzed3e6jrfbaeps@intra2net.com>
References: <00959f33ee52c4b3b0084d42c430418e502db554.1652340703.git.antony.antony@secunet.com>
 <Yn1J20HaaXeOjhLk@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yn1J20HaaXeOjhLk@unreal>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

You wrote on Thu, May 12, 2022 at 08:54:35PM +0300:
> On Thu, May 12, 2022 at 09:44:57AM +0200, Antony Antony wrote:
> > A kernel panic was reported on ARM 32 architecture.
> > In spite of initialization, x = kmem_cache_zalloc(xfrm_state_cache, GFP_ATOMIC),
> > x->mapping_maxage appears to be nozero and cause kernel panic in
> > xfrm_state_delete().
> > 
> > https://github.com/strongswan/strongswan/issues/992
> > 
> > (__xfrm_state_delete) from [<c091ad58>] (xfrm_state_delete+0x24/0x44)
> > (xfrm_state_delete) from [<bf4c31e4>] (xfrm_del_sa+0x94/0xe4 [xfrm_user])
> > (xfrm_del_sa [xfrm_user]) from [<bf4c2180>] (xfrm_user_rcv_msg+0xe0/0x1d0 [xfrm_user])
> > (xfrm_user_rcv_msg [xfrm_user]) from [<c0878da4>] (netlink_rcv_skb+0xd8/0x148)
> > (netlink_rcv_skb) from [<bf4c1724>] (xfrm_netlink_rcv+0x2c/0x48 [xfrm_user])
> > (xfrm_netlink_rcv [xfrm_user]) from [<c0878408>] (netlink_unicast+0x208/0x31c)
> > (netlink_unicast) from [<c0878710>] (netlink_sendmsg+0x1f4/0x468)
> > (netlink_sendmsg) from [<c07e1408>] (__sys_sendto+0xd4/0x13c)
> > 
> > Even if x->mapping_maxage is non zero I can't explain the cause of panic.
> > However, roth-m reports setting  x->mapping_maxage = 0 fix the panic!
> > 
> > I am still not sure of the cause. So I proposing the fix as an RFC.
> 
> We all know that it can't be a fix. It is hard to judge by this
> calltrace, but it looks like something in x->km is not set. It is
> probably ".all" field.

we just upgraded from 4.19.250 to 5.15.73 and crashed our main VPN gateway twice :o)

The callstack is exactly the same as above, this time on x86_64.

On the second crash we had the serial console ready,
but the kernel was compiled without CONFIG_DEBUG_INFO.
I've recompiled the kernel with debug info now and wait for another crash.

Once the system crashes, even the magic sysrq (over serial) stops working.

We already had the suspicion it's related to IPSec since once we booted
kernel 5.15 on our main gateway, it took ~10 minutes until it crashed
(passed all QA tests before...) and during this time quite a few VPN tunnels
were reestablished - at least two of them behind NAT. Fits the picture above.

This is the backtrace so far:
**************************************
BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 80000001209d1067 P4D 80000001209d1067 PUD 10cdbf067 PMD 0
ops: 0002 [#1] SMP PTI
CPU: 3 PID: 5084 Comm: pluto Not tainted 5.15.73-2.i2n.x86_64 #1
Hardware name: HP ProLiant DL320e Gen8 v2, BIOS P80 09/01/2013
RIP: 0010:__xfrm_state_delete+0xc9/0x1c0
Code: 02 48 85 c0 74 04 48 89 50 08 48 b8 22 01 00 00 00 00 ad de 8b 93 cc 00 00 00 48 89 43 20 85 d2 74 22 48 8b 43 38 48 8b 53 40 <48> 89 02 48 85 c0 74 04
RSP: 0018:ffffba69403e7a88 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffa27c154b53c0 RCX: dead000000000122
RDX: 0000000000000000 RSI: ffffa27c154b5478 RDI: ffffa27c154b5478
RBP: ffffba69403e7aa0 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000002 R11: 0000000000000032 R12: ffffffff833f8280
R13: ffffa27c1e25e800 R14: ffffffffc07911d0 R15: ffffa27c1e25e800
FS:  00007f9b647de700(0000) GS:ffffa27f0f4c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000120ad8005 CR4: 00000000001706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 xfrm_state_delete+0x1e/0x40
 xfrm_del_sa+0xb0/0x110 [xfrm_user]
 xfrm_user_rcv_msg+0x12d/0x270 [xfrm_user]
 ? remove_entity_load_avg+0x8a/0xa0
 ? copy_to_user_state_extra+0x580/0x580 [xfrm_user]
 netlink_rcv_skb+0x51/0x100
 xfrm_netlink_rcv+0x30/0x50 [xfrm_user]
 netlink_unicast+0x1a6/0x270
 netlink_sendmsg+0x22a/0x480
 __sys_sendto+0x1a6/0x1c0
 ? __audit_syscall_entry+0xd8/0x130
 ? __audit_syscall_exit+0x249/0x2b0
 __x64_sys_sendto+0x23/0x30
 do_syscall_64+0x3a/0x90
 entry_SYSCALL_64_after_hwframe+0x61/0xcb
RIP: 0033:0x7f9b63d617a3
Code: 49 89 ca b8 2c 00 00 00 0f 05 48 3d 01 f0 ff ff 73 34 c3 48 83 ec 08 e8 6b f6 ff ff 48 89 04 24 49 89 ca b8 2c 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8
RSP: 002b:00007ffde90fc570 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007ffde90fc5b4 RCX: 00007f9b63d617a3
RDX: 0000000000000028 RSI: 00007ffde90fd670 RDI: 000000000000000d
RBP: 0000000000000000 R08: 00007ffde90fc5b4 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000028
R13: 0000000000a8f140 R14: 0000000000a8ed40 R15: 00007ffde90fd670
 </TASK>

Modules linked in: jitterentropy_rng drbg authenc echainiv deflate ctr twofish_generic twofish_common camellia_generic serpent_generic blowfish_generic blowf
 sysfillrect syscopyarea hwmon i2c_core sg hpwdt button rtc_cmos crc32c_intel crc32c_generic ext4 jbd2 mbcache crc16 ahci libahci ehci_pci libata ehci_hcd uh
CR2: 0000000000000000
---[ end trace 5d6473ab40739a08 ]---
RIP: 0010:__xfrm_state_delete+0xc9/0x1c0
Code: 02 48 85 c0 74 04 48 89 50 08 48 b8 22 01 00 00 00 00 ad de 8b 93 cc 00 00 00 48 89 43 20 85 d2 74 22 48 8b 43 38 48 8b 53 40 <48> 89 02 48 85 c0 74 04
RSP: 0018:ffffba69403e7a88 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffa27c154b53c0 RCX: dead000000000122
RDX: 0000000000000000 RSI: ffffa27c154b5478 RDI: ffffa27c154b5478
RBP: ffffba69403e7aa0 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000002 R11: 0000000000000032 R12: ffffffff833f8280
R13: ffffa27c1e25e800 R14: ffffffffc07911d0 R15: ffffa27c1e25e800
FS:  00007f9b647de700(0000) GS:ffffa27f0f4c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000120ad8005 CR4: 00000000001706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Kernel panic - not syncing: Fatal exception in interrupt
Kernel Offset: 0x1400000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
Rebooting in 480 seconds..
**************************************

I had to remove one or two unrelated log lines since once the kernel noticed
the Oops, the log level of the serial console was increased and also logged 
unrelated messages in between. So hopefully I didn't remove anything vital.

Also no further syslog output related to VPN is visible upon crash.

HTH,
Thomas
