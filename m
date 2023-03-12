Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF33E6B62E7
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 03:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjCLC2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 21:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCLC2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 21:28:47 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCFF32CF3;
        Sat, 11 Mar 2023 18:28:45 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32C1iTBj005195;
        Sat, 11 Mar 2023 18:28:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=40EG+05Ne4+wO9JHpvJkSlvSYxtLLL5N/Vyh2Tdm8SU=;
 b=KqHVZQFo9urhBksEeGwQOiZRAry8HAuLx/tESNOBrzYyWgnY3KzqYn3mdTIvAyVYboQY
 lQ19nnaQKSQb8ggPTiaySDxdBFXeus5kfkvjrPpbZst119Meuc66yCgjg9DwyI7M0QDJ
 /jCE0v1nnVNV4rEYesHYegIHG8DjBmhixEJcrn+EaDdRTL0GotHQPXNyQnT5Dkd1vBpY
 JCH9EAtVOcG6LOqrEcGXzVcktrLzgnA2GiNnfiMEIqz3XMoPMmztZwkPtxqOjkXHBuHe
 EHMtamBnUNQH3rZbEAR6oiBfjfpkMYoBhoqq4QiBs2MssJfto+/xyHE89vqz94KWVMyY AQ== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3p8nv0jjhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 11 Mar 2023 18:28:27 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Sat, 11 Mar 2023 18:28:26 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server id
 15.1.2507.17; Sat, 11 Mar 2023 18:28:24 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Vadim Fedorenko <vadfed@meta.com>, <poros@redhat.com>,
        <mschmidt@redhat.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-clk@vger.kernel.org>
Subject: [PATCH RFC v6 3/6] dpll: documentation on DPLL subsystem interface
Date:   Sat, 11 Mar 2023 18:28:04 -0800
Message-ID: <20230312022807.278528-4-vadfed@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230312022807.278528-1-vadfed@meta.com>
References: <20230312022807.278528-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::d]
X-Proofpoint-ORIG-GUID: CIhpIdyg_CL0rA2tEAY11SEF0nO36kHv
X-Proofpoint-GUID: CIhpIdyg_CL0rA2tEAY11SEF0nO36kHv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-11_04,2023-03-10_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation explaining common netlink interface to configure DPLL
devices and monitoring events. Common way to implement DPLL device in
a driver is also covered.

Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 Documentation/networking/dpll.rst  | 347 +++++++++++++++++++++++++++++
 Documentation/networking/index.rst |   1 +
 2 files changed, 348 insertions(+)
 create mode 100644 Documentation/networking/dpll.rst

diff --git a/Documentation/networking/dpll.rst b/Documentation/networking/dpll.rst
new file mode 100644
index 000000000000..25cd81edc73c
--- /dev/null
+++ b/Documentation/networking/dpll.rst
@@ -0,0 +1,347 @@
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
+Dpll object
+===========
+Single dpll device object means single Digital PLL circuit and bunch of
+pins connected with it.
+It provides its capablities and current status to the user in response
+to the `do` request of netlink command ``DPLL_CMD_DEVICE_GET`` and list
+of dplls registered in the subsystem with `dump` netlink request of same
+command.
+Requesting configuration of dpll device is done with `do` request of
+netlink ``DPLL_CMD_DEVICE_SET`` command.
+
+
+Pin object
+==========
+A pin is amorphic object which represents either input or output, it
+could be internal component of the device, as well as externaly
+connected.
+The number of pins per dpll vary, but usually multiple pins shall be
+provided for a single dpll device.
+Pin's properities and capabilities are provided to the user in response
+to `do` request of netlink ``DPLL_CMD_PIN_GET`` command.
+It is also possible to list all the pins that were registered either
+with dpll or different pin with `dump` request of ``DPLL_CMD_PIN_GET``
+command.
+Configuration of a pin can be changed by `do` request of netlink
+``DPLL_CMD_PIN_SET`` command.
+
+
+Shared pins
+===========
+Pin can be shared by multiple dpll devices. Where configuration on one
+pin can alter multiple dplls (i.e. PIN_FREQUENCY, PIN_DIRECTION),
+or configure just one pin-dpll pair (i.e. PIN_PRIO, PIN_STATE).
+
+
+MUX-type pins
+=============
+A pin can be MUX-type, which aggregates child pins and serves as pin
+multiplexer. One or more pins are attached to MUX-type instead of being
+directly connected to a dpll device.
+Pins registered with a MUX-type provides user with additional nested
+attribute ``DPLL_A_PIN_PARENT`` for each parrent they were registered
+with.
+Only one child pin can provide it's signal to the parent MUX-type pin at
+a time, the selection is done with requesting change of child pin state
+to ``DPLL_PIN_STATE_CONNECTED`` and providing a target MUX-type pin
+index value in ``DPLL_A_PARENT_PIN_IDX``
+
+
+Pin priority
+============
+Some devices might offer a capability of automatic pin selection mode.
+Usually such automatic selection is offloaded to the hardware,
+which means only pins directly connected to the dpll are capable of
+automatic source pin selection.
+In automatic selection mode, the user cannot manually select a source
+pin for the device, instead the user shall provide all directly
+connected pins with a priority ``DPLL_A_PIN_PRIO``, the device would
+pick a highest priority valid signal and connect with it.
+Child pin of MUX-type are not capable of automatic source pin selection,
+in order to configure a source of a MUX-type pin the user still needs
+to request desired pin state.
+
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
+All netlink commands require ``GENL_ADMIN_PERM``. This is to prevent
+any spamming/D.o.S. from unauthorized userspace applications.
+
+List of command with possible attributes
+========================================
+
+All constants identifying command types use ``DPLL_CMD_`` prefix and
+suffix according to command purpose. All attributes use ``DPLL_A_``
+prefix and suffix according to attribute purpose:
+
+  ============================  =======================================
+  ``DEVICE_GET``                command to get device info or dump list
+                                of available devices
+    ``ID``                      attr internal dpll device ID
+    ``DEV_NAME``                attr dpll device name
+    ``BUS_NAME``                attr dpll device bus name
+    ``MODE``                    attr selection mode
+    ``MODE_SUPPORTED``          attr available selection modes
+    ``SOURCE_PIN_IDX``          attr index of currently selected source
+    ``LOCK_STATUS``             attr internal frequency-lock status
+    ``TEMP``                    attr device temperature information
+    ``CLOCK_ID``                attr Unique Clock Identifier (EUI-64),
+                                as defined by the IEEE 1588 standard
+    ``TYPE``                    attr type or purpose of dpll device
+  ``DEVICE_SET``                command to set dpll device configuration
+    ``ID``                      attr internal dpll device index
+    ``NAME``                    attr dpll device name (not required if
+                                dpll device index was provided)
+    ``MODE``                    attr selection mode to configure
+  ``PIN_GET``                   command to get pin info or dump list of
+                                available pins
+    ``DEVICE``                  nest attr for each dpll device pin is
+                                connected with
+      ``ID``                    attr internal dpll device ID
+      ``DEV_NAME``              attr dpll device name
+      ``BUS_NAME``              attr dpll device bus name
+      ``PIN_PRIO``              attr priority of pin on the dpll device
+      ``PIN_STATE``             attr state of pin on the dpll device
+    ``PIN_IDX``                 attr index of a pin on the dpll device
+    ``PIN_DESCRIPTION``         attr description provided by driver
+    ``PIN_TYPE``                attr type of a pin
+    ``PIN_DIRECTION``           attr direction of a pin
+    ``PIN_FREQUENCY``           attr current frequency of a pin
+    ``PIN_FREQUENCY_SUPPORTED`` attr provides supported frequencies
+    ``PIN_ANY_FREQUENCY_MIN``   attr minimum value of frequency in case
+                                pin/dpll supports any frequency
+    ``PIN_ANY_FREQUENCY_MAX``   attr maximum value of frequency in case
+                                pin/dpll supports any frequency
+    ``PIN_PARENT``              nest attr for each MUX-type parent, that
+                                pin is connected with
+      ``PIN_PARENT_IDX``        attr index of a parent pin on the dpll
+                                device
+      ``PIN_STATE``             attr state of a pin on parent pin
+    ``PIN_RCLK_DEVICE``         attr name of a device, where pin
+                                recovers clock signal from
+    ``PIN_DPLL_CAPS``           attr bitmask of pin-dpll capabilities
+
+  ``PIN_SET``                   command to set pins configuration
+    ``ID``                      attr internal dpll device index
+    ``BUS_NAME``                attr dpll device name (not required if
+                                dpll device ID was provided)
+    ``DEV_NAME``                attr dpll device name (not required if
+                                dpll device ID was provided)
+    ``PIN_IDX``                 attr index of a pin on the dpll device
+    ``PIN_DIRECTION``           attr direction to be set
+    ``PIN_FREQUENCY``           attr frequency to be set
+    ``PIN_PRIO``                attr pin priority to be set
+    ``PIN_STATE``               attr pin state to be set
+    ``PIN_PRIO``                attr pin priority to be set
+    ``PIN_PARENT_IDX``          attr if provided state is to be set with
+                                parent pin instead of with dpll device
+
+Netlink dump requests
+=====================
+
+The ``DEVICE_GET`` and ``PIN_GET`` commands are capable of dump type
+netlink requests. Possible response message attributes for netlink dump
+requests:
+
+  ==============================  =======================================
+  ``PIN_GET``                     command to dump pins
+    ``PIN``                       attr nested type contains single pin
+      ``DEVICE``                  nest attr for each dpll device pin is
+                                  connected with
+        ``ID``                    attr internal dpll device ID
+        ``DEV_NAME``              attr dpll device name
+        ``BUS_NAME``              attr dpll device bus name
+      ``PIN_IDX``                 attr index of dumped pin (on dplls)
+      ``PIN_DESCRIPTION``         description of a pin provided by driver
+      ``PIN_TYPE``                attr value of pin type
+      ``PIN_FREQUENCY``           attr current frequency of a pin
+      ``PIN_FREQUENCY_SUPPORTED`` attr provides supported frequencies
+      ``PIN_RCLK_DEVICE``         attr name of a device, where pin
+                                  recovers clock signal from
+      ``PIN_DIRECTION``           attr direction of a pin
+      ``PIN_PARENT``              nest attr for each MUX-type parent,
+                                  that pin is connected with
+        ``PIN_PARENT_IDX``        attr index of a parent pin on the dpll
+                                  device
+        ``PIN_STATE``             attr state of a pin on parent pin
+
+  ``DEVICE_GET``                  command to dump dplls
+    ``DEVICE``                    attr nested type contatin a single
+                                  dpll device
+      ``ID``                      attr internal dpll device ID
+      ``DEV_NAME``                attr dpll device name
+      ``BUS_NAME``                attr dpll device bus name
+
+
+Dpll device level configuration pre-defined enums
+=================================================
+
+For all below enum names used for configuration of dpll device use
+the ``DPLL_`` prefix.
+
+Values for ``DPLL_A_LOCK_STATUS`` attribute:
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
+Values for ``DPLL_A_MODE`` attribute:
+
+  =================== ================================================
+  ``MODE_FORCED``     source pin is force-selected by setting pin
+                      state to ``DPLL_PIN_STATE_CONNECTED`` on a dpll
+  ``MODE_AUTOMATIC``  source pin is auto selected according to
+                      configured pin priorities and source signal
+                      validity
+  ``MODE_HOLDOVER``   force holdover mode of DPLL
+  ``MODE_FREERUN``    DPLL is driven by supplied system clock without
+                      holdover capabilities
+  ``MODE_NCO``        similar to FREERUN, with possibility to
+                      numerically control frequency offset
+
+Values for ``DPLL_A_TYPE`` attribute:
+
+  ============= ================================================
+  ``TYPE_PPS``  DPLL used to provide pulse-per-second output
+  ``TYPE_EEC``  DPLL used to drive ethernet equipment clock
+
+
+
+Pin level configuration pre-defined enums
+=========================================
+
+For all below enum names used for configuration of pin use the
+``DPLL_PIN`` prefix.
+
+Values for ``DPLL_A_PIN_STATE`` attribute:
+
+  ======================= ========================================
+  ``STATE_CONNECTED``     Pin connected to a dpll or parent pin
+  ``STATE_DISCONNECTED``  Pin disconnected from dpll or parent pin
+
+Values for ``DPLL_A_PIN_DIRECTION`` attribute:
+
+  ======================= ==============================
+  ``DIRECTION_SOURCE``    Pin used as a source of signal
+  ``DIRECTION_OUTPUT``    Pin used to output signal
+
+Values for ``DPLL_A_PIN_TYPE`` attributes:
+
+  ======================== ========================================
+  ``TYPE_MUX``             MUX type pin, connected pins shall have
+                           their own types
+  ``TYPE_EXT``             External pin
+  ``TYPE_SYNCE_ETH_PORT``  SyncE on Ethernet port
+  ``TYPE_INT_OSCILLATOR``  Internal Oscillator (i.e. Holdover with
+                           Atomic Clock as a Source)
+  ``TYPE_GNSS``            GNSS 1PPS source
+
+Values for ``DPLL_A_PIN_DPLL_CAPS`` attributes:
+
+  ============================= ================================
+  ``CAPS_DIRECTION_CAN_CHANGE`` Bit present if direction can change
+  ``CAPS_PRIORITY_CAN_CHANGE``  Bit present if priority can change
+  ``CAPS_STATE_CAN_CHANGE``     Bit present if state can change
+
+
+Notifications
+=============
+
+DPLL device can provide notifications regarding status changes of the
+device, i.e. lock status changes, source/output type changes or alarms.
+This is the multicast group that is used to notify user-space apps via
+netlink socket: ``DPLL_MCGRP_MONITOR``
+
+Notifications messages (attrbiutes use ``DPLL_A`` prefix):
+
+  ========================= ==========================================
+  ``EVENT_DEVICE_CREATE``   event value new DPLL device was created
+    ``ID``                  attr internal dpll device ID
+    ``DEV_NAME``            attr dpll device name
+    ``BUS_NAME``            attr dpll device bus name
+  ``EVENT_DEVICE_DELETE``   event value DPLL device was deleted
+    ``ID``                  attr dpll device index
+  ``EVENT_DEVICE_CHANGE``   event value DPLL device attribute has
+                            changed
+    ``ID``                  attr modified dpll device ID
+    ``PIN_IDX``             attr the modified pin index
+
+Device change event shall consiste of the attribute and the value that
+has changed.
+
+
+Device driver implementation
+============================
+
+Device is allocated by ``dpll_device_get`` call. Second call with the
+same arguments doesn't create new object but provides pointer to
+previously created device for given arguments, it also increase refcount
+of that object.
+Device is deallocated by ``dpll_device_put`` call, which first decreases
+the refcount, once refcount is cleared the object is destroyed.
+
+Device should implement set of operations and register device via
+``dpll_device_register`` at which point it becomes available to the
+users. Only one driver can register a dpll device within dpll subsytem.
+Multiple driver instances can obtain reference to it with
+``dpll_device_get``.
+
+The pins are allocated separately with ``dpll_pin_get``, it works
+similarly to ``dpll_device_get``. Creates object and the for each call
+with the same arguments the object refcount increases.
+
+Once DPLL device is created, allocated pin can be registered with it
+with 2 different methods, always providing implemented pin callbacks,
+and private data pointer for calling them:
+``dpll_pin_register`` - simple registration with a dpll device.
+``dpll_pin_on_pin_register`` - register pin with another MUX type pin.
+
+For different instances of a device driver requiring to find already
+registered DPLL (i.e. to connect its pins to id) use ``dpll_device_get``
+to obtain proper dpll device pointer.
+
+The name od DPLL device is generated based on registerer provided device
+struct pointer and dev_driver_id value.
+Name is in format: ``%s_%u`` witch arguments:
+``dev_name(struct device *)`` - syscall on parent device struct
+``dev_driver_idx``            - registerer given id
+
+Notifications of adding or removing DPLL devices are created within
+subsystem itself.
+Notifications about registering/deregistering pins are also invoked by
+the subsystem.
+Notifications about dpll status changes shall be requested by device
+driver with ``dpll_device_notify`` corresponding attribute as a reason.
+
+There is no strict requirement to implement all the operations for
+each device, every operation handler is checked for existence and
+ENOTSUPP is returned in case of absence of specific handler.
+
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 4ddcae33c336..6eb83a47cc2d 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -17,6 +17,7 @@ Contents:
    dsa/index
    devlink/index
    caif/index
+   dpll
    ethtool-netlink
    ieee802154
    j1939
-- 
2.34.1

