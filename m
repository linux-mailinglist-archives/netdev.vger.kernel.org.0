Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E749236D6B2
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 13:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhD1Lnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 07:43:53 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:33932 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhD1Lnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 07:43:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619610188; x=1651146188;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J9WlUV3BQ6kRTN7YPHMpT+ukyP5pRrtlyMvySC8qstA=;
  b=OBPZhnDNbOlOUAW6UX+vJCITLT0Q3vA0GutBwgAKDnI5Y0Ga4HTwKcmD
   9xHp8qZVTnJaB7kD2P1C4cE1T0Hoa25SQ0b6SnykdsYwtfkZglWakDb/7
   D0eviqhbq3ytsXcJCAamwyW4kNo9UnHQu64d77SdHt9/+r3vILIOfWky9
   g=;
X-IronPort-AV: E=Sophos;i="5.82,258,1613433600"; 
   d="scan'208";a="929710402"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 28 Apr 2021 11:43:04 +0000
Received: from EX13D13EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id E237DA2194;
        Wed, 28 Apr 2021 11:43:03 +0000 (UTC)
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D13EUA003.ant.amazon.com (10.43.165.25) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 28 Apr 2021 11:43:02 +0000
Received: from 8c85908914bf.ant.amazon.com.com (10.85.90.101) by
 mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 28 Apr 2021 11:42:59 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     David Ahern <dsahern@gmail.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Yossi Leybovich <sleybo@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Gal Pressman <galpress@amazon.com>
Subject: [PATCH iproute2-next 2/2] rdma: Add copy-on-fork to get sys command
Date:   Wed, 28 Apr 2021 14:42:31 +0300
Message-ID: <20210428114231.96944-3-galpress@amazon.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210428114231.96944-1-galpress@amazon.com>
References: <20210428114231.96944-1-galpress@amazon.com>
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
netns shared
copy-on-fork on

Signed-off-by: Gal Pressman <galpress@amazon.com>
---
 rdma/sys.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/rdma/sys.c b/rdma/sys.c
index 8fb565d70598..dd9c6da33e2a 100644
--- a/rdma/sys.c
+++ b/rdma/sys.c
@@ -38,6 +38,15 @@ static int sys_show_parse_cb(const struct nlmsghdr *nlh, void *data)
 		print_color_string(PRINT_ANY, COLOR_NONE, "netns", "netns %s\n",
 				   mode_str);
 	}
+
+	if (tb[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK])
+		print_color_on_off(PRINT_ANY, COLOR_NONE, "copy-on-fork",
+				   "copy-on-fork %s\n",
+				   mnl_attr_get_u8(tb[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK]));
+	else
+		print_color_on_off(PRINT_ANY, COLOR_NONE, "copy-on-fork",
+				   "copy-on-fork %s\n", false);
+
 	return MNL_CB_OK;
 }
 
-- 
2.31.1

