Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A5D3EDAB7
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 18:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhHPQSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 12:18:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:27628 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231136AbhHPQSZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 12:18:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="203046327"
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="203046327"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 09:17:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="487524311"
Received: from amlin-018-053.igk.intel.com ([10.102.18.53])
  by fmsmga008.fm.intel.com with ESMTP; 16 Aug 2021 09:17:49 -0700
From:   Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
To:     linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        shuah@kernel.org, arkadiusz.kubalewski@intel.com, arnd@arndb.de,
        nikolay@nvidia.com, cong.wang@bytedance.com,
        colin.king@canonical.com, gustavoars@kernel.org
Subject: [RFC net-next 5/7] selftests/net: Add test app for SIOC{S|G}SYNCE
Date:   Mon, 16 Aug 2021 18:07:15 +0200
Message-Id: <20210816160717.31285-6-arkadiusz.kubalewski@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test usage of new netdev IOCTLs: SIOCSSYNCE and SIOCGSYNCE.

Allow set or get the netdev driver configuration
of PHY reference clock on output pins.

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 tools/testing/selftests/net/Makefile      |   1 +
 tools/testing/selftests/net/phy_ref_clk.c | 138 ++++++++++++++++++++++
 2 files changed, 139 insertions(+)
 create mode 100644 tools/testing/selftests/net/phy_ref_clk.c

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 4f9f73e7a299..ace9a5130478 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -39,6 +39,7 @@ TEST_GEN_FILES += hwtstamp_config rxtimestamp timestamping txtimestamp
 TEST_GEN_FILES += ipsec
 TEST_GEN_FILES += ioam6_parser
 TEST_GEN_FILES += gro
+TEST_GEN_FILES += phy_ref_clk
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
 TEST_GEN_FILES += toeplitz
diff --git a/tools/testing/selftests/net/phy_ref_clk.c b/tools/testing/selftests/net/phy_ref_clk.c
new file mode 100644
index 000000000000..dc07cf3d4569
--- /dev/null
+++ b/tools/testing/selftests/net/phy_ref_clk.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * This program allows to test behavior of netdev after sending
+ * SyncE related ioctl: SIOCGSYNCE and SIOCSSYNCE.
+ * SIOCGSYNCE - was designed to check how output pin on PHY port
+ * was configured.
+ * SIOCSSYNCE - was designed to configure (enable or disable)
+ * one of the pins, that PHY can propagate its recovered clock
+ * signal onto.
+ *
+ * Copyright (C) 2021 Intel Corporation.
+ * Author: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/socket.h>
+#include <sys/ioctl.h>
+#include <arpa/inet.h>
+#include <net/if.h>
+
+#include <asm/types.h>
+#include <linux/sockios.h>
+#include <linux/net_synce.h>
+
+static void usage(const char *error)
+{
+	if (error)
+		printf("invalid: %s\n\n", error);
+	printf("phy_ref_clk <interface> <pin_id> [enable]\n\n"
+		"Enable or disable phy-recovered reference clock signal on given output pin.\n"
+		"Depending on HW configuration, phy recovered clock may be enabled\n"
+		"or disabled on one of output pins which are at hardware's disposal\n\n"
+		"Params:\n"
+		" <interface> - name of netdev implementing SIOCGSYNCE and SIOCSSYNCE\n"
+		" <pin_id> - pin on which clock recovered from PHY shall be propagated\n"
+		"    (0-X), X - number of output pins at HW disposal\n"
+		" In case no other arguments are given, ask the driver\n"
+		" for the current config of recovered clock on the interface.\n\n"
+		" [enable] - if pin shal be enabled or disabled (0/1)\n\n");
+	exit(1);
+}
+
+static int get_ref_clk(const char *ifname, __u8 pin)
+{
+	struct synce_ref_clk_cfg ref_clk;
+	struct ifreq ifdata;
+	int sd, rc;
+
+	if (!ifname || *ifname == '\0')
+		return -1;
+
+	memset(&ifdata, 0, sizeof(ifdata));
+
+	strncpy(ifdata.ifr_name, ifname, IFNAMSIZ);
+
+	sd = socket(PF_INET, SOCK_DGRAM, IPPROTO_IP);
+	if (sd < 0) {
+		printf("socket failed\n");
+		return -1;
+	}
+
+	ref_clk.pin_id = pin;
+	ifdata.ifr_data = (void *)&ref_clk;
+
+	rc = ioctl(sd, SIOCGSYNCE, (char *)&ifdata);
+	close(sd);
+	if (rc != 0) {
+		printf("ioctl(SIOCGSYNCE) failed\n");
+		return rc;
+	}
+	printf("GET: pin %u is %s\n",
+		ref_clk.pin_id, ref_clk.enable ? "enabled" : "disabled");
+
+	return 0;
+}
+
+static int set_ref_clk(const char *ifname, __u8 pin, _Bool enable)
+{
+	struct synce_ref_clk_cfg ref_clk;
+	struct ifreq ifdata;
+	int sd, rc;
+
+	if (!ifname || *ifname == '\0')
+		return -1;
+
+	memset(&ifdata, 0, sizeof(ifdata));
+
+	strcpy(ifdata.ifr_name, ifname);
+
+	sd = socket(PF_INET, SOCK_DGRAM, IPPROTO_IP);
+	if (sd < 0) {
+		printf("socket failed\n");
+		return -1;
+	}
+
+	ref_clk.pin_id = pin;
+	ref_clk.enable = enable;
+	ifdata.ifr_data = (void *)&ref_clk;
+
+	rc = ioctl(sd, SIOCSSYNCE, (char *)&ifdata);
+	close(sd);
+	if (rc != 0) {
+		printf("ioctl(SIOCSSYNCE) failed\n");
+		return rc;
+	}
+	printf("SET: pin %u is %s",
+	       ref_clk.pin_id, ref_clk.enable ? "enabled" : "disabled");
+
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	_Bool enable;
+	__u8 pin;
+	int ret;
+
+	if (argc > 4 || argc < 3)
+		usage("argument count");
+
+	ret = sscanf(argv[2], "%u", &pin);
+	if (ret != 1)
+		usage(argv[2]);
+
+	if (argc == 3) {
+		ret = get_ref_clk(argv[1], pin);
+	} else if (argc == 4) {
+		ret = sscanf(argv[3], "%u", &enable);
+		if (ret != 1)
+			usage(argv[3]);
+		ret = set_ref_clk(argv[1], pin, enable);
+	}
+	return ret;
+}
-- 
2.24.0

