Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357DF481ED8
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241540AbhL3Rws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236799AbhL3Rwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 12:52:46 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C930C061574;
        Thu, 30 Dec 2021 09:52:46 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id m15so22008411pgu.11;
        Thu, 30 Dec 2021 09:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e7GlyC/Fs2J3RuyS0dBbpj6BB6+RlGoWJj21CeQljQI=;
        b=A5Ku1BpR0ZdzS0wG5MHTg3zWenyjD0JQfpljo4xouQPmUsVbP2YZMXxxtgIpJN6ebG
         kNZcaIJ2AwUKaZH/kBEA2TWs/lr4GjaenzWa7nWMHkxbumqf/S3pnM3Rpp2HSwyDFJ4k
         pBXjNSTqRK+WMb13ro2I77titwJntUKBRD0g/WovL3d0DltQ+VglL06baZAax4yH6mxp
         XxmXAWxmEK5yXnQN6OdU+qEhkefrQwCO7SO75aM3EQq6l5D9baQHw7nDm0IS+2ZHSu3R
         o2GPZcm3HeA7ptyq9jHtWodN7I49tRGFtptljt/MWTuD17Z4eZM+srvIn2WGHzS608qz
         sF8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e7GlyC/Fs2J3RuyS0dBbpj6BB6+RlGoWJj21CeQljQI=;
        b=JC5jCrnpFSCSX8E0nfguvHl6TKRzqrnd9VVCgT5AeR68EObnsCwB0n4vc8GnBDIskG
         kSwKiVOdmcvaOqKpk75o50xAn4Cz3ChNYjId/vMgolU+LWV94oalgJWkI3424PRbcf53
         N/LMwa48AAmlW+tDe0lKTSrSv/QOGSke54xzvB4BMHSnGU15BjUzHG0ICBZQPf72ll5E
         mr1tzGoIUDdL7z5fLtuN+dnkTBtqQfiDNezxMgegduedEvDXtxrY90dl3XvCyTB2MyT1
         Q/KOuxVy27u6KAnDvQ6dKdq7fRJcSL1SbEXaKqGul27gJFUcP427AckJQP26QWsf3jZq
         TKdQ==
X-Gm-Message-State: AOAM53027PJIqOBs3hOaeJAjSSpTKn9I9MxRW9mkov/5z+kyINav8UQJ
        OLfI/xaNchsUr2zuPjUE958=
X-Google-Smtp-Source: ABdhPJyXvyj3WVCZeYkdQW+c1256QWbj6+k0RymutC3+rKyKWidnoS6KBDSVTvfDmWeYbJJOayj+1Q==
X-Received: by 2002:a63:904b:: with SMTP id a72mr28157164pge.28.1640886766213;
        Thu, 30 Dec 2021 09:52:46 -0800 (PST)
Received: from integral2.. ([180.254.126.2])
        by smtp.gmail.com with ESMTPSA id 185sm9244188pfe.26.2021.12.30.09.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 09:52:45 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Nugra <richiisei@gmail.com>
Subject: [RFC PATCH v3 2/3] net: Make `move_addr_to_user()` be a non static function
Date:   Fri, 31 Dec 2021 00:52:31 +0700
Message-Id: <20211230173126.174350-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230173126.174350-1-ammar.faizi@intel.com>
References: <20211230115057.139187-3-ammar.faizi@intel.com>
 <20211230173126.174350-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to add recvfrom support for io_uring, we need to call
`move_addr_to_user()` in fs/io_uring.c.

This makes `move_addr_to_user()` be a non static function so we can
call it from io_uring.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Nugra <richiisei@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---

v3:
  * No changes *

v2:
  - Added Nugra to CC list (tester).
---
 include/linux/socket.h | 2 ++
 net/socket.c           | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 8ef26d89ef49..0d0bc1ace50c 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -371,6 +371,8 @@ struct ucred {
 #define IPX_TYPE	1
 
 extern int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *kaddr);
+extern int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
+			     void __user *uaddr, int __user *ulen);
 extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 
 struct timespec64;
diff --git a/net/socket.c b/net/socket.c
index 7f64a6eccf63..af521d351c8a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -267,8 +267,8 @@ int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *k
  *	specified. Zero is returned for a success.
  */
 
-static int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
-			     void __user *uaddr, int __user *ulen)
+int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
+		      void __user *uaddr, int __user *ulen)
 {
 	int err;
 	int len;
-- 
2.32.0

