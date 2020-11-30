Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C909F2C8D65
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388237AbgK3SyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388215AbgK3SyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:54:03 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5E2C0613D2;
        Mon, 30 Nov 2020 10:53:22 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id r9so133595pjl.5;
        Mon, 30 Nov 2020 10:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fmqhingHLo6a3b7AT4xKvWss37atmCmXSS2JFS2qwt8=;
        b=mLWsM3dgojb+LvnMZdQrQaRRXrS0CPK0KYxTsh1ET1ITv5UOfwPa5v8lmvpE0zAUHO
         Ltf6T8kfYScaqRkrf1khDQqRg8K+si3jrln5C0bP33QNNfEixeCLQNKOzF4L+E5o/r3R
         5u+iZ9z2JRL8CsgBzMzxl1xEdRMdvD77Ejtu07MWF6mBOSVZ6T5Fzu+gv+21wE8St1nA
         zd8GOHZZnEhPu4VcLZy0HkmgfGSWo0549V9OQjypmKlCqUTOiYXchYfQie2ctiS7hVgB
         ZCKoKUfSRNh6jhxl2U0CdfXs3v6UHav1Ix6crkmZ5L2meoFo3DoJLEYR6gnz8yPlh0N+
         cDJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fmqhingHLo6a3b7AT4xKvWss37atmCmXSS2JFS2qwt8=;
        b=tErBh1/gezi+Q7XCl0dTK3LpqWLgMNlYic3Ln3k4/Kx0WLsfADKdA13BzG/wfwhy/Y
         aAPkkIqjXhmwpgKsX80dwXNZTVT2yj1afOfM2goNT37eX1z0xc9S8IrncIad7wYhW2zl
         4hc2NlpW/udgu0q/nsFmjLKNO7vo/iGe3pcINrusfVSi5n6qL8WBD9p+OlR7t5YF3k+e
         YXluySbOiCjtRoU1zNUEuBZftoBVryJmHtxm6LkMvfCmH6YHA+DJKeOZ5TNZCmuL4Fb1
         pirCZOHPIOUxL1+81BxO46h5bIw1PUag/NQg6iKwbppx86eew7/+Jn1FFBxOwRxxZ0r8
         Nonw==
X-Gm-Message-State: AOAM530cLqdWHpFcFCpSth5DY2Po7cHJrE6bJMSoorqIG2FrqbHYztQ0
        0HG+xoZSG+lHJflkwcv0mAPpBoTNXQc8qJRn7OY=
X-Google-Smtp-Source: ABdhPJxJp+GRWsvXDUjngQkjuJUrcfigF+espLaDp5UTTjcihuycguUANO1ZCtChnG9dLSn004YVhg==
X-Received: by 2002:a17:90b:3658:: with SMTP id nh24mr256052pjb.80.1606762401345;
        Mon, 30 Nov 2020 10:53:21 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id i3sm12005978pgq.12.2020.11.30.10.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:53:20 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v4 07/10] samples/bpf: use recvfrom() in xdpsock/rxdrop
Date:   Mon, 30 Nov 2020 19:52:02 +0100
Message-Id: <20201130185205.196029-8-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201130185205.196029-1-bjorn.topel@gmail.com>
References: <20201130185205.196029-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Start using recvfrom() the rxdrop scenario.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
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

