Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A2829327B
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389666AbgJTA67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389646AbgJTA66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:58:58 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB08CC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:58:57 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4CFZy76DykzQkjT;
        Tue, 20 Oct 2020 02:58:55 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603155533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z7CSWxwYJEwqPVE0qm7XiHWb0y7DmeBB1lZaj2VjhFg=;
        b=QMUqD8lBMDVo0jhxhXwv5iUM6a2gUZRbvIWqJu8cnp3La/nw6/fMmBa3pO/ck4exSQ4FwF
        cIqCykIgqessuCUJkoFlMXa3ZhTTjFAuRlDwWmvs2Jvkr801a8a038IwcMXJwvm/PQX0OV
        loA2zGoFOUzT+WfEStv0Ys8CB7hL8wstbUSVU8Aof0//+pbTD1QMkDcp4xev1gqY/qb2Wa
        E3we3cZgb6S3901ArbJNRIm7p6Z/GSxAVqs4MA+zk/0veQJ16cZfgDcAtSITvXYuuGGytu
        O0BzmTP5KipV0fGY37CLsmZYHSrRbhyaetH5KgNNZZEsAMns3hIVhXZz+wRuFA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id ygROeAtvvhir; Tue, 20 Oct 2020 02:58:52 +0200 (CEST)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 09/15] lib: Extract from devlink/mnlg a helper, mnlu_msg_prepare()
Date:   Tue, 20 Oct 2020 02:58:17 +0200
Message-Id: <2eb2e1b39a08fdff0b602dac55343a1e8769b133.1603154867.git.me@pmachata.org>
In-Reply-To: <cover.1603154867.git.me@pmachata.org>
References: <cover.1603154867.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.52 / 15.00 / 15.00
X-Rspamd-Queue-Id: 9D33015
X-Rspamd-UID: 83be8b
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allocation of a new netlink message with the two usual headers is reusable
with other netlink netlink message types. Extract it into a helper,
mnlu_msg_prepare(). Take the second header as an argument, instead of
passing in parameters to initialize it, and copy it in.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 devlink/mnlg.c      | 18 ++++++------------
 include/mnl_utils.h |  2 ++
 lib/mnl_utils.c     | 19 +++++++++++++++++++
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/devlink/mnlg.c b/devlink/mnlg.c
index 9817bbad5e7d..4995b7af06a3 100644
--- a/devlink/mnlg.c
+++ b/devlink/mnlg.c
@@ -14,7 +14,6 @@
 #include <string.h>
 #include <errno.h>
 #include <unistd.h>
-#include <time.h>
 #include <libmnl/libmnl.h>
 #include <linux/genetlink.h>
 
@@ -36,19 +35,14 @@ static struct nlmsghdr *__mnlg_msg_prepare(struct mnlg_socket *nlg, uint8_t cmd,
 					   uint16_t flags, uint32_t id,
 					   uint8_t version)
 {
+	struct genlmsghdr genl = {
+		.cmd = cmd,
+		.version = version,
+	};
 	struct nlmsghdr *nlh;
-	struct genlmsghdr *genl;
-
-	nlh = mnl_nlmsg_put_header(nlg->buf);
-	nlh->nlmsg_type	= id;
-	nlh->nlmsg_flags = flags;
-	nlg->seq = time(NULL);
-	nlh->nlmsg_seq = nlg->seq;
-
-	genl = mnl_nlmsg_put_extra_header(nlh, sizeof(struct genlmsghdr));
-	genl->cmd = cmd;
-	genl->version = version;
 
+	nlh = mnlu_msg_prepare(nlg->buf, id, flags, &genl, sizeof(genl));
+	nlg->seq = nlh->nlmsg_seq;
 	return nlh;
 }
 
diff --git a/include/mnl_utils.h b/include/mnl_utils.h
index 10a064afdfe8..86ce30f49a94 100644
--- a/include/mnl_utils.h
+++ b/include/mnl_utils.h
@@ -3,5 +3,7 @@
 #define __MNL_UTILS_H__ 1
 
 struct mnl_socket *mnlu_socket_open(int bus);
+struct nlmsghdr *mnlu_msg_prepare(void *buf, uint32_t nlmsg_type, uint16_t flags,
+				  void *extra_header, size_t extra_header_size);
 
 #endif /* __MNL_UTILS_H__ */
diff --git a/lib/mnl_utils.c b/lib/mnl_utils.c
index eecb11341651..87df1e81faf5 100644
--- a/lib/mnl_utils.c
+++ b/lib/mnl_utils.c
@@ -8,6 +8,8 @@
  *
  */
 
+#include <string.h>
+#include <time.h>
 #include <libmnl/libmnl.h>
 
 #include "mnl_utils.h"
@@ -33,3 +35,20 @@ err_bind:
 	mnl_socket_close(nl);
 	return NULL;
 }
+
+struct nlmsghdr *mnlu_msg_prepare(void *buf, uint32_t nlmsg_type, uint16_t flags,
+				  void *extra_header, size_t extra_header_size)
+{
+	struct nlmsghdr *nlh;
+	void *eh;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = nlmsg_type;
+	nlh->nlmsg_flags = flags;
+	nlh->nlmsg_seq = time(NULL);
+
+	eh = mnl_nlmsg_put_extra_header(nlh, extra_header_size);
+	memcpy(eh, extra_header, extra_header_size);
+
+	return nlh;
+}
-- 
2.25.1

