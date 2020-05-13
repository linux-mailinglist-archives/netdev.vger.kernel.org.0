Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4B91D1C42
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 19:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389831AbgEMR2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 13:28:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732731AbgEMR2c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 13:28:32 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D20A42053B;
        Wed, 13 May 2020 17:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589390912;
        bh=Oz5kH5PwdQUs/HV7bh4P+ytMhZEztLZiHJFxnsBFy6A=;
        h=From:To:Cc:Subject:Date:From;
        b=acj5UEOEH81+CJ3YehxNHUfFw3s9MJnE4RNiwWwiwvXn/HmERvvGqI2WMrBJtByG7
         E3uXQhpz/VL3d8gvXNXJubXyKVEcyNGbz3PDsi45IHvcwrQb30TfXhBRAxLKrDDyEd
         Qv+87gWShJ+uTjn1DOsBFXB5b2kDX9BteysAC72U=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     jiri@resnulli.us, jacob.e.keller@intel.com, netdev@vger.kernel.org,
        kernel-team@fb.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] devlink: refactor end checks in devlink_nl_cmd_region_read_dumpit
Date:   Wed, 13 May 2020 10:28:22 -0700
Message-Id: <20200513172822.2663102-1-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up after recent fixes, move address calculations
around and change the variable init, so that we can have
just one start_offset == end_offset check.

Make the check a little stricter to preserve the -EINVAL
error if requested start offset is larger than the region
itself.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/devlink.c                            | 41 ++++++++-----------
 .../drivers/net/netdevsim/devlink.sh          | 15 +++++++
 2 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 20f935fa29f5..7b76e5fffc10 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4215,7 +4215,6 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 						struct nlattr **attrs,
 						u64 start_offset,
 						u64 end_offset,
-						bool dump,
 						u64 *new_offset)
 {
 	struct devlink_snapshot *snapshot;
@@ -4230,9 +4229,6 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 	if (!snapshot)
 		return -EINVAL;
 
-	if (end_offset > region->size || dump)
-		end_offset = region->size;
-
 	while (curr_offset < end_offset) {
 		u32 data_size;
 		u8 *data;
@@ -4260,13 +4256,12 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 					     struct netlink_callback *cb)
 {
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
-	u64 ret_offset, start_offset, end_offset = 0;
+	u64 ret_offset, start_offset, end_offset = U64_MAX;
 	struct nlattr **attrs = info->attrs;
 	struct devlink_region *region;
 	struct nlattr *chunks_attr;
 	const char *region_name;
 	struct devlink *devlink;
-	bool dump = true;
 	void *hdr;
 	int err;
 
@@ -4294,8 +4289,21 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto out_unlock;
 	}
 
+	if (attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR] &&
+	    attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]) {
+		if (!start_offset)
+			start_offset =
+				nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR]);
+
+		end_offset = nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR]);
+		end_offset += nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]);
+	}
+
+	if (end_offset > region->size)
+		end_offset = region->size;
+
 	/* return 0 if there is no further data to read */
-	if (start_offset >= region->size) {
+	if (start_offset == end_offset) {
 		err = 0;
 		goto out_unlock;
 	}
@@ -4322,27 +4330,10 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto nla_put_failure;
 	}
 
-	if (attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR] &&
-	    attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]) {
-		if (!start_offset)
-			start_offset =
-				nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR]);
-
-		end_offset = nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_ADDR]);
-		end_offset += nla_get_u64(attrs[DEVLINK_ATTR_REGION_CHUNK_LEN]);
-		dump = false;
-
-		if (start_offset == end_offset) {
-			err = 0;
-			goto nla_put_failure;
-		}
-	}
-
 	err = devlink_nl_region_read_snapshot_fill(skb, devlink,
 						   region, attrs,
 						   start_offset,
-						   end_offset, dump,
-						   &ret_offset);
+						   end_offset, &ret_offset);
 
 	if (err && err != -EMSGSIZE)
 		goto nla_put_failure;
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index ad539eccddcb..de4b32fc4223 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -146,6 +146,21 @@ regions_test()
 
 	check_region_snapshot_count dummy post-first-request 3
 
+	devlink region dump $DL_HANDLE/dummy snapshot 25 >> /dev/null
+	check_err $? "Failed to dump snapshot with id 25"
+
+	devlink region read $DL_HANDLE/dummy snapshot 25 addr 0 len 1 >> /dev/null
+	check_err $? "Failed to read snapshot with id 25 (1 byte)"
+
+	devlink region read $DL_HANDLE/dummy snapshot 25 addr 128 len 128 >> /dev/null
+	check_err $? "Failed to read snapshot with id 25 (128 bytes)"
+
+	devlink region read $DL_HANDLE/dummy snapshot 25 addr 128 len $((1<<32)) >> /dev/null
+	check_err $? "Failed to read snapshot with id 25 (oversized)"
+
+	devlink region read $DL_HANDLE/dummy snapshot 25 addr $((1<<32)) len 128 >> /dev/null 2>&1
+	check_fail $? "Bad read of snapshot with id 25 did not fail"
+
 	devlink region del $DL_HANDLE/dummy snapshot 25
 	check_err $? "Failed to delete snapshot with id 25"
 
-- 
2.25.4

