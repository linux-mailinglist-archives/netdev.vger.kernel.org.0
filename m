Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D09588276
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 21:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiHBTYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 15:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiHBTX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 15:23:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2B01EED4;
        Tue,  2 Aug 2022 12:23:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF12F61311;
        Tue,  2 Aug 2022 19:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4C8C433C1;
        Tue,  2 Aug 2022 19:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659468237;
        bh=d0pZ2bL6Yc8g5ifNioCj8/CAd9JQ5Q+HSO37WdnexCc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GOVfLu/W/24gy41zrJ2LFIW5YMMIeNxKOMniirkzyXmkW8p6sj68SC1OYP0aZxHtf
         /qKG15DZGBRdqSHxrOsD+bV9I8TY0TRb5echhwFDzzEaoKNsO9rg5JpU6XPLkBcZxh
         5xE/yYuoiSnvuwcjFV3cFSD242oDYwzMpTBgN7jws3sTu0OhJOIKcWohBjT0jGZXyz
         lzhemgv2YiOgKTetTjFnBVJASZkHMYiKMiqs+kdNLK3k4fArS2ddgPYLD0hHrL8yDf
         swVP/PKWPNuLWllJ4h5wEwbzboqeEVPHXAo7Tm8QS7DorBh/1CUoPm1Tc6AixcY44e
         ANIynfRjIYF/w==
Date:   Tue, 2 Aug 2022 12:23:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bruno Goncalves <bgoncalv@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>
Subject: Re: RIP: 0010:qede_load+0x128d/0x13b0 [qede] - 5.19.0
Message-ID: <20220802122356.6f163a79@kernel.org>
In-Reply-To: <CA+QYu4qxW1BUcbC9MwG1BxXjPO96sa9BOUXOHCj1SLY7ObJnQw@mail.gmail.com>
References: <CA+QYu4qxW1BUcbC9MwG1BxXjPO96sa9BOUXOHCj1SLY7ObJnQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Aug 2022 13:27:32 +0200 Bruno Goncalves wrote:
> Hello,
> 
> We've noticed the following panic when booting up kernel 5.19.0 on a
> specific machine.
> The panic seems to happen when we build the kernel with debug flags.
> Below is the first crash we noticed, more logs at [1] and the kernel
> config is at [2].
> 
> [   59.207684] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> [   59.212949] CPU: 32 PID: 1967 Comm: NetworkManager Not tainted 5.19.0-rc3 #1
> [   59.220041] Hardware name: HPE ProLiant DL325 Gen10 Plus/ProLiant
> DL325 Gen10 Plus, BIOS A43 08/09/2021
> [   59.229490] RIP: 0010:qede_load.cold+0x5a1/0x819 [qede]

Is it this warning?

   WARN_ON(xdp_rxq_info_reg(&fp->rxq->xdp_rxq, edev->ndev,

Would you be able to run the stacktrace thru
scripts/decode_stacktrace.sh ?

> [   59.234757] Code: 41 88 84 24 b1 00 00 00 41 0f b7 84 24 b6 00 00
> 00 45 88 b4 24 b3 00 00 00 e9 b8 00 ff ff 48 c7 c1 09 66 46 c1 e9 6f
> ff ff ff <0f> 0b 49 8b 7c 24 08 e8 82 e2 fe ff 48 89 c1 48 85 c0 74 32
> ba 2a
> [   59.253639] RSP: 0018:ffffae1e04593688 EFLAGS: 00010206
> [   59.258897] RAX: 000000000000006b RBX: 0000000000000000 RCX: 0000000000000006
> [   59.266073] RDX: ffff8f8f35332be8 RSI: ffffffffaf96411f RDI: ffffffffaf8e4b1e
> [   59.273250] RBP: ffff8f8f2a87acd0 R08: 0000000000000001 R09: 0000000000000001
> [   59.280426] R10: 0000000000000000 R11: 000000000f8c087f R12: ffff8f8f2a87ac00
> [   59.287602] R13: ffff8f8f34d7f928 R14: ffffae1e0c039000 R15: 0000000000000000
> [   59.294777] FS:  00007f164509f500(0000) GS:ffff8f9dfd800000(0000)
> knlGS:0000000000000000
> [   59.302917] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   59.308697] CR2: 00005575f29a5c08 CR3: 0000000163810000 CR4: 0000000000350ee0
> [   59.315875] Call Trace:
> [   59.318335]  <TASK>
> [   59.320458]  qede_open+0x3b/0x90 [qede]
> [   59.324323]  __dev_open+0xf1/0x1c0
> [   59.327748]  __dev_change_flags+0x1f8/0x280
> [   59.331957]  dev_change_flags+0x22/0x60
> [   59.335816]  do_setlink+0x327/0x1140
> [   59.339413]  ? lock_is_held_type+0xe3/0x140
> [   59.343625]  ? lock_is_held_type+0xe3/0x140
> [   59.347833]  ? __nla_validate_parse+0x5f/0xb70
> [   59.352307]  ? mark_held_locks+0x49/0x70
> [   59.356256]  ? _raw_spin_unlock_irqrestore+0x30/0x60
> [   59.361254]  ? lockdep_hardirqs_on+0x7d/0x100
> [   59.365640]  __rtnl_newlink+0x59c/0x950
> [   59.369502]  ? rtnl_newlink+0x2a/0x60
> [   59.373185]  ? rcu_read_lock_sched_held+0x3c/0x70
> [   59.377918]  ? trace_kmalloc+0x30/0xf0
> [   59.381692]  ? kmem_cache_alloc_trace+0x1ad/0x270
> [   59.386426]  rtnl_newlink+0x43/0x60
> [   59.389936]  rtnetlink_rcv_msg+0x184/0x540
> [   59.394057]  ? lock_acquire+0xe2/0x2e0
> [   59.397830]  ? rtnl_stats_set+0x190/0x190
> [   59.401863]  netlink_rcv_skb+0x51/0xf0
> [   59.405639]  netlink_unicast+0x189/0x260
> [   59.409586]  netlink_sendmsg+0x25a/0x4c0
> [   59.413536]  sock_sendmsg+0x5c/0x60
> [   59.417045]  ____sys_sendmsg+0x22b/0x270
> [   59.420991]  ? import_iovec+0x17/0x20
> [   59.424675]  ? sendmsg_copy_msghdr+0x78/0xa0
> [   59.428972]  ___sys_sendmsg+0x85/0xc0
> [   59.432658]  ? lock_is_held_type+0xe3/0x140
> [   59.436867]  ? find_held_lock+0x2b/0x80
> [   59.440727]  ? lock_release+0x145/0x300
> [   59.444586]  ? __fget_files+0xe5/0x170
> [   59.448360]  __sys_sendmsg+0x5c/0xb0
> [   59.451961]  do_syscall_64+0x5b/0x80
> [   59.455558]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [   59.460641] RIP: 0033:0x7f164628539d
> [   59.464251] Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 0a
> b1 f7 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 48 89 44 24 08 e8 5e b1 f7
> ff 48
> [   59.483133] RSP: 002b:00007ffd9bf01520 EFLAGS: 00000293 ORIG_RAX:
> 000000000000002e
> [   59.490749] RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007f164628539d
> [   59.497925] RDX: 0000000000000000 RSI: 00007ffd9bf01560 RDI: 000000000000000c
> [   59.505100] RBP: 00005575f2915040 R08: 0000000000000000 R09: 0000000000000000
> [   59.512275] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
> [   59.519453] R13: 00007ffd9bf016c0 R14: 00007ffd9bf016bc R15: 0000000000000000
> [   59.526637]  </TASK>
> [   59.528834] Modules linked in: rfkill sunrpc intel_rapl_msr
> intel_rapl_common vfat fat qede qed edac_mce_amd i2c_piix4 crc8 rapl
> igb ipmi_ssif ptdma ses enclosure pcspkr dca hpilo k10temp acpi_ipmi
> acpi_tad ipmi_si acpi_power_meter fuse zram xfs crct10dif_pclmul
> crc32_pclmul crc32c_intel mgag200 i2c_algo_bit drm_shmem_helper
> drm_kms_helper ghash_clmulni_intel drm hpwdt smartpqi ccp
> scsi_transport_sas sp5100_tco wmi ipmi_devintf ipmi_msghandler
> [   59.568459] ---[ end trace 0000000000000000 ]---
> [   59.632952] RIP: 0010:qede_load.cold+0x5a1/0x819 [qede]
> [   59.632967] Code: 41 88 84 24 b1 00 00 00 41 0f b7 84 24 b6 00 00
> 00 45 88 b4 24 b3 00 00 00 e9 b8 00 ff ff 48 c7 c1 09 66 46 c1 e9 6f
> ff ff ff <0f> 0b 49 8b 7c 24 08 e8 82 e2 fe ff 48 89 c1 48 85 c0 74 32
> ba 2a
> [   59.632970] RSP: 0018:ffffae1e04593688 EFLAGS: 00010206
> [   59.632972] RAX: 000000000000006b RBX: 0000000000000000 RCX: 0000000000000006
> [   59.632974] RDX: ffff8f8f35332be8 RSI: ffffffffaf96411f RDI: ffffffffaf8e4b1e
> [   59.632977] RBP: ffff8f8f2a87acd0 R08: 0000000000000001 R09: 0000000000000001
> [   59.632978] R10: 0000000000000000 R11: 000000000f8c087f R12: ffff8f8f2a87ac00
> [   59.632980] R13: ffff8f8f34d7f928 R14: ffffae1e0c039000 R15: 0000000000000000
> [   59.632982] FS:  00007f164509f500(0000) GS:ffff8f9dfd800000(0000)
> knlGS:0000000000000000
> [   59.632984] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   59.632986] CR2: 00005575f29a5c08 CR3: 0000000163810000 CR4: 0000000000350ee0
> [   59.632989] Kernel panic - not syncing: Fatal exception
> [   59.732905] Kernel Offset: 0x2d000000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [   59.807803] ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> 
> cki issue tracker: https://datawarehouse.cki-project.org/issue/1470
> 
> [1] https://datawarehouse.cki-project.org/kcidb/tests/4002370
> [2] http://s3.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/06/20/568171088/redhat:568171088/redhat:568171088_x86_64_debug/.config
> 
> Thanks,
> Bruno Goncalves
> 

