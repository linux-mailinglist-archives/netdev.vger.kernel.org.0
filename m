Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB3521023E1
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 13:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfKSMHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 07:07:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:50878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727702AbfKSMHD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 07:07:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1C85EBAF7;
        Tue, 19 Nov 2019 12:07:01 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: ipconfig: Make device wait timeout configurable
Date:   Tue, 19 Nov 2019 13:06:46 +0100
Message-Id: <20191119120647.31547-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If network device drivers are using deferred probing it's possible
that waiting for devices to show up in ipconfig is already over,
when the device eventually shows up. With the new netdev_max_wait
kernel cmdline pataremter it's now possible to extend this time.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 Documentation/admin-guide/kernel-parameters.txt |  5 +++++
 net/ipv4/ipconfig.c                             | 22 +++++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a84a83f8881e..6083ac04f075 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2755,6 +2755,11 @@
 			This usage is only documented in each driver source
 			file if at all.
 
+	netdev_max_wait=
+			[IP_PNP] set the maximum time in seconds to wait
+			for net devices showing up, when doing kernel
+			IP configuration
+
 	nf_conntrack.acct=
 			[NETFILTER] Enable connection tracking flow accounting
 			0 to disable accounting
diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 9bcca08efec9..851ea8239f5f 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -103,6 +103,9 @@
 /* Wait for carrier timeout default in seconds */
 static unsigned int carrier_timeout = 120;
 
+/* Wait for devices to show up in seconds */
+static unsigned int device_max_wait = 12;
+
 /*
  * Public IP configuration
  */
@@ -1402,13 +1405,11 @@ __be32 __init root_nfs_parse_addr(char *name)
 	return addr;
 }
 
-#define DEVICE_WAIT_MAX		12 /* 12 seconds */
-
 static int __init wait_for_devices(void)
 {
 	int i;
 
-	for (i = 0; i < DEVICE_WAIT_MAX; i++) {
+	for (i = 0; i < device_max_wait; i++) {
 		struct net_device *dev;
 		int found = 0;
 
@@ -1797,3 +1798,18 @@ static int __init set_carrier_timeout(char *str)
 	return 1;
 }
 __setup("carrier_timeout=", set_carrier_timeout);
+
+static int __init set_device_max_wait(char *str)
+{
+	ssize_t ret;
+
+	if (!str)
+		return 0;
+
+	ret = kstrtouint(str, 0, &device_max_wait);
+	if (ret)
+		return 0;
+
+	return 1;
+}
+__setup("netdev_max_wait=", set_device_max_wait);
-- 
2.16.4

