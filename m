Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086F829327D
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389684AbgJTA7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389661AbgJTA66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:58:58 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D178C0613D1
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:58:58 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CFZy82GJqzQkm3;
        Tue, 20 Oct 2020 02:58:56 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603155534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zOFr59+7kVdMDUU/vlVjeIe6NFA6FcnD4T5Gz9qFq3Q=;
        b=EkTcs7/vJklYCrMRDkwXuFZuwZQIZ4gghH0M1dbh2nVD7neYwIJAX7lt5c0LkZzIeEnhPd
        qwbmBB5a6lD1pNkfni9Ejj32ZDsogFuckqHv+G6P4MWFkkS4RoXfOHUW+ME9kEkgme20GP
        0EcqAqn+RzgMUUQxlVmJhrBRn9cCf6QB1BJ0EU57uqh05evDafaWsBYLNM8ThrJkIWRy/S
        wQjNVArp/eOD8aLFFmFP3lZtcRSmlu4gZP/JhyM00Tv+oAAM53abgVbqdRagzYmOYfJaZD
        uNXmYsgpDB2plufLjmlL/hqoUfJkNxHnuN8dtS91+ueIupt+y6ZVJ3h03Y2sUA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id r_6kqv1mik3v; Tue, 20 Oct 2020 02:58:52 +0200 (CEST)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 10/15] lib: Extract from devlink/mnlg a helper, mnlu_socket_recv_run()
Date:   Tue, 20 Oct 2020 02:58:18 +0200
Message-Id: <0879bff80744c8253266054fb3da497cc9044376.1603154867.git.me@pmachata.org>
In-Reply-To: <cover.1603154867.git.me@pmachata.org>
References: <cover.1603154867.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.11 / 15.00 / 15.00
X-Rspamd-Queue-Id: 4BB6B17E0
X-Rspamd-UID: e5d71d
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
index 87df1e81faf5..e9461d6d6b6b 100644
--- a/lib/mnl_utils.c
+++ b/lib/mnl_utils.c
@@ -8,11 +8,14 @@
  *
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
@@ -52,3 +55,61 @@ struct nlmsghdr *mnlu_msg_prepare(void *buf, uint32_t nlmsg_type, uint16_t flags
 
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

