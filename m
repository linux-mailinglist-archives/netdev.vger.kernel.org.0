Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0A51C043C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgD3R6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgD3R6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:58:07 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 984C8214D8;
        Thu, 30 Apr 2020 17:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588269486;
        bh=mCDI4VunYlGfjvLIZ+aG5aB52SfG69+CGGZfQcaFbGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKF9z5EadoDTdtQuB4BjXa8qhR1HU4gihTTdhsmef000vMB/w85kJJc6xcL5tauz2
         lGn1Os6slK/ra6jVuQ27etsPJ2viomkDpnbydKuZ4Vpi6VcnpYU/JXVYL38fXPXppj
         YVvSVSqXaDp0iJZtDZ3B63JxgQHkO6+DfZd4y6pg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 2/3] devlink: let kernel allocate region snapshot id
Date:   Thu, 30 Apr 2020 10:57:57 -0700
Message-Id: <20200430175759.1301789-3-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430175759.1301789-1-kuba@kernel.org>
References: <20200430175759.1301789-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently users have to choose a free snapshot id before
calling DEVLINK_CMD_REGION_NEW. This is potentially racy
and inconvenient.

Make the DEVLINK_ATTR_REGION_SNAPSHOT_ID optional and try
to allocate id automatically. Send a message back to the
caller with the snapshot info.

Example use:
$ devlink region new netdevsim/netdevsim1/dummy
netdevsim/netdevsim1/dummy: snapshot 1

$ id=$(devlink -j region new netdevsim/netdevsim1/dummy | \
       jq '.[][][][]')
$ devlink region dump netdevsim/netdevsim1/dummy snapshot $id
[...]
$ devlink region del netdevsim/netdevsim1/dummy snapshot $id

v3:
 - send the notification only once snapshot creation completed.
v2:
 - don't wrap the line containing extack;
 - add a few sentences to the docs.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../networking/devlink/devlink-region.rst     |  7 +-
 net/core/devlink.c                            | 69 +++++++++++++++----
 .../drivers/net/netdevsim/devlink.sh          | 13 ++++
 3 files changed, 74 insertions(+), 15 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
index 04e04d1ff627..daf35427fce1 100644
--- a/Documentation/networking/devlink/devlink-region.rst
+++ b/Documentation/networking/devlink/devlink-region.rst
@@ -23,7 +23,9 @@ states, but see also :doc:`devlink-health`
 Regions may optionally support capturing a snapshot on demand via the
 ``DEVLINK_CMD_REGION_NEW`` netlink message. A driver wishing to allow
 requested snapshots must implement the ``.snapshot`` callback for the region
-in its ``devlink_region_ops`` structure.
+in its ``devlink_region_ops`` structure. If snapshot id is not set in
+the ``DEVLINK_CMD_REGION_NEW`` request kernel will allocate one and send
+the snapshot information to user space.
 
 example usage
 -------------
@@ -45,7 +47,8 @@ example usage
     $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
 
     # Request an immediate snapshot, if supported by the region
-    $ devlink region new pci/0000:00:05.0/cr-space snapshot 5
+    $ devlink region new pci/0000:00:05.0/cr-space
+    pci/0000:00:05.0/cr-space: snapshot 5
 
     # Dump a snapshot:
     $ devlink region dump pci/0000:00:05.0/fw-health snapshot 1
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 92afb85bad89..4df947fb90d9 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4082,10 +4082,41 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
 	return 0;
 }
 
+static int
+devlink_nl_snapshot_id_notify(struct devlink *devlink, struct genl_info *info,
+			      struct devlink_region *region, u32 snapshot_id)
+{
+	struct devlink_snapshot *snapshot;
+	struct sk_buff *msg;
+	int err;
+
+	snapshot = devlink_region_snapshot_get_by_id(region, snapshot_id);
+	if (WARN_ON(!snapshot))
+		return -EINVAL;
+
+	msg = devlink_nl_region_notify_build(region, snapshot,
+					     DEVLINK_CMD_REGION_NEW,
+					     info->snd_portid, info->snd_seq);
+	err = PTR_ERR_OR_ZERO(msg);
+	if (err)
+		goto err_notify;
+
+	err = genlmsg_reply(msg, info);
+	if (err)
+		goto err_notify;
+
+	return 0;
+
+err_notify:
+	devlink_region_snapshot_del(region, snapshot);
+	return err;
+}
+
 static int
 devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
+	struct nlattr *snapshot_id_attr;
 	struct devlink_region *region;
 	const char *region_name;
 	u32 snapshot_id;
@@ -4097,11 +4128,6 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
-	if (!info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]) {
-		NL_SET_ERR_MSG_MOD(info->extack, "No snapshot id provided");
-		return -EINVAL;
-	}
-
 	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
 	region = devlink_region_get_by_name(devlink, region_name);
 	if (!region) {
@@ -4119,16 +4145,25 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 		return -ENOSPC;
 	}
 
-	snapshot_id = nla_get_u32(info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
+	snapshot_id_attr = info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID];
+	if (snapshot_id_attr) {
+		snapshot_id = nla_get_u32(snapshot_id_attr);
 
-	if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
-		NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot id is already in use");
-		return -EEXIST;
-	}
+		if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
+			NL_SET_ERR_MSG_MOD(info->extack, "The requested snapshot id is already in use");
+			return -EEXIST;
+		}
 
-	err = __devlink_snapshot_id_insert(devlink, snapshot_id);
-	if (err)
-		return err;
+		err = __devlink_snapshot_id_insert(devlink, snapshot_id);
+		if (err)
+			return err;
+	} else {
+		err = __devlink_region_snapshot_id_get(devlink, &snapshot_id);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(info->extack, "Failed to allocate a new snapshot id");
+			return err;
+		}
+	}
 
 	err = region->ops->snapshot(devlink, info->extack, &data);
 	if (err)
@@ -4138,6 +4173,14 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		goto err_snapshot_create;
 
+	if (!snapshot_id_attr) {
+		/* destroys the snapshot on failure */
+		err = devlink_nl_snapshot_id_notify(devlink, info,
+						    region, snapshot_id);
+		if (err)
+			return err;
+	}
+
 	return 0;
 
 err_snapshot_create:
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 1d15afd62941..de4b32fc4223 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -166,6 +166,19 @@ regions_test()
 
 	check_region_snapshot_count dummy post-second-delete 2
 
+	sid=$(devlink -j region new $DL_HANDLE/dummy | jq '.[][][][]')
+	check_err $? "Failed to create a new snapshot with id allocated by the kernel"
+
+	check_region_snapshot_count dummy post-first-request 3
+
+	devlink region dump $DL_HANDLE/dummy snapshot $sid >> /dev/null
+	check_err $? "Failed to dump a snapshot with id allocated by the kernel"
+
+	devlink region del $DL_HANDLE/dummy snapshot $sid
+	check_err $? "Failed to delete snapshot with id allocated by the kernel"
+
+	check_region_snapshot_count dummy post-first-request 2
+
 	log_test "regions test"
 }
 
-- 
2.25.4

