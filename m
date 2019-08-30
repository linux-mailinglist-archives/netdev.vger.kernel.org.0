Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF5D8A3646
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbfH3MHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:07:15 -0400
Received: from correo.us.es ([193.147.175.20]:36270 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728062AbfH3MHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:07:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F119AD2CB5
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:07:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD4D9D1929
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:07:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DACE9D1DBB; Fri, 30 Aug 2019 14:07:10 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EDD8FF6CC;
        Fri, 30 Aug 2019 14:07:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 30 Aug 2019 14:07:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 643414251481;
        Fri, 30 Aug 2019 14:07:08 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/5] netfilter: xt_physdev: Fix spurious error message in physdev_mt_check
Date:   Fri, 30 Aug 2019 14:07:00 +0200
Message-Id: <20190830120704.6147-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190830120704.6147-1-pablo@netfilter.org>
References: <20190830120704.6147-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Todd Seidelmann <tseidelmann@linode.com>

Simplify the check in physdev_mt_check() to emit an error message
only when passed an invalid chain (ie, NF_INET_LOCAL_OUT).
This avoids cluttering up the log with errors against valid rules.

For large/heavily modified rulesets, current behavior can quickly
overwhelm the ring buffer, because this function gets called on
every change, regardless of the rule that was changed.

Signed-off-by: Todd Seidelmann <tseidelmann@linode.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_physdev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index ead7c6022208..b92b22ce8abd 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -101,11 +101,9 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 	if (info->bitmask & (XT_PHYSDEV_OP_OUT | XT_PHYSDEV_OP_ISOUT) &&
 	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
 	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
-	    par->hook_mask & ((1 << NF_INET_LOCAL_OUT) |
-	    (1 << NF_INET_FORWARD) | (1 << NF_INET_POST_ROUTING))) {
+	    par->hook_mask & (1 << NF_INET_LOCAL_OUT)) {
 		pr_info_ratelimited("--physdev-out and --physdev-is-out only supported in the FORWARD and POSTROUTING chains with bridged traffic\n");
-		if (par->hook_mask & (1 << NF_INET_LOCAL_OUT))
-			return -EINVAL;
+		return -EINVAL;
 	}
 
 	if (!brnf_probed) {
-- 
2.11.0

