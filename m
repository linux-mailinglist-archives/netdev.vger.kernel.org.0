Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53F1B2A81
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 10:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfINIpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 04:45:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43735 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727565AbfINIpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 04:45:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id u72so16542074pgb.10;
        Sat, 14 Sep 2019 01:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=NTdUg0w3/tuA6uUITPahZY7hZDt+05gchQsrnaO5ujA=;
        b=Gx9sM3oJHRwI1npjk8ZNjbJE1nacoafTkX1Q2uOksVNKkzn07oS+kClzPTSC/BeY2O
         F88h7g+gJjMXvKgWwLo5yZe7ED3ITcsdPCssNtNw5b1Hm64tmb1ncKLckO6NPxtlYPVP
         21LPE9eZKvN/pFZzauBw50CGxxOIWsuvilS1WYGTGYAcWzPouiv5A+3hXEwoc82T8naQ
         WyXrPk/qwZ49Kxp1ZaswdaQX/ZgMW5+Q94UNdcFLpyV1/I/TDTXyLkZ63+I1tddBi1qw
         evAa/Pj8+gwLQqWj8AEExLGZNtwWKVXEEcacy95LSBBOfCKzV4IY0uM38htzrXjYOfIH
         ZVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=NTdUg0w3/tuA6uUITPahZY7hZDt+05gchQsrnaO5ujA=;
        b=Hz1EBG1MPM6kXAIuuv9+9JVbXi4h+Z49qbsG0jFrW8SWgIM1gtI/3/vj2T/re5aeRY
         1TiOQt1yr/iwg/QrU1+EBdYtVFdoAQLpcmbDHDFSJWemV3PBa/nbb4qB/pCmpZXoP8I7
         PC1I9UlrATtrJ7UxESLUruNpBtMV1rDiWjwMZu+sIS6vQx9E8yIkhOlobMayRDf41tpd
         FeEkRfHTp8cRpAZlsbBhR6dcIFIUBjEOArf7YIwmjm7yD6ZLyAzFgtOEzSdFO4EFMIXa
         ilj0jdNCFRZwtL+xlGHaLL85dvMmLglaYgcRHQ7SBy6c6wcQmYU3GL1s8clM9GbWCtE1
         Z4uw==
X-Gm-Message-State: APjAAAVx6XVVqxXd3nhZcQMfNpOWhIbsZ0XjfFfDpN69DmCKsRIqWvVY
        z0IDK2KQ3mX86Wa07a32UP0=
X-Google-Smtp-Source: APXvYqzHm8+A4QkqnIHJ0hQ4zT0L6uyARCgQdkDxIEAsYtshGzW9bBX2V69ODUHsrX1sHvF3cNPxLQ==
X-Received: by 2002:a65:57ca:: with SMTP id q10mr38486073pgr.52.1568450699321;
        Sat, 14 Sep 2019 01:44:59 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h66sm5110734pjb.0.2019.09.14.01.44.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Sep 2019 01:44:58 -0700 (PDT)
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] vhost: Fix compile time error
Date:   Sat, 14 Sep 2019 01:44:57 -0700
Message-Id: <1568450697-16775-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building vhost on 32-bit targets results in the following error.

drivers/vhost/vhost.c: In function 'translate_desc':
include/linux/compiler.h:549:38: error:
	call to '__compiletime_assert_1879' declared with attribute error:
	BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)

Fixes: a89db445fbd7 ("vhost: block speculation of translated descriptors")
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index acabf20b069e..102a0c877007 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2074,7 +2074,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 		_iov->iov_base = (void __user *)
 			((unsigned long)node->userspace_addr +
 			 array_index_nospec((unsigned long)(addr - node->start),
-					    node->size));
+					    (unsigned long)node->size));
 		s += size;
 		addr += size;
 		++ret;
-- 
2.7.4

