Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25EAF1B8862
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 20:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgDYSGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 14:06:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34916 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgDYSGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 14:06:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=b1jgWz81JBOvQ/jBOtQzSq2AAxy70juC2Jq/NIv9lUc=; b=RZTC8r2KzkJyV1C/01tfZSddC3
        gF8H6xJX/vUwPD/l92t/LRez+9vlxpfN0VBTQAWLcpTlpFr+PV77eMRl0jVNHe5g7yXqhQ1ODOWS+
        9EYMCZRrj4oEUbSCtxz6IfSftD8joQwvh9tkc2gYVo49YxpYIRQ7Gujuyp1BmWkUEH8M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jSPCG-004mhh-9X; Sat, 25 Apr 2020 20:06:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v1 4/9] net: ethtool: Add attributes for cable test reports
Date:   Sat, 25 Apr 2020 20:06:16 +0200
Message-Id: <20200425180621.1140452-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200425180621.1140452-1-andrew@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
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

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 Documentation/networking/ethtool-netlink.rst | 35 +++++++++++++++
 include/uapi/linux/ethtool_netlink.h         | 47 +++++++++++++++++++-
 2 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 0c354567e991..89fd321b0e29 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -967,6 +967,41 @@ Request contents:
   ``ETHTOOL_A_CABLE_TEST_HEADER``       nested  request header
   ====================================  ======  ==========================
 
+Notify contents:
+
+An Ethernet cable typically contains 1, 2 or 4 pairs. The length of
+the pair can only be measured when there is a fault in the pair and
+hence a reflection. Information about the fault may not be available,
+depends on the specific hardware. Hence the contents of the notify
+message is mostly optional. The attributes can be repeated an
+arbitrary number of times, in an arbitrary order, for an arbitrary
+number of pairs.
+
+The example shows a T2 cable, i.e. two pairs. One pair is O.K, and
+hence has no length information. The second pair has a fault and does
+have length information.
+
+ +-------------------------------------------+--------+-----------------------+
+ | ``ETHTOOL_A_CABLE_TEST_HEADER``           | nested | reply header          |
+ +-------------------------------------------+--------+-----------------------+
+ | ``ETHTOOL_A_CABLE_TEST_NTF_RESULT``       | nested | cable test result     |
+ +-+-----------------------------------------+--------+-----------------------+
+ | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number           |
+ +-+-----------------------------------------+--------+-----------------------+
+ | | ``ETHTOOL_A_CABLE_RESULTS_CODE``        | u8     | result code           |
+ +-+-----------------------------------------+--------+-----------------------+
+ | ``ETHTOOL_A_CABLE_TEST_NTF_RESULT``       | nested | cable test results    |
+ +-+-----------------------------------------+--------+-----------------------+
+ | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number           |
+ +-+-----------------------------------------+--------+-----------------------+
+ | | ``ETHTOOL_A_CABLE_RESULTS_CODE``        | u8     | result code           |
+ +-+-----------------------------------------+--------+-----------------------+
+ | ``ETHTOOL_A_CABLE_TEST_NTF_FAULT_LENGTH`` | nested | cable length          |
+ +-+-----------------------------------------+--------+-----------------------+
+ | | ``ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR``   | u8     | pair number           |
+ +-+-----------------------------------------+--------+-----------------------+
+ | | ``ETHTOOL_A_CABLE_FAULT_LENGTH_CM``     | u8     | length in cm          |
+ +-+-----------------------------------------+--------+-----------------------+
 
 Request translation
 ===================
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 598d0b502ebd..05ef5048e4fc 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -76,6 +76,7 @@ enum {
 	ETHTOOL_MSG_EEE_NTF,
 	ETHTOOL_MSG_TSINFO_GET_REPLY,
 	ETHTOOL_MSG_CABLE_TEST_ACT_REPLY,
+	ETHTOOL_MSG_CABLE_TEST_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -403,7 +404,6 @@ enum {
 	/* add new constants above here */
 	__ETHTOOL_A_TSINFO_CNT,
 	ETHTOOL_A_TSINFO_MAX = (__ETHTOOL_A_TSINFO_CNT - 1)
-
 };
 
 /* CABLE TEST */
@@ -417,6 +417,51 @@ enum {
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
+	ETHTOOL_A_CABLE_PAIR_0,
+	ETHTOOL_A_CABLE_PAIR_1,
+	ETHTOOL_A_CABLE_PAIR_2,
+	ETHTOOL_A_CABLE_PAIR_3,
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
+	ETHTOOL_A_CABLE_FAULT_LENGTH_CM,	/* u16 */
+
+	__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT,
+	ETHTOOL_A_CABLE_FAULT_LENGTH_MAX = (__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_TEST_NTF_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_NTF_DEV,		/* nest - ETHTOOL_A_DEV_* */
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
2.26.1

