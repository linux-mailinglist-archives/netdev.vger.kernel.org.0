Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC09C7906D
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbfG2QMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:12:22 -0400
Received: from inva020.nxp.com ([92.121.34.13]:37820 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728888AbfG2QMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 12:12:21 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 61DC31A0378;
        Mon, 29 Jul 2019 18:12:19 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 543EF1A0156;
        Mon, 29 Jul 2019 18:12:19 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DD8E5205F3;
        Mon, 29 Jul 2019 18:12:18 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, jiri@mellanox.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 3/5] staging: fsl-dpaa2/ethsw: add .ndo_fdb_dump callback
Date:   Mon, 29 Jul 2019 19:11:50 +0300
Message-Id: <1564416712-16946-4-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1564416712-16946-1-git-send-email-ioana.ciornei@nxp.com>
References: <1564416712-16946-1-git-send-email-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the .ndo_fdb_dump callback for the switch net devices.  The
list of all offloaded FDB entries is retrieved through the dpsw_fdb_dump()
firmware call. Filter the entries by the switch port on which the
callback was called and for each of them create a new neighbour message.
Also remove the requirement from the TODO list.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/TODO       |   1 -
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h |  15 +++-
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     |  51 +++++++++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     |  25 ++++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    | 135 ++++++++++++++++++++++++++++-
 5 files changed, 224 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/TODO b/drivers/staging/fsl-dpaa2/ethsw/TODO
index 24b5e95a96f8..4d46857b0b2b 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/TODO
+++ b/drivers/staging/fsl-dpaa2/ethsw/TODO
@@ -1,7 +1,6 @@
 * Add I/O capabilities on switch port netdevices. This will allow control
 traffic to reach the CPU.
 * Add ACL to redirect control traffic to CPU.
-* Add support for displaying learned FDB entries
 * Add support for multiple FDBs and switch port partitioning
 * MC firmware uprev; the DPAA2 objects used by the Ethernet Switch driver
 need to be kept in sync with binary interface changes in MC
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
index 14b974defa3a..5e1339daa7c7 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
@@ -10,7 +10,7 @@
 
 /* DPSW Version */
 #define DPSW_VER_MAJOR		8
-#define DPSW_VER_MINOR		0
+#define DPSW_VER_MINOR		1
 
 #define DPSW_CMD_BASE_VERSION	1
 #define DPSW_CMD_ID_OFFSET	4
@@ -67,6 +67,7 @@
 #define DPSW_CMDID_FDB_ADD_MULTICAST        DPSW_CMD_ID(0x086)
 #define DPSW_CMDID_FDB_REMOVE_MULTICAST     DPSW_CMD_ID(0x087)
 #define DPSW_CMDID_FDB_SET_LEARNING_MODE    DPSW_CMD_ID(0x088)
+#define DPSW_CMDID_FDB_DUMP                 DPSW_CMD_ID(0x08A)
 
 /* Macros for accessing command fields smaller than 1byte */
 #define DPSW_MASK(field)        \
@@ -351,6 +352,18 @@ struct dpsw_cmd_fdb_set_learning_mode {
 	u8 mode;
 };
 
+struct dpsw_cmd_fdb_dump {
+	__le16 fdb_id;
+	__le16 pad0;
+	__le32 pad1;
+	__le64 iova_addr;
+	__le32 iova_size;
+};
+
+struct dpsw_rsp_fdb_dump {
+	__le16 num_entries;
+};
+
 struct dpsw_rsp_get_api_version {
 	__le16 version_major;
 	__le16 version_minor;
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
index cabed77b445d..56b0fa789a67 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
@@ -981,6 +981,57 @@ int dpsw_fdb_add_unicast(struct fsl_mc_io *mc_io,
 }
 
 /**
+ * dpsw_fdb_dump() - Dump the content of FDB table into memory.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @fdb_id:	Forwarding Database Identifier
+ * @iova_addr:	Data will be stored here as an array of struct fdb_dump_entry
+ * @iova_size:	Memory size allocated at iova_addr
+ * @num_entries:Number of entries written at iova_addr
+ *
+ * Return:	Completion status. '0' on Success; Error code otherwise.
+ *
+ * The memory allocated at iova_addr must be initialized with zero before
+ * command execution. If the FDB table does not fit into memory MC will stop
+ * after the memory is filled up.
+ * The struct fdb_dump_entry array must be parsed until the end of memory
+ * area or until an entry with mac_addr set to zero is found.
+ */
+int dpsw_fdb_dump(struct fsl_mc_io *mc_io,
+		  u32 cmd_flags,
+		  u16 token,
+		  u16 fdb_id,
+		  u64 iova_addr,
+		  u32 iova_size,
+		  u16 *num_entries)
+{
+	struct dpsw_cmd_fdb_dump *cmd_params;
+	struct dpsw_rsp_fdb_dump *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_FDB_DUMP,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_fdb_dump *)cmd.params;
+	cmd_params->fdb_id = cpu_to_le16(fdb_id);
+	cmd_params->iova_addr = cpu_to_le64(iova_addr);
+	cmd_params->iova_size = cpu_to_le32(iova_size);
+
+	/* send command to mc */
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	rsp_params = (struct dpsw_rsp_fdb_dump *)cmd.params;
+	*num_entries = le16_to_cpu(rsp_params->num_entries);
+
+	return 0;
+}
+
+/**
  * dpsw_fdb_remove_unicast() - removes an entry from MAC lookup table
  * @mc_io:	Pointer to MC portal's I/O object
  * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
index 0d9330e01915..25b45850925c 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
@@ -465,6 +465,31 @@ int dpsw_fdb_remove_unicast(struct fsl_mc_io *mc_io,
 			    u16 fdb_id,
 			    const struct dpsw_fdb_unicast_cfg *cfg);
 
+#define DPSW_FDB_ENTRY_TYPE_DYNAMIC  BIT(0)
+#define DPSW_FDB_ENTRY_TYPE_UNICAST  BIT(1)
+
+/**
+ * struct fdb_dump_entry - fdb snapshot entry
+ * @mac_addr: MAC address
+ * @type: bit0 - DINAMIC(1)/STATIC(0), bit1 - UNICAST(1)/MULTICAST(0)
+ * @if_info: unicast - egress interface, multicast - number of egress interfaces
+ * @if_mask: multicast - egress interface mask
+ */
+struct fdb_dump_entry {
+	u8 mac_addr[6];
+	u8 type;
+	u8 if_info;
+	u8 if_mask[8];
+};
+
+int dpsw_fdb_dump(struct fsl_mc_io *mc_io,
+		  u32 cmd_flags,
+		  u16 token,
+		  u16 fdb_id,
+		  u64 iova_addr,
+		  u32 iova_size,
+		  u16 *num_entries);
+
 /**
  * struct dpsw_fdb_multicast_cfg - Multi-cast entry configuration
  * @type: Select static or dynamic entry
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index d6953ac427b1..e6423f1e190d 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -22,7 +22,7 @@
 
 /* Minimal supported DPSW version */
 #define DPSW_MIN_VER_MAJOR		8
-#define DPSW_MIN_VER_MINOR		0
+#define DPSW_MIN_VER_MINOR		1
 
 #define DEFAULT_VLAN_ID			1
 
@@ -529,6 +529,138 @@ static int port_get_phys_name(struct net_device *netdev, char *name,
 	return 0;
 }
 
+struct ethsw_dump_ctx {
+	struct net_device *dev;
+	struct sk_buff *skb;
+	struct netlink_callback *cb;
+	int idx;
+};
+
+static int ethsw_fdb_do_dump(struct fdb_dump_entry *entry,
+			     struct ethsw_dump_ctx *dump)
+{
+	int is_dynamic = entry->type & DPSW_FDB_ENTRY_DINAMIC;
+	u32 portid = NETLINK_CB(dump->cb->skb).portid;
+	u32 seq = dump->cb->nlh->nlmsg_seq;
+	struct nlmsghdr *nlh;
+	struct ndmsg *ndm;
+
+	if (dump->idx < dump->cb->args[2])
+		goto skip;
+
+	nlh = nlmsg_put(dump->skb, portid, seq, RTM_NEWNEIGH,
+			sizeof(*ndm), NLM_F_MULTI);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	ndm = nlmsg_data(nlh);
+	ndm->ndm_family  = AF_BRIDGE;
+	ndm->ndm_pad1    = 0;
+	ndm->ndm_pad2    = 0;
+	ndm->ndm_flags   = NTF_SELF;
+	ndm->ndm_type    = 0;
+	ndm->ndm_ifindex = dump->dev->ifindex;
+	ndm->ndm_state   = is_dynamic ? NUD_REACHABLE : NUD_NOARP;
+
+	if (nla_put(dump->skb, NDA_LLADDR, ETH_ALEN, entry->mac_addr))
+		goto nla_put_failure;
+
+	nlmsg_end(dump->skb, nlh);
+
+skip:
+	dump->idx++;
+	return 0;
+
+nla_put_failure:
+	nlmsg_cancel(dump->skb, nlh);
+	return -EMSGSIZE;
+}
+
+static int port_fdb_valid_entry(struct fdb_dump_entry *entry,
+				struct ethsw_port_priv *port_priv)
+{
+	int idx = port_priv->idx;
+	int valid;
+
+	if (entry->type & DPSW_FDB_ENTRY_TYPE_UNICAST)
+		valid = entry->if_info == port_priv->idx;
+	else
+		valid = entry->if_mask[idx / 8] & BIT(idx % 8);
+
+	return valid;
+}
+
+static int port_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
+			 struct net_device *net_dev,
+			 struct net_device *filter_dev, int *idx)
+{
+	struct ethsw_port_priv *port_priv = netdev_priv(net_dev);
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct device *dev = net_dev->dev.parent;
+	struct fdb_dump_entry *fdb_entries;
+	struct fdb_dump_entry fdb_entry;
+	struct ethsw_dump_ctx dump = {
+		.dev = net_dev,
+		.skb = skb,
+		.cb = cb,
+		.idx = *idx,
+	};
+	dma_addr_t fdb_dump_iova;
+	u16 num_fdb_entries;
+	u32 fdb_dump_size;
+	int err = 0, i;
+	u8 *dma_mem;
+
+	fdb_dump_size = ethsw->sw_attr.max_fdb_entries * sizeof(fdb_entry);
+	dma_mem = kzalloc(fdb_dump_size, GFP_KERNEL);
+	if (!dma_mem)
+		return -ENOMEM;
+
+	memset(dma_mem, 0, fdb_dump_size);
+
+	fdb_dump_iova = dma_map_single(dev, dma_mem, fdb_dump_size,
+				       DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, fdb_dump_iova)) {
+		netdev_err(net_dev, "dma_map_single() failed\n");
+		err = -ENOMEM;
+		goto err_map;
+	}
+
+	err = dpsw_fdb_dump(ethsw->mc_io, 0, ethsw->dpsw_handle, 0,
+			    fdb_dump_iova, fdb_dump_size, &num_fdb_entries);
+	if (err) {
+		netdev_err(net_dev, "dpsw_fdb_dump() = %d\n", err);
+		goto err_dump;
+	}
+
+	dma_unmap_single(dev, fdb_dump_iova, fdb_dump_size, DMA_FROM_DEVICE);
+
+	fdb_entries = (struct fdb_dump_entry *)dma_mem;
+	for (i = 0; i < num_fdb_entries; i++) {
+		fdb_entry = fdb_entries[i];
+
+		if (!port_fdb_valid_entry(&fdb_entry, port_priv))
+			continue;
+
+		err = ethsw_fdb_do_dump(&fdb_entry, &dump);
+		if (err)
+			goto end;
+	}
+
+end:
+	*idx = dump.idx;
+
+	kfree(dma_mem);
+
+	return 0;
+
+err_dump:
+	dma_unmap_single(dev, fdb_dump_iova, fdb_dump_size, DMA_TO_DEVICE);
+err_map:
+	kfree(dma_mem);
+	return err;
+}
+
 static const struct net_device_ops ethsw_port_ops = {
 	.ndo_open		= port_open,
 	.ndo_stop		= port_stop,
@@ -538,6 +670,7 @@ static int port_get_phys_name(struct net_device *netdev, char *name,
 	.ndo_change_mtu		= port_change_mtu,
 	.ndo_has_offload_stats	= port_has_offload_stats,
 	.ndo_get_offload_stats	= port_get_offload_stats,
+	.ndo_fdb_dump		= port_fdb_dump,
 
 	.ndo_start_xmit		= port_dropframe,
 	.ndo_get_port_parent_id	= swdev_get_port_parent_id,
-- 
1.9.1

