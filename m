Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C720613F9EC
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730959AbgAPTvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:51:03 -0500
Received: from correo.us.es ([193.147.175.20]:56036 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730964AbgAPTu4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 14:50:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 19516807F6
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:50:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D78CDA71A
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:50:55 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 02C09DA710; Thu, 16 Jan 2020 20:50:55 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05CA0DA710;
        Thu, 16 Jan 2020 20:50:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 20:50:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D13E842EF9E1;
        Thu, 16 Jan 2020 20:50:52 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 7/9] netfilter: nf_tables: fix memory leak in nf_tables_parse_netdev_hooks()
Date:   Thu, 16 Jan 2020 20:50:42 +0100
Message-Id: <20200116195044.326614-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200116195044.326614-1-pablo@netfilter.org>
References: <20200116195044.326614-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

Syzbot detected a leak in nf_tables_parse_netdev_hooks().  If the hook
already exists, then the error handling doesn't free the newest "hook".

Reported-by: syzbot+f9d4095107fc8749c69c@syzkaller.appspotmail.com
Fixes: b75a3e8371bc ("netfilter: nf_tables: allow netdevice to be used only once per flowtable")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b3692458d428..896a6e8aff91 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1680,6 +1680,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
 			goto err_hook;
 		}
 		if (nft_hook_list_find(hook_list, hook)) {
+			kfree(hook);
 			err = -EEXIST;
 			goto err_hook;
 		}
-- 
2.11.0

