Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7580A10F540
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 03:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfLCCzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 21:55:06 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46573 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfLCCzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 21:55:05 -0500
Received: by mail-pl1-f196.google.com with SMTP id k20so1030672pll.13
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 18:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IF8hGJehe62RZyEGQomk3G52X2m/adfbrRr0tleNlkg=;
        b=p/5FgJ48ZFhBzLYzeO9F4L3B7m4ViZoWUQR4miaDO9q8W75DIebx34dn5ky65m111W
         BQbzbKsr3POWha6jTlwe9Pgs7ImCnhVM/0DbEvRcSDnDHiD2f2MjLvOyNfbZz9D4Lo7v
         QjrPfOdStTkmQzH0cti2SxlxROX9RmmzVrSwGaToJ/1DUakMxPSnZxOrWAfZPHqsYZXJ
         fXV5ZytEbiv2qvL9So5GAuapJD2J2Zb1acgB1wcaoNevJYO7KCt0ZgYb/9m37jandcz+
         hggwRIe78YVn+zXiHOM/eO3JpJajCsjIWRDEKnHgv3Lu6TZevE4iWGiVbRj4e3KOXsrd
         jlXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IF8hGJehe62RZyEGQomk3G52X2m/adfbrRr0tleNlkg=;
        b=DoA+J2MmZyGBnTF+2qG5qEas2L4M8xbtzc3hzI9naFckCpktp+RvopXLWR3um7lUf4
         3P8FkODIloCWP9zi0vW2OGteqibhRHrUYiFO5z6enfFzjb5wVgQ4kYRk6zy6uVbNN0Ah
         73MbzTV7dz3J1UsgiQYgmC8/u+FnX7cSwmHLVWWr5b4yofPQAdDmxiNAHhXi/ausk5lC
         BDoebgrYr4u5C1cCvHGRX4gLcGTB+63Kl6uW0RYhNC2NyaRUIm/mC1wBkqrEsN3jl5T4
         F7rRM4ZBrYVwkMYuHMqJgCP5gWdP5/Cxau13ozVh5Zhjn6MZRPRODD1YYf8EA3jeYAxM
         XOvg==
X-Gm-Message-State: APjAAAWmKNKmhKM1OLFTN5xJZk5c+EKKarGrKzoK8ns9bnQrsnHH3ATM
        uQEGMpohlDyZPycp/zx07xhAvQ==
X-Google-Smtp-Source: APXvYqyIHYVZf9GRIuCN4OywaBFJKL/aAXS4GlDMkU6KCuqNtTIhV/aw/Ozyre/1uGuacK/Vfqs7mg==
X-Received: by 2002:a17:902:bc86:: with SMTP id bb6mr2719674plb.199.1575341704574;
        Mon, 02 Dec 2019 18:55:04 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id z7sm959364pfk.41.2019.12.02.18.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 18:55:02 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: mark us with IORING_FEAT_SUBMIT_STABLE
Date:   Mon,  2 Dec 2019 19:54:44 -0700
Message-Id: <20191203025444.29344-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203025444.29344-1-axboe@kernel.dk>
References: <20191203025444.29344-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If this flag is set, applications can be certain that any data for
async offload has been consumed when the kernel has consumed the
SQE.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 3 ++-
 include/uapi/linux/io_uring.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d5cd338ac8bf..cc3bfa13a1f3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5063,7 +5063,8 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 	if (ret < 0)
 		goto err;
 
-	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP;
+	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
+			IORING_FEAT_SUBMIT_STABLE;
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;
 err:
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 4637ed1d9949..eabccb46edd1 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -157,6 +157,7 @@ struct io_uring_params {
  */
 #define IORING_FEAT_SINGLE_MMAP		(1U << 0)
 #define IORING_FEAT_NODROP		(1U << 1)
+#define IORING_FEAT_SUBMIT_STABLE	(1U << 2)
 
 /*
  * io_uring_register(2) opcodes and arguments
-- 
2.24.0

