Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AFA6AE014
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 14:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjCGNNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 08:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjCGNMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 08:12:52 -0500
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 8E6F532507;
        Tue,  7 Mar 2023 05:11:33 -0800 (PST)
Received: from localhost.localdomain (unknown [122.235.142.236])
        by mail-app2 (Coremail) with SMTP id by_KCgCXnSGrNgdkbPtpCw--.43366S4;
        Tue, 07 Mar 2023 21:05:47 +0800 (CST)
From:   Lin Ma <linma@zju.edu.cn>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, richardcochran@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     intel-wired-lan@lists.osuosl.org, pmenzel@molgen.mpg.de,
        regressions@lists.linux.dev, vinschen@redhat.com,
        Lin Ma <linma@zju.edu.cn>, stable@vger.kernel.org
Subject: [PATCH] igb: revert rtnl_lock() that causes deadlock
Date:   Tue,  7 Mar 2023 21:05:47 +0800
Message-Id: <20230307130547.31446-1-linma@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <301b585a.80249.186bbe6cc50.Coremail.linma@zju.edu.cn>
References: <301b585a.80249.186bbe6cc50.Coremail.linma@zju.edu.cn>
X-CM-TRANSID: by_KCgCXnSGrNgdkbPtpCw--.43366S4
X-Coremail-Antispam: 1UD129KBjvJXoWxWw4xZw4kXw1DCw15Cr4fuFg_yoW5ZFy3pF
        13G3yxCF1kWr4jgayxZw18A34xXayjy34fWrn7uw4fuFs8CryDtry8CFWj93y5CrWxGF9F
        qF1kZa1UJF1UJa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6ry8MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUjySoJUUUUU==
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 6faee3d4ee8b ("igb: Add lock to avoid data race") adds
rtnl_lock to eliminate a false data race shown below

 (FREE from device detaching)      |   (USE from netdev core)
igb_remove                         |  igb_ndo_get_vf_config
 igb_disable_sriov                 |  vf >= adapter->vfs_allocated_count?
  kfree(adapter->vf_data)          |
  adapter->vfs_allocated_count = 0 |
                                   |    memcpy(... adapter->vf_data[vf]

The above race will never happen and the extra rtnl_lock causes deadlock
below

[  141.420169]  <TASK>
[  141.420672]  __schedule+0x2dd/0x840
[  141.421427]  schedule+0x50/0xc0
[  141.422041]  schedule_preempt_disabled+0x11/0x20
[  141.422678]  __mutex_lock.isra.13+0x431/0x6b0
[  141.423324]  unregister_netdev+0xe/0x20
[  141.423578]  igbvf_remove+0x45/0xe0 [igbvf]
[  141.423791]  pci_device_remove+0x36/0xb0
[  141.423990]  device_release_driver_internal+0xc1/0x160
[  141.424270]  pci_stop_bus_device+0x6d/0x90
[  141.424507]  pci_stop_and_remove_bus_device+0xe/0x20
[  141.424789]  pci_iov_remove_virtfn+0xba/0x120
[  141.425452]  sriov_disable+0x2f/0xf0
[  141.425679]  igb_disable_sriov+0x4e/0x100 [igb]
[  141.426353]  igb_remove+0xa0/0x130 [igb]
[  141.426599]  pci_device_remove+0x36/0xb0
[  141.426796]  device_release_driver_internal+0xc1/0x160
[  141.427060]  driver_detach+0x44/0x90
[  141.427253]  bus_remove_driver+0x55/0xe0
[  141.427477]  pci_unregister_driver+0x2a/0xa0
[  141.428296]  __x64_sys_delete_module+0x141/0x2b0
[  141.429126]  ? mntput_no_expire+0x4a/0x240
[  141.429363]  ? syscall_trace_enter.isra.19+0x126/0x1a0
[  141.429653]  do_syscall_64+0x5b/0x80
[  141.429847]  ? exit_to_user_mode_prepare+0x14d/0x1c0
[  141.430109]  ? syscall_exit_to_user_mode+0x12/0x30
[  141.430849]  ? do_syscall_64+0x67/0x80
[  141.431083]  ? syscall_exit_to_user_mode_prepare+0x183/0x1b0
[  141.431770]  ? syscall_exit_to_user_mode+0x12/0x30
[  141.432482]  ? do_syscall_64+0x67/0x80
[  141.432714]  ? exc_page_fault+0x64/0x140
[  141.432911]  entry_SYSCALL_64_after_hwframe+0x72/0xdc

Since the igb_disable_sriov() will call pci_disable_sriov() before
releasing any resources, the netdev core will synchronize the cleanup to
avoid any races. This patch removes the useless rtnl_(un)lock to guarantee
correctness.

CC: stable@vger.kernel.org
Fixes: 6faee3d4ee8b ("igb: Add lock to avoid data race")
Reported-by: Corinna <vinschen@redhat.com>
Link: https://lore.kernel.org/regressions/3ef31c0b-ce40-20d0-7740-5dc0cca278ca@molgen.mpg.de/
Signed-off-by: Lin Ma <linma@zju.edu.cn>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 03bc1e8af575..5532361b0e94 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3863,9 +3863,7 @@ static void igb_remove(struct pci_dev *pdev)
 	igb_release_hw_control(adapter);
 
 #ifdef CONFIG_PCI_IOV
-	rtnl_lock();
 	igb_disable_sriov(pdev);
-	rtnl_unlock();
 #endif
 
 	unregister_netdev(netdev);
-- 
2.34.1

