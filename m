Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44AC2E7E48
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 06:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgLaFnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Dec 2020 00:43:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgLaFnE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Dec 2020 00:43:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95C1322227;
        Thu, 31 Dec 2020 05:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609393344;
        bh=ZnULMQMtKVi3bXCP/jJRZEy1isrF8G603e/o/mzya9M=;
        h=From:To:Cc:Subject:Date:From;
        b=C5m6ZxGx+VQ6+S9Yw07gIB77YSJRQnCotouG6vGP2QSbXCeg0gZXb9nZObro2zDSB
         2w58C0Uq4EmTPBmTK+a1c3ZuXaZb02mHp5TOve9YO7s/4RjpcyCUPS/66o39ioyOo/
         i/XaoGTFHQ8h8t4r90IV0NS+RE41GV9+S9ED0+3bpOYaiqc3uKrnHYm7GUSvdOisXX
         Ox/mOpEJFGUJhZ5f70xHKIydgJ/Nc60f6vKo2Jc3+u47F9KXXBfO7B1Ji0w5YUihZL
         mX20t8F2OcDNCoDYY7X5I8Dlqme5Pf3SW/lmUtNwZZOKO8+/Vb2gHKVNzQHVAQq8LL
         Ftvc4xTkg6D4g==
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next] rdma: Add support for the netlink extack
Date:   Thu, 31 Dec 2020 07:42:17 +0200
Message-Id: <20201231054217.372274-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrisious Haddad <phaddad@nvidia.com>

Add support in rdma for extack errors to be received
in userspace when sent from kernel, so now netlink extack
error messages sent from kernel would be printed for the
user.

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Kernel part:
https://lore.kernel.org/linux-rdma/20201230130240.180737-1-leon@kernel.org
---
 rdma/rdma.h  |  1 +
 rdma/utils.c | 24 ++++++++++--------------
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/rdma/rdma.h b/rdma/rdma.h
index fc8bcf09..470e11c8 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -19,6 +19,7 @@

 #include "list.h"
 #include "utils.h"
+#include "mnl_utils.h"
 #include "json_print.h"

 #define pr_err(args...) fprintf(stderr, ##args)
diff --git a/rdma/utils.c b/rdma/utils.c
index 2a201aa4..927e2107 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -664,7 +664,7 @@ void rd_prepare_msg(struct rd *rd, uint32_t cmd, uint32_t *seq, uint16_t flags)

 int rd_send_msg(struct rd *rd)
 {
-	int ret;
+	int ret, one;

 	rd->nl = mnl_socket_open(NETLINK_RDMA);
 	if (!rd->nl) {
@@ -672,6 +672,12 @@ int rd_send_msg(struct rd *rd)
 		return -ENODEV;
 	}

+	ret = mnl_socket_setsockopt(rd->nl, NETLINK_EXT_ACK, &one, sizeof(one));
+	if (ret < 0) {
+		pr_err("Failed to set socket option with err %d\n", ret);
+		goto err;
+	}
+
 	ret = mnl_socket_bind(rd->nl, 0, MNL_SOCKET_AUTOPID);
 	if (ret < 0) {
 		pr_err("Failed to bind socket with err %d\n", ret);
@@ -692,23 +698,13 @@ err:

 int rd_recv_msg(struct rd *rd, mnl_cb_t callback, void *data, unsigned int seq)
 {
-	int ret;
-	unsigned int portid;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
+	int ret;

-	portid = mnl_socket_get_portid(rd->nl);
-	do {
-		ret = mnl_socket_recvfrom(rd->nl, buf, sizeof(buf));
-		if (ret <= 0)
-			break;
-
-		ret = mnl_cb_run(buf, ret, seq, portid, callback, data);
-	} while (ret > 0);
-
+	ret = mnlu_socket_recv_run(rd->nl, seq, buf, MNL_SOCKET_BUFFER_SIZE,
+				   callback, data);
 	if (ret < 0 && !rd->suppress_errors)
 		perror("error");
-
-	mnl_socket_close(rd->nl);
 	return ret;
 }

--
2.29.2

