Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E23D2E101D
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 23:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgLVWYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 17:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgLVWYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 17:24:45 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3A0C0613D6;
        Tue, 22 Dec 2020 14:24:04 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1krq4Z-0001tv-6e; Tue, 22 Dec 2020 23:24:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     <netdev@vger.kernel.org>, torvalds@linux-foundation.org,
        syzkaller-bugs@googlegroups.com, Florian Westphal <fw@strlen.de>,
        syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: xt_RATEEST: reject non-null terminated string from userspace
Date:   Tue, 22 Dec 2020 23:23:56 +0100
Message-Id: <20201222222356.22645-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <000000000000fcbe0705b70e9bd9@google.com>
References: <000000000000fcbe0705b70e9bd9@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reports:
detected buffer overflow in strlen
[..]
Call Trace:
 strlen include/linux/string.h:325 [inline]
 strlcpy include/linux/string.h:348 [inline]
 xt_rateest_tg_checkentry+0x2a5/0x6b0 net/netfilter/xt_RATEEST.c:143

strlcpy assumes src is a c-string. Check info->name before its used.

Reported-by: syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com
Fixes: 5859034d7eb8793 ("[NETFILTER]: x_tables: add RATEEST target")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
RATEEST test in iptables.git still passes, syzbot repro setsockopt
fails with -ENAMETOOLONG.

diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 37253d399c6b..0d5c422f8745 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -115,6 +115,9 @@ static int xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 	} cfg;
 	int ret;
 
+	if (strnlen(info->name, sizeof(est->name)) >= sizeof(est->name))
+		return -ENAMETOOLONG;
+
 	net_get_random_once(&jhash_rnd, sizeof(jhash_rnd));
 
 	mutex_lock(&xn->hash_lock);
-- 
2.26.2

