Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6881DA54B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 01:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgESXZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 19:25:00 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:29091 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgESXZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 19:25:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1589930698; x=1621466698;
  h=date:from:to:subject:message-id:mime-version;
  bh=sOfgRrPRmYHAfVrUOSXb1jwG6rejPn1YQXzhPKMaw1U=;
  b=Zno3tRzqCySeyGzd4HCkBCeo0lJfVOCMjEo6aqGqydve6c7cPBt+cjcg
   vXzVsV7ffCpDb1JSfJaPuE8ldfW/W8xSr5vz6tw4vCBMbhW5gDekZkQKh
   88xxFlbk/8e4MXOajtiCZnXc0xyhU6NPxE0E+VsM6uZFIFDb/M1FzYYOZ
   8=;
IronPort-SDR: TapJ5+eP/s1RHA3K19MF7wVhCWSkQk3+kRa1I2OBkLAKB8EewWlyo02ycYQtyZZFMpV1Mo7QXf
 a/UcclI1rQNQ==
X-IronPort-AV: E=Sophos;i="5.73,411,1583193600"; 
   d="scan'208";a="31066594"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 19 May 2020 23:24:43 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id A24D9A24BC;
        Tue, 19 May 2020 23:24:41 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 19 May 2020 23:24:29 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 19 May 2020 23:24:29 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 19 May 2020 23:24:29 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id DD57040712; Tue, 19 May 2020 23:24:28 +0000 (UTC)
Date:   Tue, 19 May 2020 23:24:28 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <boris.ostrovsky@oracle.com>,
        <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <sstabellini@kernel.org>, <konrad.wilk@oracle.com>,
        <roger.pau@citrix.com>, <axboe@kernel.dk>, <davem@davemloft.net>,
        <rjw@rjwysocki.net>, <len.brown@intel.com>, <pavel@ucw.cz>,
        <peterz@infradead.org>, <eduval@amazon.com>, <sblbir@amazon.com>,
        <anchalag@amazon.com>, <xen-devel@lists.xenproject.org>,
        <vkuznets@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dwmw@amazon.co.uk>,
        <benh@kernel.crashing.org>
Subject: [PATCH 00/12] Fix PM hibernation in Xen guests
Message-ID: <cover.1589926004.git.anchalag@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
This series fixes PM hibernation for hvm guests running on xen hypervisor.
The running guest could now be hibernated and resumed successfully at a
later time. The fixes for PM hibernation are added to block and
network device drivers i.e xen-blkfront and xen-netfront. Any other driver
that needs to add S4 support if not already, can follow same method of
introducing freeze/thaw/restore callbacks.
The patches had been tested against upstream kernel and xen4.11. Large
scale testing is also done on Xen based Amazon EC2 instances. All this testing
involved running memory exhausting workload in the background.

Doing guest hibernation does not involve any support from hypervisor and
this way guest has complete control over its state. Infrastructure
restrictions for saving up guest state can be overcome by guest initiated
hibernation.

These patches were send out as RFC before and all the feedback had been
incorporated in the patches. The last RFCV3 could be found here:
https://lkml.org/lkml/2020/2/14/2789

Known issues:
1.KASLR causes intermittent hibernation failures. VM fails to resumes and
has to be restarted. I will investigate this issue separately and shouldn't
be a blocker for this patch series.
2. During hibernation, I observed sometimes that freezing of tasks fails due
to busy XFS workqueuei[xfs-cil/xfs-sync]. This is also intermittent may be 1
out of 200 runs and hibernation is aborted in this case. Re-trying hibernation
may work. Also, this is a known issue with hibernation and some
filesystems like XFS has been discussed by the community for years with not an
effectve resolution at this point.

Testing How to:
---------------
1. Setup xen hypervisor on a physical machine[ I used Ubuntu 16.04 +upstream
xen-4.11]
2. Bring up a HVM guest w/t kernel compiled with hibernation patches
[I used ubuntu18.04 netboot bionic images and also Amazon Linux on-prem images].
3. Create a swap file size=RAM size
4. Update grub parameters and reboot
5. Trigger pm-hibernation from within the VM

Example:
Set up a file-backed swap space. Swap file size>=Total memory on the system
sudo dd if=/dev/zero of=/swap bs=$(( 1024 * 1024 )) count=4096 # 4096MiB
sudo chmod 600 /swap
sudo mkswap /swap
sudo swapon /swap

Update resume device/resume offset in grub if using swap file:
resume=/dev/xvda1 resume_offset=200704 no_console_suspend=1

Execute:
--------
sudo pm-hibernate
OR
echo disk > /sys/power/state && echo reboot > /sys/power/disk

Compute resume offset code:
"
#!/usr/bin/env python
import sys
import array
import fcntl

#swap file
f = open(sys.argv[1], 'r')
buf = array.array('L', [0])

#FIBMAP
ret = fcntl.ioctl(f.fileno(), 0x01, buf)
print buf[0]
"


Anchal Agarwal (5):
  x86/xen: Introduce new function to map HYPERVISOR_shared_info on
    Resume
  genirq: Shutdown irq chips in suspend/resume during hibernation
  xen: Introduce wrapper for save/restore sched clock offset
  xen: Update sched clock offset to avoid system instability in
    hibernation
  PM / hibernate: update the resume offset on SNAPSHOT_SET_SWAP_AREA

Munehisa Kamata (7):
  xen/manage: keep track of the on-going suspend mode
  xenbus: add freeze/thaw/restore callbacks support
  x86/xen: add system core suspend and resume callbacks
  xen-blkfront: add callbacks for PM suspend and hibernation
  xen-netfront: add callbacks for PM suspend and hibernation
  xen/time: introduce xen_{save,restore}_steal_clock
  x86/xen: save and restore steal clock

 arch/x86/xen/enlighten_hvm.c      |   8 ++
 arch/x86/xen/suspend.c            |  72 ++++++++++++++++++
 arch/x86/xen/time.c               |  18 ++++-
 arch/x86/xen/xen-ops.h            |   3 +
 drivers/block/xen-blkfront.c      | 122 ++++++++++++++++++++++++++++--
 drivers/net/xen-netfront.c        |  98 +++++++++++++++++++++++-
 drivers/xen/events/events_base.c  |   1 +
 drivers/xen/manage.c              |  73 ++++++++++++++++++
 drivers/xen/time.c                |  29 ++++++-
 drivers/xen/xenbus/xenbus_probe.c |  99 +++++++++++++++++++-----
 include/linux/irq.h               |   2 +
 include/xen/xen-ops.h             |   8 ++
 include/xen/xenbus.h              |   3 +
 kernel/irq/chip.c                 |   2 +-
 kernel/irq/internals.h            |   1 +
 kernel/irq/pm.c                   |  31 +++++---
 kernel/power/user.c               |   6 +-
 17 files changed, 536 insertions(+), 40 deletions(-)

-- 
2.24.1.AMZN

