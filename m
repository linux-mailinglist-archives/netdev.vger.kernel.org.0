Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 968C5173001
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 05:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgB1Epw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 23:45:52 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33492 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1Epw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 23:45:52 -0500
Received: by mail-pl1-f194.google.com with SMTP id ay11so749335plb.0;
        Thu, 27 Feb 2020 20:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PiYPcJuAxp1SDZtFC2pIYopA68irB9Gd6d8vzAHZmww=;
        b=Gd3Q5kzIu2PEgeziWxtedXRAGIid2KxpRI01XrAaHHqazvdrWesoxeIycvuYx9+aiT
         iYVYOpd18gZFP0AxXkzvT5usdG+gFEXtBNRXKeIb9akqpu0qvvhPa3h3g/CIfhkeKiLU
         9nn1iaCVbKD9I/2oXK/Y5LeM1xK1g2AqfHuGXPO3z5Qg/LkT8ctdSyq3NFYSZWcdovmg
         NA0ckd4+T1j76NAlEAwS5iQ7Ud3FhMq8IAowYJXliL3gGt/h7GGDR3fOv8krYSLyFFGS
         z8qLPmohrbtB1KQswqRDGwGi1zD+PYaIL5pCerjReDqkJjXVtmy9WCmTO/Cwe31NjBOs
         gUAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PiYPcJuAxp1SDZtFC2pIYopA68irB9Gd6d8vzAHZmww=;
        b=Npn8dYmHP3HZfB1jLB+Lx44J7VKuw5KIVrUHSA9iICJYZrCOXoEyMNDrPEMlCK6mSn
         Byk8yJNEbYN8mLDZ2RSYics7mY28wnOSVxbkEms4n180WJnngns2tfXvTblKyHmO9QwT
         mLNU9+QQTD7cle4oJlB/LAcvko7ffF+HKe2T2B60JG2kxMIcy1BW8HRMxZrdp8Fb748K
         8nRI42jjKpyYUIrvh/ytBTJ/GSPBaNTDatcvAWxfV0EDR/Neba9ffKXXXP3Q1Jo1KlEe
         dupAdUEYVRRd9yM97bQvqgIiTRq1lZk42vL1oytkDOOMxgk6IhskTrJnxDhwgK5qRbLQ
         bPlw==
X-Gm-Message-State: APjAAAUdaUzRdwHmHFlGfi7/23f/Uo46mJX8SwbEKY3EQg0xbowKkSqN
        1jHagrGBl+pM2nbmaq1W/ZZBPeC4J9m54g==
X-Google-Smtp-Source: APXvYqyuSvEUiDe+JjbiS+jiVf8qcYO1fAr/XE9AhsKKiniRRVucu7utcqaJGOHLhQYVY4EBG/7M1A==
X-Received: by 2002:a17:90a:868b:: with SMTP id p11mr2680575pjn.60.1582865150915;
        Thu, 27 Feb 2020 20:45:50 -0800 (PST)
Received: from localhost.localdomain ([183.128.239.135])
        by smtp.googlemail.com with ESMTPSA id s23sm316101pjq.17.2020.02.27.20.45.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Feb 2020 20:45:50 -0800 (PST)
From:   Yanhu Cao <gmayyyha@gmail.com>
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, davem@davemloft.net,
        kuba@kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Yanhu Cao <gmayyyha@gmail.com>
Subject: [PATCH] ceph: using POOL FULL flag instead of OSDMAP FULL flag
Date:   Fri, 28 Feb 2020 12:45:18 +0800
Message-Id: <20200228044518.20314-1-gmayyyha@gmail.com>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OSDMAP_FULL and OSDMAP_NEARFULL are deprecated since mimic.

Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
---
 fs/ceph/file.c                  |  6 ++++--
 include/linux/ceph/osd_client.h |  2 ++
 include/linux/ceph/osdmap.h     |  3 ++-
 net/ceph/osd_client.c           | 23 +++++++++++++----------
 4 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 7e0190b1f821..60ea1eed1b84 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1482,7 +1482,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	/* FIXME: not complete since it doesn't account for being at quota */
-	if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL)) {
+	if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
+				CEPH_POOL_FLAG_FULL)) {
 		err = -ENOSPC;
 		goto out;
 	}
@@ -1575,7 +1576,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	if (written >= 0) {
-		if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
+		if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
+					CEPH_POOL_FLAG_NEARFULL))
 			iocb->ki_flags |= IOCB_DSYNC;
 		written = generic_write_sync(iocb, written);
 	}
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 5a62dbd3f4c2..be9007b93862 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -375,6 +375,8 @@ static inline bool ceph_osdmap_flag(struct ceph_osd_client *osdc, int flag)
 	return osdc->osdmap->flags & flag;
 }
 
+bool pool_flag(struct ceph_osd_client *osdc, s64 pool_id, int flag);
+
 extern int ceph_osdc_setup(void);
 extern void ceph_osdc_cleanup(void);
 
diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
index e081b56f1c1d..88faacc11f55 100644
--- a/include/linux/ceph/osdmap.h
+++ b/include/linux/ceph/osdmap.h
@@ -36,7 +36,8 @@ int ceph_spg_compare(const struct ceph_spg *lhs, const struct ceph_spg *rhs);
 
 #define CEPH_POOL_FLAG_HASHPSPOOL	(1ULL << 0) /* hash pg seed and pool id
 						       together */
-#define CEPH_POOL_FLAG_FULL		(1ULL << 1) /* pool is full */
+#define CEPH_POOL_FLAG_FULL		(1ULL << 1)  /* pool is full */
+#define CEPH_POOL_FLAG_NEARFULL	(1ULL << 11) /* pool is nearfull */
 
 struct ceph_pg_pool_info {
 	struct rb_node node;
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index b68b376d8c2f..9ad2b96c3e78 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1447,9 +1447,9 @@ static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
 		atomic_dec(&osd->o_osdc->num_homeless);
 }
 
-static bool __pool_full(struct ceph_pg_pool_info *pi)
+static bool __pool_flag(struct ceph_pg_pool_info *pi, int flag)
 {
-	return pi->flags & CEPH_POOL_FLAG_FULL;
+	return pi->flags & flag;
 }
 
 static bool have_pool_full(struct ceph_osd_client *osdc)
@@ -1460,14 +1460,14 @@ static bool have_pool_full(struct ceph_osd_client *osdc)
 		struct ceph_pg_pool_info *pi =
 		    rb_entry(n, struct ceph_pg_pool_info, node);
 
-		if (__pool_full(pi))
+		if (__pool_flag(pi, CEPH_POOL_FLAG_FULL))
 			return true;
 	}
 
 	return false;
 }
 
-static bool pool_full(struct ceph_osd_client *osdc, s64 pool_id)
+bool pool_flag(struct ceph_osd_client *osdc, s64 pool_id, int flag)
 {
 	struct ceph_pg_pool_info *pi;
 
@@ -1475,8 +1475,10 @@ static bool pool_full(struct ceph_osd_client *osdc, s64 pool_id)
 	if (!pi)
 		return false;
 
-	return __pool_full(pi);
+	return __pool_flag(pi, flag);
 }
+EXPORT_SYMBOL(pool_flag);
+
 
 /*
  * Returns whether a request should be blocked from being sent
@@ -1489,7 +1491,7 @@ static bool target_should_be_paused(struct ceph_osd_client *osdc,
 	bool pauserd = ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSERD);
 	bool pausewr = ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSEWR) ||
 		       ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
-		       __pool_full(pi);
+		       __pool_flag(pi, CEPH_POOL_FLAG_FULL);
 
 	WARN_ON(pi->id != t->target_oloc.pool);
 	return ((t->flags & CEPH_OSD_FLAG_READ) && pauserd) ||
@@ -2320,7 +2322,8 @@ static void __submit_request(struct ceph_osd_request *req, bool wrlocked)
 		   !(req->r_flags & (CEPH_OSD_FLAG_FULL_TRY |
 				     CEPH_OSD_FLAG_FULL_FORCE)) &&
 		   (ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
-		    pool_full(osdc, req->r_t.base_oloc.pool))) {
+		   pool_flag(osdc, req->r_t.base_oloc.pool,
+			     CEPH_POOL_FLAG_FULL))) {
 		dout("req %p full/pool_full\n", req);
 		if (ceph_test_opt(osdc->client, ABORT_ON_FULL)) {
 			err = -ENOSPC;
@@ -2539,7 +2542,7 @@ static int abort_on_full_fn(struct ceph_osd_request *req, void *arg)
 
 	if ((req->r_flags & CEPH_OSD_FLAG_WRITE) &&
 	    (ceph_osdmap_flag(osdc, CEPH_OSDMAP_FULL) ||
-	     pool_full(osdc, req->r_t.base_oloc.pool))) {
+	     pool_flag(osdc, req->r_t.base_oloc.pool, CEPH_POOL_FLAG_FULL))) {
 		if (!*victims) {
 			update_epoch_barrier(osdc, osdc->osdmap->epoch);
 			*victims = true;
@@ -3707,7 +3710,7 @@ static void set_pool_was_full(struct ceph_osd_client *osdc)
 		struct ceph_pg_pool_info *pi =
 		    rb_entry(n, struct ceph_pg_pool_info, node);
 
-		pi->was_full = __pool_full(pi);
+		pi->was_full = __pool_flag(pi, CEPH_POOL_FLAG_FULL);
 	}
 }
 
@@ -3719,7 +3722,7 @@ static bool pool_cleared_full(struct ceph_osd_client *osdc, s64 pool_id)
 	if (!pi)
 		return false;
 
-	return pi->was_full && !__pool_full(pi);
+	return pi->was_full && !__pool_flag(pi, CEPH_POOL_FLAG_FULL);
 }
 
 static enum calc_target_result
-- 
2.21.1

