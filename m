Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A7C2454EA
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 01:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgHOX32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 19:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgHOX31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 19:29:27 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFBFC061786
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 16:29:27 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id bh1so5722764plb.12
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 16:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RFK8iqgXHMzUr2KO1r4TjJdfxGAXKGKq8DIgOslyPQA=;
        b=i+2YUO9UHawne3rlsWf14nwEBVwZReG89Ejrkb8tuTqw0CBnJPvBJX4+zGurQnetUK
         4lNYPgUyblO1xGX0JHQr3c08YhxIk1UDih/FRKEMHDA9TfL4cNy/0b/GFoFO/gYkzrFw
         c5Vm+yKtblmrsoDrxiSRss7YC6cFvHmP2hcoTnyBLckUq81FJx+kXVJ1eKmyJ3FJk44w
         F1p40KRVx+RQNnab6WsESEqbmujpkV2o9G49bSJyTln4F2NooYs3aokd6GF4AIhAnG7v
         8Bfj17/5f+qe0IpnqxSp/RlNG6naM9/SdBk5RDUGn3m4dPQdtI+af3IRHC8xiey2+JXW
         ku7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RFK8iqgXHMzUr2KO1r4TjJdfxGAXKGKq8DIgOslyPQA=;
        b=bZFryXDN75G8RwAxkWhQl199OZ1wQPm62ihmb5+ewqLA0gDjwyeSh9el7Z4je984LB
         Eer6fnzPuN0ieGRMz8BvSj85dVfe/+tDs6nzmtnP/mBxt0PmqYORCTJsRv/ysA7MTfH/
         Nfp38Cd3uA/9LEpCXtSt0IJ7+jcKn3ftV+6duqT3M5KfKJsD7fb4ScHLXgF4dli9vyLv
         ere+l7gDwulD2/+TXBQGYqwvG4CT6p8CiYOjHvv0FihTHVkuYxDU6AL+BN0jrLQWaDJv
         cwnZO68YNgdg1wRq+zZzDhKyUR4rYrxc+niQq3HgKmwbjVDi5KqfV0RjyMkuq1j5iEaX
         fXDg==
X-Gm-Message-State: AOAM531QPtUPMafRozRim+IiD8e8kvyPfrDLzV8nyofOJO6q7T8NVGCU
        qfsBndN8TndSzxPBqzZH1nJZocAYm7y/2Q==
X-Google-Smtp-Source: ABdhPJzJMs4o/dRKYk0k0/ZgP3txtYDg6Apea4Y8GUBY/UqmwDpjYuLFtP9xMzvaScLNPQmjDCHF8g==
X-Received: by 2002:a17:902:56a:: with SMTP id 97mr6643037plf.130.1597534166723;
        Sat, 15 Aug 2020 16:29:26 -0700 (PDT)
Received: from unknown.linux-6brj.site ([2600:1700:727f::46])
        by smtp.gmail.com with ESMTPSA id y6sm2138239pgy.94.2020.08.15.16.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2020 16:29:26 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+0e7181deafa7e0b79923@syzkaller.appspotmail.com,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Richard Alpe <richard.alpe@ericsson.com>
Subject: [Patch net] tipc: fix uninit skb->data in tipc_nl_compat_dumpit()
Date:   Sat, 15 Aug 2020 16:29:15 -0700
Message-Id: <20200815232915.17625-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__tipc_nl_compat_dumpit() has two callers, and it expects them to
pass a valid nlmsghdr via arg->data. This header is artificial and
crafted just for __tipc_nl_compat_dumpit().

tipc_nl_compat_publ_dump() does so by putting a genlmsghdr as well
as some nested attribute, TIPC_NLA_SOCK. But the other caller
tipc_nl_compat_dumpit() does not, this leaves arg->data uninitialized
on this call path.

Fix this by just adding a similar nlmsghdr without any payload in
tipc_nl_compat_dumpit().

This bug exists since day 1, but the recent commit 6ea67769ff33
("net: tipc: prepare attrs in __tipc_nl_compat_dumpit()") makes it
easier to appear.

Reported-and-tested-by: syzbot+0e7181deafa7e0b79923@syzkaller.appspotmail.com
Fixes: d0796d1ef63d ("tipc: convert legacy nl bearer dump to nl compat")
Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: Richard Alpe <richard.alpe@ericsson.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/tipc/netlink_compat.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 217516357ef2..90e3c70a91ad 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -275,8 +275,9 @@ static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 static int tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 				 struct tipc_nl_compat_msg *msg)
 {
-	int err;
+	struct nlmsghdr *nlh;
 	struct sk_buff *arg;
+	int err;
 
 	if (msg->req_type && (!msg->req_size ||
 			      !TLV_CHECK_TYPE(msg->req, msg->req_type)))
@@ -305,6 +306,15 @@ static int tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 		return -ENOMEM;
 	}
 
+	nlh = nlmsg_put(arg, 0, 0, tipc_genl_family.id, 0, NLM_F_MULTI);
+	if (!nlh) {
+		kfree_skb(arg);
+		kfree_skb(msg->rep);
+		msg->rep = NULL;
+		return -EMSGSIZE;
+	}
+	nlmsg_end(arg, nlh);
+
 	err = __tipc_nl_compat_dumpit(cmd, msg, arg);
 	if (err) {
 		kfree_skb(msg->rep);
-- 
2.28.0

