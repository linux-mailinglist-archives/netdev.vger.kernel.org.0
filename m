Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8EC627438
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 02:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbiKNBrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 20:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiKNBrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 20:47:24 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AFDDF7C
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 17:47:22 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id u2so11371194ljl.3
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 17:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2QppTyE05ogg1seVFZDWiHvpqoVYCmS+FaZJsBX13wc=;
        b=jh0ZARmZgqQiH9JvlUIFxHaXs01YQoaaOHnIk/ykAH11ueQ79NCIENOTF6ryIgMZdN
         3E/20Es53QN9spCNOLgFx7zgzTC6djaoU8bwMTIQMZXe/nJfDbYBaN0BrVEKqtGdm5hJ
         METTDEujcxANQ5rGcH4v6m28IqDAoRR25JelQA4W7h6TFU9uSRN/ZR3pxj7/8uyykT1+
         JXAKoEIziA6USjnbtpJaFOlFk44LkxE8CLSTROpFOCT6XPiBhJlvaqeKIfYUlrD1hmoq
         Wrr+ozImilw5XYedbl5cYcbpXvwcNSs2bNEUU1nZ23loHyQV1ebXyn1D3i2FB8YvLM2Z
         Wd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2QppTyE05ogg1seVFZDWiHvpqoVYCmS+FaZJsBX13wc=;
        b=pVHmEUcodny1FZrxyzGdyB9sR41wzMEqu5zPNGL1JePuU9EnH1fuyzesuq/wHb2NlS
         m+h8942UdKb9P33x+wi8fm698dQLTaPoUSk8p5xePLSVtcG+uswa65cfmA4sQ395JOxg
         TrtcCac2b4m/tOKUA9xh0e02ADIU/WsJUoNKWQffr1Ed+b9uZnZZXjAql29mNCzlKybN
         pX+mxM2Mfn9fYVOUE5pf8d1oW8RfUpVL956o0PbXrqoEhw2ZDt2/GqirTb0MxDBfC4MG
         MkhBZWA2SSJFsKwO4AXZNGy0NysTA1KM6bJdE/W2FoNt/1vdE8xhtSBOaqHerpRKAMX7
         Dptg==
X-Gm-Message-State: ANoB5pk8Kc7oRQRKOdWmcZSDP1eJwf4vZAqoOZjHDwHyeAAsMigPCCmv
        tilZ3XmcEU/mkaffKmDwclJVb4DmA01CIxlLcUFQVA==
X-Google-Smtp-Source: AA0mqf4uvTKqJKsNlAi9m+VtZ5bhQsqhOcbTp9Z2hSd6uS5A/mJ7Q0nm2Arq7GzXkArrofQxnB/e25xb81poVJ5TF5Q=
X-Received: by 2002:a05:651c:32e:b0:277:1158:7ebb with SMTP id
 b14-20020a05651c032e00b0027711587ebbmr3526347ljp.521.1668390440900; Sun, 13
 Nov 2022 17:47:20 -0800 (PST)
MIME-Version: 1.0
From:   Jun Nie <jun.nie@linaro.org>
Date:   Mon, 14 Nov 2022 09:47:09 +0800
Message-ID: <CABymUCNq9yqhAS0zxg+-gsCjj0GgTd=wmT7TjOcRz2TTew8zDA@mail.gmail.com>
Subject: [BUG REPORT] f2fs: use-after-free during garbage collection
To:     chao@kernel.org, jaegeuk@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     Lee Jones <joneslee@google.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi  Chao & Jaegeuk,

There is a KASAN report[0] that shows invalid memory
access(use-after-free) in f2fs garbage collection process, and this
issue is fixed by a recent f2fs patch set[1]. The KASAN report is caused
by an abnormal sum->ofs_in_node value 0xc3f1 in the first check. And
the investigation indicates that the f2fs_summary_block address range
is not from f2fs_kzalloc() in build_curseg(). The memory
allocation/free happens in non-f2fs thread, such as network. So I
guess the f2fs subsystem is accessing memory that's not belong to f2fs
in some cases. With the below commit merged into mainline recently,
this  use-after-free issue disappears. But there is another thread
blocked issue as below. The patch c6ad7fd16657 check the valid
ofs_in_node and stop further gc. I am not sure whether it is expected
that the f2fs_summary_block address in gc thread is not from
allocation in build_curseg(). Because I am not familiar with f2fs.

Could you help comment on my question and new issue? Is there any work
in progress to fix the new blocked issue? Thanks!

[0] https://syzkaller.appspot.com/bug?id=4cbcff00422ea402c2e5be2bc041a8f4196d608c
[1] c6ad7fd16657 f2fs: fix to do sanity check on summary info

Log of new issue:
[  250.167041][   T58] INFO: task kworker/u16:1:11 blocked for more
than 122 seconds.
[  250.169071][   T58]       Not tainted 6.1.0-rc4+gc0daf896 #3
[  250.170443][   T58] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  250.172487][   T58] task:kworker/u16:1   state:D stack:0     pid:11
   ppid:2      flags:0x00004000
[  250.174678][   T58] Workqueue: writeback wb_workfn (flush-7:0)
[  250.176128][   T58] Call Trace:
[  250.176908][   T58]  <TASK>
[  250.177638][   T58]  __schedule+0x8b7/0x1940
[  250.178736][   T58]  ? io_schedule_timeout+0x150/0x150
[  250.180013][   T58]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[  250.181541][   T58]  ? kthread_data+0x5d/0xd0
[  250.182615][   T58]  schedule+0xec/0x1b0
[  250.183582][   T58]  io_schedule+0xcd/0x150
[  250.184619][   T58]  folio_wait_bit_common+0x35d/0x910
[  250.185919][   T58]  ? filemap_map_pages+0x1230/0x1230
[  250.187214][   T58]  ? add_gc_inode+0xc9/0x2e0
[  250.188323][   T58]  ? do_garbage_collect+0x2b47/0x3730
[  250.189597][   T58]  ? f2fs_gc+0x816/0x1df0
[  250.190629][   T58]  ? f2fs_balance_fs+0x391/0x420
[  250.191803][   T58]  ? f2fs_write_inode+0x598/0xe20
[  250.193009][   T58]  ? __writeback_single_inode+0x7b8/0xac0
[  250.194369][   T58]  ? writeback_sb_inodes+0x585/0xea0
[  250.195623][   T58]  ? wb_writeback+0x25c/0x8a0
[  250.196737][   T58]  ? wb_workfn+0x277/0xed0
[  250.197831][   T58]  ? folio_unlock+0x60/0x60
[  250.198943][   T58]  ? __sanitizer_cov_trace_const_cmp1+0x1a/0x20
[  250.200438][   T58]  ? xas_load+0x64/0x2e0
[  250.201459][   T58]  __filemap_get_folio+0x84c/0x900
[  250.202685][   T58]  ? filemap_add_folio+0x1c0/0x1c0
[  250.203937][   T58]  ? __sanitizer_cov_trace_const_cmp8+0x18/0x20
[  250.205454][   T58]  pagecache_get_page+0x36/0x130
[  250.206634][   T58]  __get_node_page.part.0+0xa7/0x960
[  250.207918][   T58]  f2fs_get_node_page+0x10f/0x190
[  250.209119][   T58]  do_garbage_collect+0x1bbc/0x3730
[  250.210377][   T58]  ? ra_data_block+0x860/0x860
[  250.211522][   T58]  f2fs_gc+0x816/0x1df0
[  250.212510][   T58]  ? f2fs_start_bidx_of_node+0x50/0x50
[  250.213816][   T58]  ? map_id_up+0x1a3/0x320
[  250.214872][   T58]  ? down_write+0xf7/0x170
[  250.215931][   T58]  ? down_write_killable+0x180/0x180
[  250.217213][   T58]  ? has_not_enough_free_secs.constprop.0+0x6d8/0x840
[  250.218824][   T58]  f2fs_balance_fs+0x391/0x420
[  250.219963][   T58]  ? f2fs_balance_fs_bg+0xf70/0xf70
[  250.221205][   T58]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[  250.222688][   T58]  ? __sanitizer_cov_trace_const_cmp1+0x1a/0x20
[  250.224174][   T58]  ? folio_unlock+0x3c/0x60
[  250.225274][   T58]  ? __sanitizer_cov_trace_const_cmp1+0x1a/0x20
[  250.226990][   T58]  ? f2fs_update_inode_page+0x1d4/0x4c0
[  250.228357][   T58]  f2fs_write_inode+0x598/0xe20
[  250.229522][   T58]  ? _raw_spin_lock_bh+0x110/0x110
[  250.230760][   T58]  ? __kasan_check_write+0x14/0x20
[  250.232017][   T58]  ? _raw_spin_lock+0x8b/0x110
[  250.233177][   T58]  __writeback_single_inode+0x7b8/0xac0
[  250.234503][   T58]  writeback_sb_inodes+0x585/0xea0
[  250.235727][   T58]  ? sync_inode_metadata+0xf0/0xf0
[  250.236951][   T58]  ? __sanitizer_cov_trace_const_cmp1+0x1a/0x20
[  250.238464][   T58]  ? queue_io+0x23d/0x450
[  250.239484][   T58]  wb_writeback+0x25c/0x8a0
[  250.240566][   T58]  ? __writeback_inodes_wb+0x270/0x270
[  250.241865][   T58]  ? _raw_spin_lock+0x110/0x110
[  250.243027][   T58]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[  250.244510][   T58]  ? kthread_data+0x5d/0xd0
[  250.245581][   T58]  wb_workfn+0x277/0xed0
[  250.246594][   T58]  ? __kasan_check_read+0x11/0x20
[  250.247841][   T58]  ? psi_group_change+0x716/0xc20
[  250.249055][   T58]  ? inode_wait_for_writeback+0x40/0x40
[  250.250378][   T58]  ? _raw_spin_unlock+0x45/0x70
[  250.251540][   T58]  ? finish_task_switch.isra.0+0x174/0x7e0
[  250.252923][   T58]  ? __switch_to+0x5da/0xef0
[  250.254019][   T58]  ? __kasan_check_read+0x11/0x20
[  250.255222][   T58]  ? read_word_at_a_time+0x12/0x20
[  250.256466][   T58]  ? strscpy+0x9a/0x2a0
[  250.257513][   T58]  process_one_work+0x735/0x1000
[  250.258695][   T58]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[  250.260184][   T58]  worker_thread+0x635/0x1050
[  250.261321][   T58]  kthread+0x2cf/0x380
[  250.262322][   T58]  ? process_one_work+0x1000/0x1000
[  250.263566][   T58]  ? kthread_complete_and_exit+0x40/0x40
[  250.264913][   T58]  ret_from_fork+0x1f/0x30
[  250.265970][   T58]  </TASK>
[  250.266711][   T58] INFO: task repro:392 blocked for more than 122 seconds.
[  250.268415][   T58]       Not tainted 6.1.0-rc4+gc0daf896 #3
[  250.269785][   T58] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  250.271823][   T58] task:repro           state:D stack:0
pid:392   ppid:390    flags:0x00004000
[  250.273999][   T58] Call Trace:
[  250.274771][   T58]  <TASK>
[  250.275461][   T58]  __schedule+0x8b7/0x1940
[  250.276520][   T58]  ? io_schedule_timeout+0x150/0x150
[  250.277799][   T58]  ? _raw_spin_unlock_irq+0x46/0x70
[  250.279045][   T58]  ? _raw_spin_unlock_irqrestore+0x51/0x90
[  250.280440][   T58]  schedule+0xec/0x1b0
[  250.281410][   T58]  wb_wait_for_completion+0x18c/0x260
[  250.282696][   T58]  ? wb_writeback+0x8a0/0x8a0
[  250.283814][   T58]  ? __kasan_check_read+0x11/0x20
[  250.285019][   T58]  ? prepare_to_wait_exclusive+0x250/0x250
[  250.286396][   T58]  ? __d_free_external+0x70/0x70
[  250.287659][   T58]  ? __call_rcu_nocb_wake.part.0+0x8b0/0x8b0
[  250.289105][   T58]  __writeback_inodes_sb_nr+0x215/0x2c0
[  250.290428][   T58]  ? bdi_split_work_to_wbs+0xaf0/0xaf0
[  250.291732][   T58]  ? _find_next_bit+0x11c/0x150
[  250.292929][   T58]  ? __sanitizer_cov_trace_cmp4+0x16/0x20
[  250.294391][   T58]  ? get_nr_dirty_inodes+0x12e/0x1c0
[  250.295663][   T58]  writeback_inodes_sb+0x6e/0x90
[  250.296855][   T58]  sync_filesystem.part.0+0x29/0x1e0
[  250.298162][   T58]  sync_filesystem+0x99/0xd0
[  250.299277][   T58]  generic_shutdown_super+0x7a/0x420
[  250.300545][   T58]  kill_block_super+0xa5/0x100
[  250.301687][   T58]  kill_f2fs_super+0x2e0/0x400
[  250.302826][   T58]  ? f2fs_dquot_mark_dquot_dirty+0x210/0x210
[  250.304254][   T58]  ? up_write+0x71/0xb0
[  250.305253][   T58]  ? unregister_shrinker+0x68/0x340
[  250.306496][   T58]  deactivate_locked_super+0xa2/0x180
[  250.307799][   T58]  deactivate_super+0xb8/0xd0
[  250.308920][   T58]  cleanup_mnt+0x2c7/0x3f0
[  250.309976][   T58]  __cleanup_mnt+0x1b/0x30
[  250.311065][   T58]  task_work_run+0x19e/0x2b0
[  250.312171][   T58]  ? task_work_cancel+0x30/0x30
[  250.313334][   T58]  ? __x64_sys_umount+0x12a/0x1a0
[  250.314528][   T58]  exit_to_user_mode_prepare+0x123/0x130
[  250.315863][   T58]  syscall_exit_to_user_mode+0x21/0x40
[  250.317185][   T58]  do_syscall_64+0x42/0x80
[  250.318272][   T58]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  250.319728][   T58] RIP: 0033:0x7f189f0e8d77
[  250.320789][   T58] RSP: 002b:00007ffe4c4e7ab8 EFLAGS: 00000206
ORIG_RAX: 00000000000000a6
[  250.322794][   T58] RAX: 0000000000000000 RBX: 0000000000000000
RCX: 00007f189f0e8d77
[  250.324729][   T58] RDX: 00007ffe4c4e7b99 RSI: 000000000000000a
RDI: 00007ffe4c4e7b90
[  250.326612][   T58] RBP: 00007ffe4c4e8ba0 R08: 00005649086330a3
R09: 0000000000000009
[  250.328526][   T58] R10: 0000000000000073 R11: 0000000000000206
R12: 0000564906b91540
[  250.330408][   T58] R13: 00007ffe4c4e8cf0 R14: 0000000000000000
R15: 0000000000000000
[  250.332288][   T58]  </TASK>
[  250.333013][   T58] NMI backtrace for cpu 5
[  250.334033][   T58] CPU: 5 PID: 58 Comm: khungtaskd Not tainted
6.1.0-rc4+gc0daf896 #3
[  250.335937][   T58] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.15.0-1 04/01/2014
[  250.338106][   T58] Call Trace:
[  250.338874][   T58]  <TASK>
[  250.339559][   T58]  dump_stack_lvl+0x75/0x9b
[  250.340638][   T58]  dump_stack+0x15/0x17
[  250.341625][   T58]  nmi_cpu_backtrace.cold+0xee/0xf3
[  250.342867][   T58]  ? lapic_can_unplug_cpu+0x80/0x80
[  250.344109][   T58]  nmi_trigger_cpumask_backtrace+0x251/0x2e0
[  250.345536][   T58]  arch_trigger_cpumask_backtrace+0x19/0x20
[  250.346938][   T58]  watchdog+0x9d1/0xb40
[  250.347920][   T58]  kthread+0x2cf/0x380
[  250.348915][   T58]  ? proc_dohung_task_timeout_secs+0x90/0x90
[  250.350375][   T58]  ? kthread_complete_and_exit+0x40/0x40
[  250.351713][   T58]  ret_from_fork+0x1f/0x30
[  250.352771][   T58]  </TASK>
[  250.353509][   T58] Sending NMI from CPU 5 to CPUs 0-4,6-7:
[  250.354943][    C1] NMI backtrace for cpu 1
[  250.354953][    C1] CPU: 1 PID: 195 Comm: systemd-journal Not
tainted 6.1.0-rc4+gc0daf896 #3
[  250.354974][    C1] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.15.0-1 04/01/2014
[  250.354984][    C1] RIP: 0010:__stack_depot_save+0xcc/0x540
[  250.355016][    C1] Code: ee 03 48 83 c1 0c 8b 79 f4 03 41 f8 29 df
01 fa 89 df 01 c3 c1 c7 04 31 fa 89 d7 29 d0 01 da c1 c7 06 31 f8 89
c7 29 c3 01 d0 <c1> c7 08 31 fb 89 df 29 da 01 c3 c1 c7 10 31 fa 89 d7
29 d0 01 da
[  250.355035][    C1] RSP: 0018:ffffc900018a7a40 EFLAGS: 00000216
[  250.355050][    C1] RAX: 000000005f2a3d14 RBX: 0000000086514fa8
RCX: ffffc900018a7b14
[  250.355064][    C1] RDX: 000000000242647a RSI: 0000000000000005
RDI: 000000005ce7d89a
[  250.355076][    C1] RBP: ffffc900018a7ab0 R08: 000000000000000d
R09: 0000000000000000
[  250.355089][    C1] R10: 0000000000000000 R11: 000000000000000d
R12: 0000000000000000
[  250.355100][    C1] R13: 0000000000000000 R14: ffffc900018a7ac0
R15: 0000000000000001
[  250.355113][    C1] FS:  00007fdb4d99e8c0(0000)
GS:ffff8883eee80000(0000) knlGS:0000000000000000
[  250.355132][    C1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  250.355146][    C1] CR2: 00007fdb490fe020 CR3: 000000011bc32000
CR4: 0000000000350ea0
[  250.355159][    C1] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[  250.355170][    C1] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[  250.355183][    C1] Call Trace:
[  250.355187][    C1]  <TASK>
[  250.355193][    C1]  ? lockref_get_not_dead+0x181/0x2a0
[  250.355225][    C1]  ? kmem_cache_free+0x1f4/0x3a0
[  250.355246][    C1]  kasan_save_stack+0x3d/0x50
[  250.355267][    C1]  ? kasan_save_stack+0x26/0x50
[  250.355287][    C1]  ? kasan_set_track+0x25/0x30
[  250.355307][    C1]  ? kasan_save_free_info+0x2e/0x50
[  250.355333][    C1]  ? ____kasan_slab_free+0x13a/0x1a0
[  250.355354][    C1]  ? __kasan_slab_free+0x12/0x20
[  250.355376][    C1]  ? slab_free_freelist_hook+0xd2/0x1a0
[  250.355409][    C1]  ? kmem_cache_free+0x1f4/0x3a0
[  250.355428][    C1]  ? putname+0x115/0x150
[  250.355449][    C1]  ? user_path_at_empty+0x56/0x70
[  250.355473][    C1]  ? do_faccessat+0x147/0x840
[  250.355498][    C1]  ? __x64_sys_access+0x60/0x80
[  250.355525][    C1]  ? do_syscall_64+0x35/0x80
[  250.355547][    C1]  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  250.355581][    C1]  ? __sanitizer_cov_trace_cmp4+0x16/0x20
[  250.355603][    C1]  ? dput+0x11c/0xb40
[  250.355620][    C1]  ? try_to_unlazy+0x278/0x4f0
[  250.355640][    C1]  ? mntput+0x79/0xa0
[  250.355656][    C1]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[  250.355679][    C1]  ? terminate_walk+0x334/0x5f0
[  250.355699][    C1]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[  250.355722][    C1]  ? walk_component+0x10e/0x5d0
[  250.355745][    C1]  ? path_lookupat+0x25f/0x840
[  250.355769][    C1]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[  250.355791][    C1]  ? filename_lookup+0x3d2/0x590
[  250.355816][    C1]  ? may_linkat+0x520/0x520
[  250.355840][    C1]  kasan_set_track+0x25/0x30
[  250.355861][    C1]  kasan_save_free_info+0x2e/0x50
[  250.355888][    C1]  ____kasan_slab_free+0x13a/0x1a0
[  250.355910][    C1]  __kasan_slab_free+0x12/0x20
[  250.355932][    C1]  slab_free_freelist_hook+0xd2/0x1a0
[  250.355966][    C1]  ? putname+0x115/0x150
[  250.355987][    C1]  kmem_cache_free+0x1f4/0x3a0
[  250.356044][    C1]  putname+0x115/0x150
[  250.356066][    C1]  user_path_at_empty+0x56/0x70
[  250.356091][    C1]  do_faccessat+0x147/0x840
[  250.356116][    C1]  ? ksys_read+0x1cc/0x290
[  250.356149][    C1]  ? stream_open+0x60/0x60
[  250.356174][    C1]  ? __secure_computing+0x181/0x2f0
[  250.356199][    C1]  __x64_sys_access+0x60/0x80
[  250.356226][    C1]  do_syscall_64+0x35/0x80
[  250.356248][    C1]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  250.356299][    C1] Code: 83 c4 08 48 3d 01 f0 ff ff 73 01 c3 48 8b
0d c8 d4 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 b8 15
00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a1 d4 2b 00 f7 d8
64 89 01 48
[  250.356327][    C1] RSP: 002b:00007fff03576e68 EFLAGS: 00000246
ORIG_RAX: 0000000000000015
[  250.356345][    C1] RAX: ffffffffffffffda RBX: 00007fff03579d80
RCX: 00007fdb4c2db9c7
[  250.356358][    C1] RDX: 00007fdb4d360a00 RSI: 0000000000000000
RDI: 000055f4a1c229a3
[  250.356370][    C1] RBP: 00007fff03576ea0 R08: 0000000000000000
R09: 0000000000000000
[  250.356383][    C1] R10: 0000000000000069 R11: 0000000000000246
R12: 0000000000000000
[  250.356394][    C1] R13: 0000000000000000 R14: 00007fff03579d80
R15: 00007fff03577390
[  250.356420][    C3] NMI backtrace for cpu 3 skipped: idling at
default_idle+0x14/0x20


Regards,
Jun
