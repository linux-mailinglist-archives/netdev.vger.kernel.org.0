Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97083E0AE3
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732201AbfJVRnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:43:22 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55823 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731897AbfJVRnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:43:22 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 19:43:17 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MHhGSa005567;
        Tue, 22 Oct 2019 20:43:16 +0300
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id x9MHhG5K023983;
        Tue, 22 Oct 2019 20:43:16 +0300
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id x9MHhGK4023982;
        Tue, 22 Oct 2019 20:43:16 +0300
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next 2/9] devlink: Add PCI attributes support for vdev
Date:   Tue, 22 Oct 2019 20:43:03 +0300
Message-Id: <1571766190-23943-3-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When vdev represents a PCI device it should reflect the PCI device
type (PF/VF) and it's index.

Example:

$ devlink vdev show pci/0000:03:00.0/1 -jp
{
    "vdev": {
        "pci/0000:03:00.0/1": {
            "flavour": "pcivf",
            "pf": 0,
            "vf": 0
        }
    }
}

$ devlink vdev show pci/0000:03:00.0/1
pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h        | 17 ++++++++++++
 include/uapi/linux/devlink.h |  8 ++++++
 net/core/devlink.c           | 51 ++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 58fe8c339368..ab7e316ea758 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -92,7 +92,21 @@ struct devlink_port {
 	struct delayed_work type_warn_dw;
 };
 
+struct devlink_vdev_pci_pf_attrs {
+	u16 pf;	/* Associated PCI PF for this vdev. */
+};
+
+struct devlink_vdev_pci_vf_attrs {
+	u16 pf;	/* Associated PCI PF for this vdev. */
+	u16 vf;	/* Associated PCI VF for of the PCI PF for this vdev. */
+};
+
 struct devlink_vdev_attrs {
+	enum devlink_vdev_flavour flavour;
+	union {
+		struct devlink_vdev_pci_pf_attrs pci_pf;
+		struct devlink_vdev_pci_vf_attrs pci_vf;
+	};
 };
 
 struct devlink_sb_pool_info {
@@ -819,6 +833,9 @@ struct devlink_vdev *devlink_vdev_create(struct devlink *devlink,
 void devlink_vdev_destroy(struct devlink_vdev *devlink_vdev);
 struct devlink *devlink_vdev_devlink(struct devlink_vdev *devlink_vdev);
 void *devlink_vdev_priv(struct devlink_vdev *devlink_vdev);
+void devlink_vdev_attrs_pci_pf_init(struct devlink_vdev_attrs *attrs, u16 pf);
+void devlink_vdev_attrs_pci_vf_init(struct devlink_vdev_attrs *attrs, u16 pf,
+				    u16 vf);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 70e2816331c5..161bad54d528 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -194,6 +194,11 @@ enum devlink_port_flavour {
 				      */
 };
 
+enum devlink_vdev_flavour {
+	DEVLINK_VDEV_FLAVOUR_PCI_PF,
+	DEVLINK_VDEV_FLAVOUR_PCI_VF,
+};
+
 enum devlink_param_cmode {
 	DEVLINK_PARAM_CMODE_RUNTIME,
 	DEVLINK_PARAM_CMODE_DRIVERINIT,
@@ -431,6 +436,9 @@ enum devlink_attr {
 	DEVLINK_ATTR_NETNS_ID,			/* u32 */
 
 	DEVLINK_ATTR_VDEV_INDEX,		/* u32 */
+	DEVLINK_ATTR_VDEV_FLAVOUR,		/* u16 */
+	DEVLINK_ATTR_VDEV_PF_INDEX,		/* u32 */
+	DEVLINK_ATTR_VDEV_VF_INDEX,		/* u32 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 3d6099ec139e..0a201a373da9 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -708,6 +708,7 @@ static int devlink_nl_vdev_fill(struct sk_buff *msg, struct devlink *devlink,
 				enum devlink_command cmd, u32 vdevid,
 				u32 seq, int flags)
 {
+	struct devlink_vdev_attrs *attrs = &devlink_vdev->attrs;
 	void *hdr;
 
 	hdr = genlmsg_put(msg, vdevid, seq, &devlink_nl_family, flags, cmd);
@@ -719,6 +720,24 @@ static int devlink_nl_vdev_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (nla_put_u32(msg, DEVLINK_ATTR_VDEV_INDEX, devlink_vdev->index))
 		goto nla_put_failure;
 
+	if (nla_put_u16(msg, DEVLINK_ATTR_VDEV_FLAVOUR, attrs->flavour))
+		goto nla_put_failure;
+	switch (attrs->flavour) {
+	case DEVLINK_VDEV_FLAVOUR_PCI_PF:
+		if (nla_put_u32(msg, DEVLINK_ATTR_VDEV_PF_INDEX,
+				attrs->pci_pf.pf))
+			goto nla_put_failure;
+		break;
+	case DEVLINK_VDEV_FLAVOUR_PCI_VF:
+		if (nla_put_u32(msg, DEVLINK_ATTR_VDEV_PF_INDEX,
+				attrs->pci_vf.pf))
+			goto nla_put_failure;
+		if (nla_put_u32(msg, DEVLINK_ATTR_VDEV_VF_INDEX,
+				attrs->pci_vf.vf))
+			goto nla_put_failure;
+		break;
+	}
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -6077,6 +6096,9 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_NETNS_ID] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_VDEV_INDEX] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_VDEV_FLAVOUR] = { .type = NLA_U16 },
+	[DEVLINK_ATTR_VDEV_PF_INDEX] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_VDEV_VF_INDEX] = { .type = NLA_U32 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -6912,6 +6934,35 @@ void devlink_vdev_destroy(struct devlink_vdev *devlink_vdev)
 }
 EXPORT_SYMBOL_GPL(devlink_vdev_destroy);
 
+/**
+ *	devlink_vdev_attrs_pci_pf_int - Init PCI PF vdev attributes
+ *
+ *	@devlink_vdev_attr: devlink vdev attributes
+ *	@pf: associated PF index for the devlink vdev instance
+ */
+void devlink_vdev_attrs_pci_pf_init(struct devlink_vdev_attrs *attrs, u16 pf)
+{
+	attrs->flavour = DEVLINK_VDEV_FLAVOUR_PCI_PF;
+	attrs->pci_pf.pf = pf;
+}
+EXPORT_SYMBOL_GPL(devlink_vdev_attrs_pci_pf_init);
+
+/**
+ *	devlink_vdev_attrs_pci_vf_init - Init PCI VF vdev attributes
+ *
+ *	@devlink_vdev: devlink vdev
+ *	@pf: associated PF index for the devlink vdev instance
+ *	@vf: associated VF index for the devlink vdev instance
+ */
+void devlink_vdev_attrs_pci_vf_init(struct devlink_vdev_attrs *attrs, u16 pf,
+				    u16 vf)
+{
+	attrs->flavour = DEVLINK_VDEV_FLAVOUR_PCI_VF;
+	attrs->pci_vf.pf = pf;
+	attrs->pci_vf.vf = vf;
+}
+EXPORT_SYMBOL_GPL(devlink_vdev_attrs_pci_vf_init);
+
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
-- 
2.17.1

