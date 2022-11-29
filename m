Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1983463CA9D
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 22:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236832AbiK2Vqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 16:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236671AbiK2Vqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 16:46:46 -0500
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE386C701;
        Tue, 29 Nov 2022 13:46:44 -0800 (PST)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id A405B504F7D;
        Wed, 30 Nov 2022 00:33:53 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru A405B504F7D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1669757636; bh=jxC5mb/B563MYzjyvSKFbgKSDLCEdK3pzyR9nUdt0G8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DET4Nkq4PmScypnwvF5IFjbz4erXktgCgNOltyJex6PNoErMpgqYjneHvBMIMNPqE
         HQvMkfaCL/xuko2nbfskLrYoJ6Rpq2S/kRe+Tf2Yq5gCntYfv0x83JSDTdUyRfm7Ou
         LmBpw3wa4OzeIQ3FDVMUbizUtY0Pyfa/HbBuWxMs=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: [RFC PATCH v4 3/4] dpll: documentation on DPLL subsystem interface
Date:   Wed, 30 Nov 2022 00:37:23 +0300
Message-Id: <20221129213724.10119-4-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221129213724.10119-1-vfedorenko@novek.ru>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
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

Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 Documentation/networking/dpll.rst  | 271 +++++++++++++++++++++++++++++
 Documentation/networking/index.rst |   1 +
 2 files changed, 272 insertions(+)
 create mode 100644 Documentation/networking/dpll.rst

diff --git a/Documentation/networking/dpll.rst b/Documentation/networking/dpll.rst
new file mode 100644
index 000000000000..58401e2b70a7
--- /dev/null
+++ b/Documentation/networking/dpll.rst
@@ -0,0 +1,271 @@
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
+types of outputs.
+The main interface is NETLINK_GENERIC based protocol with an event
+monitoring multicast group defined.
+
+
+Pin object
+==========
+A pin is amorphic object which represents either input and output, it
+could be internal component of the device, as well as externaly
+connected.
+The number of pins per dpll vary, but usually multiple pins shall be
+provided for a single dpll device.
+Direction of a pin and it's capabilities are provided to the user in
+response for netlink dump request messages.
+Pin can be shared by multiple dpll devices. Where configuration on one
+pin can alter multiple dplls (i.e. DPLL_PIN_SGINAL_TYPE, DPLL_PIN_TYPE,
+DPLL_PIN_STATE), or just one pin-dpll pair (i.e. DPLL_PIN_PRIO).
+Pin can be also a MUX type, where one or more pins are attached to
+a parent pin. The parent pin is the one directly connected to the dpll,
+which may be used by dplls in DPLL_MODE_AUTOMATIC selection mode, where
+only pins directly connected to the dpll are capable of automatic
+source pin selection. In such case, pins are dumped with
+DPLLA_PIN_PARENT_IDX, and are able to be selected by the userspace with
+netlink request.
+
+Configuration commands group
+============================
+
+Configuration commands are used to get or dump information about
+registered DPLL devices (and pins), as well as set configuration of
+device or pins. As DPLL device could not be abstract and reflects real
+hardware, there is no way to add new DPLL device via netlink from user
+space and each device should be registered by it's driver.
+
+List of command with possible attributes
+========================================
+
+All constants identifying command types use ``DPLL_CMD_`` prefix and
+suffix according to command purpose. All attributes use ``DPLLA_``
+prefix and suffix according to attribute purpose:
+
+  ============================  =======================================
+  ``DEVICE_GET``                userspace to get device info
+    ``ID``                      attr internal dpll device index
+    ``NAME``                    attr dpll device name
+    ``MODE``                    attr selection mode
+    ``MODE_SUPPORTED``          attr available selection modes
+    ``SOURCE_PIN_IDX``          attr index of currently selected source
+    ``LOCK_STATUS``             attr internal frequency-lock status
+    ``TEMP``                    attr device temperature information
+    ``NETIFINDEX``              attr dpll owner Linux netdevice index
+  ``DEVICE_SET``                userspace to set dpll device
+                                configuration
+    ``ID``                      attr internal dpll device index
+    ``MODE``                    attr selection mode to configure
+    ``PIN_IDX``                 attr index of source pin to select as
+                                active source
+  ``PIN_SET``                   userspace to set pins configuration
+    ``ID``                      attr internal dpll device index
+    ``PIN_IDX``                 attr index of a pin to configure
+    ``PIN_TYPE``                attr type configuration value for
+                                selected pin
+    ``PIN_SIGNAL_TYPE``         attr signal type configuration value
+                                for selected pin
+    ``PIN_CUSTOM_FREQ``         attr signal custom frequency to be set
+    ``PIN_STATE``               attr pin state to be set
+    ``PIN_PRIO``                attr pin priority to be set
+
+Netlink dump requests
+=====================
+The ``DEVICE_GET`` command is capable of dump type netlink requests.
+In such case the userspace shall provide ``DUMP_FILTER`` attribute
+value to filter the response as required.
+If filter is not provided only name and id of available dpll(s) is
+provided. If the request also contains ``ID`` attribute, only selected
+dpll device shall be dumped.
+
+Possible response message attributes for netlink requests depending on
+the value of ``DPLLA_DUMP_FILTER`` attribute:
+
+  =============================== ====================================
+  ``DPLL_DUMP_FILTER_PINS``       value of ``DUMP_FILTER`` attribute
+    ``PIN``                       attr nested type contain single pin
+                                  attributes
+    ``PIN_IDX``                   attr index of dumped pin
+    ``PIN_DESCRIPTION``           description of a pin provided by
+                                  driver
+    ``PIN_TYPE``                  attr value of pin type
+    ``PIN_TYPE_SUPPORTED``        attr value of supported pin type
+    ``PIN_SIGNAL_TYPE``           attr value of pin signal type
+    ``PIN_SIGNAL_TYPE_SUPPORTED`` attr value of supported pin signal
+                                  type
+    ``PIN_CUSTOM_FREQ``           attr value of pin custom frequency
+    ``PIN_STATE``                 attr value of pin state
+    ``PIN_STATE_SUPPORTED``       attr value of supported pin state
+    ``PIN_PRIO``                  attr value of pin prio
+    ``PIN_PARENT_IDX``            attr value of pin patent index
+    ``PIN_NETIFINDEX``            attr value of netdevice assocaiated
+                                  with the pin
+  ``DPLL_DUMP_FILTER_STATUS``     value of ``DUMP_FILTER`` attribute
+    ``ID``                        attr internal dpll device index
+    ``NAME``                      attr dpll device name
+    ``MODE``                      attr selection mode
+    ``MODE_SUPPORTED``            attr available selection modes
+    ``SOURCE_PIN_IDX``            attr index of currently selected
+                                  source
+    ``LOCK_STATUS``               attr internal frequency-lock status
+    ``TEMP``                      attr device temperature information
+    ``NETIFINDEX``                attr dpll owner Linux netdevice index
+
+
+The pre-defined enums
+=====================
+
+All the enums use the ``DPLL_`` prefix.
+
+Values for ``PIN_TYPE`` and ``PIN_TYPE_SUPPORTED`` attributes:
+
+  ============================ ========================================
+  ``PIN_TYPE_MUX``             MUX type pin, connected pins shall
+                               have their own types
+  ``PIN_TYPE_EXT``             External pin
+  ``PIN_TYPE_SYNCE_ETH_PORT``  SyncE on Ethernet port
+  ``PIN_TYPE_INT_OSCILLATOR``  Internal Oscillator (i.e. Holdover
+                               with Atomic Clock as a Source)
+  ``PIN_TYPE_GNSS``            GNSS 1PPS source
+
+Values for ``PIN_SIGNAL_TYPE`` and ``PIN_SIGNAL_TYPE_SUPPORTED``
+attributes:
+
+  ===============================  ===================================
+  ``PIN_SIGNAL_TYPE_1_PPS``        1 Hz frequency
+  ``PIN_SIGNAL_TYPE_10_MHZ``       10 MHz frequency
+  ``PIN_SIGNAL_TYPE_CUSTOM_FREQ``  Frequency value provided in attr
+                                   ``PIN_CUSTOM_FREQ``
+
+Values for ``LOCK_STATUS`` attribute:
+
+  ============================= ======================================
+  ``LOCK_STATUS_UNLOCKED``      DPLL is in freerun, not locked to any
+                                source pin
+  ``LOCK_STATUS_CALIBRATING``   DPLL device calibrates to lock to the
+                                source pin signal
+  ``LOCK_STATUS_LOCKED``        DPLL device is locked to the source
+                                pin frequency
+  ``LOCK_STATUS_HOLDOVER``      DPLL device lost a lock, using its
+                                frequency holdover capabilities
+
+Values for ``PIN_STATE`` and ``PIN_STATE_SUPPORTED`` attributes:
+
+============================= ============================
+  ``PIN_STATE_CONNECTED``     Pin connected to a dpll
+  ``PIN_STATE_DISCONNECTED``  Pin disconnected from dpll
+  ``PIN_STATE_SOURCE``        Source pin
+  ``PIN_STATE_OUTPUT``        Output pin
+
+Possible DPLL source selection mode values:
+
+  =================== ================================================
+  ``MODE_FORCED``     source pin is force-selected by
+                      ``DPLL_CMD_DEVICE_SET`` with given value of
+                      ``DPLLA_SOURCE_PIN_IDX`` attribute
+  ``MODE_AUTOMATIC``  source pin ise auto selected according to
+                      configured pin priorities and source signal
+                      validity
+  ``MODE_HOLDOVER``   force holdover mode of DPLL
+  ``MODE_FREERUN``    DPLL is driven by supplied system clock without
+                      holdover capabilities
+  ``MODE_NCO``        similar to FREERUN, with possibility to
+                      numerically control frequency offset
+
+Notifications
+================
+
+DPLL device can provide notifications regarding status changes of the
+device, i.e. lock status changes, source/output type changes or alarms.
+This is the multicast group that is used to notify user-space apps via
+netlink socket:
+
+Notifications messages:
+
+  ========================= ==========================================
+  ``EVENT_DEVICE_CREATE``   event value new DPLL device was created
+    ``ID``                  attr dpll device index
+    ``NAME``                attr dpll device name
+  ``EVENT_DEVICE_DELETE``   event value DPLL device was deleted
+    ``ID``                  attr dpll device index
+  ``EVENT_DEVICE_CHANGE``   event value DPLL device attribute has changed
+    ``ID``                  attr dpll device index
+    ``CHANGE_TYPE``         attr the reason for change with values of
+                            ``enum dpll_event_change``
+
+Device change event reasons, values of ``CHANGE_TYPE`` attribute:
+
+  =========================== =========================================
+   ``CHANGE_MODE``            DPLL selection mode has changed
+   ``CHANGE_LOCK_STATUS``     DPLL lock status has changed
+   ``CHANGE_SOURCE_PIN``      DPLL source pin has changed
+   ``CHANGE_TEMP``            DPLL temperature has changed
+   ``CHANGE_PIN_ADD``         pin added to DPLL
+   ``CHANGE_PIN_DEL``         pin removed from DPLL
+   ``CHANGE_PIN_TYPE``        pin type has chaned
+   ``CHANGE_PIN_SIGNAL_TYPE`` pin signal type has changed
+   ``CHANGE_PIN_CUSTOM_FREQ`` pin custom frequency value has changed
+   ``CHANGE_PIN_STATE``       pin state has changed
+   ``CHANGE_PIN_PRIO``        pin prio has changed
+
+
+Device driver implementation
+============================
+
+For device to operate as DPLL subsystem device, it should implement
+set of operations and register device via ``dpll_device_alloc`` and
+``dpll_device_register`` provide the operations set, unique device
+cookie, type of dpll (PPS/EEC), and pointers to parent device and
+its private data for calling back the ops.
+
+The pins are allocated separately with ``dpll_pin_alloc``, which
+requires providing pin description and its length.
+
+Once DPLL device is created, allocated pin can be registered with it
+with 2 different methods, always providing implemented pin callbacks,
+and private data pointer for calling them:
+``dpll_pin_register`` - simple registration with a dpll device.
+``dpll_muxed_pin_register`` - register pin with another MUX type pin.
+
+It is also possible to register pin already registered with different
+DPLL device by calling ``dpll_shared_pin_register`` - in this case
+changes requested on a single pin would affect all DPLLs which were
+registered with that pin.
+
+For different instances of a device driver requiring to find already
+registered DPLL (i.e. to connect its pins to id)
+use ``dpll_device_get_by_cookie`` providing the same cookie, type of
+dpll and index of the DPLL device of such type, same as given on
+original device allocation.
+
+The name od DPLL device is generated based on registerer device struct
+pointer, DPLL type and an index received from registerer device driver.
+Name is in format: ``dpll-%s-%s-%s%d`` witch arguments:
+``dev_driver_string(parent)``        - syscall on parent device
+``dev_name(parent)``                 - syscall on parent device
+``type ? dpll_type_str(type) : ""``  - DPLL type converted to string
+``idx``                              - registerer given index
+
+Notifications of adding or removing DPLL devices are created within
+subsystem itself.
+Notifications about configurations changes are also invoked when
+requested change was successfully accepted by device driver with
+corresponding set command.
+Although the interface provides device drivers with
+``dpll_notify_device_change``, so notifications or alarms can be
+requested by device driver if needed, as different ways of confirmation
+could be used. All the interfaces for notification messages could be
+found in ``<linux/dpll.h>``, constants and enums are placed in
+``<uapi/linux/dpll.h>`` to be consistent with user-space.
+
+There is no strict requirement to implement all the operations for
+each device, every operation handler is checked for existence and
+ENOTSUPP is returned in case of absence of specific handler.
+
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 4f2d1f682a18..d50d98939942 100644
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

