Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95C14B5EA6
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 10:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbfIRIHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 04:07:31 -0400
Received: from foss.arm.com ([217.140.110.172]:36748 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725298AbfIRIHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 04:07:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD95828;
        Wed, 18 Sep 2019 01:07:30 -0700 (PDT)
Received: from entos-d05.shanghai.arm.com (entos-d05.shanghai.arm.com [10.169.40.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8EAE63F59C;
        Wed, 18 Sep 2019 01:07:25 -0700 (PDT)
From:   Jianyong Wu <jianyong.wu@arm.com>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com,
        Will.Deacon@arm.com, suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        jianyong.wu@arm.com, nd@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH v3 0/6] Enable ptp_kvm for arm64
Date:   Wed, 18 Sep 2019 04:07:10 -0400
Message-Id: <20190918080716.64242-1-jianyong.wu@arm.com>
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
  timekeeping: Expose API allowing retrival of current clocksource and
    counter value
  psci: Add hvc call service for ptp_kvm.
  ptp: arm64: Enable ptp_kvm for arm64
  kvm: arm64: Add capability check extension for ptp_kvm

 drivers/firmware/psci/psci.c         |  6 ++
 drivers/ptp/Kconfig                  |  2 +-
 drivers/ptp/Makefile                 |  1 +
 drivers/ptp/{ptp_kvm.c => kvm_ptp.c} | 77 ++++++------------------
 drivers/ptp/ptp_kvm_arm64.c          | 82 ++++++++++++++++++++++++++
 drivers/ptp/ptp_kvm_x86.c            | 87 ++++++++++++++++++++++++++++
 include/asm-generic/ptp_kvm.h        | 12 ++++
 include/linux/arm-smccc.h            | 14 ++++-
 include/linux/psci.h                 |  1 +
 include/linux/timekeeping.h          |  3 +
 include/uapi/linux/kvm.h             |  1 +
 kernel/time/timekeeping.c            | 13 +++++
 virt/kvm/arm/arm.c                   |  1 +
 virt/kvm/arm/psci.c                  | 17 ++++++
 14 files changed, 256 insertions(+), 61 deletions(-)
 rename drivers/ptp/{ptp_kvm.c => kvm_ptp.c} (63%)
 create mode 100644 drivers/ptp/ptp_kvm_arm64.c
 create mode 100644 drivers/ptp/ptp_kvm_x86.c
 create mode 100644 include/asm-generic/ptp_kvm.h

-- 
2.17.1

