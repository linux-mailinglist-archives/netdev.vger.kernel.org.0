Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C4314E8E2
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 07:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgAaGkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 01:40:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:64027 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728109AbgAaGkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 01:40:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 22:40:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,384,1574150400"; 
   d="scan'208";a="309925513"
Received: from wtczc53028gn.jf.intel.com (HELO localhost.localdomain) ([10.54.87.17])
  by orsmga001.jf.intel.com with ESMTP; 30 Jan 2020 22:40:49 -0800
From:   christopher.s.hall@intel.com
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, jacob.e.keller@intel.com, richardcochran@gmail.com,
        davem@davemloft.net, sean.v.kelley@intel.com
Cc:     Christopher Hall <christopher.s.hall@intel.com>
Subject: [Intel PMC TGPIO Driver 3/5] drivers/ptp: Add user-space input polling interface
Date:   Wed, 11 Dec 2019 13:48:50 -0800
Message-Id: <20191211214852.26317-4-christopher.s.hall@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191211214852.26317-1-christopher.s.hall@intel.com>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christopher Hall <christopher.s.hall@intel.com>

The Intel PMC Time-Aware GPIO controller doesn't implement interrupts to
notify software that an input event has occurred. To solve this problem,
implement a user-space polling interface allowing the application to check
for input events. The API returns an event count and time. This interface
(EVENT_COUNT_TSTAMP2) is *reused* from the output frequency adjustment API.
The event count delta indicates that one or more events have occurred and
how many events may have been missed.

For periodic input use cases, polling is fairly efficient. Using PPS input,
as an example, polling 3x per second is more than sufficient to capture
rising and falling edge timestamps. Generalizing, the poll period should
be:

	poll_period = (nominal_input_period / (1 + freq_offset)) / 2

	Where freq_offset = <remote:local clock ratio> - 1;

A flag that indicates a pin isn't capable of generating interrupts is
added. Software should not expect notification through the read() interface
on pins marked as such. If all pins are marked as poll only, the read
interface is marked 'defunct' and immediately returns an error because no
interrupt would ever occur to exit the wait state.

Signed-off-by: Christopher Hall <christopher.s.hall@intel.com>
---
 drivers/ptp/ptp_clock.c        | 13 +++++++++++++
 include/uapi/linux/ptp_clock.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index b84f16bbd6f2..518dc911ec40 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -190,6 +190,17 @@ static void ptp_aux_kworker(struct kthread_work *work)
 		kthread_queue_delayed_work(ptp->kworker, &ptp->aux_work, delay);
 }
 
+static bool check_for_readability(struct ptp_pin_desc *pin_desc, size_t size)
+{
+	int i;
+	unsigned int flags = PTP_PINDESC_INPUTPOLL;
+
+	for (i = 0; i < size && flags != 0; ++i)
+		flags &= pin_desc[i].flags;
+
+	return flags == 0;
+}
+
 /* public interface */
 
 struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
@@ -213,6 +224,8 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 		goto no_slot;
 	}
 
+	ptp->defunct = !check_for_readability(info->pin_config, info->n_pins);
+
 	ptp->clock.ops = ptp_clock_ops;
 	ptp->info = info;
 	ptp->devid = MKDEV(major, index);
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index ecb4c4e49205..d5bd6504480c 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -38,6 +38,7 @@
  * Bits of the ptp_pin_desc.flags field:
  */
 #define PTP_PINDESC_EVTCNTVALID	(1<<0)
+#define PTP_PINDESC_INPUTPOLL	(1<<1)
 
 /*
  * flag fields valid for the new PTP_EXTTS_REQUEST2 ioctl.
-- 
2.21.0

