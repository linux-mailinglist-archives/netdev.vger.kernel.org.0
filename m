Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3510F4882B
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 18:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfFQQCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 12:02:36 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54998 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfFQQCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 12:02:35 -0400
Received: by mail-wm1-f68.google.com with SMTP id g135so9854413wme.4
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 09:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1eVyO3475+vGYTpZM4Ne10AoF7Av4Go6cB68x/X91Aw=;
        b=O6lwPb8aGJ6ponVHaiOgGEGg5P5JN9xx7nY4eCvmoFvD2dVPm5u3qqhquNBfZx71ig
         pbFGU6xai//zgrefU5NXExkKqHg301XT858Xmm8ZATHacqA7yv6fhXYhoBPXjOQ/KEnG
         EsduWH2mwS0HoVTdXbuNP9/4hzOHdUxxStoh47yAey/jJnUaG8ZPGAt8JGXKAjtxS0ij
         lNWtvCc5ZOeLR4lEUV9iJxaQRXk9qs967angRBOVFzmhsgnpWWs/hrNLiFs8RDeqwMf9
         KVjkJ7cpX44UfePc4LJOO/B5j5hpYLESFngogDP6Lbzspy+8yEqkHoC/8R843qlu0pCB
         mlWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1eVyO3475+vGYTpZM4Ne10AoF7Av4Go6cB68x/X91Aw=;
        b=CxgFuH5YVUM6yKUCrbUsqWq+ZmXoXcT5/0CLlrrJY9lyi6/j9x0wNJ/lGmWUp5szwy
         cGkBUPwF13PFWvPPjgTSyfFBuakIRiAnCvpEmw/d3vZ2ODmtAYuRvdIVCcCk2KVzsU4K
         O9BZ/n4tQb0adVZEiO9VCJYAs70kF6bMHjnXMtxWSAU0nux2lB4ofDizermUhQWqY3zG
         SNsJmXspCwtEzdbS956kPI8TYsM0wK3x4V8/V+R5ki5+yIVCaxP3Eo96Cm2BfFUz/UdC
         DSFEBi1YugpyPYvF5yEqJL1t8CLC4C3kMIMv4z3QJhRKLWjhFYjaI5aqmk4hBfxyf+V+
         U/NA==
X-Gm-Message-State: APjAAAW1relJwchs4JPfNR9X6No+FBRiOnOIiAOpKq7RiPK1hP3+/USR
        zyWkiutofNhM8YHjvX3GnYwPa7vZwgs=
X-Google-Smtp-Source: APXvYqyCrdf2UW4tPuLNCmAgTDl8Aap6ZVd6sgPFHZN2LMLDOfLN5ZpFyAilWI5v+l6aiwFBy3pm+A==
X-Received: by 2002:a1c:6154:: with SMTP id v81mr19127147wmb.92.1560787353376;
        Mon, 17 Jun 2019 09:02:33 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id t63sm12484276wmt.6.2019.06.17.09.02.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 09:02:33 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com, eli@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com
Subject: [patch net-next] net: sched: cls_matchall: allow to delete filter
Date:   Mon, 17 Jun 2019 18:02:32 +0200
Message-Id: <20190617160232.7599-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently user is unable to delete the filter. See following example:
$ tc filter add dev ens16np1 ingress pref 1 handle 1 matchall action drop
$ tc filter show dev ens16np1 ingress
filter protocol all pref 1 matchall chain 0
filter protocol all pref 1 matchall chain 0 handle 0x1
  in_hw
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1

$ tc filter del dev ens16np1 ingress pref 1 handle 1 matchall action drop
RTNETLINK answers: Operation not supported

Implement tcf_proto_ops->delete() op and allow user to delete the filter.

Reported-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/sched/cls_matchall.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 38c0a9f0f296..a30d2f8feb32 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -21,6 +21,7 @@ struct cls_mall_head {
 	unsigned int in_hw_count;
 	struct tc_matchall_pcnt __percpu *pf;
 	struct rcu_work rwork;
+	bool deleting;
 };
 
 static int mall_classify(struct sk_buff *skb, const struct tcf_proto *tp,
@@ -258,7 +259,11 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
 static int mall_delete(struct tcf_proto *tp, void *arg, bool *last,
 		       bool rtnl_held, struct netlink_ext_ack *extack)
 {
-	return -EOPNOTSUPP;
+	struct cls_mall_head *head = rtnl_dereference(tp->root);
+
+	head->deleting = true;
+	*last = true;
+	return 0;
 }
 
 static void mall_walk(struct tcf_proto *tp, struct tcf_walker *arg,
@@ -269,7 +274,7 @@ static void mall_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 	if (arg->count < arg->skip)
 		goto skip;
 
-	if (!head)
+	if (!head || head->deleting)
 		return;
 	if (arg->fn(tp, head, arg) < 0)
 		arg->stop = 1;
-- 
2.20.1

