Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F7336D91A
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 16:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240100AbhD1OAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 10:00:40 -0400
Received: from foss.arm.com ([217.140.110.172]:42942 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240085AbhD1OAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 10:00:34 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 651B3ED1;
        Wed, 28 Apr 2021 06:59:49 -0700 (PDT)
Received: from entos-ampere-02.shanghai.arm.com (entos-ampere-02.shanghai.arm.com [10.169.214.110])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7279A3F694;
        Wed, 28 Apr 2021 06:59:43 -0700 (PDT)
From:   Jia He <justin.he@arm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Jia He <justin.he@arm.com>
Subject: [PATCH 2/4] lib/vsprintf.c: Make %p{D,d} mean as much components as possible
Date:   Wed, 28 Apr 2021 21:59:27 +0800
Message-Id: <20210428135929.27011-2-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210428135929.27011-1-justin.he@arm.com>
References: <20210428135929.27011-1-justin.he@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

We have '%pD'(no digit following) for printing a filename. It may not be
perfect (by default it only prints one component.

%pD4 should be more than good enough, but we should make plain "%pD" mean
"as much of the path that is reasonable" rather than "as few components as
possible" (ie 1).

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jia He <justin.he@arm.com>
---
 Documentation/core-api/printk-formats.rst | 3 ++-
 lib/vsprintf.c                            | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index 9be6de402cb9..aa76cbec0dae 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -413,7 +413,8 @@ dentry names
 For printing dentry name; if we race with :c:func:`d_move`, the name might
 be a mix of old and new ones, but it won't oops.  %pd dentry is a safer
 equivalent of %s dentry->d_name.name we used to use, %pd<n> prints ``n``
-last components.  %pD does the same thing for struct file.
+last components.  %pD does the same thing for struct file. By default, %p{D,d}
+is equal to %p{D,d}4.
 
 Passed by reference.
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 6c56c62fd9a5..5b563953f970 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -880,11 +880,11 @@ char *dentry_name(char *buf, char *end, const struct dentry *d, struct printf_sp
 	int i, n;
 
 	switch (fmt[1]) {
-		case '2': case '3': case '4':
+		case '1': case '2': case '3': case '4':
 			depth = fmt[1] - '0';
 			break;
 		default:
-			depth = 1;
+			depth = 4;
 	}
 
 	rcu_read_lock();
-- 
2.17.1

