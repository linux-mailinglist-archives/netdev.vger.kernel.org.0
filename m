Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67655F50E0
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfKHQTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:19:02 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60266 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726095AbfKHQTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 11:19:01 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Nov 2019 18:18:56 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA8GIsvr003120;
        Fri, 8 Nov 2019 18:18:55 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id xA8GIsbF030083;
        Fri, 8 Nov 2019 18:18:54 +0200
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id xA8GIsgb030082;
        Fri, 8 Nov 2019 18:18:54 +0200
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, danielj@mellanox.com, parav@mellanox.com,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next v2 02/10] devlink: Add PCI attributes support for subdev
Date:   Fri,  8 Nov 2019 18:18:38 +0200
Message-Id: <1573229926-30040-3-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When subdev represents a PCI device it should reflect the PCI device
type (PF/VF) and it's index.

Example:

$ devlink subdev show pci/0000:03:00.0/1 -jp
{
    "subdev": {
        "pci/0000:03:00.0/1": {
            "flavour": "pcivf",
            "pf": 0,
            "vf": 0
        }
    }
}

$ devlink subdev show pci/0000:03:00.0/1
pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h        | 18 +++++++++++++
 include/uapi/linux/devlink.h |  8 ++++++
 net/core/devlink.c           | 52 ++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 9d6b50b906ee..1e12a9be5c23 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -92,7 +92,21 @@ struct devlink_port {
 	struct delayed_work type_warn_dw;
 };
 
+struct devlink_subdev_pci_pf_attrs {
+	u16 pf;	/* Associated PCI PF for this subdev. */
+};
+
+struct devlink_subdev_pci_vf_attrs {
+	u16 pf;	/* Associated PCI PF for this subdev. */
+	u16 vf;	/* Associated PCI VF for of the PCI PF for this subdev. */
+};
+
 struct devlink_subdev_attrs {
+	enum devlink_subdev_flavour flavour;
+	union {
+		struct devlink_subdev_pci_pf_attrs pci_pf;
+		struct devlink_subdev_pci_vf_attrs pci_vf;
+	};
 };
 
 struct devlink_sb_pool_info {
@@ -820,6 +834,10 @@ devlink_subdev_create(struct devlink *devlink,
 void devlink_subdev_destroy(struct devlink_subdev *devlink_subdev);
 struct devlink *devlink_subdev_devlink(struct devlink_subdev *devlink_subdev);
 void *devlink_subdev_priv(struct devlink_subdev *devlink_subdev);
+void devlink_subdev_attrs_pci_pf_init(struct devlink_subdev_attrs *attrs,
+				      u16 pf);
+void devlink_subdev_attrs_pci_vf_init(struct devlink_subdev_attrs *attrs,
+				      u16 pf, u16 vf);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index df894091f26a..da79ffad9c5a 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -194,6 +194,11 @@ enum devlink_port_flavour {
 				      */
 };
 
+enum devlink_subdev_flavour {
+	DEVLINK_SUBDEV_FLAVOUR_PCI_PF,
+	DEVLINK_SUBDEV_FLAVOUR_PCI_VF,
+};
+
 enum devlink_param_cmode {
 	DEVLINK_PARAM_CMODE_RUNTIME,
 	DEVLINK_PARAM_CMODE_DRIVERINIT,
@@ -431,6 +436,9 @@ enum devlink_attr {
 	DEVLINK_ATTR_NETNS_ID,			/* u32 */
 
 	DEVLINK_ATTR_SUBDEV_INDEX,		/* u32 */
+	DEVLINK_ATTR_SUBDEV_FLAVOUR,		/* u16 */
+	DEVLINK_ATTR_SUBDEV_PF_INDEX,		/* u32 */
+	DEVLINK_ATTR_SUBDEV_VF_INDEX,		/* u32 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5ab2fc2f2d82..76f5fba7d242 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -708,6 +708,7 @@ static int devlink_nl_subdev_fill(struct sk_buff *msg, struct devlink *devlink,
 				  enum devlink_command cmd, u32 subdevid,
 				  u32 seq, int flags)
 {
+	struct devlink_subdev_attrs *attrs = &devlink_subdev->attrs;
 	void *hdr;
 
 	hdr = genlmsg_put(msg, subdevid, seq, &devlink_nl_family, flags, cmd);
@@ -719,6 +720,24 @@ static int devlink_nl_subdev_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (nla_put_u32(msg, DEVLINK_ATTR_SUBDEV_INDEX, devlink_subdev->index))
 		goto nla_put_failure;
 
+	if (nla_put_u16(msg, DEVLINK_ATTR_SUBDEV_FLAVOUR, attrs->flavour))
+		goto nla_put_failure;
+	switch (attrs->flavour) {
+	case DEVLINK_SUBDEV_FLAVOUR_PCI_PF:
+		if (nla_put_u32(msg, DEVLINK_ATTR_SUBDEV_PF_INDEX,
+				attrs->pci_pf.pf))
+			goto nla_put_failure;
+		break;
+	case DEVLINK_SUBDEV_FLAVOUR_PCI_VF:
+		if (nla_put_u32(msg, DEVLINK_ATTR_SUBDEV_PF_INDEX,
+				attrs->pci_vf.pf))
+			goto nla_put_failure;
+		if (nla_put_u32(msg, DEVLINK_ATTR_SUBDEV_VF_INDEX,
+				attrs->pci_vf.vf))
+			goto nla_put_failure;
+		break;
+	}
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -6082,6 +6101,9 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_NETNS_ID] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_SUBDEV_INDEX] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_SUBDEV_FLAVOUR] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_SUBDEV_PF_INDEX] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_SUBDEV_VF_INDEX] = { .type = NLA_U32 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -6918,6 +6940,36 @@ void devlink_subdev_destroy(struct devlink_subdev *devlink_subdev)
 }
 EXPORT_SYMBOL_GPL(devlink_subdev_destroy);
 
+/**
+ *	devlink_subdev_attrs_pci_pf_int - Init PCI PF subdev attributes
+ *
+ *	@devlink_subdev_attr: devlink subdev attributes
+ *	@pf: associated PF index for the devlink subdev instance
+ */
+void devlink_subdev_attrs_pci_pf_init(struct devlink_subdev_attrs *attrs,
+				      u16 pf)
+{
+	attrs->flavour = DEVLINK_SUBDEV_FLAVOUR_PCI_PF;
+	attrs->pci_pf.pf = pf;
+}
+EXPORT_SYMBOL_GPL(devlink_subdev_attrs_pci_pf_init);
+
+/**
+ *	devlink_subdev_attrs_pci_vf_init - Init PCI VF subdev attributes
+ *
+ *	@devlink_subdev: devlink subdev
+ *	@pf: associated PF index for the devlink subdev instance
+ *	@vf: associated VF index for the devlink subdev instance
+ */
+void devlink_subdev_attrs_pci_vf_init(struct devlink_subdev_attrs *attrs,
+				      u16 pf, u16 vf)
+{
+	attrs->flavour = DEVLINK_SUBDEV_FLAVOUR_PCI_VF;
+	attrs->pci_vf.pf = pf;
+	attrs->pci_vf.vf = vf;
+}
+EXPORT_SYMBOL_GPL(devlink_subdev_attrs_pci_vf_init);
+
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
-- 
2.17.1

