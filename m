Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413612D4D73
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388539AbgLIWTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:19:09 -0500
Received: from correo.us.es ([193.147.175.20]:32996 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388427AbgLIWTE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 17:19:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9D6D7D2DA1C
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 23:18:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F0DCDA8F3
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 23:18:10 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 847D5DA730; Wed,  9 Dec 2020 23:18:10 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A635DA704;
        Wed,  9 Dec 2020 23:18:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Dec 2020 23:18:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 27FE74265A5A;
        Wed,  9 Dec 2020 23:18:08 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/4] netfilter: nft_ct: Remove confirmation check for NFT_CT_ID
Date:   Wed,  9 Dec 2020 23:18:10 +0100
Message-Id: <20201209221810.32504-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201209221810.32504-1-pablo@netfilter.org>
References: <20201209221810.32504-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Mastbergen <brett.mastbergen@gmail.com>

Since commit 656c8e9cc1ba ("netfilter: conntrack: Use consistent ct id
hash calculation") the ct id will not change from initialization to
confirmation.  Removing the confirmation check allows for things like
adding an element to a 'typeof ct id' set in prerouting upon reception
of the first packet of a new connection, and then being able to
reference that set consistently both before and after the connection
is confirmed.

Fixes: 656c8e9cc1ba ("netfilter: conntrack: Use consistent ct id hash calculation")
Signed-off-by: Brett Mastbergen <brett.mastbergen@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 322bd674963e..a1b0aac46e9e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -177,8 +177,6 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	}
 #endif
 	case NFT_CT_ID:
-		if (!nf_ct_is_confirmed(ct))
-			goto err;
 		*dest = nf_ct_get_id(ct);
 		return;
 	default:
-- 
2.20.1

