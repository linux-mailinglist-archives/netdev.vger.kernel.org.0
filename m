Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CF7A9268
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731577AbfIDThA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 15:37:00 -0400
Received: from correo.us.es ([193.147.175.20]:37902 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731596AbfIDTg7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 15:36:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D38BB303D06
        for <netdev@vger.kernel.org>; Wed,  4 Sep 2019 21:36:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C69CBDA4CA
        for <netdev@vger.kernel.org>; Wed,  4 Sep 2019 21:36:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BC451DA801; Wed,  4 Sep 2019 21:36:55 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B602CB8001;
        Wed,  4 Sep 2019 21:36:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Sep 2019 21:36:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 871624265A5A;
        Wed,  4 Sep 2019 21:36:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/5] netfilter: ctnetlink: honor IPS_OFFLOAD flag
Date:   Wed,  4 Sep 2019 21:36:45 +0200
Message-Id: <20190904193646.23830-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190904193646.23830-1-pablo@netfilter.org>
References: <20190904193646.23830-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If this flag is set, timeout and state are irrelevant to userspace.

Fixes: 90964016e5d3 ("netfilter: nf_conntrack: add IPS_OFFLOAD status bit")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6aa01eb6fe99..e2d13cd18875 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -553,10 +553,8 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 		goto nla_put_failure;
 
 	if (ctnetlink_dump_status(skb, ct) < 0 ||
-	    ctnetlink_dump_timeout(skb, ct) < 0 ||
 	    ctnetlink_dump_acct(skb, ct, type) < 0 ||
 	    ctnetlink_dump_timestamp(skb, ct) < 0 ||
-	    ctnetlink_dump_protoinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_secctx(skb, ct) < 0 ||
@@ -568,6 +566,11 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	    ctnetlink_dump_ct_synproxy(skb, ct) < 0)
 		goto nla_put_failure;
 
+	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
+	    (ctnetlink_dump_timeout(skb, ct) < 0 ||
+	     ctnetlink_dump_protoinfo(skb, ct) < 0))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return skb->len;
 
-- 
2.11.0

