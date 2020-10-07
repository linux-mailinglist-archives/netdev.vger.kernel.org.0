Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5CC2858A5
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 08:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgJGG17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 02:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgJGG17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 02:27:59 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9B30206F0;
        Wed,  7 Oct 2020 06:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602052078;
        bh=HvKM/5mrBEtK9U0bZHFZTSm86pWu8D5grViHfRuNPNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ouRi779x1PbrzCw7QS9+tIdPjOROFgrh4E+UVe2g5yzPQzyXa5n/9k0XQsL62xS8T
         xVqJLk1VUstRDqhs+7MH62WMPzAbCIevfikI1hw7f0ZO5v/xeL5cvysk1wxocz8qt4
         C6pOo5bCUtMD8BDuH/lfNrhHyO8wyTWc4ppA1CWY=
Date:   Wed, 7 Oct 2020 09:27:54 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, mkubecek@suse.cz,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v2 0/7] ethtool: allow dumping policies to user
 space
Message-ID: <20201007062754.GU1874917@unreal>
References: <20201005220739.2581920-1-kuba@kernel.org>
 <7586c9e77f6aa43e598103ccc25b43415752507d.camel@sipsolutions.net>
 <20201006.062618.628708952352439429.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006.062618.628708952352439429.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 06:26:18AM -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Tue, 06 Oct 2020 08:43:17 +0200
>
> > On Mon, 2020-10-05 at 15:07 -0700, Jakub Kicinski wrote:
> >> Hi!
> >>
> >> This series wires up ethtool policies to ops, so they can be
> >> dumped to user space for feature discovery.
> >>
> >> First patch wires up GET commands, and second patch wires up SETs.
> >>
> >> The policy tables are trimmed to save space and LoC.
> >>
> >> Next - take care of linking up nested policies for the header
> >> (which is the policy what we actually care about). And once header
> >> policy is linked make sure that attribute range validation for flags
> >> is done by policy, not a conditions in the code. New type of policy
> >> is needed to validate masks (patch 6).
> >>
> >> Netlink as always staying a step ahead of all the other kernel
> >> API interfaces :)
>  ...
> > Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
>
> Series applied, thanks everyone.

Hi Dave, Johannes and Jakub

This series and my guess that it comes from ff419afa4310 ("ethtool: trim policy tables")
generates the following KASAN out-of-bound error.

 [ 187.278416] ==================================================================
 [  187.282872] BUG: KASAN: slab-out-of-bounds in strset_parse_request+0x3ef/0x480
 [  187.284499] Read of size 8 at addr ffff88828db2b158 by task ethtool/3949
 [  187.285927]
 [  187.286406] CPU: 0 PID: 3949 Comm: ethtool Not tainted 5.9.0-rc8_master_8f9ef66 #1
 [  187.288135] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
 [  187.290526] Call Trace:
 [  187.291190]  dump_stack+0x9a/0xd0
 [  187.292028]  ? strset_parse_request+0x3ef/0x480
 [  187.293069]  print_address_description.constprop.0+0x1c/0x220
 [  187.294331]  ? nla_get_range_signed+0x540/0x540
 [  187.295373]  ? strset_parse_request+0x3ef/0x480
 [  187.296421]  ? strset_parse_request+0x3ef/0x480
 [  187.297458]  kasan_report.cold+0x1f/0x37
 [  187.298387]  ? strset_parse_request+0x3ef/0x480
 [  187.299422]  strset_parse_request+0x3ef/0x480
 [  187.300434]  ? ethnl_default_dumpit+0xcd0/0xcd0
 [  187.301483]  ? strset_cleanup_data+0xd0/0xd0
 [  187.302489]  ethnl_default_parse+0xb3/0x110
 [  187.303476]  ethnl_default_doit+0x223/0x950
 [  187.304454]  ? ethnl_reply_init+0x1b0/0x1b0
 [  187.305433]  ? __nla_parse+0x22/0x25
 [  187.306292]  ? genl_family_rcv_msg_attrs_parse.constprop.0+0x15e/0x230
 [  187.307708]  genl_family_rcv_msg_doit+0x1e9/0x2f0
 [  187.308797]  ? genl_family_rcv_msg_attrs_parse.constprop.0+0x230/0x230
 [  187.310218]  ? register_lock_class+0x1650/0x1650
 [  187.311273]  genl_rcv_msg+0x27f/0x4a0
 [  187.312166]  ? genl_get_cmd+0x3c0/0x3c0
 [  187.313074]  ? lock_acquire+0x1da/0x9c0
 [  187.313978]  ? genl_rcv+0x15/0x40
 [  187.314788]  ? ethnl_reply_init+0x1b0/0x1b0
 [  187.315766]  ? ethnl_default_parse+0x110/0x110
 [  187.316781]  ? ethnl_fill_reply_header.part.0+0x2d0/0x2d0
 [  187.317998]  ? get_order+0x20/0x20
 [  187.318840]  ? check_flags+0x60/0x60
 [  187.319712]  netlink_rcv_skb+0x124/0x350
 [  187.320642]  ? genl_get_cmd+0x3c0/0x3c0
 [  187.321558]  ? netlink_ack+0x8b0/0x8b0
 [  187.322462]  ? __might_fault+0xef/0x1a0
 [  187.323383]  genl_rcv+0x24/0x40
 [  187.324199]  netlink_unicast+0x433/0x700
 [  187.325157]  ? netlink_attachskb+0x6f0/0x6f0
 [  187.326151]  ? __alloc_skb+0x32a/0x530
 [  187.327048]  netlink_sendmsg+0x6f1/0xbd0
 [  187.328010]  ? netlink_unicast+0x700/0x700
 [  187.328996]  ? netlink_unicast+0x700/0x700
 [  187.329953]  sock_sendmsg+0xb0/0xe0
 [  187.330824]  __sys_sendto+0x193/0x240
 [  187.331736]  ? __x64_sys_getpeername+0xb0/0xb0
 [  187.332781]  ? do_raw_spin_unlock+0x54/0x220
 [  187.333794]  ? __up_read+0x1a1/0x7b0
 [  187.334738]  __x64_sys_sendto+0xdd/0x1b0
 [  187.335718]  ? syscall_enter_from_user_mode+0x1d/0x50
 [  187.336889]  do_syscall_64+0x2d/0x40
 [  187.337744]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 [  187.338949] RIP: 0033:0x7fe429352efa
 [  187.339870] Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 f3 0f 1e fa 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 76 c3 0f 1f 44 00 00 55 48 83 ec 30 44 89 4c
 [  187.343971] RSP: 002b:00007ffc105fc268 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
 [  187.345764] RAX: ffffffffffffffda RBX: 000000000198c430 RCX: 00007fe429352efa
 [  187.347386] RDX: 0000000000000028 RSI: 000000000198c4a0 RDI: 0000000000000004
 [  187.349015] RBP: 000000000198c4a0 R08: 00007fe42941e000 R09: 000000000000000c
 [  187.350637] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000042f4f0
 [  187.352239] R13: 000000000197c3a0 R14: 000000000197c2a0 R15: 000000000197c3a0
 [  187.353791]
 [  187.354283] Allocated by task 3949:
 [  187.355145]  kasan_save_stack+0x1b/0x40
 [  187.356067]  __kasan_kmalloc.constprop.0+0xc2/0xd0
 [  187.357182]  genl_family_rcv_msg_attrs_parse.constprop.0+0xb5/0x230
 [  187.358567]  genl_family_rcv_msg_doit+0xc7/0x2f0
 [  187.359651]  genl_rcv_msg+0x27f/0x4a0
 [  187.360519]  netlink_rcv_skb+0x124/0x350
 [  187.361464]  genl_rcv+0x24/0x40
 [  187.362260]  netlink_unicast+0x433/0x700
 [  187.363177]  netlink_sendmsg+0x6f1/0xbd0
 [  187.364096]  sock_sendmsg+0xb0/0xe0
 [  187.364959]  __sys_sendto+0x193/0x240
 [  187.365885]  __x64_sys_sendto+0xdd/0x1b0
 [  187.366797]  do_syscall_64+0x2d/0x40
 [  187.367695]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 [  187.368900]
 [  187.369400] The buggy address belongs to the object at ffff88828db2b140
 [  187.369400]  which belongs to the cache kmalloc-32 of size 32
 [  187.372134] The buggy address is located 24 bytes inside of
 [  187.372134]  32-byte region [ffff88828db2b140, ffff88828db2b160)
 [  187.374713] The buggy address belongs to the page:
 [  187.375884] page:00000000980aee13 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88828db2bc80 pfn:0x28db2b
 [  187.378286] flags: 0x8000000000000200(slab)
 [  187.379318] raw: 8000000000000200 ffffea0009be8a80 0000001b0000001b ffff8882a3043a40
 [  187.381156] raw: ffff88828db2bc80 0000000080400039 00000001ffffffff 0000000000000000
 [  187.382973] page dumped because: kasan: bad access detected
 [  187.384252]
 [  187.384747] Memory state around the buggy address:
 [  187.385825]  ffff88828db2b000: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
 [  187.387479]  ffff88828db2b080: fb fb fb fb fc fc fc fc 00 00 00 fc fc fc fc fc
 [  187.389103] >ffff88828db2b100: fb fb fb fb fc fc fc fc 00 00 00 fc fc fc fc fc
 [  187.390707]                                                     ^
 [  187.392050]  ffff88828db2b180: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
 [  187.393693]  ffff88828db2b200: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
 [  187.395314] ==================================================================
