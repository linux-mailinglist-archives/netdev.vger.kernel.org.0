Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948236474EE
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLHRUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiLHRUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:20:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806A58C6BD;
        Thu,  8 Dec 2022 09:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0862461FBA;
        Thu,  8 Dec 2022 17:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45001C433EF;
        Thu,  8 Dec 2022 17:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670520016;
        bh=Myhj7x3OBvgAFVFPmiOWGlclDdnOshK5/oKIeoY96S0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q+VZhW2RgvDiCw1aAq6X7BsbeOSUz8A9+NpsavnwH/41iKJ4XirEdjn1duYMsdGI8
         eb5clJ94Ea3hAjG+WuevC/Mp94QZyDaCXPpjrVgzxtDc0Rgkun2+LJwd4c386iu7DP
         gkBhY01vY63VAml3ZTPmqiOoFmHHDp6Q4oWXNxCG7gg78cIc1aU4kLJjuPTr4KTrbV
         gSFLICJXX4wBBM8tVUyXlZ7q0YoMNsWZWCA7xfoi04fJUYWo4B3qZ8KjKzHVbKVDY4
         Aq13mvDgxqXsKEqY3H58QtPtWVMOmmYlNFgj+ylmXUbAYj9L2NjA8rUVHZ58xRbFiZ
         3/MU/UQ4d04zQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 17853C41606;
        Thu,  8 Dec 2022 17:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] s390/qeth: fix use-after-free in hsci
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167052001608.19571.16534020446500665478.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 17:20:16 +0000
References: <20221207105304.20494-1-wintera@linux.ibm.com>
In-Reply-To: <20221207105304.20494-1-wintera@linux.ibm.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, leon@kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        hca@linux.ibm.com, twinkler@linux.ibm.com, wenjia@linux.ibm.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Dec 2022 11:53:04 +0100 you wrote:
> KASAN found that addr was dereferenced after br2dev_event_work was freed.
> 
> ==================================================================
> BUG: KASAN: use-after-free in qeth_l2_br2dev_worker+0x5ba/0x6b0
> Read of size 1 at addr 00000000fdcea440 by task kworker/u760:4/540
> CPU: 17 PID: 540 Comm: kworker/u760:4 Tainted: G            E      6.1.0-20221128.rc7.git1.5aa3bed4ce83.300.fc36.s390x+kasan #1
> Hardware name: IBM 8561 T01 703 (LPAR)
> Workqueue: 0.0.8000_event qeth_l2_br2dev_worker
> Call Trace:
>  [<000000016944d4ce>] dump_stack_lvl+0xc6/0xf8
>  [<000000016942cd9c>] print_address_description.constprop.0+0x34/0x2a0
>  [<000000016942d118>] print_report+0x110/0x1f8
>  [<0000000167a7bd04>] kasan_report+0xfc/0x128
>  [<000000016938d79a>] qeth_l2_br2dev_worker+0x5ba/0x6b0
>  [<00000001673edd1e>] process_one_work+0x76e/0x1128
>  [<00000001673ee85c>] worker_thread+0x184/0x1098
>  [<000000016740718a>] kthread+0x26a/0x310
>  [<00000001672c606a>] __ret_from_fork+0x8a/0xe8
>  [<00000001694711da>] ret_from_fork+0xa/0x40
> Allocated by task 108338:
>  kasan_save_stack+0x40/0x68
>  kasan_set_track+0x36/0x48
>  __kasan_kmalloc+0xa0/0xc0
>  qeth_l2_switchdev_event+0x25a/0x738
>  atomic_notifier_call_chain+0x9c/0xf8
>  br_switchdev_fdb_notify+0xf4/0x110
>  fdb_notify+0x122/0x180
>  fdb_add_entry.constprop.0.isra.0+0x312/0x558
>  br_fdb_add+0x59e/0x858
>  rtnl_fdb_add+0x58a/0x928
>  rtnetlink_rcv_msg+0x5f8/0x8d8
>  netlink_rcv_skb+0x1f2/0x408
>  netlink_unicast+0x570/0x790
>  netlink_sendmsg+0x752/0xbe0
>  sock_sendmsg+0xca/0x110
>  ____sys_sendmsg+0x510/0x6a8
>  ___sys_sendmsg+0x12a/0x180
>  __sys_sendmsg+0xe6/0x168
>  __do_sys_socketcall+0x3c8/0x468
>  do_syscall+0x22c/0x328
>  __do_syscall+0x94/0xf0
>  system_call+0x82/0xb0
> Freed by task 540:
>  kasan_save_stack+0x40/0x68
>  kasan_set_track+0x36/0x48
>  kasan_save_free_info+0x4c/0x68
>  ____kasan_slab_free+0x14e/0x1a8
>  __kasan_slab_free+0x24/0x30
>  __kmem_cache_free+0x168/0x338
>  qeth_l2_br2dev_worker+0x154/0x6b0
>  process_one_work+0x76e/0x1128
>  worker_thread+0x184/0x1098
>  kthread+0x26a/0x310
>  __ret_from_fork+0x8a/0xe8
>  ret_from_fork+0xa/0x40
> Last potentially related work creation:
>  kasan_save_stack+0x40/0x68
>  __kasan_record_aux_stack+0xbe/0xd0
>  insert_work+0x56/0x2e8
>  __queue_work+0x4ce/0xd10
>  queue_work_on+0xf4/0x100
>  qeth_l2_switchdev_event+0x520/0x738
>  atomic_notifier_call_chain+0x9c/0xf8
>  br_switchdev_fdb_notify+0xf4/0x110
>  fdb_notify+0x122/0x180
>  fdb_add_entry.constprop.0.isra.0+0x312/0x558
>  br_fdb_add+0x59e/0x858
>  rtnl_fdb_add+0x58a/0x928
>  rtnetlink_rcv_msg+0x5f8/0x8d8
>  netlink_rcv_skb+0x1f2/0x408
>  netlink_unicast+0x570/0x790
>  netlink_sendmsg+0x752/0xbe0
>  sock_sendmsg+0xca/0x110
>  ____sys_sendmsg+0x510/0x6a8
>  ___sys_sendmsg+0x12a/0x180
>  __sys_sendmsg+0xe6/0x168
>  __do_sys_socketcall+0x3c8/0x468
>  do_syscall+0x22c/0x328
>  __do_syscall+0x94/0xf0
>  system_call+0x82/0xb0
> Second to last potentially related work creation:
>  kasan_save_stack+0x40/0x68
>  __kasan_record_aux_stack+0xbe/0xd0
>  kvfree_call_rcu+0xb2/0x760
>  kernfs_unlink_open_file+0x348/0x430
>  kernfs_fop_release+0xc2/0x320
>  __fput+0x1ae/0x768
>  task_work_run+0x1bc/0x298
>  exit_to_user_mode_prepare+0x1a0/0x1a8
>  __do_syscall+0x94/0xf0
>  system_call+0x82/0xb0
> The buggy address belongs to the object at 00000000fdcea400
>  which belongs to the cache kmalloc-96 of size 96
> The buggy address is located 64 bytes inside of
>  96-byte region [00000000fdcea400, 00000000fdcea460)
> The buggy address belongs to the physical page:
> page:000000005a9c26e8 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xfdcea
> flags: 0x3ffff00000000200(slab|node=0|zone=1|lastcpupid=0x1ffff)
> raw: 3ffff00000000200 0000000000000000 0000000100000122 000000008008cc00
> raw: 0000000000000000 0020004100000000 ffffffff00000001 0000000000000000
> page dumped because: kasan: bad access detected
> Memory state around the buggy address:
>  00000000fdcea300: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>  00000000fdcea380: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> >00000000fdcea400: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>                                            ^
>  00000000fdcea480: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>  00000000fdcea500: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> ==================================================================
> 
> [...]

Here is the summary with links:
  - [net,v2] s390/qeth: fix use-after-free in hsci
    https://git.kernel.org/netdev/net/c/ebaaadc332cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


