Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9210620D1C2
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgF2Snq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:43:46 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:18459 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgF2Snj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:43:39 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 5601E4200D;
        Mon, 29 Jun 2020 17:16:19 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 2/2] net/sched: act_ct: add miss tcf_lastuse_update.
Date:   Mon, 29 Jun 2020 17:16:18 +0800
Message-Id: <1593422178-26949-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593422178-26949-1-git-send-email-wenxu@ucloud.cn>
References: <1593422178-26949-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJOQkJCQkxCQkxJQ09ZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdIjULOBw*FRk5IREIHRceFA8wDTocVlZVSUlIKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PU06PTo5PTgwES0rKkgyFS8d
        FxEaCy5VSlVKTkJIT0lJSkxCT05OVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpDSUw3Bg++
X-HM-Tid: 0a72ff5cec322086kuqy5601e4200d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

When tcf_ct_act execute the tcf_lastuse_update should
be update or the used stats never update

filter protocol ip pref 3 flower chain 0
filter protocol ip pref 3 flower chain 0 handle 0x1
  eth_type ipv4
  dst_ip 1.1.1.1
  ip_flags frag/firstfrag
  skip_hw
  not_in_hw
 action order 1: ct zone 1 nat pipe
  index 1 ref 1 bind 1 installed 103 sec used 103 sec
 Action statistics:
 Sent 151500 bytes 101 pkt (dropped 0, overlimits 0 requeues 0)
 backlog 0b 0p requeues 0
 cookie 4519c04dc64a1a295787aab13b6a50fb

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/sched/act_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 2eaabdc..ec0250f 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -928,6 +928,8 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	force = p->ct_action & TCA_CT_ACT_FORCE;
 	tmpl = p->tmpl;
 
+	tcf_lastuse_update(&c->tcf_tm);
+
 	if (clear) {
 		ct = nf_ct_get(skb, &ctinfo);
 		if (ct) {
-- 
1.8.3.1

