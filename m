Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B9829424
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389564AbfEXJFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:05:32 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:41695 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389279AbfEXJFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 05:05:31 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 May 2019 05:05:31 EDT
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 0BC5C2BAA06;
        Fri, 24 May 2019 10:59:22 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.89)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1hU62r-0004Bb-TW; Fri, 24 May 2019 10:59:21 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Philippe Guibert <philippe.guibert@6wind.com>
Subject: [PATCH iproute2] lib: suppress error msg when filling the cache
Date:   Fri, 24 May 2019 10:59:10 +0200
Message-Id: <20190524085910.16018-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before the patch:
$ ip netns add foo
$ ip link add name veth1 address 2a:a5:5c:b9:52:89 type veth peer name veth2 address 2a:a5:5c:b9:53:90 netns foo
RTNETLINK answers: No such device
RTNETLINK answers: No such device

But the command was successful. This may break script. Let's remove those
error messages.

Fixes: 55870dfe7f8b ("Improve batch and dump times by caching link lookups")
Reported-by: Philippe Guibert <philippe.guibert@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 lib/ll_map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ll_map.c b/lib/ll_map.c
index 2d7b65dcb8f7..e0ed54bf77c9 100644
--- a/lib/ll_map.c
+++ b/lib/ll_map.c
@@ -177,7 +177,7 @@ static int ll_link_get(const char *name, int index)
 		addattr_l(&req.n, sizeof(req), IFLA_IFNAME, name,
 			  strlen(name) + 1);
 
-	if (rtnl_talk(&rth, &req.n, &answer) < 0)
+	if (rtnl_talk_suppress_rtnl_errmsg(&rth, &req.n, &answer) < 0)
 		goto out;
 
 	/* add entry to cache */
-- 
2.21.0

