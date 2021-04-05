Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2B8353BF6
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhDEFuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232224AbhDEFue (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:50:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9546061395;
        Mon,  5 Apr 2021 05:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617601829;
        bh=OYi5oBfh+IkfxEpEvlyTxj1HUBFhA7hXBFWPylWIYsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHFr6cbp8xiOxYDsxElx2f7O7Ptj8Ct/tjaxo5V/6e9cALtKZuUkVoqFEGJedk4WS
         Kx7up2/a2QcbAfJj1MDAKg7p6nfhS4o+sL0khFkJ75Pj0D8GvA4VSrMeA84kzxYq6+
         ciUfTpG1BKIXZ9JACRrAnjgT1lEidobeE0O36OF0DFx8GkwDn2H6CJYKNoBvkV24rM
         YT6hHscu+FiA0fO/6aPja/Vx5sw1K7Ja6a+OXOliz1AfR8rZkE0hwV5WsvfZugBm8H
         1TQjrjKBOTZZXQT+6eCpF71cbOp+gwTs7DuI79vCkT6dO6SdCTh8ksbb1ae1haUJHl
         q2hC/gSz/SehA==
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
Subject: [PATCH rdma-next 4/8] IB/core: Skip device which doesn't have necessary capabilities
Date:   Mon,  5 Apr 2021 08:49:56 +0300
Message-Id: <20210405055000.215792-5-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405055000.215792-1-leon@kernel.org>
References: <20210405055000.215792-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

If device doesn't have multicast capability, avoid client registration
for it. This saves 16Kbytes of memory for a RDMA device consist of 128
ports.

If device doesn't support subnet administration, avoid client
registration for it. This saves 8Kbytes of memory for a RDMA device
consist of 128 ports.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/multicast.c | 15 ++++++++++++++-
 drivers/infiniband/core/sa_query.c  | 15 ++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index a5dd4b7a74bc..8c81acc24e3e 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -44,11 +44,13 @@
 
 static int mcast_add_one(struct ib_device *device);
 static void mcast_remove_one(struct ib_device *device, void *client_data);
+static bool mcast_client_supported(struct ib_device *device);
 
 static struct ib_client mcast_client = {
 	.name   = "ib_multicast",
 	.add    = mcast_add_one,
-	.remove = mcast_remove_one
+	.remove = mcast_remove_one,
+	.is_supported = mcast_client_supported,
 };
 
 static struct ib_sa_client	sa_client;
@@ -816,6 +818,17 @@ static void mcast_event_handler(struct ib_event_handler *handler,
 	}
 }
 
+static bool mcast_client_supported(struct ib_device *device)
+{
+	u32 i;
+
+	rdma_for_each_port(device, i) {
+		if (rdma_cap_ib_mcast(device, i))
+			return true;
+	}
+	return false;
+}
+
 static int mcast_add_one(struct ib_device *device)
 {
 	struct mcast_device *dev;
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 9a4a49c37922..7e00e24d9423 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -176,11 +176,13 @@ static const struct nla_policy ib_nl_policy[LS_NLA_TYPE_MAX] = {
 
 static int ib_sa_add_one(struct ib_device *device);
 static void ib_sa_remove_one(struct ib_device *device, void *client_data);
+static bool ib_sa_client_supported(struct ib_device *device);
 
 static struct ib_client sa_client = {
 	.name   = "sa",
 	.add    = ib_sa_add_one,
-	.remove = ib_sa_remove_one
+	.remove = ib_sa_remove_one,
+	.is_supported = ib_sa_client_supported,
 };
 
 static DEFINE_XARRAY_FLAGS(queries, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
@@ -2293,6 +2295,17 @@ static void ib_sa_event(struct ib_event_handler *handler,
 	}
 }
 
+static bool ib_sa_client_supported(struct ib_device *device)
+{
+	unsigned int i;
+
+	rdma_for_each_port(device, i) {
+		if (rdma_cap_ib_sa(device, i))
+			return true;
+	}
+	return false;
+}
+
 static int ib_sa_add_one(struct ib_device *device)
 {
 	struct ib_sa_device *sa_dev;
-- 
2.30.2

