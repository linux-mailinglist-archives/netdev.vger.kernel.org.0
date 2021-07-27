Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62AB3D80AC
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbhG0VHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbhG0VG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:06:57 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E91EC0613D5
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:06:54 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so6614716pja.5
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O5PVCm4vbOkHTdhySLNgX8cYsmk07det2tWYYr+tRf4=;
        b=gxKAidxHtXkH57cdgTrBRW+Iu6kBJm2gLTc/ZhTreM4nUhVINAm9hnCEsll5JLIeuv
         GXDrZXo19JKoLdUCWqYws3d6+nRR58XFL0Nk9+2Zzh54A6uGcEngTnaAEe4kkqqnI2fB
         ruSx/lD+GWJQolLfAMVF9OQXx6F28ZgkVPYx0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O5PVCm4vbOkHTdhySLNgX8cYsmk07det2tWYYr+tRf4=;
        b=jczb4mlf53/8QOBkIETNcSi9N6fj3HBESaSeU4KHyRTOgJa+Nduf3h3TH1fryVV6IT
         w1CwGMGO/ZL88sggTzA9tPqeG7ilOuTu+GtFQ/XN0XmPJYtDZ31kNJ1TNT5Fdk98rMtW
         NYwUIt1Fa/lce09yY6U60ZmvB+0TmDDoK8S/EXUn6nQxMo9XlGUF8H6IXKDxB7jYPBuF
         IBHE9Ec5M3I5nRH5/HWmZswXUkgDpgORJ2TQHiiK00aoJj/p3wEzSZ/xm2QOF0qLi9Og
         5e9C22hng4IQ+klPKT8E8MKv7pugqhjf2/FbGmJfkaNXoMWxxI7rD4e9BgYnVgOp9GkR
         BO7A==
X-Gm-Message-State: AOAM533Py6GI5Bayf7PE79gVh/NOWugdxig5dsFFIISrrYv150zBQstq
        3dyRlIf6FEsPwdFrOp583vy/qQ==
X-Google-Smtp-Source: ABdhPJzlXy/VcX23c9PQ65+XqlmSvwlYyjvPZKBc9QGkV1GFAs820b6KtM3ET4HtRC/ZSXPL17y+Jg==
X-Received: by 2002:a17:90a:c003:: with SMTP id p3mr23960881pjt.14.1627420014073;
        Tue, 27 Jul 2021 14:06:54 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q14sm4721670pfn.73.2021.07.27.14.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:06:50 -0700 (PDT)
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
Subject: [PATCH 55/64] RDMA/mlx5: Use struct_group() to zero struct mlx5_ib_mr
Date:   Tue, 27 Jul 2021 13:58:46 -0700
Message-Id: <20210727205855.411487-56-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1274; h=from:subject; bh=oY909dEANo6V3IFn0noc67FV5hBK8uceU7oGCjc7zOw=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOMh317iG5OLcRV6f6KOkZ9q+C2N36hwkRl8LQQ C7eGawSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzjAAKCRCJcvTf3G3AJg4UD/ 9BnzAT1Z7CsW+TRX8tpO/bHWsp1ALKoQrreRJNLcuwaofCAjFi8BnU29qFDffCG8DWqAC3Pmtj4p39 RskVkYUAy5axxifQzhefjhk7tLjvkw2mmeV+0QGdeg2rbLL5Dpmmav2A7WaFsWyg7W74/0ud+a6Hbc M4RLDpYX0mM68jox12+Syr653lTWFNFS86gcN1Q975/PUD2xYk3dY3H3s2zF7i9XFyEP2N2G5zErPl ED8ZrAbuSSNxMO5rke2YVbiw/FbKveB5UCkCgtjoT7lSW9mZYdr144xmSl8iaDmr3LYdfAxQG6WpF1 N2W+2K9FRkZT0VZd9PdKAMbV3Ofm9qyfYEnpmGGs0y4uhKJtYKpv60s7YXeG+eQtwR/bCFvecfShz5 rvqvYF46IrMS8jbLeJHjqvjyd1hw+zCAJKd2c4R2LPUZ7WDVjRNGtq82PEZ2Tr725JvJTSLKrGx8YA tWmn4rCBBSu/PqTl3206VAZLiP+HeqZxC26TE27C7IcR67ONOX3U06CdJRm2X3VkQMJVPvT0OYPmRr DH5V/sNlfiZe0r9fNcKAYsCQaHKXs6D2jYAWqxqm2msNETdd60wrVAfUL77zKIV9hqqj6sRIXPhZ8R +len0ulP7Zp0NQRxZYGLikaPmhWeDXiQR88kCVUq6p0rdBPBuFSFYAGLjJSQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Add struct_group() to mark region of struct mlx5_ib_mr that should be
initialized to zero.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 585fb00bdce8..830066e95260 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -644,6 +644,7 @@ struct mlx5_ib_mr {
 	struct ib_umem *umem;
 
 	/* This is zero'd when the MR is allocated */
+	struct_group(cleared,
 	union {
 		/* Used only while the MR is in the cache */
 		struct {
@@ -691,12 +692,13 @@ struct mlx5_ib_mr {
 			bool is_odp_implicit;
 		};
 	};
+	);
 };
 
 /* Zero the fields in the mr that are variant depending on usage */
 static inline void mlx5_clear_mr(struct mlx5_ib_mr *mr)
 {
-	memset(mr->out, 0, sizeof(*mr) - offsetof(struct mlx5_ib_mr, out));
+	memset(&mr->cleared, 0, sizeof(mr->cleared));
 }
 
 static inline bool is_odp_mr(struct mlx5_ib_mr *mr)
-- 
2.30.2

