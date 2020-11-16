Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEAAB2B4230
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbgKPLFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729404AbgKPLFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 06:05:22 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16112C0613CF;
        Mon, 16 Nov 2020 03:05:22 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id c20so13769687pfr.8;
        Mon, 16 Nov 2020 03:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pjXiaJJaFcfh/d5Hg7T1ivvJjPLwr7C0xxhr2qpyt5M=;
        b=TxibjckWGbjY8SYhBeJQTP9jRNRWmLaHXy3WiLYZMoKsWtFTaiOEbi2U/tjRihOzJd
         S8uR13wh5262bitKBLyood/O2erkKBs2hgh++0hTE0NoiR4yfQMjvAJ9bO+Stt70qSlu
         L6KiOUev//TgrLSp+6n9Y+mThRp7LZvoy1RxCFyyjiu90YAJvZhdmHO7g8hzm5jL8FkP
         OAoVQAkXe68SwoyXqkH0fLDF7NUolWXPA2jWb0rlHjuMrvrKGHQ1PzvIJZQUOpBN0Eo4
         6EaCytury4h95gb/6Aw5/cQb43LHXQJ43zTCpGSCTjpM9e5RIj4lyT11lVoBR+K54jo6
         XzWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pjXiaJJaFcfh/d5Hg7T1ivvJjPLwr7C0xxhr2qpyt5M=;
        b=iqHPUqMx4FEjU8OtgNcmZN2vllAmWcn3iMcZHTItX0VkSxiel/0tvq7NXgdJctP75b
         kwI/oFiSmaWDFNMrBJgwum8CNyXfS3RJH+73k1qXolQ2sLZmcfNyva97piAZPyiUwWYS
         CZ5BOgy3KYJjnhF/Xl5xse7aEo2blzUEG2UtGXXkr7DrgTrgZp77TimfUqC6rqyre9XU
         oCFdgwEUBKUoOijdH6KbSKQwuYgQQVsYin8kffGgaM3BXwl71sCy2B69GsdQC1XAClkp
         ISR88qjXAybKgcpEu29Q/WhcQH3VtTwZqOMbtW4FIpbxUqHpi/9KzO5AY15eXM4cJG7i
         tEBw==
X-Gm-Message-State: AOAM531xeOr5b6wnZGSLWhVdE6ZOQwUGqx2HCNL+vPIK3JoqeX8aE4Sy
        uRCbnPIE6WewYe67noUym8HYZcQdxvOHzS3x
X-Google-Smtp-Source: ABdhPJylAdysM0x2u41w3apgW6ngd8Y8smO/eXvuI3GFD1NvnYcsM2LsXQu/TvC19MBUHDUUlz0mNA==
X-Received: by 2002:a63:1514:: with SMTP id v20mr8787957pgl.203.1605524720732;
        Mon, 16 Nov 2020 03:05:20 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id a23sm15752890pgv.35.2020.11.16.03.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 03:05:19 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v2 07/10] samples/bpf: use recvfrom() in xdpsock/rxdrop
Date:   Mon, 16 Nov 2020 12:04:13 +0100
Message-Id: <20201116110416.10719-8-bjorn.topel@gmail.com>
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

Start using recvfrom() the rxdrop scenario.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/xdpsock_user.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 1149e94ca32f..96d0b6482ac4 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1172,7 +1172,7 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk,
 	}
 }
 
-static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
+static void rx_drop(struct xsk_socket_info *xsk)
 {
 	unsigned int rcvd, i;
 	u32 idx_rx = 0, idx_fq = 0;
@@ -1182,7 +1182,7 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
 	if (!rcvd) {
 		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.rx_empty_polls++;
-			ret = poll(fds, num_socks, opt_timeout);
+			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
 		return;
 	}
@@ -1193,7 +1193,7 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
 			exit_with_error(-ret);
 		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.fill_fail_polls++;
-			ret = poll(fds, num_socks, opt_timeout);
+			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
 		ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
 	}
@@ -1235,7 +1235,7 @@ static void rx_drop_all(void)
 		}
 
 		for (i = 0; i < num_socks; i++)
-			rx_drop(xsks[i], fds);
+			rx_drop(xsks[i]);
 
 		if (benchmark_done)
 			break;
-- 
2.27.0

