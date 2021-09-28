Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F89C41B7EA
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 22:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242627AbhI1UE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 16:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242534AbhI1UEZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 16:04:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74A6D610E6;
        Tue, 28 Sep 2021 20:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632859365;
        bh=JUbEawgwP2c3g8ePRDbJDUMS5ioHTfLNboJDo0lgTFU=;
        h=Date:From:To:Cc:Subject:From;
        b=Ux5mxk8+u9s/JuBAUe8lOapvH73pC8IDGMANlVx6y8oPhvgbvBvHWer4TncIe4O5P
         zRAc9E+j11GMc534Us0lyChK0krofQdH61wQYT+tlB96ajEswJlW5LiB//1WTO2L5f
         OMdrtwjp0duaQIPR+qZIqgAi6Qa8l2np6wXwolZtpIwLuqrEayWPXVgfeSukyRPcND
         nY0jFdRZ4a8XxMmYjRaDR7p3FjeSk8z6pkePYifJt/My7UG/ldZJhgQVzS3VbSERG8
         OBVMvKrRhltAQVgX/vRxXj76KXsBAURq7425SEWqtcbmF2tEpoF58LKK2rfiAYS5sI
         9KKrJqsNYsFsw==
Date:   Tue, 28 Sep 2021 15:06:47 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][net-next] netfilter: ebtables: use array_size() helper in
 copy_{from,to}_user()
Message-ID: <20210928200647.GA266402@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use array_size() helper instead of the open-coded version in
copy_{from,to}_user().  These sorts of multiplication factors
need to be wrapped in array_size().

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 83d1798dfbb4..32fa05ec4a6d 100644
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
2.27.0

