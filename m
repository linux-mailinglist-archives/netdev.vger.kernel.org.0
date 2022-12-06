Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE897643DC2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 08:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiLFHpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 02:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiLFHpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 02:45:30 -0500
Received: from mail.nfschina.com (unknown [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BBEA11C14;
        Mon,  5 Dec 2022 23:45:28 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 9B1DB1E80D0E;
        Tue,  6 Dec 2022 15:41:10 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 67sWBfMGm1OG; Tue,  6 Dec 2022 15:41:08 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 64DCD1E80D57;
        Tue,  6 Dec 2022 15:41:07 +0800 (CST)
From:   Li Qiong <liqiong@nfschina.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        coreteam@netfilter.org, Yu Zhe <yuzhe@nfschina.com>,
        Li Qiong <liqiong@nfschina.com>
Subject: [PATCH v2] netfilter: add a 'default' case to 'switch (tuplehash->tuple.xmit_type)'
Date:   Tue,  6 Dec 2022 15:44:14 +0800
Message-Id: <20221206074414.12208-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20221202070331.10865-1-liqiong@nfschina.com>
References: <20221202070331.10865-1-liqiong@nfschina.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a 'default' case in case return a uninitialized value of ret.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
---
v2: Add 'default' case instead of initializing 'ret'.
---
 net/netfilter/nf_flow_table_ip.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index b350fe9d00b0..19efba1e51ef 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -421,6 +421,10 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		if (ret == NF_DROP)
 			flow_offload_teardown(flow);
 		break;
+	default:
+		WARN_ON_ONCE(1);
+		ret = NF_DROP;
+		break;
 	}
 
 	return ret;
@@ -682,6 +686,10 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		if (ret == NF_DROP)
 			flow_offload_teardown(flow);
 		break;
+	default:
+		WARN_ON_ONCE(1);
+		ret = NF_DROP;
+		break;
 	}
 
 	return ret;
-- 
2.11.0

