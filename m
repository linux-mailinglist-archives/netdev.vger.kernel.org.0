Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4138D1E1FC3
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 12:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731900AbgEZKdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 06:33:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731745AbgEZKdg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 06:33:36 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24F3A2086A;
        Tue, 26 May 2020 10:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590489215;
        bh=dzqvhtpLkofEHaV2L3738BnH0FvXH20o9HIlfF46rRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1DFZ/++4sBSd5e/tAe1qVYb8Z5ell8eJcabRETlBCTm5NoZeU2QmyKovnJgzKd1u
         ZUYzOs4N9uDc74CP808/+SKROtRUh5pI4/XqGJ6HtgHWkvOdjNvR0o5WKXtvS7Ym3n
         8fzegTcb8o1STFmqEzF6Kt7OtV9brvHQtDXz4ThI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        target-devel@vger.kernel.org
Subject: [PATCH rdma-next v3 6/6] RDMA/cma: Provide ECE reject reason
Date:   Tue, 26 May 2020 13:33:04 +0300
Message-Id: <20200526103304.196371-7-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526103304.196371-1-leon@kernel.org>
References: <20200526103304.196371-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

IBTA declares "vendor option not supported" reject reason in REJ
messages if passive side doesn't want to accept proposed ECE options.

Due to the fact that ECE is managed by userspace, there is a need to let
users to provide such rejected reason.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/cma.c           |  9 ++++-----
 drivers/infiniband/core/ucma.c          | 15 ++++++++++++++-
 drivers/infiniband/ulp/isert/ib_isert.c |  4 ++--
 drivers/infiniband/ulp/rtrs/rtrs-srv.c  |  2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c   |  3 ++-
 drivers/nvme/target/rdma.c              |  3 ++-
 include/rdma/rdma_cm.h                  |  2 +-
 include/uapi/rdma/rdma_user_cm.h        |  3 ++-
 net/rds/ib_cm.c                         |  4 +++-
 9 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d449afe5557b..8026ee56546a 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4196,7 +4196,7 @@ int __rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param,
 	return 0;
 reject:
 	cma_modify_qp_err(id_priv);
-	rdma_reject(id, NULL, 0);
+	rdma_reject(id, NULL, 0, IB_CM_REJ_CONSUMER_DEFINED);
 	return ret;
 }
 EXPORT_SYMBOL(__rdma_accept);
@@ -4236,7 +4236,7 @@ int rdma_notify(struct rdma_cm_id *id, enum ib_event_type event)
 EXPORT_SYMBOL(rdma_notify);
 
 int rdma_reject(struct rdma_cm_id *id, const void *private_data,
-		u8 private_data_len)
+		u8 private_data_len, u8 reason)
 {
 	struct rdma_id_private *id_priv;
 	int ret;
@@ -4251,9 +4251,8 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 						private_data, private_data_len);
 		} else {
 			trace_cm_send_rej(id_priv);
-			ret = ib_send_cm_rej(id_priv->cm_id.ib,
-					     IB_CM_REJ_CONSUMER_DEFINED, NULL,
-					     0, private_data, private_data_len);
+			ret = ib_send_cm_rej(id_priv->cm_id.ib, reason, NULL, 0,
+					     private_data, private_data_len);
 		}
 	} else if (rdma_cap_iw_cm(id->device, id->port_num)) {
 		ret = iw_cm_reject(id_priv->cm_id.iw,
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 6b27b210b890..5b87eee8ccc8 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -52,6 +52,7 @@
 #include <rdma/rdma_cm_ib.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib.h>
+#include <rdma/ib_cm.h>
 #include <rdma/rdma_netlink.h>
 #include "core_priv.h"
 
@@ -1181,12 +1182,24 @@ static ssize_t ucma_reject(struct ucma_file *file, const char __user *inbuf,
 	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
 		return -EFAULT;
 
+	if (!cmd.reason)
+		cmd.reason = IB_CM_REJ_CONSUMER_DEFINED;
+
+	switch (cmd.reason) {
+	case IB_CM_REJ_CONSUMER_DEFINED:
+	case IB_CM_REJ_VENDOR_OPTION_NOT_SUPPORTED:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	ctx = ucma_get_ctx_dev(file, cmd.id);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
 	mutex_lock(&ctx->mutex);
-	ret = rdma_reject(ctx->cm_id, cmd.private_data, cmd.private_data_len);
+	ret = rdma_reject(ctx->cm_id, cmd.private_data, cmd.private_data_len,
+			  cmd.reason);
 	mutex_unlock(&ctx->mutex);
 	ucma_put_ctx(ctx);
 	return ret;
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index a1a035270cab..7bc598d7a15c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -502,7 +502,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	if (!np->enabled) {
 		spin_unlock_bh(&np->np_thread_lock);
 		isert_dbg("iscsi_np is not enabled, reject connect request\n");
-		return rdma_reject(cma_id, NULL, 0);
+		return rdma_reject(cma_id, NULL, 0, IB_CM_REJ_CONSUMER_DEFINED);
 	}
 	spin_unlock_bh(&np->np_thread_lock);
 
@@ -553,7 +553,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	isert_free_login_buf(isert_conn);
 out:
 	kfree(isert_conn);
-	rdma_reject(cma_id, NULL, 0);
+	rdma_reject(cma_id, NULL, 0, IB_CM_REJ_CONSUMER_DEFINED);
 	return ret;
 }
 
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 5ef8988ee75b..67d164ff5aaa 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1576,7 +1576,7 @@ static int rtrs_rdma_do_reject(struct rdma_cm_id *cm_id, int errno)
 		.errno = cpu_to_le16(errno),
 	};
 
-	err = rdma_reject(cm_id, &msg, sizeof(msg));
+	err = rdma_reject(cm_id, &msg, sizeof(msg), IB_CM_REJ_CONSUMER_DEFINED);
 	if (err)
 		pr_err("rdma_reject(), err: %d\n", err);
 
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index a294630f2100..cdc8c239d6c0 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2497,7 +2497,8 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 				   SRP_BUF_FORMAT_INDIRECT);
 
 	if (rdma_cm_id)
-		rdma_reject(rdma_cm_id, rej, sizeof(*rej));
+		rdma_reject(rdma_cm_id, rej, sizeof(*rej),
+			    IB_CM_REJ_CONSUMER_DEFINED);
 	else
 		ib_send_cm_rej(ib_cm_id, IB_CM_REJ_CONSUMER_DEFINED, NULL, 0,
 			       rej, sizeof(*rej));
diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index fd47de0e4e4e..30a0a9adaddd 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1138,7 +1138,8 @@ static int nvmet_rdma_cm_reject(struct rdma_cm_id *cm_id,
 	rej.recfmt = cpu_to_le16(NVME_RDMA_CM_FMT_1_0);
 	rej.sts = cpu_to_le16(status);
 
-	return rdma_reject(cm_id, (void *)&rej, sizeof(rej));
+	return rdma_reject(cm_id, (void *)&rej, sizeof(rej),
+			   IB_CM_REJ_CONSUMER_DEFINED);
 }
 
 static struct nvmet_rdma_queue *
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 7ac91677660f..939d7abe026f 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -320,7 +320,7 @@ int rdma_notify(struct rdma_cm_id *id, enum ib_event_type event);
  * rdma_reject - Called to reject a connection request or response.
  */
 int rdma_reject(struct rdma_cm_id *id, const void *private_data,
-		u8 private_data_len);
+		u8 private_data_len, u8 reason);
 
 /**
  * rdma_disconnect - This function disconnects the associated QP and
diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
index 6b883dde7064..ed5a514305c1 100644
--- a/include/uapi/rdma/rdma_user_cm.h
+++ b/include/uapi/rdma/rdma_user_cm.h
@@ -238,7 +238,8 @@ struct rdma_ucm_accept {
 struct rdma_ucm_reject {
 	__u32 id;
 	__u8  private_data_len;
-	__u8  reserved[3];
+	__u8  reason;
+	__u8  reserved[2];
 	__u8  private_data[RDMA_MAX_PRIVATE_DATA];
 };
 
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index c71f4328d138..0fec4171564e 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -37,6 +37,7 @@
 #include <linux/vmalloc.h>
 #include <linux/ratelimit.h>
 #include <net/addrconf.h>
+#include <rdma/ib_cm.h>
 
 #include "rds_single_path.h"
 #include "rds.h"
@@ -927,7 +928,8 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
 	if (conn)
 		mutex_unlock(&conn->c_cm_lock);
 	if (err)
-		rdma_reject(cm_id, &err, sizeof(int));
+		rdma_reject(cm_id, &err, sizeof(int),
+			    IB_CM_REJ_CONSUMER_DEFINED);
 	return destroy;
 }
 
-- 
2.26.2

