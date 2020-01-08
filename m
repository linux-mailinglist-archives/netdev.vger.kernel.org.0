Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81BC1134A26
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbgAHSGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:06:23 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45103 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730092AbgAHSGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:06:11 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yishaih@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [10.7.2.17])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 008I65Oc030033;
        Wed, 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [127.0.0.1])
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8) with ESMTP id 008I65SH022338;
        Wed, 8 Jan 2020 20:06:05 +0200
Received: (from yishaih@localhost)
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8/Submit) id 008I65TY022337;
        Wed, 8 Jan 2020 20:06:05 +0200
From:   Yishai Hadas <yishaih@mellanox.com>
To:     linux-rdma@vger.kernel.org, jgg@mellanox.com, dledford@redhat.com
Cc:     saeedm@mellanox.com, yishaih@mellanox.com, maorg@mellanox.com,
        michaelgur@mellanox.com, netdev@vger.kernel.org
Subject: [PATCH rdma-next 06/10] RDMA/core: Add optional access flags range
Date:   Wed,  8 Jan 2020 20:05:36 +0200
Message-Id: <1578506740-22188-7-git-send-email-yishaih@mellanox.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Define a range of access flags that are defined to be optional, both
uverbs and drivers should enable getting them and use if they are
applicable

This will be used, for example, for the relaxed ordering access flag
which unsupporting drivers can ignore.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
---
 include/rdma/ib_verbs.h                 | 4 +++-
 include/uapi/rdma/ib_user_ioctl_verbs.h | 7 +++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a104e1c..ffb358f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1419,7 +1419,9 @@ enum ib_access_flags {
 	IB_ACCESS_ON_DEMAND = IB_UVERBS_ACCESS_ON_DEMAND,
 	IB_ACCESS_HUGETLB = IB_UVERBS_ACCESS_HUGETLB,
 
-	IB_ACCESS_SUPPORTED = ((IB_ACCESS_HUGETLB << 1) - 1)
+	IB_ACCESS_OPTIONAL = IB_UVERBS_ACCESS_OPTIONAL_RANGE,
+	IB_ACCESS_SUPPORTED =
+		((IB_ACCESS_HUGETLB << 1) - 1) | IB_ACCESS_OPTIONAL,
 };
 
 /*
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index 9019b2d..76dbbd9 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -41,6 +41,9 @@
 #define RDMA_UAPI_PTR(_type, _name)	__aligned_u64 _name
 #endif
 
+#define IB_UVERBS_ACCESS_OPTIONAL_FIRST (1 << 20)
+#define IB_UVERBS_ACCESS_OPTIONAL_LAST (1 << 29)
+
 enum ib_uverbs_access_flags {
 	IB_UVERBS_ACCESS_LOCAL_WRITE = 1 << 0,
 	IB_UVERBS_ACCESS_REMOTE_WRITE = 1 << 1,
@@ -50,6 +53,10 @@ enum ib_uverbs_access_flags {
 	IB_UVERBS_ACCESS_ZERO_BASED = 1 << 5,
 	IB_UVERBS_ACCESS_ON_DEMAND = 1 << 6,
 	IB_UVERBS_ACCESS_HUGETLB = 1 << 7,
+
+	IB_UVERBS_ACCESS_OPTIONAL_RANGE =
+		((IB_UVERBS_ACCESS_OPTIONAL_LAST << 1) - 1) &
+		~(IB_UVERBS_ACCESS_OPTIONAL_FIRST - 1)
 };
 
 enum ib_uverbs_query_port_cap_flags {
-- 
1.8.3.1

