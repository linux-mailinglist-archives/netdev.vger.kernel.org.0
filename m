Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA7F67FF80
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 19:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404771AbfHBRXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 13:23:48 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41448 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404689AbfHBRXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 13:23:48 -0400
Received: by mail-pf1-f196.google.com with SMTP id m30so36374100pff.8;
        Fri, 02 Aug 2019 10:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G0Rs3THwc2fJIRTGW9lnGtwokdpe+/s8nQ6H1nWRA2c=;
        b=icjR+pRrZARh3oCsHTKiYoHsaoI/8xcNb4lVf8tHXk1wqjIKAPoWXUsJTVrS+F2yf7
         Wh+ZgjaU/NWqDLPUZiozCSbA+dSbjAIGbM7hcxduh8zwR5aYrE0KyF2ULpt7WFplAuAp
         NyyDFz6nP/zxYREK4zabdxCLCDiVWGuk46ujqQ9jeLcLal76+XUwgJ1jDMYdlOfOxO0B
         OzQ7BGS4nBaU5tqKs/eFvavKGK7cbPDyPA4eaSKzdugcJWkN2osjIYi7YZysDCsAPAnI
         oOvSGvgnkA9PihLwFaobCOvVEWmvxxgaBsdvnXtK4cLYJyk9eGilbO+0kN2+V7WWEpJl
         sstw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G0Rs3THwc2fJIRTGW9lnGtwokdpe+/s8nQ6H1nWRA2c=;
        b=Hd3ls37sY0Th+5aNWZf/N54olafXY6tpeN/Bkuae7cjCvMJqRUW0fgsFUoe1UYowNO
         UBkt4SAQmRkRXaxlIlc8HoP+FuVtPxxtSydPx6JJULw53w+d+P7i4Hl+f3tUWdQm3nPA
         3uCtGfucflr+8qkpaS8P0JNtLW6GP1t0rRW0d628Uvjg3chS25a3P4eRi5s3CRD/85E0
         YAQabn78OOx+IqqRYKq9M/mjCFM5tVQdqI8Y9X95LvzbSKKoD4etD3uaX6FYcAVfcqFf
         Bxo3iVGKBhKklP+yM+Y7JtI7IzzgeEQ+Js2HG/13FLydEd5UYNEBr4FLJPMzPLWADv8z
         9mLg==
X-Gm-Message-State: APjAAAW9ppGo0Wc+YztMhx0es1qFH4r2uGtrZsNzq7oxUdz+4jTiJQvE
        fgmHMhknRkV+fDkezMkbhUU=
X-Google-Smtp-Source: APXvYqz+tOW1S82r3Kx1+qBEPTj94XvDzGbloKU8HUJh0kqLYoqOQ/FB+cp71Tu6WWNAoWb1Iy07Zw==
X-Received: by 2002:a65:6546:: with SMTP id a6mr72342957pgw.220.1564766627142;
        Fri, 02 Aug 2019 10:23:47 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id f32sm12295921pgb.21.2019.08.02.10.23.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 10:23:46 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2 1/3] mlx5: Use refcount_t for refcount
Date:   Sat,  3 Aug 2019 01:23:41 +0800
Message-Id: <20190802172341.8359-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t is better for reference counters since its
implementation can prevent overflows.
So convert atomic_t ref counters to refcount_t.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v2:
  - Add #include.

 include/linux/mlx5/driver.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 0e6da1840c7d..5b56f343ce87 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -47,6 +47,7 @@
 #include <linux/interrupt.h>
 #include <linux/idr.h>
 #include <linux/notifier.h>
+#include <linux/refcount.h>
 
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/doorbell.h>
@@ -398,7 +399,7 @@ enum mlx5_res_type {
 
 struct mlx5_core_rsc_common {
 	enum mlx5_res_type	res;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct completion	free;
 };
 
-- 
2.20.1

