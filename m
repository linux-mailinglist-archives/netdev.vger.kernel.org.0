Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A931EFA922
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbfKMEqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:46:51 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:41514 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbfKMEqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:46:51 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 8911C417F6;
        Wed, 13 Nov 2019 12:46:43 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, davem@davemloft.net
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] netfilter: flow_table_offload: Fix check ndo_setup_tc when setup_block
Date:   Wed, 13 Nov 2019 12:46:39 +0800
Message-Id: <1573620402-10318-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573620402-10318-1-git-send-email-wenxu@ucloud.cn>
References: <1573620402-10318-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJNS0tLSUpDSEJKT0lZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NRQ6Hzo6Hjg2LRQWGE4DHQ1R
        PzEKCkpVSlVKTkxITUlLT0tIQktMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpMTUo3Bg++
X-HM-Tid: 0a6e6315cd852086kuqy8911c417f6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

It should check the ndo_setup_tc in the nf_flow_table_offload_setup

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 9be61f47..1cc6671 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -722,6 +722,9 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	if (!(flowtable->flags & NF_FLOWTABLE_HW_OFFLOAD))
 		return 0;
 
+	if (!dev->netdev_ops->ndo_setup_tc)
+		return -EOPNOTSUPP;
+
 	bo.net		= dev_net(dev);
 	bo.block	= &flowtable->flow_block;
 	bo.command	= cmd;
-- 
1.8.3.1

