Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1361C4AF2
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 02:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgEEASr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 20:18:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41294 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgEEASp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 20:18:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9XK8apHIqTaHs8ni/GkrcpaJaRnZ/8rud6fFu/reRzM=; b=pKgwPfB3RgQ9MhH0V5NXAT4b+E
        08IzmsWfVN2RBsnasP446rziXQiCEuu5S0R6rvEu9INuUa3sqE046DSNkYaqbGFrUzQFUQe0/R4UH
        wQ9nNC475/npXn5X2nBOke20bXPO+on9mN1QorUZsQ8xWcPI+fnXhfUQoNJOoe/CSJFE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVlID-000sGT-Fi; Tue, 05 May 2020 02:18:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 04/10] net: ethtool: Add attributes for cable test reports
Date:   Tue,  5 May 2020 02:18:15 +0200
Message-Id: <20200505001821.208534-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200505001821.208534-1-andrew@lunn.ch>
References: <20200505001821.208534-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the attributes needed to report cable test results to userspace.
The reports are expected to be per twisted pair. A nested property per
pair can report the result of the cable test. A nested property can
also report the length of the cable to any fault.

v2:
Grammar fixes
Change length from u16 to u32
s/DEV/HEADER/g
Add status attributes
Rename pairs from numbers to letters.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/networking/ethtool-netlink.rst | 42 +++++++++++++++
 include/uapi/linux/ethtool_netlink.h         | 54 +++++++++++++++++++-
 2 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 72d53da2bea9..7a8a76f08bb9 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -968,6 +968,48 @@ Request contents:
   ``ETHTOOL_A_CABLE_TEST_HEADER``       nested  request header
   ====================================  ======  ==========================
 
+Notification contents:
+
+An Ethernet cable typically contains 1, 2 or 4 pairs. The length of
+the pair can only be measured when there is a fault in the pair and
+hence a reflection. Information about the fault may not be available,
+depending on the specific hardware. Hence the contents of the notify
+message are mostly optional. The attributes can be repeated an
+arbitrary number of times, in an arbitrary order, for an arbitrary
+number of pairs.
+
+The example shows the notification sent when the test is completed for
+a T2 cable, i.e. two pairs. One pair is OK and hence has no length
+information. The second pair has a fault and does have length
+information.
+
+ +---------------------------------------------+--------+---------------------+
+ | ``ETHTOOL_A_CABLE_TEST_HEADER``             | nested | reply header        |
+ +---------------------------------------------+--------+---------------------+
+ | ``ETHTOOL_A_CABLE_TEST_STATUS``             | u8     | completed           |
+ +---------------------------------------------+--------+---------------------+
+ | ``ETHTOOL_A_CABLE_TEST_NTF_NEST``           | nested | all the results     |
+ +-+-------------------------------------------+--------+---------------------+
+ | | ``ETHTOOL_A_CABLE_TEST_STATUS``           | u8     | completed           |
+ +-+-------------------------------------------+--------+---------------------+
+ | | ``ETHTOOL_A_CABLE_TEST_NTF_RESULT``       | nested | cable test result   |
+ +-+-+-----------------------------------------+--------+---------------------+
+ | | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number         |
+ +-+-+-----------------------------------------+--------+---------------------+
+ | | | ``ETHTOOL_A_CABLE_RESULTS_CODE``        | u8     | result code         |
+ +-+-+-----------------------------------------+--------+---------------------+
+ | | ``ETHTOOL_A_CABLE_TEST_NTF_RESULT``       | nested | cable test results  |
+ +-+-+-----------------------------------------+--------+---------------------+
+ | | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number         |
+ +-+-+-----------------------------------------+--------+---------------------+
+ | | | ``ETHTOOL_A_CABLE_RESULTS_CODE``        | u8     | result code         |
+ +-+-+-----------------------------------------+--------+---------------------+
+ | | ``ETHTOOL_A_CABLE_TEST_NTF_FAULT_LENGTH`` | nested | cable length        |
+ +-+-+-----------------------------------------+--------+---------------------+
+ | | | ``ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR``   | u8     | pair number         |
+ +-+-+-----------------------------------------+--------+---------------------+
+ | | | ``ETHTOOL_A_CABLE_FAULT_LENGTH_CM``     | u32    | length in cm        |
+ +-+-+-----------------------------------------+--------+---------------------+
 
 Request translation
 ===================
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 7e16a1cce20b..519c37e61fe8 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -75,6 +75,7 @@ enum {
 	ETHTOOL_MSG_EEE_GET_REPLY,
 	ETHTOOL_MSG_EEE_NTF,
 	ETHTOOL_MSG_TSINFO_GET_REPLY,
+	ETHTOOL_MSG_CABLE_TEST_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -402,7 +403,6 @@ enum {
 	/* add new constants above here */
 	__ETHTOOL_A_TSINFO_CNT,
 	ETHTOOL_A_TSINFO_MAX = (__ETHTOOL_A_TSINFO_CNT - 1)
-
 };
 
 /* CABLE TEST */
@@ -416,6 +416,58 @@ enum {
 	ETHTOOL_A_CABLE_TEST_MAX = __ETHTOOL_A_CABLE_TEST_CNT - 1
 };
 
+/* CABLE TEST NOTIFY */
+enum {
+	ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC,
+	ETHTOOL_A_CABLE_RESULT_CODE_OK,
+	ETHTOOL_A_CABLE_RESULT_CODE_OPEN,
+	ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT,
+	ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT,
+};
+
+enum {
+	ETHTOOL_A_CABLE_PAIR_A,
+	ETHTOOL_A_CABLE_PAIR_B,
+	ETHTOOL_A_CABLE_PAIR_C,
+	ETHTOOL_A_CABLE_PAIR_D,
+};
+
+enum {
+	ETHTOOL_A_CABLE_RESULT_UNSPEC,
+	ETHTOOL_A_CABLE_RESULT_PAIR,		/* u8 ETHTOOL_A_CABLE_PAIR_ */
+	ETHTOOL_A_CABLE_RESULT_CODE,		/* u8 ETHTOOL_A_CABLE_RESULT_CODE_ */
+
+	__ETHTOOL_A_CABLE_RESULT_CNT,
+	ETHTOOL_A_CABLE_RESULT_MAX = (__ETHTOOL_A_CABLE_RESULT_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_FAULT_LENGTH_UNSPEC,
+	ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR,	/* u8 ETHTOOL_A_CABLE_PAIR_ */
+	ETHTOOL_A_CABLE_FAULT_LENGTH_CM,	/* u32 */
+
+	__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT,
+	ETHTOOL_A_CABLE_FAULT_LENGTH_MAX = (__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_TEST_NTF_STATUS_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED,
+	ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED
+};
+
+enum {
+	ETHTOOL_A_CABLE_TEST_NTF_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_NTF_HEADER,	/* nest - ETHTOOL_A_HEADER_* */
+	ETHTOOL_A_CABLE_TEST_NTF_STATUS,	/* u8 - _STARTED/_COMPLETE */
+	ETHTOOL_A_CABLE_TEST_NTF_NEST,		/* nest - of results: */
+	ETHTOOL_A_CABLE_TEST_NTF_RESULT,	/* nest - ETHTOOL_A_CABLE_RESULT_ */
+	ETHTOOL_A_CABLE_TEST_NTF_FAULT_LENGTH,	/* nest - ETHTOOL_A_CABLE_FAULT_LENGTH_ */
+
+	__ETHTOOL_A_CABLE_TEST_NTF_CNT,
+	ETHTOOL_A_CABLE_TEST_NTF_MAX = (__ETHTOOL_A_CABLE_TEST_NTF_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
-- 
2.26.2

