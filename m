Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2BB2AE8C2
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 07:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbgKKGWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 01:22:38 -0500
Received: from foss.arm.com ([217.140.110.172]:41674 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgKKGWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 01:22:37 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C44BB31B;
        Tue, 10 Nov 2020 22:22:35 -0800 (PST)
Received: from localhost.localdomain (entos-thunderx2-desktop.shanghai.arm.com [10.169.212.215])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 703063F6CF;
        Tue, 10 Nov 2020 22:22:29 -0800 (PST)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, Andre.Przywara@arm.com,
        steven.price@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, jianyong.wu@arm.com,
        nd@arm.com
Subject: [PATCH v15 0/9] Enable ptp_kvm for arm/arm64
Date:   Wed, 11 Nov 2020 14:22:02 +0800
Message-Id: <20201111062211.33144-1-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we offen use ntp (sync time with remote network clock)
to sync time in VM. But the precision of ntp is subject to network delay
so it's difficult to sync time in a high precision.

kvm virtual ptp clock (ptp_kvm) offers another way to sync time in VM,
as the remote clock locates in the host instead of remote network clock.
It targets to sync time between guest and host in virtualization
environment and in this way, we can keep the time of all the VMs running
in the same host in sync. In general, the delay of communication between
host and guest is quiet small, so ptp_kvm can offer time sync precision
up to in order of nanosecond. Please keep in mind that ptp_kvm just
limits itself to be a channel which transmit the remote clock from
host to guest and leaves the time sync jobs to an application, eg. chrony,
in usersapce in VM.

How ptp_kvm works:
After ptp_kvm initialized, there will be a new device node under
/dev called ptp%d. A guest userspace service, like chrony, can use this
device to get host walltime, sometimes also counter cycle, which depends
on the service it calls. Then this guest userspace service can use those
data to do the time sync for guest.
here is a rough sketch to show how kvm ptp clock works.

|----------------------------|              |--------------------------|
|       guest userspace      |              |          host            |
|ioctl -> /dev/ptp%d         |              |                          |
|       ^   |                |              |                          |
|----------------------------|              |                          |
|       |   | guest kernel   |              |                          |
|       |   V      (get host walltime/counter cycle)                   |
|      ptp_kvm -> hypercall - - - - - - - - - - ->hypercall service    |
|                         <- - - - - - - - - - - -                     |
|----------------------------|              |--------------------------|

1. time sync service in guest userspace call ptp device through /dev/ptp%d.
2. ptp_kvm module in guest recive this request then invoke hypercall to route
into host kernel to request host walltime/counter cycle.
3. ptp_kvm hypercall service in host response to the request and send data back.
4. ptp (not ptp_kvm) in guest copy the data to userspace.

This ptp_kvm implementation focuses itself to step 2 and 3 and step 2 works
in guest comparing step 3 works in host kernel.

change log:

from v14 to v15
        (1) enable ptp_kvm on arm32 guest, also ptp_kvm has been tested
on both arm64 and arm32 guest running on arm64 kvm host.
        (2) move arch-agnostic part of ptp_kvm.rst into timekeeping.rst.
        (3) rename KVM_CAP_ARM_PTP_KVM to KVM_CAP_PTP_KVM as it should be
arch agnostic.
        (4) add description for KVM_CAP_PTP_KVM in Documentation/virt/kvm/api.rst.
        (5) adjust dependency in Kconfig for ptp_kvm.
        (6) refine multi-arch process in driver/ptp/Makefile.
        (7) fix make pdfdocs htmldocs issue for ptp_kvm doc.
        (8) address other issues from comments in v14.
        (9) fold hypercall service of ptp_kvm as a function.
        (10) rebase to 5.10-rc3.

from v13 to v14
        (1) rebase code on 5.9-rc3.
        (2) add a document to introduce implementation of PTP_KVM on
arm64.
        (3) fix comments issue in hypercall.c.
        (4) export arm_smccc_1_1_get_conduit using EXPORT_SYMBOL_GPL.
        (5) fix make issue on x86 reported by kernel test robot.

from v12 to v13:
        (1) rebase code on 5.8-rc1.
        (2) this patch set base on 2 patches of 1/8 and 2/8 from Will Decon.
        (3) remove the change to ptp device code of extend getcrosststamp.
        (4) remove the mechanism of letting user choose the counter type in
ptp_kvm for arm64.
        (5) add virtual counter option in ptp_kvm service to let user choose
the specific counter explicitly.

from v11 to v12:
        (1) rebase code on 5.7-rc6 and rebase 2 patches from Will Decon
including 1/11 and 2/11. as these patches introduce discover mechanism of
vendor smccc service.
        (2) rebase ptp_kvm hypercall service from standard smccc to vendor
smccc and add ptp_kvm to vendor smccc service discover mechanism.
        (3) add detail of why we need ptp_kvm and how ptp_kvm works in cover
letter.

from v10 to v11:
        (1) rebase code on 5.7-rc2.
        (2) remove support for arm32, as kvm support for arm32 will be
removed [1]
        (3) add error report in ptp_kvm initialization.

from v9 to v10:
        (1) change code base to v5.5.
        (2) enable ptp_kvm both for arm32 and arm64.
        (3) let user choose which of virtual counter or physical counter
should return when using crosstimestamp mode of ptp_kvm for arm/arm64.
        (4) extend input argument for getcrosstimestamp API.

from v8 to v9:
        (1) move ptp_kvm.h to driver/ptp/
        (2) replace license declaration of ptp_kvm.h the same with other
header files in the same directory.

from v7 to v8:
        (1) separate adding clocksource id for arm_arch_counter as a
single patch.
        (2) update commit message for patch 4/8.
        (3) refine patch 7/8 and patch 8/8 to make them more independent.

from v5 to v6:
        (1) apply Mark's patch[4] to get SMCCC conduit.
        (2) add mechanism to recognize current clocksource by add
clocksouce_id value into struct clocksource instead of method in patch-v5.
        (3) rename kvm_arch_ptp_get_clock_fn into
kvm_arch_ptp_get_crosststamp.

from v4 to v5:
        (1) remove hvc delay compensasion as it should leave to userspace.
        (2) check current clocksource in hvc call service.
        (3) expose current clocksource by adding it to
system_time_snapshot.
        (4) add helper to check if clocksource is arm_arch_counter.
        (5) rename kvm_ptp.c to ptp_kvm_common.c

from v3 to v4:
        (1) fix clocksource of ptp_kvm to arch_sys_counter.
        (2) move kvm_arch_ptp_get_clock_fn into arm_arch_timer.c
        (3) subtract cntvoff before return cycles from host.
        (4) use ktime_get_snapshot instead of getnstimeofday and
get_current_counterval to return time and counter value.
        (5) split ktime and counter into two 32-bit block respectively
to avoid Y2038-safe issue.
        (6) set time compensation to device time as half of the delay of
hvc call.
        (7) add ARM_ARCH_TIMER as dependency of ptp_kvm for
arm64.

from v2 to v3:
        (1) fix some issues in commit log.
        (2) add some receivers in send list.

from v1 to v2:
        (1) move arch-specific code from arch/ to driver/ptp/
        (2) offer mechanism to inform userspace if ptp_kvm service is
available.
        (3) separate ptp_kvm code for arm64 into hypervisor part and
guest part.
        (4) add API to expose monotonic clock and counter value.
        (5) refine code: remove no necessary part and reconsitution.

[1] https://patchwork.kernel.org/cover/11373351/


Jianyong Wu (6):
  ptp: Reorganize ptp_kvm module to make it arch-independent.
  clocksource: Add clocksource id for arm arch counter
  arm64/kvm: Add hypercall service for kvm ptp.
  ptp: arm/arm64: Enable ptp_kvm for arm/arm64
  doc: add ptp_kvm introduction for arm64 support
  arm64: Add kvm capability check extension for ptp_kvm

Thomas Gleixner (1):
  time: Add mechanism to recognize clocksource in time_get_snapshot

Will Deacon (2):
  arm64: Probe for the presence of KVM hypervisor
  arm/arm64: KVM: Advertise KVM UID to guests via SMCCC

 Documentation/virt/kvm/api.rst              |  9 ++
 Documentation/virt/kvm/arm/index.rst        |  1 +
 Documentation/virt/kvm/arm/ptp_kvm.rst      | 29 +++++++
 Documentation/virt/kvm/timekeeping.rst      | 35 ++++++++
 arch/arm/kernel/setup.c                     |  1 +
 arch/arm64/kernel/setup.c                   |  1 +
 arch/arm64/kvm/arm.c                        |  1 +
 arch/arm64/kvm/hypercalls.c                 | 88 +++++++++++++++++--
 drivers/clocksource/arm_arch_timer.c        | 30 +++++++
 drivers/firmware/smccc/smccc.c              | 37 ++++++++
 drivers/ptp/Kconfig                         |  2 +-
 drivers/ptp/Makefile                        |  2 +
 drivers/ptp/ptp_kvm.h                       | 11 +++
 drivers/ptp/ptp_kvm_arm.c                   | 44 ++++++++++
 drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} | 85 +++++-------------
 drivers/ptp/ptp_kvm_x86.c                   | 95 +++++++++++++++++++++
 include/linux/arm-smccc.h                   | 60 +++++++++++++
 include/linux/clocksource.h                 |  6 ++
 include/linux/clocksource_ids.h             | 12 +++
 include/linux/timekeeping.h                 | 12 +--
 include/uapi/linux/kvm.h                    |  1 +
 kernel/time/clocksource.c                   |  2 +
 kernel/time/timekeeping.c                   |  1 +
 23 files changed, 488 insertions(+), 77 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/ptp_kvm.rst
 create mode 100644 drivers/ptp/ptp_kvm.h
 create mode 100644 drivers/ptp/ptp_kvm_arm.c
 rename drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} (60%)
 create mode 100644 drivers/ptp/ptp_kvm_x86.c
 create mode 100644 include/linux/clocksource_ids.h

-- 
2.17.1

