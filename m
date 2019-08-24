Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF269C0E2
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfHXXEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:04:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57614 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbfHXXEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 19:04:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version
        :Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YjUvSbDoy8UAMMqkucajtO7n+8rRx5YU1zwI7PtMYdM=; b=d/SaaIyc3xq9wbpAqCnbj04067
        yhM1Zj9Iy2UeqQLUqqojyR/D5hBMxpCXI2lr5QjeJmea7MXOqUVd6/wsoMGT7mqcjgkjrFfYbDqTR
        rakhfTD5GxZCmVjv9VLwduVqTC+M6AzS3YtWmmYI53X8tyXhYZWfUipDHQ0EYPMWvcb0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i1f5B-0004bS-97; Sun, 25 Aug 2019 01:04:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     Russell King <rmk+kernel@arm.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>,
        Chris Healy <Chris.Healy@zii.aero>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: phy: sfp: Add labels to hwmon sensors
Date:   Sun, 25 Aug 2019 01:04:17 +0200
Message-Id: <20190824230417.17657-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SFPs can report two different power values, the transmit power and the
receive power. Add labels to make it clear which is which. Also add
labels to the other sensors, VCC power supply, bias and module
temperature.

sensors(1) now shows:

sff2-isa-0000
Adapter: ISA adapter
VCC:          +3.23 V
temperature:  +33.4 C
TX_power:    276.00 uW
RX_power:     20.00 uW
bias:         +0.01 A

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/sfp.c | 73 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index e36c04c26866..272d5773573e 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -429,6 +429,7 @@ static umode_t sfp_hwmon_is_visible(const void *data,
 				return 0;
 			/* fall through */
 		case hwmon_temp_input:
+		case hwmon_temp_label:
 			return 0444;
 		default:
 			return 0;
@@ -447,6 +448,7 @@ static umode_t sfp_hwmon_is_visible(const void *data,
 				return 0;
 			/* fall through */
 		case hwmon_in_input:
+		case hwmon_in_label:
 			return 0444;
 		default:
 			return 0;
@@ -465,6 +467,7 @@ static umode_t sfp_hwmon_is_visible(const void *data,
 				return 0;
 			/* fall through */
 		case hwmon_curr_input:
+		case hwmon_curr_label:
 			return 0444;
 		default:
 			return 0;
@@ -492,6 +495,7 @@ static umode_t sfp_hwmon_is_visible(const void *data,
 				return 0;
 			/* fall through */
 		case hwmon_power_input:
+		case hwmon_power_label:
 			return 0444;
 		default:
 			return 0;
@@ -987,9 +991,63 @@ static int sfp_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 	}
 }
 
+static const char *const sfp_hwmon_power_labels[] = {
+	"TX_power",
+	"RX_power",
+};
+
+static int sfp_hwmon_read_string(struct device *dev,
+				 enum hwmon_sensor_types type,
+				 u32 attr, int channel, const char **str)
+{
+	switch (type) {
+	case hwmon_curr:
+		switch (attr) {
+		case hwmon_curr_label:
+			*str = "bias";
+			return 0;
+		default:
+			return -EOPNOTSUPP;
+		}
+		break;
+	case hwmon_temp:
+		switch (attr) {
+		case hwmon_temp_label:
+			*str = "temperature";
+			return 0;
+		default:
+			return -EOPNOTSUPP;
+		}
+		break;
+	case hwmon_in:
+		switch (attr) {
+		case hwmon_in_label:
+			*str = "VCC";
+			return 0;
+		default:
+			return -EOPNOTSUPP;
+		}
+		break;
+	case hwmon_power:
+		switch (attr) {
+		case hwmon_power_label:
+			*str = sfp_hwmon_power_labels[channel];
+			return 0;
+		default:
+			return -EOPNOTSUPP;
+		}
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static const struct hwmon_ops sfp_hwmon_ops = {
 	.is_visible = sfp_hwmon_is_visible,
 	.read = sfp_hwmon_read,
+	.read_string = sfp_hwmon_read_string,
 };
 
 static u32 sfp_hwmon_chip_config[] = {
@@ -1007,7 +1065,8 @@ static u32 sfp_hwmon_temp_config[] = {
 	HWMON_T_MAX | HWMON_T_MIN |
 	HWMON_T_MAX_ALARM | HWMON_T_MIN_ALARM |
 	HWMON_T_CRIT | HWMON_T_LCRIT |
-	HWMON_T_CRIT_ALARM | HWMON_T_LCRIT_ALARM,
+	HWMON_T_CRIT_ALARM | HWMON_T_LCRIT_ALARM |
+	HWMON_T_LABEL,
 	0,
 };
 
@@ -1021,7 +1080,8 @@ static u32 sfp_hwmon_vcc_config[] = {
 	HWMON_I_MAX | HWMON_I_MIN |
 	HWMON_I_MAX_ALARM | HWMON_I_MIN_ALARM |
 	HWMON_I_CRIT | HWMON_I_LCRIT |
-	HWMON_I_CRIT_ALARM | HWMON_I_LCRIT_ALARM,
+	HWMON_I_CRIT_ALARM | HWMON_I_LCRIT_ALARM |
+	HWMON_I_LABEL,
 	0,
 };
 
@@ -1035,7 +1095,8 @@ static u32 sfp_hwmon_bias_config[] = {
 	HWMON_C_MAX | HWMON_C_MIN |
 	HWMON_C_MAX_ALARM | HWMON_C_MIN_ALARM |
 	HWMON_C_CRIT | HWMON_C_LCRIT |
-	HWMON_C_CRIT_ALARM | HWMON_C_LCRIT_ALARM,
+	HWMON_C_CRIT_ALARM | HWMON_C_LCRIT_ALARM |
+	HWMON_C_LABEL,
 	0,
 };
 
@@ -1050,13 +1111,15 @@ static u32 sfp_hwmon_power_config[] = {
 	HWMON_P_MAX | HWMON_P_MIN |
 	HWMON_P_MAX_ALARM | HWMON_P_MIN_ALARM |
 	HWMON_P_CRIT | HWMON_P_LCRIT |
-	HWMON_P_CRIT_ALARM | HWMON_P_LCRIT_ALARM,
+	HWMON_P_CRIT_ALARM | HWMON_P_LCRIT_ALARM |
+	HWMON_P_LABEL,
 	/* Receive power */
 	HWMON_P_INPUT |
 	HWMON_P_MAX | HWMON_P_MIN |
 	HWMON_P_MAX_ALARM | HWMON_P_MIN_ALARM |
 	HWMON_P_CRIT | HWMON_P_LCRIT |
-	HWMON_P_CRIT_ALARM | HWMON_P_LCRIT_ALARM,
+	HWMON_P_CRIT_ALARM | HWMON_P_LCRIT_ALARM |
+	HWMON_P_LABEL,
 	0,
 };
 
-- 
2.23.0.rc1

