Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2694590C6
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhKVPFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:05:14 -0500
Received: from www62.your-server.de ([213.133.104.62]:57334 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhKVPFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:05:14 -0500
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mpApY-000G0s-Ec; Mon, 22 Nov 2021 16:02:04 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel test robot <oliver.sang@intel.com>,
        Li Zhijian <zhijianx.li@intel.com>
Subject: [PATCH net] net, neigh: Fix crash in v6 module initialization error path
Date:   Mon, 22 Nov 2021 16:01:51 +0100
Message-Id: <20211122150151.16447-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26361/Mon Nov 22 10:19:53 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When IPv6 module gets initialized, but it's hitting an error in inet6_init()
where it then needs to undo all the prior initialization work, it also might
do a call to ndisc_cleanup() which then calls neigh_table_clear(). In there
is a missing timer cancellation of the table's managed_work item.

The kernel test robot explicitly triggered this error path and caused a UAF
crash similar to the below:

  [...]
  [   28.833183][    C0] BUG: unable to handle page fault for address: f7a43288
  [   28.833973][    C0] #PF: supervisor write access in kernel mode
  [   28.834660][    C0] #PF: error_code(0x0002) - not-present page
  [   28.835319][    C0] *pde = 06b2c067 *pte = 00000000
  [   28.835853][    C0] Oops: 0002 [#1] PREEMPT
  [   28.836367][    C0] CPU: 0 PID: 303 Comm: sed Not tainted 5.16.0-rc1-00233-g83ff5faa0d3b #7
  [   28.837293][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1 04/01/2014
  [   28.838338][    C0] EIP: __run_timers.constprop.0+0x82/0x440
  [...]
  [   28.845607][    C0] Call Trace:
  [   28.845942][    C0]  <SOFTIRQ>
  [   28.846333][    C0]  ? check_preemption_disabled.isra.0+0x2a/0x80
  [   28.846975][    C0]  ? __this_cpu_preempt_check+0x8/0xa
  [   28.847570][    C0]  run_timer_softirq+0xd/0x40
  [   28.848050][    C0]  __do_softirq+0xf5/0x576
  [   28.848547][    C0]  ? __softirqentry_text_start+0x10/0x10
  [   28.849127][    C0]  do_softirq_own_stack+0x2b/0x40
  [   28.849749][    C0]  </SOFTIRQ>
  [   28.850087][    C0]  irq_exit_rcu+0x7d/0xc0
  [   28.850587][    C0]  common_interrupt+0x2a/0x40
  [   28.851068][    C0]  asm_common_interrupt+0x119/0x120
  [...]

Note that IPv6 module cannot be unloaded as per 8ce440610357 ("ipv6: do not
allow ipv6 module to be removed") hence this can only be seen during module
initialization error. Tested with kernel test robot's reproducer.

Fixes: 7482e3841d52 ("net, neigh: Add NTF_MANAGED flag for managed neighbor entries")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Li Zhijian <zhijianx.li@intel.com>
---
 net/core/neighbour.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 47931c8be04b..72ba027c34cf 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1779,6 +1779,7 @@ int neigh_table_clear(int index, struct neigh_table *tbl)
 {
 	neigh_tables[index] = NULL;
 	/* It is not clean... Fix it to unload IPv6 module safely */
+	cancel_delayed_work_sync(&tbl->managed_work);
 	cancel_delayed_work_sync(&tbl->gc_work);
 	del_timer_sync(&tbl->proxy_timer);
 	pneigh_queue_purge(&tbl->proxy_queue);
-- 
2.27.0

