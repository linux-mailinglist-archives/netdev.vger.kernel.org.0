Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 133B451FCB
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbfFYAMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:12:45 -0400
Received: from mail.us.es ([193.147.175.20]:37986 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729062AbfFYAMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EACFCC04AF
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DAF1FDA70A
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CFB1CDA702; Tue, 25 Jun 2019 02:12:42 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2862DA702;
        Tue, 25 Jun 2019 02:12:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 806084265A31;
        Tue, 25 Jun 2019 02:12:40 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/26] netfilter: ipv6: Fix undefined symbol nf_ct_frag6_gather
Date:   Tue, 25 Jun 2019 02:12:08 +0200
Message-Id: <20190625001233.22057-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

CONFIG_NETFILTER=m and CONFIG_NF_DEFRAG_IPV6 is not set

ERROR: "nf_ct_frag6_gather" [net/ipv6/ipv6.ko] undefined!

Fixes: c9bb6165a16e ("netfilter: nf_conntrack_bridge: fix CONFIG_IPV6=y")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index d9673e10c60c..86048dce301b 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -238,8 +238,10 @@ static const struct nf_ipv6_ops ipv6ops = {
 	.route_input		= ip6_route_input,
 	.fragment		= ip6_fragment,
 	.reroute		= nf_ip6_reroute,
-#if IS_MODULE(CONFIG_IPV6)
+#if IS_MODULE(CONFIG_IPV6) && IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	.br_defrag		= nf_ct_frag6_gather,
+#endif
+#if IS_MODULE(CONFIG_IPV6)
 	.br_fragment		= br_ip6_fragment,
 #endif
 };
-- 
2.11.0

