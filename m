Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3D036D922
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 16:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240142AbhD1OAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 10:00:48 -0400
Received: from foss.arm.com ([217.140.110.172]:43014 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240119AbhD1OAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 10:00:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5961211B3;
        Wed, 28 Apr 2021 07:00:02 -0700 (PDT)
Received: from entos-ampere-02.shanghai.arm.com (entos-ampere-02.shanghai.arm.com [10.169.214.110])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 65F353F694;
        Wed, 28 Apr 2021 06:59:56 -0700 (PDT)
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
Subject: [PATCH 4/4] lib/test_printf: Explicitly add components number to %pD and %pd
Date:   Wed, 28 Apr 2021 21:59:29 +0800
Message-Id: <20210428135929.27011-4-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210428135929.27011-1-justin.he@arm.com>
References: <20210428135929.27011-1-justin.he@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After changing the default components number from 1 to 4 for %pD
and %pd, it would be better to explicitly add the number in test_printf
cases.

Add a test case of %pd5 to verify if it can be capped by 4 components.

Signed-off-by: Jia He <justin.he@arm.com>
---
 lib/test_printf.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/test_printf.c b/lib/test_printf.c
index 27b964ec723d..899cd55d1c90 100644
--- a/lib/test_printf.c
+++ b/lib/test_printf.c
@@ -478,18 +478,20 @@ static struct dentry test_dentry[4] __initdata = {
 static void __init
 dentry(void)
 {
-	test("foo", "%pd", &test_dentry[0]);
+	test("foo", "%pd1", &test_dentry[0]);
 	test("foo", "%pd2", &test_dentry[0]);
 
-	test("(null)", "%pd", NULL);
-	test("(efault)", "%pd", PTR_INVALID);
-	test("(null)", "%pD", NULL);
-	test("(efault)", "%pD", PTR_INVALID);
+	test("(null)", "%pd1", NULL);
+	test("(efault)", "%pd1", PTR_INVALID);
+	test("(null)", "%pD1", NULL);
+	test("(efault)", "%pD1", PTR_INVALID);
 
-	test("romeo", "%pd", &test_dentry[3]);
+	test("romeo", "%pd1", &test_dentry[3]);
 	test("alfa/romeo", "%pd2", &test_dentry[3]);
 	test("bravo/alfa/romeo", "%pd3", &test_dentry[3]);
 	test("/bravo/alfa/romeo", "%pd4", &test_dentry[3]);
+	test("/bravo/alfa/romeo", "%pd", &test_dentry[3]);
+	test("/bravo/alfa/romeo", "%pd5", &test_dentry[3]);
 	test("/bravo/alfa", "%pd4", &test_dentry[2]);
 
 	test("bravo/alfa  |bravo/alfa  ", "%-12pd2|%*pd2", &test_dentry[2], -12, &test_dentry[2]);
-- 
2.17.1

