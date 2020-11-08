Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86A92AAD93
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 22:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgKHVOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 16:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728914AbgKHVOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 16:14:45 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218CDC0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 13:14:45 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CTn2C5Y8XzQjbV;
        Sun,  8 Nov 2020 22:14:43 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604870081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6aWX8XASs/6sWnV9mLSOL43vd4+o+FUZfJHei4wY9Vg=;
        b=bKkJkt17/8IlbIFJaT1KPIbbH3Y7CvImsGNxCwx5D3pgjS/RsW1oItLmoXMINdHsofCeX3
        TWI6PdIAo/YFvITDkJG3khQCRWqqW4gjP4yZ6OcJoNuvFQkafK8rWQIt2nOhYExFPpWRvM
        w16TF3GRwsFdzXS14niTvMQLk7SQkSr/oAD6WKfCigNrZoicLnAAuDuV8A+MP29vcuwjmo
        JmNaa4d6CiWj4IQ9XzHql3Eo+DRmIDfip68zAMKmeDzruKmKifDW8PMNnuRE9m1EL6mOLY
        ttQvQu6GCUJ1R+zsPiDC5aTneNy7AshhLNdegS2+F1EznY/G6qZDfxEU7jnQvA==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id szGjoLrR5r3D; Sun,  8 Nov 2020 22:14:40 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v4 06/11] lib: Extract from devlink/mnlg a helper, mnlu_socket_recv_run()
Date:   Sun,  8 Nov 2020 22:14:11 +0100
Message-Id: <db6e376b1aecb681dec4c39c406592d42612f819.1604869679.git.me@pmachata.org>
In-Reply-To: <cover.1604869679.git.me@pmachata.org>
References: <cover.1604869679.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.56 / 15.00 / 15.00
X-Rspamd-Queue-Id: A62A216FE
X-Rspamd-UID: 68749e
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Receiving a message in libmnl is a somewhat involved operation. Devlink's
mnlg library has an implementation that is going to be handy for other
tools as well. Extract it into a new helper.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 devlink/mnlg.c      | 56 ++---------------------------------------
 include/mnl_utils.h |  2 ++
 lib/mnl_utils.c     | 61 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 54 deletions(-)

diff --git a/devlink/mnlg.c b/devlink/mnlg.c
index 4995b7af06a3..21b10c5a5669 100644
--- a/devlink/mnlg.c
+++ b/devlink/mnlg.c
@@ -28,7 +28,6 @@ struct mnlg_socket {
 	uint32_t id;
 	uint8_t version;
 	unsigned int seq;
-	unsigned int portid;
 };
 
 static struct nlmsghdr *__mnlg_msg_prepare(struct mnlg_socket *nlg, uint8_t cmd,
@@ -57,61 +56,10 @@ int mnlg_socket_send(struct mnlg_socket *nlg, const struct nlmsghdr *nlh)
 	return mnl_socket_sendto(nlg->nl, nlh, nlh->nlmsg_len);
 }
 
-static int mnlg_cb_noop(const struct nlmsghdr *nlh, void *data)
-{
-	return MNL_CB_OK;
-}
-
-static int mnlg_cb_error(const struct nlmsghdr *nlh, void *data)
-{
-	const struct nlmsgerr *err = mnl_nlmsg_get_payload(nlh);
-
-	/* Netlink subsystems returns the errno value with different signess */
-	if (err->error < 0)
-		errno = -err->error;
-	else
-		errno = err->error;
-
-	if (nl_dump_ext_ack(nlh, NULL))
-		return MNL_CB_ERROR;
-
-	return err->error == 0 ? MNL_CB_STOP : MNL_CB_ERROR;
-}
-
-static int mnlg_cb_stop(const struct nlmsghdr *nlh, void *data)
-{
-	int len = *(int *)NLMSG_DATA(nlh);
-
-	if (len < 0) {
-		errno = -len;
-		nl_dump_ext_ack_done(nlh, len);
-		return MNL_CB_ERROR;
-	}
-	return MNL_CB_STOP;
-}
-
-static mnl_cb_t mnlg_cb_array[NLMSG_MIN_TYPE] = {
-	[NLMSG_NOOP]	= mnlg_cb_noop,
-	[NLMSG_ERROR]	= mnlg_cb_error,
-	[NLMSG_DONE]	= mnlg_cb_stop,
-	[NLMSG_OVERRUN]	= mnlg_cb_noop,
-};
-
 int mnlg_socket_recv_run(struct mnlg_socket *nlg, mnl_cb_t data_cb, void *data)
 {
-	int err;
-
-	do {
-		err = mnl_socket_recvfrom(nlg->nl, nlg->buf,
-					  MNL_SOCKET_BUFFER_SIZE);
-		if (err <= 0)
-			break;
-		err = mnl_cb_run2(nlg->buf, err, nlg->seq, nlg->portid,
-				  data_cb, data, mnlg_cb_array,
-				  ARRAY_SIZE(mnlg_cb_array));
-	} while (err > 0);
-
-	return err;
+	return mnlu_socket_recv_run(nlg->nl, nlg->seq, nlg->buf, MNL_SOCKET_BUFFER_SIZE,
+				    data_cb, data);
 }
 
 struct group_info {
diff --git a/include/mnl_utils.h b/include/mnl_utils.h
index 86ce30f49a94..fa826ef1f8fe 100644
--- a/include/mnl_utils.h
+++ b/include/mnl_utils.h
@@ -5,5 +5,7 @@
 struct mnl_socket *mnlu_socket_open(int bus);
 struct nlmsghdr *mnlu_msg_prepare(void *buf, uint32_t nlmsg_type, uint16_t flags,
 				  void *extra_header, size_t extra_header_size);
+int mnlu_socket_recv_run(struct mnl_socket *nl, unsigned int seq, void *buf, size_t buf_size,
+			 mnl_cb_t cb, void *data);
 
 #endif /* __MNL_UTILS_H__ */
diff --git a/lib/mnl_utils.c b/lib/mnl_utils.c
index 61e8060ecbca..46384ff81cf1 100644
--- a/lib/mnl_utils.c
+++ b/lib/mnl_utils.c
@@ -3,11 +3,14 @@
  * mnl_utils.c	Helpers for working with libmnl.
  */
 
+#include <errno.h>
 #include <string.h>
 #include <time.h>
 #include <libmnl/libmnl.h>
 
+#include "libnetlink.h"
 #include "mnl_utils.h"
+#include "utils.h"
 
 struct mnl_socket *mnlu_socket_open(int bus)
 {
@@ -47,3 +50,61 @@ struct nlmsghdr *mnlu_msg_prepare(void *buf, uint32_t nlmsg_type, uint16_t flags
 
 	return nlh;
 }
+
+static int mnlu_cb_noop(const struct nlmsghdr *nlh, void *data)
+{
+	return MNL_CB_OK;
+}
+
+static int mnlu_cb_error(const struct nlmsghdr *nlh, void *data)
+{
+	const struct nlmsgerr *err = mnl_nlmsg_get_payload(nlh);
+
+	/* Netlink subsystems returns the errno value with different signess */
+	if (err->error < 0)
+		errno = -err->error;
+	else
+		errno = err->error;
+
+	if (nl_dump_ext_ack(nlh, NULL))
+		return MNL_CB_ERROR;
+
+	return err->error == 0 ? MNL_CB_STOP : MNL_CB_ERROR;
+}
+
+static int mnlu_cb_stop(const struct nlmsghdr *nlh, void *data)
+{
+	int len = *(int *)NLMSG_DATA(nlh);
+
+	if (len < 0) {
+		errno = -len;
+		nl_dump_ext_ack_done(nlh, len);
+		return MNL_CB_ERROR;
+	}
+	return MNL_CB_STOP;
+}
+
+static mnl_cb_t mnlu_cb_array[NLMSG_MIN_TYPE] = {
+	[NLMSG_NOOP]	= mnlu_cb_noop,
+	[NLMSG_ERROR]	= mnlu_cb_error,
+	[NLMSG_DONE]	= mnlu_cb_stop,
+	[NLMSG_OVERRUN]	= mnlu_cb_noop,
+};
+
+int mnlu_socket_recv_run(struct mnl_socket *nl, unsigned int seq, void *buf, size_t buf_size,
+			 mnl_cb_t cb, void *data)
+{
+	unsigned int portid = mnl_socket_get_portid(nl);
+	int err;
+
+	do {
+		err = mnl_socket_recvfrom(nl, buf, buf_size);
+		if (err <= 0)
+			break;
+		err = mnl_cb_run2(buf, err, seq, portid,
+				  cb, data, mnlu_cb_array,
+				  ARRAY_SIZE(mnlu_cb_array));
+	} while (err > 0);
+
+	return err;
+}
-- 
2.25.1

