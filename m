Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E38C5C303
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfGASa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:30:26 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35045 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726076AbfGASa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 14:30:26 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 1 Jul 2019 21:30:24 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x61IUMPv004959;
        Mon, 1 Jul 2019 21:30:23 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, jakub.kicinski@netronome.com,
        jiri@mellanox.com, Parav Pandit <parav@mellanox.com>
Subject: [RESEND PATCH iproute2 net-next] devlink: Introduce PCI PF and VF port flavour and attribute
Date:   Mon,  1 Jul 2019 13:30:17 -0500
Message-Id: <20190701183017.25407-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190701122734.18770-1-parav@mellanox.com>
References: <20190701122734.18770-1-parav@mellanox.com>
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

Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 devlink/devlink.c            | 23 +++++++++++++++++++++++
 include/uapi/linux/devlink.h | 11 +++++++++++
 2 files changed, 34 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 559f624e..15493426 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2771,6 +2771,10 @@ static const char *port_flavour_name(uint16_t flavour)
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
@@ -2803,8 +2807,27 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
 	if (tb[DEVLINK_ATTR_PORT_FLAVOUR]) {
 		uint16_t port_flavour =
 				mnl_attr_get_u16(tb[DEVLINK_ATTR_PORT_FLAVOUR]);
+		uint16_t pf_vf;
 
 		pr_out_str(dl, "flavour", port_flavour_name(port_flavour));
+		if (port_flavour == DEVLINK_PORT_FLAVOUR_PCI_PF) {
+			if (tb[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]) {
+				pf_vf = mnl_attr_get_u16(
+					tb[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]);
+				pr_out_uint(dl, "pfnum", pf_vf);
+			}
+		} else if (port_flavour == DEVLINK_PORT_FLAVOUR_PCI_VF) {
+			if (tb[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]) {
+				pf_vf = mnl_attr_get_u16(
+					tb[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]);
+				pr_out_uint(dl, "pfnum", pf_vf);
+			}
+			if (tb[DEVLINK_ATTR_PORT_PCI_VF_NUMBER]) {
+				pf_vf = mnl_attr_get_u16(
+					tb[DEVLINK_ATTR_PORT_PCI_VF_NUMBER]);
+				pr_out_uint(dl, "vfnum", pf_vf);
+			}
+		}
 	}
 	if (tb[DEVLINK_ATTR_PORT_SPLIT_GROUP])
 		pr_out_uint(dl, "split_group",
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 6544824a..fc195cbd 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -169,6 +169,14 @@ enum devlink_port_flavour {
 	DEVLINK_PORT_FLAVOUR_DSA, /* Distributed switch architecture
 				   * interconnect port.
 				   */
+	DEVLINK_PORT_FLAVOUR_PCI_PF, /* Represents eswitch port for
+				      * the PCI PF. It is an internal
+				      * port that faces the PCI PF.
+				      */
+	DEVLINK_PORT_FLAVOUR_PCI_VF, /* Represents eswitch port
+				      * for the PCI VF. It is an internal
+				      * port that faces the PCI VF.
+				      */
 };
 
 enum devlink_param_cmode {
@@ -337,6 +345,9 @@ enum devlink_attr {
 	DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,	/* u64 */
 	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,	/* u64 */
 
+	DEVLINK_ATTR_PORT_PCI_PF_NUMBER,	/* u16 */
+	DEVLINK_ATTR_PORT_PCI_VF_NUMBER,	/* u16 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.19.2

