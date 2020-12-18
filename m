Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8CA2DE24E
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 13:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgLRMFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 07:05:05 -0500
Received: from correo.us.es ([193.147.175.20]:51962 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgLRMFB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 07:05:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E987AEB47C
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 13:04:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB673DA844
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 13:04:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D10FDDA853; Fri, 18 Dec 2020 13:04:00 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A621ADA84B;
        Fri, 18 Dec 2020 13:03:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 18 Dec 2020 13:03:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7620E42DF562;
        Fri, 18 Dec 2020 13:03:58 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/4] netfilter: ipset: fixes possible oops in mtype_resize
Date:   Fri, 18 Dec 2020 13:04:08 +0100
Message-Id: <20201218120409.3659-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201218120409.3659-1-pablo@netfilter.org>
References: <20201218120409.3659-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

currently mtype_resize() can cause oops

        t = ip_set_alloc(htable_size(htable_bits));
        if (!t) {
                ret = -ENOMEM;
                goto out;
        }
        t->hregion = ip_set_alloc(ahash_sizeof_regions(htable_bits));

Increased htable_bits can force htable_size() to return 0.
In own turn ip_set_alloc(0) returns not 0 but ZERO_SIZE_PTR,
so follwoing access to t->hregion should trigger an OOPS.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 5f1208ad049e..1e7dddf824ae 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -640,7 +640,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	struct htype *h = set->data;
 	struct htable *t, *orig;
 	u8 htable_bits;
-	size_t dsize = set->dsize;
+	size_t hsize, dsize = set->dsize;
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 flags;
 	struct mtype_elem *tmp;
@@ -664,14 +664,12 @@ mtype_resize(struct ip_set *set, bool retried)
 retry:
 	ret = 0;
 	htable_bits++;
-	if (!htable_bits) {
-		/* In case we have plenty of memory :-) */
-		pr_warn("Cannot increase the hashsize of set %s further\n",
-			set->name);
-		ret = -IPSET_ERR_HASH_FULL;
-		goto out;
-	}
-	t = ip_set_alloc(htable_size(htable_bits));
+	if (!htable_bits)
+		goto hbwarn;
+	hsize = htable_size(htable_bits);
+	if (!hsize)
+		goto hbwarn;
+	t = ip_set_alloc(hsize);
 	if (!t) {
 		ret = -ENOMEM;
 		goto out;
@@ -813,6 +811,12 @@ mtype_resize(struct ip_set *set, bool retried)
 	if (ret == -EAGAIN)
 		goto retry;
 	goto out;
+
+hbwarn:
+	/* In case we have plenty of memory :-) */
+	pr_warn("Cannot increase the hashsize of set %s further\n", set->name);
+	ret = -IPSET_ERR_HASH_FULL;
+	goto out;
 }
 
 /* Get the current number of elements and ext_size in the set  */
-- 
2.20.1

