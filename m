Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA532B116A
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgKLW0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgKLW0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 17:26:11 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FC9C0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:26:11 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4CXGQm1RLPzQlXc;
        Thu, 12 Nov 2020 23:26:08 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1605219966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HQljg/nd8YNyMVPl1dJEdxLDy2LuGivGEot1LFvtSGU=;
        b=hXsy07KZh2eEcmwDVm2gEHqezzpJr5f5WUf5AtPh4TksimbQS9mbgzuVT3li81o0pSyOjv
        xWH2X0K1Ttc+vNSkoOmjC3AX5CqFHshuhEKSTpBM5DEWlPjaw8cFu74Zs14eMX1K/fjC7z
        qaHW5lVNK1uOuhwi2BU7PmmJWX7PfTbDVm1lAOpkIaRlCMYUSrN7DY2ePdfBIwhZuXyXM4
        ZinnCxGng2UQkOFCusAOgOeb9LxVTbpkYW99aczd4f3tbJs/iecVR+bN64xVhT1Wk/fY5Q
        oSu9WJTECd50b4CKOaC9d2Ldj8LLcV/3s0YFlJpqGjS/Ny3HSgSnZcDHKoV5og==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id T_NZT8Z_i7DM; Thu, 12 Nov 2020 23:26:04 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next v5 05/11] lib: Extract from devlink/mnlg a helper, mnlu_msg_prepare()
Date:   Thu, 12 Nov 2020 23:24:42 +0100
Message-Id: <74d26658d2d0c7f6662b852c15117bba295cd793.1605218735.git.me@pmachata.org>
In-Reply-To: <cover.1605218735.git.me@pmachata.org>
References: <cover.1605218735.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.18 / 15.00 / 15.00
X-Rspamd-Queue-Id: 134521718
X-Rspamd-UID: 932d47
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

