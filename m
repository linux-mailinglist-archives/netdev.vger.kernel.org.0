Return-Path: <netdev+bounces-9742-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DDD072A59D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:54:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CCE61C2118B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2387323D67;
	Fri,  9 Jun 2023 21:53:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26BD23C79
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4E5C4339B;
	Fri,  9 Jun 2023 21:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347622;
	bh=3SNI4rv4IFyHDhDIVZz5xr+oaME6roU6h6kQ5CLXeog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDLxPqPU/kZv+Q868NJJEnAcY7weRDQnjQMZJambnZkDpDScFzgFpMGkphNOW58M1
	 +8JdUalHgp6rjShOEuofIXrO5RvIdl1QJGrsk/wqpuMkugdNMT1ygIEO5Xj/VJqux/
	 9m9A53ChzIpyJqhlpRZRdgGVcCS6TVEVRwq0mrIWp97eGuSoRdHJ49upHgDocKLdV5
	 c3gct1agxVl0UYJZ5suvDwEL4BjMb7E5d+Trq0nSp312c9G8zzIjTxxL8Js9FycFXI
	 iFOKzFbiBrLpyeLm+VgwBvJryU1W9JwF0fI8BPobnc96nZgku8LHaYvF99OG9WJvzG
	 Aj95Nwxs2+Ytg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	dsahern@gmail.com,
	mkubecek@suse.cz,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/2] netlink: support extack in dump ->start()
Date: Fri,  9 Jun 2023 14:53:30 -0700
Message-Id: <20230609215331.1606292-2-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609215331.1606292-1-kuba@kernel.org>
References: <20230609215331.1606292-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 4a19edb60d02 ("netlink: Pass extack to dump handlers")
added extack support to netlink dumps. It was focused on rtnl
and since rtnl does not use ->start(), ->done() callbacks
it ignored those. Genetlink on the other hand uses ->start()
extensively, for parsing and input validation.

Pass the extact in via struct netlink_dump_control and link
it to cb for the time of ->start(). Both struct netlink_dump_control
and extack itself live on the stack so we can't keep the same
extack for the duration of the dump. This means that the extack
visible in ->start() and each ->dump() callbacks will be different.
Corner cases like reporting a warning message in DONE across dump
calls are still not supported.

We could put the extack (for dumps) in the socket struct,
but layering makes it slightly awkward (extack pointer is decided
before the DO / DUMP split).

The genetlink dump error extacks are now surfaced:

  $ cli.py --spec netlink/specs/ethtool.yaml --dump channels-get
  lib.ynl.NlError: Netlink error: Invalid argument
  nl_len = 64 (48) nl_flags = 0x300 nl_type = 2
	error: -22	extack: {'msg': 'request header missing'}

Previously extack was missing:

  $ cli.py --spec netlink/specs/ethtool.yaml --dump channels-get
  lib.ynl.NlError: Netlink error: Invalid argument
  nl_len = 36 (20) nl_flags = 0x100 nl_type = 2
	error: -22

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netlink.h  | 1 +
 net/netlink/af_netlink.c | 2 ++
 net/netlink/genetlink.c  | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 19c0791ed9d5..9eec3f4f5351 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -311,6 +311,7 @@ struct netlink_dump_control {
 	int (*start)(struct netlink_callback *);
 	int (*dump)(struct sk_buff *skb, struct netlink_callback *);
 	int (*done)(struct netlink_callback *);
+	struct netlink_ext_ack *extack;
 	void *data;
 	struct module *module;
 	u32 min_dump_alloc;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 3a1e0fd5bf14..cbd9aa7ee24a 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2360,7 +2360,9 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	cb->strict_check = !!(nlk2->flags & NETLINK_F_STRICT_CHK);
 
 	if (control->start) {
+		cb->extack = control->extack;
 		ret = control->start(cb);
+		cb->extack = NULL;
 		if (ret)
 			goto error_put;
 	}
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 04c4036bf406..a157247a1e45 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -912,6 +912,7 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 			.start = genl_start,
 			.dump = genl_lock_dumpit,
 			.done = genl_lock_done,
+			.extack = extack,
 		};
 
 		genl_unlock();
@@ -924,6 +925,7 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 			.start = genl_start,
 			.dump = ops->dumpit,
 			.done = genl_parallel_done,
+			.extack = extack,
 		};
 
 		err = __netlink_dump_start(net->genl_sock, skb, nlh, &c);
-- 
2.40.1


