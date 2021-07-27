Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132143D8000
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbhG0U7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhG0U7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:59:20 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA40CC06119A
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:11 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c16so11885612plh.7
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A8VL5uTwi2ok0xQG2fExEpX5b43uBzp5tHuj3L/R+N0=;
        b=MuVA98uzyFghrpeCefbkYMobO8SHDZI2jc808l40HzcktA/z0DyZWg3UUrPxY2jQTx
         1ed5PTEGwVLj+gUQNU9VV6/Wlgw5nfs0KfrxNrYxZJIzih6b5CYNoj6jQnfqqe/aF7CG
         Kag8EJWSgFoDxhRz+uHbAHJSq3YzIYRwaQERY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A8VL5uTwi2ok0xQG2fExEpX5b43uBzp5tHuj3L/R+N0=;
        b=MBDsMm6pSLgM7dCQ9uLyB9GvBBbmHR3beBmmoxJrurO1THaPhwuDR9+unNjC2huC00
         gA5NxiFeQqndc7297qKCl8tMLMB1ZIh+XNJ3Klbxmnkh3xMAtjZk+ObqxFX7x3W+OKPC
         rVgnKQeibfA/hap2mSpx7HtsrP32kF6sr/XMEq76u+EJ0Bu2f/luMIVLao5jJ6WPYVoY
         /stA1PyzSAJBB4QJfDxKsucHP9Kj6OSa6BP3iteOHQ9RRxRD51Ps3vL+01GVkzHGvbGx
         9LG2dB6V/hG9XOWd8EPTWzAvuaRwX2U/vs+svyKA7G4j91Fwntai12Q/03FsNTzax04T
         vbHg==
X-Gm-Message-State: AOAM531SpWAtan6DvQzsZ3QgYQ186FPJZRaLYqQ337ipoRBUFwdVzwRI
        Jcsb7+PWx/i8WVigITiwlVnX7g==
X-Google-Smtp-Source: ABdhPJwK/hlVX3ijEELPaVNGs5CqZ9MYVDpKWehXzD8lK279R3qnfEziD46RtfTuI5da/TZ/A7j89A==
X-Received: by 2002:a17:90a:1196:: with SMTP id e22mr5942936pja.168.1627419551358;
        Tue, 27 Jul 2021 13:59:11 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h18sm3550930pjv.21.2021.07.27.13.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:11 -0700 (PDT)
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
Subject: [PATCH 27/64] HID: cp2112: Use struct_group() for memcpy() region
Date:   Tue, 27 Jul 2021 13:58:18 -0700
Message-Id: <20210727205855.411487-28-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2121; h=from:subject; bh=K97nJ7xl1U2miGBKe3f4iGnBB6d79/ydjDfoar50c1k=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOGJiERxKe5UaB/DWAoZsHfj6ZstGRywspA5cbo qbU/Sa2JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzhgAKCRCJcvTf3G3AJviXD/ 0awF1xyojK4bdkGTsWWYC5EaCkxQXolbhn5I4Bt5LTgBerDVUkkQ+0hbx3KTd6J1shKe33O721L80q ZPSzA6XO1IU4jEh9ESD0vy/BbcwUB240/GjH7pokMgs1tY/ASfazVm5pEoVQ2XMbM9ttTkxD6cKwl2 wD3CaaTKSXRB54J1wY/RbfKchhBz/awcZEkaPX+V5MH128VNgQWftdwl6k4zkukMyTgQqqtcQEDxLG 2PXGR01tGWiZG4zcq6j0qKS9hF+YMV3vNRTD11FlkXkpCJa/stjQqYc3X+5SMk4CRzfl/Y8cOb2ori taM7ib/LTTXf/XdYjP8mkve4OB2F547uGMmQY02c0e401LtZTJR+BdjWQtnzweLMCU7bZWFnvUt/RI 4cqv3FXHI7G3rsq/9s9nQOPzyX1g6CKdhXSGgnS6F75W6n3LHmhYa9TRe7Q9yzYq+fQMiHisjUkftb iTEIUCDgO5rrzjGJ+PX3mtU2ZT4MbYy9wphEFnW76pP0WmYvf85gMWFUBXxjM3D3zkrPguys6E4LcZ Otlv5886DjdrIVDbh5s3k6JVcDviF5vEmyocVX7Gu/d9l7lhKm805IufyFMpTdxERMUq7Hv4ROE4Ex QkBYn0Udw21OjJBLXDJldGRan/1A1k6mjEOu8Q1mHNN3JiXDko0nT/TA1CHQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() in struct cp2112_string_report around members report,
length, type, and string, so they can be referenced together. This will
allow memcpy() and sizeof() to more easily reason about sizes, improve
readability, and avoid future warnings about writing beyond the end of
report.

"pahole" shows no size nor member offset changes to struct
cp2112_string_report.  "objdump -d" shows no meaningful object
code changes (i.e. only source line number induced differences.)

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/hid/hid-cp2112.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 477baa30889c..e6ee453c7cfc 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -129,10 +129,12 @@ struct cp2112_xfer_status_report {
 
 struct cp2112_string_report {
 	u8 dummy;		/* force .string to be aligned */
-	u8 report;		/* CP2112_*_STRING */
-	u8 length;		/* length in bytes of everyting after .report */
-	u8 type;		/* USB_DT_STRING */
-	wchar_t string[30];	/* UTF16_LITTLE_ENDIAN string */
+	struct_group_attr(contents, __packed,
+		u8 report;		/* CP2112_*_STRING */
+		u8 length;		/* length in bytes of everyting after .report */
+		u8 type;		/* USB_DT_STRING */
+		wchar_t string[30];	/* UTF16_LITTLE_ENDIAN string */
+	);
 } __packed;
 
 /* Number of times to request transfer status before giving up waiting for a
@@ -986,8 +988,8 @@ static ssize_t pstr_show(struct device *kdev,
 	u8 length;
 	int ret;
 
-	ret = cp2112_hid_get(hdev, attr->report, &report.report,
-			     sizeof(report) - 1, HID_FEATURE_REPORT);
+	ret = cp2112_hid_get(hdev, attr->report, (u8 *)&report.contents,
+			     sizeof(report.contents), HID_FEATURE_REPORT);
 	if (ret < 3) {
 		hid_err(hdev, "error reading %s string: %d\n", kattr->attr.name,
 			ret);
-- 
2.30.2

