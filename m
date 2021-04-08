Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B410358B70
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 19:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbhDHRe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 13:34:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:25284 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232476AbhDHReL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 13:34:11 -0400
IronPort-SDR: E6Q27bUrG31XNlbmeLh1+IyidbXjQFiY37nb36QhkUKraS7TeU4Msrra4iqVdp9XA0KEd8NYDG
 ms6VL5BC8KbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="181132912"
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="181132912"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 10:33:58 -0700
IronPort-SDR: 9rvuxObR1ybD13ojoVplS1avqSKrWUynwSzWho289Gfoh7Y7C5mrlmEndywgXoGk6D5YWBe6Wx
 uaCRBbUMWgqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="422343459"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 08 Apr 2021 10:33:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Yongxin Liu <yongxin.liu@windriver.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        brett.creeley@intel.com, Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 6/6] ice: fix memory leak of aRFS after resuming from suspend
Date:   Thu,  8 Apr 2021 10:35:37 -0700
Message-Id: <20210408173537.3519606-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408173537.3519606-1-anthony.l.nguyen@intel.com>
References: <20210408173537.3519606-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yongxin Liu <yongxin.liu@windriver.com>

In ice_suspend(), ice_clear_interrupt_scheme() is called, and then
irq_free_descs() will be eventually called to free irq and its descriptor.

In ice_resume(), ice_init_interrupt_scheme() is called to allocate new
irqs. However, in ice_rebuild_arfs(), struct irq_glue and struct cpu_rmap
maybe cannot be freed, if the irqs that released in ice_suspend() were
reassigned to other devices, which makes irq descriptor's affinity_notify
lost.

So call ice_free_cpu_rx_rmap() before ice_clear_interrupt_scheme(), which
can make sure all irq_glue and cpu_rmap can be correctly released before
corresponding irq and descriptor are released.

Fix the following memory leak.

unreferenced object 0xffff95bd951afc00 (size 512):
  comm "kworker/0:1", pid 134, jiffies 4294684283 (age 13051.958s)
  hex dump (first 32 bytes):
    18 00 00 00 18 00 18 00 70 fc 1a 95 bd 95 ff ff  ........p.......
    00 00 ff ff 01 00 ff ff 02 00 ff ff 03 00 ff ff  ................
  backtrace:
    [<0000000072e4b914>] __kmalloc+0x336/0x540
    [<0000000054642a87>] alloc_cpu_rmap+0x3b/0xb0
    [<00000000f220deec>] ice_set_cpu_rx_rmap+0x6a/0x110 [ice]
    [<000000002370a632>] ice_probe+0x941/0x1180 [ice]
    [<00000000d692edba>] local_pci_probe+0x47/0xa0
    [<00000000503934f0>] work_for_cpu_fn+0x1a/0x30
    [<00000000555a9e4a>] process_one_work+0x1dd/0x410
    [<000000002c4b414a>] worker_thread+0x221/0x3f0
    [<00000000bb2b556b>] kthread+0x14c/0x170
    [<00000000ad2cf1cd>] ret_from_fork+0x1f/0x30
unreferenced object 0xffff95bd81b0a2a0 (size 96):
  comm "kworker/0:1", pid 134, jiffies 4294684283 (age 13051.958s)
  hex dump (first 32 bytes):
    38 00 00 00 01 00 00 00 e0 ff ff ff 0f 00 00 00  8...............
    b0 a2 b0 81 bd 95 ff ff b0 a2 b0 81 bd 95 ff ff  ................
  backtrace:
    [<00000000582dd5c5>] kmem_cache_alloc_trace+0x31f/0x4c0
    [<000000002659850d>] irq_cpu_rmap_add+0x25/0xe0
    [<00000000495a3055>] ice_set_cpu_rx_rmap+0xb4/0x110 [ice]
    [<000000002370a632>] ice_probe+0x941/0x1180 [ice]
    [<00000000d692edba>] local_pci_probe+0x47/0xa0
    [<00000000503934f0>] work_for_cpu_fn+0x1a/0x30
    [<00000000555a9e4a>] process_one_work+0x1dd/0x410
    [<000000002c4b414a>] worker_thread+0x221/0x3f0
    [<00000000bb2b556b>] kthread+0x14c/0x170
    [<00000000ad2cf1cd>] ret_from_fork+0x1f/0x30

Fixes: 769c500dcc1e ("ice: Add advanced power mgmt for WoL")
Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9f1adff85be7..d821c687f239 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4564,6 +4564,7 @@ static int __maybe_unused ice_suspend(struct device *dev)
 			continue;
 		ice_vsi_free_q_vectors(pf->vsi[v]);
 	}
+	ice_free_cpu_rx_rmap(ice_get_main_vsi(pf));
 	ice_clear_interrupt_scheme(pf);
 
 	pci_save_state(pdev);
-- 
2.26.2

