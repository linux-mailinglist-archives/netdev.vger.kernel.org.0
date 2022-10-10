Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D11A5F9685
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 03:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiJJBSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 21:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiJJBSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 21:18:40 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D392E9D8;
        Sun,  9 Oct 2022 18:18:34 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id E495B504E55;
        Mon, 10 Oct 2022 04:14:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru E495B504E55
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1665364498; bh=XLHIvhz9omIEbrPi1AG5YDmm+bbkVnYbVuLRgaKLvoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sE9K+oJV6ORuVdu3MsM15fleM8DZrdYjLf15jUo22ykf3XGVemNTIhK6pZ3sWDeNR
         DM+dnAuR8AmsFgQKTMm5gnAncLOd0KrHt2U6yc7aO9iqYMQjQGXldz606wgCuecJoB
         WFDyzIsm+hbhA6tib3QiCE2/NWSAp9Bm2qk+faT8=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: [RFC PATCH v3 5/6] dpll: documentation on DPLL subsystem interface
Date:   Mon, 10 Oct 2022 04:18:03 +0300
Message-Id: <20221010011804.23716-6-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221010011804.23716-1-vfedorenko@novek.ru>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

Add documentation explaining common netlink interface to configure DPLL
devices and monitoring events. Common way to implement DPLL device in
a driver is also covered.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 Documentation/networking/dpll.rst  | 157 +++++++++++++++++++++++++++++
 Documentation/networking/index.rst |   1 +
 2 files changed, 158 insertions(+)
 create mode 100644 Documentation/networking/dpll.rst

diff --git a/Documentation/networking/dpll.rst b/Documentation/networking/dpll.rst
new file mode 100644
index 000000000000..00c15b19aefb
--- /dev/null
+++ b/Documentation/networking/dpll.rst
@@ -0,0 +1,157 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============================
+The Linux kernel DPLL subsystem
+===============================
+
+
+The main purpose of DPLL subsystem is to provide general interface
+to configure devices that use any kind of Digital PLL and could use
+different sources of signal to synchronize to as well as different
+types of outputs. The inputs and outputs could be internal components
+of the device as well as external connections. The main interface is
+NETLINK_GENERIC based protocol with config and monitoring groups of
+commands defined.
+
+Configuration commands group
+============================
+
+Configuration commands are used to get information about registered
+DPLL devices as well as get or set configuration of each used input
+or output. As DPLL device could not be abstract and reflects real
+hardware, there is no way to add new DPLL device via netlink from
+user space and each device should be registered by it's driver.
+
+List of command with possible attributes
+========================================
+
+All constants identifying command types use ``DPLL_CMD_`` prefix and
+suffix according to command purpose. All attributes use ``DPLLA_``
+prefix and suffix according to attribute purpose:
+
+  =====================================  =============================
+  ``DEVICE_GET``                         userspace to get device info
+    ``DEVICE_ID``                        attr internal device index
+    ``DEVICE_NAME``                      attr DPLL device name
+    ``STATUS``                           attr DPLL device status info
+    ``DEVICE_SRC_SELECT_MODE``           attr DPLL source selection
+                                         mode
+    ``DEVICE_SRC_SELECT_MODE_SUPPORTED`` attr supported source
+                                         selection modes
+    ``LOCK_STATUS``                      attr internal frequency-lock
+                                         status
+    ``TEMP``                             attr device temperature
+                                         information
+  ``SET_SOURCE``                         userspace to set
+                                         sources/inputs configuration
+    ``DEVICE_ID``                        attr internal device index
+                                         to configure source pin
+    ``SOURCE_ID``                        attr index of source pin to
+                                         configure
+    ``SOURCE_NAME``                      attr name of source pin to
+                                         configure
+    ``SOURCE_TYPE``                      attr configuration value for
+                                         selected source pin
+  ``SET_OUTPUT``                         userspace to set outputs
+                                         configuration
+    ``DEVICE_ID``                        attr internal device index to
+                                         configure output pin
+    ``OUTPUT_ID``                        attr index of output pin to
+                                         configure
+    ``OUTPUT_NAME``                      attr name of output pin to
+                                         configure
+    ``OUTPUT_TYPE``                      attr configuration value for
+                                         selected output pin
+  ``SET_SRC_SELECT_MODE``                userspace to set source pin
+                                         selection mode
+    ``DEVICE_ID``                        attr internal device index
+    ``DEVICE_SRC_SELECT_MODE``           attr source selection mode
+  ``SET_SOURCE_PRIO``                    userspace to set priority of
+                                         a source pin for automatic
+                                         source selection mode
+    ``DEVICE_ID``                        attr internal device index
+                                         for source pin
+    ``SOURCE_ID``                        attr index of source pin to
+                                         configure
+    ``SOURCE_PRIO``                      attr priority of a source pin
+
+
+The pre-defined enums
+=====================
+
+These enums are used to select type values for source/input and
+output pins:
+
+  ============================= ======================================
+  ``DPLL_TYPE_EXT_1PPS``        External 1PPS source
+  ``DPLL_TYPE_EXT_10MHZ``       External 10MHz source
+  ``DPLL_TYPE_SYNCE_ETH_PORT``  SyncE on Ethernet port
+  ``DPLL_TYPE_INT_OSCILLATOR``  Internal Oscillator (i.e. Holdover
+                                with Atomic Clock as a Source)
+  ``DPLL_TYPE_GNSS``            GNSS 1PPS source
+  ``DPLL_TYPE_CUSTOM``          Custom frequency
+
+Values for monitoring attributes STATUS:
+
+  ============================= ======================================
+  ``DPLL_STATUS_NONE``          No information provided
+  ``DPLL_STATUS_CALIBRATING``   DPLL device is not locked to the
+                                source frequency
+  ``DPLL_STATUS_LOCKED``        DPLL device is locked to the source
+                                frequency
+
+
+Possible DPLL source selection mode values:
+
+  ============================= ======================================
+  ``DPLL_SRC_SELECT_FORCED``    source pin is force-selected by
+                                DPLL_CMD_SET_SOURCE_TYPE
+  ``DPLL_SRC_SELECT_AUTOMATIC`` source pin ise auto selected according
+                                to configured priorities and source
+                                signal validity
+  ``DPLL_SRC_SELECT_HOLDOVER``  force holdover mode of DPLL
+  ``DPLL_SRC_SELECT_FREERUN``   DPLL is driven by supplied system
+                                clock without holdover capabilities
+  ``DPLL_SRC_SELECT_NCO``       similar to FREERUN, with possibility
+                                to numerically control frequency offset
+
+Notifications
+================
+
+DPLL device can provide notifications regarding status changes of the
+device, i.e. lock status changes, source/output type changes or alarms.
+This is the multicast group that is used to notify user-space apps via
+netlink socket:
+
+  ============================== ====================================
+  ``DPLL_EVENT_DEVICE_CREATE``   New DPLL device was created
+  ``DPLL_EVENT_DEVICE_DELETE``   DPLL device was deleted
+  ``DPLL_EVENT_STATUS_LOCKED``   DPLL device has locked to source
+  ``DPLL_EVENT_STATUS_UNLOCKED`` DPLL device is in freerun or
+                                 in calibration mode
+  ``DPLL_EVENT_SOURCE_CHANGE``   DPLL device source changed
+  ``DPLL_EVENT_OUTPUT_CHANGE``   DPLL device output changed
+  ``DPLL_EVENT_SOURCE_PRIO``     DPLL device source priority changed
+  ``DPLL_EVENT_SELECT_MODE``     DPLL device source selection mode
+                                 changed
+
+Device driver implementation
+============================
+
+For device to operate as DPLL subsystem device, it should implement
+set of operations and register device via ``dpll_device_alloc`` and
+``dpll_device_register`` providing desired device name and set of
+supported operations as well as the amount of sources/input pins and
+output pins. If there is no specific name supplied, dpll subsystem
+will use ``dpll%d`` template to create device name. Notifications of
+adding or removing DPLL devices are created within subsystem itself,
+but notifications about configurations changes or alarms should be
+implemented within driver as different ways of confirmation could be
+used. All the interfaces for notification messages could be found in
+``<dpll.h>``, constats and enums are placed in ``<uapi/linux/dpll.h>``
+to be consistent with user-space.
+
+There is no strict requeriment to implement all the operations for
+each device, every operation handler is checked for existence and
+ENOTSUPP is returned in case of absence of specific handler.
+
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 16a153bcc5fe..612d322a3380 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -16,6 +16,7 @@ Contents:
    device_drivers/index
    dsa/index
    devlink/index
+   dpll
    caif/index
    ethtool-netlink
    ieee802154
-- 
2.27.0

