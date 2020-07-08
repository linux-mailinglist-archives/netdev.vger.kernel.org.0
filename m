Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E67218EBF
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgGHRqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:46:25 -0400
Received: from correo.us.es ([193.147.175.20]:34738 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbgGHRqX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:46:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 983173066AC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86CA6DA844
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 79B4DDA7B6; Wed,  8 Jul 2020 19:46:21 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 381B1DA73F;
        Wed,  8 Jul 2020 19:46:19 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jul 2020 19:46:19 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 007BB4265A2F;
        Wed,  8 Jul 2020 19:46:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 02/12] netfilter: nft_set_pipapo: Drop useless assignment of scratch  map index on insert
Date:   Wed,  8 Jul 2020 19:45:59 +0200
Message-Id: <20200708174609.1343-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200708174609.1343-1-pablo@netfilter.org>
References: <20200708174609.1343-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

In nft_pipapo_insert(), we need to reallocate scratch maps that will
be used for matching by lookup functions, if they have never been
allocated or if the bucket size changes as a result of the insertion.

As pipapo_realloc_scratch() provides a pair of fresh, zeroed out
maps, there's no need to select a particular one after reallocation.

Other than being useless, the existing assignment was also troubled
by the fact that the index was set only on the CPU performing the
actual insertion, as spotted by Florian.

Simply drop the assignment.

Reported-by: Florian Westphal <fw@strlen.de>
Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 8c04388296b0..313de1d73168 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1249,8 +1249,6 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 		if (err)
 			return err;
 
-		this_cpu_write(nft_pipapo_scratch_index, false);
-
 		m->bsize_max = bsize_max;
 	} else {
 		put_cpu_ptr(m->scratch);
-- 
2.20.1

