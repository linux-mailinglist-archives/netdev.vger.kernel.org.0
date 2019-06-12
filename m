Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9925B42BC4
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440211AbfFLQGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:06:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49300 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437056AbfFLQGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 12:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=U/TnKJfo+pP/G+SP3RIvd+pDttF74eoSUJvafSJ/DhE=; b=GUfecgakZkJ0s8tDXXS283gdud
        yHUmLvNQBtncmsx/ImPA8Myn8Zlwa/fvR/8dD+F16wTJekJiXNDdgfdkQGCrdQyOkeWYx8bZv3le5
        Ci8BDpEdz2y/tGqzO/CTAJ+9uDMs6+BzEMjVRkjWfsTNG7B4FFuYBLZKKCJZkA07hvXA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5lD-00068X-22; Wed, 12 Jun 2019 18:06:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Raju.Lakkaraju@microchip.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 04/13] net: ethtool: Add Properties for cable test reports.
Date:   Wed, 12 Jun 2019 18:05:25 +0200
Message-Id: <20190612160534.23533-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612160534.23533-1-andrew@lunn.ch>
References: <20190612160534.23533-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the attributes needed to report cable test results to userspace.
The reports are expected to be per twisted pair. A nested property per
pair can report the result of the cable test, and length of the cable
to any fault. More attributes can be added later for other types of
fault or measurement.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/uapi/linux/ethtool_netlink.h | 54 ++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index e9d0d6fac23b..aac76a26f97b 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -506,6 +506,60 @@ enum {
 	ETHTOOL_A_RXHASHOPT_MAX = (__ETHTOOL_A_RXHASHOPT_CNT - 1)
 };
 
+/* Cable test CMD_EVENT for reporting results */
+
+enum {
+	ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC,
+	ETHTOOL_A_CABLE_RESULT_CODE_OK,
+	ETHTOOL_A_CABLE_RESULT_CODE_OPEN,
+	ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT,
+	ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT,
+};
+
+enum {
+	ETHTOOL_A_CABLE_PAIR_0,
+	ETHTOOL_A_CABLE_PAIR_1,
+	ETHTOOL_A_CABLE_PAIR_2,
+	ETHTOOL_A_CABLE_PAIR_3,
+};
+
+enum {
+	ETHTOOL_A_CABLE_RESULT_UNSPEC,
+	ETHTOOL_A_CABLE_RESULT_PAIR,		/* u8 */
+	ETHTOOL_A_CABLE_RESULT_CODE,		/* u8 ETHTOOL_A_CABLE_RESULT_CODE_ */
+
+	__ETHTOOL_A_CABLE_RESULT_CNT,
+	ETHTOOL_A_CABLE_RESULT_MAX = (__ETHTOOL_A_CABLE_RESULT_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_FAULT_LENGTH_UNSPEC,
+	ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR,	/* u8 */
+	ETHTOOL_A_CABLE_FAULT_LENGTH_CM,	/* u16 */
+
+	__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT,
+	ETHTOOL_A_CABLE_FAULT_LENGTH_MAX = (__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_LENGTH_UNSPEC,
+	ETHTOOL_A_CABLE_LENGTH_PAIR,		/* u8 */
+	ETHTOOL_A_CABLE_LENGTH_CM,		/* u16 */
+
+	__ETHTOOL_A_CABLE_LENGTH_CNT,
+	ETHTOOL_A_CABLE_LENGTH_MAX = (__ETHTOOL_A_CABLE_LENGTH_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_TEST_EVENT_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_EVENT_DEV,		/* nest - ETHTOOL_A_DEV_* */
+	ETHTOOL_A_CABLE_TEST_EVENT_RESULT,	/* nest - ETHTOOL_A_CABLE_RESULT_ */
+	ETHTOOL_A_CABLE_TEST_EVENT_FAULT_LENGTH,/* nest - ETHTOOL_A_CABLE_FAULT_LENGTH_ */
+
+	__ETHTOOL_A_CABLE_TEST_EVENT_CNT,
+	ETHTOOL_A_CABLE_TEST_EVENT_MAX = (__ETHTOOL_A_CABLE_TEST_EVENT_CNT - 1)
+};
+
 /* ACT_CABLE_TEST */
 
 enum {
-- 
2.20.1

