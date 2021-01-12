Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36AA12F3F75
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404873AbhALWVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 17:21:40 -0500
Received: from correo.us.es ([193.147.175.20]:49916 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404829AbhALWV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 17:21:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 72495D28D1
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 23:20:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63505DA78F
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 23:20:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 58B5EDA78B; Tue, 12 Jan 2021 23:20:01 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C816ADA72F;
        Tue, 12 Jan 2021 23:19:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Jan 2021 23:19:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.lan (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 846FF42EF528;
        Tue, 12 Jan 2021 23:19:58 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/3] netfilter: nf_nat: Fix memleak in nf_nat_init
Date:   Tue, 12 Jan 2021 23:20:33 +0100
Message-Id: <20210112222033.9732-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210112222033.9732-1-pablo@netfilter.org>
References: <20210112222033.9732-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

When register_pernet_subsys() fails, nf_nat_bysource
should be freed just like when nf_ct_extend_register()
fails.

Fixes: 1cd472bf036ca ("netfilter: nf_nat: add nat hook register functions to nf_nat")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index ea923f8cf9c4..b7c3c902290f 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1174,6 +1174,7 @@ static int __init nf_nat_init(void)
 	ret = register_pernet_subsys(&nat_net_ops);
 	if (ret < 0) {
 		nf_ct_extend_unregister(&nat_extend);
+		kvfree(nf_nat_bysource);
 		return ret;
 	}
 
-- 
2.20.1

