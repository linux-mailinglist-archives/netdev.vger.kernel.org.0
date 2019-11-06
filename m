Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBBACF1CDC
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 18:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbfKFRym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 12:54:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29954 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726963AbfKFRym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 12:54:42 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA6HmbXR130780;
        Wed, 6 Nov 2019 12:53:18 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w41x4tfn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Nov 2019 12:53:17 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xA6Ho4Y6017465;
        Wed, 6 Nov 2019 17:53:16 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 2w41ujgj1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Nov 2019 17:53:16 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA6HrGSM34013612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Nov 2019 17:53:16 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEC4928060;
        Wed,  6 Nov 2019 17:53:15 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 776892805C;
        Wed,  6 Nov 2019 17:53:15 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.85.194.118])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  6 Nov 2019 17:53:15 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     linuxppc-dev@ozlabs.org
Cc:     netdev@vger.kernel.org, nathanl@linux.ibm.com,
        tyreld@linux.ibm.com, msuchanek@suse.com, ruscur@russell.cc,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: [RFC PATCH v2] powerpc/pseries/mobility: notify network peers after migration
Date:   Wed,  6 Nov 2019 11:53:11 -0600
Message-Id: <1573062791-31276-1-git-send-email-tlfalcon@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-06_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911060172
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After a migration, it is necessary to send a gratuitous ARP
from all running interfaces so that the rest of the network
is aware of its new location. However, some supported network
devices are unaware that they have been migrated. To avoid network
interruptions and other unwanted behavior, force a GARP on all
valid, running interfaces as part of the post_mobility_fixup
routine.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
v2: fix missing brackets caught by Russell Currey
---
 arch/powerpc/platforms/pseries/mobility.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
index b571285..dddc3c1 100644
--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -17,6 +17,9 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/stringify.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+#include <net/net_namespace.h>
 
 #include <asm/machdep.h>
 #include <asm/rtas.h>
@@ -331,6 +334,8 @@ void post_mobility_fixup(void)
 {
 	int rc;
 	int activate_fw_token;
+	struct net_device *netdev;
+	struct net *net;
 
 	activate_fw_token = rtas_token("ibm,activate-firmware");
 	if (activate_fw_token == RTAS_UNKNOWN_SERVICE) {
@@ -371,6 +376,22 @@ void post_mobility_fixup(void)
 	/* Possibly switch to a new RFI flush type */
 	pseries_setup_rfi_flush();
 
+	/* need to force a gratuitous ARP on running interfaces */
+	rtnl_lock();
+	for_each_net(net) {
+		for_each_netdev(net, netdev) {
+			if (netif_device_present(netdev) &&
+			    netif_running(netdev) &&
+			    !(netdev->flags & (IFF_NOARP | IFF_LOOPBACK))) {
+				call_netdevice_notifiers(NETDEV_NOTIFY_PEERS,
+							 netdev);
+				call_netdevice_notifiers(NETDEV_RESEND_IGMP,
+							 netdev);
+			}
+		}
+	}
+	rtnl_unlock();
+
 	return;
 }
 
-- 
1.8.3.1

