Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC5D4BF2AC
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 08:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiBVHdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 02:33:46 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiBVHdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 02:33:44 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC0EED3AD8;
        Mon, 21 Feb 2022 23:33:17 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2592B64387;
        Tue, 22 Feb 2022 08:32:18 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/5] netfilter: xt_socket: missing ifdef CONFIG_IP6_NF_IPTABLES dependency
Date:   Tue, 22 Feb 2022 08:33:08 +0100
Message-Id: <20220222073312.308406-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222073312.308406-1-pablo@netfilter.org>
References: <20220222073312.308406-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nf_defrag_ipv6_disable() requires CONFIG_IP6_NF_IPTABLES.

Fixes: 75063c9294fb ("netfilter: xt_socket: fix a typo in socket_mt_destroy()")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Eric Dumazet<edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_socket.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 662e5eb1cc39..7013f55f05d1 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -220,8 +220,10 @@ static void socket_mt_destroy(const struct xt_mtdtor_param *par)
 {
 	if (par->family == NFPROTO_IPV4)
 		nf_defrag_ipv4_disable(par->net);
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	else if (par->family == NFPROTO_IPV6)
 		nf_defrag_ipv6_disable(par->net);
+#endif
 }
 
 static struct xt_match socket_mt_reg[] __read_mostly = {
-- 
2.30.2

