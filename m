Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A48B96D1201
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 00:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjC3WPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 18:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjC3WPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 18:15:22 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9BB9754
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 15:15:21 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id j2so3577693ila.8
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 15:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1680214520;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tLH0Td2ascDUzjU9ndqNgLKDd1EkiK8qFJUJNJtya4c=;
        b=aW0m/dWEF33JKCkWk2NWJp+Y93XhERkqXSkdyUkSWEibWKAX73JCXhIMKKmVMer/cu
         qKLR/bBVnYaWm/nvmyS1IBfyh8PERiz0+FtHQ1uqHWNk2np14wMHUqcCTyNxheDIAl8J
         D37nKiAathkHE1yqZ9vaQcH2of3/wYXmm8KsQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680214520;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tLH0Td2ascDUzjU9ndqNgLKDd1EkiK8qFJUJNJtya4c=;
        b=uB0xnjRT4KscKldcQiMAKazT4M+DcSMHRjXjMr3m50xSZt5nFXTVI7rPIpI2YZIbw+
         8bIM5Uh9d1paeMEAwgASKNd7i3/BlKII0iDFpsrkR+NJX8sDwcX4vjNa3eoqvKss8MBq
         mS/9wP1ePtLOniJP/Tb5XAIFAQaajvoxwbIXRPyZtwdF1bbrx+tjoA6rhC/oRunLst7q
         KYlOb92ExB14Oc9fZJWjnAgozDwC4RkeAEC3bXf31h/OSwrn+iZfdTamJnpRQA+exzyw
         cXYdcO8pzAvADxUjGrDXw/H39+7usWKAt/ranW28Q3UsfiPBRiTPYxpEH/7XcyJNlSvS
         u/xw==
X-Gm-Message-State: AAQBX9fIYOVNDoZ0r29fm8ch3zu8j7tFdM17K67bldNwY52hXDjcUXM/
        1bBRnvplLOXcmv5brR+yYEJgcEYx0KbR3Of5BeE=
X-Google-Smtp-Source: AKy350btOtkPOChY+Eihw7SMuMOK4fp1YUL4wWKVOPh2SbRQju+zXA62jsMJFKPTnKxdl7NxMNBkYQ==
X-Received: by 2002:a92:de50:0:b0:326:3174:bc45 with SMTP id e16-20020a92de50000000b003263174bc45mr4156395ilr.26.1680214520595;
        Thu, 30 Mar 2023 15:15:20 -0700 (PDT)
Received: from [192.168.0.41] ([70.57.89.124])
        by smtp.gmail.com with ESMTPSA id o15-20020a056e02068f00b00325cad35683sm222600ils.7.2023.03.30.15.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 15:15:20 -0700 (PDT)
Message-ID: <be5b9271-7507-19c5-ded1-fa78f1980e69@cloudflare.com>
Date:   Thu, 30 Mar 2023 17:15:19 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Content-Language: en-US
To:     saeedm@nvidia.com
Cc:     netdev@vger.kernel.org, linux-team@cloudflare.com
From:   Frederick Lawler <fred@cloudflare.com>
Subject: mlx5e: BUG: KASAN: use-after-free on shutdown
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We recently saw with Linux 6.1.21 a use-after-free bug in mlx5e on 
device shutdown followed by a general protection fault in our KASAN 
kernel. Does this occur because we're potentially doing concurrent work 
while the shutdown is happening?

mlx5_core 0000:c1:00.0 eth0: TX timeout on queue: 25, SQ: 0x2bb, CQ: 
0x80, SQ Cons: 0x2 SQ Prod: 0x4, usecs since last trans: 16233000
mlx5_core 0000:c1:00.0: mlx5_rsc_dump_trigger:116:(pid 13608): Resource 
dump: Failed to access err -67
mlx5_core 0000:c1:00.0: mlx5_rsc_dump_next:173:(pid 13608): Resource 
dump: Failed to trigger dump, -67
mlx5_core 0000:c1:00.0 eth0: EQ 0x20: Cons = 0x2da, irqn = 0x3ed
==================================================================
BUG: KASAN: use-after-free in _find_first_bit+0x66/0x80
Read of size 8 at addr ffff88823fc0d318 by task kworker/u192:0/13608

CPU: 25 PID: 13608 Comm: kworker/u192:0 Tainted: G    B   W  O 
6.1.21-cloudflare-kasan-2023.3.21 #1
Hardware name: GIGABYTE R162-R2-GEN0/MZ12-HD2-CD, BIOS R14 05/03/2021
Workqueue: mlx5e mlx5e_tx_timeout_work [mlx5_core]
Call Trace:
  <TASK>
  dump_stack_lvl+0x34/0x48
  print_report+0x170/0x473
  ? _find_first_bit+0x66/0x80
  kasan_report+0xad/0x130
  ? _find_first_bit+0x66/0x80
  _find_first_bit+0x66/0x80
  mlx5e_open_channels+0x3c5/0x3a10 [mlx5_core]
  ? console_unlock+0x2fa/0x430
  ? _raw_spin_lock_irqsave+0x8d/0xf0
  ? _raw_spin_unlock_irqrestore+0x42/0x80
  ? preempt_count_add+0x7d/0x150
  ? __wake_up_klogd.part.0+0x7d/0xc0
  ? vprintk_emit+0xfe/0x2c0
  ? mlx5e_trigger_napi_sched+0x40/0x40 [mlx5_core]
  ? dev_attr_show.cold+0x35/0x35
  ? devlink_health_do_dump.part.0+0x174/0x340
  ? devlink_health_report+0x504/0x810
  ? mlx5e_reporter_tx_timeout+0x29d/0x3a0 [mlx5_core]
  ? mlx5e_tx_timeout_work+0x17c/0x230 [mlx5_core]
  ? process_one_work+0x680/0x1050
  mlx5e_safe_switch_params+0x156/0x220 [mlx5_core]
  ? mlx5e_switch_priv_channels+0x310/0x310 [mlx5_core]
  ? mlx5_eq_poll_irq_disabled+0xb6/0x100 [mlx5_core]
  mlx5e_tx_reporter_timeout_recover+0x123/0x240 [mlx5_core]
  ? __mutex_unlock_slowpath.constprop.0+0x2b0/0x2b0
  devlink_health_reporter_recover+0xa6/0x1f0
  devlink_health_report+0x2f7/0x810
  ? vsnprintf+0x854/0x15e0
  mlx5e_reporter_tx_timeout+0x29d/0x3a0 [mlx5_core]
  ? mlx5e_reporter_tx_err_cqe+0x1a0/0x1a0 [mlx5_core]
  ? mlx5e_tx_reporter_timeout_dump+0x50/0x50 [mlx5_core]
  ? mlx5e_tx_reporter_dump_sq+0x260/0x260 [mlx5_core]
  ? newidle_balance+0x9b7/0xe30
  ? psi_group_change+0x6a7/0xb80
  ? mutex_lock+0x96/0xf0
  ? __mutex_lock_slowpath+0x10/0x10
  mlx5e_tx_timeout_work+0x17c/0x230 [mlx5_core]
  process_one_work+0x680/0x1050
  worker_thread+0x5a0/0xeb0
  ? process_one_work+0x1050/0x1050
  kthread+0x2a2/0x340
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x22/0x30
  </TASK>

Freed by task 1:
  kasan_save_stack+0x23/0x50
  kasan_set_track+0x21/0x30
  kasan_save_free_info+0x2a/0x40
  ____kasan_slab_free+0x169/0x1d0
  slab_free_freelist_hook+0xd2/0x190
  __kmem_cache_free+0x1a1/0x2f0
  irq_pool_free+0x138/0x200 [mlx5_core]
  mlx5_irq_table_destroy+0xf6/0x170 [mlx5_core]
  mlx5_core_eq_free_irqs+0x74/0xf0 [mlx5_core]
  shutdown+0x194/0x1aa [mlx5_core]
  pci_device_shutdown+0x75/0x120
  device_shutdown+0x35c/0x620
  kernel_restart+0x60/0xa0
  __do_sys_reboot+0x1cb/0x2c0
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x4b/0xb5

The buggy address belongs to the object at ffff88823fc0d300
  which belongs to the cache kmalloc-192 of size 192
The buggy address is located 24 bytes inside of
  192-byte region [ffff88823fc0d300, ffff88823fc0d3c0)

The buggy address belongs to the physical page:
page:0000000010139587 refcount:1 mapcount:0 mapping:0000000000000000 
index:0x0 pfn:0x23fc0c
head:0000000010139587 order:1 compound_mapcount:0 compound_pincount:0
flags: 0x2ffff800010200(slab|head|node=0|zone=2|lastcpupid=0x1ffff)
raw: 002ffff800010200 0000000000000000 dead000000000122 ffff88810004ca00
raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88823fc0d200: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88823fc0d280: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 >ffff88823fc0d300: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                             ^
  ffff88823fc0d380: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
  ffff88823fc0d400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================
general protection fault, probably for non-canonical address 
0xdffffc005c40d7ac: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: probably user-memory-access in range 
[0x00000002e206bd60-0x00000002e206bd67]
CPU: 25 PID: 13608 Comm: kworker/u192:0 Tainted: G    B   W  O 
6.1.21-cloudflare-kasan-2023.3.21 #1
Hardware name: GIGABYTE R162-R2-GEN0/MZ12-HD2-CD, BIOS R14 05/03/2021
Workqueue: mlx5e mlx5e_tx_timeout_work [mlx5_core]
RIP: 0010:__alloc_pages+0x141/0x5c0
Code: e0 39 a3 96 89 e9 b8 22 01 32 01 83 e1 0f 48 89 fa 01 c9 48 c1 ea 
03 d3 f8 83 e0 03 89 44 24 6c 48 b8 00 00 00 00 00 fc ff df <80> 3c 02 
00 0f 85 fc 03 00 00 89 e8 4a 8b 14 f5 e0 39 a3 96 4c 89
RSP: 0018:ffff888251f0f438 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 1ffff1104a3e1e8b RCX: 0000000000000000
RDX: 000000005c40d7ac RSI: 0000000000000003 RDI: 00000002e206bd60
RBP: 0000000000052dc0 R08: ffff8882b0044218 R09: ffff8882b0045e8a
R10: fffffbfff300fefc R11: ffff888167af4000 R12: 0000000000000003
R13: 0000000000000000 R14: 00000000696c7070 R15: ffff8882373f4380
FS:  0000000000000000(0000) GS:ffff88bf2be80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005641d031eee8 CR3: 0000002e7ca14000 CR4: 0000000000350ee0
Call Trace:
  <TASK>
  ? sysvec_apic_timer_interrupt+0xa0/0xc0
  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
  ? __alloc_pages_slowpath.constprop.0+0x1ec0/0x1ec0
  ? _raw_spin_unlock_irqrestore+0x3d/0x80
  __kmalloc_large_node+0x80/0x120
  ? kvmalloc_node+0x4e/0x170
  __kmalloc_node+0xd4/0x150
  kvmalloc_node+0x4e/0x170
  mlx5e_open_channels+0x631/0x3a10 [mlx5_core]
  ? console_unlock+0x2fa/0x430
  ? _raw_spin_lock_irqsave+0x8d/0xf0
  ? _raw_spin_unlock_irqrestore+0x42/0x80
  ? preempt_count_add+0x7d/0x150
  ? __wake_up_klogd.part.0+0x7d/0xc0
  ? vprintk_emit+0xfe/0x2c0
  ? mlx5e_trigger_napi_sched+0x40/0x40 [mlx5_core]
  ? dev_attr_show.cold+0x35/0x35
  ? devlink_health_do_dump.part.0+0x174/0x340
  ? devlink_health_report+0x504/0x810
  ? mlx5e_reporter_tx_timeout+0x29d/0x3a0 [mlx5_core]
  ? mlx5e_tx_timeout_work+0x17c/0x230 [mlx5_core]
  ? process_one_work+0x680/0x1050
  mlx5e_safe_switch_params+0x156/0x220 [mlx5_core]
  ? mlx5e_switch_priv_channels+0x310/0x310 [mlx5_core]
  ? mlx5_eq_poll_irq_disabled+0xb6/0x100 [mlx5_core]
  mlx5e_tx_reporter_timeout_recover+0x123/0x240 [mlx5_core]
  ? __mutex_unlock_slowpath.constprop.0+0x2b0/0x2b0
  devlink_health_reporter_recover+0xa6/0x1f0
  devlink_health_report+0x2f7/0x810
  ? vsnprintf+0x854/0x15e0
  mlx5e_reporter_tx_timeout+0x29d/0x3a0 [mlx5_core]
  ? mlx5e_reporter_tx_err_cqe+0x1a0/0x1a0 [mlx5_core]
  ? mlx5e_tx_reporter_timeout_dump+0x50/0x50 [mlx5_core]
  ? mlx5e_tx_reporter_dump_sq+0x260/0x260 [mlx5_core]
  ? newidle_balance+0x9b7/0xe30
  ? psi_group_change+0x6a7/0xb80
  ? mutex_lock+0x96/0xf0
  ? __mutex_lock_slowpath+0x10/0x10
  mlx5e_tx_timeout_work+0x17c/0x230 [mlx5_core]
  process_one_work+0x680/0x1050
  worker_thread+0x5a0/0xeb0
  ? process_one_work+0x1050/0x1050
  kthread+0x2a2/0x340
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x22/0x30
  </TASK>
Modules linked in: essiv dm_crypt trusted tee asn1_encoder sch_fq 
nf_conntrack nf_defrag_ipv4 nf_defrag_ipv6 8021q mrp garp stp llc 
bonding amd64_edac kvm_amd kvm irqbypass crc32_pclmul crc32c_intel 
sha512_ssse3 ipmi_ssif aesni_intel mlx5_core rapl psample acpi_ipmi 
xhci_pci nvme tls ipmi_si mlxfw ipmi_devintf ccp xhci_hcd nvme_core 
i2c_piix4 tiny_power_button ipmi_msghandler button fuse dm_mod dax 
efivarfs ip_tables x_tables bcmcrypt(O) crypto_simd cryptd
---[ end trace 0000000000000000 ]---
RIP: 0010:__alloc_pages+0x141/0x5c0
Code: e0 39 a3 96 89 e9 b8 22 01 32 01 83 e1 0f 48 89 fa 01 c9 48 c1 ea 
03 d3 f8 83 e0 03 89 44 24 6c 48 b8 00 00 00 00 00 fc ff df <80> 3c 02 
00 0f 85 fc 03 00 00 89 e8 4a 8b 14 f5 e0 39 a3 96 4c 89
RSP: 0018:ffff888251f0f438 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 1ffff1104a3e1e8b RCX: 0000000000000000
RDX: 000000005c40d7ac RSI: 0000000000000003 RDI: 00000002e206bd60
RBP: 0000000000052dc0 R08: ffff8882b0044218 R09: ffff8882b0045e8a
R10: fffffbfff300fefc R11: ffff888167af4000 R12: 0000000000000003
R13: 0000000000000000 R14: 00000000696c7070 R15: ffff8882373f4380
FS:  0000000000000000(0000) GS:ffff88bf2be80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005641d031eee8 CR3: 0000002e7ca14000 CR4: 0000000000350ee0
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x11000000 from 0xffffffff81000000 (relocation range: 
0xffffffff80000000-0xffffffffbfffffff)
---[ end Kernel panic - not syncing: Fatal exception ]---
