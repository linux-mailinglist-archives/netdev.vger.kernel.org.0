Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB7464B6ED
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 15:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbiLMOK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 09:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbiLMOJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 09:09:58 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D732F21268;
        Tue, 13 Dec 2022 06:09:31 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 2/3] ipvs: add a 'default' case in do_ip_vs_set_ctl()
Date:   Tue, 13 Dec 2022 15:09:22 +0100
Message-Id: <20221213140923.154594-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221213140923.154594-1-pablo@netfilter.org>
References: <20221213140923.154594-1-pablo@netfilter.org>
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

It is better to return the default switch case with
'-EINVAL', in case new commands are added. otherwise,
return a uninitialized value of ret.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
Reviewed-by: Simon Horman <horms@verge.net.au>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 988222fff9f0..97f6a1c8933a 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2590,6 +2590,11 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, sockptr_t ptr, unsigned int len)
 		break;
 	case IP_VS_SO_SET_DELDEST:
 		ret = ip_vs_del_dest(svc, &udest);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		ret = -EINVAL;
+		break;
 	}
 
   out_unlock:
-- 
2.30.2

