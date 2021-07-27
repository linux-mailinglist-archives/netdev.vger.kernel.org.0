Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A1B3D802D
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbhG0VAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbhG0U7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:59:14 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649D8C061387
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:10 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ca5so1755874pjb.5
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RCqXotzAIvnXgOqstJDis4roVpoLDPnfq3WqfZlD8nw=;
        b=IsnPTTOIgdGKCXuW3XQ+MT6hIlhVYI7Io0wctUxwqvbJIIvtSltHPjtWeHzLWKF+kA
         CQvAxohJQYoF71joFX6v/3Z6eoC2GSqaTNcLccBsOh5LMFueIVes2gOSJpZyft2tneFd
         eIMQ6OLOd1lFb131IMCikGtxTAI11b8IFNErI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RCqXotzAIvnXgOqstJDis4roVpoLDPnfq3WqfZlD8nw=;
        b=FO6P12n2A5H1RmEQcTjg4kw4tz62tGcqqk5Ju0erj2dw/oNbBCvd1zu2vz1ecx9tG7
         B72GGwHBt9QUs9iovFXBcP9IlRKcLANcLc1BxXm1fXUsnlCuPXLxK/E/0NWRfbP248Yj
         Jr9fGOMpYw0pCf6lIfbSZpLgSZFI//F64+yhG+xd38f4xiypysXZw43u2KblFFgYYIQw
         FvKJUyWsqdl+vH9DjfakWFTAhvuUr05HVvzq2WxBl9X3KEjavrI9E84253nWNq2Z9AMI
         E6XDScNAQiEyiJ1pf91jGUrQDbREustAIHLc7Df/mPVE+0N/3uVfewM47uBbg2Y02XQQ
         1NuA==
X-Gm-Message-State: AOAM533jXcm3E+djccivgmkHLJ/ojOxrVr9GXB2eMOWPSZ55y4g9WRPN
        Zh0Z5r3EtSqrGhOc3pTIVmxpfw==
X-Google-Smtp-Source: ABdhPJzspBBQMDyvDf6TBVh0kJFHAIruWS/HtAlIq0eRpPNOGgO/FodQZJlNxuLaUl6IYFezsXLBRA==
X-Received: by 2002:a05:6a00:1c6d:b029:338:322:137d with SMTP id s45-20020a056a001c6db02903380322137dmr25076229pfw.38.1627419549870;
        Tue, 27 Jul 2021 13:59:09 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h20sm4771196pfn.173.2021.07.27.13.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:08 -0700 (PDT)
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
Subject: [PATCH 11/64] net/mlx5e: Avoid field-overflowing memcpy()
Date:   Tue, 27 Jul 2021 13:58:02 -0700
Message-Id: <20210727205855.411487-12-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2638; h=from:subject; bh=QKALqwrqhLc+7tVP8mb7u9vJwM2ktK3XL7hcr7RjisE=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOCimDJCcehKBIQzI/fV1vkomdBEz58Sp357Acw ashx10aJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzggAKCRCJcvTf3G3AJowOD/ 0cV2/gWpM3tzSGeDnd+48FkILInBduxYU7T8eAce0pFHdDWK3Xdzt0Rz/8KSK9g9qHiPAoTtE1ZDZs IdycA5PGwVU7OoMo9y8rxip+T0x8+0FTjiK0eEeADuraWJtuRkY7rqUv3anZB+7aFcy23HLSzsokDy v3K2NShHDdMr6+BTxCwT82oNKp7sflOMI9zqU65OfotImRrxPDAWNMY94XTaiIiAAWhAiHJTCCBy8a ww4ATYSVeRhj5CuJno8eppzIfgRbYoroFPSEqjpMIcR8XWfhMi3nGrZH+yIEDKzj93dnynMtjdt29m NwgegnkyruD3AJAJMQlWpROj7wM6tRwt/RQHzXD7ude5mYXinSx6o7qjeEh5KvtVaWGZNIyNH7QX03 PtXqkYsIh8qzepHC9wr8mH6qkkUO1tkoy2yiGAA+MawqqegNs1HUQyC90hWs+rYewPsWZdHCusZQgh ZwPEDFuZ5NwYCIx582KcOGBtSe8ERTdcCF8QAsSe7eA8uVzZh7NgAKPp9Qv5ldepnhjwjiXDlXn1kl c6aG7NcBdLnGZLaWPMWbzyie+xLb3X42bGBryj5ZyD+7tJuSeBWhYRQ4Vf3KftFyOoXMrhYgc97usd VBN5UHc/ZqYheG58Rq9zQ6wjzNvKBzLmALvQsvOQLX+K6SPP+pWWlQKN4+LA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use flexible arrays instead of zero-element arrays (which look like they
are always overflowing) and split the cross-field memcpy() into two halves
that can be appropriately bounds-checked by the compiler.

"pahole" shows no size nor member offset changes to struct mlx5e_tx_wqe
nor struct mlx5e_umr_wqe. "objdump -d" shows no meaningful object
code changes (i.e. only source line number induced differences and
optimizations).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h     | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index b1b51bbba054..54c014d97db7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -204,7 +204,7 @@ static inline int mlx5e_get_max_num_channels(struct mlx5_core_dev *mdev)
 struct mlx5e_tx_wqe {
 	struct mlx5_wqe_ctrl_seg ctrl;
 	struct mlx5_wqe_eth_seg  eth;
-	struct mlx5_wqe_data_seg data[0];
+	struct mlx5_wqe_data_seg data[];
 };
 
 struct mlx5e_rx_wqe_ll {
@@ -220,7 +220,7 @@ struct mlx5e_umr_wqe {
 	struct mlx5_wqe_ctrl_seg       ctrl;
 	struct mlx5_wqe_umr_ctrl_seg   uctrl;
 	struct mlx5_mkey_seg           mkc;
-	struct mlx5_mtt                inline_mtts[0];
+	struct mlx5_mtt                inline_mtts[];
 };
 
 extern const char mlx5e_self_tests[][ETH_GSTRING_LEN];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 2f0df5cc1a2d..2d2364ea13cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -341,8 +341,10 @@ mlx5e_xmit_xdp_frame(struct mlx5e_xdpsq *sq, struct mlx5e_xmit_data *xdptxd,
 
 	/* copy the inline part if required */
 	if (sq->min_inline_mode != MLX5_INLINE_MODE_NONE) {
-		memcpy(eseg->inline_hdr.start, xdptxd->data, MLX5E_XDP_MIN_INLINE);
+		memcpy(eseg->inline_hdr.start, xdptxd->data, sizeof(eseg->inline_hdr.start));
 		eseg->inline_hdr.sz = cpu_to_be16(MLX5E_XDP_MIN_INLINE);
+		memcpy(dseg, xdptxd->data + sizeof(eseg->inline_hdr.start),
+				MLX5E_XDP_MIN_INLINE - sizeof(eseg->inline_hdr.start));
 		dma_len  -= MLX5E_XDP_MIN_INLINE;
 		dma_addr += MLX5E_XDP_MIN_INLINE;
 		dseg++;
-- 
2.30.2

