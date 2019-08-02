Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C28447EE49
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403835AbfHBIFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:05:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37408 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403825AbfHBIFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 04:05:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id d1so2856325pgp.4;
        Fri, 02 Aug 2019 01:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HPa+ZG+Ucx3JNtlF4cB30guHK57ItTJmrqfJq8VvLG0=;
        b=m+qk+DeVFuYlLnI3EvDzEHtbtpugcKJkgnVgGVsmn/kUmQUQq37uTno78epH130f8a
         LFGuCLdWYXNtqOl9sQ2iDXkexf5qBuV0LoPD37y3GNFw75t0OD7LReEaZdKuv9zYcDGL
         Nmngo7XnD5YZKTldX9QYuZ/rGdRMjTE57Z9RJUFLjrDWuLtujEhLsX05cHpZC0vO0Yc7
         WyTrDMjrvXoR7L/7M0VcAWZ7qVA5SUSL+LlyWX7dG91f3xzbyvGgrNpSB+7jmynRvKlu
         lik3r49C9FFFNe0880NXOYnUN+WzIM1feLyBE1cvo7pT7blwGeFcWKtvfWcuYPRRD6Vg
         JIIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HPa+ZG+Ucx3JNtlF4cB30guHK57ItTJmrqfJq8VvLG0=;
        b=lmp9WJ3bDENtprkb/h6OWsyLPuVzrql62F1HFFLFe7QWrecbG2XnWmvavO3e2SRvXQ
         X9C1BQfrke+W+aIH6Y1G4WjwqN3EhJ7Vt5oeUUTKlC4G7JoW6cHE88vyHsUHmn1HMNrC
         4BAec31zkfATzrX7M3kSeXhd5M2ZMda8QTPjMdRW7UTgWnEWyvX0xTnQZSDBEWxdW/VR
         wAFReBQh3hVB4GXObGJS84aMuYZOsu2tjI9EQjov0CB1nYAVyifcj8R3z/E3LATY1Z8P
         APH9Ge8jg2J8Gvub3IsRfLkgq3ZncN4TBbhFea0oKUWWsl0T2DGZYZSk8rfLZJrBBr+s
         UVzw==
X-Gm-Message-State: APjAAAWZ5QITOaff4MjMI6kUrPZODZtMiDC4pw1LC66QW4miRzOecnbn
        F8wBTNF/7I6KaDTATh4ekd3Au0SNtoFM+A==
X-Google-Smtp-Source: APXvYqzoR24ostudhlNUMKWMa0thkbk8KPzLfnK7ACvdL/RfeTLR6q1bLKh1IwvgywloGzuvC9w9xg==
X-Received: by 2002:a63:5a0a:: with SMTP id o10mr50695395pgb.282.1564733144142;
        Fri, 02 Aug 2019 01:05:44 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id r2sm92536562pfl.67.2019.08.02.01.05.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 01:05:43 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2 2/2] cnic: Use refcount_t for refcount
Date:   Fri,  2 Aug 2019 16:05:39 +0800
Message-Id: <20190802080539.11222-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t is better for reference counters since its
implementation can prevent overflows.
So convert atomic_t ref counters to refcount_t.

This patch depends on the patch:
"cnic: Explicitly initialize all reference counts to 0."

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v2:
  - Convert refcount from 0-base to 1-base.

 drivers/net/ethernet/broadcom/cnic.c    | 30 ++++++++++++-------------
 drivers/net/ethernet/broadcom/cnic_if.h |  6 ++---
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index 155599dcee76..1f59f9606b85 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -141,22 +141,22 @@ static int cnic_uio_close(struct uio_info *uinfo, struct inode *inode)
 
 static inline void cnic_hold(struct cnic_dev *dev)
 {
-	atomic_inc(&dev->ref_count);
+	refcount_inc(&dev->ref_count);
 }
 
 static inline void cnic_put(struct cnic_dev *dev)
 {
-	atomic_dec(&dev->ref_count);
+	refcount_dec(&dev->ref_count);
 }
 
 static inline void csk_hold(struct cnic_sock *csk)
 {
-	atomic_inc(&csk->ref_count);
+	refcount_inc(&csk->ref_count);
 }
 
 static inline void csk_put(struct cnic_sock *csk)
 {
-	atomic_dec(&csk->ref_count);
+	refcount_dec(&csk->ref_count);
 }
 
 static struct cnic_dev *cnic_from_netdev(struct net_device *netdev)
@@ -177,12 +177,12 @@ static struct cnic_dev *cnic_from_netdev(struct net_device *netdev)
 
 static inline void ulp_get(struct cnic_ulp_ops *ulp_ops)
 {
-	atomic_inc(&ulp_ops->ref_count);
+	refcount_inc(&ulp_ops->ref_count);
 }
 
 static inline void ulp_put(struct cnic_ulp_ops *ulp_ops)
 {
-	atomic_dec(&ulp_ops->ref_count);
+	refcount_dec(&ulp_ops->ref_count);
 }
 
 static void cnic_ctx_wr(struct cnic_dev *dev, u32 cid_addr, u32 off, u32 val)
@@ -494,7 +494,7 @@ int cnic_register_driver(int ulp_type, struct cnic_ulp_ops *ulp_ops)
 	}
 	read_unlock(&cnic_dev_lock);
 
-	atomic_set(&ulp_ops->ref_count, 0);
+	refcount_set(&ulp_ops->ref_count, 1);
 	rcu_assign_pointer(cnic_ulp_tbl[ulp_type], ulp_ops);
 	mutex_unlock(&cnic_lock);
 
@@ -545,12 +545,12 @@ int cnic_unregister_driver(int ulp_type)
 
 	mutex_unlock(&cnic_lock);
 	synchronize_rcu();
-	while ((atomic_read(&ulp_ops->ref_count) != 0) && (i < 20)) {
+	while ((refcount_read(&ulp_ops->ref_count) != 1) && (i < 20)) {
 		msleep(100);
 		i++;
 	}
 
-	if (atomic_read(&ulp_ops->ref_count) != 0)
+	if (refcount_read(&ulp_ops->ref_count) != 1)
 		pr_warn("%s: Failed waiting for ref count to go to zero\n",
 			__func__);
 	return 0;
@@ -3596,7 +3596,7 @@ static int cnic_cm_create(struct cnic_dev *dev, int ulp_type, u32 cid,
 	}
 
 	csk1 = &cp->csk_tbl[l5_cid];
-	if (atomic_read(&csk1->ref_count))
+	if (refcount_read(&csk1->ref_count) != 1)
 		return -EAGAIN;
 
 	if (test_and_set_bit(SK_F_INUSE, &csk1->flags))
@@ -3651,7 +3651,7 @@ static int cnic_cm_destroy(struct cnic_sock *csk)
 	csk_hold(csk);
 	clear_bit(SK_F_INUSE, &csk->flags);
 	smp_mb__after_atomic();
-	while (atomic_read(&csk->ref_count) != 1)
+	while (refcount_read(&csk->ref_count) != 2)
 		msleep(1);
 	cnic_cm_cleanup(csk);
 
@@ -4104,7 +4104,7 @@ static int cnic_cm_alloc_mem(struct cnic_dev *dev)
 		return -ENOMEM;
 
 	for (i = 0; i < MAX_CM_SK_TBL_SZ; i++)
-		atomic_set(&cp->csk_tbl[i].ref_count, 0);
+		refcount_set(&cp->csk_tbl[i].ref_count, 1);
 
 	port_id = prandom_u32();
 	port_id %= CNIC_LOCAL_PORT_RANGE;
@@ -5436,11 +5436,11 @@ static void cnic_free_dev(struct cnic_dev *dev)
 {
 	int i = 0;
 
-	while ((atomic_read(&dev->ref_count) != 0) && i < 10) {
+	while ((refcount_read(&dev->ref_count) != 1) && i < 10) {
 		msleep(100);
 		i++;
 	}
-	if (atomic_read(&dev->ref_count) != 0)
+	if (refcount_read(&dev->ref_count) != 1)
 		netdev_err(dev->netdev, "Failed waiting for ref count to go to zero\n");
 
 	netdev_info(dev->netdev, "Removed CNIC device\n");
@@ -5484,7 +5484,7 @@ static struct cnic_dev *cnic_alloc_dev(struct net_device *dev,
 	cdev->unregister_device = cnic_unregister_device;
 	cdev->iscsi_nl_msg_recv = cnic_iscsi_nl_msg_recv;
 	cdev->get_fc_npiv_tbl = cnic_get_fc_npiv_tbl;
-	atomic_set(&cdev->ref_count, 0);
+	refcount_set(&cdev->ref_count, 1);
 
 	cp = cdev->cnic_priv;
 	cp->dev = cdev;
diff --git a/drivers/net/ethernet/broadcom/cnic_if.h b/drivers/net/ethernet/broadcom/cnic_if.h
index 789e5c7e9311..5232a05ac7ba 100644
--- a/drivers/net/ethernet/broadcom/cnic_if.h
+++ b/drivers/net/ethernet/broadcom/cnic_if.h
@@ -300,7 +300,7 @@ struct cnic_sock {
 #define SK_F_CLOSING		7
 #define SK_F_HW_ERR		8
 
-	atomic_t ref_count;
+	refcount_t ref_count;
 	u32 state;
 	struct kwqe kwqe1;
 	struct kwqe kwqe2;
@@ -335,7 +335,7 @@ struct cnic_dev {
 #define CNIC_F_CNIC_UP		1
 #define CNIC_F_BNX2_CLASS	3
 #define CNIC_F_BNX2X_CLASS	4
-	atomic_t	ref_count;
+	refcount_t	ref_count;
 	u8		mac_addr[ETH_ALEN];
 
 	int		max_iscsi_conn;
@@ -378,7 +378,7 @@ struct cnic_ulp_ops {
 				  char *data, u16 data_size);
 	int (*cnic_get_stats)(void *ulp_ctx);
 	struct module *owner;
-	atomic_t ref_count;
+	refcount_t ref_count;
 };
 
 int cnic_register_driver(int ulp_type, struct cnic_ulp_ops *ulp_ops);
-- 
2.20.1

