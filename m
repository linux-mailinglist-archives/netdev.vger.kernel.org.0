Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873DB441571
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 09:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhKAImV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 04:42:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57784 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbhKAImU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 04:42:20 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id B242863F30;
        Mon,  1 Nov 2021 09:37:54 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 1/5] netfilter: ebtables: use array_size() helper in copy_{from,to}_user()
Date:   Mon,  1 Nov 2021 09:39:36 +0100
Message-Id: <20211101083940.51007-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211101083940.51007-1-pablo@netfilter.org>
References: <20211101083940.51007-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

Use array_size() helper instead of the open-coded version in
copy_{from,to}_user().  These sorts of multiplication factors
need to be wrapped in array_size().

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 4a1508a1c566..0ec2e1192bee 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1071,7 +1071,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	 */
 	if (repl->num_counters &&
 	   copy_to_user(repl->counters, counterstmp,
-	   repl->num_counters * sizeof(struct ebt_counter))) {
+	   array_size(repl->num_counters, sizeof(struct ebt_counter)))) {
 		/* Silent error, can't fail, new table is already in place */
 		net_warn_ratelimited("ebtables: counters copy to user failed while replacing table\n");
 	}
@@ -1399,7 +1399,8 @@ static int do_update_counters(struct net *net, const char *name,
 		goto unlock_mutex;
 	}
 
-	if (copy_from_user(tmp, counters, num_counters * sizeof(*counters))) {
+	if (copy_from_user(tmp, counters,
+			   array_size(num_counters, sizeof(*counters)))) {
 		ret = -EFAULT;
 		goto unlock_mutex;
 	}
@@ -1532,7 +1533,7 @@ static int copy_counters_to_user(struct ebt_table *t,
 	write_unlock_bh(&t->lock);
 
 	if (copy_to_user(user, counterstmp,
-	   nentries * sizeof(struct ebt_counter)))
+	    array_size(nentries, sizeof(struct ebt_counter))))
 		ret = -EFAULT;
 	vfree(counterstmp);
 	return ret;
-- 
2.30.2

