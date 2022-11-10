Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49187623C7A
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 08:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbiKJHPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 02:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbiKJHPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 02:15:08 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D2B6540
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 23:14:54 -0800 (PST)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N7Cl23T2dzmVhC;
        Thu, 10 Nov 2022 15:14:38 +0800 (CST)
Received: from [10.174.178.165] (10.174.178.165) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 15:14:52 +0800
Message-ID: <f4467d70-032b-5f7e-aa45-5529029e711d@huawei.com>
Date:   Thu, 10 Nov 2022 15:14:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net] eth: sp7021: drop free_netdev() from
 spl2sw_init_netdev()
To:     Francois Romieu <romieu@fr.zoreil.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Wei Yongjun <weiyongjun@huaweicloud.com>,
        Wells Lu <wellslutw@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20221109150116.2988194-1-weiyongjun@huaweicloud.com>
 <CANn89iJZWTVfNDDkpwPOqjj5_fVXzGRrkeEv1EedRipL-oBYbQ@mail.gmail.com>
 <Y2wjuPAww2tZLbIx@electric-eye.fr.zoreil.com>
From:   Wei Yongjun <weiyongjun1@huawei.com>
In-Reply-To: <Y2wjuPAww2tZLbIx@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.165]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/11/10 6:03, Francois Romieu wrote:
> Eric Dumazet <edumazet@google.com> :
> [...]
>>> diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
>>> index 9be585237277..c499a14314f1 100644
>>> --- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
>>> +++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
>>> @@ -287,7 +287,6 @@ static u32 spl2sw_init_netdev(struct platform_device *pdev, u8 *mac_addr,
>>>         if (ret) {
>>>                 dev_err(&pdev->dev, "Failed to register net device \"%s\"!\n",
>>>                         ndev->name);
>>
>> If the following leads to a double free, how the previous use of
>> ndev->name would actually work ?
> 
> The second free_netdev happens when device managed resources are released.
> ndev->name above is used before the first free_netdev.
> 

Yes. KASAN report use-after-free in free_netdev as follows:

BUG: KASAN: use-after-free in free_netdev+0x4f9/0x5d0 net/core/dev.c:10699
Read of size 1 at addr ffff88810e218548 by task sh/350

CPU: 2 PID: 350 Comm: sh Tainted: G        W        N 6.1.0-rc3-next-20221104+ #254 16b4d59edd8bc0a5b450b7d669a0c31a3760bc5c
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x68/0x85 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:253 [inline]
 print_report+0x175/0x478 mm/kasan/report.c:364
 kasan_report+0xbc/0xf0 mm/kasan/report.c:464
 free_netdev+0x4f9/0x5d0 net/core/dev.c:10699
 release_nodes drivers/base/devres.c:502 [inline]
 devres_release_all+0x188/0x250 drivers/base/devres.c:532
 device_unbind_cleanup+0x19/0x1b0 drivers/base/dd.c:530
 really_probe+0x585/0x770 drivers/base/dd.c:705
 __driver_probe_device+0x229/0x2a0 drivers/base/dd.c:778
 driver_probe_device+0x4d/0x250 drivers/base/dd.c:808
 __device_attach_driver+0x195/0x340 drivers/base/dd.c:936
 bus_for_each_drv+0x151/0x1e0 drivers/base/bus.c:427
 __device_attach+0x1c9/0x4c0 drivers/base/dd.c:1008
 bus_probe_device+0x1d8/0x290 drivers/base/bus.c:487
 device_add+0xacd/0x1d90 drivers/base/core.c:3517
 of_platform_device_create_pdata drivers/of/platform.c:189 [inline]
 of_platform_device_create_pdata+0x16a/0x200 drivers/of/platform.c:166
 of_platform_device_create drivers/of/platform.c:214 [inline]
 of_platform_notify+0x2a4/0x3d0 drivers/of/platform.c:737
 notifier_call_chain kernel/notifier.c:87 [inline]
 blocking_notifier_call_chain kernel/notifier.c:382 [inline]
 blocking_notifier_call_chain+0xf7/0x160 kernel/notifier.c:370
 of_reconfig_notify drivers/of/dynamic.c:97 [inline]
 __of_changeset_entry_notify+0x144/0x350 drivers/of/dynamic.c:552
 __of_changeset_apply_notify+0x56/0xb0 drivers/of/dynamic.c:750
 of_overlay_apply drivers/of/overlay.c:933 [inline]
 of_overlay_fdt_apply+0x1106/0x1510 drivers/of/overlay.c:1039
 create_overlay drivers/of/configfs.c:51 [inline]
 cfs_overlay_item_dtbo_write+0x101/0x170 drivers/of/configfs.c:178
 configfs_release_bin_file+0x2ef/0x3c0 fs/configfs/file.c:411
 __fput+0x231/0xa20 fs/file_table.c:320
 task_work_run+0x155/0x240 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x199/0x1a0 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x19/0x40 kernel/entry/common.c:296
 do_syscall_64+0x48/0x90 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7f5616c641cb
Code: 73 01 c3 48 8b 0d 65 3c 10 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 21 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 35 3c 10 00 f7 d8 64 89 01 48
RSP: 002b:00007ffecf0db568 EFLAGS: 00000246 ORIG_RAX: 0000000000000021
RAX: 0000000000000001 RBX: 0000000000000001 RCX: 00007f5616c641cb
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 000000000000000b
RBP: 0000000000000000 R08: 0000000000000000 R09: 000055c24d4bde60
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 000055c24d4bb750 R14: 0000000000000000 R15: 000055c24d4bd9d8
 </TASK>

Allocated by task 350:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 kasan_set_track+0x21/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:376 [inline]
 __kasan_kmalloc+0x7e/0x90 mm/kasan/common.c:385
 kasan_kmalloc include/linux/kasan.h:212 [inline]
 __do_kmalloc_node mm/slab_common.c:955 [inline]
 __kmalloc_node+0x4f/0xb0 mm/slab_common.c:962
 kmalloc_node include/linux/slab.h:613 [inline]
 kvmalloc_node+0x34/0x1c0 mm/util.c:581
 kvmalloc include/linux/slab.h:740 [inline]
 kvzalloc include/linux/slab.h:748 [inline]
 alloc_netdev_mqs+0x73/0xf20 net/core/dev.c:10589
 devm_alloc_etherdev_mqs+0x5b/0xf0 net/devres.c:30
 spl2sw_probe+0x752/0xee0 [sp7021_emac]
 platform_probe+0xe8/0x1c0 drivers/base/platform.c:1400
 call_driver_probe drivers/base/dd.c:560 [inline]
 really_probe+0x21f/0x770 drivers/base/dd.c:639
 __driver_probe_device+0x229/0x2a0 drivers/base/dd.c:778
 driver_probe_device+0x4d/0x250 drivers/base/dd.c:808
 __device_attach_driver+0x195/0x340 drivers/base/dd.c:936
 bus_for_each_drv+0x151/0x1e0 drivers/base/bus.c:427
 __device_attach+0x1c9/0x4c0 drivers/base/dd.c:1008
 bus_probe_device+0x1d8/0x290 drivers/base/bus.c:487
 device_add+0xacd/0x1d90 drivers/base/core.c:3517
 of_platform_device_create_pdata drivers/of/platform.c:189 [inline]
 of_platform_device_create_pdata+0x16a/0x200 drivers/of/platform.c:166
 of_platform_device_create drivers/of/platform.c:214 [inline]
 of_platform_notify+0x2a4/0x3d0 drivers/of/platform.c:737
 notifier_call_chain kernel/notifier.c:87 [inline]
 blocking_notifier_call_chain kernel/notifier.c:382 [inline]
 blocking_notifier_call_chain+0xf7/0x160 kernel/notifier.c:370
 of_reconfig_notify drivers/of/dynamic.c:97 [inline]
 __of_changeset_entry_notify+0x144/0x350 drivers/of/dynamic.c:552
 __of_changeset_apply_notify+0x56/0xb0 drivers/of/dynamic.c:750
 of_overlay_apply drivers/of/overlay.c:933 [inline]
 of_overlay_fdt_apply+0x1106/0x1510 drivers/of/overlay.c:1039
 create_overlay drivers/of/configfs.c:51 [inline]
 cfs_overlay_item_dtbo_write+0x101/0x170 drivers/of/configfs.c:178
 configfs_release_bin_file+0x2ef/0x3c0 fs/configfs/file.c:411
 __fput+0x231/0xa20 fs/file_table.c:320
 task_work_run+0x155/0x240 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x199/0x1a0 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x19/0x40 kernel/entry/common.c:296
 do_syscall_64+0x48/0x90 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

Freed by task 350:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 kasan_set_track+0x21/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2a/0x50 mm/kasan/generic.c:511
 ____kasan_slab_free mm/kasan/common.c:241 [inline]
 ____kasan_slab_free mm/kasan/common.c:205 [inline]
 __kasan_slab_free+0x106/0x190 mm/kasan/common.c:249
 kasan_slab_free include/linux/kasan.h:178 [inline]
 slab_free_hook mm/slub.c:1724 [inline]
 slab_free_freelist_hook mm/slub.c:1750 [inline]
 slab_free mm/slub.c:3653 [inline]
 __kmem_cache_free+0xcb/0x400 mm/slub.c:3666
 kvfree+0x35/0x40 mm/util.c:627
 device_release+0x9f/0x240 drivers/base/core.c:2330
 kobject_cleanup lib/kobject.c:673 [inline]
 kobject_release lib/kobject.c:704 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x12f/0x230 lib/kobject.c:721
 put_device+0x1b/0x30 drivers/base/core.c:3624
 free_netdev+0x3f0/0x5d0 net/core/dev.c:10736
 spl2sw_probe.cold+0x29/0x111 [sp7021_emac]
 platform_probe+0xe8/0x1c0 drivers/base/platform.c:1400
 call_driver_probe drivers/base/dd.c:560 [inline]
 really_probe+0x21f/0x770 drivers/base/dd.c:639
 __driver_probe_device+0x229/0x2a0 drivers/base/dd.c:778
 driver_probe_device+0x4d/0x250 drivers/base/dd.c:808
 __device_attach_driver+0x195/0x340 drivers/base/dd.c:936
 bus_for_each_drv+0x151/0x1e0 drivers/base/bus.c:427
 __device_attach+0x1c9/0x4c0 drivers/base/dd.c:1008
 bus_probe_device+0x1d8/0x290 drivers/base/bus.c:487
 device_add+0xacd/0x1d90 drivers/base/core.c:3517
 of_platform_device_create_pdata drivers/of/platform.c:189 [inline]
 of_platform_device_create_pdata+0x16a/0x200 drivers/of/platform.c:166
 of_platform_device_create drivers/of/platform.c:214 [inline]
 of_platform_notify+0x2a4/0x3d0 drivers/of/platform.c:737
 notifier_call_chain kernel/notifier.c:87 [inline]
 blocking_notifier_call_chain kernel/notifier.c:382 [inline]
 blocking_notifier_call_chain+0xf7/0x160 kernel/notifier.c:370
 of_reconfig_notify drivers/of/dynamic.c:97 [inline]
 __of_changeset_entry_notify+0x144/0x350 drivers/of/dynamic.c:552
 __of_changeset_apply_notify+0x56/0xb0 drivers/of/dynamic.c:750
 of_overlay_apply drivers/of/overlay.c:933 [inline]
 of_overlay_fdt_apply+0x1106/0x1510 drivers/of/overlay.c:1039
 create_overlay drivers/of/configfs.c:51 [inline]
 cfs_overlay_item_dtbo_write+0x101/0x170 drivers/of/configfs.c:178
 configfs_release_bin_file+0x2ef/0x3c0 fs/configfs/file.c:411
 __fput+0x231/0xa20 fs/file_table.c:320
 task_work_run+0x155/0x240 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x199/0x1a0 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x19/0x40 kernel/entry/common.c:296
 do_syscall_64+0x48/0x90 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

The buggy address belongs to the object at ffff88810e218000
 which belongs to the cache kmalloc-cg-4k of size 4096
The buggy address is located 1352 bytes inside of
 4096-byte region [ffff88810e218000, ffff88810e219000)

The buggy address belongs to the physical page:
page:0000000000f9bd51 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10e218
head:0000000000f9bd51 order:3 compound_mapcount:0 compound_pincount:0
memcg:ffff888104ecbec1
anon flags: 0x200000000010200(slab|head|node=0|zone=2)
raw: 0200000000010200 ffff88810004c140 ffffea0004167e00 0000000000000003
raw: 0000000000000000 0000000080040004 00000001ffffffff ffff888104ecbec1
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88810e218400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88810e218480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88810e218500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                              ^
 ffff88810e218580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88810e218600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Regards,
Wei Yongjun
