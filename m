Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024D41C7668
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbgEFQb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:31:29 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:42226 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730084AbgEFQal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:30:41 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GUbeq085533;
        Wed, 6 May 2020 11:30:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782637;
        bh=5IdENYjYwmQsxACLdk47f1af5gdSikuYQm2dA5NOqvw=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=YPa2ZwnjOCywJARJBp/5+CoZkPJutkZefOArv0gm4bM3dlBgkSMBRu2s172zbzg3o
         fnyYKEChFKHI9eXq1yag8nz1GbtnKiYrHSBSWSnNRQy35d9vGYW5++MtzV4XjFoTLL
         1PJgaY1llP0pTSDB0ImRwJp39XpoQFkgCeWQiTnc=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046GUbPr021949
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 11:30:37 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:30:37 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:30:37 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUXDk119719;
        Wed, 6 May 2020 11:30:37 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 07/13] net: hsr: introduce common uapi include/definitions for HSR and PRP
Date:   Wed, 6 May 2020 12:30:27 -0400
Message-ID: <20200506163033.3843-8-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506163033.3843-1-m-karicheri2@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are many commonalities between HSR and PRP protocols except for
the fact that HSR uses Tag as a prefix vs RCT (Redundancy Control Trail)
as a trailer for PRP. Few of the commonalities to name are:- both uses
a pair of Ethernet interfaces, can be set up the same way from user
space using ip link command, Same Multicast MAC address for Supervision
frames, similar mechanism for redundancy, duplicate and discard using
tag/rct etc. So this patch introduces a common user space API in
if_link.h with a HSR_PRP prefix and common hsr_prp_netlink.h for
protocol specific interface configuration.  It is assumed that the old
definitions and include file for HSR may be obsoleted at some time
future (TBD) once all applications migrate to the new API.
IFLA_HSR_PRP_SUPERVISION_ADDR is the MC address for Supervision Frames
(SF), so use the name IFLA_HSR_PRP_SF_MC_ADDR instead to make it shorter
and also change IFLA_HSR_PRP_MULTICAST_SPEC to
IFLA_HSR_PRP_SF_MC_ADDR_LSB as it is the last byte of the MC address
used by Supervision frames.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 include/uapi/linux/hsr_netlink.h     |  3 ++
 include/uapi/linux/hsr_prp_netlink.h | 50 ++++++++++++++++++++++++++++
 include/uapi/linux/if_link.h         | 19 +++++++++++
 3 files changed, 72 insertions(+)
 create mode 100644 include/uapi/linux/hsr_prp_netlink.h

diff --git a/include/uapi/linux/hsr_netlink.h b/include/uapi/linux/hsr_netlink.h
index c218ef9c35dd..54650ffca2be 100644
--- a/include/uapi/linux/hsr_netlink.h
+++ b/include/uapi/linux/hsr_netlink.h
@@ -14,6 +14,9 @@
 #ifndef __UAPI_HSR_NETLINK_H
 #define __UAPI_HSR_NETLINK_H
 
+/* This file will become obsolete soon!!! Start using hsr_prp_netlink.h
+ * instead
+ */
 /* Generic Netlink HSR family definition
  */
 
diff --git a/include/uapi/linux/hsr_prp_netlink.h b/include/uapi/linux/hsr_prp_netlink.h
new file mode 100644
index 000000000000..17865cf14432
--- /dev/null
+++ b/include/uapi/linux/hsr_prp_netlink.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* prp_prp_netlink.h: This is based on hsr_netlink.h from Arvid Brodin,
+ * arvid.brodin@alten.se
+ *
+ * Copyright 2011-2014 Autronica Fire and Security AS
+ * Copyright (C) 2020 Texas Instruments Incorporated
+ *
+ * Author(s):
+ *	2011-2014 Arvid Brodin, arvid.brodin@alten.se
+ *	2020 Murali Karicheri <m-karicheri2@ti.com>
+ */
+
+#ifndef __UAPI_HSR_PRP_NETLINK_H
+#define __UAPI_HSR_PRP_NETLINK_H
+
+/* Generic Netlink HSR/PRP family definition
+ */
+
+/* attributes */
+enum {
+	HSR_PRP_A_UNSPEC,
+	HSR_PRP_A_NODE_ADDR,
+	HSR_PRP_A_IFINDEX,
+	HSR_PRP_A_IF1_AGE,
+	HSR_PRP_A_IF2_AGE,
+	HSR_PRP_A_NODE_ADDR_B,
+	HSR_PRP_A_IF1_SEQ,
+	HSR_PRP_A_IF2_SEQ,
+	HSR_PRP_A_IF1_IFINDEX,
+	HSR_PRP_A_IF2_IFINDEX,
+	HSR_PRP_A_ADDR_B_IFINDEX,
+	__HSR_PRP_A_MAX,
+};
+#define HSR_PRP_A_MAX (__HSR_PRP_A_MAX - 1)
+
+
+/* commands */
+enum {
+	HSR_PRP_C_UNSPEC,
+	HSR_PRP_C_RING_ERROR, /* only for HSR for now */
+	HSR_PRP_C_NODE_DOWN,
+	HSR_PRP_C_GET_NODE_STATUS,
+	HSR_PRP_C_SET_NODE_STATUS,
+	HSR_PRP_C_GET_NODE_LIST,
+	HSR_PRP_C_SET_NODE_LIST,
+	__HSR_PRP_C_MAX,
+};
+#define HSR_PRP_C_MAX (__HSR_PRP_C_MAX - 1)
+
+#endif /* __UAPI_HSR_PRP_NETLINK_H */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index a009365ad67b..520537f35dcb 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -906,6 +906,8 @@ enum {
 #define IFLA_IPOIB_MAX (__IFLA_IPOIB_MAX - 1)
 
 
+/* Will become obsolete soon!!!  Replaced with IFLA_HSR_PRP* prefix below */
+
 /* HSR section */
 
 enum {
@@ -1055,4 +1057,21 @@ struct ifla_rmnet_flags {
 	__u32	mask;
 };
 
+/* New definitions below to replace the HSR_ prefixed ones for HSR and PRP.
+ * It is expected to migrate all applications to this and obsolete the
+ * HSR specific definitions used currently.
+ */
+enum {
+	IFLA_HSR_PRP_UNSPEC,
+	IFLA_HSR_PRP_SLAVE1,
+	IFLA_HSR_PRP_SLAVE2,
+	IFLA_HSR_PRP_SF_MC_ADDR_LSB,  /* Last byte of supervision addr */
+	IFLA_HSR_PRP_SF_MC_ADDR,      /* Supervision frame multicast addr */
+	IFLA_HSR_PRP_SEQ_NR,
+	IFLA_HSR_PRP_VERSION,		/* HSR version */
+	__IFLA_HSR_PRP_MAX,
+};
+
+#define IFLA_HSR_PRP_MAX (__IFLA_HSR_PRP_MAX - 1)
+
 #endif /* _UAPI_LINUX_IF_LINK_H */
-- 
2.17.1

