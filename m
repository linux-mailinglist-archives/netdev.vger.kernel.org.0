Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067C4241735
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 09:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgHKHcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 03:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgHKHcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 03:32:17 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6BC020781;
        Tue, 11 Aug 2020 07:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597131136;
        bh=Chc+S6S4r3jtmXyw0l7GaeOpzr4w4HiPX7etvrVjcLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7PpGfrvqPO4nTMUZjQbD0fCOhX3N2vccfusMZT1MrZ9ndsrn9cnHUjC+yItTxn4h
         Lw0QXQxXWlHG97e3T6ghtnJKKVuPNetopBj9FuKJaLYdFzg3nJq7I7pccS6SSUjVIl
         2UDxxdiT5nc3u8oIKktXHgBp8JFrPoSADn5SyzeI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc v1 2/2] rdma: Properly print device and link names in CLI output
Date:   Tue, 11 Aug 2020 10:32:01 +0300
Message-Id: <20200811073201.663398-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200811073201.663398-1-leon@kernel.org>
References: <20200811073201.663398-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The citied commit broke the CLI output and printed ifindex/ifname
instead of dev/link.

Before:
[leonro@vm ~]$ rdma res show qp
link mlx5_0/lqpn 1 type GSI state RTS sq-psn 0 comm ib_core
[leonro@vm ~]$ rdma res show cq
ifindex 0 ifname rocep0s9 cqn 0 cqe 1023 users 2 poll-ctx WORKQUEUE adaptive-moderation on comm ib_core

After:
[leonro@vm ~]$ rdma res show qp
link mlx5_0/- lqpn 1 type GSI state RTS sq-psn 0 comm [ib_core]
[leonro@vm ~]$ rdma res show cq
dev rocep0s9 cqn 0 cqe 1023 users 2 poll-ctx WORKQUEUE adaptive-moderation on comm [ib_core]

It was missed because rdmatool mostly used in JSON mode.

Fixes: b0a688a542cd ("rdma: Rewrite custom JSON and prints logic to use common API")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 rdma/res.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/rdma/res.c b/rdma/res.c
index b7a703f8..dc12bbe4 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -166,17 +166,27 @@ void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line)

 void print_dev(struct rd *rd, uint32_t idx, const char *name)
 {
-	print_color_int(PRINT_ANY, COLOR_NONE, "ifindex", "ifindex %d ", idx);
-	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "ifname %s ", name);
+	print_color_int(PRINT_ANY, COLOR_NONE, "ifindex", NULL, idx);
+	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "dev %s ", name);
 }

 void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
 		struct nlattr **nla_line)
 {
+	char tmp[64] = {};
+
 	print_color_uint(PRINT_JSON, COLOR_NONE, "ifindex", NULL, idx);
-	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "link %s/", name);
-	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
-		print_color_uint(PRINT_ANY, COLOR_NONE, "port", "%u ", port);
+	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", NULL, name);
+	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]) {
+		print_color_uint(PRINT_ANY, COLOR_NONE, "port", NULL, port);
+		snprintf(tmp, sizeof(tmp), "%s/%d", name, port);
+	} else {
+		snprintf(tmp, sizeof(tmp), "%s/-", name);
+	}
+
+	if (!rd->json_output)
+		print_color_string(PRINT_ANY, COLOR_NONE, NULL, "link %s ",
+				   tmp);
 }

 void print_qp_type(struct rd *rd, uint32_t val)
--
2.26.2

