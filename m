Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 127077F58D
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 12:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733230AbfHBKzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 06:55:13 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40689 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfHBKzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 06:55:13 -0400
Received: by mail-pf1-f194.google.com with SMTP id p184so35851593pfp.7;
        Fri, 02 Aug 2019 03:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s3ianRPCP2Zu9bnZaFDrTAINsaT4fxD5fOtOtR4Ftwg=;
        b=edKvkr2YLIpIwx88PyQUx4RInX3evd5YZicPc5fVUrirsHVeUJEV18bp69Zsr/uwZR
         7aEy0TZ09nh32GepyRrJ/2r4tgsVN4KfX4CvTzM9oCWZuVThYFYrEY86NzdIS42I3lvG
         W7hbLhLjK5sCECqKDZXL28jX4STloI6gjFBeF7BZaNGONsTPKTOLJHTc0zMFXRxKa/fd
         cIwHFYqkSOh0BkHPPorRoUVGUsANLrsYzVbkxP+hq3xNwhRy5iEsugguKukd63Q6WjEG
         RllZ1/urSwAAeorhM/DK5j3DUIXDFZyO8yD7wPISRGd2SLksT7PpLvUb6GiT5xRsQ9LQ
         kXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s3ianRPCP2Zu9bnZaFDrTAINsaT4fxD5fOtOtR4Ftwg=;
        b=pdXCeDdqtjbzetim8LIsIWUIHTercEVkad/DJID66f+LsjiODvhISL3UCy3OTRzbSn
         5y0RONrbZ4XaqGJBkAR2JanmRhpLWFiISZ+Cn0wXBT0B1sGiLe5TcWCjt802vnY7zwi9
         Ax1LI68QR0356WnlHMZuuLqSLPsjl+7tFdREXCeIPhxCuhZIK4eowP9FityqAG4Ke5XJ
         U4NDz7yjzquGZUBqhpqLgcq3F93q+TGUoZsvpx8xr4WC/VQE0QiwRSZSs75gyppINh44
         YMV/v75DI4Ebqj1dioZXU9olSLOD3rfaEPeyjF7KYn/UHFN3XEqJsoYS4amLzihCUNwG
         1mLA==
X-Gm-Message-State: APjAAAWQ25hSsDi96SksrZb1SCCj9xUOTmZRzzxZIZfbEozeyS/GK4cT
        uMHfREorWp5CuXV5mJdi4QQ=
X-Google-Smtp-Source: APXvYqwJ3AXNGPKR8CvVwn+1NJfF2I4wPyeLWTaJjlRgYhQbwttCQHeRPx8gz0KA9Lhih7E3N2eWXQ==
X-Received: by 2002:a62:874d:: with SMTP id i74mr57943418pfe.94.1564743312378;
        Fri, 02 Aug 2019 03:55:12 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id v7sm34909052pff.87.2019.08.02.03.55.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 03:55:11 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 2/2] ixgbe: Use refcount_t for refcount
Date:   Fri,  2 Aug 2019 18:55:07 +0800
Message-Id: <20190802105507.16650-1-hslester96@gmail.com>
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

Also convert refcount from 0-based to 1-based.

This patch depends on PATCH 1/2.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c | 6 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index 00710f43cfd2..d313d00065cd 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -773,7 +773,7 @@ int ixgbe_setup_fcoe_ddp_resources(struct ixgbe_adapter *adapter)
 
 	fcoe->extra_ddp_buffer = buffer;
 	fcoe->extra_ddp_buffer_dma = dma;
-	atomic_set(&fcoe->refcnt, 0);
+	refcount_set(&fcoe->refcnt, 1);
 
 	/* allocate pci pool for each cpu */
 	for_each_possible_cpu(cpu) {
@@ -837,7 +837,7 @@ int ixgbe_fcoe_enable(struct net_device *netdev)
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	struct ixgbe_fcoe *fcoe = &adapter->fcoe;
 
-	atomic_inc(&fcoe->refcnt);
+	refcount_inc(&fcoe->refcnt);
 
 	if (!(adapter->flags & IXGBE_FLAG_FCOE_CAPABLE))
 		return -EINVAL;
@@ -883,7 +883,7 @@ int ixgbe_fcoe_disable(struct net_device *netdev)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
-	if (!atomic_dec_and_test(&adapter->fcoe.refcnt))
+	if (!refcount_dec_and_test(&adapter->fcoe.refcnt))
 		return -EINVAL;
 
 	if (!(adapter->flags & IXGBE_FLAG_FCOE_ENABLED))
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.h
index 724f5382329f..7ace5fee6ede 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.h
@@ -51,7 +51,7 @@ struct ixgbe_fcoe_ddp_pool {
 
 struct ixgbe_fcoe {
 	struct ixgbe_fcoe_ddp_pool __percpu *ddp_pool;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	spinlock_t lock;
 	struct ixgbe_fcoe_ddp ddp[IXGBE_FCOE_DDP_MAX_X550];
 	void *extra_ddp_buffer;
-- 
2.20.1

