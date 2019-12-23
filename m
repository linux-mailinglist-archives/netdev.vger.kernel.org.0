Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7479B12961A
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 13:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfLWMrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 07:47:22 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33610 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfLWMrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 07:47:22 -0500
Received: by mail-wm1-f67.google.com with SMTP id d139so14766041wmd.0
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 04:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=prOLnjsQ+6JaIxqvb62fUL29v+TbuhLP9zpbGVCMzRQ=;
        b=mLEBRLSq/OCZWdQI8qZC9lU2urW82j+NTYUKxLLlrmgqjS9w7le3DI3JryrhlkQFp1
         kRd651123O9AMz3MWNEPgqXlU5RofY+53SJ4MEd+2m3TEKIictbGROPOsoU19b+jsENl
         /+3QgpgJ6og6B0cBCln8FINq9ZNtJORMe2iGyPyqU4TpYBM8/D8nNqeISGtX++0pItMI
         Q4Y5ilvQE1TA8JQrcqo6p+ZlMhfA9Hf6h4EAYmnK3QsDbNn2K2eICsf5p79dRcA97JLB
         ibUOsZ93MnzUUOoX8rd3ovwRhuHHpQZhfzDH1/TPB6V/m1G0uyA8OVrRtLG10hR92+et
         jHag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=prOLnjsQ+6JaIxqvb62fUL29v+TbuhLP9zpbGVCMzRQ=;
        b=RC3S3v6JYNwLoiNdi1wuCqjczogCtja2TOfvcPzGzlRQnDKavt7vKsGQ8oUoDRWKJA
         WzRlprFd+QPRqcFCsdOuucQ+esNWBlhoV9woj3Z724VycYwg2DY5gxFrSAa/ibyTAIqG
         BvH+6VUiZHZqkaWHxyy6Ftz0Cn46xZOGvHOPltWw15xC6rj/Jvz952upyBtIxPvuq8JH
         9EIHceAr/aIVTeu4pCiSiiTMyWtk66g9gmbj+/x58x0LMELAqjEBly9xdRxjuEsB56Gj
         rcxaqIMRkKRebkgQ3XWKRt/8TlxCk2zRHIS3vJlcDZpm4ZkLzJ2c70iUf3ZPf3Yx4hEN
         h8iQ==
X-Gm-Message-State: APjAAAXQOZbTakOQ0zOqAO8Qhsc40Fxu8ANF4jY3ORAHdWDMb+ixAnFa
        jfJcOu+8Pg147d141mUBFFze88aw
X-Google-Smtp-Source: APXvYqya7L0i98j1TKiJxi4JMux0Z7CKUBI/pN41xnHEbY1TMgQIbO4nfwaZJjwYM2f/WTFod8g6yA==
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr30495351wmk.172.1577105239965;
        Mon, 23 Dec 2019 04:47:19 -0800 (PST)
Received: from peto-laptopnovy ([185.144.96.57])
        by smtp.gmail.com with ESMTPSA id x26sm18512581wmc.30.2019.12.23.04.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 04:47:19 -0800 (PST)
Date:   Mon, 23 Dec 2019 13:47:16 +0100
From:   Peter Junos <petoju@gmail.com>
To:     netdev@vger.kernel.org
Cc:     petoju@gmail.com
Subject: [PATCH] ss: use compact output for undetected screen width
Message-ID: <20191223124716.GA25816@peto-laptopnovy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change fixes calculation of width in case user pipes the output.

SS output output works correctly when stdout is a terminal. When one
pipes the output, it tries to use 80 or 160 columns. That adds a
line-break if user has terminal width of 100 chars and output is of
the similar width.

To reproduce the issue, call
ss | less
and see every other line empty if your screen is between 80 and 160
columns wide.

Signed-off-by: Peter Junos <petoju@gmail.com>
---
 misc/ss.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index 95f1d37a..dff1a618 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -1135,10 +1135,10 @@ static void buf_free_all(void)
 	buffer.chunks = 0;
 }
 
-/* Get current screen width, default to 80 columns if TIOCGWINSZ fails */
+/* Get current screen width, returns -1 if TIOCGWINSZ fails */
 static int render_screen_width(void)
 {
-	int width = 80;
+	int width = -1;
 
 	if (isatty(STDOUT_FILENO)) {
 		struct winsize w;
@@ -1159,7 +1159,13 @@ static int render_screen_width(void)
  */
 static void render_calc_width(void)
 {
+	bool compact_output = false;
 	int screen_width = render_screen_width();
+	if (screen_width == -1) {
+		screen_width = 80;
+		compact_output = true;
+	}
+
 	struct column *c, *eol = columns - 1;
 	int first, len = 0, linecols = 0;
 
@@ -1183,6 +1189,11 @@ static void render_calc_width(void)
 			first = 0;
 	}
 
+	if (compact_output) {
+		/* Compact output, skip extending columns. */
+		return;
+	}
+
 	/* Second pass: find out newlines and distribute available spacing */
 	for (c = columns; c - columns < COL_MAX; c++) {
 		int pad, spacing, rem, last;
-- 
2.24.0

