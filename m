Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D58D73C2
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 12:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbfJOKsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 06:48:54 -0400
Received: from foss.arm.com ([217.140.110.172]:35070 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbfJOKsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 06:48:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64EFE28;
        Tue, 15 Oct 2019 03:48:53 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A23423F68E;
        Tue, 15 Oct 2019 03:48:48 -0700 (PDT)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, nd@arm.com
Subject: [RFC PATCH v5 0/6] Enable ptp_kvm for arm64
Date:   Tue, 15 Oct 2019 18:48:16 +0800
Message-Id: <20191015104822.13890-1-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kvm ptp targets to provide high precision time sync between guest
and host in virtualization environment. This patch enable kvm ptp
for arm64.
This patch set base on [1][2][3]

change log:
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
        (6) set time compensation to device time as half of the delay of hvc call.
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

[1]https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/
commit/?h=kvm/hvc&id=125ea89e4a21e2fc5235410f966a996a1a7148bf
[2]https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/
commit/?h=kvm/hvc&id=464f5a1741e5959c3e4d2be1966ae0093b4dce06
[3]https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/
commit/?h=kvm/hvc&id=6597490e005d0eeca8ed8c1c1d7b4318ee014681

Jianyong Wu (6):
  psci: Export psci_ops.conduit symbol as modules will use it.
  ptp: Reorganize ptp_kvm modules to make it arch-independent.
  timekeeping: Add clocksource to system_time_snapshot
  psci: Add hvc call service for ptp_kvm.
  ptp: arm64: Enable ptp_kvm for arm64
  kvm: arm64: Add capability check extension for ptp_kvm

 drivers/clocksource/arm_arch_timer.c        | 27 +++++++
 drivers/firmware/psci/psci.c                |  6 ++
 drivers/ptp/Kconfig                         |  2 +-
 drivers/ptp/Makefile                        |  1 +
 drivers/ptp/ptp_kvm_arm64.c                 | 54 +++++++++++++
 drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} | 77 +++++-------------
 drivers/ptp/ptp_kvm_x86.c                   | 87 +++++++++++++++++++++
 include/asm-generic/ptp_kvm.h               | 12 +++
 include/clocksource/arm_arch_timer.h        |  5 ++
 include/linux/arm-smccc.h                   | 14 +++-
 include/linux/psci.h                        |  1 +
 include/linux/timekeeping.h                 | 35 +++++----
 include/uapi/linux/kvm.h                    |  1 +
 kernel/time/timekeeping.c                   |  7 +-
 virt/kvm/arm/arm.c                          |  1 +
 virt/kvm/arm/psci.c                         | 21 +++++
 16 files changed, 270 insertions(+), 81 deletions(-)
 create mode 100644 drivers/ptp/ptp_kvm_arm64.c
 rename drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} (63%)
 create mode 100644 drivers/ptp/ptp_kvm_x86.c
 create mode 100644 include/asm-generic/ptp_kvm.h

-- 
2.17.1

