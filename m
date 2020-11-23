Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEA52C0C61
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388722AbgKWNwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:52:42 -0500
Received: from mga14.intel.com ([192.55.52.115]:1517 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388215AbgKWNwm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:52:42 -0500
IronPort-SDR: Urxtyn3rJNPsT8r27iuSv74u+nB2FwMIH2gtEw2owWdpIuO7kl44bI6pPw7lszz9aUwcEX14+x
 vpbwbVglfkPg==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="170981521"
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="170981521"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 05:52:41 -0800
IronPort-SDR: E/AZctTomfoqxdjiZGko30O/ibjqmO52PghxPifFBfLpXIusUIfz0zXmTmOijUaxxVCidgq/FP
 Ip2gyr7+fJfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="370035672"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga007.jf.intel.com with ESMTP; 23 Nov 2020 05:52:39 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [RFC 17/18] net: iosm: readme file
Date:   Mon, 23 Nov 2020 19:21:22 +0530
Message-Id: <20201123135123.48892-18-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20201123135123.48892-1-m.chetan.kumar@intel.com>
References: <20201123135123.48892-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documents IOSM Driver interface usage.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/README | 126 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/README

diff --git a/drivers/net/wwan/iosm/README b/drivers/net/wwan/iosm/README
new file mode 100644
index 000000000000..4a489177ad96
--- /dev/null
+++ b/drivers/net/wwan/iosm/README
@@ -0,0 +1,126 @@
+IOSM Driver for PCIe based Intel M.2 Modems
+================================================
+The IOSM (IPC over Shared Memory) driver is a PCIe host driver implemented
+for linux or chrome platform for data exchange over PCIe interface between
+Host platform & Intel M.2 Modem. The driver exposes interface conforming to the
+MBIM protocol [1]. Any front end application ( eg: Modem Manager) could easily
+manage the MBIM interface to enable data communication towards WWAN.
+
+Basic usage
+===========
+MBIM functions are inactive when unmanaged. The IOSM driver only
+provides a userspace interface of a character device representing
+MBIM control channel and does not play any role in managing the
+functionality. It is the job of a userspace application to enumerate
+the port appropriately and enable MBIM functionality.
+
+Examples of few such userspace application are:
+ - mbimcli (included with the libmbim [2] library), and
+ - ModemManager [3]
+
+For establishing an MBIM IP session at least these actions are required by the
+management application:
+ - open the control channel
+ - configure network connection settings
+ - connect to network
+ - configure IP interface
+
+Management application development
+----------------------------------
+The driver and userspace interfaces are described below. The MBIM
+control channel protocol is described in [1].
+
+MBIM control channel userspace ABI
+==================================
+
+/dev/wwanctrl character device
+------------------------------
+The driver exposes an interface to the MBIM function control channel using char
+driver as a subdriver. The userspace end of the control channel pipe is a
+/dev/wwanctrl character device.
+
+The /dev/wwanctrl device is created as a subordinate character device under
+IOSM driver. The character device associated with a specific MBIM function
+can be looked up using sysfs with matching the above device name.
+
+Control channel configuration
+-----------------------------
+The wMaxControlMessage field of the MBIM functional descriptor
+limits the maximum control message size. The management application needs to
+negotiate the control message size as per the requirements.
+See also the ioctl documentation below.
+
+Fragmentation
+-------------
+The userspace application is responsible for all control message
+fragmentation and defragmentation as per MBIM.
+
+/dev/wwanctrl write()
+---------------------
+The MBIM control messages from the management application must not
+exceed the negotiated control message size.
+
+/dev/wwanctrl read()
+--------------------
+The management application must accept control messages of up the
+negotiated control message size.
+
+/dev/wwanctrl ioctl()
+--------------------
+IOCTL_WDM_MAX_COMMAND: Get Maximum Command Size
+This IOCTL command could be used by applications to fetch the Maximum Command
+buffer length supported by the driver which is restricted to 4096 bytes.
+
+	#include <stdio.h>
+	#include <fcntl.h>
+	#include <sys/ioctl.h>
+	#include <linux/types.h>
+	int main()
+	{
+		__u16 max;
+		int fd = open("/dev/wwanctrl", O_RDWR);
+		if (!ioctl(fd, IOCTL_WDM_MAX_COMMAND, &max))
+			printf("wMaxControlMessage is %d\n", max);
+	}
+
+MBIM data channel userspace ABI
+===============================
+
+wwanY network device
+--------------------
+The IOSM driver represents the MBIM data channel as a single
+network device of the "wwan0" type. This network device is initially
+mapped to MBIM IP session 0.
+
+Multiplexed IP sessions (IPS)
+-----------------------------
+IOSM driver allows multiplexing of several IP sessions over the single network
+device of type wwan0. IOSM driver models such IP sessions as 802.1q VLAN
+subdevices of the master wwanY device, mapping MBIM IP session M to VLAN ID M
+for all values of M greater than 0.
+
+The userspace management application is responsible for adding new VLAN links
+prior to establishing MBIM IP sessions where the SessionId is greater than 0.
+These links can be added by using the normal VLAN kernel interfaces.
+
+For example, adding a link for a MBIM IP session with SessionId 5:
+
+  ip link add link wwan0 name wwan0.<name> type vlan id 5
+
+The driver will automatically map the "wwan0.<name>" network device to MBIM
+IP session 5.
+
+References
+==========
+
+[1] "MBIM (Mobile Broadband Interface Model) Registry"
+       - http://compliance.usb.org/mbim/
+
+[2] libmbim - "a glib-based library for talking to WWAN modems and
+      devices which speak the Mobile Interface Broadband Model (MBIM)
+      protocol"
+      - http://www.freedesktop.org/wiki/Software/libmbim/
+
+[3] ModemManager - "a DBus-activated daemon which controls mobile
+      broadband (2G/3G/4G) devices and connections"
+      - http://www.freedesktop.org/wiki/Software/ModemManager/
\ No newline at end of file
-- 
2.12.3

