Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB55C1097EF
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 04:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKZDAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 22:00:23 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33446 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725946AbfKZDAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 22:00:23 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Nov 2019 22:00:21 EST
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id F3AD64A2C5;
        Tue, 26 Nov 2019 13:53:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1574736799; bh=0BQcO
        SX6GhZi8vVpoT2iBwRnOnbu94JS1h+ml6+q04E=; b=L7Fg/YiNycmeB4zNcrZ9Y
        c4BLhTKXd1y66pJBzerQZkaOYXEcGJC6+nr9A25LP+5WNA7Zzc1rpmsH3qxON3r/
        RbFLTS8QwwGiKeKLr3FchixDBYwe7h4lS7gpONQzbDiZIVi6OeTvQ/Ml3a4Rg/sJ
        LH541Wq9yDqOrodpkFKO1U=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id pOjYoWOZTETI; Tue, 26 Nov 2019 13:53:19 +1100 (AEDT)
Received: from cba01.dek-tpc.internal (cba01.dek-tpc.internal [172.16.83.49])
        by mail.dektech.com.au (Postfix) with ESMTP id CBE524906A;
        Tue, 26 Nov 2019 13:53:19 +1100 (AEDT)
Received: by cba01.dek-tpc.internal (Postfix, from userid 1014)
        id 7E02518061F; Tue, 26 Nov 2019 13:53:19 +1100 (AEDT)
From:   john.rutherford@dektech.com.au
To:     davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Cc:     John Rutherford <john.rutherford@dektech.com.au>
Subject: [net] tipc: fix link name length check
Date:   Tue, 26 Nov 2019 13:52:55 +1100
Message-Id: <20191126025255.22305-1-john.rutherford@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Rutherford <john.rutherford@dektech.com.au>

In commit 4f07b80c9733 ("tipc: check msg->req data len in
tipc_nl_compat_bearer_disable") the same patch code was copied into
routines: tipc_nl_compat_bearer_disable(),
tipc_nl_compat_link_stat_dump() and tipc_nl_compat_link_reset_stats().
The two link routine occurrences should have been modified to check
the maximum link name length and not bearer name length.

Fixes: 4f07b80c9733 ("tipc: check msg->reg data len in tipc_nl_compat_bearer_disable")
Signed-off-by: John Rutherford <john.rutherford@dektech.com.au>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/netlink_compat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index e135d4e11231..d4d2928424e2 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -550,7 +550,7 @@ static int tipc_nl_compat_link_stat_dump(struct tipc_nl_compat_msg *msg,
 	if (len <= 0)
 		return -EINVAL;
 
-	len = min_t(int, len, TIPC_MAX_BEARER_NAME);
+	len = min_t(int, len, TIPC_MAX_LINK_NAME);
 	if (!string_is_valid(name, len))
 		return -EINVAL;
 
@@ -822,7 +822,7 @@ static int tipc_nl_compat_link_reset_stats(struct tipc_nl_compat_cmd_doit *cmd,
 	if (len <= 0)
 		return -EINVAL;
 
-	len = min_t(int, len, TIPC_MAX_BEARER_NAME);
+	len = min_t(int, len, TIPC_MAX_LINK_NAME);
 	if (!string_is_valid(name, len))
 		return -EINVAL;
 
-- 
2.11.0

