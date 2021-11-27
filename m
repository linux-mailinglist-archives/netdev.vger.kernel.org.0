Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2DE45FFF3
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 16:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355384AbhK0PuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 10:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349232AbhK0PsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 10:48:05 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107BCC061746;
        Sat, 27 Nov 2021 07:44:51 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso18449191otj.11;
        Sat, 27 Nov 2021 07:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lv/Kp6ESRC+AN4NQxCwaPZ0reLg9vm5QGJqQKdUOXVg=;
        b=d1d/8dbPRcDmnVpofqbwE5RzKqtuRjnKloIhHdZsx99LppSQdVXasmpMJASCqsxbRT
         B3K6GfXJnaZrUK+o+2E5IkLnKK35WR4CowCi4rxx/i3J81gijaVO1Y4SaHkyyP8kxfa4
         lDPkKUCtjO+vyWAl3Lwd9cFhtgDK7eqzYYeNngiUhpmYExX2Z1E3GyTcj5tsb7f1KCVL
         JQXtYICmtI81GSy7R7AMY/6QQs4NBqUwnrga9X48KwKIN9j0T8VuwJkrsWCf1PjJrq0r
         BVcN25uE9ymi625sKwJOSc5Mv/vtCf4BIekVhnrfSBHGeG51iBllPCslQEiZnp9N/RZ0
         kInQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Lv/Kp6ESRC+AN4NQxCwaPZ0reLg9vm5QGJqQKdUOXVg=;
        b=CX4JF17hXywbeeDkU2QxUV9sSP6EG3qfROmJhDCn8Oek1yWFML/uXCdJkIAYBlT75m
         8qSz6lbNfVZNoWUBnFWdiJqcKBq5vLHHs5Ah6OgQ1kZ44nShdoCRNyJCeylAbSVGlkXu
         gE5Jeswb8CnG79+S46wkBD8jlfe21+g0RNj16OmbCk+FDf040imQxPMzT8r7mMkNTD4e
         IAy84p6WVcHmgfEYp/Qinu5PQP1Mmk6sYKviQwo19qQ+CkmkxWssaq92Zh6fMinfrhm4
         /HYiSfawmpn+scQAjwyY2ib/u/kZ+oId1oVy4qAp+/sNV8FEyrFRRsFvoZg/nZO/QEGx
         jZwA==
X-Gm-Message-State: AOAM5313Q6ZQXmDhfmm2M58nr/4qPO9SyrPVLejmLnHmG2LhM2zDjvFR
        +zl/fyR9TQkdh4b7dva0RNmy8I4octc=
X-Google-Smtp-Source: ABdhPJz9alk4Sxe468wNHlmX+qYIK5Ar0oCeG8YckZefgGjtGwwcCC+vU/s+XoYduarsU12us77tnQ==
X-Received: by 2002:a9d:1b0f:: with SMTP id l15mr33791138otl.38.1638027890450;
        Sat, 27 Nov 2021 07:44:50 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r37sm1637094otv.54.2021.11.27.07.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 07:44:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Anton Altaparmakov <anton@tuxera.com>
Cc:     linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 2/3] fs: ntfs: Limit NTFS_RW to page sizes smaller than 64k
Date:   Sat, 27 Nov 2021 07:44:41 -0800
Message-Id: <20211127154442.3676290-3-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211127154442.3676290-1-linux@roeck-us.net>
References: <20211127154442.3676290-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NTFS_RW code allocates page size dependent arrays on the stack. This
results in build failures if the page size is 64k or larger.

fs/ntfs/aops.c: In function 'ntfs_write_mst_block':
fs/ntfs/aops.c:1311:1: error:
	the frame size of 2240 bytes is larger than 2048 bytes

Since commit f22969a66041 ("powerpc/64s: Default to 64K pages for 64 bit
book3s") this affects ppc:allmodconfig builds, but other architectures
supporting page sizes of 64k or larger are also affected.

Increasing the maximum frame size for affected architectures just to
silence this error does not really help. The frame size would have to be
set to a really large value for 256k pages. Also, a large frame size could
potentially result in stack overruns in this code and elsewhere and is
therefore not desirable. Make NTFS_RW dependent on page sizes smaller than
64k instead.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v3: Use generic configuration flag
v2: More comprehensive dependencies

 fs/ntfs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs/Kconfig b/fs/ntfs/Kconfig
index 1667a7e590d8..f93e69a61283 100644
--- a/fs/ntfs/Kconfig
+++ b/fs/ntfs/Kconfig
@@ -52,6 +52,7 @@ config NTFS_DEBUG
 config NTFS_RW
 	bool "NTFS write support"
 	depends on NTFS_FS
+	depends on PAGE_SIZE_LESS_THAN_64KB
 	help
 	  This enables the partial, but safe, write support in the NTFS driver.
 
-- 
2.33.0

