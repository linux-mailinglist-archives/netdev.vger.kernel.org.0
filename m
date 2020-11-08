Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDA32AABBB
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 16:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgKHPIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 10:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728533AbgKHPIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 10:08:34 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50030C0613D2
        for <netdev@vger.kernel.org>; Sun,  8 Nov 2020 07:08:34 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4CTcvh5Z8szQlLT;
        Sun,  8 Nov 2020 16:08:32 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1604848110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HQljg/nd8YNyMVPl1dJEdxLDy2LuGivGEot1LFvtSGU=;
        b=Rp7zik3Ccp2W5Lq61Hs2HErKfRPH8IQX9WIUKWZKCkm8ngBS8qM5Sjy/T1qTNN9YX+8R+K
        cC5XHlHbAe7eYHB4D1PLASmh4k+9VRKhXFcQRIpg6XKpvh7QgMh5+Rkg1mCuZUJta0ZE/t
        MZX/2c5RK4vahOJRHyWV3/7sd/tuqKbXsFlfTxg60s0hgsDBBGsDxrMM/rygQ0Qk0Q2gLv
        Bssu122urljwPgxAriGOq+r7k3ztiI+EiiwmZwJcoLL7jxYUJQvXgLbHvM77I3LLAB1G4x
        MiTwWLy9jBTRYzDj5V/pE2eGZktmnaGkmRC/mEQ3vbX3GpdAmwoseY3h5srljg==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id G8UQLmTJ9zWN; Sun,  8 Nov 2020 16:08:29 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v3 05/11] lib: Extract from devlink/mnlg a helper, mnlu_msg_prepare()
Date:   Sun,  8 Nov 2020 16:07:26 +0100
Message-Id: <52cc2abecaa94ff64b981309d1d3c7ad2d66cf44.1604847919.git.me@pmachata.org>
In-Reply-To: <cover.1604847919.git.me@pmachata.org>
References: <cover.1604847919.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.56 / 15.00 / 15.00
X-Rspamd-Queue-Id: B4F801709
X-Rspamd-UID: 5b2b5b
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
index 2426912aa511..61e8060ecbca 100644
--- a/lib/mnl_utils.c
+++ b/lib/mnl_utils.c
@@ -3,6 +3,8 @@
  * mnl_utils.c	Helpers for working with libmnl.
  */
 
+#include <string.h>
+#include <time.h>
 #include <libmnl/libmnl.h>
 
 #include "mnl_utils.h"
@@ -28,3 +30,20 @@ err_bind:
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

