Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8053B9CA9
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 08:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhGBHCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 03:02:08 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:28526 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229542AbhGBHCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 03:02:08 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jul 2021 03:02:08 EDT
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 1 Jul 2021 23:44:31 -0700
Received: from ubuntu.eng.vmware.com (unknown [10.20.114.115])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id E31572008F;
        Thu,  1 Jul 2021 23:44:34 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net] vmxnet3: fix cksum offload issues for tunnels with non-default udp ports
Date:   Thu, 1 Jul 2021 23:44:27 -0700
Message-ID: <20210702064427.32378-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
support") added support for encapsulation offload. However, the inner
offload capability is to be restricted to UDP tunnels with default
Vxlan and Geneve ports.

This patch fixes the issue for tunnels with non-default ports using
features check capability and filtering appropriate features for such
tunnels.

Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index c0bd9cbc43b1..1b483cf2b1ca 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's vmxnet3 ethernet NIC.
  *
- * Copyright (C) 2008-2020, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2021, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -26,6 +26,10 @@
 
 
 #include "vmxnet3_int.h"
+#include <net/vxlan.h>
+#include <net/geneve.h>
+
+#define VXLAN_UDP_PORT 8472
 
 struct vmxnet3_stat_desc {
 	char desc[ETH_GSTRING_LEN];
@@ -262,6 +266,8 @@ netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
 	if (VMXNET3_VERSION_GE_4(adapter) &&
 	    skb->encapsulation && skb->ip_summed == CHECKSUM_PARTIAL) {
 		u8 l4_proto = 0;
+		u16 port;
+		struct udphdr *udph;
 
 		switch (vlan_get_protocol(skb)) {
 		case htons(ETH_P_IP):
@@ -274,8 +280,20 @@ netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
 			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 		}
 
-		if (l4_proto != IPPROTO_UDP)
+		switch (l4_proto) {
+		case IPPROTO_UDP:
+			udph = udp_hdr(skb);
+			port = be16_to_cpu(udph->dest);
+			/* Check if offloaded port is supported */
+			if (port != GENEVE_UDP_PORT &&
+			    port != IANA_VXLAN_UDP_PORT &&
+			    port != VXLAN_UDP_PORT) {
+				return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			}
+			break;
+		default:
 			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		}
 	}
 	return features;
 }
-- 
2.11.0

