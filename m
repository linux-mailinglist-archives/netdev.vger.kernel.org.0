Return-Path: <netdev+bounces-7563-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67E777209C4
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 21:24:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16FB828183C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BFBB1E51C;
	Fri,  2 Jun 2023 19:24:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170AF17759
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 19:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CC1C433EF;
	Fri,  2 Jun 2023 19:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685733882;
	bh=BhF+dxcZ3BoeqOs7UhCd+5S9ER97FtkFR2y7DJ/8Cuw=;
	h=Subject:From:To:Cc:Date:From;
	b=FO0/GoRJrYWfhMzHk/IFxydtIN71DPq7dMKU2/CXEjb08UyNSweEXQjPNo2x2dHM3
	 cnq2YJqiOnvEX1kCpW05Kv5YF3sVro85dvyQHcSUj23CpsRYyz+eL6gtLZEorXTeEs
	 6w4EflKtSIljqoVrWPE3kVlu2ZFuJEGXWQKYfOU5MOWMG8RAYt3NIPqDdkjllEJK7+
	 p1da7bT/VXAxlixZi6KE2P2CDZLADDDTc6+rghQO509xmi8/0rqYaH5XEy0BZN07Or
	 q5aXPlpT3sQeZhWd3IxxkbCSSm5oHHSwanis4DhWumpAHtCRPmptM2uxwp2eLZONEA
	 4BJsCX9GhWgRQ==
Subject: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
From: Chuck Lever <cel@kernel.org>
To: jgg@nvidia.com
Cc: Chuck Lever <chuck.lever@oracle.com>, linux-rdma@vger.kernel.org,
 BMT@zurich.ibm.com, tom@talpey.com, netdev@vger.kernel.org
Date: Fri, 02 Jun 2023 15:24:30 -0400
Message-ID: 
 <168573386075.5660.5037682341906748826.stgit@oracle-102.nfsv4bat.org>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Chuck Lever <chuck.lever@oracle.com>

We would like to enable the use of siw on top of a VPN that is
constructed and managed via a tun device. That hasn't worked up
until now because ARPHRD_NONE devices (such as tun devices) have
no GID for the RDMA/core to look up.

But it turns out that the egress device has already been picked for
us. addr_handler() just has to do the right thing with it.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 drivers/infiniband/core/cma.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 56e568fcd32b..3351dc5afa17 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -704,11 +704,15 @@ cma_validate_port(struct ib_device *device, u32 port,
 		ndev = dev_get_by_index(dev_addr->net, bound_if_index);
 		if (!ndev)
 			return ERR_PTR(-ENODEV);
+	} else if (dev_type == ARPHRD_NONE) {
+		sgid_attr = rdma_get_gid_attr(device, port, 0);
+		goto out;
 	} else {
 		gid_type = IB_GID_TYPE_IB;
 	}
 
 	sgid_attr = rdma_find_gid_by_port(device, gid, gid_type, port, ndev);
+out:
 	dev_put(ndev);
 	return sgid_attr;
 }



