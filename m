Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B798322BAF6
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 02:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgGXAW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 20:22:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:23101 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728251AbgGXAWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 20:22:24 -0400
IronPort-SDR: 8T42RWEpMH/XugxYhw6fi2oIPPEw2JBKmHir+0GJChBHjwwT98u8fLwB72eYa+kRX9ggauEzEG
 JL4MbINZShEQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="215232503"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="215232503"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 17:22:19 -0700
IronPort-SDR: /OjBpKEnflx+K+Jp9bI0mtNEcZ4lRbRuPJg4jK4oeY9+8f3EBTiXnT78mCbqXjHvtUMEgfMFgj
 bAc4EubpcPfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="272441983"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga008.fm.intel.com with ESMTP; 23 Jul 2020 17:22:18 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Tom Herbert <tom@herbertland.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v1 1/5] Add pldmfw library for PLDM firmware update
Date:   Thu, 23 Jul 2020 17:21:59 -0700
Message-Id: <20200724002203.451621-2-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.rc1.139.gd6b33fda9dd1
In-Reply-To: <20200724002203.451621-1-jacob.e.keller@intel.com>
References: <20200724002203.451621-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pldmfw library is used to implement common logic needed to flash
devices based on firmware files using the format described by the PLDM
for Firmware Update standard.

This library consists of logic to parse the PLDM file format from
a firmware file object, as well as common logic for sending the relevant
PLDM header data to the device firmware.

A simple ops table is provided so that device drivers can implement
device specific hardware interactions while keeping the common logic to
the pldmfw library.

This library will be used by the Intel ice networking driver as part of
implementing device flash update via devlink. The library aims to be
vendor and device agnostic. For this reason, it has been placed in
lib/pldmfw, in the hopes that other devices which use the PLDM firmware
file format may benefit from it in the future. However, do note that not
all features defined in the PLDM standard have been implemented.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/driver-api/index.rst            |   1 +
 .../driver-api/pldmfw/driver-ops.rst          |  56 ++
 .../driver-api/pldmfw/file-format.rst         | 203 ++++
 Documentation/driver-api/pldmfw/index.rst     |  72 ++
 MAINTAINERS                                   |   7 +
 include/linux/pldmfw.h                        | 165 ++++
 lib/Kconfig                                   |   4 +
 lib/Makefile                                  |   3 +
 lib/pldmfw/Makefile                           |   2 +
 lib/pldmfw/pldmfw.c                           | 879 ++++++++++++++++++
 lib/pldmfw/pldmfw_private.h                   | 238 +++++
 11 files changed, 1630 insertions(+)
 create mode 100644 Documentation/driver-api/pldmfw/driver-ops.rst
 create mode 100644 Documentation/driver-api/pldmfw/file-format.rst
 create mode 100644 Documentation/driver-api/pldmfw/index.rst
 create mode 100644 include/linux/pldmfw.h
 create mode 100644 lib/pldmfw/Makefile
 create mode 100644 lib/pldmfw/pldmfw.c
 create mode 100644 lib/pldmfw/pldmfw_private.h

diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index 6567187e7687..7fc1e0cccae7 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -95,6 +95,7 @@ available subsections can be seen below.
    phy/index
    pti_intel_mid
    pwm
+   pldmfw/index
    rfkill
    serial/index
    sm501
diff --git a/Documentation/driver-api/pldmfw/driver-ops.rst b/Documentation/driver-api/pldmfw/driver-ops.rst
new file mode 100644
index 000000000000..f0654783d3b3
--- /dev/null
+++ b/Documentation/driver-api/pldmfw/driver-ops.rst
@@ -0,0 +1,56 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+=========================
+Driver-specific callbacks
+=========================
+
+The ``pldmfw`` module relies on the device driver for implementing device
+specific behavior using the following operations.
+
+``.match_record``
+-----------------
+
+The ``.match_record`` operation is used to determine whether a given PLDM
+record matches the device being updated. This requires comparing the record
+descriptors in the record with information from the device. Many record
+descriptors are defined by the PLDM standard, but it is also allowed for
+devices to implement their own descriptors.
+
+The ``.match_record`` operation should return true if a given record matches
+the device.
+
+``.send_package_data``
+----------------------
+
+The ``.send_package_data`` operation is used to send the device-specific
+package data in a record to the device firmware. If the matching record
+provides package data, ``pldmfw`` will call the ``.send_package_data``
+function with a pointer to the package data and with the package data
+length. The device driver should send this data to firmware.
+
+``.send_component_table``
+-------------------------
+
+The ``.send_component_table`` operation is used to forward component
+information to the device. It is called once for each applicable component,
+that is, for each component indicated by the matching record. The
+device driver should send the component information to the device firmware,
+and wait for a response. The provided transfer flag indicates whether this
+is the first, last, or a middle component, and is expected to be forwarded
+to firmware as part of the component table information. The driver should an
+error in the case when the firmware indicates that the component cannot be
+updated, or return zero if the component can be updated.
+
+``.flash_component``
+--------------------
+
+The ``.flash_component`` operation is used to inform the device driver to
+flash a given component. The driver must perform any steps necessary to send
+the component data to the device.
+
+``.finalize_update``
+--------------------
+
+The ``.finalize_update`` operation is used by the ``pldmfw`` library in
+order to allow the device driver to perform any remaining device specific
+logic needed to finish the update.
diff --git a/Documentation/driver-api/pldmfw/file-format.rst b/Documentation/driver-api/pldmfw/file-format.rst
new file mode 100644
index 000000000000..b7a9cebe09c6
--- /dev/null
+++ b/Documentation/driver-api/pldmfw/file-format.rst
@@ -0,0 +1,203 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+==================================
+PLDM Firmware file format overview
+==================================
+
+A PLDM firmware package is a binary file which contains a header that
+describes the contents of the firmware package. This includes an initial
+package header, one or more firmware records, and one or more components
+describing the actual flash contents to program.
+
+This diagram provides an overview of the file format::
+
+        overall file layout
+      +----------------------+
+      |                      |
+      |  Package Header      |
+      |                      |
+      +----------------------+
+      |                      |
+      |  Device Records      |
+      |                      |
+      +----------------------+
+      |                      |
+      |  Component Info      |
+      |                      |
+      +----------------------+
+      |                      |
+      |  Package Header CRC  |
+      |                      |
+      +----------------------+
+      |                      |
+      |  Component Image 1   |
+      |                      |
+      +----------------------+
+      |                      |
+      |  Component Image 2   |
+      |                      |
+      +----------------------+
+      |                      |
+      |         ...          |
+      |                      |
+      +----------------------+
+      |                      |
+      |  Component Image N   |
+      |                      |
+      +----------------------+
+
+Package Header
+==============
+
+The package header begins with the UUID of the PLDM file format, and
+contains information about the version of the format that the file uses. It
+also includes the total header size, a release date, the size of the
+component bitmap, and an overall package version.
+
+The following diagram provides an overview of the package header::
+
+             header layout
+      +-------------------------+
+      | PLDM UUID               |
+      +-------------------------+
+      | Format Revision         |
+      +-------------------------+
+      | Header Size             |
+      +-------------------------+
+      | Release Date            |
+      +-------------------------+
+      | Component Bitmap Length |
+      +-------------------------+
+      | Package Version Info    |
+      +-------------------------+
+
+Device Records
+==============
+
+The device firmware records area starts with a count indicating the total
+number of records in the file, followed by each record. A single device
+record describes what device matches this record. All valid PLDM firmware
+files must contain at least one record, but optionally may contain more than
+one record if they support multiple devices.
+
+Each record will identify the device it supports via TLVs that describe the
+device, such as the PCI device and vendor information. It will also indicate
+which set of components that are used by this device. It is possible that
+only subset of provided components will be used by a given record. A record
+may also optionally contain device-specific package data that will be used
+by the device firmware during the update process.
+
+The following diagram provides an overview of the device record area::
+
+         area layout
+      +---------------+
+      |               |
+      |  Record Count |
+      |               |
+      +---------------+
+      |               |
+      |  Record 1     |
+      |               |
+      +---------------+
+      |               |
+      |  Record 2     |
+      |               |
+      +---------------+
+      |               |
+      |      ...      |
+      |               |
+      +---------------+
+      |               |
+      |  Record N     |
+      |               |
+      +---------------+
+
+           record layout
+      +-----------------------+
+      | Record Length         |
+      +-----------------------+
+      | Descriptor Count      |
+      +-----------------------+
+      | Option Flags          |
+      +-----------------------+
+      | Version Settings      |
+      +-----------------------+
+      | Package Data Length   |
+      +-----------------------+
+      | Applicable Components |
+      +-----------------------+
+      | Version String        |
+      +-----------------------+
+      | Descriptor TLVs       |
+      +-----------------------+
+      | Package Data          |
+      +-----------------------+
+
+Component Info
+==============
+
+The component information area begins with a count of the number of
+components. Following this count is a description for each component. The
+component information points to the location in the file where the component
+data is stored, and includes version data used to identify the version of
+the component.
+
+The following diagram provides an overview of the component area::
+
+         area layout
+      +-----------------+
+      |                 |
+      | Component Count |
+      |                 |
+      +-----------------+
+      |                 |
+      | Component 1     |
+      |                 |
+      +-----------------+
+      |                 |
+      | Component 2     |
+      |                 |
+      +-----------------+
+      |                 |
+      |     ...         |
+      |                 |
+      +-----------------+
+      |                 |
+      | Component N     |
+      |                 |
+      +-----------------+
+
+           component layout
+      +------------------------+
+      | Classification         |
+      +------------------------+
+      | Component Identifier   |
+      +------------------------+
+      | Comparison Stamp       |
+      +------------------------+
+      | Component Options      |
+      +------------------------+
+      | Activation Method      |
+      +------------------------+
+      | Location Offset        |
+      +------------------------+
+      | Component Size         |
+      +------------------------+
+      | Component Version Info |
+      +------------------------+
+      | Package Data           |
+      +------------------------+
+
+
+Package Header CRC
+==================
+
+Following the component information is a short 4-byte CRC calculated over
+the contents of all of the header information.
+
+Component Images
+================
+
+The component images follow the package header information in the PLDM
+firmware file. Each of these is simply a binary chunk with its start and
+size defined by the matching component structure in the component info area.
diff --git a/Documentation/driver-api/pldmfw/index.rst b/Documentation/driver-api/pldmfw/index.rst
new file mode 100644
index 000000000000..ad2c33ece30f
--- /dev/null
+++ b/Documentation/driver-api/pldmfw/index.rst
@@ -0,0 +1,72 @@
+.. SPDX-License-Identifier: GPL-2.0-only
+
+==================================
+PLDM Firmware Flash Update Library
+==================================
+
+``pldmfw`` implements functionality for updating the flash on a device using
+the PLDM for Firmware Update standard
+<https://www.dmtf.org/documents/pmci/pldm-firmware-update-specification-100>.
+
+.. toctree::
+   :maxdepth: 1
+
+   file-format
+   driver-ops
+
+==================================
+Overview of the ``pldmfw`` library
+==================================
+
+The ``pldmfw`` library is intended to be used by device drivers for
+implementing device flash update based on firmware files following the PLDM
+firwmare file format.
+
+It is implemented using an ops table that allows device drivers to provide
+the underlying device specific functionality.
+
+``pldmfw`` implements logic to parse the packed binary format of the PLDM
+firmware file into data structures, and then uses the provided function
+operations to determine if the firmware file is a match for the device. If
+so, it sends the record and component data to the firmware using the device
+specific implementations provided by device drivers. Once the device
+firmware indicates that the update may be performed, the firmware data is
+sent to the device for programming.
+
+Parsing the PLDM file
+=====================
+
+The PLDM file format uses packed binary data, with most multi-byte fields
+stored in the Little Endian format. Several pieces of data are variable
+length, including version strings and the number of records and components.
+Due to this, it is not straight forward to index the record, record
+descriptors, or components.
+
+To avoid proliferating access to the packed binary data, the ``pldmfw``
+library parses and extracts this data into simpler structures for ease of
+access.
+
+In order to safely process the firmware file, care is taken to avoid
+unaligned access of multi-byte fields, and to properly convert from Little
+Endian to CPU host format. Additionally the records, descriptors, and
+components are stored in linked lists.
+
+Performing a flash update
+=========================
+
+To perform a flash update, the ``pldmfw`` module performs the following
+steps
+
+1. Parse the firmware file for record and component information
+2. Scan through the records and determine if the device matches any record
+   in the file. The first matched record will be used.
+3. If the matching record provides package data, send this package data to
+   the device.
+4. For each component that the record indicates, send the component data to
+   the device. For each component, the firmware may respond with an
+   indication of whether the update is suitable or not. If any component is
+   not suitable, the update is canceled.
+5. For each component, send the binary data to the device firmware for
+   updating.
+6. After all components are programmed, perform any final device-specific
+   actions to finalize the update.
diff --git a/MAINTAINERS b/MAINTAINERS
index 6200eb14757c..c3639e4781e3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13593,6 +13593,13 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/iio/chemical/plantower,pms7003.yaml
 F:	drivers/iio/chemical/pms7003.c
 
+PLDMFW LIBRARY
+M:	Jacob Keller <jacob.e.keller@intel.com>
+S:	Maintained
+F:	Documentation/driver-api/pldmfw/
+F:	include/linux/pldmfw.h
+F:	lib/pldmfw/
+
 PLX DMA DRIVER
 M:	Logan Gunthorpe <logang@deltatee.com>
 S:	Maintained
diff --git a/include/linux/pldmfw.h b/include/linux/pldmfw.h
new file mode 100644
index 000000000000..0fc831338226
--- /dev/null
+++ b/include/linux/pldmfw.h
@@ -0,0 +1,165 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2018-2019, Intel Corporation. */
+
+#ifndef _PLDMFW_H_
+#define _PLDMFW_H_
+
+#include <linux/list.h>
+#include <linux/firmware.h>
+
+#define PLDM_DEVICE_UPDATE_CONTINUE_AFTER_FAIL BIT(0)
+
+#define PLDM_STRING_TYPE_UNKNOWN	0
+#define PLDM_STRING_TYPE_ASCII		1
+#define PLDM_STRING_TYPE_UTF8		2
+#define PLDM_STRING_TYPE_UTF16		3
+#define PLDM_STRING_TYPE_UTF16LE	4
+#define PLDM_STRING_TYPE_UTF16BE	5
+
+struct pldmfw_record {
+	struct list_head entry;
+
+	/* List of descriptor TLVs */
+	struct list_head descs;
+
+	/* Component Set version string*/
+	const u8 *version_string;
+	u8 version_type;
+	u8 version_len;
+
+	/* Package Data length */
+	u16 package_data_len;
+
+	/* Bitfield of Device Update Flags */
+	u32 device_update_flags;
+
+	/* Package Data block */
+	const u8 *package_data;
+
+	/* Bitmap of components applicable to this record */
+	unsigned long *component_bitmap;
+	u16 component_bitmap_len;
+};
+
+/* Standard descriptor TLV identifiers */
+#define PLDM_DESC_ID_PCI_VENDOR_ID	0x0000
+#define PLDM_DESC_ID_IANA_ENTERPRISE_ID	0x0001
+#define PLDM_DESC_ID_UUID		0x0002
+#define PLDM_DESC_ID_PNP_VENDOR_ID	0x0003
+#define PLDM_DESC_ID_ACPI_VENDOR_ID	0x0004
+#define PLDM_DESC_ID_PCI_DEVICE_ID	0x0100
+#define PLDM_DESC_ID_PCI_SUBVENDOR_ID	0x0101
+#define PLDM_DESC_ID_PCI_SUBDEV_ID	0x0102
+#define PLDM_DESC_ID_PCI_REVISION_ID	0x0103
+#define PLDM_DESC_ID_PNP_PRODUCT_ID	0x0104
+#define PLDM_DESC_ID_ACPI_PRODUCT_ID	0x0105
+#define PLDM_DESC_ID_VENDOR_DEFINED	0xFFFF
+
+struct pldmfw_desc_tlv {
+	struct list_head entry;
+
+	const u8 *data;
+	u16 type;
+	u16 size;
+};
+
+#define PLDM_CLASSIFICATION_UNKNOWN		0x0000
+#define PLDM_CLASSIFICATION_OTHER		0x0001
+#define PLDM_CLASSIFICATION_DRIVER		0x0002
+#define PLDM_CLASSIFICATION_CONFIG_SW		0x0003
+#define PLDM_CLASSIFICATION_APP_SW		0x0004
+#define PLDM_CLASSIFICATION_INSTRUMENTATION	0x0005
+#define PLDM_CLASSIFICATION_BIOS		0x0006
+#define PLDM_CLASSIFICATION_DIAGNOSTIC_SW	0x0007
+#define PLDM_CLASSIFICATION_OS			0x0008
+#define PLDM_CLASSIFICATION_MIDDLEWARE		0x0009
+#define PLDM_CLASSIFICATION_FIRMWARE		0x000A
+#define PLDM_CLASSIFICATION_CODE		0x000B
+#define PLDM_CLASSIFICATION_SERVICE_PACK	0x000C
+#define PLDM_CLASSIFICATION_SOFTWARE_BUNDLE	0x000D
+
+#define PLDM_ACTIVATION_METHOD_AUTO		BIT(0)
+#define PLDM_ACTIVATION_METHOD_SELF_CONTAINED	BIT(1)
+#define PLDM_ACTIVATION_METHOD_MEDIUM_SPECIFIC	BIT(2)
+#define PLDM_ACTIVATION_METHOD_REBOOT		BIT(3)
+#define PLDM_ACTIVATION_METHOD_DC_CYCLE		BIT(4)
+#define PLDM_ACTIVATION_METHOD_AC_CYCLE		BIT(5)
+
+#define PLDMFW_COMPONENT_OPTION_FORCE_UPDATE		BIT(0)
+#define PLDMFW_COMPONENT_OPTION_USE_COMPARISON_STAMP	BIT(1)
+
+struct pldmfw_component {
+	struct list_head entry;
+
+	/* component identifier */
+	u16 classification;
+	u16 identifier;
+
+	u16 options;
+	u16 activation_method;
+
+	u32 comparison_stamp;
+
+	u32 component_size;
+	const u8 *component_data;
+
+	/* Component version string */
+	const u8 *version_string;
+	u8 version_type;
+	u8 version_len;
+
+	/* component index */
+	u8 index;
+
+};
+
+/* Transfer flag used for sending components to the firmware */
+#define PLDM_TRANSFER_FLAG_START		BIT(0)
+#define PLDM_TRANSFER_FLAG_MIDDLE		BIT(1)
+#define PLDM_TRANSFER_FLAG_END			BIT(2)
+
+struct pldmfw_ops;
+
+/* Main entry point to the PLDM firmware update engine. Device drivers
+ * should embed this in a private structure and use container_of to obtain
+ * a pointer to their own data, used to implement the device specific
+ * operations.
+ */
+struct pldmfw {
+	const struct pldmfw_ops *ops;
+	struct device *dev;
+};
+
+bool pldmfw_op_pci_match_record(struct pldmfw *context, struct pldmfw_record *record);
+
+/* Operations invoked by the generic PLDM firmware update engine. Used to
+ * implement device specific logic.
+ *
+ * @match_record: check if the device matches the given record. For
+ * convenience, a standard implementation is provided for PCI devices.
+ *
+ * @send_package_data: send the package data associated with the matching
+ * record to firmware.
+ *
+ * @send_component_table: send the component data associated with a given
+ * component to firmware. Called once for each applicable component.
+ *
+ * @flash_component: Flash the data for a given component to the device.
+ * Called once for each applicable component, after all component tables have
+ * been sent.
+ *
+ * @finalize_update: (optional) Finish the update. Called after all components
+ * have been flashed.
+ */
+struct pldmfw_ops {
+	bool (*match_record)(struct pldmfw *context, struct pldmfw_record *record);
+	int (*send_package_data)(struct pldmfw *context, const u8 *data, u16 length);
+	int (*send_component_table)(struct pldmfw *context, struct pldmfw_component *component,
+				    u8 transfer_flag);
+	int (*flash_component)(struct pldmfw *context, struct pldmfw_component *component);
+	int (*finalize_update)(struct pldmfw *context);
+};
+
+int pldmfw_flash_image(struct pldmfw *context, const struct firmware *fw);
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index df3f3da95990..3ffbca6998e5 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -676,3 +676,7 @@ config GENERIC_LIB_CMPDI2
 
 config GENERIC_LIB_UCMPDI2
 	bool
+
+config PLDMFW
+	bool
+	default n
diff --git a/lib/Makefile b/lib/Makefile
index b1c42c10073b..281888ff713b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -315,6 +315,9 @@ obj-$(CONFIG_GENERIC_LIB_CMPDI2) += cmpdi2.o
 obj-$(CONFIG_GENERIC_LIB_UCMPDI2) += ucmpdi2.o
 obj-$(CONFIG_OBJAGG) += objagg.o
 
+# pldmfw library
+obj-$(CONFIG_PLDMFW) += pldmfw/
+
 # KUnit tests
 obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
diff --git a/lib/pldmfw/Makefile b/lib/pldmfw/Makefile
new file mode 100644
index 000000000000..99ad10711abe
--- /dev/null
+++ b/lib/pldmfw/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_PLDMFW)	+= pldmfw.o
diff --git a/lib/pldmfw/pldmfw.c b/lib/pldmfw/pldmfw.c
new file mode 100644
index 000000000000..e5d4b3b2af81
--- /dev/null
+++ b/lib/pldmfw/pldmfw.c
@@ -0,0 +1,879 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2018-2019, Intel Corporation. */
+
+#include <asm/unaligned.h>
+#include <linux/crc32.h>
+#include <linux/device.h>
+#include <linux/firmware.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/pldmfw.h>
+#include <linux/slab.h>
+#include <linux/uuid.h>
+
+#include "pldmfw_private.h"
+
+/* Internal structure used to store details about the PLDM image file as it is
+ * being validated and processed.
+ */
+struct pldmfw_priv {
+	struct pldmfw *context;
+	const struct firmware *fw;
+
+	/* current offset of firmware image */
+	size_t offset;
+
+	struct list_head records;
+	struct list_head components;
+
+	/* PLDM Firmware Package Header */
+	const struct __pldm_header *header;
+	u16 total_header_size;
+
+	/* length of the component bitmap */
+	u16 component_bitmap_len;
+	u16 bitmap_size;
+
+	/* Start of the component image information */
+	u16 component_count;
+	const u8 *component_start;
+
+	/* Start pf the firmware device id records */
+	const u8 *record_start;
+	u8 record_count;
+
+	/* The CRC at the end of the package header */
+	u32 header_crc;
+
+	struct pldmfw_record *matching_record;
+};
+
+/**
+ * pldm_check_fw_space - Verify that the firmware image has space left
+ * @data: pointer to private data
+ * @offset: offset to start from
+ * @length: length to check for
+ *
+ * Verify that the firmware data can hold a chunk of bytes with the specified
+ * offset and length.
+ *
+ * Returns: zero on success, or -EFAULT if the image does not have enough
+ * space left to fit the expected length.
+ */
+static int
+pldm_check_fw_space(struct pldmfw_priv *data, size_t offset, size_t length)
+{
+	size_t expected_size = offset + length;
+	struct device *dev = data->context->dev;
+
+	if (data->fw->size < expected_size) {
+		dev_dbg(dev, "Firmware file size smaller than expected. Got %zu bytes, needed %zu bytes\n",
+			data->fw->size, expected_size);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+/**
+ * pldm_move_fw_offset - Move the current firmware offset forward
+ * @data: pointer to private data
+ * @bytes_to_move: number of bytes to move the offset forward by
+ *
+ * Check that there is enough space past the current offset, and then move the
+ * offset forward by this ammount.
+ *
+ * Returns: zero on success, or -EFAULT if the image is too small to fit the
+ * expected length.
+ */
+static int
+pldm_move_fw_offset(struct pldmfw_priv *data, size_t bytes_to_move)
+{
+	int err;
+
+	err = pldm_check_fw_space(data, data->offset, bytes_to_move);
+	if (err)
+		return err;
+
+	data->offset += bytes_to_move;
+
+	return 0;
+}
+
+/**
+ * pldm_parse_header - Validate and extract details about the PLDM header
+ * @data: pointer to private data
+ *
+ * Performs initial basic verification of the PLDM image, up to the first
+ * firmware record.
+ *
+ * This includes the following checks and extractions
+ *
+ *   * Verify that the UUID at the start of the header matches the expected
+ *     value as defined in the DSP0267 PLDM specification
+ *   * Check that the revision is 0x01
+ *   * Extract the total header_size and verify that the image is large enough
+ *     to contain at least the length of this header
+ *   * Extract the size of the component bitmap length
+ *   * Extract a pointer to the start of the record area
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int pldm_parse_header(struct pldmfw_priv *data)
+{
+	const struct __pldmfw_record_area *record_area;
+	struct device *dev = data->context->dev;
+	const struct __pldm_header *header;
+	size_t header_size;
+	int err;
+
+	err = pldm_move_fw_offset(data, sizeof(*header));
+	if (err)
+		return err;
+
+	header = (const struct __pldm_header *)data->fw->data;
+	data->header = header;
+
+	if (!uuid_equal(&header->id, &pldm_firmware_header_id)) {
+		dev_dbg(dev, "Invalid package header identifier. Expected UUID %pUB, but got %pUB\n",
+			&pldm_firmware_header_id, &header->id);
+		return -EINVAL;
+	}
+
+	if (header->revision != PACKAGE_HEADER_FORMAT_REVISION) {
+		dev_dbg(dev, "Invalid package header revision. Expected revision %u but got %u\n",
+			PACKAGE_HEADER_FORMAT_REVISION, header->revision);
+		return -EOPNOTSUPP;
+	}
+
+	data->total_header_size = get_unaligned_le16(&header->size);
+	header_size = data->total_header_size - sizeof(*header);
+
+	err = pldm_check_fw_space(data, data->offset, header_size);
+	if (err)
+		return err;
+
+	data->component_bitmap_len =
+		get_unaligned_le16(&header->component_bitmap_len);
+
+	if (data->component_bitmap_len % 8 != 0) {
+		dev_dbg(dev, "Invalid component bitmap length. The length is %u, which is not a multiple of 8\n",
+			data->component_bitmap_len);
+		return -EINVAL;
+	}
+
+	data->bitmap_size = data->component_bitmap_len / 8;
+
+	err = pldm_move_fw_offset(data, header->version_len);
+	if (err)
+		return err;
+
+	/* extract a pointer to the record area, which just follows the main
+	 * PLDM header data.
+	 */
+	record_area = (const struct __pldmfw_record_area *)(data->fw->data +
+							 data->offset);
+
+	err = pldm_move_fw_offset(data, sizeof(*record_area));
+	if (err)
+		return err;
+
+	data->record_count = record_area->record_count;
+	data->record_start = record_area->records;
+
+	return 0;
+}
+
+/**
+ * pldm_check_desc_tlv_len - Check that the length matches expectation
+ * @data: pointer to image details
+ * @type: the descriptor type
+ * @size: the length from the descriptor header
+ *
+ * If the descriptor type is one of the documented descriptor types according
+ * to the standard, verify that the provided length matches.
+ *
+ * If the type is not recognized or is VENDOR_DEFINED, return zero.
+ *
+ * Returns: zero on success, or -EINVAL if the specified size of a standard
+ * TLV does not match the expected value defined for that TLV.
+ */
+static int
+pldm_check_desc_tlv_len(struct pldmfw_priv *data, u16 type, u16 size)
+{
+	struct device *dev = data->context->dev;
+	u16 expected_size;
+
+	switch (type) {
+	case PLDM_DESC_ID_PCI_VENDOR_ID:
+	case PLDM_DESC_ID_PCI_DEVICE_ID:
+	case PLDM_DESC_ID_PCI_SUBVENDOR_ID:
+	case PLDM_DESC_ID_PCI_SUBDEV_ID:
+		expected_size = 2;
+		break;
+	case PLDM_DESC_ID_PCI_REVISION_ID:
+		expected_size = 1;
+		break;
+	case PLDM_DESC_ID_PNP_VENDOR_ID:
+		expected_size = 3;
+		break;
+	case PLDM_DESC_ID_IANA_ENTERPRISE_ID:
+	case PLDM_DESC_ID_ACPI_VENDOR_ID:
+	case PLDM_DESC_ID_PNP_PRODUCT_ID:
+	case PLDM_DESC_ID_ACPI_PRODUCT_ID:
+		expected_size = 4;
+		break;
+	case PLDM_DESC_ID_UUID:
+		expected_size = 16;
+		break;
+	case PLDM_DESC_ID_VENDOR_DEFINED:
+		return 0;
+	default:
+		/* Do not report an error on an unexpected TLV */
+		dev_dbg(dev, "Found unrecognized TLV type 0x%04x\n", type);
+		return 0;
+	}
+
+	if (size != expected_size) {
+		dev_dbg(dev, "Found TLV type 0x%04x with unexpected length. Got %u bytes, but expected %u bytes\n",
+			type, size, expected_size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * pldm_parse_desc_tlvs - Check and skip past a number of TLVs
+ * @data: pointer to private data
+ * @record: pointer to the record this TLV belongs too
+ * @desc_count: descriptor count
+ *
+ * From the current offset, read and extract the descriptor TLVs, updating the
+ * current offset each time.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int
+pldm_parse_desc_tlvs(struct pldmfw_priv *data, struct pldmfw_record *record, u8 desc_count)
+{
+	const struct __pldmfw_desc_tlv *__desc;
+	const u8 *desc_start;
+	u8 i;
+
+	desc_start = data->fw->data + data->offset;
+
+	pldm_for_each_desc_tlv(i, __desc, desc_start, desc_count) {
+		struct pldmfw_desc_tlv *desc;
+		int err;
+		u16 type, size;
+
+		err = pldm_move_fw_offset(data, sizeof(*__desc));
+		if (err)
+			return err;
+
+		type = get_unaligned_le16(&__desc->type);
+
+		/* According to DSP0267, this only includes the data field */
+		size = get_unaligned_le16(&__desc->size);
+
+		err = pldm_check_desc_tlv_len(data, type, size);
+		if (err)
+			return err;
+
+		/* check that we have space and move the offset forward */
+		err = pldm_move_fw_offset(data, size);
+		if (err)
+			return err;
+
+		desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+		if (!desc)
+			return -ENOMEM;
+
+		desc->type = type;
+		desc->size = size;
+		desc->data = __desc->data;
+
+		list_add_tail(&desc->entry, &record->descs);
+	}
+
+	return 0;
+}
+
+/**
+ * pldm_parse_one_record - Verify size of one PLDM record
+ * @data: pointer to image details
+ * @__record: pointer to the record to check
+ *
+ * This function checks that the record size does not exceed either the size
+ * of the firmware file or the total length specified in the header section.
+ *
+ * It also verifies that the recorded length of the start of the record
+ * matches the size calculated by adding the static structure length, the
+ * component bitmap length, the version string length, the length of all
+ * descriptor TLVs, and the length of the package data.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int
+pldm_parse_one_record(struct pldmfw_priv *data,
+		      const struct __pldmfw_record_info *__record)
+{
+	struct pldmfw_record *record;
+	size_t measured_length;
+	int err;
+	const u8 *bitmap_ptr;
+	u16 record_len;
+	int i;
+
+	/* Make a copy and insert it into the record list */
+	record = kzalloc(sizeof(*record), GFP_KERNEL);
+	if (!record)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&record->descs);
+	list_add_tail(&record->entry, &data->records);
+
+	/* Then check that we have space and move the offset */
+	err = pldm_move_fw_offset(data, sizeof(*__record));
+	if (err)
+		return err;
+
+	record_len = get_unaligned_le16(&__record->record_len);
+	record->package_data_len = get_unaligned_le16(&__record->package_data_len);
+	record->version_len = __record->version_len;
+	record->version_type = __record->version_type;
+
+	bitmap_ptr = data->fw->data + data->offset;
+
+	/* check that we have space for the component bitmap length */
+	err = pldm_move_fw_offset(data, data->bitmap_size);
+	if (err)
+		return err;
+
+	record->component_bitmap_len = data->component_bitmap_len;
+	record->component_bitmap = bitmap_zalloc(record->component_bitmap_len,
+						 GFP_KERNEL);
+	if (!record->component_bitmap)
+		return -ENOMEM;
+
+	for (i = 0; i < data->bitmap_size; i++)
+		bitmap_set_value8(record->component_bitmap, bitmap_ptr[i], i * 8);
+
+	record->version_string = data->fw->data + data->offset;
+
+	err = pldm_move_fw_offset(data, record->version_len);
+	if (err)
+		return err;
+
+	/* Scan through the descriptor TLVs and find the end */
+	err = pldm_parse_desc_tlvs(data, record, __record->descriptor_count);
+	if (err)
+		return err;
+
+	record->package_data = data->fw->data + data->offset;
+
+	err = pldm_move_fw_offset(data, record->package_data_len);
+	if (err)
+		return err;
+
+	measured_length = data->offset - ((const u8 *)__record - data->fw->data);
+	if (measured_length != record_len) {
+		dev_dbg(data->context->dev, "Unexpected record length. Measured record length is %zu bytes, expected length is %u bytes\n",
+			measured_length, record_len);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+/**
+ * pldm_parse_records - Locate the start of the component area
+ * @data: pointer to private data
+ *
+ * Extract the record count, and loop through each record, searching for the
+ * component area.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int pldm_parse_records(struct pldmfw_priv *data)
+{
+	const struct __pldmfw_component_area *component_area;
+	const struct __pldmfw_record_info *record;
+	int err;
+	u8 i;
+
+	pldm_for_each_record(i, record, data->record_start, data->record_count) {
+		err = pldm_parse_one_record(data, record);
+		if (err)
+			return err;
+	}
+
+	/* Extract a pointer to the component area, which just follows the
+	 * PLDM device record data.
+	 */
+	component_area = (const struct __pldmfw_component_area *)(data->fw->data + data->offset);
+
+	err = pldm_move_fw_offset(data, sizeof(*component_area));
+	if (err)
+		return err;
+
+	data->component_count =
+		get_unaligned_le16(&component_area->component_image_count);
+	data->component_start = component_area->components;
+
+	return 0;
+}
+
+/**
+ * pldm_parse_components - Locate the CRC header checksum
+ * @data: pointer to private data
+ *
+ * Extract the component count, and find the pointer to the component area.
+ * Scan through each component searching for the end, which should point to
+ * the package header checksum.
+ *
+ * Extract the package header CRC and save it for verification.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int pldm_parse_components(struct pldmfw_priv *data)
+{
+	const struct __pldmfw_component_info *__component;
+	struct device *dev = data->context->dev;
+	const u8 *header_crc_ptr;
+	int err;
+	u8 i;
+
+	pldm_for_each_component(i, __component, data->component_start, data->component_count) {
+		struct pldmfw_component *component;
+		u32 offset, size;
+
+		err = pldm_move_fw_offset(data, sizeof(*__component));
+		if (err)
+			return err;
+
+		err = pldm_move_fw_offset(data, __component->version_len);
+		if (err)
+			return err;
+
+		offset = get_unaligned_le32(&__component->location_offset);
+		size = get_unaligned_le32(&__component->size);
+
+		err = pldm_check_fw_space(data, offset, size);
+		if (err)
+			return err;
+
+		component = kzalloc(sizeof(*component), GFP_KERNEL);
+		if (!component)
+			return -ENOMEM;
+
+		component->index = i;
+		component->classification = get_unaligned_le16(&__component->classification);
+		component->identifier = get_unaligned_le16(&__component->identifier);
+		component->comparison_stamp = get_unaligned_le32(&__component->comparison_stamp);
+		component->options = get_unaligned_le16(&__component->options);
+		component->activation_method = get_unaligned_le16(&__component->activation_method);
+		component->version_type = __component->version_type;
+		component->version_len = __component->version_len;
+		component->version_string = __component->version_string;
+		component->component_data = data->fw->data + offset;
+		component->component_size = size;
+
+		list_add_tail(&component->entry, &data->components);
+	}
+
+	header_crc_ptr = data->fw->data + data->offset;
+
+	err = pldm_move_fw_offset(data, sizeof(data->header_crc));
+	if (err)
+		return err;
+
+	/* Make sure that we reached the expected offset */
+	if (data->offset != data->total_header_size) {
+		dev_dbg(dev, "Invalid firmware header size. Expected %u but got %zu\n",
+			data->total_header_size, data->offset);
+		return -EFAULT;
+	}
+
+	data->header_crc = get_unaligned_le32(header_crc_ptr);
+
+	return 0;
+}
+
+/**
+ * pldm_verify_header_crc - Verify that the CRC in the header matches
+ * @data: pointer to private data
+ *
+ * Calculates the 32-bit CRC using the standard IEEE 802.3 CRC polynomial and
+ * compares it to the value stored in the header.
+ *
+ * Returns: zero on success if the CRC matches, or -EBADMSG on an invalid CRC.
+ */
+static int pldm_verify_header_crc(struct pldmfw_priv *data)
+{
+	struct device *dev = data->context->dev;
+	u32 calculated_crc;
+	size_t length;
+
+	/* Calculate the 32-bit CRC of the header header contents up to but
+	 * not including the checksum. Note that the Linux crc32_le function
+	 * does not perform an expected final XOR.
+	 */
+	length = data->offset - sizeof(data->header_crc);
+	calculated_crc = crc32_le(~0, data->fw->data, length) ^ ~0;
+
+	if (calculated_crc != data->header_crc) {
+		dev_dbg(dev, "Invalid CRC in firmware header. Got 0x%08x but expected 0x%08x\n",
+			calculated_crc, data->header_crc);
+		return -EBADMSG;
+	}
+
+	return 0;
+}
+
+/**
+ * pldmfw_free_priv - Free memory allocated while parsing the PLDM image
+ * @data: pointer to the PLDM data structure
+ *
+ * Loops through and clears all allocated memory associated with each
+ * allocated descriptor, record, and component.
+ */
+static void pldmfw_free_priv(struct pldmfw_priv *data)
+{
+	struct pldmfw_component *component, *c_safe;
+	struct pldmfw_record *record, *r_safe;
+	struct pldmfw_desc_tlv *desc, *d_safe;
+
+	list_for_each_entry_safe(component, c_safe, &data->components, entry) {
+		list_del(&component->entry);
+		kfree(component);
+	}
+
+	list_for_each_entry_safe(record, r_safe, &data->records, entry) {
+		list_for_each_entry_safe(desc, d_safe, &record->descs, entry) {
+			list_del(&desc->entry);
+			kfree(desc);
+		}
+
+		if (record->component_bitmap) {
+			bitmap_free(record->component_bitmap);
+			record->component_bitmap = NULL;
+		}
+
+		list_del(&record->entry);
+		kfree(record);
+	}
+}
+
+/**
+ * pldm_parse_image - parse and extract details from PLDM image
+ * @data: pointer to private data
+ *
+ * Verify that the firmware file contains valid data for a PLDM firmware
+ * file. Extract useful pointers and data from the firmware file and store
+ * them in the data structure.
+ *
+ * The PLDM firmware file format is defined in DMTF DSP0267 1.0.0. Care
+ * should be taken to use get_unaligned_le* when accessing data from the
+ * pointers in data.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int pldm_parse_image(struct pldmfw_priv *data)
+{
+	int err;
+
+	if (WARN_ON(!(data->context->dev && data->fw->data && data->fw->size)))
+		return -EINVAL;
+
+	err = pldm_parse_header(data);
+	if (err)
+		return err;
+
+	err = pldm_parse_records(data);
+	if (err)
+		return err;
+
+	err = pldm_parse_components(data);
+	if (err)
+		return err;
+
+	return pldm_verify_header_crc(data);
+}
+
+/* these are u32 so that we can store PCI_ANY_ID */
+struct pldm_pci_record_id {
+	int vendor;
+	int device;
+	int subsystem_vendor;
+	int subsystem_device;
+};
+
+/**
+ * pldmfw_op_pci_match_record - Check if a PCI device matches the record
+ * @context: PLDM fw update structure
+ * @record: list of records extracted from the PLDM image
+ *
+ * Determine of the PCI device associated with this device matches the record
+ * data provided.
+ *
+ * Searches the descriptor TLVs and extracts the relevant descriptor data into
+ * a pldm_pci_record_id. This is then compared against the PCI device ID
+ * information.
+ *
+ * Returns: true if the device matches the record, false otherwise.
+ */
+bool pldmfw_op_pci_match_record(struct pldmfw *context, struct pldmfw_record *record)
+{
+	struct pci_dev *pdev = to_pci_dev(context->dev);
+	struct pldm_pci_record_id id = {
+		.vendor = PCI_ANY_ID,
+		.device = PCI_ANY_ID,
+		.subsystem_vendor = PCI_ANY_ID,
+		.subsystem_device = PCI_ANY_ID,
+	};
+	struct pldmfw_desc_tlv *desc;
+
+	list_for_each_entry(desc, &record->descs, entry) {
+		u16 value;
+		int *ptr;
+
+		switch (desc->type) {
+		case PLDM_DESC_ID_PCI_VENDOR_ID:
+			ptr = &id.vendor;
+			break;
+		case PLDM_DESC_ID_PCI_DEVICE_ID:
+			ptr = &id.device;
+			break;
+		case PLDM_DESC_ID_PCI_SUBVENDOR_ID:
+			ptr = &id.subsystem_vendor;
+			break;
+		case PLDM_DESC_ID_PCI_SUBDEV_ID:
+			ptr = &id.subsystem_device;
+			break;
+		default:
+			/* Skip unrelated TLVs */
+			continue;
+		}
+
+		value = get_unaligned_le16(desc->data);
+		/* A value of zero for one of the descriptors is sometimes
+		 * used when the record should ignore this field when matching
+		 * device. For example if the record applies to any subsystem
+		 * device or vendor.
+		 */
+		if (value)
+			*ptr = (int)value;
+		else
+			*ptr = PCI_ANY_ID;
+	}
+
+	if ((id.vendor == PCI_ANY_ID || id.vendor == pdev->vendor) &&
+	    (id.device == PCI_ANY_ID || id.device == pdev->device) &&
+	    (id.subsystem_vendor == PCI_ANY_ID || id.subsystem_vendor == pdev->subsystem_vendor) &&
+	    (id.subsystem_device == PCI_ANY_ID || id.subsystem_device == pdev->subsystem_device))
+		return true;
+	else
+		return false;
+}
+EXPORT_SYMBOL(pldmfw_op_pci_match_record);
+
+/**
+ * pldm_find_matching_record - Find the first matching PLDM record
+ * @data: pointer to private data
+ *
+ * Search through PLDM records and find the first matching entry. It is
+ * expected that only one entry matches.
+ *
+ * Store a pointer to the matching record, if found.
+ *
+ * Returns: zero on success, or -ENOENT if no matching record is found.
+ */
+static int pldm_find_matching_record(struct pldmfw_priv *data)
+{
+	struct pldmfw_record *record;
+
+	list_for_each_entry(record, &data->records, entry) {
+		if (data->context->ops->match_record(data->context, record)) {
+			data->matching_record = record;
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+
+/**
+ * pldm_send_package_data - Send firmware the package data for the record
+ * @data: pointer to private data
+ *
+ * Send the package data associated with the matching record to the firmware,
+ * using the send_pkg_data operation.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int
+pldm_send_package_data(struct pldmfw_priv *data)
+{
+	struct pldmfw_record *record = data->matching_record;
+	const struct pldmfw_ops *ops = data->context->ops;
+
+	return ops->send_package_data(data->context, record->package_data,
+				      record->package_data_len);
+}
+
+/**
+ * pldm_send_component_tables - Send component table information to firmware
+ * @data: pointer to private data
+ *
+ * Loop over each component, sending the applicable components to the firmware
+ * via the send_component_table operation.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int
+pldm_send_component_tables(struct pldmfw_priv *data)
+{
+	unsigned long *bitmap = data->matching_record->component_bitmap;
+	struct pldmfw_component *component;
+	int err;
+
+	list_for_each_entry(component, &data->components, entry) {
+		u8 index = component->index, transfer_flag = 0;
+
+		/* Skip components which are not intended for this device */
+		if (!test_bit(index, bitmap))
+			continue;
+
+		/* determine whether this is the start, middle, end, or both
+		 * the start and end of the component tables
+		 */
+		if (index == find_first_bit(bitmap, data->component_bitmap_len))
+			transfer_flag |= PLDM_TRANSFER_FLAG_START;
+		if (index == find_last_bit(bitmap, data->component_bitmap_len))
+			transfer_flag |= PLDM_TRANSFER_FLAG_END;
+		if (!transfer_flag)
+			transfer_flag = PLDM_TRANSFER_FLAG_MIDDLE;
+
+		err = data->context->ops->send_component_table(data->context,
+							       component,
+							       transfer_flag);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+/**
+ * pldm_flash_components - Program each component to device flash
+ * @data: pointer to private data
+ *
+ * Loop through each component that is active for the matching device record,
+ * and send it to the device driver for flashing.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+static int pldm_flash_components(struct pldmfw_priv *data)
+{
+	unsigned long *bitmap = data->matching_record->component_bitmap;
+	struct pldmfw_component *component;
+	int err;
+
+	list_for_each_entry(component, &data->components, entry) {
+		u8 index = component->index;
+
+		/* Skip components which are not intended for this device */
+		if (!test_bit(index, bitmap))
+			continue;
+
+		err = data->context->ops->flash_component(data->context, component);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+/**
+ * pldm_finalize_update - Finalize the device flash update
+ * @data: pointer to private data
+ *
+ * Tell the device driver to perform any remaining logic to complete the
+ * device update.
+ *
+ * Returns: zero on success, or a PLFM_FWU error indicating the reason for
+ * failure.
+ */
+static int pldm_finalize_update(struct pldmfw_priv *data)
+{
+	if (data->context->ops->finalize_update)
+		return data->context->ops->finalize_update(data->context);
+
+	return 0;
+}
+
+/**
+ * pldmfw_flash_image - Write a PLDM-formatted firmware image to the device
+ * @context: ops and data for firmware update
+ * @fw: firmware object pointing to the relevant firmware file to program
+ *
+ * Parse the data for a given firmware file, verifying that it is a valid PLDM
+ * formatted image that matches this device.
+ *
+ * Extract the device record Package Data and Component Tables and send them
+ * to the device firmware. Extract and write the flash data for each of the
+ * components indicated in the firmware file.
+ *
+ * Returns: zero on success, or a negative error code on failure.
+ */
+int pldmfw_flash_image(struct pldmfw *context, const struct firmware *fw)
+{
+	struct pldmfw_priv *data;
+	int err;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&data->records);
+	INIT_LIST_HEAD(&data->components);
+
+	data->fw = fw;
+	data->context = context;
+
+	err = pldm_parse_image(data);
+	if (err)
+		goto out_release_data;
+
+	err = pldm_find_matching_record(data);
+	if (err)
+		goto out_release_data;
+
+	err = pldm_send_package_data(data);
+	if (err)
+		goto out_release_data;
+
+	err = pldm_send_component_tables(data);
+	if (err)
+		goto out_release_data;
+
+	err = pldm_flash_components(data);
+	if (err)
+		goto out_release_data;
+
+	err = pldm_finalize_update(data);
+
+out_release_data:
+	pldmfw_free_priv(data);
+	kfree(data);
+
+	return err;
+}
+EXPORT_SYMBOL(pldmfw_flash_image);
+
+MODULE_AUTHOR("Jacob Keller <jacob.e.keller@intel.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("PLDM firmware flash update library");
diff --git a/lib/pldmfw/pldmfw_private.h b/lib/pldmfw/pldmfw_private.h
new file mode 100644
index 000000000000..687ef2200692
--- /dev/null
+++ b/lib/pldmfw/pldmfw_private.h
@@ -0,0 +1,238 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2018-2019, Intel Corporation. */
+
+#ifndef _PLDMFW_PRIVATE_H_
+#define _PLDMFW_PRIVATE_H_
+
+/* The following data structures define the layout of a firmware binary
+ * following the "PLDM For Firmware Update Specification", DMTF standard
+ * #DSP0267.
+ *
+ * pldmfw.c uses these structures to implement a simple engine that will parse
+ * a fw binary file in this format and perform a firmware update for a given
+ * device.
+ *
+ * Due to the variable sized data layout, alignment of fields within these
+ * structures is not guaranteed when reading. For this reason, all multi-byte
+ * field accesses should be done using the unaligned access macros.
+ * Additionally, the standard specifies that multi-byte fields are in
+ * LittleEndian format.
+ *
+ * The structure definitions are not made public, in order to keep direct
+ * accesses within code that is prepared to deal with the limitation of
+ * unaligned access.
+ */
+
+/* UUID for PLDM firmware packages: f018878c-cb7d-4943-9800-a02f059aca02 */
+static const uuid_t pldm_firmware_header_id =
+	UUID_INIT(0xf018878c, 0xcb7d, 0x4943,
+		  0x98, 0x00, 0xa0, 0x2f, 0x05, 0x9a, 0xca, 0x02);
+
+/* Revision number of the PLDM header format this code supports */
+#define PACKAGE_HEADER_FORMAT_REVISION 0x01
+
+/* timestamp104 structure defined in PLDM Base specification */
+#define PLDM_TIMESTAMP_SIZE 13
+struct __pldm_timestamp {
+	u8 b[PLDM_TIMESTAMP_SIZE];
+} __packed __aligned(1);
+
+/* Package Header Information */
+struct __pldm_header {
+	uuid_t id;			    /* PackageHeaderIdentifier */
+	u8 revision;			    /* PackageHeaderFormatRevision */
+	__le16 size;			    /* PackageHeaderSize */
+	struct __pldm_timestamp release_date; /* PackageReleaseDateTime */
+	__le16 component_bitmap_len;	    /* ComponentBitmapBitLength */
+	u8 version_type;		    /* PackageVersionStringType */
+	u8 version_len;			    /* PackageVersionStringLength */
+
+	/*
+	 * DSP0267 also includes the following variable length fields at the
+	 * end of this structure:
+	 *
+	 * PackageVersionString, length is version_len.
+	 *
+	 * The total size of this section is
+	 *   sizeof(pldm_header) + version_len;
+	 */
+	u8 version_string[];		/* PackageVersionString */
+} __packed __aligned(1);
+
+/* Firmware Device ID Record */
+struct __pldmfw_record_info {
+	__le16 record_len;		/* RecordLength */
+	u8 descriptor_count;		/* DescriptorCount */
+	__le32 device_update_flags;	/* DeviceUpdateOptionFlags */
+	u8 version_type;		/* ComponentImageSetVersionType */
+	u8 version_len;			/* ComponentImageSetVersionLength */
+	__le16 package_data_len;	/* FirmwareDevicePackageDataLength */
+
+	/*
+	 * DSP0267 also includes the following variable length fields at the
+	 * end of this structure:
+	 *
+	 * ApplicableComponents, length is component_bitmap_len from header
+	 * ComponentImageSetVersionString, length is version_len
+	 * RecordDescriptors, a series of TLVs with 16bit type and length
+	 * FirmwareDevicePackageData, length is package_data_len
+	 *
+	 * The total size of each record is
+	 *   sizeof(pldmfw_record_info) +
+	 *   component_bitmap_len (converted to bytes!) +
+	 *   version_len +
+	 *   <length of RecordDescriptors> +
+	 *   package_data_len
+	 */
+	u8 variable_record_data[];
+} __packed __aligned(1);
+
+/* Firmware Descriptor Definition */
+struct __pldmfw_desc_tlv {
+	__le16 type;			/* DescriptorType */
+	__le16 size;			/* DescriptorSize */
+	u8 data[];			/* DescriptorData */
+} __aligned(1);
+
+/* Firmware Device Identification Area */
+struct __pldmfw_record_area {
+	u8 record_count;		/* DeviceIDRecordCount */
+	/* This is not a struct type because the size of each record varies */
+	u8 records[];
+} __aligned(1);
+
+/* Individual Component Image Information */
+struct __pldmfw_component_info {
+	__le16 classification;		/* ComponentClassfication */
+	__le16 identifier;		/* ComponentIdentifier */
+	__le32 comparison_stamp;	/* ComponentComparisonStamp */
+	__le16 options;			/* componentOptions */
+	__le16 activation_method;	/* RequestedComponentActivationMethod */
+	__le32 location_offset;		/* ComponentLocationOffset */
+	__le32 size;			/* ComponentSize */
+	u8 version_type;		/* ComponentVersionStringType */
+	u8 version_len;		/* ComponentVersionStringLength */
+
+	/*
+	 * DSP0267 also includes the following variable length fields at the
+	 * end of this structure:
+	 *
+	 * ComponentVersionString, length is version_len
+	 *
+	 * The total size of this section is
+	 *   sizeof(pldmfw_component_info) + version_len;
+	 */
+	u8 version_string[];		/* ComponentVersionString */
+} __packed __aligned(1);
+
+/* Component Image Information Area */
+struct __pldmfw_component_area {
+	__le16 component_image_count;
+	/* This is not a struct type because the component size varies */
+	u8 components[];
+} __aligned(1);
+
+/**
+ * pldm_first_desc_tlv
+ * @start: byte offset of the start of the descriptor TLVs
+ *
+ * Converts the starting offset of the descriptor TLVs into a pointer to the
+ * first descriptor.
+ */
+#define pldm_first_desc_tlv(start)					\
+	((const struct __pldmfw_desc_tlv *)(start))
+
+/**
+ * pldm_next_desc_tlv
+ * @desc: pointer to a descriptor TLV
+ *
+ * Finds the pointer to the next descriptor following a given descriptor
+ */
+#define pldm_next_desc_tlv(desc)						\
+	((const struct __pldmfw_desc_tlv *)((desc)->data +			\
+					     get_unaligned_le16(&(desc)->size)))
+
+/**
+ * pldm_for_each_desc_tlv
+ * @i: variable to store descriptor index
+ * @desc: variable to store descriptor pointer
+ * @start: byte offset of the start of the descriptors
+ * @count: the number of descriptors
+ *
+ * for loop macro to iterate over all of the descriptors of a given PLDM
+ * record.
+ */
+#define pldm_for_each_desc_tlv(i, desc, start, count)			\
+	for ((i) = 0, (desc) = pldm_first_desc_tlv(start);		\
+	     (i) < (count);						\
+	     (i)++, (desc) = pldm_next_desc_tlv(desc))
+
+/**
+ * pldm_first_record
+ * @start: byte offset of the start of the PLDM records
+ *
+ * Converts a starting offset of the PLDM records into a pointer to the first
+ * record.
+ */
+#define pldm_first_record(start)					\
+	((const struct __pldmfw_record_info *)(start))
+
+/**
+ * pldm_next_record
+ * @record: pointer to a PLDM record
+ *
+ * Finds a pointer to the next record following a given record
+ */
+#define pldm_next_record(record)					\
+	((const struct __pldmfw_record_info *)				\
+	 ((const u8 *)(record) + get_unaligned_le16(&(record)->record_len)))
+
+/**
+ * pldm_for_each_record
+ * @i: variable to store record index
+ * @record: variable to store record pointer
+ * @start: byte offset of the start of the records
+ * @count: the number of records
+ *
+ * for loop macro to iterate over all of the records of a PLDM file.
+ */
+#define pldm_for_each_record(i, record, start, count)			\
+	for ((i) = 0, (record) = pldm_first_record(start);		\
+	     (i) < (count);						\
+	     (i)++, (record) = pldm_next_record(record))
+
+/**
+ * pldm_first_component
+ * @start: byte offset of the start of the PLDM components
+ *
+ * Convert a starting offset of the PLDM components into a pointer to the
+ * first component
+ */
+#define pldm_first_component(start)					\
+	((const struct __pldmfw_component_info *)(start))
+
+/**
+ * pldm_next_component
+ * @component: pointer to a PLDM component
+ *
+ * Finds a pointer to the next component following a given component
+ */
+#define pldm_next_component(component)						\
+	((const struct __pldmfw_component_info *)((component)->version_string +	\
+						  (component)->version_len))
+
+/**
+ * pldm_for_each_component
+ * @i: variable to store component index
+ * @component: variable to store component pointer
+ * @start: byte offset to the start of the first component
+ * @count: the number of components
+ *
+ * for loop macro to iterate over all of the components of a PLDM file.
+ */
+#define pldm_for_each_component(i, component, start, count)		\
+	for ((i) = 0, (component) = pldm_first_component(start);	\
+	     (i) < (count);						\
+	     (i)++, (component) = pldm_next_component(component))
+
+#endif

base-commit: 0d127fc31b70b1aa28f8bc3014c7e6d11a4dd1bc
-- 
2.28.0.rc1.139.gd6b33fda9dd1

