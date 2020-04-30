Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F7F1C043B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgD3R6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgD3R6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:58:07 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30E1D208C3;
        Thu, 30 Apr 2020 17:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588269486;
        bh=BgMsAri7O0jqoRKugUOYNio3WKPBcrkrLTde5/F4BMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIeyVfk2tVJwW6XBjS500i3f2yusxWoxasGmsHg7szqpXYc3lcnG34k3h4sgegJI8
         KqBCc82nPS+SeKRVe9P6F/VR+rqKQzka0ICMNmFOfp0AGkFHeqRIioI33WKudCsw0M
         bgNKQ81DzRJAGQG9k97EcSUBCHBbCv5mhOxlyWU8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 1/3] devlink: factor out building a snapshot notification
Date:   Thu, 30 Apr 2020 10:57:56 -0700
Message-Id: <20200430175759.1301789-2-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430175759.1301789-1-kuba@kernel.org>
References: <20200430175759.1301789-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll need to send snapshot info back on the socket
which requested a snapshot to be created. Factor out
constructing a snapshot description from the broadcast
notification code.

v3: new patch

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/devlink.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9f0af8931a9c..92afb85bad89 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3716,24 +3716,26 @@ static int devlink_nl_region_fill(struct sk_buff *msg, struct devlink *devlink,
 	return err;
 }
 
-static void devlink_nl_region_notify(struct devlink_region *region,
-				     struct devlink_snapshot *snapshot,
-				     enum devlink_command cmd)
+static struct sk_buff *
+devlink_nl_region_notify_build(struct devlink_region *region,
+			       struct devlink_snapshot *snapshot,
+			       enum devlink_command cmd, u32 portid, u32 seq)
 {
 	struct devlink *devlink = region->devlink;
 	struct sk_buff *msg;
 	void *hdr;
 	int err;
 
-	WARN_ON(cmd != DEVLINK_CMD_REGION_NEW && cmd != DEVLINK_CMD_REGION_DEL);
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
-		return;
+		return ERR_PTR(-ENOMEM);
 
-	hdr = genlmsg_put(msg, 0, 0, &devlink_nl_family, 0, cmd);
-	if (!hdr)
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, 0, cmd);
+	if (!hdr) {
+		err = -EMSGSIZE;
 		goto out_free_msg;
+	}
 
 	err = devlink_nl_put_handle(msg, devlink);
 	if (err)
@@ -3757,15 +3759,30 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 	}
 	genlmsg_end(msg, hdr);
 
-	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
-				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
-
-	return;
+	return msg;
 
 out_cancel_msg:
 	genlmsg_cancel(msg, hdr);
 out_free_msg:
 	nlmsg_free(msg);
+	return ERR_PTR(err);
+}
+
+static void devlink_nl_region_notify(struct devlink_region *region,
+				     struct devlink_snapshot *snapshot,
+				     enum devlink_command cmd)
+{
+	struct devlink *devlink = region->devlink;
+	struct sk_buff *msg;
+
+	WARN_ON(cmd != DEVLINK_CMD_REGION_NEW && cmd != DEVLINK_CMD_REGION_DEL);
+
+	msg = devlink_nl_region_notify_build(region, snapshot, cmd, 0, 0);
+	if (IS_ERR(msg))
+		return;
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
+				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
 /**
-- 
2.25.4

