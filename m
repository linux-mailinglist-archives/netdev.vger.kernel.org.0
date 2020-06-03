Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926C81EC7CF
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 05:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgFCDaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 23:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFCDaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 23:30:16 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A7DC08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 20:30:16 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r10so758847pgv.8
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 20:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fNYP1b2B77S7hbjuGKvG/5ryZMUAnS0B1cRzFwBLaw4=;
        b=pC+EeqpG+OIqIw/GTCAwx6CAo32KMfB8GwClwzUcXIYhmrtQFcfVSdFgSQHqwPSb4b
         hOW7dGcRP7YelhLFisNGvcCq5jvYeFBDZLs0V8Oe6XeOnG4+BIJhxA/FKoBrEkMXC2/c
         cdMLv6NSdj9BrrxqA7SzCRr1E4MsXmA/ApQkllfE4HEzFSnQraTmSU7sfSrWK4lkPVK+
         uTCyFn5wt8NgnIo7c45Rtd+VO29PnYHswrfvypU/BDlmuTA4kifqW7tiyTCHMyZd14IZ
         sn/KRaM7Ev7wx15WYA1Xur06oYPHTCENpY9mkJyxia23flEimbc9VREsrS0bMuCph9R4
         lOFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fNYP1b2B77S7hbjuGKvG/5ryZMUAnS0B1cRzFwBLaw4=;
        b=MyaNRxB4TKx00Kh9tLAq7t6lImp3g752Pe4zD2VNWl8DjxlxC+0Cuk3GsaGhHdBWtk
         Ox8S1Q80dbPp1jW2AOEFWS+JRS3sbJ+hr1yHH3cjrRLZ2nqbadVAjcD2o2/+++pNn8Xp
         a3ySqkjvYuwAWrk9E1znw1IQ06+DKAWrJfNi/T0MTxL9t1tmcpcY1CqZqSVvNsDsouiq
         h1SSnyHdlzvfUSPCJGGRYfwprT7SBuxSt67tGw35Pe/Ss6mvMNMIoTKu5sCNe6v+P/Ai
         Wnx45tEYeQrg++sAi8B6G/UAtzxgwwiMc5rArQVyJzaRJ29/aq6mr5ID7NGU9EAGOzVz
         5ctg==
X-Gm-Message-State: AOAM531KkyuvPwt64xvGdbFgIthpeWUzHEbCIdDIhP6ggYFNwLgyP9Vw
        /ilEDaDaRY3LOA/7AIFlBzG9ab22
X-Google-Smtp-Source: ABdhPJxQrpJ0Pxv8GoLRtLwl0Kh7+ohpZajzH+6EKOXY+u1799GIKz5zu4sLkOTHwxG2GaJ/f5k5rg==
X-Received: by 2002:a17:90a:1a17:: with SMTP id 23mr2804541pjk.95.1591155015339;
        Tue, 02 Jun 2020 20:30:15 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id e78sm482848pfh.50.2020.06.02.20.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 20:30:14 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+21f04f481f449c8db840@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Pirko <jiri@mellanox.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Shaochun Chen <cscnull@gmail.com>
Subject: [Patch net] genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()
Date:   Tue,  2 Jun 2020 20:29:42 -0700
Message-Id: <20200603032942.20995-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two kinds of memory leaks in genl_family_rcv_msg_dumpit():

1. Before we call ops->start(), whenever an error happens, we forget
   to free the memory allocated in genl_family_rcv_msg_dumpit().

2. When ops->start() fails, the 'info' has been already installed on
   the per socket control block, so we should not free it here. More
   importantly, nlk->cb_running is still false at this point, so
   netlink_sock_destruct() cannot free it either.

The first kind of memory leaks is easier to resolve, but the second
one requires some deeper thoughts.

After reviewing how netfilter handles this, the most elegant solution
I find is just to use a similar way to allocate the memory, that is,
moving memory allocations from caller into ops->start(). With this,
we can solve both kinds of memory leaks: for 1), no memory allocation
happens before ops->start(); for 2), ops->start() handles its own
failures and 'info' is only installed to the socket control block
when succeeds. The only ugliness here is we have to pass all local
variables on stack via a struct, but this is not hard to understand.

Alternatively, we can introduce a ops->free() to solve this too,
but it is overkill as only genetlink has this problem so far.

Fixes: 1927f41a22a0 ("net: genetlink: introduce dump info struct to be available during dumpit op")
Reported-by: syzbot+21f04f481f449c8db840@syzkaller.appspotmail.com
Cc: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: YueHaibing <yuehaibing@huawei.com>
Cc: Shaochun Chen <cscnull@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netlink/genetlink.c | 94 +++++++++++++++++++++++++----------------
 1 file changed, 58 insertions(+), 36 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 9f357aa22b94..5abd4fe17b8f 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -513,16 +513,59 @@ static void genl_family_rcv_msg_attrs_free(const struct genl_family *family,
 		kfree(attrbuf);
 }
 
-static int genl_lock_start(struct netlink_callback *cb)
+struct genl_start_context {
+	const struct genl_family *family;
+	struct nlmsghdr *nlh;
+	struct netlink_ext_ack *extack;
+	const struct genl_ops *ops;
+	int hdrlen;
+};
+
+static int genl_start(struct netlink_callback *cb)
 {
-	const struct genl_ops *ops = genl_dumpit_info(cb)->ops;
+	struct genl_start_context *ctx = cb->data;
+	const struct genl_ops *ops = ctx->ops;
+	struct genl_dumpit_info *info;
+	struct nlattr **attrs = NULL;
 	int rc = 0;
 
+	if (ops->validate & GENL_DONT_VALIDATE_DUMP)
+		goto no_attrs;
+
+	if (ctx->nlh->nlmsg_len < nlmsg_msg_size(ctx->hdrlen))
+		return -EINVAL;
+
+	attrs = genl_family_rcv_msg_attrs_parse(ctx->family, ctx->nlh, ctx->extack,
+						ops, ctx->hdrlen,
+						GENL_DONT_VALIDATE_DUMP_STRICT,
+						true);
+	if (IS_ERR(attrs))
+		return PTR_ERR(attrs);
+
+no_attrs:
+	info = genl_dumpit_info_alloc();
+	if (!info) {
+		kfree(attrs);
+		return -ENOMEM;
+	}
+	info->family = ctx->family;
+	info->ops = ops;
+	info->attrs = attrs;
+
 	if (ops->start) {
-		genl_lock();
+		if (!ctx->family->parallel_ops)
+			genl_lock();
 		rc = ops->start(cb);
-		genl_unlock();
+		if (!ctx->family->parallel_ops)
+			genl_unlock();
 	}
+
+	if (rc) {
+		kfree(attrs);
+		genl_dumpit_info_free(info);
+		return rc;
+	}
+	cb->data = info;
 	return rc;
 }
 
@@ -548,7 +591,7 @@ static int genl_lock_done(struct netlink_callback *cb)
 		rc = ops->done(cb);
 		genl_unlock();
 	}
-	genl_family_rcv_msg_attrs_free(info->family, info->attrs, true);
+	genl_family_rcv_msg_attrs_free(info->family, info->attrs, false);
 	genl_dumpit_info_free(info);
 	return rc;
 }
@@ -573,43 +616,23 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 				      const struct genl_ops *ops,
 				      int hdrlen, struct net *net)
 {
-	struct genl_dumpit_info *info;
-	struct nlattr **attrs = NULL;
+	struct genl_start_context ctx;
 	int err;
 
 	if (!ops->dumpit)
 		return -EOPNOTSUPP;
 
-	if (ops->validate & GENL_DONT_VALIDATE_DUMP)
-		goto no_attrs;
-
-	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
-		return -EINVAL;
-
-	attrs = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
-						ops, hdrlen,
-						GENL_DONT_VALIDATE_DUMP_STRICT,
-						true);
-	if (IS_ERR(attrs))
-		return PTR_ERR(attrs);
-
-no_attrs:
-	/* Allocate dumpit info. It is going to be freed by done() callback. */
-	info = genl_dumpit_info_alloc();
-	if (!info) {
-		genl_family_rcv_msg_attrs_free(family, attrs, true);
-		return -ENOMEM;
-	}
-
-	info->family = family;
-	info->ops = ops;
-	info->attrs = attrs;
+	ctx.family = family;
+	ctx.nlh = nlh;
+	ctx.extack = extack;
+	ctx.ops = ops;
+	ctx.hdrlen = hdrlen;
 
 	if (!family->parallel_ops) {
 		struct netlink_dump_control c = {
 			.module = family->module,
-			.data = info,
-			.start = genl_lock_start,
+			.data = &ctx,
+			.start = genl_start,
 			.dump = genl_lock_dumpit,
 			.done = genl_lock_done,
 		};
@@ -617,12 +640,11 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 		genl_unlock();
 		err = __netlink_dump_start(net->genl_sock, skb, nlh, &c);
 		genl_lock();
-
 	} else {
 		struct netlink_dump_control c = {
 			.module = family->module,
-			.data = info,
-			.start = ops->start,
+			.data = &ctx,
+			.start = genl_start,
 			.dump = ops->dumpit,
 			.done = genl_parallel_done,
 		};
-- 
2.26.2

