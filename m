Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7C332065
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 20:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfFASYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 14:24:08 -0400
Received: from mail.us.es ([193.147.175.20]:40028 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbfFASYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 14:24:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C2C18B60F2
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D698DA701
        for <netdev@vger.kernel.org>; Sat,  1 Jun 2019 20:24:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 441B4FF150; Sat,  1 Jun 2019 20:23:53 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDD41DA712;
        Sat,  1 Jun 2019 20:23:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 20:23:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.178.197])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 64D6A4265A32;
        Sat,  1 Jun 2019 20:23:50 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/15] netfilter: xt_owner: Add supplementary groups option
Date:   Sat,  1 Jun 2019 20:23:29 +0200
Message-Id: <20190601182340.2662-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601182340.2662-1-pablo@netfilter.org>
References: <20190601182340.2662-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>

The XT_OWNER_SUPPL_GROUPS flag causes GIDs specified with XT_OWNER_GID
to be also checked in the supplementary groups of a process.

f_cred->group_info cannot be modified during its lifetime and f_cred
holds a reference to it so it's safe to use.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/xt_owner.h |  7 ++++---
 net/netfilter/xt_owner.c                | 23 ++++++++++++++++++++---
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_owner.h b/include/uapi/linux/netfilter/xt_owner.h
index fa3ad84957d5..9e98c09eda32 100644
--- a/include/uapi/linux/netfilter/xt_owner.h
+++ b/include/uapi/linux/netfilter/xt_owner.h
@@ -5,9 +5,10 @@
 #include <linux/types.h>
 
 enum {
-	XT_OWNER_UID    = 1 << 0,
-	XT_OWNER_GID    = 1 << 1,
-	XT_OWNER_SOCKET = 1 << 2,
+	XT_OWNER_UID          = 1 << 0,
+	XT_OWNER_GID          = 1 << 1,
+	XT_OWNER_SOCKET       = 1 << 2,
+	XT_OWNER_SUPPL_GROUPS = 1 << 3,
 };
 
 struct xt_owner_match_info {
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 46686fb73784..a8784502aca6 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -91,11 +91,28 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	if (info->match & XT_OWNER_GID) {
+		unsigned int i, match = false;
 		kgid_t gid_min = make_kgid(net->user_ns, info->gid_min);
 		kgid_t gid_max = make_kgid(net->user_ns, info->gid_max);
-		if ((gid_gte(filp->f_cred->fsgid, gid_min) &&
-		     gid_lte(filp->f_cred->fsgid, gid_max)) ^
-		    !(info->invert & XT_OWNER_GID))
+		struct group_info *gi = filp->f_cred->group_info;
+
+		if (gid_gte(filp->f_cred->fsgid, gid_min) &&
+		    gid_lte(filp->f_cred->fsgid, gid_max))
+			match = true;
+
+		if (!match && (info->match & XT_OWNER_SUPPL_GROUPS) && gi) {
+			for (i = 0; i < gi->ngroups; ++i) {
+				kgid_t group = gi->gid[i];
+
+				if (gid_gte(group, gid_min) &&
+				    gid_lte(group, gid_max)) {
+					match = true;
+					break;
+				}
+			}
+		}
+
+		if (match ^ !(info->invert & XT_OWNER_GID))
 			return false;
 	}
 
-- 
2.11.0

