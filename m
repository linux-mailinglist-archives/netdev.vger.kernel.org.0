Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0117651F79
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbfFYAMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:12:45 -0400
Received: from mail.us.es ([193.147.175.20]:37994 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729189AbfFYAMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 20:12:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 81FCCC04B0
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71AD5DA704
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:12:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 670ACDA707; Tue, 25 Jun 2019 02:12:43 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B391DA704;
        Tue, 25 Jun 2019 02:12:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:12:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 400054265A31;
        Tue, 25 Jun 2019 02:12:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 02/26] netfilter: ipset: remove useless memset() calls
Date:   Tue, 25 Jun 2019 02:12:09 +0200
Message-Id: <20190625001233.22057-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190625001233.22057-1-pablo@netfilter.org>
References: <20190625001233.22057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florent Fourcot <florent.fourcot@wifirst.fr>

One of the memset call is buggy: it does not erase full array, but only pointer size.
Moreover, after a check, first step of nla_parse_nested/nla_parse is to
erase tb array as well. We can remove both calls safely.

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 3f4a4936f63c..faddcf398b73 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1599,7 +1599,6 @@ static int ip_set_uadd(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 		int nla_rem;
 
 		nla_for_each_nested(nla, attr[IPSET_ATTR_ADT], nla_rem) {
-			memset(tb, 0, sizeof(tb));
 			if (nla_type(nla) != IPSET_ATTR_DATA ||
 			    !flag_nested(nla) ||
 			    nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, nla, set->type->adt_policy, NULL))
@@ -1651,7 +1650,6 @@ static int ip_set_udel(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 		int nla_rem;
 
 		nla_for_each_nested(nla, attr[IPSET_ATTR_ADT], nla_rem) {
-			memset(tb, 0, sizeof(*tb));
 			if (nla_type(nla) != IPSET_ATTR_DATA ||
 			    !flag_nested(nla) ||
 			    nla_parse_nested_deprecated(tb, IPSET_ATTR_ADT_MAX, nla, set->type->adt_policy, NULL))
-- 
2.11.0

