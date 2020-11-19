Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A96D2B8D56
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgKSIbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgKSIbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:31:40 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B311DC0613CF;
        Thu, 19 Nov 2020 00:31:38 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id 10so3775986pfp.5;
        Thu, 19 Nov 2020 00:31:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HgluhhsOMbA+3BwJiOmeNOPCO4MFaX5rSDQzLBwWi5o=;
        b=Pr1K1hz+easnpV1l104M9bYIWLy7a0SXmsYoEQAyquoYWI8Z/WJS+rtZJ44po8aqLv
         +z8WunZS8gE0Uom3zH5bWH4ZLez2oqyA60r+Xyv1fZebESTPtYpqfYX4Vw6vCGtE0gei
         fO4qnAnAB8fHFT0fuHC2qHgeUUceQ04eTwvp3nVmWWUBWyMsvt1g74nLK51kX2NTPbVG
         Vz6wnsTxRX6+N+B+wWGLfGta3IP0BOZF+LttTdksbe+72aiq3c99LMgRmy/CiyUxOFsP
         gbMiJntE5bOGx31ra88HS9DdudqCQorgCcjGLlSqpFzCTMcQZ9JWo4/TCYgom6QvOR1j
         zK6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HgluhhsOMbA+3BwJiOmeNOPCO4MFaX5rSDQzLBwWi5o=;
        b=Yygx7Wrz2MnhtuKBzsu7KnCNLdMQ56RKR9lcYvnTn6srVZPyak04hSimNflDos4I9Q
         X4LTwzf7oA7KIMc5pM4DTiBnI5fGMVmJmp+fi6qrhnLJ7nP/fhpa3zgNKvS1h/xJMQsZ
         HF79TSb7NIwUAvA6raz2cKGAQsy9aUZWwKjTvMtibLros8h34GvVHclQw28hQJ9R92bR
         YL+aYMyvtvCWt0+sRum0sKRe9F71a14X81eWrhfI3AqyX6gkUVHSGl/jeEfMcDa3+MhC
         BWqcddc/7+Je+UqTcZ5o1miYuffnpVUux9CZV46zSgZCZSj+BgA6wSMrJHEus4oRrWgt
         k8oA==
X-Gm-Message-State: AOAM531jmn82EHDRch5ZCL3jg7n424AodOx+o/nRW8V9frhc9/ePj1UC
        WKcyWa/MZPKiQG+99QvpmiIWiaeaI9df4AyG
X-Google-Smtp-Source: ABdhPJxsSSRTpgfdqn3VFVbYmTj5qw8HVZqWPnsgFzu8O87+VzNwAtGlBHKqQtQzG2harX5tbIyaRw==
X-Received: by 2002:a17:90a:bc83:: with SMTP id x3mr3316766pjr.90.1605774697656;
        Thu, 19 Nov 2020 00:31:37 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id r2sm5517713pji.55.2020.11.19.00.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 00:31:36 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v3 07/10] samples/bpf: use recvfrom() in xdpsock/rxdrop
Date:   Thu, 19 Nov 2020 09:30:21 +0100
Message-Id: <20201119083024.119566-8-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201119083024.119566-1-bjorn.topel@gmail.com>
References: <20201119083024.119566-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Start using recvfrom() the rxdrop scenario.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/xdpsock_user.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 2567f0db5aca..f90111b95b2e 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1170,7 +1170,7 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk,
 	}
 }
 
-static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
+static void rx_drop(struct xsk_socket_info *xsk)
 {
 	unsigned int rcvd, i;
 	u32 idx_rx = 0, idx_fq = 0;
@@ -1180,7 +1180,7 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
 	if (!rcvd) {
 		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.rx_empty_polls++;
-			ret = poll(fds, num_socks, opt_timeout);
+			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
 		return;
 	}
@@ -1191,7 +1191,7 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
 			exit_with_error(-ret);
 		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.fill_fail_polls++;
-			ret = poll(fds, num_socks, opt_timeout);
+			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
 		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
 	}
@@ -1233,7 +1233,7 @@ static void rx_drop_all(void)
 		}
 
 		for (i = 0; i < num_socks; i++)
-			rx_drop(xsks[i], fds);
+			rx_drop(xsks[i]);
 
 		if (benchmark_done)
 			break;
-- 
2.27.0

