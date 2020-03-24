Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA540190310
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 01:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgCXAur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 20:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbgCXAur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 20:50:47 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 552BE20722;
        Tue, 24 Mar 2020 00:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585011046;
        bh=KkXgIu9uzbDCnxBLJUW9K36aLcCXyVsSxCwG9cqL81Q=;
        h=From:To:Cc:Subject:Date:From;
        b=uFIbMHJxtAMdIqXS0xCNcnm/ocu6nmrT95lpGMg3pe/sA3SdSYCqjc/vB4FhBOKg6
         LFDpiqTfvtedWS8eqpOgL+lZswAg+12xasHeFRSdHNHNPce/oYVhww9+H42XUD6p1X
         rfgc+Tgi0QDnPRQiKEya71IgHvC/by/7u4GtHf9k=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, eugenem@fb.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        michael.chan@broadcom.com, snelson@pensando.io,
        jesse.brandeburg@intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] devlink: expand the devlink-info documentation
Date:   Mon, 23 Mar 2020 17:50:24 -0700
Message-Id: <20200324005024.67605-1-kuba@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are having multiple review cycles with all vendors trying
to implement devlink-info. Let's expand the documentation with
more information about what's implemented and motivation behind
this interface in an attempt to make the implementations easier.

Describe what each info section is supposed to contain, and make
some references to other HW interfaces (PCI caps).

Document how firmware management is expected to look, to make
it clear how devlink-info and devlink-flash work in concert.

Name some future work.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../networking/devlink/devlink-flash.rst      |  88 ++++++++++++
 .../networking/devlink/devlink-info.rst       | 132 +++++++++++++++---
 .../networking/devlink/devlink-params.rst     |   2 +
 Documentation/networking/devlink/index.rst    |   1 +
 4 files changed, 207 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/networking/devlink/devlink-flash.rst

diff --git a/Documentation/networking/devlink/devlink-flash.rst b/Documentation/networking/devlink/devlink-flash.rst
new file mode 100644
index 000000000000..46cea870117d
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-flash.rst
@@ -0,0 +1,88 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+.. _devlink_flash:
+
+=============
+Devlink Flash
+=============
+
+The ``devlink-flash`` allows updating device firmware. It replaces the
+older ``ethtool-flash`` mechanism, and doesn't require taking any
+networking locks in the kernel to perform the flash update. Example use::
+
+  $ devlink dev flash pci/0000:05:00.0 file flash-boot.bin
+
+Note that the file name is a path relative to the firmware loading path
+(usually ``/lib/firmware/``). Drivers may send status updates to inform
+user space about the progress of the update operation.
+
+Firmware Loading
+================
+
+Devices which require firmware to operate usually store it in non-volatile
+memory on the board, e.g. flash. Some devices store only basic firmware on
+the board, and driver loads the rest from disk during probing.
+``devlink-info`` allows users to query firmware information (loaded
+components and versions).
+
+In other cases device can both store the image on the board, load from
+disk, or automatically flash a new image from disk. ``fw_load_policy``
+devlink parameter can be used to control this behavior
+(:ref:`Documentation/networking/devlink/devlink-params.rst <devlink_params_generic>`).
+
+On-disk firmware files are usually stored in ``/lib/firmware/``.
+
+Firmware Version Management
+===========================
+
+Drivers are expected to implement ``devlink-flash`` and ``devlink-info``
+functionality, which together allow for implementing vendor-independent
+automated firmware update facilities.
+
+``devlink-info`` exposes the ``driver`` name and three version groups
+(``fixed``, ``running``, ``stored``).
+
+``driver`` and ``fixed`` group identify the specific device design,
+e.g. for looking up applicable firmware updates. This is why ``serial_number``
+is not part of the ``fixed`` versions (even though it is fixed) - ``fixed``
+versions should identify the design, not a single device.
+
+``running`` and ``stored`` firmware versions identify the firmware running
+on the device, and firmware which will be activated after reboot or device
+reset.
+
+The firmware update agent is supposed to be able to follow this simple
+algorithm to update firmware contents, regardless of the device vendor:
+
+.. code-block:: sh
+
+  # Get unique HW design identifier
+  $hw_id = devlink-dev-info['fixed']
+
+  # Find out which FW flash we want to use for this NIC
+  $want_flash_vers = some-db-backed.lookup($hw_id, 'flash')
+
+  # Update flash if necessary
+  if $want_flash_vers != devlink-dev-info['stored']:
+      $file = some-db-backed.download($hw_id, 'flash')
+      devlink-dev-flash($file)
+
+  # Find out the expected overall firmware versions
+  $want_fw_vers = some-db-backed.lookup($hw_id, 'all')
+
+  # Update on-disk file if necessary
+  if $want_fw_vers != devlink-dev-info['running']:
+      $file = some-db-backed.download($hw_id, 'disk')
+      write($file, '/lib/firmware/')
+
+  # Reboot if necessary
+  if $want_fw_vers != devlink-dev-info['running']:
+     reboot()
+
+Note that each reference to ``devlink-dev-info`` in this pseudo-code
+is expected to fetch up-to-date information from the kernel.
+
+For the convenience of identifying firmware files some vendors add
+``bundle_id`` information to the firmware versions. This meta-version covers
+multiple per-component versions and can be used e.g. in firmware file names
+(all component versions could get rather long.)
diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
index 70981dd1b981..06f05dd3f448 100644
--- a/Documentation/networking/devlink/devlink-info.rst
+++ b/Documentation/networking/devlink/devlink-info.rst
@@ -5,34 +5,118 @@ Devlink Info
 ============
 
 The ``devlink-info`` mechanism enables device drivers to report device
-information in a generic fashion. It is extensible, and enables exporting
-even device or driver specific information.
+(hardware and firmware) information in a standard, extensible fashion.
 
-devlink supports representing the following types of versions
+The original motivation for the ``devlink-info`` API was twofold:
 
-.. list-table:: List of version types
+ - making it possible to automate device and firmware management in a fleet
+   of machines in a vendor-independent fashion (see also
+   :ref:`Documentation/networking/devlink/devlink-flash.rst <devlink_flash>`);
+ - name the per component FW versions (as opposed to the crowded ethtool
+   version string).
+
+``devlink-info`` supports reporting multiple types of objects. Reporting driver
+versions is generally discouraged - here, and via any other Linux API.
+
+.. list-table:: List of top level info objects
    :widths: 5 95
 
-   * - Type
+   * - Name
      - Description
+   * - ``driver``
+     - Name of the currently used device driver, also available through sysfs.
+
+   * - ``serial_number``
+     - Serial number of the device.
+
+       This is usually the serial number of the ASIC, also often available
+       in PCI config space of the device in the *Device Serial Number*
+       capability.
+
+       The serial number should be unique per physical device.
+       Sometimes the serial number of the device is only 48 bits long (the
+       length of the Ethernet MAC address), and since PCI DSN is 64 bits long
+       devices pad or encode additional information into the serial number.
+       One example is adding port ID or PCI interface ID in the extra two bytes.
+       Drivers should make sure to strip or normalize any such padding
+       or interface ID, and report only the part of the serial number
+       which uniquely identify the hardware. In other words serial number
+       reported for two ports of the same device or on two hosts of
+       a multi-host device should be identical.
+
+       .. note:: ``devlink-info`` API should be extended with a new field
+	  if devices want to report board/product serial number (often
+	  reported in PCI *Vital Product Data* capability).
+
    * - ``fixed``
-     - Represents fixed versions, which cannot change. For example,
+     - Group for hardware identifiers, and versions of components
+       which are not field-updatable.
+
+       Versions in this section identify the device design. For example,
        component identifiers or the board version reported in the PCI VPD.
+       Data in ``devlink-info`` should be broken into smallest logical
+       components, e.g. PCI VPD may concatenate various information
+       to form the Part Number string, in ``devlink-info`` all parts
+       should be reported as separate items.
+
+       This groups must not contain any frequently changing identifiers,
+       such as serial numbers. See
+       :ref:`Documentation/networking/devlink/devlink-flash.rst <devlink_flash>`
+       to understand why.
+
    * - ``running``
-     - Represents the version of the currently running component. For
-       example the running version of firmware. These versions generally
-       only update after a reboot.
+     - Group for information about currently running software/firmware.
+       These versions often only update after a reboot, sometimes device reset.
+
    * - ``stored``
-     - Represents the version of a component as stored, such as after a
-       flash update. Stored values should update to reflect changes in the
-       flash even if a reboot has not yet occurred.
+     - Group for software/firmware versions in device flash.
+
+       Stored values must update to reflect changes in the flash even
+       if reboot has not yet occurred. If device is not capable of updating
+       ``stored`` versions when new software is flashed, it must not report
+       them.
+
+Each version can be reported at most once in each version group. Firmware
+components stored on the flash should feature both in ``running`` and
+``stored`` section, if device is capable of reporting ``stored`` versions
+(see :ref:`Documentation/networking/devlink/devlink-flash.rst <devlink_flash>`).
+In case software/firmware components are loaded from the disk (e.g.
+``/lib/firmware``) only running version should be reported via the kernel API.
 
 Generic Versions
 ================
 
 It is expected that drivers use the following generic names for exporting
-version information. Other information may be exposed using driver-specific
-names, but these should be documented in the driver-specific file.
+version information. If generic name for given component doesn't exist, yet,
+driver authors should consult existing driver-specific versions and attempt
+reuse. As last resort, if component is truly unique, using driver-specific
+names is allowed, but these should be documented in the driver-specific file.
+
+All versions should try to use the following terminology:
+
+.. list-table:: List of common version suffixes
+   :widths: 10 90
+
+   * - Name
+     - Description
+   * - ``id``, ``revision``
+     - Identifiers of designs and revision, mostly used for hardware versions.
+
+   * - ``api``
+     - Version of API between components. API items are usually of limited
+       value to the user, and can be inferred from other versions by the vendor,
+       so adding API versions is generally discouraged as noise.
+
+   * - ``bundle_id``
+     - Identifier of a distribution package which was flashed onto the device.
+       This is an attribute of a firmware package which covers multiple versions
+       for ease of managing firmware images (see
+       :ref:`Documentation/networking/devlink/devlink-flash.rst <devlink_flash>`).
+
+       ``bundle_id`` can appear in both ``running`` and ``stored`` versions,
+       but it must not be reported if any of the components covered by the
+       ``bundle_id`` was changed and no longer matches the version from
+       the bundle.
 
 board.id
 --------
@@ -52,7 +136,7 @@ ASIC design identifier.
 asic.rev
 --------
 
-ASIC design revision.
+ASIC design revision/stepping.
 
 board.manufacture
 -----------------
@@ -91,10 +175,26 @@ Network Controller Sideband Interface.
 fw.psid
 -------
 
-Unique identifier of the firmware parameter set.
+Unique identifier of the firmware parameter set. These are usually
+parameters of a particular board, defined at manufacturing time.
 
 fw.roce
 -------
 
 RoCE firmware version which is responsible for handling roce
 management.
+
+Future work
+===========
+
+The following extensions could be useful:
+
+ - product serial number - NIC boards often get labeled with a board serial
+   number rather than ASIC serial number, it'd be useful to add board serial
+   numbers to the API if they can be retrieved from the device;
+
+ - on-disk firmware file names - drivers list the file names of firmware they
+   may need to load onto devices via the ``MODULE_FIRMWARE()`` macro. These,
+   however, are per module, rather than per device. It'd be useful to list
+   the names of firmware files the driver will try to load for a given device,
+   in order of priority.
diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index da2f85c0fa21..d075fd090b3d 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -41,6 +41,8 @@ In order for ``driverinit`` parameters to take effect, the driver must
 support reloading via the ``devlink-reload`` command. This command will
 request a reload of the device driver.
 
+.. _devlink_params_generic:
+
 Generic configuration parameters
 ================================
 The following is a list of generic configuration parameters that drivers may
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 087ff54d53fc..55ee74e52d97 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -16,6 +16,7 @@ general.
    devlink-dpipe
    devlink-health
    devlink-info
+   devlink-flash
    devlink-params
    devlink-region
    devlink-resource
-- 
2.25.1

