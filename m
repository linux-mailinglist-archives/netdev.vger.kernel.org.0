Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D113EFAF0
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238257AbhHRGHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238282AbhHRGGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:06:36 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13531C0611FA
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:05:56 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so8173512pjn.4
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gUjXHriNI60ZMiX98O41J0RBUaJAOzuxCN136yOtJx8=;
        b=PFR7uYpP3VrpE4Zr8VMf97aLHDhHs7MCH87WL+gpOmTOK1WCgqayKERpAzNjnF+s4i
         9ajmen1yXG+vpJNm8m9nhLHe3xml94z7vjPinj8nzZWRd+UvkObZQmTbKhHOgjie9KGY
         GwGNjjyCQL5UCD3lxRE1kWmJhtmjWT2CNQkZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gUjXHriNI60ZMiX98O41J0RBUaJAOzuxCN136yOtJx8=;
        b=DXyIP4+GoqVBzS74CuXXylNVDD0tVbc7HhTo+Yc8vHAgMTDiOAf5ANqejCeDvmI94b
         8O9d0ieRZ3fywH/waO/Ualg9dstncbgJLwCIo826uwZgY/z1bWRMVpGkQPCrpfpL+kaH
         Z4gPI+5zkEXN4mAVfyTeqgVHXfasIzXFeDrsvnZxdkEyxFW4qDJSN1dYNADSfgukMhhF
         fya2skz4RrqD5uCl2Fxtz7nNJXo7eBv2yyhhP7w2xs4Qv20ae+uIXCgAYAgHKV1bSoeb
         pHd9AjlOnOzKyCiqIVzNv2qSDxz2dvIDOAHHxSoWyoygeBtOwdKiho70+3aJ0+tZby5/
         wLug==
X-Gm-Message-State: AOAM532ETBsmZbKw/RUxTxn5vvKdDwhFiHytU88c9vbi2d9jQt4OsGvd
        2o83UNgGIH7uPwLOxGcrmy4YjA==
X-Google-Smtp-Source: ABdhPJx12eVE2s9aJqrT8X6wYbgyP7wX5Q41/S0rPW3qXiQMC3iYutyI7oCSghqi1s9SYy0llSUR8w==
X-Received: by 2002:a17:90b:11c2:: with SMTP id gv2mr3328920pjb.227.1629266755654;
        Tue, 17 Aug 2021 23:05:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p34sm4534140pfh.172.2021.08.17.23.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:05:53 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 08/63] bnxt_en: Use struct_group_attr() for memcpy() region
Date:   Tue, 17 Aug 2021 23:04:38 -0700
Message-Id: <20210818060533.3569517-9-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2801; h=from:subject; bh=TrncHbsmiWtnPjfAh2YkxN9s4bIlTDfFJMFZjUYKPP8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMfghAlM5KHg2hODEFSil5MEnhHr6UFtvkVIcLZ UTb+yCiJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjHwAKCRCJcvTf3G3AJrOJD/ 9hJH7jjz6tTkXVy3qRA527RgZiJeLECLzI6DoacBsPBfgyoKgz38PgicK9SwNgGvknQLWXJVluWAP3 E6rfbFiFlaM+Ah7i9TxwUplp60bQ8YQ6iLUK1jH7hES5/9GBkUaUVkVD3QjkV+GFMjzQAoawZjdUpr bE2gauE7tXilXaSUlWcyJfI07eT+K1XAEXoEY25zZpgxMGLL9yt/EbtvJcI+IrQuzSk/npjqhtQ2T3 d1nN9lTpRoS2zYNWrlVJJwNxvF1D1OBofuImaHDiDSNHXNKeThXLcbj1UYQqw/Ysgyk3p6pUd21lZB EuXd1zc9Yz9IEs6aPE6YEdm0AdAKR4pu8NCfI2LOYoDFMavYA+UDx+3rb/38ISxKIokoPZG0aHpP4c ezu4gtgECYTqz+PxbA2YWRttoBtOT9wi+rXSXOrtuHdJ9I1SuKBFQ8dMZXVFk0b2j6eA/u33kPuF+X I7KNJW1I+qU7lmi4iGjzDA1ALhfCCbWN78KpBUzwnIJbehj6BXZr2B04FaSAWa5Qe1BlLaaCW2szcx ScEByKBugc990sVUSUI2bY2JLlU8S6kgDfe8tUa7onXMNbGcnY2eexNnUsFBVySVYvcIQmVaSDF/u/ corCu6p0SQZQCPWdEE3UyQoxqtTSfoiIghXXJkxUfXrbaG5HgaIbs8lXLpJA==
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

Cc: Michael Chan <michael.chan@broadcom.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/lkml/CACKFLinDc6Y+P8eZ=450yA1nMC7swTURLtcdyiNR=9J6dfFyBg@mail.gmail.com
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/lkml/20210728044517.GE35706@embeddedor
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

