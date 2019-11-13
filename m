Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92E4FFA924
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfKMEqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:46:51 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:41536 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbfKMEqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:46:50 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 05537418E8;
        Wed, 13 Nov 2019 12:46:44 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, davem@davemloft.net
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 3/4] netfilter: nf_tables: Fix check the err for FLOW_BLOCK_BIND setup call
Date:   Wed, 13 Nov 2019 12:46:41 +0800
Message-Id: <1573620402-10318-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573620402-10318-1-git-send-email-wenxu@ucloud.cn>
References: <1573620402-10318-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlNS0tLSkNCTENKSkJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Phg6DBw6Ezg*ORROCE8uHRcu
        PUkKChdVSlVKTkxITUlLT0tPSkpPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpDSU83Bg++
X-HM-Tid: 0a6e6315cf472086kuqy05537418e8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_tables_api.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2dc636f..0a00812 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5995,8 +5995,12 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			}
 		}
 
-		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
-					    FLOW_BLOCK_BIND);
+		err = flowtable->data.type->setup(&flowtable->data,
+						  hook->ops.dev,
+						  FLOW_BLOCK_BIND);
+		if (err < 0)
+			goto err_unregister_net_hooks;
+
 		err = nf_register_net_hook(net, &hook->ops);
 		if (err < 0)
 			goto err_unregister_net_hooks;
-- 
1.8.3.1

