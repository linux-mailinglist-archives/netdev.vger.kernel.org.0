Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD4C2D4D74
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388521AbgLIWTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:19:09 -0500
Received: from correo.us.es ([193.147.175.20]:32982 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388419AbgLIWTE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 17:19:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1E784D2DA13
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 23:18:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E1A1DA8F6
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 23:18:10 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0387DDA722; Wed,  9 Dec 2020 23:18:10 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6419DA73F;
        Wed,  9 Dec 2020 23:18:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Dec 2020 23:18:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id A9D734265A5A;
        Wed,  9 Dec 2020 23:18:07 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/4] netfilter: nftables: comment indirect serialization of commit_mutex with rtnl_mutex
Date:   Wed,  9 Dec 2020 23:18:09 +0100
Message-Id: <20201209221810.32504-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201209221810.32504-1-pablo@netfilter.org>
References: <20201209221810.32504-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an explicit comment in the code to describe the indirect
serialization of the holders of the commit_mutex with the rtnl_mutex.
Commit 90d2723c6d4c ("netfilter: nf_tables: do not hold reference on
netdevice from preparation phase") already describes this, but a comment
in this case is better for reference.

Reported-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c2f59879a48d..9a080767667b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1723,6 +1723,10 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	}
 
 	nla_strlcpy(ifname, attr, IFNAMSIZ);
+	/* nf_tables_netdev_event() is called under rtnl_mutex, this is
+	 * indirectly serializing all the other holders of the commit_mutex with
+	 * the rtnl_mutex.
+	 */
 	dev = __dev_get_by_name(net, ifname);
 	if (!dev) {
 		err = -ENOENT;
-- 
2.20.1

