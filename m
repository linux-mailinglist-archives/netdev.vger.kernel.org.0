Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A949542A657
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbhJLNrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:47:53 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:14467 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236678AbhJLNrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:47:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1634046350; x=1665582350;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=aJDGDLPHAoJo34NVDGUNoZT0BwG/DiHT72I8u2frdhQ=;
  b=IpcY+yLw+pD+Mi9F/s/dwFcii3wfgmdTpHWP0Oef9f4aFKy/G4+tZDA2
   yu5aaUAwruYEBRBHS5BkqCcHjxdueVvgRwPVrpUrQ+koYtBMLPJSZar23
   eO6IxwOLpz31cbAiO4rN6y1k8rIQ/5bj78MwnVw+ZuY4c8BSIn7liAo4Z
   +LYp4ciNb5EJP8X7OznZQkpnxKJSIgwwbf3dhgMwNlbwOseoeZ8PDv8I9
   m+vXV071tmy7fyBC7laRZ5IlDnMPZptcRoF3Rjb+dMFJw8vzh4pZWNVDj
   7nXorRlv6vFqOcNGDVzrxPDy0XuigeHAqSk1bTstxEy9kkvFxwdcvoblm
   g==;
IronPort-SDR: wWOXe+AxiWvsjxlqf0yL/spBOJhE1NvxLQ3fvOIIZ3s0trRNUzUOUf0htvxCQNNGIf9dL0dixe
 fKmEu2lfuh/U10KIz1l4u9JtaYJduFQ3eOuCaU2qW45ZoGk1VEh3gUsN+UbyHK0f3VDaCjFbz4
 Z9lmClTbzgNtDgoxtlb9tjjXWCIiT+fOHIPCRO0NlSkUpsTyCIjgdMfL7MpQFf0p6AGVnFRCj+
 s/+TguuK69rZYvGclo22BpBfpyO4zytFHnOAIZUhFQkqnRxtn5PE7EFsZkmNZxRsr34wXe5oBA
 c4He9+O4zj6zjoweDauNZCEC
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="132714156"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2021 06:45:50 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 12 Oct 2021 06:45:49 -0700
Received: from ubuntu.localdomain (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 12 Oct 2021 06:45:49 -0700
From:   <yuiko.oshino@microchip.com>
To:     <davem@devemloft.net>
CC:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: [PATCH net-next] net: microchip: lan743x: add support for PTP pulse width (duty cycle)
Date:   Tue, 12 Oct 2021 09:44:19 -0400
Message-ID: <1634046259-64217-1-git-send-email-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuiko Oshino <yuiko.oshino@microchip.com>

If the PTP_PEROUT_DUTY_CYCLE flag is set, then check if the
request_on value in ptp_perout_request matches the pre-defined
values or a toggle option.
Return a failure if the value is not supported.

Preserve the old behaviors if the PTP_PEROUT_DUTY_CYCLE flag is not
set.

Tested with an oscilloscope on EVB-LAN7430:
e.g., to output PPS 1sec period 500mS on (high) to GPIO 2.
 ./testptp -L 2,2
 ./testptp -p 1000000000 -w 500000000

Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.h |  1 +
 drivers/net/ethernet/microchip/lan743x_ptp.c  | 91 ++++++++++++++++---
 2 files changed, 81 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
index 6080028c1df2..34c22eea0124 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.h
+++ b/drivers/net/ethernet/microchip/lan743x_main.h
@@ -279,6 +279,7 @@
 #define PTP_GENERAL_CONFIG_CLOCK_EVENT_1MS_	(3)
 #define PTP_GENERAL_CONFIG_CLOCK_EVENT_10MS_	(4)
 #define PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_	(5)
+#define PTP_GENERAL_CONFIG_CLOCK_EVENT_TOGGLE_	(6)
 #define PTP_GENERAL_CONFIG_CLOCK_EVENT_X_SET_(channel, value) \
 	(((value) & 0x7) << (1 + ((channel) << 2)))
 #define PTP_GENERAL_CONFIG_RELOAD_ADD_X_(channel)	(BIT((channel) << 2))
diff --git a/drivers/net/ethernet/microchip/lan743x_ptp.c b/drivers/net/ethernet/microchip/lan743x_ptp.c
index ab6d719d40f0..9380e396f648 100644
--- a/drivers/net/ethernet/microchip/lan743x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan743x_ptp.c
@@ -491,9 +491,10 @@ static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
 	int perout_pin = 0;
 	unsigned int index = perout_request->index;
 	struct lan743x_ptp_perout *perout = &ptp->perout[index];
+	int ret = 0;
 
 	/* Reject requests with unsupported flags */
-	if (perout_request->flags)
+	if (perout_request->flags & ~PTP_PEROUT_DUTY_CYCLE)
 		return -EOPNOTSUPP;
 
 	if (on) {
@@ -518,6 +519,7 @@ static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
 		netif_warn(adapter, drv, adapter->netdev,
 			   "Failed to reserve event channel %d for PEROUT\n",
 			   index);
+		ret = -EBUSY;
 		goto failed;
 	}
 
@@ -529,6 +531,7 @@ static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
 		netif_warn(adapter, drv, adapter->netdev,
 			   "Failed to reserve gpio %d for PEROUT\n",
 			   perout_pin);
+		ret = -EBUSY;
 		goto failed;
 	}
 
@@ -540,27 +543,93 @@ static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
 	period_sec += perout_request->period.nsec / 1000000000;
 	period_nsec = perout_request->period.nsec % 1000000000;
 
-	if (period_sec == 0) {
-		if (period_nsec >= 400000000) {
+	if (perout_request->flags & PTP_PEROUT_DUTY_CYCLE) {
+		struct timespec64 ts_on, ts_period;
+		s64 wf_high, period64, half;
+		s32 reminder;
+
+		ts_on.tv_sec = perout_request->on.sec;
+		ts_on.tv_nsec = perout_request->on.nsec;
+		wf_high = timespec64_to_ns(&ts_on);
+		ts_period.tv_sec = perout_request->period.sec;
+		ts_period.tv_nsec = perout_request->period.nsec;
+		period64 = timespec64_to_ns(&ts_period);
+
+		if (period64 < 200) {
+			netif_warn(adapter, drv, adapter->netdev,
+				   "perout period too small, minimum is 200nS\n");
+			ret = -EOPNOTSUPP;
+			goto failed;
+		}
+		if (wf_high >= period64) {
+			netif_warn(adapter, drv, adapter->netdev,
+				   "pulse width must be smaller than period\n");
+			ret = -EINVAL;
+			goto failed;
+		}
+
+		/* Check if we can do 50% toggle on an even value of period.
+		 * If the period number is odd, then check if the requested
+		 * pulse width is the same as one of pre-defined width values.
+		 * Otherwise, return failure.
+		 */
+		half = div_s64_rem(period64, 2, &reminder);
+		if (!reminder) {
+			if (half == wf_high) {
+				/* It's 50% match. Use the toggle option */
+				pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_TOGGLE_;
+				/* In this case, devide period value by 2 */
+				ts_period = ns_to_timespec64(div_s64(period64, 2));
+				period_sec = ts_period.tv_sec;
+				period_nsec = ts_period.tv_nsec;
+
+				goto program;
+			}
+		}
+		/* if we can't do toggle, then the width option needs to be the exact match */
+		if (wf_high == 200000000) {
 			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_;
-		} else if (period_nsec >= 20000000) {
+		} else if (wf_high == 10000000) {
 			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_10MS_;
-		} else if (period_nsec >= 2000000) {
+		} else if (wf_high == 1000000) {
 			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_1MS_;
-		} else if (period_nsec >= 200000) {
+		} else if (wf_high == 100000) {
 			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_100US_;
-		} else if (period_nsec >= 20000) {
+		} else if (wf_high == 10000) {
 			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_10US_;
-		} else if (period_nsec >= 200) {
+		} else if (wf_high == 100) {
 			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_100NS_;
 		} else {
 			netif_warn(adapter, drv, adapter->netdev,
-				   "perout period too small, minimum is 200nS\n");
+				   "duty cycle specified is not supported\n");
+			ret = -EOPNOTSUPP;
 			goto failed;
 		}
 	} else {
-		pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_;
+		if (period_sec == 0) {
+			if (period_nsec >= 400000000) {
+				pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_;
+			} else if (period_nsec >= 20000000) {
+				pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_10MS_;
+			} else if (period_nsec >= 2000000) {
+				pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_1MS_;
+			} else if (period_nsec >= 200000) {
+				pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_100US_;
+			} else if (period_nsec >= 20000) {
+				pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_10US_;
+			} else if (period_nsec >= 200) {
+				pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_100NS_;
+			} else {
+				netif_warn(adapter, drv, adapter->netdev,
+					   "perout period too small, minimum is 200nS\n");
+				ret = -EOPNOTSUPP;
+				goto failed;
+			}
+		} else {
+			pulse_width = PTP_GENERAL_CONFIG_CLOCK_EVENT_200MS_;
+		}
 	}
+program:
 
 	/* turn off by setting target far in future */
 	lan743x_csr_write(adapter,
@@ -599,7 +668,7 @@ static int lan743x_ptp_perout(struct lan743x_adapter *adapter, int on,
 
 failed:
 	lan743x_ptp_perout_off(adapter, index);
-	return -ENODEV;
+	return ret;
 }
 
 static int lan743x_ptpci_enable(struct ptp_clock_info *ptpci,
-- 
2.25.1

