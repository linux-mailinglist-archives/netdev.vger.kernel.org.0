Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF0C649396
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 11:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiLKKM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 05:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLKKMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 05:12:16 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CAC9CE08;
        Sun, 11 Dec 2022 02:12:16 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 06/12] netfilter: flowtable: add a 'default' case to flowtable datapath
Date:   Sun, 11 Dec 2022 11:11:58 +0100
Message-Id: <20221211101204.1751-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221211101204.1751-1-pablo@netfilter.org>
References: <20221211101204.1751-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li Qiong <liqiong@nfschina.com>

Add a 'default' case in case return a uninitialized value of ret, this
should not ever happen since the follow transmit path types:

- FLOW_OFFLOAD_XMIT_UNSPEC
- FLOW_OFFLOAD_XMIT_TC

are never observed from this path. Add this check for safety reasons.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

