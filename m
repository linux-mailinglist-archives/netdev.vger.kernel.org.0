Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287803D8042
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhG0VBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhG0U7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:59:07 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6154CC061798
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:07 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso1053329pjo.1
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2339k4b0c5OWODNkIvToUoNb0tla173APtop2g87yK0=;
        b=iEi8m5VvnHSI7PFGMBkWP99DR9/hasEmGaHMmQ/hAQvXWolvYn1ZqWUISR9yx86HKe
         271G4W/Ncz7bw1+gj01x3c+6WGGDOH9Vwl/Z+aiHCXNR+A9GI+MIw4zbZztpHvcFA5pK
         3bJY25UolqjG5yrPadDsyTKAutRNBCjMgVGtE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2339k4b0c5OWODNkIvToUoNb0tla173APtop2g87yK0=;
        b=Gcqd0ZUzCjBLqzYOihdJc9TXwcfIzaZrUlzQza5pJh5abNI3TDs363Cey93yu4r4wb
         26r9pVyQTYITz5EFl+rAq67nTBLWRdxEjsEHqpp1h5J4cvSdQwCIcHhHDS8Baj4s52jH
         DO8/S9Lo0hXUV713F7xgfCdxydfD7kbyvhqmkG8aVQlXLm2L3xqpso8otvLR/y9I0bXI
         pY9OqnFvKqm0rCMQ1Wwo2jmoMRur9Vxq/NS+iAu+2EPInbgL1P3a+oz+A78w8fzXmt2p
         HWIhVNcpPpEnPGa2HDrGtu9R1YbUBaUlPIg19uAvWX85x5nllCEc69+BkOP901+RSwc5
         EZEA==
X-Gm-Message-State: AOAM5338Ip0LNMm+INia/i2tHdRegGtYvkZ10l6dM9lj9AZXGcBBoR5f
        dV4WAk9yk0ljqfVvj8KWpReSuA==
X-Google-Smtp-Source: ABdhPJyJWxUGA3LrJs4BG51/vLWpJYAHbkWL9HNsMr9tG1fy6upd+bj3BEBNQksVHaNDSvFaiNMgng==
X-Received: by 2002:a63:5610:: with SMTP id k16mr25193869pgb.439.1627419546981;
        Tue, 27 Jul 2021 13:59:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j20sm4672710pfc.203.2021.07.27.13.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:05 -0700 (PDT)
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
Subject: [PATCH 06/64] bnxt_en: Use struct_group_attr() for memcpy() region
Date:   Tue, 27 Jul 2021 13:57:57 -0700
Message-Id: <20210727205855.411487-7-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2358; h=from:subject; bh=urnr1c0HuSr0zcemksTCEth1t70QAfbHaEcP+c1mXUA=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOBqioJQ+1gy1GQQan/jf7RJ1/WXH5A0qXVd7xV vq5+5hOJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzgQAKCRCJcvTf3G3AJiWREA CNm4WJeCn47J5obmfhInAVhQHs+WaRodzYXqYlwhYZwqztfgNWLmnuTFB7WixSIet+ogzFMJ1r7fzU QnWXAsLuJ3BX98gUGzvKpmV42J3D2bYmtlrZs7Eyhzqsf8YU/1DgzM/cyzoMB1MkY7QVnFyA9ECldc n4XuqAu3QiaIe+5lzEXU3cW0wy5VDaO3U89VhsX3c6FWjMhQ0FF71U5yZVlZ7s8QMcwjgGQ/rSZ5HS tHMaYMmuprGsc0WRWDxssLMce4AZIdKRwnQBGxYX56oM9u/26JaL77KjZeahVv+n4nC+KkXfWFoSls jO+qT1zevLJBtQfWAqBgbtl6mxUkW3D/0aBPlL7o63ss885dcW9pWjj8sVkqG2AOPVUcl+mMOp+VQm 5qmqUeZbnxJVtXjSRXpvzpBMjNj47QiFJaRRu++FQ9+TJ9TwFws9C31mCXsNjIBK/xzNCc0OuY/J2T Fuuz5AL5SsvRzztZGGQvpjWG2xGgfilhJucEqfeyaJrFQIvjGMIAVFYzMGX4dwwIpBMhxVU4spof3f TLNENoSRR30/sOaQWASgjwj8RqwZ3WioWr4/ALRyqYdHD8j5usq3wgrSpYlAC1AQpefx1uLVDOyes3 1j+4vL+JqxKC93LWdqu/2gVD/VBJnBjDTcrSW3GQTmYSKuzKxca2WKziYSew==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() around members queue_id, min_bw, max_bw, tsa, pri_lvl,
and bw_weight so they can be referenced together. This will allow memcpy()
and sizeof() to more easily reason about sizes, improve readability,
and avoid future warnings about writing beyond the end of queue_id.

"pahole" shows no size nor member offset changes to struct bnxt_cos2bw_cfg.
"objdump -d" shows no meaningful object code changes (i.e. only source
line number induced differences and optimizations).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c |  4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.h | 14 ++++++++------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
index 8a68df4d9e59..95c636f89329 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c
@@ -148,10 +148,10 @@ static int bnxt_hwrm_queue_cos2bw_qcfg(struct bnxt *bp, struct ieee_ets *ets)
 	}
 
 	data = &resp->queue_id0 + offsetof(struct bnxt_cos2bw_cfg, queue_id);
-	for (i = 0; i < bp->max_tc; i++, data += sizeof(cos2bw) - 4) {
+	for (i = 0; i < bp->max_tc; i++, data += sizeof(cos2bw.cfg)) {
 		int tc;
 
-		memcpy(&cos2bw.queue_id, data, sizeof(cos2bw) - 4);
+		memcpy(&cos2bw.cfg, data, sizeof(cos2bw.cfg));
 		if (i == 0)
 			cos2bw.queue_id = resp->queue_id0;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.h
index 6eed231de565..716742522161 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.h
@@ -23,13 +23,15 @@ struct bnxt_dcb {
 
 struct bnxt_cos2bw_cfg {
 	u8			pad[3];
-	u8			queue_id;
-	__le32			min_bw;
-	__le32			max_bw;
+	struct_group_attr(cfg, __packed,
+		u8		queue_id;
+		__le32		min_bw;
+		__le32		max_bw;
 #define BW_VALUE_UNIT_PERCENT1_100		(0x1UL << 29)
-	u8			tsa;
-	u8			pri_lvl;
-	u8			bw_weight;
+		u8		tsa;
+		u8		pri_lvl;
+		u8		bw_weight;
+	);
 	u8			unused;
 };
 
-- 
2.30.2

