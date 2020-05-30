Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B12F1E8E0E
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 07:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgE3Fy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 01:54:56 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:13452 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgE3Fyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 01:54:55 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 1885040F40;
        Sat, 30 May 2020 13:54:54 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com, marcelo.leitner@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] net/sched: act_ct: add nat mangle action only for NAT-conntrack
Date:   Sat, 30 May 2020 13:54:51 +0800
Message-Id: <1590818091-3548-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJTEJCQkJCTEpIQ0JMTFlXWShZQU
        lCN1dZLVlBSVdZDwkaFQgSH1lBWR0iNQs4HDgjQzQMCEIfPR4oL0NLOhxWVlVCQ0hIKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NC46Nhw5PTgxNz9WGhoeMyMW
        TThPCSlVSlVKTkJLQ0pDS0JPSkxDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpIQkM3Bg++
X-HM-Tid: 0a726425bc212086kuqy1885040f40
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Currently add nat mangle action with comparing invert and ori tuple.
It is better to check IPS_NAT_MASK flags first to avoid non necessary
memcmp for non-NAT conntrack.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/act_ct.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 1a76639..2057735 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -199,6 +199,9 @@ static int tcf_ct_flow_table_add_action_nat(struct net *net,
 	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
 	struct nf_conntrack_tuple target;
 
+	if (!(ct->status & IPS_NAT_MASK))
+		return 0;
+
 	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
 
 	switch (tuple->src.l3num) {
-- 
1.8.3.1

