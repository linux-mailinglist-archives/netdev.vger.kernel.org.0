Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD69763B35D
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiK1UhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbiK1UhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:37:04 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1BC2C673
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669667822; x=1701203822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c15Xr5gDDr2PWpXmkejsIx81RNnE88Df+2C9wrSddQ4=;
  b=G34342SBm0dGBM3WnrWee6Eauw/1tvpWjsB3uoABKFWClkhRCmTopNl4
   yFrXHSvTI5JnuPl24OwK5GNwYy0OECVmrL3elWD5mqjE545PBROAOKY42
   1j+kJ/6oJkPO9feHuyZTvmS1ZgwcatGHjCoiH/Uijooro/d1cyoKL0cf1
   TdzB4YC8k5Zq946fMCj3XxvIAuNJ+1M8CXwgyT0TSpbGiKHxfrKwbKQrp
   K8jkwNZpu8nmey2RlJBefTrOA0hOP6pxJgOyvTJMCtvgvClyubkSmcPwG
   PF6yjc2EjNBkDwgClMWjRz9N7Zf16miSFhVPaCam7eAcLXPP/GzHIP8CV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379205397"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379205397"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="732286357"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="732286357"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:59 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 6/9] devlink: support directly reading from region memory
Date:   Mon, 28 Nov 2022 12:36:44 -0800
Message-Id: <20221128203647.1198669-7-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221128203647.1198669-1-jacob.e.keller@intel.com>
References: <20221128203647.1198669-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To read from a region, user space must currently request a new snapshot of
the region and then read from that snapshot. This can sometimes be overkill
if user space only reads a tiny portion. They first create the snapshot,
then request a read, then destroy the snapshot.

For regions which have a single underlying "contents", it makes sense to
allow supporting direct reading of the region data.

Extend the DEVLINK_CMD_REGION_READ to allow direct reading from a region if
requested via the new DEVLINK_ATTR_REGION_DIRECT. If this attribute is set,
then perform a direct read instead of using a snapshot. Direct read is
mutually exclusive with DEVLINK_ATTR_REGION_SNAPSHOT_ID, and care is taken
to ensure that we reject commands which provide incorrect attributes.

Regions must enable support for direct read by implementing the .read()
callback function. If a region does not support such direct reads, a
suitable extended error message is reported.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
Changes since v2:
* Switched to using a new DEVLINK_ATTR_REGION_DIRECT attribute, ensuring
  that user space is explicit in requesting direct access, and user space to
  determine when support exists in the kernel.
* Fixed the capitalization of NL_SET_ERR_MSG


 .../networking/devlink/devlink-region.rst     | 13 +++
 include/net/devlink.h                         | 16 ++++
 include/uapi/linux/devlink.h                  |  2 +
 net/core/devlink.c                            | 80 +++++++++++++++----
 4 files changed, 94 insertions(+), 17 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
index f06dca9a1eb6..9232cd7da301 100644
--- a/Documentation/networking/devlink/devlink-region.rst
+++ b/Documentation/networking/devlink/devlink-region.rst
@@ -31,6 +31,15 @@ in its ``devlink_region_ops`` structure. If snapshot id is not set in
 the ``DEVLINK_CMD_REGION_NEW`` request kernel will allocate one and send
 the snapshot information to user space.
 
+Regions may optionally allow directly reading from their contents without a
+snapshot. Direct read requests are not atomic. In particular a read request
+of size 256 bytes or larger will be split into multiple chunks. If atomic
+access is required, use a snapshot. A driver wishing to enable this for a
+region should implement the ``.read`` callback in the ``devlink_region_ops``
+structure. User space can request a direct read by using the
+``DEVLINK_ATTR_REGION_DIRECT`` attribute instead of specifying a snapshot
+id.
+
 example usage
 -------------
 
@@ -65,6 +74,10 @@ example usage
     $ devlink region read pci/0000:00:05.0/fw-health snapshot 1 address 0 length 16
     0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
 
+    # Read from the region without a snapshot
+    $ devlink region read pci/0000:00:05.0/fw-health address 16 length 16
+    0000000000000010 0000 0000 ffff ff04 0029 8c00 0028 8cc8
+
 As regions are likely very device or driver specific, no generic regions are
 defined. See the driver-specific documentation files for information on the
 specific regions a driver supports.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 074a79b8933f..02528f736f65 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -650,6 +650,10 @@ struct devlink_info_req;
  *            the data variable must be updated to point to the snapshot data.
  *            The function will be called while the devlink instance lock is
  *            held.
+ * @read: callback to directly read a portion of the region. On success,
+ *        the data pointer will be updated with the contents of the
+ *        requested portion of the region. The function will be called
+ *        while the devlink instance lock is held.
  * @priv: Pointer to driver private data for the region operation
  */
 struct devlink_region_ops {
@@ -659,6 +663,10 @@ struct devlink_region_ops {
 			const struct devlink_region_ops *ops,
 			struct netlink_ext_ack *extack,
 			u8 **data);
+	int (*read)(struct devlink *devlink,
+		    const struct devlink_region_ops *ops,
+		    struct netlink_ext_ack *extack,
+		    u64 offset, u32 size, u8 *data);
 	void *priv;
 };
 
@@ -670,6 +678,10 @@ struct devlink_region_ops {
  *            the data variable must be updated to point to the snapshot data.
  *            The function will be called while the devlink instance lock is
  *            held.
+ * @read: callback to directly read a portion of the region. On success,
+ *        the data pointer will be updated with the contents of the
+ *        requested portion of the region. The function will be called
+ *        while the devlink instance lock is held.
  * @priv: Pointer to driver private data for the region operation
  */
 struct devlink_port_region_ops {
@@ -679,6 +691,10 @@ struct devlink_port_region_ops {
 			const struct devlink_port_region_ops *ops,
 			struct netlink_ext_ack *extack,
 			u8 **data);
+	int (*read)(struct devlink_port *port,
+		    const struct devlink_port_region_ops *ops,
+		    struct netlink_ext_ack *extack,
+		    u64 offset, u32 size, u8 *data);
 	void *priv;
 };
 
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 498d0d5d0957..70191d96af89 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -610,6 +610,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_RATE_TX_PRIORITY,		/* u32 */
 	DEVLINK_ATTR_RATE_TX_WEIGHT,		/* u32 */
 
+	DEVLINK_ATTR_REGION_DIRECT,		/* flag */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 22480c85a0d0..bb8b7e00f420 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6515,6 +6515,26 @@ devlink_region_snapshot_fill(void *cb_priv, u8 *chunk, u32 chunk_size,
 	return 0;
 }
 
+static int
+devlink_region_port_direct_fill(void *cb_priv, u8 *chunk, u32 chunk_size,
+				u64 curr_offset, struct netlink_ext_ack *extack)
+{
+	struct devlink_region *region = cb_priv;
+
+	return region->port_ops->read(region->port, region->port_ops, extack,
+				      curr_offset, chunk_size, chunk);
+}
+
+static int
+devlink_region_direct_fill(void *cb_priv, u8 *chunk, u32 chunk_size,
+			   u64 curr_offset, struct netlink_ext_ack *extack)
+{
+	struct devlink_region *region = cb_priv;
+
+	return region->ops->read(region->devlink, region->ops, extack,
+				 curr_offset, chunk_size, chunk);
+}
+
 static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 					     struct netlink_callback *cb)
 {
@@ -6523,12 +6543,12 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	u64 ret_offset, start_offset, end_offset = U64_MAX;
 	struct nlattr **attrs = info->attrs;
 	struct devlink_port *port = NULL;
-	struct devlink_snapshot *snapshot;
+	devlink_chunk_fill_t *region_cb;
 	struct devlink_region *region;
 	const char *region_name;
 	struct devlink *devlink;
 	unsigned int index;
-	u32 snapshot_id;
+	void *region_cb_priv;
 	void *hdr;
 	int err;
 
@@ -6546,12 +6566,6 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto out_unlock;
 	}
 
-	if (!attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
-		NL_SET_ERR_MSG(cb->extack, "No snapshot id provided");
-		err = -EINVAL;
-		goto out_unlock;
-	}
-
 	if (info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
 		index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
 
@@ -6577,12 +6591,43 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	}
 
 	snapshot_attr = attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID];
-	snapshot_id = nla_get_u32(snapshot_attr);
-	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
-	if (!snapshot) {
-		NL_SET_ERR_MSG_ATTR(cb->extack, snapshot_attr, "Requested snapshot does not exist");
-		err = -EINVAL;
-		goto out_unlock;
+	if (!snapshot_attr) {
+		if (!nla_get_flag(attrs[DEVLINK_ATTR_REGION_DIRECT])) {
+			NL_SET_ERR_MSG(cb->extack, "No snapshot id provided");
+			err = -EINVAL;
+			goto out_unlock;
+		}
+
+		if (!region->ops->read) {
+			NL_SET_ERR_MSG(cb->extack, "Requested region does not support direct read");
+			err = -EOPNOTSUPP;
+			goto out_unlock;
+		}
+
+		if (port)
+			region_cb = &devlink_region_port_direct_fill;
+		else
+			region_cb = &devlink_region_direct_fill;
+		region_cb_priv = region;
+	} else {
+		struct devlink_snapshot *snapshot;
+		u32 snapshot_id;
+
+		if (nla_get_flag(attrs[DEVLINK_ATTR_REGION_DIRECT])) {
+			NL_SET_ERR_MSG_ATTR(cb->extack, snapshot_attr, "Direct region read does not use snapshot");
+			err = -EINVAL;
+			goto out_unlock;
+		}
+
+		snapshot_id = nla_get_u32(snapshot_attr);
+		snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
+		if (!snapshot) {
+			NL_SET_ERR_MSG_ATTR(cb->extack, snapshot_attr, "Requested snapshot does not exist");
+			err = -EINVAL;
+			goto out_unlock;
+		}
+		region_cb = &devlink_region_snapshot_fill;
+		region_cb_priv = snapshot;
 	}
 
 	if (attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR] &&
@@ -6633,9 +6678,9 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto nla_put_failure;
 	}
 
-	err = devlink_nl_region_read_fill(skb, &devlink_region_snapshot_fill,
-					  snapshot, start_offset, end_offset,
-					  &ret_offset, cb->extack);
+	err = devlink_nl_region_read_fill(skb, region_cb, region_cb_priv,
+					  start_offset, end_offset, &ret_offset,
+					  cb->extack);
 
 	if (err && err != -EMSGSIZE)
 		goto nla_put_failure;
@@ -9280,6 +9325,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_SELFTESTS] = { .type = NLA_NESTED },
 	[DEVLINK_ATTR_RATE_TX_PRIORITY] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_RATE_TX_WEIGHT] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_REGION_DIRECT] = { .type = NLA_FLAG },
 };
 
 static const struct genl_small_ops devlink_nl_ops[] = {
-- 
2.38.1.420.g319605f8f00e

