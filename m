Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A78E6429F
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 09:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfGJHZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 03:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbfGJHZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 03:25:18 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E5842083D;
        Wed, 10 Jul 2019 07:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562743517;
        bh=JkZplVn3xt35Y2dfqpZF1VmyrYiv+s/b60YHeHwbZsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlCA5NBz+2jAxDn+PiKI1YYSCgYJ8d+FKlCY43hAZpQKu1i/zOKG49nPiqnsUDPEm
         4w8HeZhG01Acj4NXyXbT0KpnkWQf8maFWpsKE2YRXmU6/pYK9Ohjq0n+JfU9IiK2LE
         v1Ifi49foPAuMHwvXFMP4qOloVBJE8q/CS+huG0k=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc 5/8] rdma: Make get_port_from_argv() returns valid port in strict port mode
Date:   Wed, 10 Jul 2019 10:24:52 +0300
Message-Id: <20190710072455.9125-6-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190710072455.9125-1-leon@kernel.org>
References: <20190710072455.9125-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

When strict_port is set, make get_port_from_argv() returns failure if
no valid port is specified.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/utils.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/rdma/utils.c b/rdma/utils.c
index aed1a3d0..95b669f3 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -56,7 +56,7 @@ bool rd_no_arg(struct rd *rd)
  * mlx5_1/1    | 1          | false
  * mlx5_1/-    | 0          | false
  *
- * In strict mode, /- will return error.
+ * In strict port mode, a non-0 port must be provided
  */
 static int get_port_from_argv(struct rd *rd, uint32_t *port,
 			      bool *is_dump_all, bool strict_port)
@@ -64,7 +64,7 @@ static int get_port_from_argv(struct rd *rd, uint32_t *port,
 	char *slash;
 
 	*port = 0;
-	*is_dump_all = true;
+	*is_dump_all = strict_port ? false : true;
 
 	slash = strchr(rd_argv(rd), '/');
 	/* if no port found, return 0 */
@@ -83,6 +83,9 @@ static int get_port_from_argv(struct rd *rd, uint32_t *port,
 		if (!*port && strlen(slash))
 			return -EINVAL;
 	}
+	if (strict_port && (*port == 0))
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.20.1

