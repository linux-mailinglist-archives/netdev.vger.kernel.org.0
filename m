Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523AC21A700
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgGIS0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgGIS0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:26:49 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E17EC08C5DD
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 11:26:49 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id e18so1330300pgn.7
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 11:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bbOsfemkppItMRL9baKJDrdeIT9dav/5vOG4sh+GTJw=;
        b=YU79DjoIN/w7y5TyqFO3ZzDnsrj2BCinthNc2lfzih0B5hSlbM9EPloRGc7GUGLZ0o
         6JCSijpWAwERecVO9M0iG7unm7ZYrZrnPJPNyO9Oco+db4Slc8o+2SvXhQzFecZDzV3x
         uE470OnBMx34GKCyElA8NXtqGTnzpolwAW8kQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bbOsfemkppItMRL9baKJDrdeIT9dav/5vOG4sh+GTJw=;
        b=LlrwuwHp2h0aS9G/2aWx4L7s2NFxS4S0gdgwzv6ciaUFcHtTVjnnmy44v4s99PTMRx
         pf7xsVXUjEBbAEmCOTsKHbaQjmawVJyegsq86i4LG15P432xgfAjucbFHjvah4hdh4Kc
         RigiYQFkcS3IkfTiz1/8pJTTzpQyYFS/Ljwr/e6EgW1b8J6hliNBNcys9YbKxG4G4hMv
         NfNN91Bn6SFI61yBWZt43WeBhMLwTraHZxWPWLKJ/AUPZ2NwBGvSVKsMDvgqlR1o5FiN
         u6l+npL+BHPRKXBTTGo6ke+Dg9jrdLCoZzZSS3CcKBdZd/PsKePLNemx9QsV5bfB17uS
         HhVQ==
X-Gm-Message-State: AOAM530pXybUKiqpiXmXMe6iUNaePjt7dgii4ynwZgjpk86PIdBWadl6
        RjYtOzp5H2JVigYkgWnT/aYI7Q==
X-Google-Smtp-Source: ABdhPJzltdn89rhN6XYfPiPOe4yMRQPDF/YkLsmF+9nfEb0qXub5V6RSRyXpBK142NIdo+LNFAx+Tw==
X-Received: by 2002:a63:9212:: with SMTP id o18mr37331988pgd.347.1594319208450;
        Thu, 09 Jul 2020 11:26:48 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h1sm3436654pgn.41.2020.07.09.11.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 11:26:47 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v7 2/9] pidfd: Add missing sock updates for pidfd_getfd()
Date:   Thu,  9 Jul 2020 11:26:35 -0700
Message-Id: <20200709182642.1773477-3-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709182642.1773477-1-keescook@chromium.org>
References: <20200709182642.1773477-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sock counting (sock_update_netprioidx() and sock_update_classid())
was missing from pidfd's implementation of received fd installation. Add
a call to the new __receive_sock() helper.

Cc: stable@vger.kernel.org
Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/pid.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index f1496b757162..85ed00abdc7c 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -42,6 +42,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/task.h>
 #include <linux/idr.h>
+#include <net/sock.h>
 
 struct pid init_struct_pid = {
 	.count		= REFCOUNT_INIT(1),
@@ -642,10 +643,12 @@ static int pidfd_getfd(struct pid *pid, int fd)
 	}
 
 	ret = get_unused_fd_flags(O_CLOEXEC);
-	if (ret < 0)
+	if (ret < 0) {
 		fput(file);
-	else
+	} else {
 		fd_install(ret, file);
+		__receive_sock(file);
+	}
 
 	return ret;
 }
-- 
2.25.1

