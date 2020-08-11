Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1294D241733
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 09:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgHKHcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 03:32:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgHKHcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 03:32:12 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FAEF20781;
        Tue, 11 Aug 2020 07:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597131132;
        bh=4Gz9wH5OhFfIvkBhnEs+7ma/ZF0CoVRNATaK8oqSIk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YczC/E+1+NEtGbzDvXe1Xug6qJa7OIapNx0S5ivosqkKorqzJO2QX7VL5v5qZ2yRw
         oGApOlJxYl6N6WWeAvGdIoH7OVbfunsOQHTG/Q6sqtkV7sbM2Ad45LyXpdnNy6PsQs
         aCnQ6+Z+WdvfHHJNiim6Dyp2QqCln+5p01ebFy2w=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc v1 1/2] rdma: Fix owner name for the kernel resources
Date:   Tue, 11 Aug 2020 10:32:00 +0300
Message-Id: <20200811073201.663398-2-leon@kernel.org>
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

Owner of kernel resources is printed in different format than user
resources to easy with the reader by simply looking on the name.
The kernel owner will have "[ ]" around the name.

Before this change:
[leonro@vm ~]$ rdma res show qp
link rocep0s9/1 lqpn 1 type GSI state RTS sq-psn 58 comm ib_core

After this change:
[leonro@vm ~]$ rdma res show qp
link rocep0s9/1 lqpn 1 type GSI state RTS sq-psn 58 comm [ib_core]

Fixes: b0a688a542cd ("rdma: Rewrite custom JSON and prints logic to use common API")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 rdma/res.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rdma/res.c b/rdma/res.c
index c99a1fcb..b7a703f8 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -157,11 +157,11 @@ void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line)
 	if (!str)
 		return;

-	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PID] || rd->json_output)
 		snprintf(tmp, sizeof(tmp), "%s", str);
 	else
 		snprintf(tmp, sizeof(tmp), "[%s]", str);
-	print_color_string(PRINT_ANY, COLOR_NONE, "comm", "comm %s ", str);
+	print_color_string(PRINT_ANY, COLOR_NONE, "comm", "comm %s ", tmp);
 }

 void print_dev(struct rd *rd, uint32_t idx, const char *name)
--
2.26.2

