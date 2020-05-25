Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33F21E1779
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 23:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388880AbgEYVyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 17:54:38 -0400
Received: from correo.us.es ([193.147.175.20]:47316 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389345AbgEYVyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 17:54:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 07838FB479
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 23:54:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EC901DA707
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 23:54:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CD6E6DA705; Mon, 25 May 2020 23:54:29 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BE3FDA711;
        Mon, 25 May 2020 23:54:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 May 2020 23:54:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 03D4942EE38F;
        Mon, 25 May 2020 23:54:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 5/5] netfilter: nfnetlink_cthelper: unbreak userspace helper support
Date:   Mon, 25 May 2020 23:54:20 +0200
Message-Id: <20200525215420.2290-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200525215420.2290-1-pablo@netfilter.org>
References: <20200525215420.2290-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Restore helper data size initialization and fix memcopy of the helper
data size.

Fixes: 157ffffeb5dc ("netfilter: nfnetlink_cthelper: reject too large userspace allocation requests")
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cthelper.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index a5f294aa8e4c..5b0d0a77379c 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -103,7 +103,7 @@ nfnl_cthelper_from_nlattr(struct nlattr *attr, struct nf_conn *ct)
 	if (help->helper->data_len == 0)
 		return -EINVAL;
 
-	nla_memcpy(help->data, nla_data(attr), sizeof(help->data));
+	nla_memcpy(help->data, attr, sizeof(help->data));
 	return 0;
 }
 
@@ -240,6 +240,7 @@ nfnl_cthelper_create(const struct nlattr * const tb[],
 		ret = -ENOMEM;
 		goto err2;
 	}
+	helper->data_len = size;
 
 	helper->flags |= NF_CT_HELPER_F_USERSPACE;
 	memcpy(&helper->tuple, tuple, sizeof(struct nf_conntrack_tuple));
-- 
2.20.1

