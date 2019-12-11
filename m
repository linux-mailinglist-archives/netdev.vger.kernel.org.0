Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4F714E8DB
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 07:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgAaGkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 01:40:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:64027 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgAaGkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 01:40:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 22:40:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,384,1574150400"; 
   d="scan'208";a="309925480"
Received: from wtczc53028gn.jf.intel.com (HELO localhost.localdomain) ([10.54.87.17])
  by orsmga001.jf.intel.com with ESMTP; 30 Jan 2020 22:40:40 -0800
From:   christopher.s.hall@intel.com
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, jacob.e.keller@intel.com, richardcochran@gmail.com,
        davem@davemloft.net, sean.v.kelley@intel.com
Cc:     Christopher Hall <christopher.s.hall@intel.com>
Subject: [Intel PMC TGPIO Driver 0/5] Add support for Intel PMC Time GPIO Driver with PHC interface changes to support additional H/W Features
Date:   Wed, 11 Dec 2019 13:48:47 -0800
Message-Id: <20191211214852.26317-1-christopher.s.hall@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christopher Hall <christopher.s.hall@intel.com>

Upcoming Intel platforms will have Time-Aware GPIO (TGPIO) hardware.
The TGPIO logic is driven by the Always Running Timer (ART) that's
related to TSC using CPUID[15H] (See Intel SDM Invariant
Time-Keeping).

The ART frequency is not adjustable. In order, to implement output
adjustments an additional edge-timestamp API is added, as well, as
a periodic output frequency adjustment API. Togther, these implement
equivalent functionality to the existing SYS_OFFSET_* and frequency
adjustment APIs.

The TGPIO hardware doesn't implement interrupts. For TGPIO input, the
output edge-timestamp API is re-used to implement a user-space polling
interface. For periodic input (e.g. PPS) this is fairly efficient,
requiring only a marginally faster poll rate than the input event
frequency.

Acknowledgment: Portions of the driver code were authored by Felipe
Balbi <balbi@kernel.org>

=======================================================================

Christopher Hall (5):
  drivers/ptp: Add Enhanced handling of reserve fields
  drivers/ptp: Add PEROUT2 ioctl frequency adjustment interface
  drivers/ptp: Add user-space input polling interface
  x86/tsc: Add TSC support functions to support ART driven Time-Aware
    GPIO
  drivers/ptp: Add PMC Time-Aware GPIO Driver

 arch/x86/include/asm/tsc.h        |   6 +
 arch/x86/kernel/tsc.c             | 116 +++-
 drivers/ptp/Kconfig               |  13 +
 drivers/ptp/Makefile              |   1 +
 drivers/ptp/ptp-intel-pmc-tgpio.c | 867 ++++++++++++++++++++++++++++++
 drivers/ptp/ptp_chardev.c         |  86 ++-
 drivers/ptp/ptp_clock.c           |  13 +
 include/linux/ptp_clock_kernel.h  |   2 +
 include/uapi/linux/ptp_clock.h    |  26 +-
 9 files changed, 1099 insertions(+), 31 deletions(-)
 create mode 100644 drivers/ptp/ptp-intel-pmc-tgpio.c

-- 
2.21.0

