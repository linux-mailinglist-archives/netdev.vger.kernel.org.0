Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73012353BE9
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhDEFu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:50:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232096AbhDEFuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6483661393;
        Mon,  5 Apr 2021 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617601819;
        bh=546fGdgC8SELgOTgK16DtIQhtdQvE38vpzuMVIP5F1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ox73jiWftd/wanyKh8k00x9xX3j7k39NF4uvD1Ak6tQOV9KfBK+BZH8T1mUf5n+wR
         FJ2Nt4BbDlzYiGIz9mbnli/SEUh4JHAU2ASpED1/ocjPHChDnajmT22NXFM9WYbYL0
         w6Y4/xDB0Ty2VQo+g7a1gTiRiJ8eiOEKZIoKekwZji7Ybxg71daCG4POi2fX7h8NLW
         rIE2SfTJ7P3BXWivrnxPnUazMZaNSsnW6z8pntprtryMyAP3Z19uBYmQQzaFFNoW7R
         1pLFUV+S/50/gWtt+xdi2CC1PeSZQnlyH9XO1TrkK5n5S+q8mykPwUgQVw1gdTnioZ
         xeeSImH3O2VcA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: [PATCH rdma-next 5/8] IB/IPoIB: Skip device which doesn't have InfiniBand port
Date:   Mon,  5 Apr 2021 08:49:57 +0300
Message-Id: <20210405055000.215792-6-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405055000.215792-1-leon@kernel.org>
References: <20210405055000.215792-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Skip RDMA device which doesn't have InfiniBand ports using newly
introduced client_supported() callback.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 8f769ebaacc6..b02c10dea242 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -93,6 +93,7 @@ static struct net_device *ipoib_get_net_dev_by_params(
 		struct ib_device *dev, u32 port, u16 pkey,
 		const union ib_gid *gid, const struct sockaddr *addr,
 		void *client_data);
+static bool ipoib_client_supported(struct ib_device *device);
 static int ipoib_set_mac(struct net_device *dev, void *addr);
 static int ipoib_ioctl(struct net_device *dev, struct ifreq *ifr,
 		       int cmd);
@@ -102,6 +103,7 @@ static struct ib_client ipoib_client = {
 	.add    = ipoib_add_one,
 	.remove = ipoib_remove_one,
 	.get_net_dev_by_params = ipoib_get_net_dev_by_params,
+	.is_supported = ipoib_client_supported,
 };
 
 #ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
@@ -2530,6 +2532,17 @@ static struct net_device *ipoib_add_port(const char *format,
 	return ERR_PTR(-ENOMEM);
 }
 
+static bool ipoib_client_supported(struct ib_device *device)
+{
+	u32 i;
+
+	rdma_for_each_port(device, i) {
+		if (rdma_protocol_ib(device, i))
+			return true;
+	}
+	return false;
+}
+
 static int ipoib_add_one(struct ib_device *device)
 {
 	struct list_head *dev_list;
-- 
2.30.2

