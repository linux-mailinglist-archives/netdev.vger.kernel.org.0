Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6AE48829
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 18:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfFQQCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 12:02:11 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46515 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfFQQCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 12:02:11 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so10543520wrw.13
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 09:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1eVyO3475+vGYTpZM4Ne10AoF7Av4Go6cB68x/X91Aw=;
        b=SIEcs+YzLZvQqtpwNTeddXv76rp7FipkTp5uJTvv9XzLFfDBimJicByamKkTuuu61I
         ZxctydBlGdNJQUWxL/EfiIS2Wg77eNd7FXSyU75fqPLRE8DlK/bFo4noX6ZHjS5hM/+Q
         w3csHOi3+P17zR/AnMmkObGOBRx0gTDCnPMk4xrf4oLC03Pmx/p9oWzsYjB9IKNiO3tO
         BMJ1AzOCIUvET/4STvaRJ/l0s1EokrbGBbupHWPU+6Snak3kc2LYIvgEgv+w+P4flY+9
         ek5Wg7M0/78HuBnSskVLlDeji9HraYWXzR/eYiviNPKskIJLT2ddzcx7aT15yJzPw+6j
         tMzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1eVyO3475+vGYTpZM4Ne10AoF7Av4Go6cB68x/X91Aw=;
        b=o2Zvmn5QFkvtGnipoHwYicXqbZnO4BnwVRdf1LPg/oOJO58T9IsoCpleiYeEtsUisM
         N1zQPNSxswRPfCMPRRB76QWQwSQu7QOy/qqUkN+lMEJVq6RsaCOh/1Rr56mUHJKhsAsK
         eHPKNtF81fBUP8ONifUL+z25E/zdyxJmFa8lKHkBvUiT8LldQJTYJxojyQQ9JS/3DVq0
         qlFCPydgGRiOx2gYmRoQXFT7B6ttDsov99IKMnv+12kYCPCQVqOYxHJFx5Rvfm/kLo1Z
         5A+c2n74YRxA+OHhyGZJsZjAT6l0lcVnc2aeB65R1elA1EeUMpReegf8xWInp5y5uC7d
         ud7g==
X-Gm-Message-State: APjAAAV1bqP0D9+OaYm8F1mYbP02NtHE8VeMrJwQIWwNWkNdEx3mDgLB
        Z87YhdIfvGcFCvVqgfXIKSoQtP4YwJM=
X-Google-Smtp-Source: APXvYqwBRD//bnkgHN3ovmckUF/qJrQK/Qb90U2iPnu9cGhj+DhQXmoT/oLV3ItLMIj0vV3SLpFARw==
X-Received: by 2002:adf:e7ca:: with SMTP id e10mr16582418wrn.281.1560787329166;
        Mon, 17 Jun 2019 09:02:09 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id y9sm124369wma.1.2019.06.17.09.02.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 09:02:08 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com, eli@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com
Subject: [patch net-next internal] net: sched: cls_matchall: allow to delete filter
Date:   Mon, 17 Jun 2019 18:02:08 +0200
Message-Id: <20190617160208.7548-1-jiri@resnulli.us>
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

