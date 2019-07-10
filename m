Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C31AE6466A
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 14:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfGJMkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 08:40:05 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37238 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726458AbfGJMkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 08:40:04 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 10 Jul 2019 15:39:58 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x6ACdtr8020922;
        Wed, 10 Jul 2019 15:39:57 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org, jiri@mellanox.com,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next iproute2 v2 2/2] devlink: Introduce PCI PF and VF port flavour and attribute
Date:   Wed, 10 Jul 2019 07:39:52 -0500
Message-Id: <20190710123952.6877-2-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190710123952.6877-1-parav@mellanox.com>
References: <20190701183017.25407-1-parav@mellanox.com>
 <20190710123952.6877-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce PCI PF and VF port flavour and port attributes such as PF
number and VF number.

$ devlink port show
pci/0000:05:00.0/0: type eth netdev eth0 flavour pcipf pfnum 0
pci/0000:05:00.0/1: type eth netdev eth1 flavour pcivf pfnum 0 vfnum 0
pci/0000:05:00.0/2: type eth netdev eth2 flavour pcivf pfnum 0 vfnum 1

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
Changelog:
v1->v2:
 - Instead of if-else using switch-case.
 - Split patch to two patches to have kernel header update in dedicated
   patch.
---
 devlink/devlink.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index ac8c0fb1..d8197ea3 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2794,11 +2794,29 @@ static const char *port_flavour_name(uint16_t flavour)
 		return "cpu";
 	case DEVLINK_PORT_FLAVOUR_DSA:
 		return "dsa";
+	case DEVLINK_PORT_FLAVOUR_PCI_PF:
+		return "pcipf";
+	case DEVLINK_PORT_FLAVOUR_PCI_VF:
+		return "pcivf";
 	default:
 		return "<unknown flavour>";
 	}
 }
 
+static void pr_out_port_pfvf_num(struct dl *dl, struct nlattr **tb)
+{
+	uint16_t fn_num;
+
+	if (tb[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]) {
+		fn_num = mnl_attr_get_u16(tb[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]);
+		pr_out_uint(dl, "pfnum", fn_num);
+	}
+	if (tb[DEVLINK_ATTR_PORT_PCI_VF_NUMBER]) {
+		fn_num = mnl_attr_get_u16(tb[DEVLINK_ATTR_PORT_PCI_VF_NUMBER]);
+		pr_out_uint(dl, "vfnum", fn_num);
+	}
+}
+
 static void pr_out_port(struct dl *dl, struct nlattr **tb)
 {
 	struct nlattr *pt_attr = tb[DEVLINK_ATTR_PORT_TYPE];
@@ -2828,6 +2846,15 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
 				mnl_attr_get_u16(tb[DEVLINK_ATTR_PORT_FLAVOUR]);
 
 		pr_out_str(dl, "flavour", port_flavour_name(port_flavour));
+
+		switch (port_flavour) {
+		case DEVLINK_PORT_FLAVOUR_PCI_PF:
+		case DEVLINK_PORT_FLAVOUR_PCI_VF:
+			pr_out_port_pfvf_num(dl, tb);
+			break;
+		default:
+			break;
+		}
 	}
 	if (tb[DEVLINK_ATTR_PORT_NUMBER]) {
 		uint32_t port_number;
-- 
2.19.2

