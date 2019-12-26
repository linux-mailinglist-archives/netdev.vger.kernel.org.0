Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEA912AC51
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 14:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfLZNHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 08:07:15 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50529 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfLZNHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 08:07:14 -0500
Received: by mail-wm1-f67.google.com with SMTP id a5so5871175wmb.0
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 05:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=FBspn7Aor2cBYJpDf62etojNB2CCaprBvmHAP8ji9aU=;
        b=Z+Iz9ApoxRo4xxR0YHT2YGrD+0yzTx5xztyhHeCrxSfSTkUQyO3a/11EmyDCOyvv+Y
         zBdarFV6W99UTktCb6lDBVy/+9HHhmHilmWjoTUC+L28NtyTg7t1XrgDpRaSNjIwH7+p
         zpwEqqRGgkKtfmjG9K90riMiOraaieoI4Gdm5MX4VcMlzgV1n3lvGkoKa6uqTvrkU+7c
         5ahM/KA4aQ1k75whwdGqKN0vpmA8Z7NYGgfS9w2PE1TxrjbYcukLQYuqNyN6XXcusRU7
         zj3XGzjlhAPZadytzMsS4SOe0boHX6wkN7MDUzJFdVWGi4VyviqsIc3h5Yno8olB6dc8
         Tweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=FBspn7Aor2cBYJpDf62etojNB2CCaprBvmHAP8ji9aU=;
        b=sWHYSU1RX2ebkglEjtGLQxkd4iDRiRPLGtF+pXA/z5bh8tjgfRP84wf2UtZ7zUpjvr
         MrfXewArm98pmmAXuB3P1ShIVysGJR1A00KklaOkDQbXkiEsDMWERCE5GVbYKYRa2PZk
         QKI7xkC9DB76R+eX7Ax2E/I4ipAuJXhlDnp8alVeiprJOd1sAiYWkWHBT/obbTfQuEyj
         HSVuyDwH/uD459tVmw8YO6OWnAUqT6AzbvtrYteWA83R8v+U0v7avWiwZnjCL933xhCv
         D9LAmS6nrxTmS3U77TFyHk92hjmOZ1kqYOgLnSfuIOES5zAzgIm2vu/zfBFWxH2O77zc
         JvLw==
X-Gm-Message-State: APjAAAUbScaTleCt4lsnrGGT4/hW9yGj7caG3a7NhxhCohGHSniaa9Xa
        pZPEe1lRFhVM+rYop+yoYXT9BBWx1p8=
X-Google-Smtp-Source: APXvYqwwozQKOa3iKGwzNdSZfRoLmY/S5FvYFrMqnCRLmOzM2Q99KWTHTEGYmNEEmXjyvKEXulmV9A==
X-Received: by 2002:a1c:7d93:: with SMTP id y141mr14583150wmc.111.1577365632509;
        Thu, 26 Dec 2019 05:07:12 -0800 (PST)
Received: from peto-laptopnovy ([185.144.96.57])
        by smtp.gmail.com with ESMTPSA id b67sm8525596wmc.38.2019.12.26.05.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 05:07:12 -0800 (PST)
Date:   Thu, 26 Dec 2019 14:07:09 +0100
From:   Peter Junos <petoju@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Peter Junos <petoju@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH net-next] ss: use compact output for undetected screen width
Message-ID: <20191226130709.GA29733@peto-laptopnovy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191225123607.38be4bdc@hermes.lan>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change fixes calculation of width in case user pipes the output.

SS output output works correctly when stdout is a terminal. When one
pipes the output, it tries to use 80 or 160 columns. That adds a
line-break if user has terminal width of 100 chars and output is of
the similar width. No width is assumed here.

To reproduce the issue, call
ss | less
and see every other line empty if your screen is between 80 and 160
columns wide.

This second version of the patch fixes screen_width being set to arbitrary
value.

Signed-off-by: Peter Junos <petoju@gmail.com>
---
 misc/ss.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index 95f1d37a..d5bae16d 100644
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
@@ -1159,9 +1159,15 @@ static int render_screen_width(void)
  */
 static void render_calc_width(void)
 {
-	int screen_width = render_screen_width();
+	int screen_width, first, len = 0, linecols = 0;
+	bool compact_output = false;
 	struct column *c, *eol = columns - 1;
-	int first, len = 0, linecols = 0;
+
+	screen_width = render_screen_width();
+	if (screen_width == -1) {
+		screen_width = INT_MAX;
+		compact_output = true;
+	}
 
 	/* First pass: set width for each column to measured content length */
 	for (first = 1, c = columns; c - columns < COL_MAX; c++) {
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

