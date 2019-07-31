Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FE17C121
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 14:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbfGaMW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 08:22:29 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46077 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfGaMW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 08:22:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id y8so30439813plr.12;
        Wed, 31 Jul 2019 05:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BARg4dgRj/eeBMzSYjIXsyCBQnffvLr7GTQzYLrEu3w=;
        b=Wt0pU8JNIIJ+EGbiXSG8NrBYPOMzG/9e27ujtkIHfFPJmLoo2fk2xXS+iNkIpwlDwF
         AmHLikz5JE56rmkHyfEn82ZbgorukbUnXY+A7Y/+w4oEcviRvozMDzHdLIE+krPKiXQ7
         kNouteCK281XHHYCtAF29gLdWfmxhJdwlf9b/HfNCy7FrRSJm2dskGLpyMdSV/Lmhrb+
         ivkheRPxTMK5eFJS4llWvH1FBGUARBjyODavP7C9FVQHz/XC1mvybXypIOjKvVioZ+9s
         YQnngG5m0xdfiP90POx3EteeNeTawAni0PpKp7wwSNgnO3OlXc2uPVTm+19YiEXzM6lR
         yJ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BARg4dgRj/eeBMzSYjIXsyCBQnffvLr7GTQzYLrEu3w=;
        b=t9qOIyj3/vv45D4Izrb7dWQ/l6mM6CachBQXWbMdF/+OLkA1dkd1WAhxvEAdnbVeOY
         5mcRWtMDJEw6y4xfntaM66xjRNe4YIwa7etAyDhQ3ksomBmggDPjvYv7qR6qblvtiTWJ
         00Rg5U95CtoVnIYaxYRh8oHda4NOEQbxvsvDTXCBMFn6hT5eM1oTx1h2BOlqkM7dFgXZ
         ho6pFQgeYAqNdD3YlFiFaDvJzaiQ5DmdpWF11JoB4ZAre9hEAWvOCjmel4njlYndVQw2
         f7W5Kzx5X4ZhWM3GMLJIxDjHUlxASdiyVsUbwMKATaihJTfnJnfz5SdxyoVWfBP3BffU
         BnnA==
X-Gm-Message-State: APjAAAU+ADrDgOaBwx/C4QeuiDzRYTRqJG9WYZ8XoVSCzmWPAtNRHl3l
        Vd8JB34njbANJroZqKj95LQ=
X-Google-Smtp-Source: APXvYqzoLYMtQVZ0QolFwexSga3N5HBdBGndW6QMs9UQYoPr38zfLjEwYuQoTgqDUcxCl9dd8fgsww==
X-Received: by 2002:a17:902:2be8:: with SMTP id l95mr111781698plb.231.1564575748499;
        Wed, 31 Jul 2019 05:22:28 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id c23sm62040683pgj.62.2019.07.31.05.22.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 05:22:27 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 2/2] cnic: Use refcount_t for refcount
Date:   Wed, 31 Jul 2019 20:22:24 +0800
Message-Id: <20190731122224.1003-1-hslester96@gmail.com>
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

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/broadcom/cnic.c    | 26 ++++++++++++-------------
 drivers/net/ethernet/broadcom/cnic_if.h |  6 +++---
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index 57dc3cbff36e..215777d63cda 100644
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
+	refcount_set(&ulp_ops->ref_count, 0);
 	rcu_assign_pointer(cnic_ulp_tbl[ulp_type], ulp_ops);
 	mutex_unlock(&cnic_lock);
 
@@ -545,12 +545,12 @@ int cnic_unregister_driver(int ulp_type)
 
 	mutex_unlock(&cnic_lock);
 	synchronize_rcu();
-	while ((atomic_read(&ulp_ops->ref_count) != 0) && (i < 20)) {
+	while ((refcount_read(&ulp_ops->ref_count) != 0) && (i < 20)) {
 		msleep(100);
 		i++;
 	}
 
-	if (atomic_read(&ulp_ops->ref_count) != 0)
+	if (refcount_read(&ulp_ops->ref_count) != 0)
 		pr_warn("%s: Failed waiting for ref count to go to zero\n",
 			__func__);
 	return 0;
@@ -3596,7 +3596,7 @@ static int cnic_cm_create(struct cnic_dev *dev, int ulp_type, u32 cid,
 	}
 
 	csk1 = &cp->csk_tbl[l5_cid];
-	if (atomic_read(&csk1->ref_count))
+	if (refcount_read(&csk1->ref_count))
 		return -EAGAIN;
 
 	if (test_and_set_bit(SK_F_INUSE, &csk1->flags))
@@ -3651,7 +3651,7 @@ static int cnic_cm_destroy(struct cnic_sock *csk)
 	csk_hold(csk);
 	clear_bit(SK_F_INUSE, &csk->flags);
 	smp_mb__after_atomic();
-	while (atomic_read(&csk->ref_count) != 1)
+	while (refcount_read(&csk->ref_count) != 1)
 		msleep(1);
 	cnic_cm_cleanup(csk);
 
@@ -5432,11 +5432,11 @@ static void cnic_free_dev(struct cnic_dev *dev)
 {
 	int i = 0;
 
-	while ((atomic_read(&dev->ref_count) != 0) && i < 10) {
+	while ((refcount_read(&dev->ref_count) != 0) && i < 10) {
 		msleep(100);
 		i++;
 	}
-	if (atomic_read(&dev->ref_count) != 0)
+	if (refcount_read(&dev->ref_count) != 0)
 		netdev_err(dev->netdev, "Failed waiting for ref count to go to zero\n");
 
 	netdev_info(dev->netdev, "Removed CNIC device\n");
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

