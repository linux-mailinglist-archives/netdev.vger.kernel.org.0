Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E6433CA8A
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 02:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbhCPBEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 21:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbhCPBEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 21:04:34 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75671C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:04:34 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id jx12so10870576pjb.1
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=oRaM6UIZrjG8k4wOQmOSoF0waV9YLP9Rb5WjnIs2lZ8=;
        b=fjg6hUnBQeP9xPq1otcoqnZdvnsunREEJdYk+0U+1dBskKkqYP77vU1dOEfqyTct5W
         JO87XTAJDQcNQywYIyNjNK1KXmZapt87YLHEIAsAb36lEUpgnR+qQf7VgHjQO/gVxatq
         PKKkHDXhGFYZaDzEYRJKbnOX6rDmL5zHcLJBqHv2IPqkJAXbgJp7RsAGpMBTCNp+X3FC
         sVfg0WFtLdoxzvn9GY4QQRRlzUlVINRmelna3l8uO9A+NbiUPCpxzmYh2N5V/8QgHSs7
         SxaJ7JlSB8YamKVjQm/AZXEohLQryC257s8R/s9Z9AAT2nSDSJ1yKx7D47Egb27ZJjR3
         9nPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=oRaM6UIZrjG8k4wOQmOSoF0waV9YLP9Rb5WjnIs2lZ8=;
        b=OxwzbrpjHUJwiqz4GurgUUPYa3L/QOyYDPMFVWNTozn3iQhOAkiSk6iJbC6Ggqdawx
         Bz+h9jPrcb4YFducxZt/GCzUxsbyKtix30o8xsSwFNN7boEUibBKWMhUf9+261M4Gdls
         2H4DOZkLEufOmT4t+O1m69TbQTUiKC03bXchBLbbHt+ZaqZrfVAQpN0N94FWellv5XaT
         p0hFzcbSbtoV9Gl1XcmCxFffaKm7wUI1QDc3WovC5UYCjz24dOabcSXpevmxAV2XwRfC
         SuaYWzQcC/T0Lz8Nv6Pb4ACsZmUSHbs+ivOSqVAqqSwYkS+Fa7j7lk0U0nYF1U3LPZY4
         mmPQ==
X-Gm-Message-State: AOAM530h2XB/3IXPddrRfK1Dc+IcwZCXP58jCg7lYw9jt9OxHJ/kA+Qr
        dRIlUoRAkBQFR0vtDTC/Sym67efINYQsJg==
X-Google-Smtp-Source: ABdhPJyOPhggUdPpuU51cG4FhyHrw4T78j2ZGEUwXW5VLODg7J/7BY8l31pvj8wReFbxJeg5pRiyKDoNP34smw==
X-Received: from xllamas.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:b1])
 (user=cmllamas job=sendgmr) by 2002:a17:90a:ff0f:: with SMTP id
 ce15mr1986741pjb.15.1615856673961; Mon, 15 Mar 2021 18:04:33 -0700 (PDT)
Date:   Tue, 16 Mar 2021 01:04:29 +0000
Message-Id: <20210316010429.624223-1-cmllamas@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH] selftests/net: fix warnings on reuseaddr_ports_exhausted
From:   Carlos Llamas <cmllamas@google.com>
To:     willemb@google.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Carlos Llamas <cmllamas@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix multiple warnings seen with gcc 10.2.1:
reuseaddr_ports_exhausted.c:32:41: warning: missing braces around initializer [-Wmissing-braces]
   32 | struct reuse_opts unreusable_opts[12] = {
      |                                         ^
   33 |  {0, 0, 0, 0},
      |   {   } {   }

Fixes: 7f204a7de8b0 ("selftests: net: Add SO_REUSEADDR test to check if 4-tuples are fully utilized.")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
 .../selftests/net/reuseaddr_ports_exhausted.c | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/net/reuseaddr_ports_exhausted.c b/tools/testing/selftests/net/reuseaddr_ports_exhausted.c
index 7b01b7c2ec10..066efd30e294 100644
--- a/tools/testing/selftests/net/reuseaddr_ports_exhausted.c
+++ b/tools/testing/selftests/net/reuseaddr_ports_exhausted.c
@@ -30,25 +30,25 @@ struct reuse_opts {
 };
 
 struct reuse_opts unreusable_opts[12] = {
-	{0, 0, 0, 0},
-	{0, 0, 0, 1},
-	{0, 0, 1, 0},
-	{0, 0, 1, 1},
-	{0, 1, 0, 0},
-	{0, 1, 0, 1},
-	{0, 1, 1, 0},
-	{0, 1, 1, 1},
-	{1, 0, 0, 0},
-	{1, 0, 0, 1},
-	{1, 0, 1, 0},
-	{1, 0, 1, 1},
+	{{0, 0}, {0, 0}},
+	{{0, 0}, {0, 1}},
+	{{0, 0}, {1, 0}},
+	{{0, 0}, {1, 1}},
+	{{0, 1}, {0, 0}},
+	{{0, 1}, {0, 1}},
+	{{0, 1}, {1, 0}},
+	{{0, 1}, {1, 1}},
+	{{1, 0}, {0, 0}},
+	{{1, 0}, {0, 1}},
+	{{1, 0}, {1, 0}},
+	{{1, 0}, {1, 1}},
 };
 
 struct reuse_opts reusable_opts[4] = {
-	{1, 1, 0, 0},
-	{1, 1, 0, 1},
-	{1, 1, 1, 0},
-	{1, 1, 1, 1},
+	{{1, 1}, {0, 0}},
+	{{1, 1}, {0, 1}},
+	{{1, 1}, {1, 0}},
+	{{1, 1}, {1, 1}},
 };
 
 int bind_port(struct __test_metadata *_metadata, int reuseaddr, int reuseport)
-- 
2.31.0.rc2.261.g7f71774620-goog

