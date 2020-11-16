Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D387A2B4232
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgKPLFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgKPLF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 06:05:28 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30237C0613CF;
        Mon, 16 Nov 2020 03:05:28 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id q28so2375993pgk.1;
        Mon, 16 Nov 2020 03:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SMuIIzNyAeXu64StgjlhI6xMtW/RAUIa0LLgxB8HnhI=;
        b=PP2rU74MUkheao3IWVTC4xC7KRp3QuPf8DtUdYaTQog5H9dZBRZqcPjNiFZdog3aqZ
         +03xjPZ4+/FLt7Jx7Mr57XSWb9IZu6/2wylhPu1Xwz4zj1i6UhgT234b06aJVklNeKVQ
         bJp7VHdEJI5Jq5vsvZqjnDR7wPiqbgfvTLMbxA1wTffg/p8/FasrJnYrZwfY8yKOND1+
         tggUzxC2R5cvatR/SJyxO3lrHml0zbzbhRNf0q5TFBtt8FPLYtVSR3E246oego4K7IH4
         JjQwp0ozM1FGEPW/SdCHTLniHpXJvJvHZ7cU/AOBNfMlL8MW6DzPskhuah4ZZosQ5N5Q
         IIog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SMuIIzNyAeXu64StgjlhI6xMtW/RAUIa0LLgxB8HnhI=;
        b=S8J8pPblOqaipHuxcsue6rwWphDtTQyjQOBpHQWvu9Vqo3esMRIg/RTfLv9+44EQqA
         ByiZncxZhWYIh5c9sijUHIr10qv8nGxTcQ2qbU24bsmsqWJb0ZBEMTpBA51TG5iAN9Z0
         qFoB+VT2IRYXdCzvTCbUSPUhZ+klnkL597CGIrXbnuTv3urIEpivCWsDdQ9FU//lyf9r
         byy88vVF52JnievCDAJAugsUsJecZfm8NMucLDj1DsXFt5BtZj+F/FpwxJvkFi8MPFYZ
         cPG12iL+ZxQa7OXlK3DjEdZBtUEoJJn8EdysO1zlstYmrgSFFq1PNpUgdf/eenqO724v
         bU+Q==
X-Gm-Message-State: AOAM532c0c9Q0f3l46Jk9yqiYrU2dG3omdqX0r/fXNIsjAZppGocvBNL
        UGkDXittrh72JtIwcFZc80Hl9vr5yCG/CeO/
X-Google-Smtp-Source: ABdhPJx6nRwoGVGcQ4Mi5KLOZtiecZmlqBTD86Y0GGXLskcxlYy7APUm3ckrlS1C/xRAoYAeO0tCKw==
X-Received: by 2002:a62:2c16:0:b029:15d:8d2:2e6d with SMTP id s22-20020a622c160000b029015d08d22e6dmr13589884pfs.52.1605524727205;
        Mon, 16 Nov 2020 03:05:27 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id a23sm15752890pgv.35.2020.11.16.03.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 03:05:26 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v2 08/10] samples/bpf: use recvfrom() in xdpsock/l2fwd
Date:   Mon, 16 Nov 2020 12:04:14 +0100
Message-Id: <20201116110416.10719-9-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201116110416.10719-1-bjorn.topel@gmail.com>
References: <20201116110416.10719-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Start using recvfrom() the l2fwd scenario, instead of poll() which is
more expensive and need additional knobs for busy-polling.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/xdpsock_user.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 96d0b6482ac4..bc4ef3ac9dfb 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1098,8 +1098,7 @@ static void kick_tx(struct xsk_socket_info *xsk)
 	exit_with_error(errno);
 }
 
-static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
-				     struct pollfd *fds)
+static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
 {
 	struct xsk_umem_info *umem = xsk->umem;
 	u32 idx_cq = 0, idx_fq = 0;
@@ -1134,7 +1133,7 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
 				exit_with_error(-ret);
 			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
 				xsk->app_stats.fill_fail_polls++;
-				ret = poll(fds, num_socks, opt_timeout);
+				recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 			}
 			ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
 		}
@@ -1332,19 +1331,19 @@ static void tx_only_all(void)
 		complete_tx_only_all();
 }
 
-static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
+static void l2fwd(struct xsk_socket_info *xsk)
 {
 	unsigned int rcvd, i;
 	u32 idx_rx = 0, idx_tx = 0;
 	int ret;
 
-	complete_tx_l2fwd(xsk, fds);
+	complete_tx_l2fwd(xsk);
 
 	rcvd = xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
 	if (!rcvd) {
 		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.rx_empty_polls++;
-			ret = poll(fds, num_socks, opt_timeout);
+			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
 		return;
 	}
@@ -1353,7 +1352,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 	while (ret != rcvd) {
 		if (ret < 0)
 			exit_with_error(-ret);
-		complete_tx_l2fwd(xsk, fds);
+		complete_tx_l2fwd(xsk);
 		if (xsk_ring_prod__needs_wakeup(&xsk->tx)) {
 			xsk->app_stats.tx_wakeup_sendtos++;
 			kick_tx(xsk);
@@ -1388,22 +1387,20 @@ static void l2fwd_all(void)
 	struct pollfd fds[MAX_SOCKS] = {};
 	int i, ret;
 
-	for (i = 0; i < num_socks; i++) {
-		fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
-		fds[i].events = POLLOUT | POLLIN;
-	}
-
 	for (;;) {
 		if (opt_poll) {
-			for (i = 0; i < num_socks; i++)
+			for (i = 0; i < num_socks; i++) {
+				fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
+				fds[i].events = POLLOUT | POLLIN;
 				xsks[i]->app_stats.opt_polls++;
+			}
 			ret = poll(fds, num_socks, opt_timeout);
 			if (ret <= 0)
 				continue;
 		}
 
 		for (i = 0; i < num_socks; i++)
-			l2fwd(xsks[i], fds);
+			l2fwd(xsks[i]);
 
 		if (benchmark_done)
 			break;
-- 
2.27.0

