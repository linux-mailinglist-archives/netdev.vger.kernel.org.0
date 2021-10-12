Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907AC42A66D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbhJLNwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:52:00 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:14856 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbhJLNv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:51:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1634046597; x=1665582597;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=aJDGDLPHAoJo34NVDGUNoZT0BwG/DiHT72I8u2frdhQ=;
  b=q+omw07jU+JTyOMivue1dUorODLHWvRkThzxRJu1OBmHEGtpqCJy0oe5
   4S38+F9Xs8Gw3qtcvZp3qh2fM6dXtj1TNOIP0EKA+eavBuAfxZY8uzvOU
   VICfj0TgewrMF5MgiTkuad+RXdIH7x6cdUeaEnK9h/Ox5UA50VXxylL3S
   CoV0YwLQJ8E2ZJlN9G85ER7Peyh1m2J/nHQFZq8DcOc0HlEXllez1Rk56
   6fb3IGXy6Guk3lpmZJkqMA/Y6g294rp+i2fsFTerx2bkCCunfL+oChMlz
   bSPeMGMa5TZjTxWXFBHCnRJlP+dtoOPCX2ZAi8m5eeU+2czm8gnB83DLN
   w==;
IronPort-SDR: EFHNz31JLOEJCN9YltCIiZEdfsR7tL7Viy3hrSIsOjFXPPobdS3JWrkQ9VJPQRCKdsr8jk/oeb
 eIPm3s7o8mFiSN4gxkxA/BKkCWctH/0DjHrGCTrxfcC2dHuO8EnmPR9QHji2EtL22y0TxQJ5Pi
 Q+ZSE1VPSbKrUI0IMXcrrbnWsAiynUbaTYrebUTcysdNEeITMJ/nDTEyHWFtW7OBI2TBntl7sm
 6VGS0XHw03Z9ABBDqYse0cXrQgYgLNicAyLD2EX99i6FtJA5X8n4HBTxXiK57LRg8LvcOwVqst
 CsP6DaZ7FI27FTNzjNvnEdxi
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="132714833"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2021 06:49:57 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 12 Oct 2021 06:49:57 -0700
Received: from ubuntu.localdomain (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 12 Oct 2021 06:49:57 -0700
From:   <yuiko.oshino@microchip.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: [PATCH net-next] net: microchip: lan743x: add support for PTP pulse width (duty cycle)
Date:   Tue, 12 Oct 2021 09:49:53 -0400
Message-ID: <1634046593-64312-1-git-send-email-yuiko.oshino@microchip.com>
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

