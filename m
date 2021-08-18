Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E363EFBEA
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238572AbhHRGR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239320AbhHRGQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:16:31 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89968C033276
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:23 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id u1so1173931plr.1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OUj8oRrB7MxugyxrrPjBU6cYuiAw0IG2BHh9L0frR4M=;
        b=K5/QOCQ1GvHen4il+zts6aBVpR/MUixrVtFBh2u/OTX9/NfLMzS8Z3/B82bDko5rUs
         +eln7mM7MgpGb5g2fE+0/q4b2GAEHUqQx+fWFvhMosxIkDyZCevOdwe60Fbd9V0q1eOl
         0CFRhL0TI0b8ZFszkcA5toy3dO5yGBBGUx4X4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OUj8oRrB7MxugyxrrPjBU6cYuiAw0IG2BHh9L0frR4M=;
        b=OmmVs3hf9LFdd7m37u4u1U8TCbJ0PWpqvSItxaGqWb830m/dtSG0XcqWR5lpCMEch2
         A6APph3ZsRjP6e0NvGQkw5wylksoX9Q2HBXGIv+rYrf7LpMVnJMGZaTq/ZKUX1LkQxc3
         Ka6lZIhUnE1FybWXcFazhjDSXLa/KQFGMwLvDACgjotXEADSjEFlb1pc2mZYYLXjX+dU
         Qr6CQtHmRACvUgfJEUg6bl+lw6d1aDAMUR9EkRqn2D4lGbl8BVLUEY+uKOIinwEyTERh
         6NfL/U9cPcpHqgq9QUqYZYF8UeyR1SV8ykiF1cpFUmLNdOjIqZv7KGif9XcAJwdFU6f2
         PrbQ==
X-Gm-Message-State: AOAM531Tsd9qt7IPy0ljwXrwgtz2tp9Z0dINTeLiCWJE+V6N8mGDlu+d
        uoIIum46QNEVpeZOTOdegLmqXg==
X-Google-Smtp-Source: ABdhPJxbVOgs77pmnTYxvMPZHd1kccPxvYaRj3SbBhPFubv/TnK5SJeyMbp4QCzFpEAy80w5v2ECHw==
X-Received: by 2002:a17:90a:ad07:: with SMTP id r7mr7764155pjq.110.1629267263131;
        Tue, 17 Aug 2021 23:14:23 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w3sm4782286pfn.96.2021.08.17.23.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:14:21 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 51/63] drbd: Use struct_group() to zero algs
Date:   Tue, 17 Aug 2021 23:05:21 -0700
Message-Id: <20210818060533.3569517-52-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2518; h=from:subject; bh=Q2Uw9RXFjMIXKo2IteRobBuJ9t0Fke5gpQvhXOFkzbw=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMpAyrkrjCd9Sudd2DfvVM313Dv4J16Pprur7BE R2yLw5iJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjKQAKCRCJcvTf3G3AJllsD/ wMjgK1D0usgaVPmcG7ap73L0KQ/QF2TmwlTkN7ZYJNbPcOUTgH5qCBiL4kXD4qvPRMMk0z6M1MOXdD ad40Qjj391s1LOtbrXKzB6J0ACE6yMl0izT0iLKpKz+DHNtX6SXR4SCElIRw7Oe+D3OKvp8ncq6h/L m13yHC4gKfbb79IqU0KWkeB5qij4Ou7trqxTVeSvJLXgH5H6vMpMIrwWdj1jMXJgy2G8nUmOkFIh0c 0ivZjFBnwVNyQGo2OJAUvyz7W+qHXTnM5y/SfhabHHCHfGMD1LGZjB64ItBJUK+pcOykcIH49b9FnO h5fpUcqYNY7PRCXpb3rxN6MHOUY3PGy+gXlfy1Vx3CvXI1nI+OvBPvO8wi/whnPXp+BTOePiw4Blh+ 8bAGX27nZlzfW1jE3Y0VKrvKEieIn/i0YS3XfaCmMPn2OjPgaFjZMQTtKm9F61UAlxVlnSXOyRWiAa m+Binjs5N0XDni6qQxE+PwYb4X6+L5pWbOSWdiBOGY85wCWrqAF6DrTw4mXIB61ww03FHpMrwNH9ra 8yuAKhS3W2V+UbAd/ToTq0/JvDMwmWZGu/z6EIbBy/wAWPT3+RGq1gfMcM6HmInqPQk3SfLeIsEZHe jsEogyBmIWFi3hcxJwpocYVxG6KAlMgJp3sy7ctAUBzS5sy3VSG31B8l/x7Q==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Add a struct_group() for the algs so that memset() can correctly reason
about the size.

Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Cc: linux-block@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/block/drbd/drbd_main.c     | 3 ++-
 drivers/block/drbd/drbd_protocol.h | 6 ++++--
 drivers/block/drbd/drbd_receiver.c | 3 ++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 55234a558e98..b824679cfcb2 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -729,7 +729,8 @@ int drbd_send_sync_param(struct drbd_peer_device *peer_device)
 	cmd = apv >= 89 ? P_SYNC_PARAM89 : P_SYNC_PARAM;
 
 	/* initialize verify_alg and csums_alg */
-	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
+	BUILD_BUG_ON(sizeof(p->algs) != 2 * SHARED_SECRET_MAX);
+	memset(&p->algs, 0, sizeof(p->algs));
 
 	if (get_ldev(peer_device->device)) {
 		dc = rcu_dereference(peer_device->device->ldev->disk_conf);
diff --git a/drivers/block/drbd/drbd_protocol.h b/drivers/block/drbd/drbd_protocol.h
index dea59c92ecc1..a882b65ab5d2 100644
--- a/drivers/block/drbd/drbd_protocol.h
+++ b/drivers/block/drbd/drbd_protocol.h
@@ -283,8 +283,10 @@ struct p_rs_param_89 {
 
 struct p_rs_param_95 {
 	u32 resync_rate;
-	char verify_alg[SHARED_SECRET_MAX];
-	char csums_alg[SHARED_SECRET_MAX];
+	struct_group(algs,
+		char verify_alg[SHARED_SECRET_MAX];
+		char csums_alg[SHARED_SECRET_MAX];
+	);
 	u32 c_plan_ahead;
 	u32 c_delay_target;
 	u32 c_fill_target;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 1f740e42e457..6df2539e215b 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3921,7 +3921,8 @@ static int receive_SyncParam(struct drbd_connection *connection, struct packet_i
 
 	/* initialize verify_alg and csums_alg */
 	p = pi->data;
-	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
+	BUILD_BUG_ON(sizeof(p->algs) != 2 * SHARED_SECRET_MAX);
+	memset(&p->algs, 0, sizeof(p->algs));
 
 	err = drbd_recv_all(peer_device->connection, p, header_size);
 	if (err)
-- 
2.30.2

