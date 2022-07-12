Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFE15717F8
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiGLLFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbiGLLFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:05:17 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B875FAF76B
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:15 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t3so9378101edd.0
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8GiI7c6KLyvYWlAlrJO708tvc5vzNaQAzQETyEtyT+o=;
        b=4SyE+faZsJRdI883O1q/nOn+O9Ldvwmgxbk0IafFZGpMOHHUWo6uuIJujxMZeHtoV6
         fg3A57exAOhUn3lfcGaoROXESOQbtnUtn6TfFcfivNTqkgoshObehnHaDHdqTrXy7imp
         8Gsx5T3vv3D4NnkdarYEDmcmxHwRSeQY6DHJQjQOqcI8TnRww7rpzE1hg1T81o8Pw7ww
         bl0aqfvtGmlzdLZvnQoMa6bWLdrnMaktMiI5aEJToY9kFVCHP9u2JdM7oT4fKeKglztQ
         5u024wmymgPtWAwRQPpdxEwPXRPx5ytez/rLt4MzSppUdrdQ9zedYDAA2V2a9iSbhz0R
         FgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8GiI7c6KLyvYWlAlrJO708tvc5vzNaQAzQETyEtyT+o=;
        b=J2gZwmx45Rdbnr65mAYxAcI13/vf8BtMzv5HNyvDL7g+IXXC33iqV5LCSiOiWA3rHm
         g7r+92cC4QIcHOGTfs5YM6l/UFLbkSg84ojemwAJr5YQRvQRCd+3dm6VNK6LVl8m1DET
         +sSTQyDhIjGz3V4tVWpOfJvov6qDi/ljOEx0fPogk6msrsnoFq9OFYhL8DgXByd1yN08
         bSPJ9zhlAWK3cgl+SQrSveXMK1o58mi0xnLEtFB4GvpwPvf5kBNLJeqNzjTkR0UkUlg6
         nPazWcpTWCyPFQpLEC6bArrkS6ja3DUbPFngszftYVMYwGlIl6PPz1SOLO56icS90XiV
         HCEg==
X-Gm-Message-State: AJIora/aesJTYDnaJ9JfZQ5lrulJQkMCZS7iXeRuAJ2Uw2CHrCmoM2Ci
        m52d8AFxj5NUDAUwo8iSda0MjAPAjLMPDhElaDU=
X-Google-Smtp-Source: AGRyM1u3s565X0yR1rbnV43SacZB5lBnB2JCCvrzTsvp1OQFEF7Yw8RkHBe6c3tXlMu1am3e6wy2qQ==
X-Received: by 2002:a05:6402:5c9:b0:420:aac6:257b with SMTP id n9-20020a05640205c900b00420aac6257bmr31125197edx.128.1657623914238;
        Tue, 12 Jul 2022 04:05:14 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id ku19-20020a170907789300b006fece722508sm3630913ejc.135.2022.07.12.04.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:05:13 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, idosch@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: [patch net-next RFC 01/10] net: devlink: avoid false DEADLOCK warning reported by lockdep
Date:   Tue, 12 Jul 2022 13:05:02 +0200
Message-Id: <20220712110511.2834647-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712110511.2834647-1-jiri@resnulli.us>
References: <20220712110511.2834647-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

Add a lock_class_key per devlink instance to avoid DEADLOCK warning by
lockdep, while locking more than one devlink instance in driver code,
for example in opening VFs flow.

Kernel log:
[  101.433802] ============================================
[  101.433803] WARNING: possible recursive locking detected
[  101.433810] 5.19.0-rc1+ #35 Not tainted
[  101.433812] --------------------------------------------
[  101.433813] bash/892 is trying to acquire lock:
[  101.433815] ffff888127bfc2f8 (&devlink->lock){+.+.}-{3:3}, at: probe_one+0x3c/0x690 [mlx5_core]
[  101.433909]
               but task is already holding lock:
[  101.433910] ffff888118f4c2f8 (&devlink->lock){+.+.}-{3:3}, at: mlx5_core_sriov_configure+0x62/0x280 [mlx5_core]
[  101.433989]
               other info that might help us debug this:
[  101.433990]  Possible unsafe locking scenario:

[  101.433991]        CPU0
[  101.433991]        ----
[  101.433992]   lock(&devlink->lock);
[  101.433993]   lock(&devlink->lock);
[  101.433995]
                *** DEADLOCK ***

[  101.433996]  May be due to missing lock nesting notation

[  101.433996] 6 locks held by bash/892:
[  101.433998]  #0: ffff88810eb50448 (sb_writers#3){.+.+}-{0:0}, at: ksys_write+0xf3/0x1d0
[  101.434009]  #1: ffff888114777c88 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x20d/0x520
[  101.434017]  #2: ffff888102b58660 (kn->active#231){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x230/0x520
[  101.434023]  #3: ffff888102d70198 (&dev->mutex){....}-{3:3}, at: sriov_numvfs_store+0x132/0x310
[  101.434031]  #4: ffff888118f4c2f8 (&devlink->lock){+.+.}-{3:3}, at: mlx5_core_sriov_configure+0x62/0x280 [mlx5_core]
[  101.434108]  #5: ffff88812adce198 (&dev->mutex){....}-{3:3}, at: __device_attach+0x76/0x430
[  101.434116]
               stack backtrace:
[  101.434118] CPU: 5 PID: 892 Comm: bash Not tainted 5.19.0-rc1+ #35
[  101.434120] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  101.434130] Call Trace:
[  101.434133]  <TASK>
[  101.434135]  dump_stack_lvl+0x57/0x7d
[  101.434145]  __lock_acquire.cold+0x1df/0x3e7
[  101.434151]  ? register_lock_class+0x1880/0x1880
[  101.434157]  lock_acquire+0x1c1/0x550
[  101.434160]  ? probe_one+0x3c/0x690 [mlx5_core]
[  101.434229]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[  101.434232]  ? __xa_alloc+0x1ed/0x2d0
[  101.434236]  ? ksys_write+0xf3/0x1d0
[  101.434239]  __mutex_lock+0x12c/0x14b0
[  101.434243]  ? probe_one+0x3c/0x690 [mlx5_core]
[  101.434312]  ? probe_one+0x3c/0x690 [mlx5_core]
[  101.434380]  ? devlink_alloc_ns+0x11b/0x910
[  101.434385]  ? mutex_lock_io_nested+0x1320/0x1320
[  101.434388]  ? lockdep_init_map_type+0x21a/0x7d0
[  101.434391]  ? lockdep_init_map_type+0x21a/0x7d0
[  101.434393]  ? __init_swait_queue_head+0x70/0xd0
[  101.434397]  probe_one+0x3c/0x690 [mlx5_core]
[  101.434467]  pci_device_probe+0x1b4/0x480
[  101.434471]  really_probe+0x1e0/0xaa0
[  101.434474]  __driver_probe_device+0x219/0x480
[  101.434478]  driver_probe_device+0x49/0x130
[  101.434481]  __device_attach_driver+0x1b8/0x280
[  101.434484]  ? driver_allows_async_probing+0x140/0x140
[  101.434487]  bus_for_each_drv+0x123/0x1a0
[  101.434489]  ? bus_for_each_dev+0x1a0/0x1a0
[  101.434491]  ? lockdep_hardirqs_on_prepare+0x286/0x400
[  101.434494]  ? trace_hardirqs_on+0x2d/0x100
[  101.434498]  __device_attach+0x1a3/0x430
[  101.434501]  ? device_driver_attach+0x1e0/0x1e0
[  101.434503]  ? pci_bridge_d3_possible+0x1e0/0x1e0
[  101.434506]  ? pci_create_resource_files+0xeb/0x190
[  101.434511]  pci_bus_add_device+0x6c/0xa0
[  101.434514]  pci_iov_add_virtfn+0x9e4/0xe00
[  101.434517]  ? trace_hardirqs_on+0x2d/0x100
[  101.434521]  sriov_enable+0x64a/0xca0
[  101.434524]  ? pcibios_sriov_disable+0x10/0x10
[  101.434528]  mlx5_core_sriov_configure+0xab/0x280 [mlx5_core]
[  101.434602]  sriov_numvfs_store+0x20a/0x310
[  101.434605]  ? sriov_totalvfs_show+0xc0/0xc0
[  101.434608]  ? sysfs_file_ops+0x170/0x170
[  101.434611]  ? sysfs_file_ops+0x117/0x170
[  101.434614]  ? sysfs_file_ops+0x170/0x170
[  101.434616]  kernfs_fop_write_iter+0x348/0x520
[  101.434619]  new_sync_write+0x2e5/0x520
[  101.434621]  ? new_sync_read+0x520/0x520
[  101.434624]  ? lock_acquire+0x1c1/0x550
[  101.434626]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[  101.434630]  vfs_write+0x5cb/0x8d0
[  101.434633]  ksys_write+0xf3/0x1d0
[  101.434635]  ? __x64_sys_read+0xb0/0xb0
[  101.434638]  ? lockdep_hardirqs_on_prepare+0x286/0x400
[  101.434640]  ? syscall_enter_from_user_mode+0x1d/0x50
[  101.434643]  do_syscall_64+0x3d/0x90
[  101.434647]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  101.434650] RIP: 0033:0x7f5ff536b2f7
[  101.434658] Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f
1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f
05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[  101.434661] RSP: 002b:00007ffd9ea85d58 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  101.434664] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f5ff536b2f7
[  101.434666] RDX: 0000000000000002 RSI: 000055c4c279e230 RDI: 0000000000000001
[  101.434668] RBP: 000055c4c279e230 R08: 000000000000000a R09: 0000000000000001
[  101.434669] R10: 000055c4c283cbf0 R11: 0000000000000246 R12: 0000000000000002
[  101.434670] R13: 00007f5ff543d500 R14: 0000000000000002 R15: 00007f5ff543d700
[  101.434673]  </TASK>

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index a9776ea923ae..d2a4e6ee1be6 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -66,6 +66,7 @@ struct devlink {
 	 * port, sb, dpipe, resource, params, region, traps and more.
 	 */
 	struct mutex lock;
+	struct lock_class_key lock_key;
 	u8 reload_failed:1;
 	refcount_t refcount;
 	struct completion comp;
@@ -9472,7 +9473,9 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	INIT_LIST_HEAD(&devlink->trap_list);
 	INIT_LIST_HEAD(&devlink->trap_group_list);
 	INIT_LIST_HEAD(&devlink->trap_policer_list);
+	lockdep_register_key(&devlink->lock_key);
 	mutex_init(&devlink->lock);
+	lockdep_set_class(&devlink->lock, &devlink->lock_key);
 	mutex_init(&devlink->reporters_lock);
 	mutex_init(&devlink->linecards_lock);
 	refcount_set(&devlink->refcount, 1);
@@ -9619,6 +9622,7 @@ void devlink_free(struct devlink *devlink)
 	mutex_destroy(&devlink->linecards_lock);
 	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->lock);
+	lockdep_unregister_key(&devlink->lock_key);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
 	WARN_ON(!list_empty(&devlink->trap_group_list));
 	WARN_ON(!list_empty(&devlink->trap_list));
-- 
2.35.3

