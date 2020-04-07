Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5041A182A
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 00:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgDGW3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 18:29:54 -0400
Received: from correo.us.es ([193.147.175.20]:53164 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgDGW3r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Apr 2020 18:29:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C4F16F2DF0
        for <netdev@vger.kernel.org>; Wed,  8 Apr 2020 00:29:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B82E920C64
        for <netdev@vger.kernel.org>; Wed,  8 Apr 2020 00:29:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AD3B3FA525; Wed,  8 Apr 2020 00:29:44 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3CFC4EA8F;
        Wed,  8 Apr 2020 00:29:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Apr 2020 00:29:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A78874251480;
        Wed,  8 Apr 2020 00:29:42 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 5/7] netfilter: ipset: Pass lockdep expression to RCU lists
Date:   Wed,  8 Apr 2020 00:29:34 +0200
Message-Id: <20200407222936.206295-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200407222936.206295-1-pablo@netfilter.org>
References: <20200407222936.206295-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amol Grover <frextrite@gmail.com>

ip_set_type_list is traversed using list_for_each_entry_rcu
outside an RCU read-side critical section but under the protection
of ip_set_type_mutex.

Hence, add corresponding lockdep expression to silence false-positive
warnings, and harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 8dd17589217d..340cb955af25 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -86,7 +86,8 @@ find_set_type(const char *name, u8 family, u8 revision)
 {
 	struct ip_set_type *type;
 
-	list_for_each_entry_rcu(type, &ip_set_type_list, list)
+	list_for_each_entry_rcu(type, &ip_set_type_list, list,
+				lockdep_is_held(&ip_set_type_mutex))
 		if (STRNCMP(type->name, name) &&
 		    (type->family == family ||
 		     type->family == NFPROTO_UNSPEC) &&
-- 
2.11.0

