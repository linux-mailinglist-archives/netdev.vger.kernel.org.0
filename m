Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3136C82976
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 04:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731148AbfHFCAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 22:00:01 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36604 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728922AbfHFCAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 22:00:01 -0400
Received: by mail-pf1-f196.google.com with SMTP id r7so40586834pfl.3;
        Mon, 05 Aug 2019 19:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/0O9dqOc4nkeJ0zaaFH6UPXk6SFA/EBytMbcsgVF30=;
        b=AF5zkB3spuoa5HbPRDmCMH7OiaoKbye1/HPrtOaeZ96bg1O5I+ia0Hg/yzspkdIPsw
         nOY6oXEnLtxodk3t8lb+Uj8WupJYJYVaYJ0YdV46ih87AYS7Q2V6D1E7eH8LJKrLs+aj
         sAlTAx1GjaGOMyJC/dmxP4DnsVgJawkuoNzjgT7fZ6n+nNDtC0S/Nw0XNLVAB3qg7GV8
         2PUqadSTSiSp48l/M0Am2YKpNvU40Eq69f4Qm0nS94fdvjlE2kkjpkIxMyz1VeK18qg+
         LZkaGnpx3hL0sHzUcGdm31zDtBs6MZcmcbZqkFMr/joPKRauqhwwcqIqnkRJWAQ5Hlpo
         w5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/0O9dqOc4nkeJ0zaaFH6UPXk6SFA/EBytMbcsgVF30=;
        b=E5xR0XaRd4o+A/6ByKVT/12kabqdBQp/9oamvotoUaLh2N2cK8pRUySYTpjI34Xy7q
         d/K3/JmaOZpV4mYNwGFK0tiEQkpSdGhUMt4mgntvLx8PcRI795EPc6NUOtVPU0D4HS3w
         yzvmjL80lEiqo3E13TwTnHwUOh9j+C1qWtEvkylErFlaVbTRbO5Na/j+xw1ZJEx2G84g
         QZkKm1Ti4VsORLVAKqp8qD/k/ODVZfuLg1URpkwaPV84aMHt5KFsKe3m+sQeGqy7cq0I
         KQrGrncqAmaTf3+ohN4v+OidQ3Egr/SOVVlghZNDmb4q3xRuN5fPFN3wbA0ifv2eQVuy
         /RjA==
X-Gm-Message-State: APjAAAVQmzXwh6mUA+Hg15ZicP+uumEP0X4pDcSnyIHQp+YYzhHgDBnY
        4JDKYpwAkYo7BnfPHIW3PiY=
X-Google-Smtp-Source: APXvYqzqyyTOM3FAXD4vhj+wSdzE/MyiJEoan+mQk+8LvdnrBeBgNSE7vJAJGcXcUNdE5lg8wxxIUA==
X-Received: by 2002:a65:65c5:: with SMTP id y5mr757366pgv.342.1565056800260;
        Mon, 05 Aug 2019 19:00:00 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id u23sm88548281pfn.140.2019.08.05.18.59.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 18:59:59 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v3] mlx5: Use refcount_t for refcount
Date:   Tue,  6 Aug 2019 09:59:50 +0800
Message-Id: <20190806015950.18167-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reference counters are preferred to use refcount_t instead of
atomic_t.
This is because the implementation of refcount_t can prevent
overflows and detect possible use-after-free.
So convert atomic_t ref counters to refcount_t.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v3:
  - Merge v2 patches together.

 drivers/infiniband/hw/mlx5/srq_cmd.c         | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 6 +++---
 include/linux/mlx5/driver.h                  | 3 ++-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq_cmd.c b/drivers/infiniband/hw/mlx5/srq_cmd.c
index b0d0687c7a68..8fc3630a9d4c 100644
--- a/drivers/infiniband/hw/mlx5/srq_cmd.c
+++ b/drivers/infiniband/hw/mlx5/srq_cmd.c
@@ -86,7 +86,7 @@ struct mlx5_core_srq *mlx5_cmd_get_srq(struct mlx5_ib_dev *dev, u32 srqn)
 	xa_lock(&table->array);
 	srq = xa_load(&table->array, srqn);
 	if (srq)
-		atomic_inc(&srq->common.refcount);
+		refcount_inc(&srq->common.refcount);
 	xa_unlock(&table->array);
 
 	return srq;
@@ -592,7 +592,7 @@ int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	if (err)
 		return err;
 
-	atomic_set(&srq->common.refcount, 1);
+	refcount_set(&srq->common.refcount, 1);
 	init_completion(&srq->common.free);
 
 	err = xa_err(xa_store_irq(&table->array, srq->srqn, srq, GFP_KERNEL));
@@ -675,7 +675,7 @@ static int srq_event_notifier(struct notifier_block *nb,
 	xa_lock(&table->array);
 	srq = xa_load(&table->array, srqn);
 	if (srq)
-		atomic_inc(&srq->common.refcount);
+		refcount_inc(&srq->common.refcount);
 	xa_unlock(&table->array);
 
 	if (!srq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index b8ba74de9555..7b44d1e49604 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -53,7 +53,7 @@ mlx5_get_rsc(struct mlx5_qp_table *table, u32 rsn)
 
 	common = radix_tree_lookup(&table->tree, rsn);
 	if (common)
-		atomic_inc(&common->refcount);
+		refcount_inc(&common->refcount);
 
 	spin_unlock_irqrestore(&table->lock, flags);
 
@@ -62,7 +62,7 @@ mlx5_get_rsc(struct mlx5_qp_table *table, u32 rsn)
 
 void mlx5_core_put_rsc(struct mlx5_core_rsc_common *common)
 {
-	if (atomic_dec_and_test(&common->refcount))
+	if (refcount_dec_and_test(&common->refcount))
 		complete(&common->free);
 }
 
@@ -209,7 +209,7 @@ static int create_resource_common(struct mlx5_core_dev *dev,
 	if (err)
 		return err;
 
-	atomic_set(&qp->common.refcount, 1);
+	refcount_set(&qp->common.refcount, 1);
 	init_completion(&qp->common.free);
 	qp->pid = current->pid;
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 0e6da1840c7d..5b56f343ce87 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -47,6 +47,7 @@
 #include <linux/interrupt.h>
 #include <linux/idr.h>
 #include <linux/notifier.h>
+#include <linux/refcount.h>
 
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/doorbell.h>
@@ -398,7 +399,7 @@ enum mlx5_res_type {
 
 struct mlx5_core_rsc_common {
 	enum mlx5_res_type	res;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct completion	free;
 };
 
-- 
2.20.1

