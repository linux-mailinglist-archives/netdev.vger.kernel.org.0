Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF3B4A55E9
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 05:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbiBAE2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 23:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbiBAE2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 23:28:23 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EE2C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 20:28:23 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id z14-20020a17090ab10e00b001b6175d4040so1435909pjq.0
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 20:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g+QlftrcaXfoEEpJhh1t78sHHpIFJnjZ0IbJpz4Ch7Y=;
        b=lT0i5q3ii0Nr5lJgP+ZL9zoyNWzc1ldlWtnmwQBt1NuPqYh0H8uzKdJ7J3QqStu2xo
         MlfTc8IBgRk3j/Xsn+QfHC8Gl5SozgfTBNn+gu8CYq8GGEp1ITBRKmpf/kGIrehxgpVy
         ASJTDnqEeIVhgZwZB9awPkl+jZQZONoiDG6gG/TWLeNn8bXNllDR2l1URYGtPmSGXLhl
         hYoTJVJg4IwnjIxLWnWJJM0nkiK/ptqDqF7mmT3k3DVIRrPVhxL1f7rNNZuEMTeySzqq
         ZatwHlKwSnrriFV1kCNAcq+jaguWlSS3QacRQdMJB3nOgGHbZSp+TOkr5FZaA1QgS5N0
         4R9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g+QlftrcaXfoEEpJhh1t78sHHpIFJnjZ0IbJpz4Ch7Y=;
        b=kH2dYPPlAfQpTFr3A5gPGeeH/W7S7gdu4oBYIt6bFz5+LTwwSUQ3jvKTwd1wmJGsbd
         qHYSDkAcQDlb708iNkr26hwpf44UKWs3li2+wY5mwUw5Fdci5yQVEFguNlTX+od/uQLX
         tctoHUBO4kiN92kL3bGdgmhxdz+V9vbyGkb6Q5rbYmxZd/QhJvPNX/jd+UY6ddiJcnEK
         RCLVh22yqYTrVizHPED0qOm11c4h9bAzMZ05LVyGv/JD3rkmI5kJtltp4ojA+Uf7f2D7
         HvF9Af+BQk42LICewqFPwJhQTpYwYrohfifr3DGizB0i1dlpx7P+9JY3AAfkK/xfqRn+
         nhbQ==
X-Gm-Message-State: AOAM533R2bDLSYr2m7K2GrIfTThz61KsAaY/Yjohw8r3Dohd1w4MFUBl
        tYNi7K2xFOZl9A3a2THtA7rDLg==
X-Google-Smtp-Source: ABdhPJwG+bFt51qvRhkS7o3hWO07JoYabSANgVn81zoKHdO+pBJTKg3eqURSr084YMpi/Lboggk1+g==
X-Received: by 2002:a17:90a:d188:: with SMTP id fu8mr267471pjb.60.1643689703230;
        Mon, 31 Jan 2022 20:28:23 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id l8sm20441335pfc.187.2022.01.31.20.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 20:28:22 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, Victor Nogueira <victor@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 1/2] tc_util: fix breakage from clang changes
Date:   Mon, 31 Jan 2022 20:28:18 -0800
Message-Id: <20220201042819.322106-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CA+NMeC-uzWxn182SfF57e7xjXUdLmJV7fV0VN2a681LCh95R5g@mail.gmail.com>
References: <CA+NMeC-uzWxn182SfF57e7xjXUdLmJV7fV0VN2a681LCh95R5g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes the indentation of types with newline flag.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
The clang changes merged an earlier version of the changes
to print_masked_type.

 tc/tc_util.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 67960d2c03d7..78cb9901f7b9 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -784,8 +784,6 @@ static void print_masked_type(__u32 type_max,
 			      struct rtattr *mask_attr, bool newline)
 {
 	__u32 value, mask;
-	SPRINT_BUF(out);
-	size_t done;
 
 	if (!attr)
 		return;
@@ -793,21 +791,18 @@ static void print_masked_type(__u32 type_max,
 	value = rta_getattr_type(attr);
 	mask = mask_attr ? rta_getattr_type(mask_attr) : type_max;
 
-	if (is_json_context()) {
-		print_hu(PRINT_JSON, name, NULL, value);
-		if (mask != type_max) {
-			char mask_name[SPRINT_BSIZE-6];
+	if (newline)
+		print_string(PRINT_FP, NULL, "%s  ", _SL_);
+	else
+		print_string(PRINT_FP, NULL, " ", _SL_);
 
-			sprintf(mask_name, "%s_mask", name);
-			print_hu(PRINT_JSON, mask_name, NULL, mask);
-		}
-	} else {
-		done = sprintf(out, "%u", value);
-		if (mask != type_max)
-			sprintf(out + done, "/0x%x", mask);
+	print_uint_name_value(name, value);
+
+	if (mask != type_max) {
+		char mask_name[SPRINT_BSIZE-6];
 
-		print_nl();
-		print_string_name_value(name, out);
+		snprintf(mask_name, sizeof(mask_name), "%s_mask", name);
+		print_hex(PRINT_ANY, mask_name, "/0x%x", mask);
 	}
 }
 
-- 
2.34.1

