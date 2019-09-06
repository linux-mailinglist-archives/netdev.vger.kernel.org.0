Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15696AB526
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 11:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389895AbfIFJxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 05:53:19 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:55176 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfIFJxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 05:53:19 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Sep 2019 05:53:18 EDT
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTP id CA79431418D;
        Fri,  6 Sep 2019 11:47:15 +0200 (CEST)
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net
Cc:     roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net v2] bridge/mdb: remove wrong use of NLM_F_MULTI
Date:   Fri,  6 Sep 2019 11:47:02 +0200
Message-Id: <20190906094703.21300-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NLM_F_MULTI must be used only when a NLMSG_DONE message is sent at the end.
In fact, NLMSG_DONE is sent only at the end of a dump.

Libraries like libnl will wait forever for NLMSG_DONE.

Fixes: 949f1e39a617 ("bridge: mdb: notify on router port add and del")
CC: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---

v2:
  add netdev and bridge ml :D
  remove Satish Ashok <sashok@cumulusnetworks.com> (its mail bounces)

 net/bridge/br_mdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index bf6acd34234d..63f9c08625f0 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -437,7 +437,7 @@ static int nlmsg_populate_rtr_fill(struct sk_buff *skb,
 	struct nlmsghdr *nlh;
 	struct nlattr *nest;
 
-	nlh = nlmsg_put(skb, pid, seq, type, sizeof(*bpm), NLM_F_MULTI);
+	nlh = nlmsg_put(skb, pid, seq, type, sizeof(*bpm), 0);
 	if (!nlh)
 		return -EMSGSIZE;
 
-- 
2.21.0

