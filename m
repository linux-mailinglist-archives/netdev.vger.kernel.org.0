Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA24B30B33
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 11:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfEaJPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 05:15:43 -0400
Received: from mail.us.es ([193.147.175.20]:34474 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbfEaJPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 05:15:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 54DE610FB07
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 11:15:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 43AA4DA717
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 11:15:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 38E86DA70F; Fri, 31 May 2019 11:15:41 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3685DA707;
        Fri, 31 May 2019 11:15:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 11:15:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A6D4D4265A32;
        Fri, 31 May 2019 11:15:38 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sfr@canb.auug.org.au,
        yuehaibing@huawei.com, lkp@intel.com, wenxu@ucloud.cn
Subject: [PATCH net-next,v2] netfilter: nf_conntrack_bridge: fix CONFIG_IPV6=y
Date:   Fri, 31 May 2019 11:15:26 +0200
Message-Id: <20190531091526.1671-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a few problems with CONFIG_IPV6=y and
CONFIG_NF_CONNTRACK_BRIDGE=m:

In file included from net/netfilter/utils.c:5:
include/linux/netfilter_ipv6.h: In function 'nf_ipv6_br_defrag':
include/linux/netfilter_ipv6.h:110:9: error: implicit declaration of function 'nf_ct_frag6_gather'; did you mean 'nf_ct_attach'? [-Werror=implicit-function-declaration]

And these too:

net/ipv6/netfilter.c:242:2: error: unknown field 'br_defrag' specified in initializer
net/ipv6/netfilter.c:243:2: error: unknown field 'br_fragment' specified in initializer

This patch includes an original chunk from wenxu.

Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Yuehaibing <yuehaibing@huawei.com>
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Forgot to include "net-next" and added Reported-by to all people that have
    reported problems.

 include/linux/netfilter_ipv6.h | 2 ++
 net/ipv6/netfilter.c           | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index a21b8c9623ee..3a3dc4b1f0e7 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -96,6 +96,8 @@ static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
 #endif
 }
 
+#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
+
 static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
 				    u32 user)
 {
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index c6665382acb5..9530cc280953 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -238,7 +238,7 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
 	.reroute		= nf_ip6_reroute,
-#if IS_MODULE(CONFIG_NF_CONNTRACK_BRIDGE)
+#if IS_MODULE(CONFIG_IPV6)
 	.br_defrag		= nf_ct_frag6_gather,
 	.br_fragment		= br_ip6_fragment,
 #endif
-- 
2.11.0

