Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B9B15B3AF
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 23:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgBLWaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 17:30:09 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:60554 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727564AbgBLWaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 17:30:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581546609; x=1613082609;
  h=date:from:to:subject:message-id:mime-version;
  bh=akTZAV+grlU78dn6Z1+WBBfqhjetJKFVvDp992dKcrc=;
  b=jPaNFYvT8m18e9L/RTge+9SQE3F06MALzGBxrKR0C1EA23GW/pb/CU69
   MBCgsMG5wsSnpYtXcZjNaBRAWYonICi50R7mZuI33c1MCo6nkJYOXP5JE
   mTWQ3qMtFxEdXTrwckCn8GiTQLeXerRiNP+RUsUZavH1mJffcFUFX35a6
   I=;
IronPort-SDR: DKuXC4xlCSUIPj9ul8xIp6uhnDILF7QL9Mjam9n2eegP2xSoxYYsOjmjus7iKoOEaZJ/eyhUpH
 ya6jnGM6gumA==
X-IronPort-AV: E=Sophos;i="5.70,434,1574121600"; 
   d="scan'208";a="16326996"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 12 Feb 2020 22:30:06 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 2C554A2197;
        Wed, 12 Feb 2020 22:30:04 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Feb 2020 22:29:35 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 12 Feb 2020 22:29:35 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Wed, 12 Feb 2020 22:29:35 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 36859400D1; Wed, 12 Feb 2020 22:29:35 +0000 (UTC)
Date:   Wed, 12 Feb 2020 22:29:35 +0000
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
        <fllinden@amaozn.com>, <benh@kernel.crashing.org>
Subject: [RFC PATCH v3 00/12] Enable PM hibernation on guest VMs
Message-ID: <20200212222935.GA3421@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
I am sending out a v3 version of series of patches that implements guest
PM hibernation.
These guests are running on xen hypervisor. The patches had been tested
against mainstream kernel. EC2 instance hibernation feature is provided
to the AWS EC2 customers. PM hibernation uses swap space carved out within
the guest[or can be a separate partition], where hibernation image is
stored and restored from.

Doing guest hibernation does not involve any support from hypervisor and 
this way guest has complete control over its state. Infrastructure
restrictions for saving up guest state can be overcome by guest initiated
hibernation.

This series includes some improvements over RFC series sent last year:
https://lists.xenproject.org/archives/html/xen-devel/2018-06/msg00823.html

Changelog v3:
1. Feedback from V2
2. Introduced 2 new patches for xen sched clock offset fix
3. Fixed pirq shutdown/restore in generic irq subsystem
4. Split save/restore steal clock patches into 2 for better readability

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
All testing is done for multiple hibernation cycle for 5.4 kernel on EC2.

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

Anchal Agarwal (4):
  x86/xen: Introduce new function to map HYPERVISOR_shared_info on
    Resume
  genirq: Shutdown irq chips in suspend/resume during hibernation
  xen: Introduce wrapper for save/restore sched clock offset
  xen: Update sched clock offset to avoid system instability in
    hibernation

Munehisa Kamata (7):
  xen/manage: keep track of the on-going suspend mode
  xenbus: add freeze/thaw/restore callbacks support
  x86/xen: add system core suspend and resume callbacks
  xen-netfront: add callbacks for PM suspend and hibernation support
  xen-blkfront: add callbacks for PM suspend and hibernation
  xen/time: introduce xen_{save,restore}_steal_clock
  x86/xen: save and restore steal clock

 arch/x86/xen/enlighten_hvm.c      |   8 ++
 arch/x86/xen/suspend.c            |  72 ++++++++++++++++++
 arch/x86/xen/time.c               |  18 ++++-
 arch/x86/xen/xen-ops.h            |   3 +
 drivers/block/xen-blkfront.c      | 119 ++++++++++++++++++++++++++++--
 drivers/net/xen-netfront.c        |  98 +++++++++++++++++++++++-
 drivers/xen/events/events_base.c  |   1 +
 drivers/xen/manage.c              |  73 ++++++++++++++++++
 drivers/xen/time.c                |  29 +++++++-
 drivers/xen/xenbus/xenbus_probe.c |  99 ++++++++++++++++++++-----
 include/linux/irq.h               |   2 +
 include/xen/xen-ops.h             |   8 ++
 include/xen/xenbus.h              |   3 +
 kernel/irq/chip.c                 |   2 +-
 kernel/irq/internals.h            |   1 +
 kernel/irq/pm.c                   |  31 +++++---
 kernel/power/user.c               |   6 +-
 17 files changed, 533 insertions(+), 40 deletions(-)

-- 
2.24.1.AMZN

