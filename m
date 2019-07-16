Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D196A2CF
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 09:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfGPHUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 03:20:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:64887 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbfGPHUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 03:20:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 00:20:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,496,1557212400"; 
   d="scan'208";a="194796175"
Received: from pipin.fi.intel.com ([10.237.72.175])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jul 2019 00:20:44 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [RFC PATCH 0/5] PTP: add support for Intel's TGPIO controller
Date:   Tue, 16 Jul 2019 10:20:33 +0300
Message-Id: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TGPIO is a new IP which allows for time synchronization between systems
without any other means of synchronization such as PTP or NTP. The
driver is implemented as part of the PTP framework since its features
covered most of what this controller can do.

There are a few things that made me send this as a RFC, however:

(1) This version of the controller lacks an interrupt line. Currently I
	put a kthread that starts polling the controller whenever its
	pin is configured as input. Any better ideas for allowing
	userspace control the polling rate? Perhaps tap into ptp_poll()?

(2) ACPI IDs can't be shared at this moment, unfortunately.

(3) The change in arch/x86/kernel/tsc.c needs to be reviewed at length
	before going in.

Let me know what you guys think,
Cheers

Felipe Balbi (5):
  x86: tsc: add tsc to art helpers
  PTP: add a callback for counting timestamp events
  PTP: implement PTP_EVENT_COUNT_TSTAMP ioctl
  PTP: Add flag for non-periodic output
  PTP: Add support for Intel PMC Timed GPIO Controller

 arch/x86/include/asm/tsc.h        |   2 +
 arch/x86/kernel/tsc.c             |  32 +++
 drivers/ptp/Kconfig               |   8 +
 drivers/ptp/Makefile              |   1 +
 drivers/ptp/ptp-intel-pmc-tgpio.c | 378 ++++++++++++++++++++++++++++++
 drivers/ptp/ptp_chardev.c         |  15 ++
 include/linux/ptp_clock_kernel.h  |  12 +
 include/uapi/linux/ptp_clock.h    |   6 +-
 8 files changed, 453 insertions(+), 1 deletion(-)
 create mode 100644 drivers/ptp/ptp-intel-pmc-tgpio.c

-- 
2.22.0

