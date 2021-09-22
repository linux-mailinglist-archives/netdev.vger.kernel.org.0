Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2FB414432
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 10:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhIVIv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 04:51:57 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:53125 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233741AbhIVIv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 04:51:56 -0400
Received: from bretzel (unknown [10.16.0.57])
        by proxy.6wind.com (Postfix) with ESMTPS id DDE37B43C9F;
        Wed, 22 Sep 2021 10:50:20 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1mSxxM-0003X5-RP; Wed, 22 Sep 2021 10:50:20 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com,
        syzbot+3d9866419b4aa8f985d6@syzkaller.appspotmail.com
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH ipsec] xfrm: fix rcu lock in xfrm_notify_userpolicy()
Date:   Wed, 22 Sep 2021 10:50:06 +0200
Message-Id: <20210922085006.13570-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <0000000000003533d205cc8a624b@google.com>
References: <0000000000003533d205cc8a624b@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As stated in the comment above xfrm_nlmsg_multicast(), rcu read lock must
be held before calling this function.

Reported-by: syzbot+3d9866419b4aa8f985d6@syzkaller.appspotmail.com
Fixes: 703b94b93c19 ("xfrm: notify default policy on update")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/xfrm/xfrm_user.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 0eba0c27c665..3a3cb09eec12 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1967,6 +1967,7 @@ static int xfrm_notify_userpolicy(struct net *net)
 	int len = NLMSG_ALIGN(sizeof(*up));
 	struct nlmsghdr *nlh;
 	struct sk_buff *skb;
+	int err;
 
 	skb = nlmsg_new(len, GFP_ATOMIC);
 	if (skb == NULL)
@@ -1988,7 +1989,11 @@ static int xfrm_notify_userpolicy(struct net *net)
 
 	nlmsg_end(skb, nlh);
 
-	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_POLICY);
+	rcu_read_lock();
+	err = xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_POLICY);
+	rcu_read_unlock();
+
+	return err;
 }
 
 static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
-- 
2.33.0

