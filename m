Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BC16657C7
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjAKJjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbjAKJhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:37:24 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125FFB1F3;
        Wed, 11 Jan 2023 01:36:04 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id h16so14401407wrz.12;
        Wed, 11 Jan 2023 01:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O23XHz16kQsggrfAT5R5+VpQORNxeVkJc7shnnA68O8=;
        b=RC3h9zWU6wudCkE5XZlstgBJ4kITywJ/+KVr7ao8SPnXwQwrC5dcz8saLaFfqOleF+
         Ru6VvjgjcCPeG+fDGdoGjGwp7K6i/BFriz9XsXX0fzAL27UPLurcDP7LpqYHXUP0dRsm
         48tdKZY4/kCkGJY7SEafrpXS3yC1B2TD5K/NsQOi1LclNlW8frQVuSoQnxat3jOD7hx/
         Dmf4hrgp3yiJiOKqDaZGElRTO7AESWbixXbdFTF2PZwXc0STGd99CvZXcUArR0wQKYBh
         +xk0cbi29tX5thHzSuoMY0wIU1RtHT9lYxhO7+Cinf5WhcqSMOfkZJuNG62RVO9bJQGf
         0FBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O23XHz16kQsggrfAT5R5+VpQORNxeVkJc7shnnA68O8=;
        b=x7gk9O9SCpcC7KgFCL0LjE8+wdGVeWHe5lf9XqNQyYRE6AtVEW64FllJVcmonbw2Yp
         R++6ZMmhAOFTPPONgO4Aj+y4tPKjrABu9lVbb1KQdJsqYOt1/mw8J2x3r/xMDmI0ctY7
         WQjbu+ybQCnA2GdkisTQ0G6nC9MJ65HxvBt5grIZh04bM2dgWFfxV7ZcnlYF8KUjyCbF
         85ODn7cQuifnd6QX3ac+Qo+jUr4Ve8bj8ULKsz4/IJkt0L9FyVOjzJl/u9djHd2nqhl7
         wUbsNmK+kCsvbFZcW+cLjlVIqXE7HLp8Ne8IJkXbSKiPmiD+2l0LS1kkFVzAspHa92Nh
         smMw==
X-Gm-Message-State: AFqh2koKs+Smv1v0F/DvKVkY7zpYudHuzPsemcGK7sKWSvMK6VDyXrmj
        tIC0t/Rz5BYDSD921dOol84=
X-Google-Smtp-Source: AMrXdXvI4OHX9YsrlTl1lCJYqtXbGjgSow5oE3nLQpcVUTb1Ag8zjLG5ZjruIpYJkrrdgRq5t/LX3g==
X-Received: by 2002:a05:6000:719:b0:2a4:bff5:6e79 with SMTP id bs25-20020a056000071900b002a4bff56e79mr17190808wrb.67.1673429762520;
        Wed, 11 Jan 2023 01:36:02 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb52000000b0025e86026866sm15553069wrs.0.2023.01.11.01.36.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:36:02 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 02/15] selftests/xsk: do not close unused file descriptors
Date:   Wed, 11 Jan 2023 10:35:13 +0100
Message-Id: <20230111093526.11682-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111093526.11682-1-magnus.karlsson@gmail.com>
References: <20230111093526.11682-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Do not close descriptors that have never been used. File descriptor
fields that are not in use are erroneously marked with the number 0,
which is a valid fd. Mark unused fds with -1 instead and do not close
these when deleting the socket.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xsk.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
index 39d349509ba4..5e4a6552ed37 100644
--- a/tools/testing/selftests/bpf/xsk.c
+++ b/tools/testing/selftests/bpf/xsk.c
@@ -35,6 +35,8 @@
 #include "xsk.h"
 #include "bpf_util.h"
 
+#define FD_NOT_USED (-1)
+
 #ifndef SOL_XDP
  #define SOL_XDP 283
 #endif
@@ -583,6 +585,9 @@ static void xsk_delete_bpf_maps(struct xsk_socket *xsk)
 {
 	struct xsk_ctx *ctx = xsk->ctx;
 
+	if (ctx->xsks_map_fd == FD_NOT_USED)
+		return;
+
 	bpf_map_delete_elem(ctx->xsks_map_fd, &ctx->queue_id);
 	close(ctx->xsks_map_fd);
 }
@@ -941,6 +946,9 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
 	ctx->umem = umem;
 	ctx->queue_id = queue_id;
 	bpf_strlcpy(ctx->ifname, ifname, IFNAMSIZ);
+	ctx->prog_fd = FD_NOT_USED;
+	ctx->link_fd = FD_NOT_USED;
+	ctx->xsks_map_fd = FD_NOT_USED;
 
 	ctx->fill = fill;
 	ctx->comp = comp;
@@ -1221,8 +1229,9 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 
 	if (ctx->refcount == 1) {
 		xsk_delete_bpf_maps(xsk);
-		close(ctx->prog_fd);
-		if (ctx->has_bpf_link)
+		if (ctx->prog_fd != FD_NOT_USED)
+			close(ctx->prog_fd);
+		if (ctx->has_bpf_link && ctx->link_fd != FD_NOT_USED)
 			close(ctx->link_fd);
 	}
 
-- 
2.34.1

