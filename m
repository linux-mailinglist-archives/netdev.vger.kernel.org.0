Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A0F2E8B20
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 07:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbhACGRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 01:17:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:56548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbhACGRx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 01:17:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F32662078D;
        Sun,  3 Jan 2021 06:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609654632;
        bh=Nwg9ogr39Uv2julf1XzB71dEpJXIEW5QHP5Sui7qAi8=;
        h=From:To:Cc:Subject:Date:From;
        b=L+YdKR8NqZG3RHfmaXBds01t6+cHt+J2ulYjvY4FTAT9baSsIyA15N4NiEj63dIq3
         qp4Y6LVxjvw/7UXJTudsl5K4zKGW2XgcqdPdhtztyuhBVv4RShn2gjeYy5xHHZ+gVP
         TsS2TOQP3e5iti9U/MRPsuD1JOUYqbXD4f234Cy6QY963oszA4wM4rdoLKrtJYsnef
         XEVWmvvM39kV0HAvZPvol+JfTMC1lGVHWoplGqt0YCyC1vQ5N1nqKdFV9WlWA7VdrG
         519zlJU6d1ByLVus5SFTINVoy/0FSE5i1XmwPPeahSsaAO4q0XsKWrpXgivNHDgdhC
         4XOAU4x1Y1DKg==
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next v2] rdma: Add support for the netlink extack
Date:   Sun,  3 Jan 2021 08:17:06 +0200
Message-Id: <20210103061706.18313-1-leon@kernel.org>
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
David,

Just as a note, rdmatool is heavily influenced by the devlink and
general code should probably be applicable for both tools. Most likely
that any core refactoring/fix in the devlink is needed for rdmatool too.

Thanks
----
Changelog:
v2: Reused already existing function to set extack.
v1: https://lore.kernel.org/linux-rdma/20201231054217.372274-1-leon@kernel.org
---
 rdma/rdma.h  |  1 +
 rdma/utils.c | 24 ++++--------------------
 2 files changed, 5 insertions(+), 20 deletions(-)

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
index 2a201aa4..903a544c 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -666,18 +666,12 @@ int rd_send_msg(struct rd *rd)
 {
 	int ret;

-	rd->nl = mnl_socket_open(NETLINK_RDMA);
+	rd->nl = mnlu_socket_open(NETLINK_RDMA);
 	if (!rd->nl) {
 		pr_err("Failed to open NETLINK_RDMA socket\n");
 		return -ENODEV;
 	}

-	ret = mnl_socket_bind(rd->nl, 0, MNL_SOCKET_AUTOPID);
-	if (ret < 0) {
-		pr_err("Failed to bind socket with err %d\n", ret);
-		goto err;
-	}
-
 	ret = mnl_socket_sendto(rd->nl, rd->nlh, rd->nlh->nlmsg_len);
 	if (ret < 0) {
 		pr_err("Failed to send to socket with err %d\n", ret);
@@ -692,23 +686,13 @@ err:

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

