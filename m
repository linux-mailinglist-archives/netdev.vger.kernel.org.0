Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5292C29D9C2
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389930AbgJ1XCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389508AbgJ1XBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:01:44 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52114C0613CF;
        Wed, 28 Oct 2020 16:01:44 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q25so1325282ioh.4;
        Wed, 28 Oct 2020 16:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pjXiaJJaFcfh/d5Hg7T1ivvJjPLwr7C0xxhr2qpyt5M=;
        b=GxjsphOX2zEbZqqdQjCwAyYsCORJvqE7NNfEH29SRF58gKtpndwV3xboOfeL6smVhr
         4g9HGrTfQyhg0GU/TbXK7hJt3NIiNdA2V8nV9goYxAa4mJST3cVcz/KhnqPh8EqWynDC
         sriF1cbKq5FLWJnxDmMDZg+khJmAWWy+d1pAz51gd8d4ihLk9EF2itAqhARQNy8Jq0ii
         SkL+OfhtU1GE//eVEggFflv5XZg0HQvYBN4ZTWsrISGG2pRxnVmvt9J1hvabHy0olmuR
         915k6mYOzmj3DXKD4SYLXVGkIPhldX8Acsy8lWnmYbC/VTdrJNcf9BwKVJw9n8v8xx+g
         5u5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pjXiaJJaFcfh/d5Hg7T1ivvJjPLwr7C0xxhr2qpyt5M=;
        b=YJy7437eVW9YzTJ0IPFEUl/kL4YDYmd4d2Nuee5nC0suu8uRW2DA14fUcEFcEsHSgv
         G+pm4qjyq7TxWm+kkXNrrXk5DfcwOE2z3dMc5FCf0mQMpgR0rjq9uzmuIuyqr6qU7JdG
         yUrlnYeBWiT0B8OE1g8W/MCeZVzk7vXG80vOeFOZAiQMI3NKpMA+qUr+6nngP5UFFEtj
         I/CuS1RIFphwgBgInYZJcR4ZTL7a8M3647Vxk/x0nQSbOxb+mJScZyohMWYjJJM7EDPd
         P0XJ2Y1iNcX9xBIS7QrDy3kQa0KQ7vzhEj0oR01e5t0+vCnb/QZ7Ex29jViHNwwn0665
         /O/g==
X-Gm-Message-State: AOAM533MEGDv7unlDVHTr9eMU3A32cwzLocfvNG3TESA6NbCF0E4bnYP
        zO47KQPrfysLJhLWcClmdHQpY17k+wpiAbW4
X-Google-Smtp-Source: ABdhPJyIdK45Sv7Xjy21+qnn5zK3LkhfJoLsJXWYGmLi0HlZiH+Y7k2D41upxa+5dTuxo4y475uc9g==
X-Received: by 2002:a63:c211:: with SMTP id b17mr6356557pgd.195.1603892144863;
        Wed, 28 Oct 2020 06:35:44 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q14sm5935393pjp.43.2020.10.28.06.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:35:44 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next 7/9] samples/bpf: use recvfrom() in xdpsock
Date:   Wed, 28 Oct 2020 14:34:35 +0100
Message-Id: <20201028133437.212503-8-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201028133437.212503-1-bjorn.topel@gmail.com>
References: <20201028133437.212503-1-bjorn.topel@gmail.com>
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

