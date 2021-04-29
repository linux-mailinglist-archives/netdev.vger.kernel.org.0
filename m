Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC6036E50E
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 08:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbhD2GtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 02:49:15 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:53159 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239097AbhD2GtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 02:49:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619678909; x=1651214909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jisvsmXSS9hiUqpGnzFUMeYtD+Lk4C7wFOXWw7+yy7o=;
  b=IBAkOiK4pHSS0K8Rb3EA65Gc4WZJMLrgvJzrC9AeSOOQJbcgu2PPSeE4
   YizzXc97ICmsGPWoxhooH6h9i1wvGcswGdlPOGV7F7Wo+LsDeXG0N1miQ
   jzEKLLReUddFBgNPtJKM3JN0oaftszjNwhyW/r96LS1nOnxdPHtx1IhK/
   4=;
X-IronPort-AV: E=Sophos;i="5.82,258,1613433600"; 
   d="scan'208";a="131706902"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 29 Apr 2021 06:48:28 +0000
Received: from EX13D02EUC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 43F8C281FAE;
        Thu, 29 Apr 2021 06:48:25 +0000 (UTC)
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D02EUC002.ant.amazon.com (10.43.164.14) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 29 Apr 2021 06:48:24 +0000
Received: from 8c85908914bf.ant.amazon.com.com (10.85.98.110) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 29 Apr 2021 06:48:21 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     David Ahern <dsahern@gmail.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Yossi Leybovich <sleybo@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Gal Pressman <galpress@amazon.com>
Subject: [PATCH iproute2-next v2 2/2] rdma: Add copy-on-fork to get sys command
Date:   Thu, 29 Apr 2021 09:48:03 +0300
Message-ID: <20210429064803.58458-3-galpress@amazon.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210429064803.58458-1-galpress@amazon.com>
References: <20210429064803.58458-1-galpress@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new attribute indicates that the kernel copies DMA pages on fork,
hence fork support through madvise and MADV_DONTFORK is not needed.

If the attribute is not reported (expected on older kernels),
copy-on-fork is disabled.

Example:
$ rdma sys
netns shared copy-on-fork on

Signed-off-by: Gal Pressman <galpress@amazon.com>
---
 rdma/sys.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/rdma/sys.c b/rdma/sys.c
index 8fb565d70598..fd785b253e20 100644
--- a/rdma/sys.c
+++ b/rdma/sys.c
@@ -20,6 +20,7 @@ static const char *netns_modes_str[] = {
 static int sys_show_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	bool cof = false;
 
 	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
 
@@ -35,9 +36,17 @@ static int sys_show_parse_cb(const struct nlmsghdr *nlh, void *data)
 		else
 			mode_str = "unknown";
 
-		print_color_string(PRINT_ANY, COLOR_NONE, "netns", "netns %s\n",
+		print_color_string(PRINT_ANY, COLOR_NONE, "netns", "netns %s ",
 				   mode_str);
 	}
+
+	if (tb[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK])
+		cof = mnl_attr_get_u8(tb[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK]);
+
+	print_color_on_off(PRINT_ANY, COLOR_NONE, "copy-on-fork",
+			   "copy-on-fork %s\n",
+			   cof);
+
 	return MNL_CB_OK;
 }
 
-- 
2.31.1

