Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39CC3C3367
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 09:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhGJHGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 03:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbhGJHGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 03:06:06 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F07C0613DD;
        Sat, 10 Jul 2021 00:03:21 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id v14so28217377lfb.4;
        Sat, 10 Jul 2021 00:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xo4bexh207DLTAjED8GZaZ5kSi3bAbNhqunA58gKJSQ=;
        b=YuFfzV5PEjCJ73ZKma2lAnzAgcwWvh6hBYp02t9GzUXSgMDvk7M8AjtY6r5u/GsyRG
         a9rd6fDbBDQRkHC+i1s0K9M6r0dfFami/+NXMRwv6JkyYkNFkTS5zQ8uHxYMCp9W3idU
         I/fCGtlhGSDRAKGZRSppap2iUqs7YegGLJTAYHu4Pk3ZlJnl62ODtWrxj05EWMoOHOAC
         8Li9ElTI6xmpFWezFVq0dSExPl9pPR1725MAc0z/fOGL5KikOynrMMHznIpo+AecLZ4L
         76qsZgekcTLDgZE0qVXBT2CMaCxnQm1OBm2RnbzHrwcvaQ6UhjGsLpqkouJoH8jpSNVh
         BMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xo4bexh207DLTAjED8GZaZ5kSi3bAbNhqunA58gKJSQ=;
        b=NdrFrkc7GjvIxFZIrNe8BtkwMqzOVzJDhCb+p0aK+iSGiMpdhJqQ8tw1SlfntNz488
         UaYGIb4g2whmgzl/5OoFGnrIyoePgTOAebQsmgLg5FmqA9v/8QzmoCxFvHXZSQNI4yRL
         Zhwmdek8xvESEsHzoYDwxneMVv2rtkDioh6MSlg85uoaLprKFxlgtNbarXMfgnHxL8bl
         BJ70R2CpCCdN/JG64BjyoRpV//mr8i1J7roNJI+Yc19yE2dQJFrpZlZsHeb2SqasACI6
         oDdZzR3KtzswekSo/AKAlcRT5d9/2KVCmEopZLep9JRtlT5dUdbWnetTe+ucVK2wNv5R
         2QuQ==
X-Gm-Message-State: AOAM531zjqpFRY/v8n7guYB0eNElwhmHksGMN7/3v3sQtyI2kh6dVBfl
        JrCgYFVKNEw1/wz/NMITodM=
X-Google-Smtp-Source: ABdhPJwoeX4A8fRR0QsrYJzJJOPI2Ud7BK36wluOrKelOU1yZ3F2gWSCpar5CybY4hJWlWyXVC6Lmw==
X-Received: by 2002:a05:6512:3f0d:: with SMTP id y13mr22915092lfa.217.1625900599534;
        Sat, 10 Jul 2021 00:03:19 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id p11sm642778lft.298.2021.07.10.00.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 00:03:19 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     paul@paul-moore.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+cdd51ee2e6b0b2e18c0d@syzkaller.appspotmail.com
Subject: [PATCH 1/2] net: cipso: fix warnings in netlbl_cipsov4_add_std
Date:   Sat, 10 Jul 2021 10:03:13 +0300
Message-Id: <53de0ccd1aa3fffa6bce2a2ae7a5ca07e0af6d3a.1625900431.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1625900431.git.paskripkin@gmail.com>
References: <cover.1625900431.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported warning in netlbl_cipsov4_add(). The
problem was in too big doi_def->map.std->lvl.local_size
passed to kcalloc(). Since this value comes from userpace there is
no need to warn if value is not correct.

The same problem may occur with other kcalloc() calls in
this function, so, I've added __GFP_NOWARN flag to all
kcalloc() calls there.

Reported-and-tested-by: syzbot+cdd51ee2e6b0b2e18c0d@syzkaller.appspotmail.com
Fixes: 96cb8e3313c7 ("[NetLabel]: CIPSOv4 and Unlabeled packet integration")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/netlabel/netlabel_cipso_v4.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index 4f50a64315cf..50f40943c815 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -187,14 +187,14 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		}
 	doi_def->map.std->lvl.local = kcalloc(doi_def->map.std->lvl.local_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 	if (doi_def->map.std->lvl.local == NULL) {
 		ret_val = -ENOMEM;
 		goto add_std_failure;
 	}
 	doi_def->map.std->lvl.cipso = kcalloc(doi_def->map.std->lvl.cipso_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 	if (doi_def->map.std->lvl.cipso == NULL) {
 		ret_val = -ENOMEM;
 		goto add_std_failure;
@@ -263,7 +263,7 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		doi_def->map.std->cat.local = kcalloc(
 					      doi_def->map.std->cat.local_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 		if (doi_def->map.std->cat.local == NULL) {
 			ret_val = -ENOMEM;
 			goto add_std_failure;
@@ -271,7 +271,7 @@ static int netlbl_cipsov4_add_std(struct genl_info *info,
 		doi_def->map.std->cat.cipso = kcalloc(
 					      doi_def->map.std->cat.cipso_size,
 					      sizeof(u32),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_NOWARN);
 		if (doi_def->map.std->cat.cipso == NULL) {
 			ret_val = -ENOMEM;
 			goto add_std_failure;
-- 
2.32.0

