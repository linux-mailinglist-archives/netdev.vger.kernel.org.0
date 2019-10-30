Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D381CEA7AA
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 00:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfJ3XTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 19:19:32 -0400
Received: from inva020.nxp.com ([92.121.34.13]:60412 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbfJ3XTb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 19:19:31 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B3F471A0491;
        Thu, 31 Oct 2019 00:19:28 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A6CC81A0292;
        Thu, 31 Oct 2019 00:19:28 +0100 (CET)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4F2A3205E9;
        Thu, 31 Oct 2019 00:19:28 +0100 (CET)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@armlinux.org.uk, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 2/5] bus: fsl-mc: add the fsl_mc_get_endpoint function
Date:   Thu, 31 Oct 2019 01:18:29 +0200
Message-Id: <1572477512-4618-3-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
References: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using the newly added fsl_mc_get_endpoint function a fsl-mc driver can
find its associated endpoint (another object at the other link of a MC
firmware link).

The API will be used in the following patch in order to discover the
connected DPMAC object of a DPNI.

Also, the fsl_mc_device_lookup function is made available to the entire
fsl-mc bus driver and not just for the dprc driver.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - use ENOTCONN instead of EINVAL
Changes in v3:
 - none
Changes in v4:
 - use ERR_PTR instead of plain NULL

 drivers/bus/fsl-mc/dprc-driver.c    |  6 ++---
 drivers/bus/fsl-mc/dprc.c           | 53 +++++++++++++++++++++++++++++++++++++
 drivers/bus/fsl-mc/fsl-mc-bus.c     | 33 +++++++++++++++++++++++
 drivers/bus/fsl-mc/fsl-mc-private.h | 42 +++++++++++++++++++++++++++++
 include/linux/fsl/mc.h              |  2 ++
 5 files changed, 132 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/fsl-mc/dprc-driver.c b/drivers/bus/fsl-mc/dprc-driver.c
index 52c7e15143d6..c8b1c3842c1a 100644
--- a/drivers/bus/fsl-mc/dprc-driver.c
+++ b/drivers/bus/fsl-mc/dprc-driver.c
@@ -104,10 +104,8 @@ static int __fsl_mc_device_match(struct device *dev, void *data)
 	return fsl_mc_device_match(mc_dev, obj_desc);
 }
 
-static struct fsl_mc_device *fsl_mc_device_lookup(struct fsl_mc_obj_desc
-								*obj_desc,
-						  struct fsl_mc_device
-								*mc_bus_dev)
+struct fsl_mc_device *fsl_mc_device_lookup(struct fsl_mc_obj_desc *obj_desc,
+					   struct fsl_mc_device *mc_bus_dev)
 {
 	struct device *dev;
 
diff --git a/drivers/bus/fsl-mc/dprc.c b/drivers/bus/fsl-mc/dprc.c
index 0fe3f52ae0de..602f030d84eb 100644
--- a/drivers/bus/fsl-mc/dprc.c
+++ b/drivers/bus/fsl-mc/dprc.c
@@ -554,3 +554,56 @@ int dprc_get_container_id(struct fsl_mc_io *mc_io,
 
 	return 0;
 }
+
+/**
+ * dprc_get_connection() - Get connected endpoint and link status if connection
+ *			exists.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPRC object
+ * @endpoint1:	Endpoint 1 configuration parameters
+ * @endpoint2:	Returned endpoint 2 configuration parameters
+ * @state:	Returned link state:
+ *		1 - link is up;
+ *		0 - link is down;
+ *		-1 - no connection (endpoint2 information is irrelevant)
+ *
+ * Return:     '0' on Success; -ENOTCONN if connection does not exist.
+ */
+int dprc_get_connection(struct fsl_mc_io *mc_io,
+			u32 cmd_flags,
+			u16 token,
+			const struct dprc_endpoint *endpoint1,
+			struct dprc_endpoint *endpoint2,
+			int *state)
+{
+	struct dprc_cmd_get_connection *cmd_params;
+	struct dprc_rsp_get_connection *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err, i;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_CONNECTION,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dprc_cmd_get_connection *)cmd.params;
+	cmd_params->ep1_id = cpu_to_le32(endpoint1->id);
+	cmd_params->ep1_interface_id = cpu_to_le16(endpoint1->if_id);
+	for (i = 0; i < 16; i++)
+		cmd_params->ep1_type[i] = endpoint1->type[i];
+
+	/* send command to mc */
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return -ENOTCONN;
+
+	/* retrieve response parameters */
+	rsp_params = (struct dprc_rsp_get_connection *)cmd.params;
+	endpoint2->id = le32_to_cpu(rsp_params->ep2_id);
+	endpoint2->if_id = le16_to_cpu(rsp_params->ep2_interface_id);
+	*state = le32_to_cpu(rsp_params->state);
+	for (i = 0; i < 16; i++)
+		endpoint2->type[i] = rsp_params->ep2_type[i];
+
+	return 0;
+}
diff --git a/drivers/bus/fsl-mc/fsl-mc-bus.c b/drivers/bus/fsl-mc/fsl-mc-bus.c
index bb3c2fc7c5ba..a07cc19becdb 100644
--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -712,6 +712,39 @@ void fsl_mc_device_remove(struct fsl_mc_device *mc_dev)
 }
 EXPORT_SYMBOL_GPL(fsl_mc_device_remove);
 
+struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device *mc_dev)
+{
+	struct fsl_mc_device *mc_bus_dev, *endpoint;
+	struct fsl_mc_obj_desc endpoint_desc = { 0 };
+	struct dprc_endpoint endpoint1 = { 0 };
+	struct dprc_endpoint endpoint2 = { 0 };
+	int state, err;
+
+	mc_bus_dev = to_fsl_mc_device(mc_dev->dev.parent);
+	strcpy(endpoint1.type, mc_dev->obj_desc.type);
+	endpoint1.id = mc_dev->obj_desc.id;
+
+	err = dprc_get_connection(mc_bus_dev->mc_io, 0,
+				  mc_bus_dev->mc_handle,
+				  &endpoint1, &endpoint2,
+				  &state);
+
+	if (err == -ENOTCONN || state == -1)
+		return ERR_PTR(-ENOTCONN);
+
+	if (err < 0) {
+		dev_err(&mc_bus_dev->dev, "dprc_get_connection() = %d\n", err);
+		return ERR_PTR(err);
+	}
+
+	strcpy(endpoint_desc.type, endpoint2.type);
+	endpoint_desc.id = endpoint2.id;
+	endpoint = fsl_mc_device_lookup(&endpoint_desc, mc_bus_dev);
+
+	return endpoint;
+}
+EXPORT_SYMBOL_GPL(fsl_mc_get_endpoint);
+
 static int parse_mc_ranges(struct device *dev,
 			   int *paddr_cells,
 			   int *mc_addr_cells,
diff --git a/drivers/bus/fsl-mc/fsl-mc-private.h b/drivers/bus/fsl-mc/fsl-mc-private.h
index 020fcc04ec8b..21ca8c756ee7 100644
--- a/drivers/bus/fsl-mc/fsl-mc-private.h
+++ b/drivers/bus/fsl-mc/fsl-mc-private.h
@@ -105,6 +105,8 @@ int dpmcp_reset(struct fsl_mc_io *mc_io,
 #define DPRC_CMDID_GET_OBJ_REG_V2               DPRC_CMD_V2(0x15E)
 #define DPRC_CMDID_SET_OBJ_IRQ                  DPRC_CMD(0x15F)
 
+#define DPRC_CMDID_GET_CONNECTION               DPRC_CMD(0x16C)
+
 struct dprc_cmd_open {
 	__le32 container_id;
 };
@@ -228,6 +230,22 @@ struct dprc_cmd_set_obj_irq {
 	u8 obj_type[16];
 };
 
+struct dprc_cmd_get_connection {
+	__le32 ep1_id;
+	__le16 ep1_interface_id;
+	u8 pad[2];
+	u8 ep1_type[16];
+};
+
+struct dprc_rsp_get_connection {
+	__le64 pad[3];
+	__le32 ep2_id;
+	__le16 ep2_interface_id;
+	__le16 pad1;
+	u8 ep2_type[16];
+	__le32 state;
+};
+
 /*
  * DPRC API for managing and querying DPAA resources
  */
@@ -392,6 +410,27 @@ int dprc_get_container_id(struct fsl_mc_io *mc_io,
 			  u32 cmd_flags,
 			  int *container_id);
 
+/**
+ * struct dprc_endpoint - Endpoint description for link connect/disconnect
+ *			operations
+ * @type:	Endpoint object type: NULL terminated string
+ * @id:		Endpoint object ID
+ * @if_id:	Interface ID; should be set for endpoints with multiple
+ *		interfaces ("dpsw", "dpdmux"); for others, always set to 0
+ */
+struct dprc_endpoint {
+	char type[16];
+	int id;
+	u16 if_id;
+};
+
+int dprc_get_connection(struct fsl_mc_io *mc_io,
+			u32 cmd_flags,
+			u16 token,
+			const struct dprc_endpoint *endpoint1,
+			struct dprc_endpoint *endpoint2,
+			int *state);
+
 /*
  * Data Path Buffer Pool (DPBP) API
  */
@@ -574,4 +613,7 @@ int __must_check fsl_create_mc_io(struct device *dev,
 
 bool fsl_mc_is_root_dprc(struct device *dev);
 
+struct fsl_mc_device *fsl_mc_device_lookup(struct fsl_mc_obj_desc *obj_desc,
+					   struct fsl_mc_device *mc_bus_dev);
+
 #endif /* _FSL_MC_PRIVATE_H_ */
diff --git a/include/linux/fsl/mc.h b/include/linux/fsl/mc.h
index 975553a9f75d..54d9436600c7 100644
--- a/include/linux/fsl/mc.h
+++ b/include/linux/fsl/mc.h
@@ -403,6 +403,8 @@ struct irq_domain *fsl_mc_msi_create_irq_domain(struct fwnode_handle *fwnode,
 
 void fsl_mc_free_irqs(struct fsl_mc_device *mc_dev);
 
+struct fsl_mc_device *fsl_mc_get_endpoint(struct fsl_mc_device *mc_dev);
+
 extern struct bus_type fsl_mc_bus_type;
 
 extern struct device_type fsl_mc_bus_dprc_type;
-- 
1.9.1

