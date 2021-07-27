Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165F13D81E4
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhG0Vgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbhG0Vgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:36:52 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BAFC061796
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:36:51 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so6735231pja.5
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4BnfRKheoEyJ1stoqG1udFT4VTgOpqL9vmyJJWgrwhQ=;
        b=NTFTSGnaaL1PjdfbInP9wW4+rEyfYbhJ/keeV1wnvEThtRN2gdcrpRCZ7hd1LSPL/w
         gpm7aIDUJ/FjLYIardaQXcuOjI/ZjGwWIdtBU8XtYG2CMUC8Us1z4TA/eJ27DZ+AF+dn
         3omle6d7QFY3/lutHZTQhs0+KkQrfijMwyIfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4BnfRKheoEyJ1stoqG1udFT4VTgOpqL9vmyJJWgrwhQ=;
        b=XdZdY3PdaVNyLH2BztKhKri52iPPuwfTMavQWZ7uQ5+z0/W6T7q9lZBXy47TFU9HKv
         QPEip/1i/Z/AtNQT80EphK5iaaqmZppZIaTPEaEq0ntaFo4GiMTYReqYBeJGu1F7DmsV
         rSfvPhDH7ssui8DXc9/V/y74Yt0c1/w3+2BBRja5QkIWa8DexzD9pKrf5U1LeJVHChds
         rf/iAZvOewcEB+RThAmpTF+Ic42seT3f+LPPat1R5y7ye4PC0C1lVLVHnen4iVOhGfTG
         euKUiPTFfDzkPMLKEYgE4bTZUdwGHNn+Wr37AbXRJhZKwNtstEp106Q4+5vRypQueOeL
         3Lag==
X-Gm-Message-State: AOAM5300I4J7eqzvL8+K9vvcHr0SmzvCv4xMYBhsbJrU+A+lniOfvnqf
        wTDeZ1sxvHup1da2PbmLmZGerQ==
X-Google-Smtp-Source: ABdhPJywXHABddj5YKILKb1GKuMRYeJ3OumAxfDVgtAesPzGrRwd3W2ViDD691FQDqn6Bsbeqru0EA==
X-Received: by 2002:a63:154d:: with SMTP id 13mr214806pgv.116.1627421811222;
        Tue, 27 Jul 2021 14:36:51 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z9sm4890526pfa.2.2021.07.27.14.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:36:50 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 48/64] drbd: Use struct_group() to zero algs
Date:   Tue, 27 Jul 2021 13:58:39 -0700
Message-Id: <20210727205855.411487-49-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2322; h=from:subject; bh=1syui6IaJX/LeKhpA35yXKLKiDQJbdN3KjOA72sb0yw=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOL7jOa6t9HnTRkat/yBLQ7dAwkDK4D28V8dSKs BckHWDOJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBziwAKCRCJcvTf3G3AJjzYD/ 4zCOLV8aaPBAT/bUiOjvDCTgLgraBRaR3pGWcZHMGJANYM2EkJwwuDhYBGkXFsg/LT9+C0FBP8Y/Zc 5zPMr5Ck8KK1vkPuvxC1XxLeWJhbO7Z9IV0T96RT6vedIbwG/X0HJaMaOlT+1avad2HTRLXhAUzKf9 gxK4g4ZAvz/FXSOFqfOu4JDUZkbvgdqXKTRl1Ks3V/KGyA9ON1fkJKujv9YXdTGyFFudWFZewLc3BP DZPR81LSq8W/amm31XbR+stxT3RkRdzalx01+vXbX9LJoiC0gu7l/6U4b5J/VpCStcDJGVQl8FIhTi V+1401vurSluzntSGK22z+Cm1SERyXlJmS441MJeAecPsqSCnwghfDjdjciI3UKJWO/K9Qg++zKSTX Xg46C2C1CDENzVc/BEXLX4bRTM4AwyujZVJ2hRQ7bxl9SnluGtBytRpsMg8Msnryyvs3X8cmlQ9bUl XRrL69gqQC1H0bptqlRAOSNMxXAHdZVeI6VwFfJlkcw9nlt77JLmR4IN0CztbMsOydMgnp7kFIyOow V3/czlAK48y8FIgtBvWH5SaTNQHjO8KDpB/sU7DTiAlRVmRb+H9uM3KcdDUwf+cI08Yry5bLkSot5g ggAqgBoLiqeU0j1EpwD4W48NHRYgozq2B6FyI6ymPjBsMY1DKp1cRWhDZRww==
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

