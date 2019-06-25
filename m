Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66D2851F7B
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbfFYAMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:12:47 -0400
Received: from mail.us.es ([193.147.175.20]:38006 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729204AbfFYAMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 26E7CC04B6
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 170A3DA70B
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0C689DA709; Tue, 25 Jun 2019 02:12:45 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8FDCDA705;
        Tue, 25 Jun 2019 02:12:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 753C64265A2F;
        Tue, 25 Jun 2019 02:12:42 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/26] netfilter: ipset: fix a missing check of nla_parse
Date:   Tue, 25 Jun 2019 02:12:11 +0200
Message-Id: <20190625001233.22057-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

When nla_parse fails, we should not use the results (the first
argument). The fix checks if it fails, and if so, returns its error code
upstream.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 2ad609900b22..d0f4c627ff91 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1544,10 +1544,14 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
 		cmdattr = (void *)&errmsg->msg + min_len;
 
-		nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, cmdattr,
-				     nlh->nlmsg_len - min_len,
-				     ip_set_adt_policy, NULL);
+		ret = nla_parse_deprecated(cda, IPSET_ATTR_CMD_MAX, cmdattr,
+					   nlh->nlmsg_len - min_len,
+					   ip_set_adt_policy, NULL);
 
+		if (ret) {
+			nlmsg_free(skb2);
+			return ret;
+		}
 		errline = nla_data(cda[IPSET_ATTR_LINENO]);
 
 		*errline = lineno;
-- 
2.11.0

