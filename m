Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340843C3BBD
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 13:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhGKLSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 07:18:41 -0400
Received: from relay.sw.ru ([185.231.240.75]:45140 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231567AbhGKLSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 07:18:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=3uBNSL0vsw2lEeuOeCoTXZlYVr6b6XiO//eBDuY2Hds=; b=a4pIvyjTQn8G
        idfcPsX8I4ZH4/mw1M9e5vsH0XnCW3ATTY+lqfIeQBDBDIZjcJdVSA5mPeTsG75eGA+94K2AJqRp8
        lG9FjZLqWZWJq+zr+qce8ayMWE0KKrJHVfJTORfmbD0MicKZjXqGpsg0LRG7fZyq2lXCXBIR51BCB
        1DGyQ=;
Received: from [192.168.15.50] (helo=mikhalitsyn-laptop.sw.ru)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1m2XR9-003blO-FC; Sun, 11 Jul 2021 14:15:51 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Roi Dayan <roid@nvidia.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: [PATCH iproute2] libnetlink: check error handler is present before a call
Date:   Sun, 11 Jul 2021 14:15:46 +0300
Message-Id: <20210711111546.3695-1-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix nullptr dereference of errhndlr from rtnl_dump_filter_arg
struct in rtnl_dump_done and rtnl_dump_error functions.

Fixes: 459ce6e3d792 ("ip route: ignore ENOENT during save if RT_TABLE_MAIN is being dumped")
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Roi Dayan <roid@nvidia.com>
Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Reported-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
---
 lib/libnetlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index e9b8c3bd..d068dbe2 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -686,7 +686,7 @@ static int rtnl_dump_done(struct nlmsghdr *h,
 	if (len < 0) {
 		errno = -len;
 
-		if (a->errhndlr(h, a->arg2) & RTNL_SUPPRESS_NLMSG_DONE_NLERR)
+		if (a->errhndlr && (a->errhndlr(h, a->arg2) & RTNL_SUPPRESS_NLMSG_DONE_NLERR))
 			return 0;
 
 		/* check for any messages returned from kernel */
@@ -729,7 +729,7 @@ static int rtnl_dump_error(const struct rtnl_handle *rth,
 		     errno == EOPNOTSUPP))
 			return -1;
 
-		if (a->errhndlr(h, a->arg2) & RTNL_SUPPRESS_NLMSG_ERROR_NLERR)
+		if (a->errhndlr && (a->errhndlr(h, a->arg2) & RTNL_SUPPRESS_NLMSG_ERROR_NLERR))
 			return 0;
 
 		if (!(rth->flags & RTNL_HANDLE_F_SUPPRESS_NLERR))
-- 
2.31.1

