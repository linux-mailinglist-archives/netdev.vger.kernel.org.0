Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08448652C6
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 10:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbfGKIDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 04:03:34 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:16382 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfGKIDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 04:03:34 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 507B541AE4;
        Thu, 11 Jul 2019 16:03:31 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, davem@davemloft.net
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] netfilter: nf_table_offload: Fix zero prio of flow_cls_common_offload
Date:   Thu, 11 Jul 2019 16:03:30 +0800
Message-Id: <1562832210-25981-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0tCQkJDQkNCSktOSVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MC46Gjo4ETg4FAwMKREIDCI9
        DBNPFBlVSlVKTk1JQ0hJSUpKT09NVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlLQkI3Bg++
X-HM-Tid: 0a6be00f0d972086kuqy507b541ae4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The flow_cls_common_offload prio should be not zero

It leads the invalid table prio in hw.

# nft add table netdev firewall
# nft add chain netdev firewall acl { type filter hook ingress device mlx_pf0vf0 priority - 300 \; }
# nft add rule netdev firewall acl ip daddr 1.1.1.7 drop
Error: Could not process rule: Invalid argument

kernel log
mlx5_core 0000:81:00.0: E-Switch: Failed to create FDB Table err -22 (table prio: 65535, level: 0, size: 4194304)

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_tables_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 2c33028..01d8133 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -7,6 +7,8 @@
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/pkt_cls.h>
 
+#define FLOW_OFFLOAD_DEFAUT_PRIO 1U
+
 static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
 {
 	struct nft_flow_rule *flow;
@@ -107,6 +109,7 @@ static void nft_flow_offload_common_init(struct flow_cls_common_offload *common,
 					struct netlink_ext_ack *extack)
 {
 	common->protocol = proto;
+	common->prio = TC_H_MAKE(FLOW_OFFLOAD_DEFAUT_PRIO << 16, 0);
 	common->extack = extack;
 }
 
-- 
1.8.3.1

