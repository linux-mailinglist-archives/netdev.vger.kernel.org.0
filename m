Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F6A13377A
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 00:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgAGXgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 18:36:41 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:61641 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgAGXgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 18:36:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578440200; x=1609976200;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=My8oU4ytBcdcQ+UejUzlcPtOhmb8DAm8xNHPkmPJYvQ=;
  b=H6NGKtDKdgb6PmM+a20b1C8P6fI+DOJhCNmucoNel5EbQnlMQg6s9FUc
   wYzTeMabb0+vz9Q2QCj28sv/07pqVqn5l8bhPCL7mVYU7lG50e/I//kUy
   orrReDXFgd9d/vJyDu/hQ8JfBeiL2tIh3o+VsS4SD0hG4Awsl8mEBp5mE
   U=;
IronPort-SDR: sD0hFGoR+riFpzTxnD5uoaQgk4FuSlaIatLnlspL6yw4MTCBhzx49SWPF1KM3u++pTozpnXqG6
 46roJ3NRDYOg==
X-IronPort-AV: E=Sophos;i="5.69,407,1571702400"; 
   d="scan'208";a="11930335"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 07 Jan 2020 23:36:36 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 378EFA24D9;
        Tue,  7 Jan 2020 23:36:35 +0000 (UTC)
Received: from EX13D01UWB001.ant.amazon.com (10.43.161.75) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 Jan 2020 23:36:25 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13d01UWB001.ant.amazon.com (10.43.161.75) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 Jan 2020 23:36:24 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Tue, 7 Jan 2020 23:36:24 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id D304340E0B; Tue,  7 Jan 2020 23:36:24 +0000 (UTC)
Date:   Tue, 7 Jan 2020 23:36:24 +0000
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
Subject: [RFC PATCH V2 00/11] Enable PM hibernation on guest VMs
Message-ID: <20200107233624.GA16802@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
I am sending out a V2 version of series of patches that implements guest 
PM hibernation.
These guests are running on xen hypervisor. The patches had been tested
against mainstream kernel. EC2 instance hibernation feature is provided 
to the AWS EC2 customers. PM hibernation uses swap space carved out within 
the guest[or can be a separate partition], where hibernation image is 
stored and restored from.

Why is guest hibenration needed:
Doing guest hibernation does not involve any support from hypervisor and this
way guest has complete control over its state. Infrastructure restrictions like
saving up guest state etc can be overcome by guest initiated hibernation.

This series includes some improvements over RFC series sent last year:
https://lists.xenproject.org/archives/html/xen-devel/2018-06/msg00823.html

Any comments or suggestions are welcome.

Changelog v2:
1. Removed timeout/request present on the ring in xen-blkfront during blkfront freeze
2. Fixed restoring of PIRQs which was apparently working for 4.9 kernels but not for
newer kernel. [Legacy irqs were no longer restored after hibernation introduced with
this commit "020db9d3c1dc0"]
3. Merged couple of related patches to make the code more coherent and readable
4. Code refactoring
5. Sched clock fix when hibernating guest is under heavy CPU load
Note: Under very rare circumstances we see resume failures with KASLR enabled only
on xen instances.  We are roughly seeing 3% failures [>1000 runs] when testing with
various instance sizes and some workload running on each instance. I am currently
investigating the issue as to confirm if its a xen issue or kernel issue.
However, it should not hold back anyone from reviewing/accepting these patches.

Testing done:
All the testing is done using amazon linux images w/t stock upstream kernel
installed. All testing is done for multiple hibernation cycle.

i. multiple loops[~100] of hibernation in disk mode <reboot> w/t 5.4 guest kernel + 4.11 xen
ii. Hibernation tested with memory stress tester running in background on smaller and
larger instance sizes on EC2.[>500 runs]
iii. Testing is also done on physical host machine[Ubuntu18.04/4.15 kernel/stock xen-4.6]
running amazon linux 2 OS as guest VM with multiple queues.
iv. Ran dd to write a large file with bs=1k and hibernated multiple times

Testing How to:
---------------
Example:
Set up a file-backed swap space. Swap file size>=Total memory on the system
sudo dd if=/dev/zero of=/swap bs=$(( 1024 * 1024 )) count=4096 # 4096MiB
sudo chmod 600 /swap
sudo mkswap /swap
sudo swapon /swap

Update resume device/resume offset in grub if using swap file:
resume=/dev/xvda1 resume_offset=200704

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

Aleksei Besogonov (1):
  PM / hibernate: update the resume offset on SNAPSHOT_SET_SWAP_AREA

Anchal Agarwal (2):
  x86/xen: Introduce new function to map HYPERVISOR_shared_info on
    Resume
  xen: Clear IRQD_IRQ_STARTED flag during shutdown PIRQs

Eduardo Valentin (1):
  x86: tsc: avoid system instability in hibernation

Munehisa Kamata (7):
  xen/manage: keep track of the on-going suspend mode
  xenbus: add freeze/thaw/restore callbacks support
  x86/xen: add system core suspend and resume callbacks
  xen-netfront: add callbacks for PM suspend and hibernation support
  xen-blkfront: add callbacks for PM suspend and hibernation
  x86/xen: save and restore steal clock during hibernation
  x86/xen: close event channels for PIRQs in system core suspend
    callback

 arch/x86/kernel/tsc.c             |  29 ++++++++++
 arch/x86/xen/enlighten_hvm.c      |   8 +++
 arch/x86/xen/suspend.c            |  66 +++++++++++++++++++++
 arch/x86/xen/time.c               |   3 +
 arch/x86/xen/xen-ops.h            |   1 +
 drivers/block/xen-blkfront.c      | 119 +++++++++++++++++++++++++++++++++++---
 drivers/net/xen-netfront.c        |  98 ++++++++++++++++++++++++++++++-
 drivers/xen/events/events_base.c  |  13 +++++
 drivers/xen/manage.c              |  73 +++++++++++++++++++++++
 drivers/xen/time.c                |  28 ++++++++-
 drivers/xen/xenbus/xenbus_probe.c |  99 +++++++++++++++++++++++++------
 include/linux/irq.h               |   1 +
 include/linux/sched/clock.h       |   5 ++
 include/xen/events.h              |   1 +
 include/xen/xen-ops.h             |   8 +++
 include/xen/xenbus.h              |   3 +
 kernel/irq/chip.c                 |   3 +-
 kernel/power/user.c               |   6 +-
 kernel/sched/clock.c              |   4 +-
 19 files changed, 537 insertions(+), 31 deletions(-)

-- 
2.15.3.AMZN

