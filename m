Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05BFB7F509
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 12:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390755AbfHBKaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 06:30:03 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42263 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730143AbfHBKaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 06:30:03 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay6so33529584plb.9;
        Fri, 02 Aug 2019 03:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B6ThXTdLqQnYtFH4Sq6DQYOhXAfMjbsowfx2ATZ6RaA=;
        b=T7vtdHxlHDoWWbMDsMpp4A0KhFa9XY5Zi8XGuYS4AM38N9jbmQzJRMRambMleJGfc5
         +1jPzgP6T0SBoAAbgDtPqttfjvVY6G5IbjZqpUq8aGFi7jJBQqk3qxlM3r73ooqf6sKo
         dN8JKzkxfGTq2jiAfTWDF0DsT/h0JOg96rtcAVT9CpiVaZd2lAIaLAJEt2Bkt/IoQwyb
         OJqwjnDEzouXItsCGfuCwu5wdy5P/eaZTMIHRdfwN3saU8BVQNwIYQRh43hsoqZPhi6K
         rQL9C7H1raeEPqFM6n2KNOexIJNtle/Vdt6notrRNQsr+Nk7qZzg40Qd5rwWzYEMaRTU
         GEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B6ThXTdLqQnYtFH4Sq6DQYOhXAfMjbsowfx2ATZ6RaA=;
        b=SuQVy2i/veSnHmI7Z0utNs/5gTGPNdtIMD98ZSOa36oh8YzOfpabgtIYoyMZtJKZPL
         /4EjgMKahLxTVPYV2usbkehZQpdf9HHwjcgFFM1gMSvuX7N4DKGg5wyTqUKa2Ru+a7pf
         d/BQ9/0Rsyx6qP5/63k1hDNRFVjPJERnEyszZ2tqz9fPact4s3ZsyfDfVzsxhMQTIddE
         kElZiOPWFW2qXh7YfuZiQ5bEZbstai71XuF0uKwtjImymhRpWwRNiFeEKbqVYvcCoaW3
         igeuKOop6bpgVLr8Y/cmuZYg52CpbwyXkX5ZLphAhi9NOmNTjZfeKwB+Kr3O1wUIOAim
         PiuA==
X-Gm-Message-State: APjAAAWJbQ5K7tSEpJaGTbCCSjFVOXoQ3xUwHb8o/CZbay/09FqMHbO/
        kNInDCAks0MHQlfOX7AX9BI=
X-Google-Smtp-Source: APXvYqwk2G89WFkms0GDbxvkH3iDt3WeAC2IhYzei5wzMGpQV+Mu4UKICIEnKEQfiMvVjaGdDdK+CA==
X-Received: by 2002:a17:902:f213:: with SMTP id gn19mr134302687plb.35.1564741802356;
        Fri, 02 Aug 2019 03:30:02 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id j5sm64742881pgp.59.2019.08.02.03.30.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 03:30:01 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] dpaa_eth: Use refcount_t for refcount
Date:   Fri,  2 Aug 2019 18:29:56 +0800
Message-Id: <20190802102956.14867-1-hslester96@gmail.com>
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
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 6 +++---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index f38c3fa7d705..2df6e745cb3f 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -485,7 +485,7 @@ static struct dpaa_bp *dpaa_bpid2pool(int bpid)
 static bool dpaa_bpid2pool_use(int bpid)
 {
 	if (dpaa_bpid2pool(bpid)) {
-		atomic_inc(&dpaa_bp_array[bpid]->refs);
+		refcount_inc(&dpaa_bp_array[bpid]->refs);
 		return true;
 	}
 
@@ -496,7 +496,7 @@ static bool dpaa_bpid2pool_use(int bpid)
 static void dpaa_bpid2pool_map(int bpid, struct dpaa_bp *dpaa_bp)
 {
 	dpaa_bp_array[bpid] = dpaa_bp;
-	atomic_set(&dpaa_bp->refs, 1);
+	refcount_set(&dpaa_bp->refs, 1);
 }
 
 static int dpaa_bp_alloc_pool(struct dpaa_bp *dpaa_bp)
@@ -584,7 +584,7 @@ static void dpaa_bp_free(struct dpaa_bp *dpaa_bp)
 	if (!bp)
 		return;
 
-	if (!atomic_dec_and_test(&bp->refs))
+	if (!refcount_dec_and_test(&bp->refs))
 		return;
 
 	if (bp->free_buf_cb)
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
index af320f83c742..acc3fcdf730a 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
@@ -99,7 +99,7 @@ struct dpaa_bp {
 	int (*seed_cb)(struct dpaa_bp *);
 	/* bpool can be emptied before freeing by this cb */
 	void (*free_buf_cb)(const struct dpaa_bp *, struct bm_buffer *);
-	atomic_t refs;
+	refcount_t refs;
 };
 
 struct dpaa_rx_errors {
-- 
2.20.1

