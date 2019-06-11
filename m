Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B247F3D1EF
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405506AbfFKQMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:12:00 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35382 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2405473AbfFKQL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:11:59 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from moshe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Jun 2019 19:11:58 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.134.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x5BGBvIj008247;
        Tue, 11 Jun 2019 19:11:58 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id x5BGBvno031012;
        Tue, 11 Jun 2019 19:11:57 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id x5BGBpZt031001;
        Tue, 11 Jun 2019 19:11:51 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH iproute2] devlink: mnlg: Catch returned error value of dumpit commands
Date:   Tue, 11 Jun 2019 19:11:09 +0300
Message-Id: <1560269469-30938-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink commands which implements the dumpit callback may return error.
The netlink function netlink_dump() sends the errno value as the payload
of the message, while answering user space with NLMSG_DONE.
To enable receiving errno value for dumpit commands we have to check for
it in the message. If it is a negative value then the dump returned an
error so we should set errno accordingly and check for ext_ack in case
it was set.

Fixes: 049c58539f5d ("devlink: mnlg: Add support for extended ack")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/mnlg.c       | 7 +++++++
 include/libnetlink.h | 1 +
 lib/libnetlink.c     | 4 ++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/devlink/mnlg.c b/devlink/mnlg.c
index 37cc25d..ee125df 100644
--- a/devlink/mnlg.c
+++ b/devlink/mnlg.c
@@ -85,6 +85,13 @@ static int mnlg_cb_error(const struct nlmsghdr *nlh, void *data)
 
 static int mnlg_cb_stop(const struct nlmsghdr *nlh, void *data)
 {
+	int len = *(int *)NLMSG_DATA(nlh);
+
+	if (len < 0) {
+		errno = -len;
+		nl_dump_ext_ack_done(nlh, len);
+		return MNL_CB_ERROR;
+	}
 	return MNL_CB_STOP;
 }
 
diff --git a/include/libnetlink.h b/include/libnetlink.h
index 503b3ec..0205af8 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -129,6 +129,7 @@ int rtnl_send(struct rtnl_handle *rth, const void *buf, int)
 int rtnl_send_check(struct rtnl_handle *rth, const void *buf, int)
 	__attribute__((warn_unused_result));
 int nl_dump_ext_ack(const struct nlmsghdr *nlh, nl_ext_ack_fn_t errfn);
+int nl_dump_ext_ack_done(const struct nlmsghdr *nlh, int error);
 
 int addattr(struct nlmsghdr *n, int maxlen, int type);
 int addattr8(struct nlmsghdr *n, int maxlen, int type, __u8 data);
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 0d48a3d..028d550 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -125,7 +125,7 @@ int nl_dump_ext_ack(const struct nlmsghdr *nlh, nl_ext_ack_fn_t errfn)
 	return 0;
 }
 
-static int nl_dump_ext_ack_done(const struct nlmsghdr *nlh, int error)
+int nl_dump_ext_ack_done(const struct nlmsghdr *nlh, int error)
 {
 	struct nlattr *tb[NLMSGERR_ATTR_MAX + 1] = {};
 	unsigned int hlen = sizeof(int);
@@ -155,7 +155,7 @@ int nl_dump_ext_ack(const struct nlmsghdr *nlh, nl_ext_ack_fn_t errfn)
 	return 0;
 }
 
-static int nl_dump_ext_ack_done(const struct nlmsghdr *nlh, int error)
+int nl_dump_ext_ack_done(const struct nlmsghdr *nlh, int error)
 {
 	return 0;
 }
-- 
1.8.3.1

