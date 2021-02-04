Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C7130C20D
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbhBBOi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:38:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231628AbhBBORv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 09:17:51 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1658B64DDA;
        Tue,  2 Feb 2021 14:12:11 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l6wPY-00BVqw-VN; Tue, 02 Feb 2021 14:12:09 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com, seanjc@google.com,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, Andre.Przywara@arm.com,
        steven.price@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, jianyong.wu@arm.com,
        kernel-team@android.com
Subject: [PATCH v17 0/7] KVM: arm64: Add host/guest KVM-PTP support
Date:   Tue,  2 Feb 2021 14:11:57 +0000
Message-Id: <20210202141204.3134855-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, seanjc@google.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, jianyong.wu@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given that this series[0] has languished in my Inbox for the best of the
past two years, and in an effort to eventually get it merged, I've
taken the liberty to pick it up and do the changes I wanted to see
instead of waiting to go through yet another round.

All the patches have a link to their original counterpart (though I
have squashed a couple of them where it made sense). Tested both 64
and 32bit guests for a good measure. Of course, I claim full
responsibility for any bug introduced here.

* From v16 [0]:
  - Moved the KVM service discovery to its own file, plugged it into
    PSCI instead of the arch code, dropped the inlining, made use of
    asm/hypervisor.h.
  - Tidied-up the namespacing
  - Cleanup the hypercall handler
  - De-duplicate the guest code
  - Tidied-up arm64-specific documentation
  - Dropped the generic PTP documentation as it needs a new location,
    and some cleanup
  - Squashed hypercall documentation and capability into the
    main KVM patch
  - Rebased on top of 5.11-rc4

[0] https://lore.kernel.org/r/20201209060932.212364-1-jianyong.wu@arm.com

Jianyong Wu (4):
  ptp: Reorganize ptp_kvm.c to make it arch-independent
  clocksource: Add clocksource id for arm arch counter
  KVM: arm64: Add support for the KVM PTP service
  ptp: arm/arm64: Enable ptp_kvm for arm/arm64

Thomas Gleixner (1):
  time: Add mechanism to recognize clocksource in time_get_snapshot

Will Deacon (2):
  arm/arm64: Probe for the presence of KVM hypervisor
  KVM: arm64: Advertise KVM UID to guests via SMCCC

 Documentation/virt/kvm/api.rst              |  9 ++
 Documentation/virt/kvm/arm/index.rst        |  1 +
 Documentation/virt/kvm/arm/ptp_kvm.rst      | 25 ++++++
 arch/arm/include/asm/hypervisor.h           |  3 +
 arch/arm64/include/asm/hypervisor.h         |  3 +
 arch/arm64/kvm/arm.c                        |  1 +
 arch/arm64/kvm/hypercalls.c                 | 80 +++++++++++++++--
 drivers/clocksource/arm_arch_timer.c        | 33 +++++++
 drivers/firmware/psci/psci.c                |  2 +
 drivers/firmware/smccc/Makefile             |  2 +-
 drivers/firmware/smccc/kvm_guest.c          | 51 +++++++++++
 drivers/firmware/smccc/smccc.c              |  1 +
 drivers/ptp/Kconfig                         |  2 +-
 drivers/ptp/Makefile                        |  2 +
 drivers/ptp/ptp_kvm_arm.c                   | 28 ++++++
 drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} | 84 +++++-------------
 drivers/ptp/ptp_kvm_x86.c                   | 97 +++++++++++++++++++++
 include/linux/arm-smccc.h                   | 41 +++++++++
 include/linux/clocksource.h                 |  6 ++
 include/linux/clocksource_ids.h             | 12 +++
 include/linux/ptp_kvm.h                     | 19 ++++
 include/linux/timekeeping.h                 | 12 +--
 include/uapi/linux/kvm.h                    |  1 +
 kernel/time/clocksource.c                   |  2 +
 kernel/time/timekeeping.c                   |  1 +
 25 files changed, 440 insertions(+), 78 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/ptp_kvm.rst
 create mode 100644 drivers/firmware/smccc/kvm_guest.c
 create mode 100644 drivers/ptp/ptp_kvm_arm.c
 rename drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} (60%)
 create mode 100644 drivers/ptp/ptp_kvm_x86.c
 create mode 100644 include/linux/clocksource_ids.h
 create mode 100644 include/linux/ptp_kvm.h

-- 
2.29.2

