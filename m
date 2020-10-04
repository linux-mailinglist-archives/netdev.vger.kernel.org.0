Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A968282D65
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 21:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgJDTuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 15:50:20 -0400
Received: from correo.us.es ([193.147.175.20]:34954 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbgJDTuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 15:50:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 91B63EF436
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 21:50:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81AA5DA78C
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 21:50:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 80C86DA789; Sun,  4 Oct 2020 21:50:12 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34CEDDA722;
        Sun,  4 Oct 2020 21:50:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 04 Oct 2020 21:50:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 0BC9942EF9E2;
        Sun,  4 Oct 2020 21:50:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 08/11] netfilter: ipset: enable memory accounting for ipset allocations
Date:   Sun,  4 Oct 2020 21:49:37 +0200
Message-Id: <20201004194940.7368-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201004194940.7368-1-pablo@netfilter.org>
References: <20201004194940.7368-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

Currently netadmin inside non-trusted container can quickly allocate
whole node's memory via request of huge ipset hashtable.
Other ipset-related memory allocations should be restricted too.

v2: fixed typo ALLOC -> ACCOUNT

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 920b7c4331f0..6f35832f0de3 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -250,22 +250,7 @@ EXPORT_SYMBOL_GPL(ip_set_type_unregister);
 void *
 ip_set_alloc(size_t size)
 {
-	void *members = NULL;
-
-	if (size < KMALLOC_MAX_SIZE)
-		members = kzalloc(size, GFP_KERNEL | __GFP_NOWARN);
-
-	if (members) {
-		pr_debug("%p: allocated with kmalloc\n", members);
-		return members;
-	}
-
-	members = vzalloc(size);
-	if (!members)
-		return NULL;
-	pr_debug("%p: allocated with vmalloc\n", members);
-
-	return members;
+	return kvzalloc(size, GFP_KERNEL_ACCOUNT);
 }
 EXPORT_SYMBOL_GPL(ip_set_alloc);
 
-- 
2.20.1

