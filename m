Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911BE46DBA8
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 19:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239439AbhLHTAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhLHTAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:00:08 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A8BC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 10:56:35 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id k26so3225550pfp.10
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 10:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=xE04kmxKYuhjmq3lq7HpPRAolqRho3f+2YvI3TIv+Bw=;
        b=niIVyfZ+cOPterU7k8wAD8b2aP1YtZ+N4w4Kc2dKorcyXa0qW3fVxvfiiDUiv1Cs6p
         9uM7wwJakBjYuhYi6HfaqsusFgy9k2D5fCWwKJgp4OEX3Y+290KlYXBJUZ9k0ivGiPWE
         X9x3kbcw8Kx/HcSAhjM3HvxvBFSVlOlbxWlhs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xE04kmxKYuhjmq3lq7HpPRAolqRho3f+2YvI3TIv+Bw=;
        b=nGrPpeJi+2ptz88WH6sXyFQxVQwIDoG6+rEdB7Ui3pwszfs4UJGyydSNIlWtc68vvd
         PL/c8o0EQRUXlZSTn5ZlxuoFrfV9bexHM6xQaZ+wtEAXtjXvMNFxprT5AeXzGPj+qn2L
         fSzSEhxp8oEVuPzuWbaLW55eYUeIDbiMcPKav2gjowERriwyxIubObtxIA4zHhg/MqAG
         UWx8nqfubZNzPEhTZP0FfEcytFcnTsfl4suXDX37kYWLxCQY30vtuoGLXF/jI0ot8ZRB
         DKITkcaYSjMaULSYAtKovG2wZtFkFYCpvN5jinTIJKs8b7keRMOatD+4qyU8GcicIavB
         eCKA==
X-Gm-Message-State: AOAM531Rj+O61cOa+WC20jQtm8/5gur8u63IbI2D/CJiNbQMyYaV5ovb
        TMKpuBwLybnNKV8UKuYXm5KASwDaNWicLqgjd6caEKsAblx71MEuWXGaRbAJDs+syAZPLLLjG3L
        XnH0kL+LBwQG88bbshjutmYca0JULD8PSFdxdwJWUq+CaMXoKTDBbKg/SG1FoHbp/4MGz
X-Google-Smtp-Source: ABdhPJx7KY/rXLumlnnMsOTLAF9mgR3XNFUqyVlJbGCGxH91mjWFlJIfRSYawH6s6nuQxY/9ZUE0VA==
X-Received: by 2002:a05:6a00:22d2:b0:4a0:93a:e165 with SMTP id f18-20020a056a0022d200b004a0093ae165mr7222519pfj.68.1638989794739;
        Wed, 08 Dec 2021 10:56:34 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id k16sm4996394pfu.183.2021.12.08.10.56.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Dec 2021 10:56:34 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [PATCH] net/i40e: fix unsigned stat widths
Date:   Wed,  8 Dec 2021 10:56:18 -0800
Message-Id: <1638989778-126260-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change i40e_update_vsi_stats and struct i40e_vsi to use u64 fields to match
the width of the stats counters in struct i40e_rx_queue_stats.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      | 4 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 4d939af..2e2578f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -852,8 +852,8 @@ struct i40e_vsi {
 	u32 tx_busy;
 	u64 tx_linearize;
 	u64 tx_force_wb;
-	u32 rx_buf_failed;
-	u32 rx_page_failed;
+	u64 rx_buf_failed;
+	u64 rx_page_failed;
 
 	/* These are containers of ring pointers, allocated at run-time */
 	struct i40e_ring **rx_rings;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index e118cf9..945eeef1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -756,7 +756,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	struct i40e_eth_stats *es;     /* device's eth stats */
 	u32 tx_restart, tx_busy;
 	struct i40e_ring *p;
-	u32 rx_page, rx_buf;
+	u64 rx_page, rx_buf;
 	u64 bytes, packets;
 	unsigned int start;
 	u64 tx_linearize;
-- 
2.7.4

