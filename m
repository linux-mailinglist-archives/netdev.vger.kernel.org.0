Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3914913379E
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 00:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbgAGXoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 18:44:12 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:49775 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgAGXoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 18:44:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578440652; x=1609976652;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=UUoiDw62OaoiuTXALuZgpOAThPO4x4J408qVWSCrhCo=;
  b=cZePfaWPziR9BAUDorN9tfzkFJ7NWKZgaejJjmk+TT1sj8J0+PgsmZOp
   dOQeCIcThmGANtj6Iuwhc51tvm+9gtP0/42cpm374XCdAbIIp6jGtp2iJ
   FuyuGbF4w7HUJdoCJh6hqXKIdV+ylrFMBBx5iOlDnOB9UpVTnObHMTh9v
   0=;
IronPort-SDR: isxIpuJEy/UGoJ7F3jCaH/LivfpJTT57vE63npovTgLeuI1NC402U0z8/k1z0K0aWtOUJYTNvY
 USeGTNst5HPQ==
X-IronPort-AV: E=Sophos;i="5.69,407,1571702400"; 
   d="scan'208";a="11335420"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 07 Jan 2020 23:44:11 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 14441A29F4;
        Tue,  7 Jan 2020 23:44:09 +0000 (UTC)
Received: from EX13D05UWC002.ant.amazon.com (10.43.162.92) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 Jan 2020 23:43:47 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D05UWC002.ant.amazon.com (10.43.162.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 Jan 2020 23:43:47 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Tue, 7 Jan 2020 23:43:47 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id B359440E65; Tue,  7 Jan 2020 23:43:47 +0000 (UTC)
Date:   Tue, 7 Jan 2020 23:43:47 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <boris.ostrovsky@oracle.com>,
        <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <sstabellini@kernel.org>, <konrad.wilk@oracle.co>,
        <roger.pau@citrix.com>, <axboe@kernel.dk>, <davem@davemloft.net>,
        <rjw@rjwysocki.net>, <len.brown@intel.com>, <pavel@ucw.cz>,
        <peterz@infradead.org>, <eduval@amazon.com>, <sblbir@amazon.com>,
        <anchalag@amazon.com>, <xen-devel@lists.xenproject.org>,
        <vkuznets@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>,
        <dwmw@amazon.co.uk>, <fllinden@amaozn.com>
CC:     <anchalag@amazon.com>
Subject: [RFC PATCH V2 08/11] x86/xen: close event channels for PIRQs in
 system core suspend callback
Message-ID: <20200107234347.GA18699@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Munehisa Kamata <kamatam@amazon.com>

There are no pm handlers for the legacy devices, so during tear down
stale event channel <> IRQ mapping may still remain in the image and resume
may fail. To avoid adding much code by implementing handlers for legacy
devices, add a simple helper function to "shutdown" active PIRQs, which
actually closes event channels but keeps related IRQ structures intact.
PM suspend/hibernation code will rely on this.
Close event channels allocated for devices which are backed by PIRQ and
still active when suspending the system core. Normally, the devices are
emulated legacy devices, e.g. PS/2 keyboard, floppy controller and etc.
Without this, in PM hibernation, information about the event channel
remains in hibernation image, but there is no guarantee that the same
event channel numbers are assigned to the devices when restoring the
system. This may cause conflict like the following and prevent some
devices from being restored correctly.

[  102.330821] ------------[ cut here ]------------
[  102.333264] WARNING: CPU: 0 PID: 2324 at
drivers/xen/events/events_base.c:878 bind_evtchn_to_irq+0x88/0xf0
...
[  102.348057] Call Trace:
[  102.348057]  [<ffffffff813001df>] dump_stack+0x63/0x84
[  102.348057]  [<ffffffff81071811>] __warn+0xd1/0xf0
[  102.348057]  [<ffffffff810718fd>] warn_slowpath_null+0x1d/0x20
[  102.348057]  [<ffffffff8139a1f8>] bind_evtchn_to_irq+0x88/0xf0
[  102.348057]  [<ffffffffa00cd420>] ? blkif_copy_from_grant+0xb0/0xb0 [xen_blkfront]
[  102.348057]  [<ffffffff8139a307>] bind_evtchn_to_irqhandler+0x27/0x80
[  102.348057]  [<ffffffffa00cc785>] talk_to_blkback+0x425/0xcd0 [xen_blkfront]
[  102.348057]  [<ffffffff811e0c8a>] ? __kmalloc+0x1ea/0x200
[  102.348057]  [<ffffffffa00ce84d>] blkfront_restore+0x2d/0x60 [xen_blkfront]
[  102.348057]  [<ffffffff813a0078>] xenbus_dev_restore+0x58/0x100
[  102.348057]  [<ffffffff813a1ff0>] ?  xenbus_frontend_delayed_resume+0x20/0x20
[  102.348057]  [<ffffffff813a200e>] xenbus_dev_cond_restore+0x1e/0x30
[  102.348057]  [<ffffffff813f797e>] dpm_run_callback+0x4e/0x130
[  102.348057]  [<ffffffff813f7f17>] device_resume+0xe7/0x210
[  102.348057]  [<ffffffff813f7810>] ? pm_dev_dbg+0x80/0x80
[  102.348057]  [<ffffffff813f9374>] dpm_resume+0x114/0x2f0
[  102.348057]  [<ffffffff810c00cf>] hibernation_snapshot+0x15f/0x380
[  102.348057]  [<ffffffff810c0ac3>] hibernate+0x183/0x290
[  102.348057]  [<ffffffff810be1af>] state_store+0xcf/0xe0
[  102.348057]  [<ffffffff813020bf>] kobj_attr_store+0xf/0x20
[  102.348057]  [<ffffffff8127c88a>] sysfs_kf_write+0x3a/0x50
[  102.348057]  [<ffffffff8127c3bb>] kernfs_fop_write+0x10b/0x190
[  102.348057]  [<ffffffff81200008>] __vfs_write+0x28/0x120
[  102.348057]  [<ffffffff81200c19>] ? rw_verify_area+0x49/0xb0
[  102.348057]  [<ffffffff81200e62>] vfs_write+0xb2/0x1b0
[  102.348057]  [<ffffffff81202196>] SyS_write+0x46/0xa0
[  102.348057]  [<ffffffff81520cf7>] entry_SYSCALL_64_fastpath+0x1a/0xa9
[  102.423005] ---[ end trace b8d6718e22e2b107 ]---
[  102.425031] genirq: Flags mismatch irq 6. 00000000 (blkif) vs. 00000000 (floppy)

Note that we don't explicitly re-allocate event channels for such
devices in the resume callback. Re-allocation will occur when PM core
re-enable IRQs for the devices at later point.

Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
---
 arch/x86/xen/suspend.c           |  2 ++
 drivers/xen/events/events_base.c | 12 ++++++++++++
 include/xen/events.h             |  1 +
 3 files changed, 15 insertions(+)

diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index dae0f74f5390..affa63d4b6bd 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -105,6 +105,8 @@ static int xen_syscore_suspend(void)
 		xen_save_steal_clock(cpu);
 	}
 
+	xen_shutdown_pirqs();
+
 	xrfp.domid = DOMID_SELF;
 	xrfp.gpfn = __pa(HYPERVISOR_shared_info) >> PAGE_SHIFT;
 
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 569437c158ca..b893536d8af4 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1597,6 +1597,18 @@ void xen_irq_resume(void)
 	restore_pirqs();
 }
 
+void xen_shutdown_pirqs(void)
+{
+	struct irq_info *info;
+
+	list_for_each_entry(info, &xen_irq_list_head, list) {
+		if (info->type != IRQT_PIRQ || !VALID_EVTCHN(info->evtchn))
+			continue;
+
+		shutdown_pirq(irq_get_irq_data(info->irq));
+	}
+}
+
 static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.name			= "xen-dyn",
 
diff --git a/include/xen/events.h b/include/xen/events.h
index c0e6a0598397..39b2c4e4d2ef 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -71,6 +71,7 @@ static inline void notify_remote_via_evtchn(int port)
 void notify_remote_via_irq(int irq);
 
 void xen_irq_resume(void);
+void xen_shutdown_pirqs(void);
 
 /* Clear an irq's pending state, in preparation for polling on it */
 void xen_clear_irq_pending(int irq);
-- 
2.15.3.AMZN

