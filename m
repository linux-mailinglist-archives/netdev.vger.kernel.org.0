Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F4A1EC880
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 06:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgFCEtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 00:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFCEtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 00:49:20 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FF5C05BD43
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 21:49:20 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t7so922056pgt.3
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 21:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dhyo+KoHdckqBDs7L3zgMeQa35gpXl7JEVwJhBuNh0M=;
        b=q1E/NFdVKJjzpJW7Rn4RVSV0eLVoi8Vnn9oboSzzPUdtuL2md36N6nWDVuXk5li67v
         Roazg2gI/TK+YEye4k3MRqFNG3ZWK6b3vg55J6CfuQN8P4WzgoaUUUIhZy/b/m1pi1Cp
         3dFbFUoYI3/vklb5JNouYlMNx4338D9A5x0bBTWsKGqtmZKyq0yHX8rCshcxKicFdwBI
         CUrONgmx27nyNXVPGNiwbwN+7BuJIj9qDZkowztgkF9dSNjdlJMQMj0TduHJzEkgU1Jh
         7h79Dd4a3BA9BOeIcBYmy30Q1q2WFaoKmoFB9tM9NzKW/dBMjMmK71mqf6bPW4T5cJHK
         4QPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dhyo+KoHdckqBDs7L3zgMeQa35gpXl7JEVwJhBuNh0M=;
        b=UOcCVRkMo5GSvvPwLqAl62FAbynir30m8HqPzNtOQAFpezlefiKrWGYpEVWINwt2ee
         X2krBS5KWHcKOtU9nSWj11JdoHlUo773rXNcvR0r67UF1vse9Ep2w70Glu+fKfNDHKy5
         BzWrkmdd5qo9RXeSaWgGnDSS0xFfyZCLnFdgQqt7UFhDJ0MqWA8hXAl5BoIPsBvkCt4c
         22PBFZNlqgATg1pg0paESiWvOrYRPViAnotrexDAgKOENrnLdDzWFSU+O4+90LVTfu3x
         B5296ZobCtsHOzqxoFqT+2aaWCPvJ0SNgyqDSJEGC1mD+YSG3IiCSBXe7+qrqJ4ZkwsY
         L9GA==
X-Gm-Message-State: AOAM530/tQ9f/sd0HbNuPggwJfu0Tc2TMls8jaEcezYq6VqhIppTHygj
        l1IoWTx7W57NWFRzdzvBc19pqBrD
X-Google-Smtp-Source: ABdhPJz9cyrVp/Z2t0cTmU7xIWbib0rUMM5lki1j9EIxzQKBEfZO1t/BmBKE8aPp/6KBwjz8sBqTWQ==
X-Received: by 2002:a17:90b:1b06:: with SMTP id nu6mr3269180pjb.106.1591159758007;
        Tue, 02 Jun 2020 21:49:18 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id np5sm780083pjb.43.2020.06.02.21.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 21:49:17 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+21f04f481f449c8db840@syzkaller.appspotmail.com,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Pirko <jiri@mellanox.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Shaochun Chen <cscnull@gmail.com>
Subject: [Patch net v2] genetlink: fix memory leaks in genl_family_rcv_msg_dumpit()
Date:   Tue,  2 Jun 2020 21:49:10 -0700
Message-Id: <20200603044910.27259-1-xiyou.wangcong@gmail.com>
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
failures and 'info' is installed to the socket control block only
when success. The only ugliness here is we have to pass all local
variables on stack via a struct, but this is not hard to understand.

Alternatively, we can introduce a ops->free() to solve this too,
but it is overkill as only genetlink has this problem so far.

Fixes: 1927f41a22a0 ("net: genetlink: introduce dump info struct to be available during dumpit op")
Reported-by: syzbot+21f04f481f449c8db840@syzkaller.appspotmail.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
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
index 9f357aa22b94..bcbba0bef1c2 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -513,15 +513,58 @@ static void genl_family_rcv_msg_attrs_free(const struct genl_family *family,
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
+	cb->data = info;
 	if (ops->start) {
-		genl_lock();
+		if (!ctx->family->parallel_ops)
+			genl_lock();
 		rc = ops->start(cb);
-		genl_unlock();
+		if (!ctx->family->parallel_ops)
+			genl_unlock();
+	}
+
+	if (rc) {
+		kfree(attrs);
+		genl_dumpit_info_free(info);
+		cb->data = NULL;
 	}
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

