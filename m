Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1154393DA
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 12:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbhJYKjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 06:39:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230231AbhJYKje (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 06:39:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E174360E52;
        Mon, 25 Oct 2021 10:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635158232;
        bh=QGUHrwvC01NDSQx51abxS9V21OrpvuaE068eEMzyjEA=;
        h=From:To:Cc:Subject:Date:From;
        b=qeee9aayGB+Hb3ZLYDJBgq2MosI9jyOxhf0IxmC1eTOLJJZGp4fDR7/Eg62tuObov
         xNo8qXYR/bAkb7pnfB7S42/e2eODgz9qt1DIJ4aVwKi0uJi+4MmPYQ7+RFeQ0VSNTx
         g4Dkp7kON3OAGoRly/QWzw0/ZecXjwbP5wZqGqthS3KnHDONQSshg26I+NuVxZOz9Y
         cg2PgjCESMbPKYmk5KHwno8WYFu6eNcr6tHgzbeIQVt3JltOwZxMsdIW4AuhT/EFCG
         ZNGJNcf8gmmfohe8lU4E7Ca0lsiqTrP/sCEicq7kmfGD0FKGxsQ8ejp0wB/ztMofCH
         IaL4ba/07mp8Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Neta Ostrovsky <netao@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next] rdma: Fix SRQ resource tracking information json
Date:   Mon, 25 Oct 2021 13:37:07 +0300
Message-Id: <9c6d0a4841f89d67d8370e5663397ada99c87635.1635157955.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neta Ostrovsky <netao@nvidia.com>

Fix the json output for the QPs that are associated with the SRQ -
The qpn are now displayed in a json array.

Sample output before the fix:
$ rdma res show srq lqpn 126-141 -j -p
[ {
        "ifindex":0,
	"ifname":"ibp8s0f0",
	"srqn":4,
	"type":"BASIC",
	"lqpn":["126-128,130-140"],
	"pdn":9,
	"pid":3581,
	"comm":"ibv_srq_pingpon"
    },{
	"ifindex":0,
	"ifname":"ibp8s0f0",
	"srqn":5,
	"type":"BASIC",
	"lqpn":["141"],
	"pdn":10,
	"pid":3584,
	"comm":"ibv_srq_pingpon"
    } ]

Sample output after the fix:
$ rdma res show srq lqpn 126-141 -j -p
[ {
        "ifindex":0,
	"ifname":"ibp8s0f0",
	"srqn":4,
	"type":"BASIC",
	"lqpn":["126-128","130-140"],
	"pdn":9,
	"pid":3581,
	"comm":"ibv_srq_pingpon"
    },{
	"ifindex":0,
	"ifname":"ibp8s0f0",
	"srqn":5,
	"type":"BASIC",
	"lqpn":["141"],
	"pdn":10,
	"pid":3584,
	"comm":"ibv_srq_pingpon"
    } ]

Fixes: 9b272e138d23 ("rdma: Add SRQ resource tracking information")
Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 rdma/res-srq.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/rdma/res-srq.c b/rdma/res-srq.c
index c14ac5d8..5d8f3842 100644
--- a/rdma/res-srq.c
+++ b/rdma/res-srq.c
@@ -26,11 +26,24 @@ static void print_type(struct rd *rd, uint32_t val)
 			   srq_types_to_str(val));
 }
 
-static void print_qps(const char *str)
+static void print_qps(char *qp_str)
 {
-	if (!strlen(str))
+	char *qpn;
+
+	if (!strlen(qp_str))
 		return;
-	print_color_string(PRINT_ANY, COLOR_NONE, "lqpn", "lqpn %s ", str);
+
+	open_json_array(PRINT_ANY, "lqpn");
+	print_color_string(PRINT_FP, COLOR_NONE, NULL, " ", NULL);
+	qpn = strtok(qp_str, ",");
+	while (qpn) {
+		print_color_string(PRINT_ANY, COLOR_NONE, NULL, "%s", qpn);
+		qpn = strtok(NULL, ",");
+		if (qpn)
+			print_color_string(PRINT_FP, COLOR_NONE, NULL, ",", NULL);
+	}
+	print_color_string(PRINT_FP, COLOR_NONE, NULL, " ", NULL);
+	close_json_array(PRINT_JSON, NULL);
 }
 
 static int filter_srq_range_qps(struct rd *rd, struct nlattr **qp_line,
-- 
2.31.1

