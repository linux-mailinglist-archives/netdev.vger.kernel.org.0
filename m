Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA941716EA
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 13:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389313AbfGWLZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 07:25:46 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:51795 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbfGWLZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 07:25:43 -0400
Received: by mail-wm1-f50.google.com with SMTP id 207so38148757wma.1
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 04:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+s7u9WUtpKpWAHO+LhS4I+88txqIVajZBlE+6bepC2Y=;
        b=Nb2Y3HA0cKYjrnBq3ZR2NqIan66GezCCtFbqi/9DuCxFG0Fd3HOHt0uuwp/Gx4CzZ3
         F2pvr1QGNeGpQIJH6Wt0HZtwSYAqr4WVEefvzxkjNKfzpc8zt1Dz6jY9hBKhTImV+ezG
         j+Nyt4dIrzV86cKL7DoTlioRK/qx72ulg70Y61jPeU2spTZyq9VVtiWd4PDigK/QDGju
         1C3X95EqAEug3ysJ/qq/DDBGK/E3wCDdErIt8QFYRNgzzPCjTqZoJMNADMWjHqsjOe9i
         nqC1lQLnIOCyE8BZy+whBZ9LJh85NaGq90R+S2pDPXFjW+zB7ofSNDgnFj2h4qT9woj1
         MwWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+s7u9WUtpKpWAHO+LhS4I+88txqIVajZBlE+6bepC2Y=;
        b=KZq8+sZMYLCwp2Ea6DiDGeBN27XGgUAnH4drYh5LC8U1OwaylQ30abDN5vmaEx8BUY
         Nw25N51MaRRxa0r7KgKA5UO5bF+KLZ/2xuCjQnm2cBJ1Qd/CdWPVGeYLcdxA1s3jhDA5
         yWyz6oAiKAUHXr5zp6xaN18REf5/k5ncUOcWKv5QplpeNVC0Z/iodHKvIWFumUhc7z2X
         eNB/ScCKd4J1YXVUwTVybTJVcijIF0NLTvQM8VeycknzPF/nXcDfhoAfWmJtFMzy5Udl
         o0mq9P2miVS+VA5w6+z+tvq2eD4GIgT5pbHnOT5NRqUOwSzYfiwgUz7s6DKL9Mgad8gZ
         QczA==
X-Gm-Message-State: APjAAAWCHtE/Yk7GRiak1T4dc1/0pJq2Rt66ahuP8I/kL7aoFoERLc/E
        qHIz1HX9nIONOYXZNEeDl651F3fF
X-Google-Smtp-Source: APXvYqy3nsJks/rbjF8fvLBul4yk/2GukAzQd8MAfVRJXxTbe+J5nbOAoFePrH0hzj2A6hcau1i+yQ==
X-Received: by 2002:a05:600c:2297:: with SMTP id 23mr16580179wmf.47.1563881142145;
        Tue, 23 Jul 2019 04:25:42 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id g19sm47484968wmg.10.2019.07.23.04.25.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 04:25:41 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com, alexanderk@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch iproute2 2/2] tc: batch: fix line/line_next processing in batch
Date:   Tue, 23 Jul 2019 13:25:38 +0200
Message-Id: <20190723112538.10977-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723112538.10977-1-jiri@resnulli.us>
References: <20190723112538.10977-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

When getcmdline fails, there is no valid string in line_next.
So change the flow and don't process it. Alongside with that,
free the previous line buffer and prevent memory leak.

Fixes: 485d0c6001c4 ("tc: Add batchsize feature for filter and actions")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 tc/tc.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/tc/tc.c b/tc/tc.c
index 64e342dd85bf..8abc82aedcf8 100644
--- a/tc/tc.c
+++ b/tc/tc.c
@@ -325,11 +325,10 @@ static int batch(const char *name)
 {
 	struct batch_buf *head = NULL, *tail = NULL, *buf_pool = NULL;
 	char *largv[100], *largv_next[100];
-	char *line, *line_next = NULL;
+	char *line = NULL, *line_next = NULL;
 	bool bs_enabled = false;
 	bool lastline = false;
 	int largc, largc_next;
-	bool bs_enabled_saved;
 	bool bs_enabled_next;
 	int batchsize = 0;
 	size_t len = 0;
@@ -360,11 +359,13 @@ static int batch(const char *name)
 	largc = makeargs(line, largv, 100);
 	bs_enabled = batchsize_enabled(largc, largv);
 	do {
-		if (getcmdline(&line_next, &len, stdin) == -1)
+		if (getcmdline(&line_next, &len, stdin) == -1) {
 			lastline = true;
-
-		largc_next = makeargs(line_next, largv_next, 100);
-		bs_enabled_next = batchsize_enabled(largc_next, largv_next);
+			bs_enabled_next = false;
+		} else {
+			largc_next = makeargs(line_next, largv_next, 100);
+			bs_enabled_next = batchsize_enabled(largc_next, largv_next);
+		}
 		if (bs_enabled) {
 			struct batch_buf *buf;
 
@@ -389,17 +390,8 @@ static int batch(const char *name)
 		else
 			send = true;
 
-		line = line_next;
-		line_next = NULL;
-		len = 0;
-		bs_enabled_saved = bs_enabled;
-		bs_enabled = bs_enabled_next;
-
-		if (largc == 0) {
-			largc = largc_next;
-			memcpy(largv, largv_next, largc * sizeof(char *));
-			continue;	/* blank line */
-		}
+		if (largc == 0)
+			goto to_next_line;	/* blank line */
 
 		err = do_cmd(largc, largv, tail == NULL ? NULL : tail->buf,
 			     tail == NULL ? 0 : sizeof(tail->buf));
@@ -411,10 +403,8 @@ static int batch(const char *name)
 			if (!force)
 				break;
 		}
-		largc = largc_next;
-		memcpy(largv, largv_next, largc * sizeof(char *));
 
-		if (send && bs_enabled_saved) {
+		if (send && bs_enabled) {
 			struct iovec *iov, *iovs;
 			struct batch_buf *buf;
 			struct nlmsghdr *n;
@@ -438,6 +428,18 @@ static int batch(const char *name)
 			}
 			batchsize = 0;
 		}
+
+to_next_line:
+		if (lastline)
+			continue;
+		free(line);
+		line = line_next;
+		line_next = NULL;
+		len = 0;
+		bs_enabled = bs_enabled_next;
+		largc = largc_next;
+		memcpy(largv, largv_next, largc * sizeof(char *));
+
 	} while (!lastline);
 
 	free_batch_bufs(&buf_pool);
-- 
2.21.0

