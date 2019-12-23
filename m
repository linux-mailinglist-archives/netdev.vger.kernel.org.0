Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A70CA12945B
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 11:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfLWKp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 05:45:57 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53887 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfLWKp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 05:45:57 -0500
Received: by mail-wm1-f66.google.com with SMTP id m24so15363926wmc.3
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 02:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=s/M5dijp2KwW7Hu0RJPMS2w1muNH7B/bYmEMje/jJAc=;
        b=OYip9Nmq3ceiWvcFgOR+obt+XeTNCW0Z64xeWYsh1HnU2S8i9aBepzaicRHVCOIofO
         38IvrKgcqNhvgRDH4POLplHnNPHl0flopwK4Fh2709PqgiMZlU+f8Xmjjy933F9TlhTP
         Hll2OM7R+uV7Wi9TXISWHZWJmXpQivGnhzOq964pE13CyeixZQZK4BZIulK3S5+RDAoV
         rZKFFk4CYID5uGA/zM5/37eFcNhkojxhehzUpQlzTtVQLM2TwHgCOzYUX9AriJPM/Bf1
         cqB159eoMNqfcQPVowZQeVEQaK47emksM+0FxR5WRGi5kRMlVSylogiVByeGe26m8hpe
         oV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=s/M5dijp2KwW7Hu0RJPMS2w1muNH7B/bYmEMje/jJAc=;
        b=QaALPV/mBEWiLyTyw5cplnHoePJ2yBEsPCkjyLZ9NX7/o/sDrZ2Umjh+oSdzOxsZMA
         5fK/yxD7zSMByn2QGSobLWjezY0DerUsP95KpuXj7NzhRjygWRq1h/Et5vaM23dLmB1D
         SoQ0V2Zn2/HaPTMHj8nWE835JAPY4e5AbyiFBofFBciZm/QaOorkQji+MZdzm9MDPLBm
         5UKrhrUCRvmV9oH9XLh8HKNlNqoU9uDLs/EG30HlUE1+SaZVmv+0O4lUbtn8wckHaGL4
         MakhtVRkjn3qAp2keSGxFToEnW//W4D9rissXbzZuLbhKZ6diEiQ+Jsv4k2jeYvUY52W
         EnQQ==
X-Gm-Message-State: APjAAAW44LIqdcJwQnuAv89wTCMElHvwDYvrTOa48KTTepbsSLg/o5KU
        nBMY8VUK9nFkoyTlY5Um3zjBEi5s
X-Google-Smtp-Source: APXvYqyyxMQYqeoVfcQH38nrB5ImFxIZ8CRBNKZXv1wYGUMSiI4K6hEyTqjdEjiYtSx0w1ESGfwoEA==
X-Received: by 2002:a1c:770e:: with SMTP id t14mr32632656wmi.101.1577097954984;
        Mon, 23 Dec 2019 02:45:54 -0800 (PST)
Received: from peto-laptopnovy ([185.144.96.57])
        by smtp.gmail.com with ESMTPSA id o7sm18468733wmh.11.2019.12.23.02.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 02:45:54 -0800 (PST)
Date:   Mon, 23 Dec 2019 11:45:52 +0100
From:   Peter Junos <petoju@gmail.com>
To:     netdev@vger.kernel.org
Cc:     petoju@gmail.com
Subject: [PATCH] ss: use compact output for undetected screen width
Message-ID: <20191223104552.GA16433@peto-laptopnovy>
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
---
 misc/ss.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index 95f1d37a..56d44f6b 100644
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
+		/* Terminal width couldn't be guessed, don't extend the output */
+		return;
+	}
+
 	/* Second pass: find out newlines and distribute available spacing */
 	for (c = columns; c - columns < COL_MAX; c++) {
 		int pad, spacing, rem, last;
-- 
2.24.0

