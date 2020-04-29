Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5C91BD1D0
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgD2BnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726158AbgD2BnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 21:43:00 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F29302070B;
        Wed, 29 Apr 2020 01:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588124580;
        bh=yzbp6kL3fUKC5fG74g8YYREQuNA2/4pPCQCn/Dpd1f0=;
        h=From:To:Cc:Subject:Date:From;
        b=HqGhfzYuo1Ckw2w98nJNPkuLI0wx+t1+6ciUnKoNHkUVMXCwnu4jsJJEl7Z88utsE
         JS128zNqzrLOseiOWKS4M6qpEo0YYScbk9XqhKsFEk9cVz4qbDQKkC2RhoxZYW8V8q
         PS20sfYvgVwcrEjHDmM+5jNLaYDcJ4HV4YJS3kpE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] devlink: let kernel allocate region snapshot id
Date:   Tue, 28 Apr 2020 18:42:48 -0700
Message-Id: <20200429014248.893731-1-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
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

The message carrying id gets sent immediately, but the
allocation is only valid if the entire operation succeeded.
This makes life easier, as sending the notification itself
may fail.

Example use:
$ devlink region new netdevsim/netdevsim1/dummy
netdevsim/netdevsim1/dummy: snapshot 1

$ id=$(devlink -j region new netdevsim/netdevsim1/dummy | \
       jq '.[][][][]')
$ devlink region dump netdevsim/netdevsim1/dummy snapshot $id
[...]
$ devlink region del netdevsim/netdevsim1/dummy snapshot $id

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Jiri, this is what I had in mind of snapshots and the same
thing will come back for slice allocation.

 net/core/devlink.c                            | 84 ++++++++++++++++---
 .../drivers/net/netdevsim/devlink.sh          | 13 +++
 2 files changed, 84 insertions(+), 13 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 1ec2e9fd8898..dad5d07dd4f8 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4065,10 +4065,65 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
 	return 0;
 }
 
+static int
+devlink_nl_alloc_snapshot_id(struct devlink *devlink, struct genl_info *info,
+			     struct devlink_region *region, u32 *snapshot_id)
+{
+	struct sk_buff *msg;
+	void *hdr;
+	int err;
+
+	err = __devlink_region_snapshot_id_get(devlink, snapshot_id);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(info->extack,
+				   "Failed to allocate a new snapshot id");
+		return err;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		err = -ENOMEM;
+		goto err_msg_alloc;
+	}
+
+	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
+			  &devlink_nl_family, 0, DEVLINK_CMD_REGION_NEW);
+	if (!hdr) {
+		err = -EMSGSIZE;
+		goto err_put_failure;
+	}
+	err = devlink_nl_put_handle(msg, devlink);
+	if (err)
+		goto err_attr_failure;
+	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME, region->ops->name);
+	if (err)
+		goto err_attr_failure;
+	err = nla_put_u32(msg, DEVLINK_ATTR_REGION_SNAPSHOT_ID, *snapshot_id);
+	if (err)
+		goto err_attr_failure;
+	genlmsg_end(msg, hdr);
+
+	err = genlmsg_reply(msg, info);
+	if (err)
+		goto err_reply;
+
+	return 0;
+
+err_attr_failure:
+	genlmsg_cancel(msg, hdr);
+err_put_failure:
+	nlmsg_free(msg);
+err_msg_alloc:
+err_reply:
+	__devlink_snapshot_id_decrement(devlink, *snapshot_id);
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
@@ -4080,11 +4135,6 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
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
@@ -4102,16 +4152,24 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
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
+		err = devlink_nl_alloc_snapshot_id(devlink, info,
+						   region, &snapshot_id);
+		if (err)
+			return err;
+	}
 
 	err = region->ops->snapshot(devlink, info->extack, &data);
 	if (err)
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 9f9741444549..ad539eccddcb 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -151,6 +151,19 @@ regions_test()
 
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

