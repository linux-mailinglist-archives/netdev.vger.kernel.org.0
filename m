Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0F7176FAB
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 07:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbgCCGy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 01:54:59 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:56663 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725440AbgCCGy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 01:54:59 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04428;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TrXKGEF_1583218496;
Received: from localhost(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0TrXKGEF_1583218496)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 03 Mar 2020 14:54:57 +0800
From:   Cambda Zhu <cambda@linux.alibaba.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Cambda Zhu <cambda@linux.alibaba.com>
Subject: [PATCH] ipv6: Use math to point per net sysctls into the appropriate struct net
Date:   Tue,  3 Mar 2020 14:54:34 +0800
Message-Id: <20200303065434.81842-1-cambda@linux.alibaba.com>
X-Mailer: git-send-email 2.16.6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The data pointers of ipv6 sysctl are set one by one which is hard to
maintain, especially with kconfig. This patch simplifies it by using
math to point the per net sysctls into the appropriate struct net,
just like what we did for ipv4.

Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
---
 net/ipv6/sysctl_net_ipv6.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index ec8fcfc60a27..cfc82cbe8e1f 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -203,6 +203,7 @@ static int __net_init ipv6_sysctl_net_init(struct net *net)
 	struct ctl_table *ipv6_table;
 	struct ctl_table *ipv6_route_table;
 	struct ctl_table *ipv6_icmp_table;
+	int i;
 	int err;
 
 	err = -ENOMEM;
@@ -210,22 +211,9 @@ static int __net_init ipv6_sysctl_net_init(struct net *net)
 			     GFP_KERNEL);
 	if (!ipv6_table)
 		goto out;
-	ipv6_table[0].data = &net->ipv6.sysctl.bindv6only;
-	ipv6_table[1].data = &net->ipv6.sysctl.anycast_src_echo_reply;
-	ipv6_table[2].data = &net->ipv6.sysctl.flowlabel_consistency;
-	ipv6_table[3].data = &net->ipv6.sysctl.auto_flowlabels;
-	ipv6_table[4].data = &net->ipv6.sysctl.fwmark_reflect;
-	ipv6_table[5].data = &net->ipv6.sysctl.idgen_retries;
-	ipv6_table[6].data = &net->ipv6.sysctl.idgen_delay;
-	ipv6_table[7].data = &net->ipv6.sysctl.flowlabel_state_ranges;
-	ipv6_table[8].data = &net->ipv6.sysctl.ip_nonlocal_bind;
-	ipv6_table[9].data = &net->ipv6.sysctl.flowlabel_reflect;
-	ipv6_table[10].data = &net->ipv6.sysctl.max_dst_opts_cnt;
-	ipv6_table[11].data = &net->ipv6.sysctl.max_hbh_opts_cnt;
-	ipv6_table[12].data = &net->ipv6.sysctl.max_dst_opts_len;
-	ipv6_table[13].data = &net->ipv6.sysctl.max_hbh_opts_len;
-	ipv6_table[14].data = &net->ipv6.sysctl.multipath_hash_policy,
-	ipv6_table[15].data = &net->ipv6.sysctl.seg6_flowlabel;
+	/* Update the variables to point into the current struct net */
+	for (i = 0; i < ARRAY_SIZE(ipv6_table_template) - 1; i++)
+		ipv6_table[i].data += (void *)net - (void *)&init_net;
 
 	ipv6_route_table = ipv6_route_sysctl_init(net);
 	if (!ipv6_route_table)
-- 
2.16.6

