Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856A121447F
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 09:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgGDHmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 03:42:50 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:23503 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgGDHmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 03:42:50 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 7C69F40F6B
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 15:42:47 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Subject: [PATCH net] net/sched: act_ct: add miss tcf_lastuse_update.
Date:   Sat,  4 Jul 2020 15:42:47 +0800
Message-Id: <1593848567-14288-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSFVMTExCQkJDTExCSUJNQllXWShZQU
        lCN1dZLVlBSVdZDwkaFQgSH1lBWR0iNQs4HDkzMxMdSDYcOR0#MRUxOhxWVlVOTEhKKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PQw6TQw4KT4MQ04SCQsoIgNR
        AzkKFBZVSlVKTkJIQ09DTk1MTkxMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpOT083Bg++
X-HM-Tid: 0a7318c716d92086kuqy7c69f40f6b
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

