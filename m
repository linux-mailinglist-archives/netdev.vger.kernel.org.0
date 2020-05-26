Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F451E3259
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391453AbgEZWWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:22:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50578 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390254AbgEZWV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 18:21:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=evLpajUbuKOhAqaiZp2WCPBhFUmMkHCUFeIexsTA1WA=; b=VUPWytuBZjPLRgp/H9RmmPMR2M
        wXcm7X8PNyolQQkXpZEzKsejWFetKcYMc4eOXuifGIMjSbjM4vOu1F72WyPHA5DVYIyKefRintW7r
        IGq+oy2kAA0C644NNzWgCoiLY3bIt2U7WW6j1wnl+zj4znSq4dUBzZn1u9vNjMJF9te4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdhxK-003KSz-1I; Wed, 27 May 2020 00:21:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 1/7] net: ethtool: Add attributes for cable test TDR data
Date:   Wed, 27 May 2020 00:21:37 +0200
Message-Id: <20200526222143.793613-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526222143.793613-1-andrew@lunn.ch>
References: <20200526222143.793613-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some Ethernet PHYs can return the raw time domain reflectromatry data.
Add the attributes to allow this data to be requested and returned via
netlink ethtool.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>

v2:
m -> cm
Report what the PHY actually used for start/stop/step.
---
 Documentation/networking/ethtool-netlink.rst | 81 ++++++++++++++++++++
 include/uapi/linux/ethtool_netlink.h         | 63 +++++++++++++++
 2 files changed, 144 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 7e651ea33eab..dae36227d590 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -205,6 +205,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_EEE_SET``               set EEE settings
   ``ETHTOOL_MSG_TSINFO_GET``		get timestamping info
   ``ETHTOOL_MSG_CABLE_TEST_ACT``        action start cable test
+  ``ETHTOOL_MSG_CABLE_TEST_TDR_ACT``    action start raw TDR cable test
   ===================================== ================================
 
 Kernel to userspace:
@@ -237,6 +238,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_EEE_NTF``               EEE settings
   ``ETHTOOL_MSG_TSINFO_GET_REPLY``	timestamping info
   ``ETHTOOL_MSG_CABLE_TEST_NTF``        Cable test results
+  ``ETHTOOL_MSG_CABLE_TEST_TDR_NTF``    Cable test TDR results
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1014,6 +1016,84 @@ information.
  | | | ``ETHTOOL_A_CABLE_FAULT_LENGTH_CM``     | u32    | length in cm        |
  +-+-+-----------------------------------------+--------+---------------------+
 
+CABLE_TEST TDR
+==============
+
+Start a cable test and report raw TDR data
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_CABLE_TEST_TDR_HEADER``   nested  request header
+  ====================================  ======  ==========================
+
+Notification contents:
+
+Raw TDR data is gathered by sending a pulse down the cable and
+recording the amplitude of the reflected pulse for a given distance.
+
+It can take a number of seconds to collect TDR data, especial if the
+full 100 meters is probed at 1 meter intervals. When the test is
+started a notification will be sent containing just
+ETHTOOL_A_CABLE_TEST_TDR_STATUS with the value
+ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED.
+
+When the test has completed a second notification will be sent
+containing ETHTOOL_A_CABLE_TEST_TDR_STATUS with the value
+ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED and the TDR data.
+
+The message may optionally contain the amplitude of the pulse send
+down the cable. This is measured in mV. A reflection should not be
+bigger than transmitted pulse.
+
+Before the raw TDR data should be an ETHTOOL_A_CABLE_TDR_NEST_STEP
+nest containing information about the distance along the cable for the
+first reading, the last reading, and the step between each
+reading. Distances are measured in centimeters. These should be the
+exact values the PHY used. These may be different to what the user
+requested, if the native measurement resolution is greater than 1 cm.
+
+For each step along the cable, a ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE is
+used to report the amplitude of the reflection for a given pair.
+
+ +---------------------------------------------+--------+----------------------+
+ | ``ETHTOOL_A_CABLE_TEST_TDR_HEADER``         | nested | reply header         |
+ +---------------------------------------------+--------+----------------------+
+ | ``ETHTOOL_A_CABLE_TEST_TDR_STATUS``         | u8     | completed            |
+ +---------------------------------------------+--------+----------------------+
+ | ``ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST``       | nested | all the results      |
+ +-+-------------------------------------------+--------+----------------------+
+ | | ``ETHTOOL_A_CABLE_TDR_NEST_PULSE``        | nested | TX Pulse amplitude   |
+ +-+-+-----------------------------------------+--------+----------------------+
+ | | | ``ETHTOOL_A_CABLE_PULSE_mV``            | s16    | Pulse amplitude      |
+ +-+-+-----------------------------------------+--------+----------------------+
+ | | ``ETHTOOL_A_CABLE_NEST_STEP``             | nested | TDR step info        |
+ +-+-+-----------------------------------------+--------+----------------------+
+ | | | ``ETHTOOL_A_CABLE_STEP_FIRST_DISTANCE ``| u32    | First data distance  |
+ +-+-+-----------------------------------------+--------+----------------------+
+ | | | ``ETHTOOL_A_CABLE_STEP_LAST_DISTANCE `` | u32    | Last data distance   |
+ +-+-+-----------------------------------------+--------+----------------------+
+ | | | ``ETHTOOL_A_CABLE_STEP_STEP_DISTANCE `` | u32    | distance of each step|
+ +-+-+-----------------------------------------+--------+----------------------+
+ | | ``ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE``    | nested | Reflection amplitude |
+ +-+-+-----------------------------------------+--------+----------------------+
+ | | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number          |
+ +-+-+-----------------------------------------+--------+----------------------+
+ | | | ``ETHTOOL_A_CABLE_AMPLITUDE_mV``        | s16    | Reflection amplitude |
+ +-+-+-----------------------------------------+--------+----------------------+
+ | | ``ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE``    | nested | Reflection amplitude |
+ +-+-+-----------------------------------------+--------+----------------------+
+ | | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number          |
+ +-+-+-----------------------------------------+--------+----------------------+
+ | | | ``ETHTOOL_A_CABLE_AMPLITUDE_mV``        | s16    | Reflection amplitude |
+ +-+-+-----------------------------------------+--------+----------------------+
+ | | ``ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE``    | nested | Reflection amplitude |
+ +-+-+-----------------------------------------+--------+----------------------+
+ | | | ``ETHTOOL_A_CABLE_RESULTS_PAIR``        | u8     | pair number          |
+ +-+-+-----------------------------------------+--------+----------------------+
+ | | | ``ETHTOOL_A_CABLE_AMPLITUDE_mV``        | s16    | Reflection amplitude |
+ +-+-+-----------------------------------------+--------+----------------------+
+
 Request translation
 ===================
 
@@ -1110,4 +1190,5 @@ are netlink only.
   ``ETHTOOL_GFECPARAM``               n/a
   ``ETHTOOL_SFECPARAM``               n/a
   n/a                                 ''ETHTOOL_MSG_CABLE_TEST_ACT''
+  n/a                                 ''ETHTOOL_MSG_CABLE_TEST_TDR_ACT''
   =================================== =====================================
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index e6f109b76c9a..739faa7070c6 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -40,6 +40,7 @@ enum {
 	ETHTOOL_MSG_EEE_SET,
 	ETHTOOL_MSG_TSINFO_GET,
 	ETHTOOL_MSG_CABLE_TEST_ACT,
+	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -76,6 +77,7 @@ enum {
 	ETHTOOL_MSG_EEE_NTF,
 	ETHTOOL_MSG_TSINFO_GET_REPLY,
 	ETHTOOL_MSG_CABLE_TEST_NTF,
+	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -478,6 +480,67 @@ enum {
 	ETHTOOL_A_CABLE_TEST_NTF_MAX = (__ETHTOOL_A_CABLE_TEST_NTF_CNT - 1)
 };
 
+/* CABLE TEST TDR */
+
+enum {
+	ETHTOOL_A_CABLE_TEST_TDR_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_TDR_HEADER,	/* nest - _A_HEADER_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_CABLE_TEST_TDR_CNT,
+	ETHTOOL_A_CABLE_TEST_TDR_MAX = __ETHTOOL_A_CABLE_TEST_TDR_CNT - 1
+};
+
+/* CABLE TEST TDR NOTIFY */
+
+enum {
+	ETHTOOL_A_CABLE_AMPLITUDE_UNSPEC,
+	ETHTOOL_A_CABLE_AMPLITUDE_PAIR,         /* u8 */
+	ETHTOOL_A_CABLE_AMPLITUDE_mV,           /* s16 */
+
+	__ETHTOOL_A_CABLE_AMPLITUDE_CNT,
+	ETHTOOL_A_CABLE_AMPLITUDE_MAX = (__ETHTOOL_A_CABLE_AMPLITUDE_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_PULSE_UNSPEC,
+	ETHTOOL_A_CABLE_PULSE_mV,		/* s16 */
+
+	__ETHTOOL_A_CABLE_PULSE_CNT,
+	ETHTOOL_A_CABLE_PULSE_MAX = (__ETHTOOL_A_CABLE_PULSE_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_STEP_UNSPEC,
+	ETHTOOL_A_CABLE_STEP_FIRST_DISTANCE,	/* u32 */
+	ETHTOOL_A_CABLE_STEP_LAST_DISTANCE,	/* u32 */
+	ETHTOOL_A_CABLE_STEP_STEP_DISTANCE,	/* u32 */
+
+	__ETHTOOL_A_CABLE_STEP_CNT,
+	ETHTOOL_A_CABLE_STEP_MAX = (__ETHTOOL_A_CABLE_STEP_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_TDR_NEST_UNSPEC,
+	ETHTOOL_A_CABLE_TDR_NEST_STEP,		/* nest - ETHTTOOL_A_CABLE_STEP */
+	ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE,	/* nest - ETHTOOL_A_CABLE_AMPLITUDE */
+	ETHTOOL_A_CABLE_TDR_NEST_PULSE,		/* nest - ETHTOOL_A_CABLE_PULSE */
+
+	__ETHTOOL_A_CABLE_TDR_NEST_CNT,
+	ETHTOOL_A_CABLE_TDR_NEST_MAX = (__ETHTOOL_A_CABLE_TDR_NEST_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_TEST_TDR_NTF_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_TDR_NTF_HEADER,	/* nest - ETHTOOL_A_HEADER_* */
+	ETHTOOL_A_CABLE_TEST_TDR_NTF_STATUS,	/* u8 - _STARTED/_COMPLETE */
+	ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST,	/* nest - of results: */
+
+	/* add new constants above here */
+	__ETHTOOL_A_CABLE_TEST_TDR_NTF_CNT,
+	ETHTOOL_A_CABLE_TEST_TDR_NTF_MAX = __ETHTOOL_A_CABLE_TEST_TDR_NTF_CNT - 1
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
-- 
2.27.0.rc0

