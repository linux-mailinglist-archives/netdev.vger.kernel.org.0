Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC75026D4F8
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 09:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgIQHpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 03:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726306AbgIQHpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 03:45:07 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC91EC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 00:45:06 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gf14so798010pjb.5
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 00:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2N3mWH4dWBjYIgMqML5SFtLQn8Wc+WVJixIOAPyOzJA=;
        b=idh71yNvBVxWLoWXnqR9b8hBq73P+5oYksH6cYCmUxaJLP3zItcAtvxAsAEejSKGD6
         OOnwMp8FC7fdVZGvrLSajJRiOAdWaiH7Ab3/T8FSAi3AYtwsXOtMe1KxQCTIq2ZfIfOE
         Bu6qWr+/agn6NHYaPkONMNJXpevY4g5TXNbSapVm1mCRUaBqrcdOoeAe63iXk47IHqRo
         esN9NiE0x3+j9s4y4bD3NKKQnQofCIUBsNHFaMc0rXJAsC3KUusnfWyD8cadGXUKOuyM
         ndR0r5mTn+vArVbFj/8G+gS8Lo/xY9SiWnUEgcjoxZzvz76QzjKbgVGVEbm+5jSk/X/h
         9nbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2N3mWH4dWBjYIgMqML5SFtLQn8Wc+WVJixIOAPyOzJA=;
        b=b/UBn8HB5vwoRpelF2n/347lc4IOLbjaxuCY7yNw8+F/LhV62TieKy6hGKTdU9N7Jf
         xx44hEbUvq0/Ik17/AMdB/obc1k9pJigaSvkoZDBhrs3QOh9lpC9+MTX3C5uitdWmu/M
         zwNki4qTj185agKaU2WMWT1HN4DYnxhDlEU6UNPUZ6ia4h6NgH/rkndKJhoyA+STInjt
         iSaVeNX5a60vcXBsaW2OqEd7084auWJrN4qTd2B4TfMzl9BdMFWDD7v1RVIw7XZ62K+U
         MDPqzyYSqU/2FUt+Mz2pEaQi3Ub2jJoCwlLnH9+8kQmeF+NFeQTpMbmpNaiirMga2UcS
         VNIg==
X-Gm-Message-State: AOAM530gBqU98+3xV0cOwHfT1i8UESTclbANAaM/9EZQQ1+eE/zu91Xh
        10Y5TWPHrpvOHWcNFkpUlhbygQ==
X-Google-Smtp-Source: ABdhPJwXaMllPXLLBBq/ZdkN+0JpO5r0KMFYX2Af8lAj/0slXE5K3cOn/uUBCY85+zsg2ZmTQcGeuA==
X-Received: by 2002:a17:90b:20d1:: with SMTP id ju17mr6874545pjb.134.1600328706465;
        Thu, 17 Sep 2020 00:45:06 -0700 (PDT)
Received: from bogon.bytedance.net ([103.136.220.66])
        by smtp.gmail.com with ESMTPSA id v26sm17786351pgo.83.2020.09.17.00.45.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 00:45:05 -0700 (PDT)
From:   Muchun Song <songmuchun@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>
Subject: [RFC PATCH] bpf: Fix potential call bpf_link_free() in atomic context
Date:   Thu, 17 Sep 2020 15:44:53 +0800
Message-Id: <20200917074453.20621-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The in_atomic macro cannot always detect atomic context. In particular,
it cannot know about held spinlocks in non-preemptible kernels. Although,
there is no user call bpf_link_put() with holding spinlock now. Be the
safe side, we can avoid this in the feature.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 kernel/bpf/syscall.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 178c147350f5..6347be0a5c82 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2345,12 +2345,8 @@ void bpf_link_put(struct bpf_link *link)
 	if (!atomic64_dec_and_test(&link->refcnt))
 		return;
 
-	if (in_atomic()) {
-		INIT_WORK(&link->work, bpf_link_put_deferred);
-		schedule_work(&link->work);
-	} else {
-		bpf_link_free(link);
-	}
+	INIT_WORK(&link->work, bpf_link_put_deferred);
+	schedule_work(&link->work);
 }
 
 static int bpf_link_release(struct inode *inode, struct file *filp)
-- 
2.20.1

