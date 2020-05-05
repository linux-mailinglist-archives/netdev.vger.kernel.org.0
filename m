Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1266E1C5B90
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgEEPhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729561AbgEEPhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 11:37:47 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D935EC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 08:37:46 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id q43so2079238qtj.11
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 08:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6XH0FPT08YBoUx+mfK4TeZ+oCrUvAXy0ysNUHVi9yfY=;
        b=V4lu4DOohkEbU/ygGOhKvQ5skq0xGYACi2bYX+2rJikgFeHm1c6nANeCfPkHDGG82P
         29omG+HlqmzrezTYL7DvLbxGXstOzFYkTN0K89KNsUfR0l42C0LiIVGhuXGTH2zxQcV5
         Tx8fN2fgcHXRtABfxzoHXf+ixWdGRb6bWmWIc88lzTAKaCRtYs22jA9u6CzGsrqXHYyq
         2zBuKu3AhNqi6i/EtvzEins272cMEbPkRTLRGczFM+do0CGpqvqjGncDhlp/2RYiyb2H
         2WNc/bw5HDan7UIqxpg6Thi38c/6QV/yBbwPlsbkIdkJIIyuqueCPci8isnReOpXEBNc
         72Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6XH0FPT08YBoUx+mfK4TeZ+oCrUvAXy0ysNUHVi9yfY=;
        b=fPgC3J5OTqT/hQYwu2dUQodlmMkwzwZkEENeqSsgjmE2Pql15vil/3AuMe0LeGpDER
         VwDcA/nXoKC/TSrng7D5bMbyvXtxWLSNkWY9fSojPPQBYLsw7dc310GpUlU8Wy5LWPcd
         ngUJinHUKKE7wfcFtq+GevTut/otDBhO3/RR3Vb3kyAW5PDvHcchfE/LIjnH92/Tbhge
         xRnfvy8Wv9Pjy1Xa3Cr3pxgYmU1U+0I7OOA1hDPgUffrWubAIAqRC4it0+d9kMthaWNv
         k8NXZd9t+MhBbDNog8HEVk9P5lFKJKHrwi7YMAdeoINFSQHLUzh9q5dX7mm+tIZWRWlN
         UjZA==
X-Gm-Message-State: AGi0PubZavx1xRnNkrccLVRoGZJHrEOYpvEFPRIoxaL4AUEzoff1hHyY
        dTeuKtSDEh1RoxEBLKk/DceEYs+7e5PPdQ==
X-Google-Smtp-Source: APiQypKox1e7l+91oxCJzNRNLS2Iz4JvcwylazpIeYqgWziOLrFGkz3eC9+OnVZLSKgjUYZHzCrqQQOpbldpYg==
X-Received: by 2002:a05:6214:1702:: with SMTP id db2mr3338445qvb.201.1588693065830;
 Tue, 05 May 2020 08:37:45 -0700 (PDT)
Date:   Tue,  5 May 2020 08:37:41 -0700
Message-Id: <20200505153741.223354-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH iproute2] ss: add support for Gbit speeds in sprint_bw()
From:   Eric Dumazet <edumazet@google.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also use 'g' specifier instead of 'f' to remove trailing zeros,
and increase precision.

Examples of output :
 Before        After
 8.0Kbps       8Kbps
 9.9Mbps       9.92Mbps
 55001Mbps     55Gbps

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 misc/ss.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index 3ef151fbf1f1b3856e95a1baa751a1cdd27d10b7..ab206b2011ec92b899709d2c78ce7310e88ec80e 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -2382,10 +2382,12 @@ static char *sprint_bw(char *buf, double bw)
 {
 	if (numeric)
 		sprintf(buf, "%.0f", bw);
-	else if (bw > 1000000.)
-		sprintf(buf, "%.1fM", bw / 1000000.);
-	else if (bw > 1000.)
-		sprintf(buf, "%.1fK", bw / 1000.);
+	else if (bw >= 1e9)
+		sprintf(buf, "%.3gG", bw / 1e9);
+	else if (bw >= 1e6)
+		sprintf(buf, "%.3gM", bw / 1e6);
+	else if (bw >= 1e3)
+		sprintf(buf, "%.3gK", bw / 1e3);
 	else
 		sprintf(buf, "%g", bw);
 
-- 
2.26.2.526.g744177e7f7-goog

