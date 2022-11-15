Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B176292ED
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 09:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiKOIGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 03:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbiKOIGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 03:06:03 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14371D318;
        Tue, 15 Nov 2022 00:06:02 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id bs21so22841495wrb.4;
        Tue, 15 Nov 2022 00:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R4MreCSI5ZRqggTXhx8hY2RP6JDPW+WxWqfQy+yqcNY=;
        b=p0On+zMFWQjL5cmqUOR12b8Dx4ffotrsxuGpim1rK847NyPwEXOtFmyMaCgSxDqWjj
         2MGQ5AmY6ppgZTam8p01le5s3/58MKtroT55sxjRrfqsrplEJFM0tovswwLemqUa4CgX
         m5o5SvIiqeOBRRx0PgEFDzW5ZETWiSjh1v0LFmoD7kHFZCf4BINdQjohMT9AFWI/O00y
         c2MU76Ky2329Vi31irnd41rQkgb6TqYlLZqte8h+SuQHCgySW8VU9ZU38vNWrd7Nlw5s
         ni6B8xZYnIquGDVyL07ocBnYlhXc05EegPC9j0stinue1IErxwHeaFP1sFEmH6OtvmJ/
         GveQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R4MreCSI5ZRqggTXhx8hY2RP6JDPW+WxWqfQy+yqcNY=;
        b=3Edy+ApAgkFXHehgmWKL7/kd4hlGUAO7nDAF/cZyDYMlpa81b27V8URnJEKOZLwIlC
         ANtDfJoz+vCQMN1Xm8AYytP1m2GWMVWRWKLD25nCgV8dCIt9+AxOmAIIp9Qoit+vsWtE
         JokYh8PX0QAXyECHS/a4+W4B9o/kHo3jTl60OG7Fp4GQoHQjdeOqxdWpdWe0NEtru0/M
         4HEoLfQIYakR9aqkuZgepEbZdMhRRs8eMgoLeQN+JWsv4JNOIRZLxN4U+7emt0qL0X59
         +zBhELnuYUne6RnS3yE/6vbVBSSQbmu5+ZQQDxAOKLRukIezszIfv6MOpVhhXQBTxdfr
         Fkhg==
X-Gm-Message-State: ANoB5pmnaHCxFaIAEfub0PXcO6EEHWTV+WyqcYDIHnOK6OwRT+SbJot6
        vwRqYc4joBRSMus28rIWZy8=
X-Google-Smtp-Source: AA0mqf505FwDXsNDs5+8TQimlQgipWkl+0+R4+iMsZeVgq4PS+IOIyGkFG1E5JsSD2CMsBTuIkTKWA==
X-Received: by 2002:adf:e74c:0:b0:22e:387:a7ba with SMTP id c12-20020adfe74c000000b0022e0387a7bamr9854289wrn.260.1668499561470;
        Tue, 15 Nov 2022 00:06:01 -0800 (PST)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id cy6-20020a056000400600b002416ecb8c33sm11464190wrb.105.2022.11.15.00.06.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Nov 2022 00:06:00 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf 2/3] selftests/xsk: do not close unused file descriptors
Date:   Tue, 15 Nov 2022 09:05:37 +0100
Message-Id: <20221115080538.18503-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115080538.18503-1-magnus.karlsson@gmail.com>
References: <20221115080538.18503-1-magnus.karlsson@gmail.com>
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

Fixes: f36600634282 ("libbpf: move xsk.{c,h} into selftests/bpf")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xsk.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
index 0b3ff49c740d..bea4cd076cd4 100644
--- a/tools/testing/selftests/bpf/xsk.c
+++ b/tools/testing/selftests/bpf/xsk.c
@@ -34,6 +34,8 @@
 #include <bpf/libbpf.h>
 #include "xsk.h"
 
+#define FD_NOT_USED (-1)
+
 #ifndef SOL_XDP
  #define SOL_XDP 283
 #endif
@@ -601,6 +603,9 @@ static void xsk_delete_bpf_maps(struct xsk_socket *xsk)
 {
 	struct xsk_ctx *ctx = xsk->ctx;
 
+	if (ctx->xsks_map_fd == FD_NOT_USED)
+		return;
+
 	bpf_map_delete_elem(ctx->xsks_map_fd, &ctx->queue_id);
 	close(ctx->xsks_map_fd);
 }
@@ -959,6 +964,9 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
 	ctx->umem = umem;
 	ctx->queue_id = queue_id;
 	libbpf_strlcpy(ctx->ifname, ifname, IFNAMSIZ);
+	ctx->prog_fd = FD_NOT_USED;
+	ctx->link_fd = FD_NOT_USED;
+	ctx->xsks_map_fd = FD_NOT_USED;
 
 	ctx->fill = fill;
 	ctx->comp = comp;
@@ -1239,8 +1247,9 @@ void xsk_socket__delete(struct xsk_socket *xsk)
 
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

