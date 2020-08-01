Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3212352C9
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 16:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgHAOkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 10:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgHAOkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 10:40:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F0BC06174A
        for <netdev@vger.kernel.org>; Sat,  1 Aug 2020 07:40:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k1sg6-0006xu-5P; Sat, 01 Aug 2020 16:40:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Subject: [PATCH net-next] mptcp: fix syncookie build error on UP
Date:   Sat,  1 Aug 2020 16:39:59 +0200
Message-Id: <20200801143959.211300-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel test robot says:
net/mptcp/syncookies.c: In function 'mptcp_join_cookie_init':
include/linux/kernel.h:47:38: warning: division by zero [-Wdiv-by-zero]
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))

I forgot that spinock_t size is 0 on UP, so ARRAY_SIZE cannot be used.

Fixes: 9466a1ccebbe54 ("mptcp: enable JOIN requests even if cookies are in use")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/syncookies.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mptcp/syncookies.c b/net/mptcp/syncookies.c
index 6eb992789b50..abe0fd099746 100644
--- a/net/mptcp/syncookies.c
+++ b/net/mptcp/syncookies.c
@@ -125,8 +125,6 @@ void __init mptcp_join_cookie_init(void)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(join_entry_locks); i++)
+	for (i = 0; i < COOKIE_JOIN_SLOTS; i++)
 		spin_lock_init(&join_entry_locks[i]);
-
-	BUILD_BUG_ON(ARRAY_SIZE(join_entry_locks) != ARRAY_SIZE(join_entries));
 }
-- 
2.26.2

